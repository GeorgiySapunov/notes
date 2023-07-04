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

    intel-ucode cups cups-pdf flatpak firewalld git sof-firmware
    neovim vim vi noto-fonts print-manager reflector ttf-liberation ttf-font-awesome
    ttf-joypixels ttf-hack-nerd networkmanager-openvpn gnome-browser-connector man-db
    wget openssh cronie tor torsocks power-profiles-daemon inotify-tools

---

/etc/fstab change btrfs to:

    rw,noatime,compress=zstd,subvol=

then:

    btrfs filesystem defragment -r -v -czstd /

    <!-- systemctl enable avahi-daemon -->
    systemctl enable bluetooth
    systemctl enable cups
    systemctl enable firewalld
    <!-- systemctl enable tlp -->
    <!-- systemctl mask systemd-rfkill.socket -->
    <!-- systemctl mask systemd-rfkill.service -->
    <!-- systemctl enable upower -->
    systemctl enable cronie.service
    systemctl enable tor.service

etc/xdg/reflector/reflector.conf change to:

    --country China,Russia

    systemctl enable reflector.timer

reboot

### gsconnect

    sudo firewall-cmd --zone=public --permanent --add-port=1714-1764/tcp
    sudo firewall-cmd --zone=public --permanent --add-port=1714-1764/udp
    sudo systemctl restart firewalld.service

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
    sudo btrfs subvolume list /
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

# pacman

    pacman -S rsync ffmpeg mpv zathura zathura-pdf-mupdf zathura-djvu gimp inkscape \
    blender libreoffice nano texlive texlive-lang biber fzf testdisk \
    yt-dlp moreutils wl-clipboard \
    zsh tmux zsh-completions zoxide libbluray libaacs tmate neofetch stow

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

# python

    sudo pacman -S --noconfirm ipython python-pip jupyterlab \
    python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib

    paru -S brave-bin telegram-desktop latex-mk write-good htop-vim tldr++ exa anki

    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser obfs4proxy-bin

### Gramps

    sudo pacman -S gramps python-pyicu osm-gps-map

##### lf with kitty

    paru -S lf atool perl-file-mimeinfo
    sudo pacman -S --noconfirm ffmpegthumbnailer bat
