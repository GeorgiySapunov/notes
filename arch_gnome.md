# archinstall

### disk layout

    fat32:
    start: 1MiB
    end: 512MiB
    mount: /boot

    btrfs
    start: 513MiB
    end: 100%
    set subvolumes
    add:
    !no compression

    @
    /

    @home
    /home

    @var_log
    /var/log

    @snapshots
    /.snapshots

    @images
    /var/lib/libvirt/images
    nodatacow

confirm and exit

## additional packages

    intel-ucode cups cups-pdf flatpak firefox firewalld git sof-firmware
    inotify-tools neovim vim noto-fonts print-manager reflector tlp ttf-croscore
    ttf-dejavu ttf-ibm-plex ttf-jetbrains-mono ttf-liberation networkmanager-openvpn gnome-browser-connector

---

/etc/fstab change btrfs to:

    rw,noatime,compress=zstd,subvol=

then:

    btrfs filesystem defragment -r -v -czstd /

    systemctl enable avahi-daemon
    systemctl enable bluetooth
    systemctl enable cups
    systemctl enable firewalld
    systemctl enable tlp
    systemctl mask systemd-rfkill.socket
    systemctl mask systemd-rfkill.service
    systemctl enable upower

etc/xdg/reflector/reflector.conf change to:

    --country China

    systemctl enable reflector.timer

reboot

### Paru

    mkdir /home/georgiy/git
    cd /home/georgiy/git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

    paru -S ttf-ms-fonts
    paru -S snapper-support

    sudo umount /.snapshots/
    sudo rm -r /.snapshots
    sudo snapper -c root create-config /
    sudo btrfs subvolume list /
    sudo btrfs subvolume delete /.snapshots
    sudo btfrs subvolume list /
    sudo mkdir /.snapshots
    sudo mount -av
    sudo snapper ls
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo systemctl enable --now grub-btrfsd
    sudo systemctl status grub-btrfsd

reboot

# trim

    sudo cryptsetup status cryptlvm
    sudo fstrim -v /
    sudo cryptsetup refresh --allow-discards cryptlvm
    sudo systemctl start fstrim.service
    sudo systemctl status fstrim.service
    sudo systemctl status fstrim.timer

----

# sudo su:

    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
    echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
    echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
    echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen
    echo zh_CN.UTF-8 UTF-8 >> /etc/locale.gen

    echo KEYMAP=ru >> /etc/vconsole.conf
    echo FONT=cyr-sun16 >> /etc/vconsole.conf

    locale-gen

    pacman -S git cups bluez man-db wget openssh cronie tor torsocks

# systemctl:
    
    <!-- openssh -->
    systemctl enable cronie.service
    systemctl enable tor.service
    systemctl enable cups.service

# pacman

    pacman -S reflector rsync

    pacman -S ffmpeg mpv zathura zathura-pdf-mupdf zathura-djvu gimp inkscape \
    blender libreoffice nano texlive texlive-lang biber fzf testdisk \
    yt-dlp moreutils

##### neovim

    pacman -S --noconfirm neovim \
    lazygit ncdu ripgrep luarocks

### Make configs (see "Should be done")

    nvim /etc/paru.conf

# sudo su - georgiy

### Make zsh the default shell for the user.

    sudo chsh -s /bin/zsh georgiy
    sudo -u georgiy mkdir -p "/home/georgiy/.cache/zsh/"

    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

    sudo pacman -S libbluray libaacs
    sudo pacman -S tmate neofetch stow

# python

    sudo pacman -S --noconfirm ipython python-pip jupyterlab \
    python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib

    paru -S brave-bin telegram-desktop latex-mk write-good htop-vim tldr++ exa anki

    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser obfs4proxy-bin

    sudo pacman -S --noconfirm transmission-cli transmission-gtk

### Gramps

    sudo pacman -S gramps python-pyicu osm-gps-map