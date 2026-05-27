# Playbook: diagnose high resource usage

> **Trigger:** a Linux box is slow, out of memory, out of disk, or a process is pegging the CPU. Est. time: 5–20 min. Concepts: [../../references/linux/processes-and-signals.md](../../references/linux/processes-and-signals.md).

## Step 1 — Which resource is the problem?

Get the overall picture first so you investigate the right thing:

```bash
uptime            # load average (roughly: runnable processes; compare to core count)
free -h           # memory: used / available / swap
df -h             # disk space per filesystem
top               # live CPU/mem; or htop if installed
```

- **Load >> core count** and high `%CPU` → CPU-bound. Go to Step 2.
- **`available` low / swap filling** → memory pressure. Step 3.
- **A filesystem near 100%** → disk full. Step 4.
- **Disk space fine but slow** → maybe disk *I/O* (Step 5).

## Step 2 — CPU

```bash
top                         # press P to sort by CPU; note the top PID(s)
ps -eo pid,ppid,user,%cpu,cmd --sort=-%cpu | head
```

Identify the process and its parent. If it's a runaway, decide: is it doing legitimate work (let it finish / nice it), or stuck? `renice` to deprioritize, or `kill` it ([processes-and-signals](../../references/linux/processes-and-signals.md) — TERM before KILL).

## Step 3 — Memory

```bash
free -h
ps -eo pid,user,%mem,rss,cmd --sort=-%mem | head      # top memory consumers
journalctl -k | grep -i "killed process"              # was the OOM killer invoked?
```

- A process with huge `RSS` → the leak/hog; restart or fix it.
- Exit code **137** on a service = OOM-killed ([troubleshoot-a-service](troubleshoot-a-service.md)). Add memory, cap the process, or fix the leak.
- Swap thrashing makes everything slow even if no single process looks huge.

## Step 4 — Disk space full

```bash
df -h                                   # which filesystem is full
du -h --max-depth=1 / 2>/dev/null | sort -rh | head    # biggest dirs (then descend)
du -h --max-depth=1 /var/log | sort -rh | head         # logs are a common culprit
```

Descend into the biggest directory repeatedly until you find it. Common causes: runaway logs (rotate/truncate; check `journalctl --disk-usage` and `journalctl --vacuum-size=200M`), old packages/caches, large temp files, a Docker image/volume buildup (`docker system df`).

> Gotcha: a file that's been **deleted but is still open** by a process keeps using space (won't show in `du`). `lsof +L1` finds them; the space frees when the process is restarted.

## Step 5 — Disk I/O or "inodes full"

```bash
df -i               # inodes — a filesystem can be "full" of inodes with space left (many tiny files)
iostat -x 2         # per-device I/O utilization (from the sysstat package)
iotop               # which process is doing the I/O (needs root)
```

"No space left on device" with `df -h` showing free space → you're out of **inodes** (`df -i`), usually millions of tiny files in one place.

## Step 6 — Act, then confirm

- Free the resource (kill/fix the process, rotate logs, clear caches, add capacity).
- Re-run the Step 1 command for that resource to confirm it recovered.
- If it's a recurring service, address the root cause (memory cap, log rotation, `Restart=` with a sane limit) rather than just clearing it once.

## How I use it

`uptime`/`free -h`/`df -h` to triage which resource → drill with the sorted `ps`/`du` command for that resource → identify the PID/dir → act (TERM before KILL; find the biggest dir by descending) → confirm recovery. Exit `137` and "space free but disk full" (inodes / deleted-open files) are the two traps worth remembering.
