# archinstall old
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
    avahi nss-mdns cups cups-pdf print-manager\
    flatpak\
    firewalld\
    git\
    sof-firmware\
    neovim vim vi\
    reflector\
    noto-fonts\
    ttf-liberation ttf-font-awesome ttf-joypixels ttf-hack-nerd\
    networkmanager-openvpn\
    gnome-browser-connector gnome-extra gnome-shell-extensions dconf-editor\
    gnome gnome-tweaks \
    wget\
    man-db\
    openssh\
    cronie\
    tor torsocks\
    power-profiles-daemon\
    inotify-tools\
    ibus ibus-libpinyin \
    
---

/etc/fstab change btrfs to:

    rw,noatime,compress=zstd,subvol=

then:

    btrfs filesystem defragment -r -v -czstd /

    systemctl enable avahi-daemon
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

### other

    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm

## additional packages

    systemctl enable bluetooth
    systemctl enable cups
    systemctl enable firewalld
    systemctl enable cronie.service
    # systemctl enable tor.service
    systemctl enable NetworkManager
    # systemctl enable sshd
    # ? systemctl enable fstrim.timer
    # not for gnome? systemctl enable acpid

    systemctl enable avahi-daemon
    Then, edit the file /etc/nsswitch.conf and change the hosts line to include mdns_minimal [NOTFOUND=return] before resolve and dns:

    hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns

### Paru

    mkdir /home/georgiy/git
    cd /home/georgiy/git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

    paru -S ttf-ms-fonts
    paru -S snapper-support
    paru -S ibus-mozc

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
    
### zramd ?

    paru -S zramd
    sudo systemctl enable --now zramd.service

    paru -S timeshift timeshift-autosnap
    sudo timeshift --create --comments "start of time" --tags D
    sudo systemctl edit --full grub-btrfsd
        # rm : ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots
        # add: ExecStart=/usr/bin/grub-btrfsd --syslog -t
    sudo grub-mkconfig -o /boot/grub/grub.cfg

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
    

### avahi-daemon (for cups)

    sudo firewall-cmd --permanent --add-service=ipp-client
    sudo systemctl restart firewalld.service

### ? Mkinitcpio

    vim /etc/mkinitcpio.conf
    add encrypt lvm2 after block in line ^HOOKS:
    add btrfs in line MODULES:

    echo $(grep ^HOOKS /etc/mkinitcpio.conf | grep encrypt) || HOOKS=$(grep ^HOOKS /etc/mkinitcpio.conf) ; HOOKS2=$(echo $HOOKS | sed "s/block/block encrypt lvm2/g") ; sed -i "s/$(echo $HOOKS)/$(echo $HOOKS2)/g" /etc/mkinitcpio.conf

    mkinitcpio -p linux

reboot


# arch manual
https://github.com/radleylewis/arch_installation_guide

    setfont ter-132b

### wifi

    iwctl
        device list # get device_name (like wlan0)
        station {device_name} get-networks
        station list
        station {device_name} connect {network_name}
        exit
    ping -c 2 archlinux.org

### ssh

    systemctl status sshd # if not running: systemctl start sshd
    passwd
    ip addr show
    
    on other machine:
    ssh root@{ip}

### other

    loadkeys us
    cat /sys/firmware/efi/fw_platform_size
    >>> 64
    timedatectl list-timezones | grep Asia/Shanghai
    timedatectl set-timezone Asia/Shanghai
    timedatectl set-ntp true
    timedatectl

### disk layout

    lsblk
    gdisk /dev/nvme0n1
        o - create new partition table
        d - delete a partition
        p - print the partition table
        n - add a new partition
        Last sector:
        +10M (BIOS boot)
        +1G (UEFI boot)
        (root)
        w - write table to disk and exit
    o
    n
    enter (default)
    enter (default)
    +1G
    Hex code or GUID: ef00 # EFI system partition
    n
    enter (default)
    enter (default)
    enter (default)
    enter (default) # Linux filesystem
    w
    lsblk

    cryptsetup luksFormat /dev/nvme0n1p2
    cryptsetup open /dev/nvme0n1p2 cryptroot
    mkfs.btrfs /dev/mapper/cryptroot
    mount /dev/mapper/cryptroot /mnt
    cd /mnt
    btrfs subvolume create @
    btrfs subvolume create @home
    cd # cd /root
    unmount /mnt
    mount -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt
    mkdir /mnt/home
    mount -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home

    mkfs.fat -F32 /dev/nvme0n1p1
    mkdir /mnt/boot
    mount /dev/nvme0n1p1 /mnt/boot
    
### pacstrap

    reflector -c China -a 12 --sort rate --save /etc/pacman.d/mirrorlist
    pacstrap /mnt base base-devel linux linux-headers linux-firmware vim lvm2 cryptsetup btrfs-progs grub grub-btrfs efibootmgr networkmanager

    genfstab -U -p /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc

    pacman -S mtools openssh git \
    iptables-nft ipset firewalld acpid reflector intel-ucode \
    avahi nss-mdns cups cups-pdf \
    flatpak sof-firmware neovim vi noto-fonts print-manager ttf-liberation ttf-font-awesome ttf-joypixels ttf-hack-nerd \
    networkmanager-openvpn gnome-browser-connector man-pages man-db \
    texinfo bluez bluez-utils pipewire alsa-utils pipewire-pulse pipewire-jack gst-plugin-pipewire \
    wget openssh cronie tor torsocks power-profiles-daemon \
    gnome gnome-extra gnome-shell-extensions dconf-editor gnome-tweaks \
    ibus ibus-libpinyin \
    # inotify-tools

    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
    echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
    echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
    echo fr_FR.UTF-8 UTF-8 >> /etc/locale.gen
    echo zh_CN.UTF-8 UTF-8 >> /etc/locale.gen
    locale-gen
    echo LANG=ru_RU.UTF-8 >> /etc/locale.gen
    # echo LANG=en_US.UTF-8 >> /etc/locale.conf

    echo KEYMAP=ru >> /etc/vconsole.conf
    echo FONT=cyr-sun16 >> /etc/vconsole.conf

    echo matebook >> /etc/hostname
        echo "127.0.0.1    localhost" >> /etc/hosts
        echo "::1          localhost" >> /etc/hosts
        echo "127.0.0.1    portable.localdomain matebook" >> /etc/hosts

### user

    passwd
    useradd -m -g users -G wheel georgiy
    passwd georgiy

    # echo "georgiy  ALL=(All) ALL" >> /etc/sudoers.d/georgiy

    EDITOR=vim visudo

    %wheel ALL=(ALL) ALL
    %wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm

## additional packages

    Then, edit the file /etc/nsswitch.conf and change the hosts line to include mdns_minimal [NOTFOUND=return] before resolve and dns:

    hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
    
---

    systemctl enable gdm.service
    systemctl enable avahi-daemon
    systemctl enable bluetooth
    systemctl enable cups
    systemctl enable firewalld
    systemctl enable cronie.service
    # systemctl enable tor.service
    systemctl enable NetworkManager
    # systemctl enable sshd
    # ? systemctl enable fstrim.timer
    # not for gnome? systemctl enable acpid

### avahi-daemon (for cups)

    sudo firewall-cmd --permanent --add-service=ipp-client
    sudo systemctl restart firewalld.service

etc/xdg/reflector/reflector.conf change to:

    --country China,Russia
    systemctl enable reflector.timer

### Mkinitcpio

    vim /etc/mkinitcpio.conf
    add encrypt lvm2 after block in line ^HOOKS:
    add btrfs in line MODULES:

    echo $(grep ^HOOKS /etc/mkinitcpio.conf | grep encrypt) || HOOKS=$(grep ^HOOKS /etc/mkinitcpio.conf) ; HOOKS2=$(echo $HOOKS | sed "s/block/block encrypt lvm2/g") ; sed -i "s/$(echo $HOOKS)/$(echo $HOOKS2)/g" /etc/mkinitcpio.conf

    mkinitcpio -p linux

#### GRUB portable (LEGACY and UEFI) with crypt

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    vim /etc/default/grub
    # add cryptdevice=UUID={nvme0n1p2 UUID}:cryptroot root=/dev/mapper/cryptroot after quiet in line ^GRUB_CMDLINE_LINUX_DEFAULT:
    add cryptdevice=UUID={nvme0n1p2 UUID}:cryptroot root={cryptroot UUID} after quiet in line ^GRUB_CMDLINE_LINUX_DEFAULT:
    # blkid -o value -s UUID /dev/nvme0n1p2 >> /etc/default/grub
    # blkid -o value -s UUID /dev/mapper/cryptroot >> /etc/default/grub

    grub=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet\""); grub2=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=$(echo $(blkid | grep nvme0n1p2 | awk $'{print $2}' | sed "s/\"//g")):cryptroot root=\/dev\/mapper\/cryptroot\""); sed -i "s/$(echo "$grub")/$(echo "$grub2")/g" /etc/default/grub

    # grub=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet\""); grub2=$(echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=$(echo $(blkid | grep sdc3 | awk $'{print $2}' | sed "s/\"//g")):cryptroot root=\/dev\/mapper\/cryptroot\""); sed -i "s/$(echo "$grub")/$(echo "$grub2")/g" /etc/default/grub

    grub-mkconfig -o /boot/grub/grub.cfg

### Paru

    mkdir /home/georgiy/git
    cd /home/georgiy/git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

    paru -S ttf-ms-fonts
    paru -S snapper-support
    paru -S ibus-mozc

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
    ffmpeg mpv\
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

    paru -S brave-bin\
    telegram-desktop\
    latex-mk\
    write-good\
    tealdeer\
    exa\
    anki

    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    paru -S tor-browser obfs4proxy-bin

### Gramps

    sudo pacman -S gramps python-pyicu osm-gps-map

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

    sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader

#### emacs

    sudo pacman -S emacs\
    pyright\
    python-black\
    python-debugpy\
    ripgrep\
    fd

    systemctl --user enable emacs.service

### other

  vim \
  wget \
  gnupg \
  rsync \
  lm_sensors \
  poppler \
  file \
  ncdu \
  testdisk \
  htop \
  zip \
  unzip \
  p7zip \
  gnome-tweaks \
  gnome-software \
  usbutils \
  libheif \
  libbluray \
  libaacs \
  libosm-gps-map \
  ghostscript \
  gnumake \
  killall \
  
  amberol \
  gnome-video-trimmer \
  kiten \
  labplot \
  gnome-photos \
  upscayl \

  brave \
  librewolf \
  syncplay \

  npm \
  gnome-contacts \
  snapshot \
  gcc \
  starship \
  flatpak \
  emacs \
  neovim \
  tmux \
  git \
  moreutils \
  fzf \
  zoxide \
  eza \
  yt-dlp \
  tealdeer \
  stow \
  neofetch \
  yazi \
  ffmpegthumbnailer \
  jq \
  unar \
  btop \
  tmate \
  cmake \
  atool \
  gnome-console \
  sushi \
  turtle nautilus-python \
  nautilus-open-any-terminal \
  gnome-boxes \
  geary \
  secrets \
  keepassxc \
  deja-dup \
  rhythmbox \
  newsflash \
  qbittorrent \
  junction \
  mousai \
  NetworkManager-applet-gtk \
  ffmpeg \
  obs-studio \
  ImageMagick \
  mpv \
  vlc \
  inkscape \
  gimp \
  libreoffice \
  qucs-s \
  blender \
  telegram-desktop \
  anki2 \
  remmina \
  okular \
  kdenlive \
  glaxnimate \
  gramps \
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
  zathura \
  zathura-djvu \
  poppler \
  axel \
  calibre \
  enscript \
  ibus-pinyin \
  syncthing \
  pip \
  timeshift \
  overskride \

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

### doom emacs

  emacs emacs-leim emacs-leim-el
  black
  libtool # для emacs vterm
  shfmt # Code formatting
  shellcheck # Shell script linting
  epdfinfo # Emacs PDF helper

  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  ~/.config/emacs/bin/doom install

  To enter a dark mode using gnome-tweaks in Gnome:
  On the Appearance tab, next to Legacy Applications, select Adwaita-dark

  systemctl --user enable --now emacs

### docker

  docker-engine \
  docker-compose-v2

  sudo gpasswd -a georgiy docker
  sudo systemctl enable --now docker
