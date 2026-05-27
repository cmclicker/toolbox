# Users, groups, and sudo

**TL;DR:** Linux is multi-user. Each user has a UID, a primary group, and optional supplementary groups; the superuser is **root** (UID 0). You don't log in as root — you run individual commands with **`sudo`**, which grants temporary root for one command and logs it. Group membership is how you grant access to shared resources (Docker, dialout, a project directory).

## Users and identity

```bash
id                      # your uid, gid, and groups (verified here: uid=1000)
whoami                  # current username
id <user>               # someone else's ids/groups
getent passwd <user>    # account details from /etc/passwd (and other sources)
```

- **UID 0 = root**, the superuser — bypasses file-permission and most security checks. Regular users start at 1000 on most distros.
- Account data lives in `/etc/passwd` (users), `/etc/group` (groups), `/etc/shadow` (password hashes, root-only).

## `sudo` vs. `su`

- **`sudo <cmd>`** — run a single command as root (or another user with `-u`), authenticating with **your own** password. Preferred: scoped, logged, no shared root password.
- **`su -`** — switch to a full root shell (needs the root password, often disabled on Ubuntu). Everything after runs as root until you `exit` — easy to forget you're root. Avoid for routine work.

```bash
sudo apt update                 # one command as root
sudo -u postgres psql           # run as a different user
sudo -i                         # interactive root shell (when you truly need a session)
sudo -l                         # what am I allowed to run via sudo?
```

Who may use `sudo` is controlled by membership in a group (**`sudo`** on Debian/Ubuntu, **`wheel`** on Fedora/Arch) and the `/etc/sudoers` file. **Edit sudoers only with `visudo`** — it validates syntax before saving, so you don't lock yourself out with a typo.

## Managing users and groups

```bash
sudo adduser alice              # create a user (interactive, Debian/Ubuntu friendly)
sudo useradd -m -s /bin/bash alice   # lower-level, cross-distro
sudo passwd alice               # set/change a password
sudo usermod -aG docker alice   # ADD alice to the 'docker' group (note -aG together)
sudo deluser alice              # remove (userdel on other distros)
groups alice                    # which groups alice is in
```

**`usermod -aG`**: the `-a` (append) is critical — `usermod -G docker alice` *replaces* all supplementary groups; `usermod -aG docker alice` adds to them. Forgetting `-a` removes the user from every other group.

## Group membership and access

Groups are how non-root access to resources is granted, e.g.:

- `docker` group → run `docker` without `sudo` (note: that's effectively root-equivalent power).
- `sudo`/`wheel` → may use `sudo`.
- a project group + a setgid directory → shared write access ([permissions-and-ownership.md](permissions-and-ownership.md)).

**Group changes take effect on next login.** After `usermod -aG`, the user must log out and back in (or `newgrp <group>` for the current shell) for the new membership to apply — a frequent "I added myself to docker but still get permission denied" cause.

## Least privilege

- Run as your normal user; reach for `sudo` per command, not a root shell.
- Don't `chmod 777` to "fix" a permission problem — grant via the right group/ownership instead.
- Be aware that `docker` group membership and passwordless sudo are effectively root; treat them as such.

## How I use it

- `sudo <cmd>` per action; `sudo -i` only when a genuine root session is needed; never routine `su -`.
- `usermod -aG <group> <user>` (always `-aG`), then log out/in for it to take.
- `visudo` for any sudoers change; group+ownership for shared access instead of `777`.

## Links

- [`sudo` man page](https://man7.org/linux/man-pages/man8/sudo.8.html)
- [Ubuntu — about sudo / root](https://help.ubuntu.com/community/RootSudo)
