# archinstall

    setfont ter-128n
    iwctl
      device list
      station wlan0 scan
      station wlan0 get-networks
      station wlan0 connect "mywifi"

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

    intel-ucode\
    neovim vim vi nano\
    git\
    wget\
    inotify-tools\
    reflector\

# skip

    avahi nss-mdns cups cups-pdf print-manager\
    #flatpak\
    firewalld\
    sof-firmware\
    noto-fonts\
    ttf-liberation ttf-font-awesome ttf-joypixels ttf-hack-nerd\
    networkmanager-openvpn\
    #gnome-software
    gnome-browser-connector gnome-extra gnome-shell-extensions dconf-editor\
    #gnome gnome-tweaks \
    man-db\
    #openssh
    cronie\
    tor torsocks\
    power-profiles-daemon\
    ibus ibus-libpinyin \
    
### additional

    pacman -S
    avahi nss-mdns cups cups-pdf
    print-manager
    firewalld
    sof-firmware
    noto-fonts ttf-liberation ttf-font-awesome ttf-joypixels ttf-hack-nerd
    networkmanager-openvpn
    gnome-browser-connector
    gnome-extra
    man-db
    cronie
    tor torsocks
    power-profiles-daemon
    ibus ibus-libpinyin
    sshfs
    rsync
    zathura zathura-pdf-mupdf zathura-djvu
    yt-dlp
    moreutils
    wl-clipboard
    fzf
    testdisk
    zsh
    tmux
    zsh-completions
    stow
    emacs
    pyright
    python-black python-debugpy
    ripgrep
    fd
    starship zoxide eza
    ncdu
    atool zip p7zip
    aspell
    usbutils
    libaacs
    gramps python-pyicu osm-gps-map
    amberol
    kiten
    syncplay
    npm
    tmux
    tealdeer
    ffmpegthumbnailer
    cmake
    tmate
    secrets keepassxc
    deja-dup
    rhythmbox
    newsflash
    junction
    mousai
    mpv
    pdftk
    enscript
    docker docker-compose
    lazygit
    luarocks
    gimp inkscape blender libreoffice
    qbittorrent
    obs-studio
    kdenlive
    thunderbird
    texlive texlive-fontsextra
    ipython python-pip
    python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib
    adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts
    
    ?libplot
    ?upscayl
    ?anki

    paru -S
    brave-bin librewolf
    tor-browser obfs4proxy-bin
    telegram-desktop
    latex-mk
    write-good
    anki
    ibus-mozc
    ttf-ms-fonts
    snapper-support

    ?gnome-video-trimmer
    ?turtle nautilus-python
    ?nautilus-open-any-terminal
    
---
### zstd

/etc/fstab change btrfs to:

    rw,noatime,compress=zstd,subvol=

then:

    btrfs filesystem defragment -r -v -czstd /

### 

    systemctl enable avahi-daemon
    systemctl enable bluetooth
    systemctl enable cups
    systemctl enable firewalld
    <!-- systemctl enable tlp -->
    <!-- systemctl mask systemd-rfkill.socket -->
    <!-- systemctl mask systemd-rfkill.service -->
    <!-- systemctl enable upower -->

etc/xdg/reflector/reflector.conf change to:

    --country China,Russia

    systemctl enable reflector.timer

### other

    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm

### Paru

    mkdir /home/georgiy/git
    cd /home/georgiy/git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

    paru -S ttf-ms-fonts

    paru -S snapper-support
    # paru -S grub-btrfs # it's dependacy of snapper-support
    pacman -S inotify-tools

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

## additional packages

    systemctl enable cronie.service
    # systemctl enable tor.service
    systemctl enable NetworkManager
    # systemctl enable sshd
    # ? systemctl enable fstrim.timer
    # not for gnome? systemctl enable acpid

    systemctl enable avahi-daemon
    Then, edit the file /etc/nsswitch.conf and change the hosts line to include mdns_minimal [NOTFOUND=return] before resolve and dns:

    hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns

# trim

    sudo cryptsetup status cryptlvm
    sudo fstrim -v /
    sudo cryptsetup refresh --allow-discards cryptlvm
    sudo systemctl start fstrim.service
    sudo systemctl status fstrim.service
    sudo systemctl status fstrim.timer
    
### zramd ? skip timeshift, since we are using snapper

    paru -S zramd
    sudo systemctl enable --now zramd.service

    paru -S timeshift timeshift-autosnap
    sudo timeshift --create --comments "start of time" --tags D
    sudo systemctl edit --full grub-btrfsd
        # rm : ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots
        # add: ExecStart=/usr/bin/grub-btrfsd --syslog -t
    sudo grub-mkconfig -o /boot/grub/grub.cfg

reboot

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
    

### avahi-daemon (for cups)

    sudo firewall-cmd --permanent --add-service=ipp-client
    sudo systemctl restart firewalld.service

### ? Mkinitcpio

    vim /etc/mkinitcpio.conf
    add encrypt after block in line ^HOOKS:
    add btrfs in line MODULES:

    echo $(grep ^HOOKS /etc/mkinitcpio.conf | grep encrypt) || HOOKS=$(grep ^HOOKS /etc/mkinitcpio.conf) ; HOOKS2=$(echo $HOOKS | sed "s/block/block encrypt/g") ; sed -i "s/$(echo $HOOKS)/$(echo $HOOKS2)/g" /etc/mkinitcpio.conf

    mkinitcpio -p linux

reboot

# continue

### autologin

    vim /etc/gdm/custom.conf
        # Enable automatic login for user
        [daemon]
        AutomaticLogin=georgiy
        AutomaticLoginEnable=True

### gsconnect

    sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
    sudo systemctl restart firewalld.service

    sudo pacman -S sshfs

add to ~/.ssh/config:

    Host 192.168.*.*
      HostKeyAlgorithms +ssh-rsa

https://github.com/GSConnect/gnome-shell-extension-gsconnect/issues/1610
https://github.com/GSConnect/gnome-shell-extension-gsconnect/issues/1647

ctrl + l
    storage/emulated/0


reboot

# pacman

    pacman -S rsync\
    #ffmpeg
    mpv\
    zathura zathura-pdf-mupdf zathura-djvu\
    gimp inkscape blender\
    libreoffice nano\
    texlive texlive-lang biber\
    yt-dlp\
    moreutils\
    wl-clipboard \
    fzf\
    testdisk \
    zsh tmux zsh-completions zoxide\
    libbluray libaacs\
    tmate\
    neofetch\
    stow\
    btop

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

    sudo pacman -S ipython python-pip \
    python-tensorflow python-scikit-learn python-pandas python-numpy python-matplotlib

    pandas
    matplotlib
    seaborn
    scikit-learn
    tensorflow
    pyyaml
    pyvisa
    pyvisa-py
    scikit-rf
    pyfiglet
    rich
    termcolor
    click
    icecream
    requests
    tkinter
    isort
    pyflakes
    pytest
    pythonnet

### paru

    paru -S
    brave-bin
    telegram-desktop
    latex-mk
    write-good
    anki
    ?outils # Port of OpenBSD-exclusive tools such as `calendar`, `vis`, and `signify`

    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser obfs4proxy-bin

### Gramps

    sudo pacman -S gramps python-pyicu osm-gps-map
    osm-gps-map # Used to show maps in the geography view (Gramps)

##### lf with kitty

    paru -S lf atool perl-file-mimeinfo
    sudo pacman -S --noconfirm ffmpegthumbnailer bat

#### fonts

    sudo pacman -S --noconfirm adobe-source-han-sans-cn-fonts \
    adobe-source-han-sans-jp-fonts adobe-source-han-serif-cn-fonts \
    adobe-source-han-serif-jp-fonts

####

    sudo pacman -S geary aspell

#### lutris

    #sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader

#### emacs

    sudo pacman -S emacs\
    pyright\
    python-black\
    python-debugpy\
    ripgrep # rg for doom emacs
    fd # for doom emacs Simple, fast and user-friendly alternative to find

    systemctl --user enable emacs.service

    check also:
    emacs emacs-leim emacs-leim-el
    black # auto-format
    libtool # for emacs vterm
    shfmt # Code formatting
    shellcheck # Shell script linting
    epdfinfo # Emacs PDF helper
    pytest # run tests (doom emacs)

    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install

    To enter a dark mode using gnome-tweaks in Gnome:
    On the Appearance tab, next to Legacy Applications, select Adwaita-dark

    systemctl --user enable --now emacs


### yazi

    pacman -S

    yazi
    poppler  # for yazi PDF rendering library
    ffmpegthumbnailer # for yazi
    jq # for yazi Lightweight and flexible command-line JSON processor
    unar # Archive unpacker program
    file # for yazi Program that shows the type of files
    kitty

### other

    pacman -S

    starship \
    fzf \
    zoxide # Fast cd command that learns your habits
    eza # Modern, maintained replacement for ls
    git
    ibus-mozc
    ibus-pinyin \
    vim \
    neovim \
    emacs
    wget \
    gnupg \
    rsync \
    #lm_sensors # Tools for reading hardware sensors (sensors command)
    ncdu # Disk usage analyzer with an ncurses interface
    testdisk # Data recovery utilities
    #htop \

    atool # Archive command line helper
    zip \
    unzip \
    p7zip \

    #gnome-tweaks \
    #gnome-software \
    gnome-video-trimmer \
    #gnome-photos \
    #gnome-contacts \
    #gnome-console \
    #snapshot # gnome camera
    #sushi # Quick previewer for Nautilus
    turtle nautilus-python \
    nautilus-open-any-terminal \
    #eog # GNOME image viewer
    #gnome-boxes \
    #geary \

    usbutils # Tools for working with USB devices, such as lsusb
    libheif # ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder
    libbluray \
    libaacs # Library to access AACS protected Blu-Ray disks
    osm-gps-map \
    #ghostscript \
    gnumake \
    killall \

    amberol \
    kiten \
    labplot \
    upscayl \

    brave \
    librewolf \
    syncplay \

    npm \
    gcc \
    #flatpak \
    tmux \
    moreutils # vidir
    yt-dlp \
    tealdeer \
    stow \
    neofetch \
    ffmpegthumbnailer \
    btop \
    tmate \
    cmake \

    secrets \
    keepassxc \
    deja-dup \
    rhythmbox \
    newsflash \
    qbittorrent \
    junction # Choose the application to open files and links
    mousai # Identify any songs in seconds
    # network-manager-applet # NetworkManager control applet for GNOME (nm-connection-editor)
    #ffmpeg \
    obs-studio \
    #imagemagick \
    mpv \
    vlc \
    inkscape \
    gimp \
    libreoffice \
    blender \
    telegram-desktop \
    anki2 \
    qucs-s # circuit simulator
    remmina # Remote desktop client written in GTK
    okular \
    kdenlive \
    glaxnimate # for kdenlive Simple vector animation program
    pandoc \
    libreoffice-languagetool \
    fd \
    ripgrep \
    aspell \
    aspell-en  \
    aspell-ru \
    aspell-fr \
    evolution \
    thunderbird \
    texlive \
    texlive-fontsextra \
    zathura # Highly customizable and functional PDF viewer
    zathura-djvu \
    pdftk # to work with pdf
    poppler \
    axel # Console downloading program with some features for parallel connections for faster downloading
    calibre # e-book reader
    enscript # converts ASCII files to PostScript, HTML, or RTF
    syncthing \
    pip \
    overskride # A simple yet powerful bluetooth client

    fonts-otf-adobe-source-han-sans-cn \
    fonts-otf-adobe-source-han-sans-jp \
    fonts-otf-adobe-source-han-sans-kr \
    fonts-otf-adobe-source-han-sans-tw \
    fonts-otf-adobe-source-han-serif-cn \
    fonts-otf-adobe-source-han-serif-jp \
    fonts-otf-adobe-source-han-serif-kr \
    fonts-otf-adobe-source-han-serif-tw \
    fonts-ttf-google-noto-serif \
    fonts-ttf-google-noto-sans \
    fonts-otf-google-noto-cjk \
    fonts-ttf-google-noto-emoji \
    fonts-ttf-liberation \
    fonts-ttf-open-sans \

## flatpak install

  flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  <!-- sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub -->
  flatpak update

  flatpak install flathub fr.romainvigier.MetadataCleaner
  flatpak install flathub org.zotero.Zotero
  flatpak install flathub com.usebottles.bottles
  flatpak install flathub com.github.geigi.cozy
  flatpak install flathub com.github.tchx84.Flatseal
  flatpak install flathub app.fotema.Fotema

  flatpak install flathub io.bassi.Amberol
  flatpak install flathub org.gnome.gitlab.YaLTeR.VideoTrimmer
  flatpak install flathub org.gnome.World.Secrets
  flatpak install flathub io.gitlab.theevilskeleton.Upscaler
  flatpak install flathub org.gnome.Boxes
  flatpak install flathub com.github.geigi.cozy
  flatpak install flathub org.gnome.DejaDup
  flatpak install flathub com.github.tenderowl.frog
  flatpak install flathub org.jupyter.JupyterLab
  flatpak install flathub org.kde.kiten
  flatpak install flathub org.kde.labplot2
  flatpak install flathub net.sourceforge.scidavis
  flatpak install flathub com.github.dynobo.normcap
  flatpak install flathub io.github.finefindus.Hieroglyphic
  flatpak install flathub org.gnome.Photos
  flatpak install flathub io.gitlab.adhami3310.Converter


## other gnome extentions
    
    caffeine
    GSConnect
    Blur my Shell
    Launch new instance
    Primary Input on LockScreen
    Removable Drive Menu
    Switcher
    Vitals
    windowNavigator
    upower-battery

### docker

  docker-engine \
  docker-compose

  sudo gpasswd -a georgiy docker
  sudo systemctl enable --now docker
