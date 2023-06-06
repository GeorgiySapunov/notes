# Gentoo installation checklist

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

Crypt physical volume group (to activate: vgchange -ay vg0):

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

### Artix installation

Create mount point:

    mkdir /mnt

Mount the root filesystem from the encrypted LVM partition:

    mount /dev/mapper/vg0-root /mnt

And switch into /mnt/gentoo:

    cd /mnt

---
**Note:**
If you are making changes to the home partition (like adding a user) in the chroot

    mkdir /mnt/home
    mount /dev/mapper/vg0-home /mnt/home/

    mkdir /mnt/boot
    mount /dev/sdX2 /mnt/boot
---


### Installation

    basestrap /mnt base base-devel openrc elogind-openrc linux linux-firmware vim
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

    echo hostname='portable' >> /etc/conf.d/hostname

    pacman -S --noconfirm networkmanager networkmanager-openrc grub efibootmgr cryptsetup lvm2 \
    polkit polkit-qt5 \
    bluez bluez-utils bluez-openrc cups cups-openrc git wireplumber \
    pipewire-pulse pipewire artix-pipewire-loader man-db \
    wget openssh openssh-openrc cronie cronie-openrc tor torsocks tor-openrc artix-keyring

    vim /etc/pacman.d/mirrorlist-arch
    vim /etc/pacman.conf

    pacman -S --noconfirm artix-archlinux-support

    pacman-key --populate archlinux

    rc-update add sshd default
    rc-update add cronie default
    rc-update add cupsd default
    rc-update add bluetoothd default
    rc-update add NetworkManager default
    rc-update add tor default
    rc-update add cronie default

    rc-service sshd start
    rc-service cronie start
    rc-service cupsd start
    rc-service bluetoothd start
    rc-service NetworkManager start
    rc-service tor start
    rc-service cronie start

    passwd

### Mkinitcpio

    vim /etc/mkinitcpio.conf
    add encrypt lvm2 after block in line ^HOOKS

    mkinitcpio -p linux

#### GRUB portable (LEGACY and UEFI) with crypt

    vim /etc/default/grub
    
    add:

?    <!-- GRUB_CMDLINE_LINUX="dolvm crypt_root=UUID=(REPLACE ME WITH sdX3 UUID from blkid)" -->

    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=(REPLACE ME WITH sdX3 UUID from blkid):lvm root=/dev/mapper/vg0-root"

    grub-install --target=i386-pc --boot-directory=/boot /dev/sdX
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --recheck


    grub-mkconfig -o /boot/grub/grub.cfg

#### GRUB only UEFI without crypt

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

    grub-mkconfig -o /boot/grub/grub.cfg

### Make a user

    useradd -mg wheel gs
    passwd gs

    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
??
    %wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm

### Video drivers

    pacman -S --noconfirm mesa
    pacman -S --noconfirm xf86-video-intel xf86-video-nouveau
    pacman -S --noconfirm xf86-video-amdgpu xf86-video-ati xf86-video-vesa

    %%exit
    %%umount -a

### Packages

##### pacman

    pacman -S --noconfirm reflector rsync

    reflector -c Russia -c China -c Switzerland -c France -a 12 --sort rate --save /etc/pacman.d/mirrorlist-arch
     curl https://gitea.artixlinux.org/packagesA/artix-mirrorlist/raw/branch/master/trunk/mirrorlist -o /etc/pacman.d/mirrorlist

    pacman -S --noconfirm artix-live-base gnome-keyring

    pacman -S --noconfirm zsh tmux zsh-completions zoxide
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

    pacman -S --noconfirm pulsemixer dosfstools exfat-utils ntfs-3g kitty


    pacman -S --noconfirm bmon dunst

##### programs

    pacman -S --noconfirm ffmpeg mpd mpv mpc ncmpcpp newsboat sxiv calcurse \
    zathura zathura-pdf-mupdf zathura-djvu pdfpc \
    gimp inkscape blender libreoffice nano pcmanfm \
    texlive-most texlive-lang biber \
    mediainfo fzf \
    testdisk yt-dlp moreutils

##### neovim

    pacman -S --noconfirm neovim \
    lazygit ncdu ripgrep luarocks

#### Fonts

    pacman -S --noconfirm noto-fonts-emoji noto-fonts noto-fonts-cjk ttf-liberation ttf-font-awesome ttf-joypixels \
    libertinus-font adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts \
    adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts \
    ttf-opensans ttf-arphic-ukai ttf-arphic-uming ttf-baekmuk ttf-hannom


### Everything after this is under user georgiy

    sudo su - georgiy

### Paru

     cd /home/georgiy/git
     git clone https://aur.archlinux.org/paru.git
     cd paru
     makepkg -si

### Make configs (see "Should be done")

    sudo nvim /etc/paru.conf

## Luke's settings
<!-- ### Synchronizing system time -->
<!---->
<!--     sudo pacman -S ntp ntp-openrc -->
<!--     sudo ntpd -q -g -->

### Use all cores for compilation.

sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

### Make zsh the default shell for the user.

    sudo chsh -s /bin/zsh georgiy
    sudo -u georgiy mkdir -p "/home/georgiy/.cache/zsh/"

## Personal
### Packages

    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

##### pacman

    sudo pacman -S --noconfirm fcitx5-gtk fcitx5-qt fcitx5 fcitx5-configtool \
    libbluray libaacs \
    tmate syncthing neofetch stow \
    okular

?
    lxappearance qt5-styleplugins arc-gtk-theme python-qdarkstyle papirus-folders-nordic \
    okular breeze-icons

##### python

    sudo pacman -S --noconfirm ipython python-pip python-black flake8 stylua jupyterlab \
    python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib

##### paru

    paru -S --noconfirm simple-mtpfs urlview \
    brave-bin sc-im-git telegram-desktop latex-mk write-good htop-vim tldr++ exa \
    anki cozy-audiobooks


    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser obfs4proxy-bin

##### Fonts

    paru -S ttf-ms-fonts ttf-cmu-serif ttf-cmu-sans-serif ttf-cmu-bright ttf-cmu-concrete \
    ttf-cmu-typewriter nerd-fonts-hack ttf-sazanami-hanazono ttf-paratype ttf-dejavu

##### lf with ueberzug

    paru -S lf atool perl-file-mimeinfo
    sudo pacman -S --noconfirm ueberzug ffmpegthumbnailer bat

##### lf with kitty

    paru -S lf atool perl-file-mimeinfo
    sudo pacman -S --noconfirm ffmpegthumbnailer bat

##### neomutt

    sudo pacman -S --noconfirm neomutt isync msmtp lynx notmuch
    paru -S abook mutt-wizard-git

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

    paru -S playerctl

    paru -S hyprland-git polkit-gnome dunst grimblast rofi rofi-emoji rofi-pass \
    wl-clipboard wf-recorder wlogout hyprpicker-git hyprpaper-git \
    xdg-desktop-portal-hyprland-git ffmpegthumbnailer tumbler wtype colord      \
    imagemagick swaylock-effects qt5-wayland qt6-wayland ripgrep rofi-pass  \
    waybar-hyprland-no-systemd brightnessctl

    paru -S pavucontrol lf zsh neovim viewnior noise-suppression-for-voice







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

### crontab -e

    */15 * * * * ~/.local/bin/cron/newsup

### To do:

##### Should be done:

    sudo cp /etc/pacman.conf /mnt/etc/pacman.conf
    sudo cp /etc/paru.conf /mnt/etc/paru.conf

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
