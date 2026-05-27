# Processes, jobs, and signals

**TL;DR:** Every running program is a process with a PID. You inspect them with `ps`/`top`/`htop`, control them with **signals** sent via `kill`, and manage foreground/background **jobs** in your shell. The signal that matters most: `SIGTERM` (15) asks a process to stop gracefully; `SIGKILL` (9) forces it and can't be caught — try TERM first, KILL only if it won't die.

## Inspecting processes

```bash
ps aux                  # every process (user, PID, %CPU, %MEM, command)
ps -ef                  # same idea, different columns; -ef shows parent PID (PPID)
top                     # live, sorted by CPU; press M to sort by memory, q to quit
htop                    # nicer interactive top (install separately) — scroll, filter, kill
pgrep -fl node          # find PIDs by name/pattern
pstree -p               # process tree with PIDs (parent/child relationships)
```

Each process has a **PID** and a **parent** (PPID). Processes form a tree rooted at PID 1 (the init system, usually systemd — [systemd-and-services.md](systemd-and-services.md)).

## Signals and `kill`

`kill` sends a signal to a PID (despite the name, it's "send signal," not necessarily "terminate"):

```bash
kill <pid>              # default SIGTERM (15): polite "please stop"
kill -TERM <pid>        # explicit SIGTERM
kill -KILL <pid>        # SIGKILL (9): forced, uncatchable — last resort
kill -HUP <pid>         # SIGHUP (1): often "reload config" for daemons
kill -9 <pid>           # numeric form of SIGKILL
pkill -f pattern        # signal by name/pattern instead of PID
killall <name>          # signal all processes with that exact name
```

| Signal | Num | Effect |
|---|---|---|
| `SIGTERM` | 15 | graceful stop (default); the process can clean up. **Try this first.** |
| `SIGKILL` | 9 | immediate kill; cannot be caught/ignored. Use only if TERM fails. |
| `SIGHUP` | 1 | hangup; many daemons reload config on it |
| `SIGINT` | 2 | what Ctrl-C sends (interrupt) |
| `SIGSTOP`/`SIGCONT` | 19/18 | pause / resume a process |

The order matters: `SIGKILL` gives the process no chance to flush buffers or release locks, which can corrupt state. Send `SIGTERM`, wait a moment, then `SIGKILL` only if it's stuck.

## Shell jobs (foreground/background)

```bash
long-command &          # start in the background
jobs                    # list this shell's jobs
fg %1                   # bring job 1 to the foreground
bg %1                   # resume a stopped job in the background
# Ctrl-Z                # suspend the foreground job (SIGTSTP) -> then bg/fg
```

Background jobs are tied to the shell — closing it sends `SIGHUP` and they may die. To survive logout:

```bash
nohup long-command &          # ignore SIGHUP, log to nohup.out
setsid long-command           # fully detach into its own session
# for interactive long-runners, prefer a terminal multiplexer: tmux / screen
```

## Exit status

A finished process returns 0–255; `$?` holds the last one (0 = success). Processes killed by signal N report `128 + N` (e.g. `137` = 128+9 = SIGKILL, `143` = 128+15 = SIGTERM) — handy for spotting OOM-kills (137). See [../bash/error-handling.md](../bash/error-handling.md).

## How I use it

- `htop` (or `top`, `M` for memory) to see what's hot; `pgrep`/`pstree` to find the right PID and its parents.
- `kill <pid>` (TERM) first; `kill -9` only when a process is truly stuck — knowing it can corrupt state.
- `nohup ... &` or `tmux` for anything that must outlive the shell; `Ctrl-Z`+`bg` to background something I forgot to.
- Exit `137` → suspect an OOM kill; check `dmesg`/`journalctl`.

## Links

- [`signal(7)` — the signal list](https://man7.org/linux/man-pages/man7/signal.7.html)
- [`ps(1)`](https://man7.org/linux/man-pages/man1/ps.1.html)
