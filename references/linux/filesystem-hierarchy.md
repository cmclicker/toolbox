# The Linux filesystem hierarchy

**TL;DR:** Linux has one tree rooted at `/` (no drive letters); everything — disks, devices, network mounts — hangs off it. The Filesystem Hierarchy Standard (FHS) defines what lives where: configuration in `/etc`, variable data in `/var`, user homes in `/home`, programs in `/usr`, temporary files in `/tmp`. Knowing the map tells you where to look for config, logs, and binaries on any distro.

## One tree, mounted

There's a single root `/`. Additional filesystems (a second disk, a USB drive, a network share, the WSL `/mnt/c`) are **mounted** at a directory and appear as part of the one tree. `df -h` shows what's mounted where; `lsblk` shows block devices.

## The directories that matter

| Path | Holds |
|---|---|
| `/etc` | system-wide **configuration** (text files) — `/etc/ssh/sshd_config`, `/etc/hosts`, `/etc/fstab` |
| `/home/<user>` | user home directories (`~`); your dotfiles and projects |
| `/root` | the root user's home (not under `/home`) |
| `/var` | **variable** data that changes at runtime — `/var/log` (logs), `/var/lib` (app state), spool, caches |
| `/tmp` | temporary files, often cleared on reboot; world-writable with the sticky bit |
| `/usr` | user-space **programs and libraries** — `/usr/bin`, `/usr/lib`, `/usr/share`; the bulk of the OS |
| `/usr/local` | software installed **locally** by you/admin (not the package manager) — keeps it separate from distro files |
| `/opt` | self-contained third-party/vendor packages |
| `/bin` `/sbin` `/lib` | essential binaries/libs (on modern distros these are symlinks into `/usr`) |
| `/boot` | kernel and bootloader |
| `/dev` | device files (`/dev/sda`, `/dev/null`) |
| `/proc` `/sys` | virtual filesystems exposing kernel/process state (not real files on disk) |
| `/mnt` `/media` | mount points for temporary/removable filesystems (WSL mounts Windows drives at `/mnt/c`) |

## The patterns worth internalizing

- **Config is text under `/etc`.** To configure a service, you almost always edit a file in `/etc` (or a drop-in under `/etc/<svc>.d/`). No registry.
- **Logs and changing state live in `/var`.** `/var/log` first when something misbehaves; `journalctl` for systemd services ([systemd-and-services.md](systemd-and-services.md)).
- **Programs live under `/usr`;** your locally-built tools under `/usr/local/bin`; vendor blobs under `/opt`.
- **`/proc` and `/sys` aren't disk files** — they're live windows into the kernel (`/proc/cpuinfo`, `/proc/<pid>/`). Reading them inspects the running system.
- **`~` is `/home/<you>`** (or `/root` for root). Dotfiles (`.bashrc`, `.config/`) live here.

## Finding things

```bash
which <cmd>            # where a command's binary is (on PATH)
type <cmd>             # is it a binary, alias, function, or builtin?
find / -name pattern   # locate by name (slow; scope to a subtree)
locate pattern         # fast name search via a prebuilt db (needs mlocate/plocate)
ls -l /etc | less      # browse config
```

## How I use it

- Config → `/etc`; logs/state → `/var/log`, `/var/lib`; my own installs → `/usr/local` or `/opt` (never scattered in `/usr` where the package manager owns files).
- `/proc`/`/sys` to inspect the live kernel/process state rather than guessing.
- `df -h` / `lsblk` / `mount` to understand what's actually mounted where (including `/mnt/c` under WSL — [../windows/wsl.md](../windows/wsl.md)).

## Links

- [Filesystem Hierarchy Standard (FHS 3.0)](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- [`man hier`](https://man7.org/linux/man-pages/man7/hier.7.html) — the hierarchy described in the manual
