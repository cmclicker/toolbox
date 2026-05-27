# Playbook: troubleshoot a failed systemd service

> **Trigger:** a service won't start, keeps restarting, or isn't behaving. Est. time: 5–30 min. Concepts: [../../references/linux/systemd-and-services.md](../../references/linux/systemd-and-services.md).

## Step 1 — Get the state and the last words

```bash
systemctl status myapp
```

Read: is it `active`, `failed`, or `activating` (restart-looping)? `enabled` or not? The status output also shows the **last few log lines** and the exit code / signal — often the answer is right there (`status=203/EXEC` = bad ExecStart path; `status=217/USER` = user doesn't exist).

## Step 2 — Read the logs

```bash
journalctl -u myapp -e          # jump to the most recent entries
journalctl -u myapp --since "10 min ago"
journalctl -u myapp -f          # follow while you try to start it
```

The journal has the service's stdout/stderr. Most startup failures explain themselves here: missing file, port in use, permission denied, bad config.

## Step 3 — Map the symptom to a cause

| Status / log clue | Likely cause |
|---|---|
| `203/EXEC` | `ExecStart` path wrong or not executable (use an absolute path; `chmod +x`) |
| `217/USER` | the `User=` doesn't exist |
| `Address already in use` | another process holds the port → `ss -tlnp \| grep :PORT` ([networking](../../references/linux/networking-basics.md)) |
| `Permission denied` | service user can't read/write a path → check ownership/modes ([permissions](../../references/linux/permissions-and-ownership.md)) |
| restart loop (`activating`) | crashes on start; read logs for the real error; `Restart=` masks it |
| `command not found` in logs | systemd doesn't use your shell PATH — use absolute paths or set `Environment=PATH=...` |

## Step 4 — Fix, reload if the unit changed, restart

```bash
# edit config in /etc/<svc>/... or the unit in /etc/systemd/system/myapp.service
sudo systemctl daemon-reload    # REQUIRED if you edited the .service file
sudo systemctl restart myapp
systemctl status myapp          # confirm active
```

Forgetting `daemon-reload` after editing a unit file is a classic "my change did nothing" — systemd is still running the old definition until you reload.

## Step 5 — Verify it stays up and starts at boot

```bash
systemctl is-active myapp       # active
systemctl is-enabled myapp      # enabled (will start at boot) — `enable --now` if not
journalctl -u myapp -f          # watch a bit to confirm it doesn't restart-loop
```

## If it's not a systemd service

- App logs to a file, not the journal → check `/var/log/<app>/` ([filesystem-hierarchy](../../references/linux/filesystem-hierarchy.md)).
- It's a user service → add `--user` to every `systemctl`/`journalctl` command.
- The process dies under load with exit `137` → likely OOM-killed; check `journalctl -k` / `dmesg` for the OOM killer ([processes](../../references/linux/processes-and-signals.md)).
