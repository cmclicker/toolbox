# Shell startup files: `.bashrc` vs `.bash_profile` vs `.profile`

**TL;DR:** Which file Bash reads depends on whether the shell is a **login** shell and whether it's **interactive**. Interactive non-login shells read `~/.bashrc`; login shells read `~/.bash_profile` (or `~/.bash_login`/`~/.profile`) but **not** `~/.bashrc` automatically. The standard fix is to source `~/.bashrc` from `~/.bash_profile` so your config loads in both cases. Put PATH/env in the profile, interactive niceties (aliases, prompt) in `.bashrc`.

## The two axes

- **Login shell** — started at actual login (SSH, a TTY, `bash --login`, often the macOS Terminal). Sets up the environment for the whole session.
- **Interactive shell** — has a prompt and reads commands from you (vs. running a script). A new terminal tab/window is usually interactive **non-login**.

## What gets read when

| Shell kind | Files read (in order) |
|---|---|
| Interactive **login** | `/etc/profile`, then the **first found** of `~/.bash_profile`, `~/.bash_login`, `~/.profile` |
| Interactive **non-login** | `/etc/bash.bashrc` (distro-dependent), then `~/.bashrc` |
| Non-interactive (script) | the file named by `$BASH_ENV` (if set) — **not** `.bashrc` |

Key consequences:

- A login shell does **not** read `~/.bashrc` on its own.
- A script does **not** read `~/.bashrc` or your profile — don't put script-required setup in them.

## The standard arrangement

Make login shells also load your interactive config by sourcing `.bashrc` from the profile:

```bash
# ~/.bash_profile
[ -f ~/.bashrc ] && . ~/.bashrc
```

Then split responsibilities:

- **`~/.bash_profile`** (login, once per session): environment that should be **exported** and inherited — `PATH` additions, `EDITOR`, `LANG`, tool env vars.
- **`~/.bashrc`** (every interactive shell): aliases, functions, prompt (`PS1`), shell options (`shopt`), completion. These aren't exported and are needed in every interactive shell, including non-login ones.

Putting `PATH` only in `.bashrc` is a common mistake: GUI-launched or login sessions may not pick it up. Export-worthy environment belongs in the profile.

## `.profile` and other shells

`~/.profile` is the POSIX-shell (sh) profile, read by Bash as a login fallback only if `.bash_profile`/`.bash_login` don't exist. Keep `.profile` POSIX-portable (no Bash-only syntax) if other shells use it; put Bash-specific things in `.bashrc`. zsh uses an entirely different set (`.zshrc`/`.zprofile`).

## On Windows

- **Git Bash** reads `~/.bash_profile`/`~/.bashrc` under your Git-Bash home (typically `%USERPROFILE%`).
- **WSL** is a full Linux environment with its own `~/.bashrc` inside the distro — separate from Git Bash. Edits in one don't affect the other. (The `windows` domain will cover the WSL bridge when it lands.)

## How I use it

- `~/.bash_profile` sources `~/.bashrc` (the snippet above) so both shell kinds get my config.
- Exported environment (PATH, EDITOR) in the profile; aliases/functions/prompt in `.bashrc`.
- Anything a *script* needs is set in the script (or `set -a`/explicit export), never assumed from interactive startup files.
- After editing, `source ~/.bashrc` (or open a new shell) to apply.

## Links

- [Bash manual — Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)
