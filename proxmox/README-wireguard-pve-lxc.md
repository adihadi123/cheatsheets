# Roy WireGuard PVE LXC Installer

Run on the Proxmox VE host as root:

```bash
curl -fsSL https://raw.githubusercontent.com/adihadi123/cheatsheets/main/proxmox/roy-wireguard-pve-lxc.sh -o roy-wireguard-pve-lxc.sh
bash roy-wireguard-pve-lxc.sh
```

This wrapper is tailored for Roy's Proxmox layout discovered on 2026-06-02:

- `vmbr0` = public/external bridge with `152.53.142.232/22`
- `vmbr1` = private/internal bridge with `10.10.10.1/24`
- existing LXCs are on `vmbr1`
- NAT/port forwarding is maintained in `/opt/script/network/post-up.sh`

The installer uses the official Community-Scripts WireGuard LXC script as base, creates a Debian 13 unprivileged LXC with TUN/TAP enabled, configures `wg0`, creates the first client config, and optionally installs WGDashboard.

Recommended answers for Roy's setup:

- Bridge: `vmbr1`
- LXC IP: `10.10.10.230/24` unless that address is already used
- Gateway: `10.10.10.1`
- WireGuard port: `51820`
- WireGuard server address: `10.99.0.1/24`
- First client address: `10.99.0.2/32`
- Allowed LANs: `10.10.10.0/24`
- Install WGDashboard: `yes` if you want the dashboard
- Host UDP port forward: `yes` for the current vmbr0 -> vmbr1 topology

After install:

```bash
pct exec <CTID> -- wg show
pct exec <CTID> -- systemctl status wg-quick@wg0
pct exec <CTID> -- cat /root/wireguard-clients/roy-laptop.conf
```

WGDashboard, if installed, is reachable internally at:

```text
http://<wireguard-lxc-ip>:10086
```

For Roy's preferred Nginx Proxy Manager setup, do **not** expose WGDashboard's
`10086/tcp` directly with a PVE port forward. Keep the only direct PVE forward
for WireGuard itself:

```text
Internet UDP 51820 -> PVE vmbr0 -> WireGuard LXC 10.10.10.230:51820/udp
Internet TCP 80/443 -> NPM/proxy LXC 10.10.10.254 -> WGDashboard 10.10.10.230:10086/tcp
```

NPM proxy host example:

```text
Domain: wgdashboard.<your-domain>
Scheme: http
Forward Hostname/IP: 10.10.10.230
Forward Port: 10086
Block Common Exploits: enabled
SSL: Let's Encrypt
Force SSL: enabled
Access List: Basic Auth and/or allow only VPN/internal source ranges
```

Security notes:

- Change WGDashboard's default login immediately.
- Only expose the WireGuard UDP port, usually `51820/udp`.
- Do not expose WGDashboard `10086/tcp` directly from PVE; publish it through NPM only if you add NPM access controls.
- Do not expose Proxmox `8006` or MT5/noVNC `6080` publicly.
- Review the script before running it as root.
