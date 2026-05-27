# Permissions and ownership

**TL;DR:** Every file has an **owner**, a **group**, and three permission triads — for owner, group, and others — each granting read (`r`/4), write (`w`/2), execute (`x`/1). `chmod` sets permissions (octal `644`/`755` or symbolic `u+x`); `chown` sets owner/group. `umask` controls default permissions on new files. On directories, `x` means "may enter," and the setgid bit makes new files inherit the directory's group.

## Reading `ls -l`

```
-rwxr-xr-x  1 cody devs  4096 May 27 10:00 script.sh
└┬┘└┬┘└┬┘└┬┘     └─┬┘ └┬┘
 │  │  │  │        │   group
 │  │  │  │        owner
 │  │  │  others (r-x)
 │  │  group (r-x)
 │  owner (rwx)
 type (- file, d dir, l symlink)
```

Each triad is `rwx`; a `-` means that permission is absent.

## Octal numbers

Each permission is a bit: **r=4, w=2, x=1**. Sum per triad, three digits for owner/group/other:

| Octal | Symbolic | Meaning |
|---|---|---|
| `644` | `rw-r--r--` | owner read/write, others read — typical for files |
| `755` | `rwxr-xr-x` | owner full, others read/execute — scripts, directories |
| `600` | `rw-------` | owner only — private files (SSH keys, secrets) |
| `700` | `rwx------` | owner-only directory/script |
| `640` | `rw-r-----` | owner write, group read, others nothing |

```bash
chmod 755 script.sh        # octal
chmod u+x script.sh        # symbolic: add execute for the owner
chmod -R go-w dir/         # recursively remove write for group+others
chmod a+r file             # all (ugo) can read
```

## Ownership

```bash
chown cody file            # change owner
chown cody:devs file       # owner and group
chgrp devs file            # group only
chown -R cody:devs dir/    # recursive
```

Changing ownership generally requires root (`sudo`) — see [users-sudo-and-groups.md](users-sudo-and-groups.md).

## `umask`: defaults for new files

`umask` is a mask **subtracted** from the base permissions of new files (base 666) and directories (base 777). The common default `022` (confirmed on this Ubuntu) yields:

- new files → `666 - 022 = 644` (`rw-r--r--`)
- new dirs → `777 - 022 = 755` (`rwxr-xr-x`)

```bash
umask           # show current mask (e.g. 0022)
umask 077       # stricter: new files 600, dirs 700 (owner-only)
```

Files are never created executable by `umask` (the base for files omits `x`); you add `x` explicitly with `chmod`.

## `x` on directories, and the special bits

- **Directory `x`** = permission to *enter* / traverse it (access files inside by name). A directory with `r` but not `x` lets you list names but not access entries. Directories almost always need `x` where they need `r`.
- **setuid (4xxx)** on an executable → runs as its **owner** (e.g. `/usr/bin/passwd`). Rare and security-sensitive.
- **setgid (2xxx)** on a directory → new files inside inherit the **directory's group** (great for shared project dirs). On an executable → runs as its group.
- **sticky bit (1xxx)** on a directory → only a file's owner can delete it, even if others can write the dir. This is why `/tmp` (`drwxrwxrwt`) is world-writable but safe.

```bash
chmod 2775 shared/    # setgid dir: group-shared, new files inherit the group
chmod 1777 /tmp       # sticky world-writable dir
chmod 600 ~/.ssh/id_ed25519   # SSH refuses keys that are group/world-readable
```

## How I use it

- `644` for files, `755` for scripts/dirs, `600`/`700` for anything private (SSH keys, secrets) — SSH actively rejects keys that aren't owner-only.
- `umask 022` normally; `077` on machines where new files should default private.
- `setgid` on shared project directories so the group is inherited; sticky bit understood as why `/tmp` is safe.
- `sudo` for `chown`; symbolic `chmod` (`u+x`) for quick tweaks, octal for setting exact modes.

## Links

- [`chmod` man page](https://man7.org/linux/man-pages/man1/chmod.1.html)
- [`umask` explained (man 2 umask)](https://man7.org/linux/man-pages/man2/umask.2.html)
