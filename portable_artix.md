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

    mkfs.fat -F32 /dev/sdX2
    cryptsetup luksFormat /dev/sdX3
    cryptsetup open /dev/sdX3 cryptroot
    mkfs.ext4 /dev/mapper/cryptroot
    mount /dev/mapper/cryptroot /mnt
    mkdir /mnt/boot
    mount /dev/sdX2 /mnt/boot

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
    pacman -S --noconfirm polkit polkit-qt5

    pacman -S --noconfirm bluez bluez-utils bluez-runit cups cups-runit git wireplumber pipewire-pulse man-db
    pacman -S --noconfirm wget openssh openssh-runit cronie cronie-runit tor torsocks tor-runit artix-keyring artix-archlinux-support

    pacman-key --populate archlinux

    vim /etc/pacman.conf

    ln -s /etc/runit/sv/NetworkManager/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/bluetoothd/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/cupsd/ /etc/runit/runsvdir/default
    ln -s /etc/runit/sv/sshd/ /etc/runit/runsvdir/default/
    ln -s /etc/runit/sv/cronie/ /etc/runit/runsvdir/default/
    ln -s /etc/runit/sv/tor/ /etc/runit/runsvdir/default/
    ln -s /etc/runit/sv/ntpd/ /etc/runit/runsvdir/default/

    ln -s /etc/runit/sv/bumblebeed /etc/runit/runsvdir/default
    (
    sudo ln -s /etc/runit/sv/bumblebeed /run/runit/service/bumblebeed
    )

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

    useradd -mg wheel gs
    passwd gs

    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm

### Video drivers and xorg

    pacman -S --noconfirm mesa
    pacman -S --noconfirm xf86-video-intel xf86-video-nouveau
    pacman -S --noconfirm xf86-video-amdgpu xf86-video-ati xf86-video-vesa
    pacman -S --noconfirm xorg-server xorg-xwininfo xorg-xinit xorg-xbacklight xorg-xprop xorg-xdpyinfo arandr
    pacman -S --noconfirm xf86-input-libinput libinput

    Proprietary nvidia driver instead of nouveu:
    pacman -S --noconfirm nvidia lib32-nvidia-utils cuda vulkan-tools

    pacman -S --noconfirm nvidia-prime
    or
    pacman -S --noconfirm bumblebe

    %%exit
    %%umount -a

### Packages

##### pacman

    pacman -S --noconfirm reflector

    reflector -c Russia -c China -c Switzerland -c France -a 12 --sort rate --save /etc/pacman.d/mirrorlist-arch
     curl https://gitea.artixlinux.org/packagesA/artix-mirrorlist/raw/branch/master/trunk/mirrorlist -o /etc/pacman.d/mirrorlist

    %% rms: Runit service manager
    pacman -S --noconfirm rsm
    pacman -S --noconfirm artix-live-base
    pacman -S --noconfirm gnome-keyring

    pacman -S --noconfirm zsh tmux
    pacman -S --noconfirm zsh-completions zoxide
    sh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh)

    pacman -S --noconfirm pulsemixer
    pacman -S --noconfirm dosfstools exfat-utils ntfs-3g

##### dwm

    pacman -S --noconfirm libnotify dunst
    pacman -S --noconfirm maim xclip
    pacman -S --noconfirm xwallpaper unclutter xdotool xcape bmon

    pacman -S --noconfirm ffmpeg mpd mpv mpc ncmpcpp newsboat sxiv calcurse
    pacman -S --noconfirm zathura zathura-pdf-mupdf zathura-djvu pdfpc

    pacman -S --noconfirm gimp inkscape blender libreoffice nano pcmanfm
    pacman -S --noconfirm texlive-most texlive-lang biber

    pacman -S --noconfirm mediainfo fzf sxhkd
    pacman -S --noconfirm testdisk yt-dlp moreutils

##### neovim

    pacman -S --noconfirm neovim
    pacman -S --noconfirm lazygit ncdu ripgrep luarocks

#### Fonts

    pacman -S --noconfirm noto-fonts-emoji noto-fonts noto-fonts-cjk ttf-liberation ttf-font-awesome ttf-joypixels
    pacman -S --noconfirm libertinus-font adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts
    pacman -S --noconfirm adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts
    pacman -S --noconfirm ttf-opensans ttf-arphic-ukai ttf-arphic-uming ttf-baekmuk ttf-hannom


### Suckless installation

    cd /home/gs/.local/src/dwm
    make clean install
    cd /home/gs/.local/src/dmenu
    make clean install
    cd /home/gs/.local/src/st
    make clean install
    cd /home/gs/.local/src/dwmblocks
    make clean install

### Everything after this is under user gs

    sudo su - gs

### Paru

     cd /home/gs/git
     git clone https://aur.archlinux.org/paru.git
     cd paru
     makepkg -si

### Make configs (see "Should be done")

    sudo nvim /etc/paru.conf

## Luke's settings
### Synchronizing system time

    sudo pacman -S ntp ntp-runit
    sudo ntpd -q -g

### Use all cores for compilation.

sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

### Most important command! Get rid of the beep!

    rmmod pcspkr
    sudo mkdir -p /etc/modprobe.d
    sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

### Make zsh the default shell for the user.

    sudo chsh -s /bin/zsh gs
    sudo -u gs mkdir -p "/home/gs/.cache/zsh/"

### dbus UUID must be generated for Artix runit.

    %%sudo mkdir -p /var/lib/dbus

        %%dbus-uuidgen
        %%sudo nvim /var/lib/dbus/machine-id

    %%dbus-uuidgen > /var/lib/dbus/machine-id

### Tap to click (just copy /etc/X11)
### (sudo cp /etc/X11/xorg.conf.d/* /mnt/etc/X11/xorg.conf.d/)

    %%[ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
            %%Identifier "libinput touchpad catchall"
            %%MatchIsTouchpad "on"
            %%MatchDevicePath "/dev/input/event*"
            %%Driver "libinput"
        %%# Enable left mouse button by tapping
        %%Option "Tapping" "on"
    %%EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

## Personal
### Packages

##### pacman

    sudo pacman -S --noconfirm ibus

    sudo pacman -S --noconfirm libbluray libaacs
    sudo pacman -S --noconfirm tmate syncthing rsync neofetch

    sudo pacman -S --noconfirm lxappearance qt5-styleplugins arc-gtk-theme python-qdarkstyle papirus-folders-nordic
    sudo pacman -S --noconfirm okular breeze-icons

##### python

    sudo pacman -S --noconfirm ipython python-pip python-black flake8 stylua jupyterlab
    sudo pacman -S --noconfirm python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib

##### paru

    paru -S task-spooler simple-mtpfs urlview

    paru -S brave-bin sc-im-git telegram-desktop latex-mk write-good htop-vim tldr++ exa
    paru -S anki cozy-audiobooks

    paru -S betterlockscreen xidlehook
    betterlockscreen -u ~/.local/share/wallpaper.jpg

    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser obfs4proxy-bin

##### Fonts

    paru -S ttf-ms-fonts ttf-cmu-serif ttf-cmu-sans-serif ttf-cmu-bright ttf-cmu-concrete
    paru -S ttf-cmu-typewriter nerd-fonts-hack ttf-sazanami-hanazono ttf-paratype ttf-dejavu

##### lf with ueberzug

    paru -S lf atool perl-file-mimeinfo
    sudo pacman -S --noconfirm ueberzug ffmpegthumbnailer bat

##### lf with kitty

    paru -S lf atool perl-file-mimeinfo
    sudo pacman -S --noconfirm ffmpegthumbnailer bat

##### neomutt

    sudo pacman -S --noconfirm neomutt isync msmtp lynx notmuch
    paru -S abook
    paru -S mutt-wizard-git

### Pam-gnupg

    paru -S pam-gnupg

    echo UPDATESTARTUPTTY | gpg-connect-agent
    shh-add

    add keygrips to .config/pam-gnupg
    for gpg:
    gpg -K --with-keygrip
    for ssh:
    gpg-connect-agent 'keyinfo --ssh-list' /bye

### Torrent

    sudo pacman -S --noconfirm transmission-cli
    paru -S stig

### Virtualbox

    sudo pacman -S virtualbox virtualbox-host-modules-artix

### Gramps

    sudo pacman -S gramps python-pyicu osm-gps-map

### hyprland

   paru -S hyprland waybar wofi wl-clipboard

### Neovim

    :LspInstallInfo
    1. pyright
    2. sumneko_lua
    3. texlab
    4. jsonls
    5. bashls

    :DIInstall python

    :DIInstall <debugger> installs <debugger>.
    :DIUninstall <debugger> uninstalls <debugger>.
    :DIList lists installed debuggers.

### Wi-fi adapter Archer T4UH v2

    sudo pacman -S --noconfirm linux-headers
    paru -S rtl8814au-dkms-git


### Sleep settings (just copy /usr/lib/elogind/system-sleep)

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

### To do:

##### Should be done:

    sudo cp /etc/X11/xorg.conf.d/* /mnt/etc/X11/xorg.conf.d/
    sudo cp /etc/pacman.conf /mnt/etc/pacman.conf
    sudo cp /etc/paru.conf /mnt/etc/paru.conf
    sudo cp usr/lib/elogind/system-sleep/lock.sh mnt/usr/lib/elogind/system-sleep/lock.sh
    sudo chmod +x mnt/usr/lib/elogind/system-sleep/lock.sh

##### Copy aacs for blue-ray

    cp -r ~/.config/aacs /mnt/home/gs/.config/

    https://wiki.archlinux.org/title/Blu-ray

##### Copy ssh and gpg keys

    cp -r ~/.ssh /mnt/home/gs/
    cp -r ~/.local/share/password-store /mnt/home/gs/.local/share

##### Copy ~/.config/mpd/playlists and specify Music folder

    cp -r ~/.config/mpd/playlists /mnt/home/gs/.config/mpd

##### Setup torrc

    sudo cp /etc/tor/torrc /mnt/etc/tor/torrc

##### Also

    1. lxappearance, brave, anki, telegram-desktop, abook, calcurse, mutt
    2. dbus UUID must be generated for Artix runit.

##### Xorg/Wayland

    xorg-server
    xorg-xwininfo
    xorg-xinit
    xorg-xbacklight                  xbacklight (backlight management) → light / brightnessctl
    xorg-xprop
    xorg-xdpyinfo

                                     xrandr → swaymsg output …, wlr-randr
    xf86-input-libinput
    libinput

    libnotify
    dunst                            dunst (notification daemon) → dunst (supports wayland) / mako / fnott / swaync
    betterlockscreen
    i3lock                           swaylock
    (feh)                            feh (wallpaper setting) → sway output configuration, see man 5 sway-output (or oguri, which supports animated wallpapers)
    xidlehook
    maim                             scrot (screenshot) → grim + slurp (or grimshot, which wraps around both).
    xclip                            xclip / xsel (clipboard copy/paste) → wl-clipboard, wl-clipboard-rs, wayclip
    xwallpaper                       feh (wallpaper setting) → sway output configuration, see man 5 sway-output (or oguri, which supports animated wallpapers)
    unclutter                        unclutter (hiding cursor after some time) → seat <name> hide_cursor <timeout>
    xdotool                          xdotool → wtype, wlrctl, swaymsg seat <seat> cursor …, ydotool
    xcape (remaps)                   keyd, KMonad.
    st                               Alacritty, kitty
    sxiv
    zathura zathura-pdf-mupdf zathura-djvu
    pdfpc
    fcitx-im fcitx-configtool fcitx-mozc
    lxappearance arc-gtk-theme python-qdarkstyle papirus-folders-nordic
    okular
    ueberzug                         kitty (https://github.com/gokcehan/lf/issues/437
                                            https://gist.github.com/Provessor/e4ee757e6c424083ca3c6441fe6ab9ac
                                            https://github.com/gokcehan/lf/wiki/Previews)
    ffmpegthumbnailer
    dmenu                            dmenu → wmenu, bemenu, fuzzel, gmenu, wldash
                                     bemenu: To use the same color scheme used in dmenu, use bemenu-run -p "" --tb "#285577" --hb "#285577" --tf "#eeeeee" --hf "#eeeeee" --nf "#bbbbbb"
    sxhkd                            sxhkd (an X daemon that reacts to input events by executing commands), shkd (a simple hotkey daemon for the Linux console. ) → swhkd

    To emulate xset dpms force off, use swayidle timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' then run pkill -USR1 swayidle to trigger timeout immediately.
    Use the output command to configure outputs instead of xrandr
    Use the output command to configure your wallpaper instead of feh
    Use the input command to configure input devices

### waybar

        "custom/sb-news": {
        "signal": 6,
        "interval": "once",
        "exec": "sb-news",
        "max-length": 5,
        "format": " {}",
        "on-click": "setsid \"$TERMINAL\" -e newsboat",
        "on-click-middle": "setsid -f newsup >/dev/null exit",
        "on-right-click": ""
    },
    "custom/sb-mailbox": {
        "signal": 12,
        "interval": "once",
        "exec": "sb-mailbox",
        "max-length": 5,
        "format": " {}",
        "on-click": "setsid -f \"$TERMINAL\" -e neomutt",
        "on-click-middle": "setsid -f mw -Y >/dev/null",
        "on-right-click": ""
    },
    "custom/sb-torrent": {
        "signal": 7,
        "interval": "once",
        "exec": "sb-torrent",
        "max-length": 10,
        "format": " {}",
        "on-click": "setsid -f \"$TERMINAL\" -e tremc",
        "on-click-middle": "td-toggle",
        "on-right-click": ""
    },
