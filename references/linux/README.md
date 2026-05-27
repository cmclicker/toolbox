# Linux — references

> My authored explainers for Linux as a dev/server environment. The shell *language* lives in [../bash/](../bash/); this domain is the OS around it. For curated external material, see [../../resources/linux/](../../resources/linux/). Running Linux under Windows: [../windows/wsl.md](../windows/wsl.md).

## Foundations

- [filesystem-hierarchy.md](filesystem-hierarchy.md) — the single tree, and what lives where (`/etc`, `/var`, `/usr`, `/proc`).
- [permissions-and-ownership.md](permissions-and-ownership.md) — `rwx`, octal modes, `chmod`/`chown`, `umask`, setuid/setgid/sticky.
- [users-sudo-and-groups.md](users-sudo-and-groups.md) — users/UIDs, `sudo` vs `su`, groups for access, `usermod -aG`.

## Running system

- [processes-and-signals.md](processes-and-signals.md) — `ps`/`top`/`htop`, signals (`SIGTERM` vs `SIGKILL`), jobs, `nohup`/`tmux`.
- [systemd-and-services.md](systemd-and-services.md) — `systemctl` (start vs enable), units, `journalctl` for logs.
- [networking-basics.md](networking-basics.md) — `ip`/`ss`, `curl`, `ssh`, DNS (`dig`/`getent`), firewall.

## Software & text

- [package-managers.md](package-managers.md) — apt vs dnf vs pacman (where distro differences live), snap/flatpak, language managers.
- [text-processing-tools.md](text-processing-tools.md) — grep, sed, awk, find, xargs, sort/uniq/cut — the CLI data toolkit.

## See also

- [../../playbooks/linux/](../../playbooks/linux/) — troubleshoot a service, diagnose resource usage.
- [../../snippets/linux/](../../snippets/linux/) · [../../configs/linux/](../../configs/linux/) · [../../checklists/linux/](../../checklists/linux/) · [../../resources/linux/](../../resources/linux/)
- [../bash/](../bash/) — the shell language · [../windows/wsl.md](../windows/wsl.md) — Linux under Windows
