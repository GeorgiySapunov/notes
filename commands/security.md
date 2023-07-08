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


```zsh
systemctl enable apparmor.service
systemctl start apparmor.service
```

Put lsm=landlock,lockdown,yama,integrity,apparmor,bpf to GRUB_CMDLINE_LINUX_DEFAULT= in /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet lsm=landlock,lockdown,yama,integrity,apparmor,bpf"

In order to use the apparmor integration with firejail, install the apparmor package and run as root: 

```zsh
sudo apparmor_parser -r /etc/apparmor.d/firejail-default
```

### firejail

```zsh
firejail --seccomp --nonewprivs --private-tmp <app name>
```
