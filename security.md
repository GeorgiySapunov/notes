### Rkhunter

rkhunter (Rootkit Hunter) is a security monitoring tool for POSIX compliant
systems. It scans for rootkits, and other possible vulnerabilities. It does so
by searching for the default directories (of rootkits), misconfigured
permissions, hidden files, kernel modules containing suspicious strings, and
comparing hashes of important files with known good ones.

```zsh
rkhunter --update
rkhunter --propupd
rkhunter --check
cat /var/log/rkhunter.log
sudo cat /var/log/rkhunter.log | grep -A5 "\[ Warning \]"
```

### apparmor

https://wiki.archlinux.org/title/AppArmor
https://www.youtube.com/watch?v=-3W2f_JL3yw

### firejail

```zsh
firejail --seccomp --nonewprivs --private-tmp <app name>
```
