# archinstall
    setfont ter-128n
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

    linux linux-headers linux-firmware
    intel-ucode # Микропрограммы Intel CPU для улучшения производительности и стабильности.
    avahi nss-mdns cups cups-pdf print-manager # Для сетевого обнаружения устройств и печати.
    flatpak # Платформа для установки приложений в контейнеризированном виде.
    firewalld # Межсетевой экран.
    git # Управление версиями программного обеспечения.
    sof-firmware # Фирменное ПО для звука.
    neovim vim # Редакторы текста.
    reflector # Инструмент для автоматической оптимизации списков зеркал пакетов.
    noto-fonts # Универсальные шрифты.
    ttf-liberation ttf-font-awesome ttf-joypixels ttf-hack-nerd # Набор свободных шрифтов.
    networkmanager networkmanager-openvpn # Менеджер сети.
    wget # Утилита для скачивания файлов.
    man-pages man-db # Система справочных страниц 
    openssh # SSH клиент и сервер
    cronie # Планировщик задач
    tor # Прокси-сервис для анонимного серфинга в Интернете
    torsocks # Средство для прозрачного перенаправления TCP соединений через Tor
    #ibus ibus-libpinyin  # Средства ввода
    fcitx5-im fcitx5-configtool fcitx5-mozc fcitx5-pinyin-zhwiki # Средства ввода
    acpid # демон для обработки сигналов от материнской платы (например, кнопка выключения, крышка ноутбука, перегрев).
    base # содержит минимальный набор необходимых программ
    base-devel # для сборки программ из исходников
    lvm2 # Logical Volume Manager
    cryptsetup # для шифрования разделов диска
    btrfs-progs # Инструменты для работы с файловой системой BTRFS.
    # mtools # набор утилит для работы с дискетами и файлами DOS/FAT формата. (Useful for virtual machines such as QEMU or VirtualBox)
    # texinfo # для создания и просмотра документации в формате Texinfo 
    bluez bluez-utils # Bluetooth
    pipewire wireplumber alsa-utils pipewire-pulse pipewire-jack gst-plugin-pipewire # обработки звука и мультимедиа
    kitty
    sddm
    power-profiles-daemon # Управление профилями питания
    archlinux-keyring # Arch Linux PGP keyring
    plymouth # Graphical boot splash screen
    
---

/etc/fstab change btrfs to:

    rw,noatime,compress=zstd,subvol=

then:

etc/xdg/reflector/reflector.conf change to:

    --country China,Russia

    systemctl enable reflector.timer

### other

    1:
    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
    
    2:
    edit /etc/pacman.conf

## systemctl emable

    systemctl enable NetworkManager
    systemctl enable bluetooth
    systemctl enable firewalld
    systemctl enable cronie
    systemctl enable acpid # управление питанием и реакциями на события (такие как закрытие крышки ноутбука или нажатие кнопки питания).
    systemctl enable sddm
    systemctl enable powerprofiles-daemon
    # systemctl enable tor
    # systemctl enable sshd

Running Syncthing as a system service ensures that it is running at startup even if the user has no active session, it is intended to be used on a server. Enable and start the syncthing@myusername.service where myusername is the actual name of the Syncthing user.

### avahi-daemon (for cups)

    systemctl enable cups
    systemctl enable avahi-daemon

Then, edit the file /etc/nsswitch.conf and change the hosts line to include mdns_minimal [NOTFOUND=return] before resolve and dns:

hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns

    sudo firewall-cmd --permanent --add-service=ipp-client
    sudo systemctl restart firewalld.service
    
### Paru

    mkdir /home/georgiy/git
    cd /home/georgiy/git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

    paru -S snapper-support # AUR

    # paru -S grub-btrfs # it's a dependacy of snapper-support
    pacman -S inotify-tools # Мониторинг изменений в файловой системе.

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
    
    
    paru -S ttf-ms-fonts # AUR
    # ibus-mozc # AUR
    
reboot

# trim

    sudo cryptsetup status cryptlvm
    sudo fstrim -v /
    sudo cryptsetup refresh --allow-discards cryptlvm
    sudo systemctl start fstrim.service
    sudo systemctl status fstrim.service
    sudo systemctl status fstrim.timer

----

    hwclock --systohc

### Mkinitcpio

    vim /etc/mkinitcpio.conf
    add encrypt lvm2 after block in line ^HOOKS:
    add btrfs in line MODULES:

    echo $(grep ^HOOKS /etc/mkinitcpio.conf | grep encrypt) || HOOKS=$(grep ^HOOKS /etc/mkinitcpio.conf) ; HOOKS2=$(echo $HOOKS | sed "s/block/block encrypt lvm2/g") ; sed -i "s/$(echo $HOOKS)/$(echo $HOOKS2)/g" /etc/mkinitcpio.conf

    mkinitcpio -p linux


### gsconnect

    sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
    sudo systemctl restart firewalld

    sudo pacman -S sshfs

add to ~/.ssh/config:

    Host 192.168.*.*
      HostKeyAlgorithms +ssh-rsa

https://github.com/GSConnect/gnome-shell-extension-gsconnect/issues/1610
https://github.com/GSConnect/gnome-shell-extension-gsconnect/issues/1647

ctrl + l
    storage/emulated/0

# pacman

    rsync
    ffmpeg
    mpv
    zathura zathura-pdf-mupdf zathura-djvu
    texlive texlive-lang biber
    yt-dlp
    testdisk # Data recovery utilities
    libbluray libaacs
    stow

    syncthing
    gimp
    inkscape
    blender
    libreoffice
    libreoffice-languagetool
    telegram-desktop
    tealdeer
    anki # Quizlet to Anki 1362209126
    
    xdg-user-dirs
run xdg-user-dirs-update to make dirs

##### neovim

    neovim
    lazygit
    ncdu # Disk usage analyzer with an ncurses interface
    luarocks # Deployment and management system for Lua modules
    ripgrep # rg

### Make configs (see "Should be done")

    nvim /etc/paru.conf

### terminal

    zsh
    zsh-completions
    zoxide # Fast cd command that learns your habits
    fzf
    tmux
    moreutils
    starship
    eza # Modern, maintained replacement for ls
    #tmate

### Make zsh the default shell for the user.

    sudo chsh -s /bin/zsh georgiy
    sudo -u georgiy mkdir -p "/home/georgiy/.cache/zsh/"

    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

# python

    sudo pacman -S ipython python-pip uv

### AUR

    brave-bin # AUR
    latex-mk # AUR
    write-good # AUR
    localsend-bin # AUR An open source cross-platform alternative to AirDrop
    eloquent # AUR Your proofreading assistant
    foliate # AUR A simple and modern GTK eBook reader
    zotero # AUR
    boxes # AUR
    upscayl-bin # AUR

    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    tor-browser-bin # AUR
    obfs4proxy-bin # AUR

### Gramps

    sudo pacman -S gramps python-pyicu osm-gps-map

#### geary

    #geary aspell

#### lutris

    sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader

#### emacs

    emacs
    pyright # статический анализатор кода Python
    python-black # auto-format
    python-debugpy
    ripgrep # rg
    fd # for doom emacs. Simple, fast and user-friendly alternative to 'find'
    python-pyflakes # статический анализатор кода Python

    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install

    To enter a dark mode using gnome-tweaks in Gnome:
    On the Appearance tab, next to Legacy Applications, select Adwaita-dark
    
    ## mu4e:
    #mu # AUR
    #mbsync-git # AUR
    
### yazi

    kitty
    yazi
    poppler # manipulates .pdfs and gives .pdf previews and other .pdf functions.
    ffmpegthumbnailer # for yazi
    jq # for yazi Lightweight and flexible command-line JSON processor
    unar # Archive unpacker program
    file # for yazi Program that shows the type of files

##### lf with kitty

    #lf
    #atool # Archive command line helper
    #perl-file-mimeinfo # mimeopen
    #ffmpegthumbnailer
    #bat
    
### other

    gnupg
    lm_sensors # Tools for reading hardware sensors (sensors command)
    ncdu # Disk usage analyzer with an ncurses interface
    htop

    atool # Archive command line helper
    zip unzip p7zip

    usbutils # Tools for working with USB devices, such as lsusb
    libheif # ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder
    ghostscript
    make # GNU make utility to maintain groups of programs

    syncplay
    keepassxc
    deja-dup
    newsflash
    qbittorrent
    junction # Choose the application to open files and links
    imagemagick
    vlc
    vlc-plugin-ffmpeg
    okular
    kdenlive
    pandoc
    aspell aspell-en aspell-ru aspell-fr
    thunderbird
    pdftk # to work with pdf
    calibre # e-book reader
    enscript # converts ASCII files to PostScript, HTML, or RTF
    blueman
    #overskride-bin # AUR A simple yet powerful bluetooth client
    #secrets
    #rhythmbox gst-libav
    # mousai # Identify any songs in seconds
    # network-manager-applet # NetworkManager control applet for GNOME (nm-connection-editor)
    # glaxnimate # AUR for kdenlive Simple vector animation program
    # evolution
    # axel # Console downloading program with some features for parallel connections for faster downloading
    #qucs-s # circuit simulator
    #remmina # Remote desktop client written in GTK

    adobe-source-han-sans-cn-fonts
    adobe-source-han-sans-jp
    adobe-source-han-sans-kr
    adobe-source-han-sans-hk
    adobe-source-han-serif-cn
    adobe-source-han-serif-jp
    adobe-source-han-serif-kr
    adobe-source-han-serif-hk
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    ttf-noto-nerd
    ttf-opensans

    #ttf-jetbrains-mono-nerd
    #otf-geist-mono-nerd
    
    exfat-utils # allows management of FAT drives
    ntfs-3g # allows accessing NTFS partitions
    gvfs-mtp # Virtual filesystem implementation for GIO - MTP backend (Android, media player)
    # simple-mtpfs # AUR enables the mounting of cell phones.
    metadata-cleaner # Python GTK application to view and clean metadata in files, using mat2
    video-trimmer # Cut out a fragment of a video quickly

## flatpak install

  flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  <!-- sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub -->
  flatpak update

  flatpak install flathub com.usebottles.bottles
  flatpak install flathub com.github.tchx84.Flatseal

  flatpak install flathub org.jupyter.JupyterLab
  #flatpak install flathub com.github.tenderowl.frog
  #flatpak install flathub com.github.dynobo.normcap
  #flatpak install flathub io.github.finefindus.Hieroglyphic


### docker

  docker
  docker-compose

  sudo gpasswd -a georgiy docker
  sudo systemctl enable --now docker

### Plymouth

  plymouth

  Add plymouth to the HOOKS array in mkinitcpio.conf.

  /etc/mkinitcpio.conf
  HOOKS=(... plymouth ...)

  в моём случае:
  HOOKS=(base udev plymouth autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck grub-btrfs-overlayfs)

  If you are using the systemd hook, it must be before plymouth.
  Furthermore make sure you place plymouth before the encrypt or sd-encrypt hook if your system is encrypted with dm-crypt.
  Finally, regenerate the initramfs (mkinitcpio -p linux).

### SDDM
  https://github.com/catppuccin/sddm

  sudo mv -v catppuccin-mocha-mauve /usr/share/sddm/themes

  Edit the /etc/sddm.conf file and change the theme to catppuccin-<flavour>-<accent>. For example, catppuccin-mocha-mauve.

  If you don't have this file, create the /etc/sddm.conf file and add the following lines:
   [Theme]
   Current=catppuccin-mocha-mauve

### razer

sudo pacman -S openrazer-daemon

### corsair

sudo yay openlinkhub # AUR
<!-- sudo yay ckb-next -->
