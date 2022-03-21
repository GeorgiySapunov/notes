### Fdisk

    fdisk /dev/sdX/

    /dev/sdc1     2048      22527      20480    10M BIOS boot
    /dev/sdc2    22528    2119679    2097152     1G EFI System
    /dev/sdc3  2119680 1953523678 1951403999 930.5G Linux filesystem

    NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sda      8:0    0 465.8G  0 disk
    └─sda1   8:1    0 465.8G  0 part /home/gs/hdd
    sdb      8:16   0 238.5G  0 disk
    ├─sdb1   8:17   0     1G  0 part /boot
    ├─sdb2   8:18   0   128G  0 part /
    └─sdb3   8:19   0 109.5G  0 part /home
    sdc      8:32   0 931.5G  0 disk
    ├─sdc1   8:33   0    10M  0 part
    ├─sdc2   8:34   0     1G  0 part
    └─sdc3   8:35   0 930.5G  0 part

    d - delete a partition
    p - print the partition table
    n - add a new partition
    Last sector:
    +10M (BIOS boot)
    +1G (UEFI boot)
    (root)
    w - write table to disk and exit

    mkfs.fat -F32 /dev/sdc2
    cryptsetup luksFormat /dev/sdc3
    cryptsetup open /dev/sdc3 cryptroot
    mkfs.ext4 /dev/mapper/cryptroot
    mount /dev/mapper/cryptroot /mnt
    mkdir /mnt/boot
    mount /dev/sdc2 /mnt/boot

#### without encryption UEFI

    d - delete a partition
    p - print the partition table
    n - add a new partition
    Last sector:
    +1G (UEFI boot)
    +90G (root)
    (home)
    w - write table to disk and exit

    mkfs.fat -F32 /dev/sdX1
    mkfs.ext4 /dev/sdX2
    mkfs.ext4 /dev/sdX3
    mount /dev/sdX2 /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount /dev/sdX1 /mnt/boot
    mount /dev/sdX3 /mnt/home

### Installation

    basestrap /mnt base base-devel runit elogind-runit linux linux-firmware vim
    fstabgen -U /mnt >> /mnt/etc/fstab
    artix-chroot /mnt
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
    hwclock --systohc

    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
    echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
    echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
    echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen
    echo zh_CN.UTF-8 UTF-8 >> /etc/locale.gen

    echo KEYMAP=ru >> /etc/vconsole.conf
    echo FONT=cyr-sun16 >> /etc/vconsole.conf

    locale-gen

    echo LANG=en_US.UTF-8 >> /etc/locale.conf
    echo portable >> /etc/hostname
    echo "127.0.0.1    localhost" >> /etc/hosts
    echo "::1          localhost" >> /etc/hosts
    echo "127.0.0.1    portable.localdomain portable" >> /etc/hosts

    pacman -S --noconfirm networkmanager networkmanager-runit grub efibootmgr cryptsetup

    pacman -S --noconfirm bluez bluez-utils bluez-runit cups cups-runit git pipewire pipewire-pulse wget openssh openssh-runit cronie cronie-runit tor torsocks tor-runit artix-keyring artix-archlinux-support

    pacman-key --populate archlinux

    vim /etc/pacman.conf

    ln -s /etc/runit/sv/NetworkManager/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/bluetoothd/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/cupsd/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/sshd/ /etc/runit/runsvdir/default/
    ln -s /etc/runit/sv/cronie/ /etc/runit/runsvdir/default/
    ln -s /etc/runit/sv/tor/ /etc/runit/runsvdir/default/

    passwd

### Mkinitcpio

    vim /etc/mkinitcpio.conf
    add encrypt after block in line ^HOOKS:

    echo $(grep ^HOOKS /etc/mkinitcpio.conf | grep encrypt) || HOOKS=$(grep ^HOOKS /etc/mkinitcpio.conf) ; HOOKS2=$(echo $HOOKS | sed "s/block/block encrypt/g") ; sed -i "s/$(echo $HOOKS)/$(echo $HOOKS2)/g" /etc/mkinitcpio.conf

    mkinitcpio -p linux

#### GRUB portable (LEGACY and UEFI) with crypt

    grub-install --target=i386-pc --boot-directory=/boot /dev/sdX
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --recheck

    grub=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet\""); grub2=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=$(echo $(blkid | grep sdc3 | awk $'{print $2}' | sed "s/\"//g")):cryptroot root=\/dev\/mapper\/cryptroot\""); sed -i "s/$(echo "$grub")/$(echo "$grub2")/g" /etc/default/grub

    grub-mkconfig -o /boot/grub/grub.cfg

#### GRUB only UEFI without crypt

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

    grub-mkconfig -o /boot/grub/grub.cfg

### Make a user

    useradd -mG wheel gs
    passwd gs

    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm

### Video drivers and xorg

    pacman -S --noconfirm mesa
    pacman -S --noconfirm xf86-video-intel xf86-video-nouveau
    pacman -S --noconfirm xf86-video-amdgpu xf86-video-ati xf86-video-vesa
    pacman -S --noconfirm xorg-server xf86-input-libinput libinput xorg-xinit xorg-xbacklight xorg-xprop xorg-xdpyinfo neofetch
    pacman -S --noconfirm xorg-xwininfo

    exit
    umount -a

### Packages

    pacman -S --noconfirm reflector pulsemixer pamixer

    reflector -c Russia -c China -c Switzerland -c France -a 12 --sort rate --save /etc/pacman.d/mirrorlist-arch
     curl https://gitea.artixlinux.org/packagesA/artix-mirrorlist/raw/branch/master/trunk/mirrorlist -o /etc/pacman.d/mirrorlist

    pacman -S --noconfirm neovim zsh nano artix-live-base rsm
    pacman -S --noconfirm noto-fonts-emoji noto-fonts ttf-liberation ttf-font-awesome ttf-joypixels
    pacman -S --noconfirm libertinus-font adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts
    pacman -S --noconfirm dosfstools libnotify dunst exfat-utils ffmpeg gnome-keyring mpd mpv man-db ntfs-3g maim unrar unzip p7zip xclip yt-dlp mediainfo fzf sxhkd gimp inkscape moreutils newsboat
    pacman -S --noconfirm texlive-most texlive-lang biber
    pacman -S --noconfirm sxiv xwallpaper mpc ncmpcpp unclutter xdotool zathura zathura-pdf-mupdf zathura-djvu bat blender bmon testdisk


### Suckless installation

    cd /home/gs/.local/src/dwm
    make clean install
    cd /home/gs/.local/src/dmenu
    make clean install
    cd /home/gs/.local/src/st
    make clean install

### Everything after this is under user gs

    sudo su - gs

### Paru

     cd /home/gs/git
     git clone https://aur.archlinux.org/paru.git
     cd paru
     makepkg -si

### Make configs

    sudo nvim /etc/paru.conf
    sudo nvim /usr/lib/elogind/system-sleep/lock.sh

    sudo chmod +x /usr/lib/elogind/system-sleep/lock.sh

## Luke's settings
### Installing \`libxft-bgra\` to enable color emoji in suckless software without crashes

    paru -S libxft-bgra

### Synchronizing system time

    sudo pacman -S ntp
    sudo ntpdate 0.us.pool.ntp.org

### Use all cores for compilation.

    sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

### Most important command! Get rid of the beep!

    rmmod pcspkr
    sudo mkdir -p /etc/modprobe.d
    sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

### Make zsh the default shell for the user.

    sudo chsh -s /bin/zsh gs
    sudo -u gs mkdir -p "/home/gs/.cache/zsh/"

### dbus UUID must be generated for Artix runit.

    sudo mkdir -p /var/lib/dbus
    sudo dbus-uuidgen > /var/lib/dbus/machine-id

### (just copy /etc/X11) Tap to click
### (sudo cp /etc/X11/xorg.conf.d/* /mnt/etc/X11/xorg.conf.d/)

    [ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
            Identifier "libinput touchpad catchall"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Driver "libinput"
    	# Enable left mouse button by tapping
    	Option "Tapping" "on"
    EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

## Personal
### Packages

    sudo pacman -S --noconfirm pcmanfm xcape fcitx-im fcitx-configtool fcitx-mozc neomutt isync msmtp lynx notmuch libbluray libaacs libreoffice tldr tldr ipython python-pip tmate calcurse r tk syncthing rsync python-black jupyterlab python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib ueberzug lxappearance arc-gtk-theme python-qdarkstyle
    sudo pacman -S --noconfirm ttf-opensans ttf-arphic-ukai ttf-arphic-uming ttf-baekmuk ttf-hannom
    pacman -S --noconfirm polkit polkit-qt5

    paru -S atool
    paru -S lf brave-bin sc-im-git zsh-fast-syntax-highlighting-git task-spooler simple-mtpfs xkb-switch latex-mk obfs4proxy-bin abook
    paru -S ttf-ms-fonts ttf-cmu-serif ttf-cmu-sans-serif ttf-cmu-bright ttf-cmu-concrete ttf-cmu-typewriter nerd-fonts-hack ttf-sazanami-hanazono ttf-paratype ttf-dejavu ttf-hack
    paru -S urlview mutt-wizard-git betterlockscreen xidlehook write-good perl-file-mimeinfo htop-vim


    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser
    paru -S scidavis
    paru -S anki-bin

### pip

    pip install jupyterlab-vim

### Wi-fi adapter Archer T4UH v2

    sudo pacman -S --noconfirm linux-headers
    paru -S rtl8814au-dkms-git

### Language servers

    sudo pacman -S pyright
   #sudo pacman -S rust-analyzer
   #paru -S typescript-language-server

In R:

    install.packages("languageserver")

### (just copy /usr/lib/elogind/system-sleep) Sleep settings

    sudo nvim /usr/lib/elogind/system-sleep/lock.sh


                    #!/bin/sh
                    # /lib/elogind/system-sleep/lock.sh
                    # Lock before suspend integration with elogind

                    username=gs
                    userhome=/home/$username
                    export XAUTHORITY="$userhome/.Xauthority"
                    export DISPLAY=":0.0"
                    case "${1}" in
                        pre) su $username -c "fcit-remote -c; betterlockscreen -l" &
                            sleep 1s;
                            ;;
                    esac

    sudo chmod +x /usr/lib/elogind/system-sleep/lock.sh

### Picom

    paru -S picom-ibhagwan-git
    picom --config ~/.config/picom.conf

### crontab -e

    */15 * * * * ~/.local/bin/cron/newsup

### Blu-ray (aacs)

    https://wiki.archlinux.org/title/Blu-ray
