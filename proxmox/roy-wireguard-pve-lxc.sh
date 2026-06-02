#!/usr/bin/env bash
set -Eeuo pipefail

# Roy / Hermes WireGuard LXC installer for Proxmox VE
# - Uses the official Community-Scripts WireGuard LXC creator as base
# - Creates a small unprivileged Debian 13 LXC with /dev/net/tun enabled
# - Optionally installs WGDashboard (recommended only on internal/VPN access)
# - Generates wg0.conf and one client config
#
# Run on the Proxmox VE host as root:
#   bash roy-wireguard-pve-lxc.sh

COMMUNITY_WG_SCRIPT_URL="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/wireguard.sh"
COMMUNITY_WG_SCRIPT_SHA256="" # optional pin; leave empty to track upstream

WG_NETWORK_DEFAULT="10.99.0.0/24"
WG_SERVER_DEFAULT="10.99.0.1/24"
WG_CLIENT_DEFAULT="10.99.0.2/32"
WG_PORT_DEFAULT="51820"
LAN_ALLOWED_DEFAULT="10.10.10.0/24"
HOSTNAME_DEFAULT="wireguard"
BRIDGE_DEFAULT="vmbr1"
RAM_DEFAULT="512"
CPU_DEFAULT="1"
DISK_DEFAULT="4"

log() { printf '\033[1;32m[OK]\033[0m %s\n' "$*"; }
info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m[ERR]\033[0m %s\n' "$*" >&2; }

need_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    err "Bitte als root auf dem Proxmox-Host ausführen."
    exit 1
  fi
}

need_pve() {
  if ! command -v pct >/dev/null 2>&1 || ! command -v pveversion >/dev/null 2>&1; then
    err "Das sieht nicht wie ein Proxmox-VE-Host aus: pct/pveversion fehlt."
    exit 1
  fi
}

prompt() {
  local name="$1" text="$2" def="$3" value
  read -r -p "$text [$def]: " value || true
  value="${value:-$def}"
  printf -v "$name" '%s' "$value"
}

prompt_yes_no() {
  local name="$1" text="$2" def="$3" value
  read -r -p "$text [$def]: " value || true
  value="${value:-$def}"
  case "${value,,}" in
    y|yes|j|ja|true|1) printf -v "$name" '%s' "yes" ;;
    *) printf -v "$name" '%s' "no" ;;
  esac
}

get_nextid() {
  pvesh get /cluster/nextid 2>/dev/null || echo 200
}

sanitize_file_name() {
  tr -c 'A-Za-z0-9_.-' '_' <<<"$1"
}

fetch_community_script() {
  local dst="$1"
  info "Lade Community-Scripts WireGuard Script..."
  curl -fsSL "$COMMUNITY_WG_SCRIPT_URL" -o "$dst"
  chmod 0700 "$dst"
  if [[ -n "$COMMUNITY_WG_SCRIPT_SHA256" ]]; then
    local actual
    actual="$(sha256sum "$dst" | awk '{print $1}')"
    if [[ "$actual" != "$COMMUNITY_WG_SCRIPT_SHA256" ]]; then
      err "SHA256 stimmt nicht. Erwartet: $COMMUNITY_WG_SCRIPT_SHA256, Ist: $actual"
      exit 1
    fi
  fi
  log "Community Script geladen: $dst"
}

find_ctid_by_hostname() {
  local hn="$1"
  pct list | awk -v hn="$hn" 'NR>1 && $3==hn {print $1; exit}'
}

wait_for_ct() {
  local ctid="$1"
  info "Warte auf LXC $ctid..."
  for _ in $(seq 1 60); do
    if pct status "$ctid" 2>/dev/null | grep -q 'status: running'; then
      if pct exec "$ctid" -- true 2>/dev/null; then
        log "LXC $ctid läuft."
        return 0
      fi
    fi
    sleep 2
  done
  err "LXC $ctid wurde nicht rechtzeitig erreichbar."
  exit 1
}

ct_exec() {
  local ctid="$1"; shift
  pct exec "$ctid" -- bash -lc "$*"
}

configure_wireguard_inside_ct() {
  local ctid="$1" endpoint="$2" port="$3" server_addr="$4" client_addr="$5" allowed_lans="$6" client_name="$7"
  local tmp="/tmp/wg-configure-${ctid}.sh"
  cat >"$tmp" <<'CTSCRIPT'
#!/usr/bin/env bash
set -Eeuo pipefail
endpoint="$1"
port="$2"
server_addr="$3"
client_addr="$4"
allowed_lans="$5"
client_name="$6"

install -d -m 0700 /etc/wireguard /root/wireguard-clients
chmod 0700 /root/wireguard-clients

# Enable forwarding inside the WireGuard LXC
cat >/etc/sysctl.d/99-wireguard-forward.conf <<EOF
net.ipv4.ip_forward=1
EOF
sysctl -p /etc/sysctl.d/99-wireguard-forward.conf >/dev/null

server_private="$(wg genkey)"
server_public="$(printf '%s' "$server_private" | wg pubkey)"
client_private="$(wg genkey)"
client_public="$(printf '%s' "$client_private" | wg pubkey)"
client_psk="$(wg genpsk)"

# Determine egress interface for NAT from LXC to LAN
wan_if="$(ip route show default 2>/dev/null | awk '{print $5; exit}')"
wan_if="${wan_if:-eth0}"
server_ip_no_cidr="${server_addr%%/*}"
wg_net="10.99.0.0/24"
case "$server_addr" in
  10.99.0.*/*) wg_net="10.99.0.0/24" ;;
  10.*.*.*/*) wg_net="${server_ip_no_cidr%.*}.0/24" ;;
esac

cat >/etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $server_private
Address = $server_addr
ListenPort = $port
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -s $wg_net -o $wan_if -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -s $wg_net -o $wan_if -j MASQUERADE

[Peer]
# $client_name
PublicKey = $client_public
PresharedKey = $client_psk
AllowedIPs = $client_addr
EOF
chmod 0600 /etc/wireguard/wg0.conf

client_ip_no_cidr="${client_addr%%/*}"
cat >"/root/wireguard-clients/${client_name}.conf" <<EOF
[Interface]
PrivateKey = $client_private
Address = $client_addr

[Peer]
PublicKey = $server_public
PresharedKey = $client_psk
Endpoint = $endpoint:$port
AllowedIPs = ${allowed_lans}, ${server_ip_no_cidr}/32
PersistentKeepalive = 25
EOF
chmod 0600 "/root/wireguard-clients/${client_name}.conf"

systemctl enable --now wg-quick@wg0
systemctl --no-pager --full status wg-quick@wg0 | sed -n '1,20p'
wg show wg0
printf '\nCLIENT_CONFIG_PATH=/root/wireguard-clients/%s.conf\n' "$client_name"
printf 'SERVER_PUBLIC_KEY=%s\n' "$server_public"
CTSCRIPT
  pct push "$ctid" "$tmp" /tmp/wg-configure.sh --perms 0700 >/dev/null
  rm -f "$tmp"
  pct exec "$ctid" -- bash /tmp/wg-configure.sh "$endpoint" "$port" "$server_addr" "$client_addr" "$allowed_lans" "$client_name"
}

maybe_configure_host_port_forward() {
  local enable="$1" public_port="$2" ct_ip="$3" ct_port="$4"
  [[ "$enable" == "yes" ]] || return 0

  warn "Host-Portforward wird eingerichtet: UDP $public_port -> $ct_ip:$ct_port"
  warn "Das verändert NAT-Regeln auf dem Proxmox-Host."

  if ! command -v iptables >/dev/null 2>&1; then
    err "iptables fehlt auf dem Host. Portforward wird übersprungen."
    return 1
  fi

  # Runtime rule for immediate use.
  iptables -t nat -C PREROUTING -i vmbr0 -p udp --dport "$public_port" -j DNAT --to-destination "$ct_ip:$ct_port" 2>/dev/null || \
    iptables -t nat -A PREROUTING -i vmbr0 -p udp --dport "$public_port" -j DNAT --to-destination "$ct_ip:$ct_port"

  # Roy's PVE uses /opt/script/network/post-up.sh for persistent vmbr0 NAT/port-forwarding.
  # Append the rule there when the file exists; otherwise leave a clear runtime-only warning.
  local post_up="/opt/script/network/post-up.sh"
  local persist_line="iptables    -t nat      -A PREROUTING   -i vmbr0    -p udp      --dport ${public_port}               -j DNAT     --to ${ct_ip}:${ct_port}"
  if [[ -f "$post_up" ]]; then
    if ! grep -Fq -- "--dport ${public_port}" "$post_up"; then
      cp -a "$post_up" "${post_up}.bak.$(date +%Y%m%d-%H%M%S)"
      {
        printf '\n# wireguard lxc %s (added by roy-wireguard-pve-lxc.sh)\n' "$ct_ip"
        printf '%s\n' "$persist_line"
      } >>"$post_up"
      chmod +x "$post_up" || true
      log "Portforward persistent in $post_up eingetragen."
    else
      log "Portforward für UDP $public_port scheint bereits in $post_up vorhanden zu sein."
    fi
  else
    warn "Kein $post_up gefunden; Portforward ist nur runtime aktiv. Bitte persistent nachtragen."
  fi

  log "Portforward aktiv: UDP $public_port -> $ct_ip:$ct_port"
}

install_wgdashboard_inside_ct() {
  local ctid="$1"
  info "Installiere WGDashboard im LXC $ctid..."
  pct exec "$ctid" -- bash -lc '
    set -Eeuo pipefail
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y git
    if [[ ! -d /etc/wgdashboard ]]; then
      git clone -q https://github.com/WGDashboard/WGDashboard.git /etc/wgdashboard
    fi
    cd /etc/wgdashboard/src
    chmod u+x wgd.sh
    ./wgd.sh install
    cat >/etc/systemd/system/wg-dashboard.service <<EOF
[Unit]
After=syslog.target network-online.target
Wants=wg-quick.target
ConditionPathIsDirectory=/etc/wireguard

[Service]
Type=forking
PIDFile=/etc/wgdashboard/src/gunicorn.pid
WorkingDirectory=/etc/wgdashboard/src
ExecStart=/etc/wgdashboard/src/wgd.sh start
ExecStop=/etc/wgdashboard/src/wgd.sh stop
ExecReload=/etc/wgdashboard/src/wgd.sh restart
TimeoutSec=120
PrivateTmp=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable --now wg-dashboard
    systemctl --no-pager --full status wg-dashboard | sed -n "1,24p"
  '
  log "WGDashboard installiert. Es ist über http://<LXC-IP>:10086 erreichbar. Default Login sofort ändern: admin/admin."
}

main() {
  need_root
  need_pve

  local nextid default_endpoint detected_ip
  nextid="$(get_nextid)"
  detected_ip="$(curl -fsS --max-time 5 https://api.ipify.org 2>/dev/null || true)"
  default_endpoint="${detected_ip:-DEINE-DOMAIN-ODER-PUBLIC-IP}"

  cat <<'INTRO'
Roy/Hermes WireGuard-LXC Installer

Das Script nutzt Community-Scripts als Basis, installiert optional WGDashboard,
erzeugt wg0 und legt eine erste Client-Konfiguration ab.

Roy-PVE-Erkennung: vmbr0 ist extern, vmbr1 ist intern. Daher ist vmbr1 der Default
für den WireGuard-LXC; der öffentliche UDP-Port wird bei Bedarf von vmbr0 weitergeleitet.

Wichtig: UDP 51820 muss am Ende von außen beim WireGuard-LXC ankommen.
INTRO

  local ctid hostname bridge ct_ip gateway cpu ram disk wg_endpoint wg_port wg_server wg_client allowed_lans client_name install_dashboard enable_host_forward
  prompt ctid "Container-ID" "$nextid"
  prompt hostname "Hostname" "$HOSTNAME_DEFAULT"
  prompt bridge "Proxmox Bridge" "$BRIDGE_DEFAULT"
  prompt ct_ip "LXC-IP mit CIDR, z.B. 10.10.10.106/24 oder dhcp" "dhcp"
  if [[ "$ct_ip" == "dhcp" ]]; then
    gateway=""
  else
    prompt gateway "Gateway für LXC" "10.10.10.1"
  fi
  prompt cpu "CPU Cores" "$CPU_DEFAULT"
  prompt ram "RAM MiB" "$RAM_DEFAULT"
  prompt disk "Disk GB" "$DISK_DEFAULT"
  prompt wg_endpoint "Öffentliche VPN-Adresse/DNS für Client Endpoint" "$default_endpoint"
  prompt wg_port "WireGuard UDP Port" "$WG_PORT_DEFAULT"
  prompt wg_server "WireGuard Server-Adresse" "$WG_SERVER_DEFAULT"
  prompt wg_client "Erste Client-Adresse" "$WG_CLIENT_DEFAULT"
  prompt allowed_lans "Netze, die der Client über VPN erreichen soll, Komma-getrennt" "$LAN_ALLOWED_DEFAULT"
  prompt client_name "Name der ersten Client-Konfig" "roy-laptop"
  client_name="$(sanitize_file_name "$client_name")"
  prompt_yes_no install_dashboard "WGDashboard installieren? Nur intern/VPN nutzen; Default-Login sofort ändern" "yes"
  prompt_yes_no enable_host_forward "UDP-Portforward auf dem PVE-Host automatisch setzen? Für Roys vmbr0->vmbr1 Setup normalerweise JA" "yes"

  cat <<SUMMARY

Zusammenfassung:
- CTID/Hostname: $ctid / $hostname
- LXC Netz: bridge=$bridge ip=$ct_ip gateway=${gateway:-none}
- Ressourcen: CPU=$cpu RAM=${ram}MiB Disk=${disk}GB
- WireGuard: $wg_server UDP $wg_port
- Client: $wg_client ($client_name)
- Client AllowedIPs: $allowed_lans, ${wg_server%%/*}/32
- Endpoint: $wg_endpoint:$wg_port
- WGDashboard: $install_dashboard
- Host-Portforward: $enable_host_forward
SUMMARY

  local confirm
  read -r -p "Fortfahren? [yes/NO]: " confirm || true
  if [[ "${confirm,,}" != "yes" ]]; then
    warn "Abgebrochen."
    exit 0
  fi

  local script_path="/tmp/community-wireguard-${ctid}.sh"
  fetch_community_script "$script_path"

  info "Starte Community-Scripts WireGuard LXC Erstellung..."
  # In non-interactive mode the WGDashboard prompt receives EOF/empty and defaults to N.
  # We still pass 'default' to avoid the Advanced wizard; all key defaults are set by var_* env vars.
  var_ctid="$ctid" \
  var_hostname="$hostname" \
  var_brg="$bridge" \
  var_net="$ct_ip" \
  var_gateway="$gateway" \
  var_cpu="$cpu" \
  var_ram="$ram" \
  var_disk="$disk" \
  var_os="debian" \
  var_version="13" \
  var_unprivileged="1" \
  var_tun="yes" \
  var_nesting="0" \
  var_keyctl="0" \
  var_fuse="no" \
  var_tags="network;vpn;wireguard;roy" \
  bash "$script_path" default

  wait_for_ct "$ctid"

  # If DHCP was used, discover CT IP for optional host forward and final output.
  local ct_ipv4
  ct_ipv4="$(pct exec "$ctid" -- hostname -I 2>/dev/null | tr ' ' '\n' | grep -E '^[0-9]+\.' | head -1 || true)"
  if [[ -z "$ct_ipv4" && "$ct_ip" != "dhcp" ]]; then
    ct_ipv4="${ct_ip%%/*}"
  fi

  info "Konfiguriere wg0 im LXC..."
  configure_wireguard_inside_ct "$ctid" "$wg_endpoint" "$wg_port" "$wg_server" "$wg_client" "$allowed_lans" "$client_name"

  if [[ "$install_dashboard" == "yes" ]]; then
    install_wgdashboard_inside_ct "$ctid"
  fi

  if [[ -n "$ct_ipv4" ]]; then
    maybe_configure_host_port_forward "$enable_host_forward" "$wg_port" "$ct_ipv4" "$wg_port" || true
  else
    warn "Konnte LXC-IP nicht ermitteln; Host-Portforward übersprungen."
  fi

  cat <<DONE

Fertig.

LXC:
- CTID: $ctid
- Hostname: $hostname
- IP: ${ct_ipv4:-unknown}

WireGuard:
- Server config im LXC: /etc/wireguard/wg0.conf
- Client config im LXC: /root/wireguard-clients/${client_name}.conf
- WGDashboard: ${install_dashboard}$( [[ "$install_dashboard" == "yes" ]] && printf ' -> http://%s:10086' "${ct_ipv4:-LXC-IP}" )

Client-Konfig anzeigen:
  pct exec $ctid -- cat /root/wireguard-clients/${client_name}.conf

Status prüfen:
  pct exec $ctid -- wg show
  pct exec $ctid -- systemctl status wg-quick@wg0

Wichtig:
- UDP $wg_port muss von außen den LXC erreichen.
- Proxmox Web UI / MT5 noVNC danach am besten NICHT öffentlich freigeben, sondern nur über VPN nutzen.
DONE
}

main "$@"
