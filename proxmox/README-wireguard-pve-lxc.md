# Roy WireGuard PVE LXC Installer

Run on the Proxmox VE host as root:

```bash
curl -fsSL https://raw.githubusercontent.com/adihadi123/cheatsheets/main/proxmox/roy-wireguard-pve-lxc.sh -o roy-wireguard-pve-lxc.sh
bash roy-wireguard-pve-lxc.sh
```

This wrapper uses the official Community-Scripts WireGuard LXC script as base, skips WGDashboard by default, configures wg0, and generates the first client config in the LXC.
