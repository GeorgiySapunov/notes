# Чек-лист установки gentoo linux

    lsblk -f
    
## Full_Disk_Encryption

https://wiki.gentoo.org/wiki/Full_Disk_Encryption_From_Scratch_Simplified

### Create partitions   

To create GRUB BIOS, issue the following command:

    parted -a optimal /dev/sdX

Set the default units to mebibytes:

    unit mib

Create a GPT partition table:

    mklabel gpt

Create the BIOS partition:

    mkpart primary 1 3
    name 1 grub
    set 1 bios_grub on

Create boot partition. This partition will contain GRUB files, plain (unencrypted) kernel and kernel initrd:

    mkpart primary fat32 3 515
    name 2 boot
    set 2 BOOT on
    mkpart primary 515 -1
    name 3 lvm
    set 3 lvm on

Everything is done, exit parted:

    quit

### Create boot filesystem

Create filesystem for /dev/sdX2, that will contain GRUB and kernel files. This partition is read by UEFI BIOS. Most of motherboards can ready only FAT32 filesystem:

    mkfs.vfat -F32 /dev/sdX2

### Prepare encrypted partition

In the next step, configure dm-crypt for /dev/sdX3:

---
**_For Ubuntu live cd (or another different distribution):_**

    modprobe dm-crypt
---

Encrypt LVM partition /dev/sdX3 with LUKS:

    cryptsetup luksFormat /dev/sdX3

### Create LVM inside encrypted block

#### LVM creation

Open encrypted device:

    cryptsetup luksOpen /dev/sdX3 lvm

##### Create LVM structure for partition mapping (/root, /swap and /home):

Crypt physical volume group:

    lvm pvcreate /dev/mapper/lvm
    
Create volume group vg0:

    vgcreate vg0 /dev/mapper/lvm

Create logical volumes for /root, /swap and /home filesystem:

    lvcreate -L 90G -n root vg0
    lvcreate -L 8G -n swap vg0
    lvcreate -l 100%FREE -n home vg0

#### File Systems

Build ext4 filesystem on each logical volume:

    mkfs.ext4 /dev/mapper/vg0-root
    mkfs.ext4 /dev/mapper/vg0-home
    mkswap /dev/mapper/vg0-swap
    swapon /dev/mapper/vg0-swap

### Gentoo installation

Create mount point for permanent Gentoo:

    mkdir /mnt/gentoo

Mount the root filesystem from the encrypted LVM partition:

    mount /dev/mapper/vg0-root /mnt/gentoo
    
And switch into /mnt/gentoo:

    cd /mnt/gentoo

---
**Note:**
If you are making changes to the home partition (like adding a user) in the chroot

    mkdir /mnt/gentoo/home
    mount /dev/mapper/vg0-home /mnt/gentoo/home/
---

## rootfs install

### Stage 3 install

Download the stage3 [desktop profile | openrc] to /mnt/gentoo from Gentoo mirrors.

    links https://www.gentoo.org/downloads/mirrors/
    
or use wget 

Extract the downloaded archive

    tar xJpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

### Configuring compile options

Переменная USE — это одна из самых крутых переменных в Gentoo. Она важна
при установке программ. Как уже говорилось, все программы компилируются из
исходников. Это увеличивает время установки, зато позволяет ставить именно
те части программ, которые нужны данной системе. В этой инструкции
предполагается, что в качестве графической оболочки будет использоваться
XFCE. Эта оболочка легче Gnome и KDE, но всё-таки симпатичная и гибкая.
Рекомендуемое значение этой переменной для пользователя XFCE приведено чуть
ниже.

Переменная CFLAGS по умолчанию имеет значение -O2 -pipe.

    -O2 (буква O — Optimization, а не ноль) контролирует общий уровень
    оптимизации. Не рекомендуется менять без острой необходимости.
    Подробнее про возможные значения переменной на
    wiki.gentoo.org/wiki/GCC_optimization#-O.

    -pipe не влияет на сгенерированный код, но ускоряет процесс компиляции.

    -march=... Часто рекомендуют прописать конкретный тип процессора
    (например, -march=core-avx-i, -march=core-avx2, -march=corei7-avx,
    -march=core2, -march=pentium-m и т.д., чтобы программы компилировались
    именно для конкретного типа процессора. Много примеров на
    wiki.gentoo.org/wiki/Safe_CFLAGS). Если архитектура процессора
    неизвестна, в большинстве случаев можно использовать -march=native. Но
    лучше не менять CFLAGS, хорошо не разобравшись в смысле происходящего.

Переменная MAKEOPTS отвечает за параллелизацию выполняемых операций. Если
на машине двухъядерный или четырёхъядерный процессор, обычно рекомендуется
значение MAKEOPTS="-j<количество ядер + 1>", т.е. MAKEOPTS="-j3" для
двухъядерного и MAKEOPTS="-j5" для четырёхъядерного процессора.

С помощью текстового редактора nano (или другого по выбору) редактируем
файл /mnt/gentoo/etc/portage/make.conf:

    CFLAGS="-march=native -O2 -pipe"
    # Для 8 потоков
    MAKEOPTS="-j8"
    # Для графической оболочки XFCE
    USE="-gnome -kde -minimal -qt4 dbus jpeg lock session startup-notification thunar udev X gtk3 pulsaudio alsa dhcp "
    # Mental Outlaw
    USE="-systemd -gnome -kde"
    # Xorg
    USE="X pam elogind harfbuzz truetype"
    # dwm
    USE="-gnome -kde -dvd -dvdr -cdr harfbuzz"

### Choose mirrors

    mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

### Repos configuration

    mkdir -p /mnt/gentoo/etc/portage/repos.conf
    cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

### Chroot prepare

Copy DNS info:

    cp -L /etc/resolv.conf /mnt/gentoo/etc/

Mount all required filesystems into chroot:

    mount --types proc /proc /mnt/gentoo/proc
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev
    mount --bind /run /mnt/gentoo/run
    mount --make-slave /mnt/gentoo/run
    
Mount shm filesystem:

    test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
    mount -t tmpfs -o nosuid,nodev,noexec shm /dev/shm
    chmod 1777 /dev/shm

Enter chroot:

    chroot /mnt/gentoo /bin/bash
    source /etc/profile
    
And run:

    export PS1="(chroot) $PS1"

Mounting the boot partition:

    mount /dev/sda2 /boot

Synchronize ebuild repository:

    emerge-webrsync

---

Возможные ошибки:

    !!! Section 'gentoo' in repos.conf has location attribute
    set to nonexistent directory: '/usr/portage'

    !!! Repository x-portage is missing masters attribute in
    /usr/portage/metadata/layout.conf

Увидев эти ошибки, я прервал операцию, нажав Ctrl + C, и сделал следующее:

    mkdir /usr/portage
    mkdir -p /usr/portage/metadata/ 
    nano -w /usr/portage/metadata/layout.conf

    /usr/portage/metadata/layout.conf 
    
и там написать

    masters = gentoo

После этого emerge-webrsync запустился без ошибок.

---

Choose and install correct profile:

    eselect profile list

Select profile [/desktop (stable)]:

    eselect profile set X

Update World

    emerge --verbose --update --deep --newuse @world

---

Если по какому-то пакету отругался, что надо поменять флаг, делаем следующее

    cd /etc/portage/
    rmdir package.use

А потом надо создать текстовик, но с тем же именем, с тем же каталогом

    nano -w /etc/portage/package.use

И там записать что надо делать по типу "ветка/имя_пакета флаги" -флаг - это
значит определённый модуль задействоваться не будет.

По факту это пересборка под профиль всего.

---

Setup the correct timezone:

    echo "Europe/Moscow" > /etc/timezone
    emerge --config sys-libs/timezone-data

Install Vim
    
    emerge vim

Configure locales:

    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
    echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
    echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
    echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen
    echo zh_CN.UTF-8 UTF-8 >> /etc/locale.gen

    locale-gen

Set default locale:

    eselect locale list
    
select en_US.UTF-8 locale:
    
    eselect locale set X
    
Update the environment:

    env-update && source /etc/profile
    
## Configure fstab

For consistent setup of the required partition, use the UUID identifier.

Run **blkid** and see partition IDs:

    blkid

*example:*
    
    /dev/sdb1: UUID="4F20-B9DB" TYPE="vfat" PARTLABEL="grub" PARTUUID="70b1627b-57e7-4559-877a-355184f0ab9d"
    /dev/sdb2: UUID="DB1D-89C5" TYPE="vfat" PARTLABEL="boot" PARTUUID="b2a61809-4c19-4685-8875-e7fdf645eec5"
    /dev/sdb3: UUID="6a7a642a-3262-4f87-9540-bcd53969343b" TYPE="crypto_LUKS" PARTLABEL="lvm" PARTUUID="be8e6694-b39c-4d2f-9f42-7ca455fdd64f"
    /dev/mapper/lvm: UUID="HL32bg-ZjrZ-RBo9-PcFM-DmaQ-QbrC-9HkNMk" TYPE="LVM2_member"
    /dev/mapper/vg0-root: UUID="6bedbbd8-cea9-4734-9c49-8e985c61c120" TYPE="ext4"
    /dev/mapper/vg0-home: UUID="5d6ff087-50ce-400f-91c4-e3378be23c00" TYPE="ext4"
    
Edit /etc/fstab and setup correct filesystem:

*example:*

    # <fs>                                          <mountpoint>    <type>          <opts>          <dump/pass>
    UUID=DB1D-89C5                                  /boot           vfat            noauto,noatime  1 2
    UUID=6bedbbd8-cea9-4734-9c49-8e985c61c120       /               ext4            defaults        0 1
    UUID={/dev/mapper/vg0-swap UUID}                none            swap            sw              0 0
    UUID=5d6ff087-50ce-400f-91c4-e3378be23c00       /home           ext4            defaults        0 1
    # tmps
    tmpfs                                           /tmp            tmpfs           size=4G         0 0

## 1. Configuring the Linux kernel manually

Package distributed alongside the Linux kernel that contains firmware binary blobs

    emerge sys-kernel/linux-firmware

If **All ebuilds that satisfy "sys-kernel/linux-firmware" have been masked** run:
    
    echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license

---

Consider installing

    emerge sys-apps/pciutils

---

Install kernel and cryptsetup

    emerge sys-kernel/gentoo-sources
    emerge sys-fs/cryptsetup
    
cd to kernel directory and make menuconfig

    cd /usr/src/linux- <- TAB

    make menuconfig
    
---

Modern processors, like Intel Core or AMD Ryzen, support AES-NI instruction
set. AES-NI significantly improves encryption/decryption performance. To enable
AES-NI support in the kernel:

    KERNEL AES-NI cipher algorithm
    
    --- Cryptographic API
       <*>   AES cipher algorithms (AES-NI)

---

**_Warning_**

When using a LUKS passphrase, double check that the kernel configuration has a
usable framebuffer configuration or else ensure text-only GRUB with text-only
payload and no **gfxterm**. Otherwise the LUKS passphrase prompt may not be
visible. Consult the graphic driver's setup. It may also be necessary to fix
Kernel's **keymap** if the passphrase contains special characters.

---

Optionally:

    KERNEL SHA-256 with NI instructions
    
    --- Cryptographic API
       <*>   SHA1 digest algorithm (SSSE3/AVX/AVX2/SHA-NI)
    │ │  
       <*>   SHA256 digest algorithm (SSSE3/AVX/AVX2/SHA-NI) 
       
---

## 2. Configuring the Linux kernel with genkernel

Package distributed alongside the Linux kernel that contains firmware binary blobs

    emerge sys-kernel/linux-firmware
    
If **All ebuilds that satisfy "sys-kernel/linux-firmware" have been masked** run:
    
    echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license
    
---

Consider installing

    emerge sys-apps/pciutils

---
    
Install kernel, genkernel, and cryptsetup packages:

    emerge sys-kernel/gentoo-sources
    emerge sys-kernel/genkernel
    
---

If **All ebuilds that satisfy "sys-kernel/linux-firmware" have been masked** run:

    emerge --ask sys-kernel/genkernel --autounmask
    dispatch-conf
    (u for use-new)
    emerge sys-kernel/genkernel

---
    
    emerge sys-fs/cryptsetup

Build genkernel:

    genkernel --luks --lvm --no-zfs all
    
---

If **ERROR:** kernel source directory "usr/src/linux" was not found!

    eselect kernel list
    eselect kernel set 1

---

Modern processors, like Intel Core or AMD Ryzen, support AES-NI instruction
set. AES-NI significantly improves encryption/decryption performance. To enable
AES-NI support in the kernel:

    KERNEL AES-NI cipher algorithm
    
    --- Cryptographic API
       <*>   AES cipher algorithms (AES-NI)

---

**_Warning_**

When using a LUKS passphrase, double check that the kernel configuration has a
usable framebuffer configuration or else ensure text-only GRUB with text-only
payload and no **gfxterm**. Otherwise the LUKS passphrase prompt may not be
visible. Consult the graphic driver's setup. It may also be necessary to fix
Kernel's **keymap** if the passphrase contains special characters.

---

Optionally:

    KERNEL SHA-256 with NI instructions
    
    --- Cryptographic API
       <*>   SHA1 digest algorithm (SSSE3/AVX/AVX2/SHA-NI)
    │ │  
       <*>   SHA256 digest algorithm (SSSE3/AVX/AVX2/SHA-NI) 
       
---
       
## Install GRUB2

    echo "sys-boot/grub:2 device-mapper" >> /etc/portage/package.use/sys-boot
    emerge -av grub
    
    ??? emerge --ask sys-boot/efibootmgr 
   
---

**Note for UEFI users:**
running the above command will output the enabled
GRUB_PLATFORMS values before emerging. When using UEFI capable systems, users
will need to ensure **_GRUB_PLATFORMS="efi-64"_** is enabled (as it is the case by
default). If that is not the case for the setup, **_GRUB_PLATFORMS="efi-64"_** will
need to be added to the /etc/portage/make.conf file *before* emerging GRUB2 so
that the package will be built with EFI functionality:
    
    echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
    emerge --ask sys-boot/grub
    
If GRUB2 was somehow emerged without enabling **_GRUB_PLATFORMS="efi-64"_**, the line
(as shown above) can be added to make.conf and then dependencies for the world
package set can be re-calculated by passing the --update --newuse_ options to
**emerge**: 
    
    emerge --ask --update --newuse --verbose sys-boot/grub

---
    
---

**FILE** /etc/default/grub

    GRUB_CMDLINE_LINUX="dolvm crypt_root=UUID=(REPLACE ME WITH sdb3 UUID from above)"

---

Don't forget to change "(REPLACE ME WITH sdb3 UUID from above)" to the actual value.

Mount boot:

    mount /boot
    
Install GRUB with EFI:

    grub-install --target=x86_64-efi --efi-directory=/boot
    
---

**_Note:_** Upon receiving the message "Could not prepare Boot variable: Read-only file system", try running:

    mount -o remount,rw /sys/firmware/efi/efivars

---

---

**_Note:_** For some old motherboards for GRUB run this command:

    mkdir -p /boot/efi/efi/boot
    cp /boot/efi/efi/gentoo/grubx64.efi /boot/efi/efi/boot/bootx64.efi
    
---

Make sure that /etc/default/grub is configured correctly. Especially with UEFI
GRUB and kernel might use different framebuffer drivers. Generate GRUB
configuration file:

    grub-mkconfig -o /boot/grub/grub.cfg
    
---

**_Note:_**
When using a LUKS passphrase and there is no visible prompt after loading the
initramfs, try typing the passphrase. If this continues loading try GRUB
without **gfxterm**/ in text-only mode. Depending on the BIOS it might help to boot
legacy first to check if there's a prompt at all.

---

## Finalizing

While in the chroot setup, it is important to remember to set the root password before rebooting:

    passwd

After the install is complete, add the LVM service to boot. If this is not
done, at the very least grub-mkconfig will throw "WARNING: Failed to connect to
lvmetad. Falling back to internal scanning."

    rc-update add lvm default

## 23. Создаём пользователя

    useradd -m -G users,wheel,audio,video -s /bin/bash {user_name}
    passwd {user_name}

## 24. Ставим sudo

    emerge --ask app-admin/sudo

    nano -w /etc/sudoers
    
Ищем строчку wheel ALL=(ALL:ALL) ALL - раскомментируем

Если нам потом кажут фигу, дописываем под root

    user ALL=(ALL:ALL) ALL

## 25. Почистим малость

    rm /stage3-* (добить Tab)

## 15. Имя машины 

    nano -w /etc/conf.d/hostname

    hostname="user_name"


## Net settings

    emerge net-misc/dhcpcd net-misc/netifrc
    
    rc-update add dhcpcd default
    rc-service dhcpcd start
    
    ifconfig

Lets assume interfaces names are eno1 and ln.

Add to /etc/conf.d/net:

    config_eno1="dhcp"

Add symlink to enable network at boot:

    ln -s net.lo net.eno1
    
    rc-update add net.eno1 default

## 17.	HOST
 
    vim /etc/hosts

setup

    127.0.0.1 имя_машины localhost
    ::1       localhost

## 19.	Настройка загрузки и автозагрузки

    vim /etc/conf.d/keymaps

setup

    keymap="us"
    windowkeys="YES"
    extended_keymaps=""
    dumpkeys_charset=""

## 20. Установка системных программ

Чтобы можно было залогиниться в систему:

    emerge --ask app-admin/sysklogd
    rc-update add sysklogd default

Утилита файловой системы ext4

    emerge --ask sys-fs/e2fsprogs

## 21. Выход и размонтирование

    exit

    umount -l /mnt/gentoo/dev{/shm,/pts,}
    umount /mnt/gentoo{/boot,/sys,/proc,}

Скрестим пальцы на ногах

    reboot

Если бандура завелась, выдыхаем, получаем root'a и едем дальше

## 22. Проверить сеть

    ifconfig

Итак, если после установки Gentoo обнаружится, что вместо eth0 Ethernet адаптер называется eno1, то действуем так:

Меняем config_eth0 → config_eno1 и routes_eno1 → routes_eth0 в /etc/conf.d/net. Можно вручную, можно командой:

    sed -i 's:eth0:eno1:g' /etc/conf.d/net

Затем выполняем

    ln -s net.lo net.eno1
    rm /etc/init.d/net.eth0
    rc-update add net.eno1 default
    rc-update del net.eth0 

## 26.	INPUT_DEVICES

Для поддержки тачпада нужен synaptics - это у кого ноут

    /etc/portage/make.conf	

    INPUT_DEVICES="evdev synaptics"
    
## OpenSSH

Add the OpenSSH daemon to the default runlevel:

    rc-update add sshd default
    
Start the sshd daemon with:

    rc-service sshd start
    
## Cron

    emerge --ask sys-process/cronie
    rc-update add cronie default

## File indexing

    emerge --ask sys-apps/mlocate

## Optional: Install wireless networking tools

If the system will be connecting to wireless networks, install the
net-wireless/iw package for Open or WEP networks and/or the
net-wireless/wpa_supplicant package for WPA or WPA2 networks. iw is also a
useful basic diagnostic tool for scanning wireless networks.

    emerge --ask net-wireless/iw net-wireless/wpa_supplicant
