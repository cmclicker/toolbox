#!/usr/bin/env bash
# Curated Linux command-line one-liners worth keeping. Copy individually.
# Concepts: ../../references/linux/text-processing-tools.md,
#           ../../references/linux/processes-and-signals.md

# --- Disk / space ----------------------------------------------------------
# What's using disk in the current dir, largest first, human-readable:
du -h --max-depth=1 . | sort -rh | head -20
# Overall filesystem usage:
df -h
# Find files larger than 100MB:
find . -type f -size +100M -exec ls -lh {} + 2>/dev/null

# --- Processes / resources -------------------------------------------------
# Top 10 processes by memory, then by CPU:
ps aux --sort=-%mem | head -11
ps aux --sort=-%cpu | head -11
# What is listening on a given port (e.g. 8080):
sudo ss -tlnp | grep :8080
# Kill processes matching a name (TERM first; -9 only if stuck):
pkill -f myserver

# --- Logs / text -----------------------------------------------------------
# Most frequent lines in a log (top offenders):
sort access.log | uniq -c | sort -rn | head
# Follow a service's logs live:
journalctl -u myapp -f
# Count occurrences of a pattern across a tree:
grep -rc "ERROR" /var/log 2>/dev/null | grep -v ':0$'

# --- Files / cleanup -------------------------------------------------------
# Delete files older than 7 days (test by swapping -delete for -print first):
find /tmp/mycache -type f -mtime +7 -print
# Recursively replace text in matching files (preview by dropping -i):
grep -rl OLD src/ | xargs sed -i 's/OLD/NEW/g'

# --- Network ---------------------------------------------------------------
# Health check that exits non-zero on an HTTP error response (script-safe):
curl -fsSL https://example.com/health
# Resolve a name the way the system actually does:
getent hosts example.com
