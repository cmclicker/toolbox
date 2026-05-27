# Networking basics

**TL;DR:** The everyday Linux networking toolkit: `ip` (interfaces/addresses/routes), `ss` (open sockets/listening ports), `curl`/`wget` (HTTP), `ssh`/`scp` (remote access and copy), and `dig`/`getent` (DNS). The old `ifconfig`/`netstat` are deprecated in favor of `ip`/`ss`. Most "is it the network?" questions are answered by "is the port listening?" (`ss`) and "does the name resolve?" (`dig`).

## Interfaces, addresses, routes — `ip`

```bash
ip addr            # interfaces and their IP addresses (alias: ip a)
ip route           # the routing table; `ip route get 1.1.1.1` shows the path for a dest
ip link            # interfaces up/down state
```

`ip` replaces `ifconfig`/`route` (which may not even be installed on modern distros).

## Ports and sockets — `ss`

```bash
ss -tlnp           # TCP, listening, numeric, with process (needs sudo for PID)
ss -tlnp | grep :8080     # what's listening on 8080?
ss -tan            # all TCP connections and their states
```

`ss` replaces `netstat`. `-t` TCP, `-u` UDP, `-l` listening, `-n` numeric (don't resolve names), `-p` show the owning process. "Connection refused" almost always means **nothing is listening** on that port — `ss -tlnp` confirms.

## HTTP — `curl` and `wget`

```bash
curl https://api.example.com/health        # fetch to stdout
curl -i URL                                # include response headers
curl -fsSL URL                             # fail on error, silent, follow redirects (script-safe)
curl -X POST -H "Content-Type: application/json" -d '{"a":1}' URL
curl -O URL                                # save as the remote filename
wget URL                                   # download to a file (good for large/recursive)
```

`curl -fsSL` is the canonical form for "fetch this and don't print junk or silently succeed on a 404" — used in install scripts.

## Remote access — `ssh` / `scp`

```bash
ssh user@host                              # log in
ssh -p 2222 user@host "uptime"             # custom port; run one remote command
scp file user@host:/path/                  # copy to remote (rsync for big/repeated syncs)
ssh-keygen -t ed25519                      # generate a key pair (use keys, not passwords)
ssh-copy-id user@host                      # install your public key on the server
```

Use key-based auth (an `~/.ssh/config` makes hosts memorable — template in [../../configs/linux/ssh-config](../../configs/linux/ssh-config)). SSH refuses private keys that are group/world-readable — `chmod 600 ~/.ssh/id_ed25519` ([permissions-and-ownership.md](permissions-and-ownership.md)).

## DNS and name resolution

```bash
dig example.com +short        # resolve a name (just the answer)
dig example.com MX            # a specific record type
getent hosts example.com      # resolve the way the system actually does (respects /etc/hosts, nsswitch)
```

`/etc/hosts` overrides DNS for specific names (local dev hostnames). `getent hosts` shows the *effective* resolution (file + DNS), which `dig` (DNS-only) doesn't.

## Firewall

```bash
sudo ufw status                # Ubuntu/Debian's simple firewall front-end
sudo ufw allow 22/tcp          # open a port
# Fedora/RHEL use firewalld: firewall-cmd --list-all
```

If a service listens (`ss` confirms) but is unreachable from outside, suspect the firewall (or a cloud security group) before the service.

## How I use it

- `ss -tlnp` to answer "is it listening / what owns this port"; `ip a`/`ip route` for addressing.
- `curl -fsSL` for health checks and scripts; `curl -i` to inspect headers when debugging an API.
- SSH keys + `~/.ssh/config`, `600` perms on keys; `rsync` over `scp` for repeated/large transfers.
- `dig +short` then `getent hosts` when a name "won't resolve" — they answer different questions (DNS vs. effective).

## Links

- [`ip`](https://man7.org/linux/man-pages/man8/ip.8.html) · [`ss`](https://man7.org/linux/man-pages/man8/ss.8.html) · [`curl`](https://curl.se/docs/manpage.html) · [`ssh`](https://man.openbsd.org/ssh)
