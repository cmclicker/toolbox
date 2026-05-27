# systemd and services

**TL;DR:** systemd is the init system and service manager on most modern distros (Ubuntu, Debian, Fedora, RHEL, Arch). It starts the system and manages long-running services ("units"). You control services with `systemctl` (start/stop/enable/status) and read their logs with `journalctl`. The distinction that trips people: **`start`** runs a service now; **`enable`** makes it start at boot — they're independent.

## `systemctl` — managing services

```bash
systemctl status nginx          # state, recent log lines, PID, whether enabled
sudo systemctl start nginx      # start now
sudo systemctl stop nginx       # stop now
sudo systemctl restart nginx    # stop + start
sudo systemctl reload nginx     # reload config without dropping connections (if supported)
sudo systemctl enable nginx     # start automatically at boot (persistent)
sudo systemctl disable nginx    # don't start at boot
sudo systemctl enable --now nginx   # enable AND start in one step
systemctl is-active nginx       # scriptable: active/inactive
systemctl is-enabled nginx      # scriptable: enabled/disabled
systemctl list-units --type=service --state=running
```

**`start` ≠ `enable`.** `start` affects the current running system only (gone after reboot). `enable` sets boot behavior only (doesn't start it now). Use `enable --now` when you want both, which is usually the case for a service you're deploying.

## Units

A **unit** is anything systemd manages; services (`.service`) are the common kind, but there are also `.timer` (cron replacement), `.socket`, `.mount`, `.target` (groups, like the old runlevels). Unit files live in:

- `/lib/systemd/system/` (or `/usr/lib/...`) — packages' default units. Don't edit these.
- `/etc/systemd/system/` — your units and overrides (takes precedence).

After adding or editing a unit file, reload systemd's view:

```bash
sudo systemctl daemon-reload    # re-read unit files after changes
```

A minimal service unit and a user-service template are in [../../snippets/linux/systemd-service.service](../../snippets/linux/systemd-service.service).

## Reading logs with `journalctl`

systemd captures stdout/stderr of services into the journal:

```bash
journalctl -u nginx               # all logs for the nginx unit
journalctl -u nginx -f            # follow (tail -f equivalent)
journalctl -u nginx --since "1 hour ago"
journalctl -u nginx -e            # jump to the end
journalctl -p err -b              # priority error+ since this boot
journalctl -b                     # logs from the current boot
```

`-u <unit>` (which service), `-f` (follow), `-e` (end), `--since`/`--until`, and `-b` (this boot) cover most needs. This replaces hunting through `/var/log` for systemd-managed services (though some apps still log to files there).

## User services (no root)

A regular user can run services scoped to their session/login:

```bash
systemctl --user status myapp
systemctl --user enable --now myapp
loginctl enable-linger $USER      # keep user services running after logout
```

Unit files go in `~/.config/systemd/user/`. Useful for per-user dev daemons without touching system config.

## Troubleshooting a failed service

`systemctl status <svc>` (state + last log lines) → `journalctl -u <svc> -e` (full recent logs) → fix config in `/etc` → `daemon-reload` if the unit changed → `restart`. The procedure is [../../playbooks/linux/troubleshoot-a-service.md](../../playbooks/linux/troubleshoot-a-service.md).

## How I use it

- `systemctl enable --now <svc>` to deploy a service (run now + at boot); `status` then `journalctl -u <svc> -e` whenever one misbehaves.
- My own units in `/etc/systemd/system/`, `daemon-reload` after edits; user units under `~/.config/systemd/user/` for per-user dev daemons.
- `journalctl -u <svc> -f` to watch a service live instead of tailing files.

## Links

- [systemd / systemctl (man)](https://man7.org/linux/man-pages/man1/systemctl.1.html)
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/Systemd) (excellent regardless of distro)
