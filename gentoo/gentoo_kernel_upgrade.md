# How to Upgrade Your Gentoo Linux Kernel 

In this video I show you how to upgrade your kernel on Gentoo Linux, I go over
the full steps from how to make newer kernels available, how to download them,
compile them, and make them bootable. The commands used in this video are
written below


0. write "sys-kernel/gentoo-sources ~amd64" to your package.accept_keywords file
1. emerge --sync
2. emerge -uDNq --with-bdeps=y
3. cp /usr/src/linux/.config $(uname -r).config

4. eselect kernel list
5. eselect kernel set "NEW KERNEL NUMBER"
become root, or add sudo to the beginning of the following commands
make mrproper
6. copy the configuration file you backed up in step 3
7. mount "boot partition" /boot (don't forget -U if using UUID)
8. make modules_prepare
9. make -j4 && make modules_install && make install

10. emerge @module-rebuild

11. grub-mkconfig -o /boot/grub/grub.cfg
12. Reboot into your new kernel, congratulations, you're done :D
