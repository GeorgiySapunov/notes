# How to Upgrade Your Gentoo Linux Kernel 

In this video I show you how to upgrade your kernel on Gentoo Linux, I go over
the full steps from how to make newer kernels available, how to download them,
compile them, and make them bootable. The commands used in this video are
written below


0. write "sys-kernel/gentoo-sources ~amd64" to your package.accept_keywords file
1. emerge --sync
2. emerge -uDNq --with-bdeps=y sys-kernel/gentoo-sources

    ```--with-bdeps``` In dependency calculations, pull in build time
    dependencies that are not strictly required.

3. cp /usr/src/linux/.config $(uname -r).config # save .config somewhere

4. eselect kernel list
5. eselect kernel set "NEW KERNEL NUMBER"

become root, or add sudo to the beginning of the following commands

6. cd /usr/src/linux
7. make mrproper
8. copy the configuration file you backed up in step 3 to ```/usr/src/linux/.config```
9. make olddefconfig **_or_** make manuconfig
10. mount "boot partition" /boot (don't forget -U if using UUID)
11. make modules_prepare
12. make -j4 && make modules_install && make install

13. emerge @module-rebuild

14. grub-mkconfig -o /boot/grub/grub.cfg
15. Reboot into your new kernel, congratulations, you're done :D
