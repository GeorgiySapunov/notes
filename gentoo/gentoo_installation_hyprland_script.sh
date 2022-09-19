#!/usr/bin/env bash

## USE flags

    emerge -v app-eselect/eselect-repository
    eselect repository enable guru
    eselect repository add librewolf git https://gitlab.com/librewolf-community/browser/gentoo.git
    eselect repository enable ambasta
    
    emerge --sync
    emerge --verbose --update --deep --newuse @world
    
    emerge -avn x11-base/xwayland \
        sys-process/cronie \
        net-misc/networkmanager \
        net-wireless/bluez \
        net-print/cups \
        media-video/pipewire \
        dev-vcs/git \
        \
        net-vpn/tor \
        net-proxy/torsocks \
        net-proxy/obfs4proxy \
        www-client/torbrowser-launcher \
        \
        brave-bin \
        www-client/librewolf \
        net-misc/ntp \
        \
        app-shells/zsh \
        app-shells/gentoo-zsh-completions \
        app-shells/zoxide \
        app-shells/fzf \
        sys-apps/exa \
        \
        media-video/ffmpeg \
        media-video/mpv \
        media-video/mediainfo \
        media-video/ffmpegthumbnailer \
        net-misc/yt-dlp \
        media-sound/mpd \
        media-sound/ncmpcpp \
        \
        gnome-base/gnome-keyring \
        net-news/newsboat \
        media-gfx/sxiv \
        app-office/calcurse \
        media-gfx/gimp \
        media-gfx/inkscape \
        media-gfx/blender \
        app-office/libreoffice \
        x11-misc/pcmanfm  \
        x11-misc/dunst \
        app-admin/testdisk \
        sys-apps/moreutils \
        app-editors/neovim \
        dev-lua/luarocks \
        sys-fs/ncdu \
        sys-apps/ripgrep \
        app-i18n/ibus \
        app-i18n/ibus-libpinyin \
        app-misc/neofetch \
        kde-apps/okular \
        net-im/telegram-desktop \
        sys-process/htop \
        app-misc/anki \
        \
        app-crypt/gnupg \
        app-admin/pass \
        app-crypt/pinentry \
        \
        net-p2p/transmission \
        net-p2p/tremc \
        net-misc/wget \
        net-analyzer/bmon \
        media-sound/pulsemixer \
        app-misc/tmux \
        sys-apps/mlocate \
        x11-terms/kitty \
        media-libs/libbluray \
        \
        app-misc/lf \
        app-arch/atool \
        dev-perl/File-MimeInfo \
        sys-apps/bat \
        \
        mail-client/neomutt \
        net-mail/isync \
        mail-mta/msmtp \
        www-client/lynx \
        net-mail/notmuch \
        app-misc/abook \
        mail-client/mutt-wizard \
        \
        sys-fs/simple-mtpfs \
        \
        app-text/zathura \
        app-text/zathura-meta \
        app-misc/pdfpc \
        \
        media-libs/fontconfig \
        media-fonts/noto \
        media-fonts/noto-emoji \
        media-fonts/symbola \
        media-fonts/mikachan-font-ttf \
        media-fonts/fonts-meta \
        media-fonts/corefonts \
        media-fonts/fontawesome \
        media-fonts/liberation-fonts \
        \
        lxde-base/lxappearance  \
        x11-libs/gtk+ \
        gui-libs/gtk \
        dev-qt/qtstyleplugins \
        \
        dev-python/ipython \
        dev-python/black \
        dev-python/flake8 \
        sci-libs/tensorflow \
        sci-libs/scikit-learn \
        dev-python/pandas \
        dev-python/matplotlib \
        \
        app-text/texlive \
        dev-texlive/texlive-langcyrillic \
        dev-tex/biber \
        dev-tex/latexmk \
        \
        dev-lua/StyLua \
        \
        sys-auth/pam-gnupg \
        \
        gui-apps/waybar \
        gui-apps/wl-clipboard \
        gui-apps/grim \
        gui-apps/swaylock \
        gui-apps/swaylock-effects \
        gui-apps/wlogout \
        gui-apps/wf-recorder \
        gui-apps/wofi \
        gnome-base/gdm \
        gui-wm/sway \
        gui-libs/xdg-desktop-portal-wlr
    

## rc-update

    rc-update add sshd default
    rc-service sshd start
    rc-update add cronie default
    rc-update add elogind boot
    rc-update add udev sysinit
    rc-service NetworkManager start
    rc-update add NetworkManager default
    rc-service bluetooth start
    rc-update add bluetooth default
    rc-service cupsd start
    rc-update add cupsd default
    rc-service tor start
    rc-update add tor default
    rc-service ntpd start
    rc-update add ntpd default
    rc-service mpd start
    rc-update add mpd default
    
    chsh -s /bin/zsh
