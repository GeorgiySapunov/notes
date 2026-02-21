# Document Title

## Включаем sudo:

    su -
    control sudowheel enabled
    exit

## Обновление системы

    epm update && epm full-upgrade


### Make zsh the default shell for the user.

    sudo chsh -s /bin/zsh georgiy
    sudo -u georgiy mkdir -p "/home/georgiy/.cache/zsh/"

    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)
  
## Обновить названия стандартных папок в соответствии с локалью. 

  echo 'en_US' > ~/.config/user-dirs.locale
  LC_ALL=en_US xdg-user-dirs-update --force

## already have

  vim
  wget
  gnupg
  rsync
  lm_sensors
  poppler
  file
  ncdu
  testdisk
  htop
  zip
  unzip
  p7zip
  gnome-tweaks
  gnome-software
  usbutils
  libheif
  libbluray
  libaacs
  libosm-gps-map
  ghostscript

## already have, but not a package

  gnumake
  killall

## flatpak install

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
  
  epmi amberol gnome-video-trimmer kde5-kiten labplot gnome-photos
  epm play upscayl

## epm play

  brave
  librewolf

## problems

  syncplay
  tor-browser-bundle-bin

## check it

  pyright

### progs

  npm
  gnome-contacts
  snapshot
  gcc
  starship
  flatpak
  flatpak-repo-flathub
  emacs-pgtk
  neovim
  tmux
  git
  moreutils
  fzf
  zoxide
  eza
  yt-dlp
  tealdeer
  stow
  neofetch
  yazi
  ffmpegthumbnailer
  jq
  unar
  btop
  tmate
  cmake
  atool
  gnome-console
  sushi
  turtle nautilus-python
  nautilus-open-any-terminal
  gnome-boxes
  geary
  secrets
  keepassxc
  deja-dup
  rhythmbox
  newsflash
  qbittorrent
  junction
  mousai
  NetworkManager-applet-gtk
  ffmpeg
  obs-studio
  ImageMagick
  mpv
  vlc
  inkscape
  gimp
  libreoffice
  chromium
  qucs-s
  blender
  telegram-desktop
  anki2
  remmina
  okular
  kdenlive
  glaxnimate
  gramps
  pandoc
  libreoffice-languagetool
  fd
  ripgrep
  aspell
  aspell-en 
  aspell-ru
  aspell-fr
  evolution
  thunderbird
  texlive
  texlive-fontsextra
  zathura
  zathura-djvu
  poppler
  axel
  calibre
  enscript
  ibus-pinyin
  #? ibus-gtk2 ibus-gtk3 ibus-gtk4
  syncthing
  pip
  timeshift
  overskride

  fonts-otf-adobe-source-han-sans-cn
  fonts-otf-adobe-source-han-sans-jp
  fonts-otf-adobe-source-han-sans-kr
  fonts-otf-adobe-source-han-sans-tw
  fonts-otf-adobe-source-han-serif-cn
  fonts-otf-adobe-source-han-serif-jp
  fonts-otf-adobe-source-han-serif-kr
  fonts-otf-adobe-source-han-serif-tw
  fonts-ttf-google-noto-serif
  fonts-ttf-google-noto-sans
  fonts-otf-google-noto-cjk
  fonts-ttf-google-noto-emoji
  fonts-ttf-liberation
  fonts-ttf-open-sans
  getnf

  gnome-shell-extension-caffeine
  gnome-shell-extension-gsconnect
  gnome-shell-extension-blur-my-shell

## other gnome extentions

    # tophat
    primary-input-on-lockscreen
    removable-drive-menu # already have it
    windownavigator # already have it
    vitals
    color-picker
    window-calls # for NormCap
    switcher
    upower-battery
    
    # whole list:
    Blur my Shell
    GSConnect
    Launch new instance
    Primary Input on LockScreen
    Removable Drive Menu
    Switcher
    Vitals
    Window Calls
    windowNavigator
    upower-battery

## python

  epmi python3-module-pandas python3-module-matplotlib python3-module-seaborn python3-module-scikit-learn python3-module-pyaml python3-module-rich python3-module-termcolor python3-module-click python3-module-requests python3-module-tkinter python3-module-isort python3-module-pyflakes python3-module-pytest
  # python3-module-notebook
  python3-module-python-lsp-server

    (python312.withPackages(ps: with ps; [
      pandas
      matplotlib
      seaborn
      scikit-learn
      # tensorflow
      pyyaml
      # pyvisa pyvisa-py
      # scikit-rf
      pyfiglet
      rich
      termcolor
      click
      # icecream
      requests
      tkinter
      # pyicu
      # debugpy
      isort
      pyflakes
      pytest
      pythonnet
      jupyter
      # openai-whisper
    ]))

### systemd

  systemctl enable syncthing@georgiy.service
  systemctl start syncthing@georgiy.service

### doom emacs

  epmi emacs emacs-leim emacs-leim-el
  epmi python3-module-black
  epmi libtool # для emacs vterm
  epmi shfmt # Code formatting
  epmi shellcheck # Shell script linting
  epmi epdfinfo # Emacs PDF helper

  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  ~/.config/emacs/bin/doom install

  To enter a dark mode using gnome-tweaks in Gnome:
  On the Appearance tab, next to Legacy Applications, select Adwaita-dark

  systemctl --user enable --now emacs

### nix

  sh <(curl -L https://nixos.org/nix/install) --no-daemon

  nix search nixpkgs syncplay
  nix-env -iA nixpkgs.syncplay
  nix-channel --update
  nix-env --upgrade
  nix-collect-garbage --delete-old

### docker

  epmi docker-engine docker-compose-v2
  sudo gpasswd -a georgiy docker
  sudo systemctl enable --now docker
