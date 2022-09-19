## virtualbox guest

    emerge --ask app-emulation/virtualbox-guest-additions
    rc-update add virtualbox-guest-additions default

    gpasswd -a <user> vboxguest
    gpasswd -a <user> vboxsf

    you cat mount  shared folders with:
        mount -t  vboxsf <shared_folder_name> <mount_point>

## USE flags

FILE etc/portage/make.conf

    bloat?
    
    USE="-systemd -gnome -kde -dvd -dvdr -cdr -ios -ipod -aqua -emacs -xemacs \
    crypt cjk wayland xwayland X tray policykit dbus udev networkmanager \
    bluetooth sound-server screencast alsa ffmpeg aacs pdf djvu ibus wifi \
    elogind ncurses cups text gtk python widgets gui"

    ?? USE="unicode"

    emerge --verbose --update --deep --newuse @world
    
clean:

    ??? sys-power/suspend crypt
    ?? app-text/texlive cjk
    ?? app-text/texlive-core cjk
    ?? app-text/texlive-core cjk
    ?? media-fonts/noto cjk
    ?? gui-wm/sway tray
    ?? gui-apps/waybar tray
    ?? gui-apps/waybar mpd
    ?? app-text/zathura-meta pdf djvu
    ?? alsa
    ?? mediaa-libs/hurfbuzz
    ?? pam
    ?? harfbuzz

    USE="-systemd -gnome -kde -dvd -dvdr -cdr -ios -ipod -aqua -emacs -xemacs \
    cjk wayland xwayland X tray policykit dbus udev networkmanager bluetooth \
    sound-server screencast alsa aacs mpd djvu ibus wifi elogind cups gui"

## Waland

FILE etc/portage/make.conf

    USE="wayland xwayland

    emerge --ask x11-base/xwayland

## OpenSSH

Add the OpenSSH daemon to the default runlevel:

    rc-update add sshd default
    rc-service sshd start

## Cron

    emerge --ask sys-process/cronie
    rc-update add cronie default

##

Enabling this USE flag will pull in sys-auth/polkit automatically
(default for desktop profiles):

vim etc/portage/make.conf

    use="policykit"

    ?? emerge -ask sys-auth/polkit-qt

## d-bus

FILE etc/portage/make.conf

    USE="dbus"

## elogind

elogind should be configured to start at boot time:

    rc-update add elogind boot

## ? Udev

Adding this USE flag value to the USE flag list (default in all Linux
profiles) will pull in the virtual/udev package automatically:

FILE /etc/portage/make.conf

    USE="udev"

    rc-update add udev sysinit

## eselect-repository

    emerge --ask app-eselect/eselect-repository

## NetworkManager

Enabling this USE flag will make those packages pull in
net-misc/networkmanager automatically:

FILE /etc/portage/make.conf

    USE="networkmanager"

    emerge --ask net-misc/networkmanager

    gpasswd -a (user name) plugdev

---

NetworkManager uses an internal DHCP client implementation since
version 1.20. There is no explicit need for an external DHCP client.
The ```dhclient``` and ```dhcpcd``` USE flags enable alternative implementations.

    for x in /etc/runlevels/default/net.* ; do rc-update del $(basename $x) default ; rc-service --ifstarted $(basename $x) stop; done
    rc-update del dhcpcd default

---

    rc-service NetworkManager start
    rc-update add NetworkManager default

## Bluetooth

Bluetooth support can be enabled system-wide by setting the USE
variable to bluetooth:

FILE /etc/portage/make.conf

    USE="bluetooth"

    emerge --ask --noreplace net-wireless/bluez

    rc-service bluetooth start
    rc-update add bluetooth default

## Cups

FILE /etc/portage/make.conf

    USE="cups"

    emerge --ask net-print/cups

    rc-service cupsd start
    rc-update add cupsd default

## pipewire

FILE /etc/portage/make.conf

    USE="sound-server screencast alsa"

    emerge --ask media-video/pipewire

Starting PipeWire with various non-systemd setups

FILE ~/.config/sway/config

    exec gentoo-pipewire-launcher

## git

    emerge --ask dev-vcs/git

    ? lazygit

## tor

    emerge --ask net-vpn/tor \
        net-proxy/torsocks \
        net-proxy/obfs4proxy

    rc-service tor start
    rc-update add tor default

    ??
        FILE /etc/portage/make.conf

            ACCEPT_KEYWORDS="~amd64"
            USE="gui"

            app-crypt/gpgme python
            dev-python/PyQt5 widgets

            eselect repository enable guru
            emerge --sync guru
            emerge --ask www-client/torbrowser-launcher

## brave

    eselect repository enable brave-overlay

    emerge --ask brave-bin

## librewolf

    eselect repository add librewolf git https://gitlab.com/librewolf-community/browser/gentoo.git
    emaint -r librewolf sync
    ? (emerge --sync librewolf)
    emerge --ask www-client/librewolf

## npd

    emerge net-misc/ntp

    rc-service ntpd start
    rc-update add ntpd default

## zsh

    emerge --ask app-shells/zsh \
        app-shells/gentoo-zsh-completions
    emerge --ask sys-apps/exa

    chsh -s /bin/zsh

## zoxide

    eselect repository enable guru
    emerge --sync guru
    emerge app-shells/zoxide

## dunst

    emerge --ask --verbose x11-misc/dunst

    ?? libnotify

## ffmpeg, mpd, mpv

FILE /etc/portage/make.conf

    USE="ffmpeg"

    emerge --ask media-video/ffmpeg \
        media-video/mpv \
        media-video/mediainfo \
        media-video/ffmpegthumbnailer \
        net-misc/yt-dlp \
        media-sound/mpd \
        media-sound/ncmpcpp

    rc-service mpd start
    rc-update add mpd default

## also

    emerge --ask gnome-base/gnome-keyring \
        net-news/newsboat \
        media-gfx/sxiv \
        app-office/calcurse \
        media-gfx/gimp \
        media-gfx/inkscape \
        media-gfx/blender \
        app-office/libreoffice \
        x11-misc/pcmanfm  \
        app-shells/fzf \
        app-admin/testdisk \
        sys-apps/moreutils \
        app-editors/neovim \
        dev-lua/luarocks \
        sys-fs/ncdu \                  #  zig
        sys-apps/ripgrep \
        app-i18n/ibus 
        app-i18n/ibus-libpinyin \
        app-misc/neofetch \
        kde-apps/okular \
        net-im/telegram-desktop \
        sys-process/htop \
        app-misc/anki \
        app-crypt/gnupg \
        app-admin/pass \
        app-crypt/pinentry \
        net-p2p/transmission \
        net-p2p/tremc \
        net-misc/wget \
        net-analyzer/bmon \
        media-sound/pulsemixer \
        app-misc/tmux \
        sys-apps/mlocate \
        x11-terms/kitty

## blueray

FILE /etc/portage/make.conf

    USE="aacs"

    emerge --ask media-libs/libbluray

    https://wiki.archlinux.org/title/Blu-ray

    ~/.config/aacs/KEYDB.cfg

## file-manager

    emerge --ask app-misc/lf \
        app-arch/atool \
        dev-perl/File-MimeInfo \
        sys-apps/bat

## mutt

    emerge --ask mail-client/neomutt \
        net-mail/isync \
        mail-mta/msmtp \
        www-client/lynx \
        net-mail/notmuch \
        app-misc/abook \
        mail-client/mutt-wizard

## android

    emerge --ask sys-fs/simple-mtpfs

## zathura, pdfpc

FILE /etc/portage/make.conf

    USE="pdf djvu"

    emerge --ask app-text/zathura \
        app-text/zathura-meta \
        app-misc/pdfpc

## fonts

    emerge --ask media-libs/fontconfig

    emerge --ask media-fonts/noto \
        media-fonts/noto-emoji \
        media-fonts/symbola \
        media-fonts/mikachan-font-ttf \
        media-fonts/fonts-meta \
        media-fonts/corefonts \
        media-fonts/fontawesome \
        media-fonts/liberation-fonts

## gtk

FILE etc/portage/make.conf

    USE="gtk"

    emerge --ask lxde-base/lxappearance  \
        x11-libs/gtk+ \
        gui-libs/gtk

## gtk2 or qt5ct for qt

    emerge --ask dev-qt/qtstyleplugins
    or
    emerge --ask x11-misc/qt5ct

## python

    emerge --ask dev-python/ipython \
        dev-python/black \
        dev-python/flake8 \
        sci-libs/tensorflow \
        sci-libs/scikit-learn \
        dev-python/pandas \
        dev-python/matplotlib

## latex

    emerge --ask app-text/texlive \
        dev-texlive/texlive-langcyrillic \
        dev-tex/biber \
        dev-tex/latexmk

## ? stylua

    ? ambasta layer

    eselect repository enable ambasta
    emerge --sync ambasta
    emerge --ask dev-lua/StyLua

## pam-gnupg

    eselect repository enable guru
    emerge --sync guru
    emerge --ask sys-auth/pam-gnupg


    echo UPDATESTARTUPTTY | gpg-connect-agent
    shh-add

    add keygrips to .config/pam-gnupg
    for gpg:
    gpg -K --with-keygrip
    for ssh:
    gpg-connect-agent 'keyinfo --ssh-list' /bye

## write-good

    npm install write-good

## tldr++

    go get github.com/isacikgoz/tldr/cmd/tldr

### crontab -e

    */15 * * * * ~/.local/bin/cron/newsup

## wayland switch

    wofipassmenu
    https://github.com/ovlach/wofipassmenu
    https://github.com/tasmo/passwmenu

    swhkd
    https://github.com/waycrate/swhkd

    emerge --ask gui-apps/waybar \
        gui-apps/wl-clipboard \
        gui-apps/grim \
        gui-apps/swaylock \
        gui-apps/swaylock-effects \
        gui-apps/wlogout \
        gui-apps/wf-recorder \
        gui-apps/wofi \

vim etc/portage/make.conf

    use="X"

## gdm

    emerge -a gnome-base/gdm
    emerge -an gui-libs/display-manager-init

FILE /etc/conf.d/display-manager

    DISPLAYMANAGER="gdm"

    rc-update add display-manager default
    rc-service display-manager start

## sway

    emerge --ask gui-wm/sway \
        gui-libs/xdg-desktop-portal-wlr


## hyprland

emerge -avn gui-libs/wlroots

emerge -avn gdb \
    dev-util/ninja \
    sys-devel/gcc \
    dev-util/cmake \
    x11-libs/libxcb
    x11-base/xcb-proto
    x11-libs/xcb-util \
    x11-libs/xcb-util-keysyms \
    x11-libs/libXfixes \
    x11-libs/libX11 \
    x11-libs/libXcomposite \
    x11-apps/xinput \
    x11-libs/libXrender \
    x11-libs/pixman \
    dev-libs/wayland-protocols \
    x11-libs/cairo \
    x11-libs/pango
