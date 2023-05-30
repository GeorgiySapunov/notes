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
    
    openssh
    cronie
    tor
    cups

# pacman

    pacman -S reflector rsync

    pacman -S ffmpeg mpv zathura zathura-pdf-mupdf zathura-djvu gimp inkscape \
    blender libreoffice nano texlive-most texlive-lang biber fzf testdisk \
    yt-dlp moreutils

##### neovim

    pacman -S --noconfirm neovim \
    lazygit ncdu ripgrep luarocks

### Paru

     cd /home/georgiy/git
     git clone https://aur.archlinux.org/paru.git
     cd paru
     makepkg -si

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
