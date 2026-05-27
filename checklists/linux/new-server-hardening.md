# Checklist: harden a new Linux server

> Walk this when provisioning a Linux server that's reachable from a network. Each item is yes/no; blocking items are the baseline that stops the common automated attacks. Concepts: [../../references/linux/users-sudo-and-groups.md](../../references/linux/users-sudo-and-groups.md), [../../references/linux/networking-basics.md](../../references/linux/networking-basics.md).

## Access (blocking)

- [ ] A non-root user exists with `sudo`, and you've logged in as them — not as root.
- [ ] SSH **key** authentication works for that user (`ssh-copy-id`), tested before disabling passwords.
- [ ] Password authentication disabled in `/etc/ssh/sshd_config` (`PasswordAuthentication no`), then `sudo systemctl restart ssh`.
- [ ] Root SSH login disabled (`PermitRootLogin no`).
- [ ] Private keys are `600`, `~/.ssh` is `700` ([../../references/linux/permissions-and-ownership.md](../../references/linux/permissions-and-ownership.md)).

## Network exposure (blocking)

- [ ] Firewall enabled, default-deny inbound, allowing only needed ports (`sudo ufw allow OpenSSH`, then `sudo ufw enable`).
- [ ] `ss -tlnp` reviewed — every listening service is one you intend to expose; bind internal-only services to `127.0.0.1`.
- [ ] Cloud security group / network ACL matches the host firewall (don't rely on only one layer).

## Patching & services (blocking)

- [ ] System fully updated (`sudo apt update && sudo apt upgrade`, or distro equivalent).
- [ ] Unattended security updates enabled (`unattended-upgrades` on Debian/Ubuntu).
- [ ] Unnecessary services disabled (`systemctl list-units --type=service --state=running` reviewed; `disable --now` the ones you don't need).

## Hardening (advisory)

- [ ] `fail2ban` (or equivalent) installed to throttle brute-force attempts.
- [ ] Time sync enabled (`timedatectl` / `systemd-timesyncd`) — important for logs and TLS.
- [ ] Service units run as a dedicated non-root user with least privilege ([../../snippets/linux/systemd-service.service](../../snippets/linux/systemd-service.service)).
- [ ] Secrets in files are `600` and owned by the service user, not world-readable.
- [ ] Logging/monitoring in place; you know where `journalctl`/`/var/log` are for this host.

## After

- [ ] Documented what's exposed and why; recorded the access path (who has keys).
- [ ] Confirmed you can still get in from a second session **before** closing the first (don't lock yourself out after an sshd change).
