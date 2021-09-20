### Fdisk

    fdisk /dev/sdc/

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

    mkfs.fat -F32 /dev/sdc2
    cryptsetup luksFormat /dev/sdc3
    cryptsetup open /dev/sdc3 cryptroot
    mkfs.ext4 /dev/mapper/cryptroot
    mount /dev/mapper/cryptroot /mnt
    mkdir /mnt/boot
    mount /dev/sdc2 /mnt/boot

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

    pacman -S --noconfirm networkmanager networkmanager-runit grub efibootmgr cryptsetup mkinitcpio
    pacman -S --noconfirm bluez bluez-utils bluez-runit cups cups-runit git reflector alsa-utils pulseaudio pulsemixer pulseaudio-alsa pamixer wget curl ca-certificates openssh openssh-runit cronie cronie-runit

    ln -s /etc/runit/sv/NetworkManager/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/bluetoothd/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/cupsd/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/sshd/ /etc/runit/runsvdir/default/
    ln -s /etc/runit/sv/cronie/ /etc/runit/runsvdir/default/

    passwd

### Mkinitcpio and grub

    vim /etc/mkinitcpio.conf
    add encrypt after block in line ^HOOKS:     echo $(grep ^HOOKS /etc/mkinitcpio.conf | grep encrypt) || HOOKS=$(grep ^HOOKS /etc/mkinitcpio.conf) ; HOOKS2=$(echo $HOOKS | sed "s/block/block encrypt/g") ; sed -i "s/$(echo $HOOKS)/$(echo $HOOKS2)/g" /etc/mkinitcpio.conf

    mkinitcpio -p linux
    grub-install --target=i386-pc --boot-directory=/boot /dev/sdc
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --recheck

    grub=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet\""); grub2=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=$(echo $(blkid | grep sdc3 | awk $'{print $2}' | sed "s/\"//g")):cryptroot root=\/dev\/mapper\/cryptroot\""); sed -i "s/$(echo "$grub")/$(echo "$grub2")/g" /etc/default/grub

    grub-mkconfig -o /boot/grub/grub.cfg
    useradd -mG wheel gs
    passwd gs

    EDITOR=vim visudo

### Video drivers and xorg

    pacman -S --noconfirm xf86-video-intel xf86-video-amdgpu xf86-video-nouveau xf86-video-ati xf86-video-vesa
    pacman -S --noconfirm xorg-server xf86-input-libinput libinput xorg-xwininfo xorg-xinit	xorg-xbacklight xorg-xprop xorg-xdpyinfo neofetch
    exit
    umount -a

### Packages

    pacman -S --noconfirm neovim zsh nano artix-live-base rsm
    pacman -S --noconfirm ttf-linux-libertine noto-fonts-emoji ttf-liberation adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts
    pacman -S --noconfirm dosfstools libnotify dunst exfat-utils sxiv xwallpaper ffmpeg gnome-keyring mpc mpd mpv man-db ncmpcpp ntfs-3g maim unclutter unrar unzip p7zip xclip xdotool youtube-dl zathura zathura-pdf-mupdf mediainfo atool fzf highlight texlive-most biber sxhkd gimp inkscape blender artix-keyring artix-archlinux-support bmon moreutils

### Suckless download

     mkdir -p /home/gs/.local/src
     cd /home/gs/.local/src
     git clone https://git.suckless.org/dwm
     git clone https://git.suckless.org/dmenu
     git clone https://git.suckless.org/st
     https://github.com/LukeSmithxyz/dwmblocks.git

### Xprofile and zprofile

    ln -s /home/gs/.config/shell/profile .zprofile
    ln -s /home/gs/.config/X11/xprofile .xprofile

### Suckless installation

    cd /home/gs/.local/src/dwm
    make clean install
    cd /home/gs/.local/src/dmenu
    make clean install
    cd /home/gs/.local/src/st
    make clean install

### Everything after this is under user gs

### Paru

     cd /home/gs
     git clone https://aur.archlinux.org/paru.git
     cd paru
     makepkg -si

## Luke's settings
### Installing \`libxft-bgra\` to enable color emoji in suckless software without crashes

    paru libxft-bgra-git

### Synchronizing system time

    ntpdate 0.us.pool.ntp.org

### Make pacman and paru colorful and adds eye candy on the progress bar because why not.

    grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
    grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

### Use all cores for compilation.

    sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

### Most important command! Get rid of the beep!

    rmmod pcspkr
    echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

### Make zsh the default shell for the user.

    chsh -s /bin/zsh gs >/dev/null 2>&1
    sudo -u gs mkdir -p "/home/gs/.cache/zsh/"

### dbus UUID must be generated for Artix runit.

    dbus-uuidgen > /var/lib/dbus/machine-id

### Tap to click

    [ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
            Identifier "libinput touchpad catchall"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Driver "libinput"
    	# Enable left mouse button by tapping
    	Option "Tapping" "on"
    EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

### Fix fluidsynth/pulseaudio issue.

    grep -q "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" /etc/conf.d/fluidsynth || echo "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" >> /etc/conf.d/fluidsynth

### Start/restart PulseAudio.

    pkill -15 -x 'pulseaudio'; sudo -u "$name" pulseaudio --start

### This line, overwriting the `newperms` command above will allow the user to run serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.

    newperms "%wheel ALL=(ALL) ALL
    %wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm"

## Personal
### Packages

    sudo pacman -S --noconfirm pcmanfm xcape fcitx-im fcitx-configtool fcitx-mozc neomutt isync msmtp lynx notmuch abook libbluray libaacs libreoffice tor torsocks tldr texlive-lang tldr htop anki ipython python-pip tmate texlab calcurse r tk syncthing rsync

    paru -S lf lxappearance arc-gtk-theme brave-bin sc-im-git zsh-fast-syntax-highlighting task-spooler simple-mtpfs htop-vim-git xkb-switch
    paru -S ttf-liberation ttf-linux-libertine ttf-ms-fonts ttf-opensans ttf-arphic-ukai ttf-arphic-uming ttf-baekmuk ttf-hannom ttf-cmu-serif ttf-cmu-sans-serif ttf-cmu-bright ttf-cmu-concrete ttf-cmu-typewriter ttf-hack-ibx ttf-sazanami-hanazono ttf-paratype latex-mk
    paru -S urlview mutt-wizard-git scidavis tor-browser betterlockscreen write-good perl-file-mimeinfo

### For wi-fi adapter Archer T4UH v2

    sudo pacman -S --noconfirm linux-headers
    paru -S rtl8814au-dkms-git

### Language servers

    paru -S tsserver rust-analyzer

In R:

    install.packages("languageserver")

In bash:

    npm i -g pyright

### Sleep settings

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
