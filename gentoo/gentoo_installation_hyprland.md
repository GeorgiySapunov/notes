## USE flags

FILE etc/portage/make.conf

    USE="-systemd -gnome -kde -dvd -dvdr -cdr wayland policykit dbus udev networkmanager bluetooth sound-server screencast ffmpeg aacs pdf djvu ibus wifi"

    emerge --verbose --update --deep --newuse @world
    
## Waland

FILE etc/portage/make.conf

    USE="wayland"
    
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

    emerge -ask sys-auth/polkit-qt

## d-bus

FILE etc/portage/make.conf

    USE="dbus"

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
    
    gpasswd -a (user name) plugdev
    
    for x in /etc/runlevels/default/net.* ; do rc-update del $(basename $x) default ; rc-service --ifstarted $(basename $x) stop; done
    rc-update del dhcpcd default
    
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

    emerge --ask net-print/cups

    rc-service cupsd start
    rc-update add cupsd default

## pipewire

FILE /etc/portage/make.conf

    USE="sound-server screencast"
    
    emerge --ask media-video/pipewire
    
Starting PipeWire with various non-systemd setups

FILE ~/.config/sway/config
    
    exec gentoo-pipewire-launcher

## git

    emerge --ask dev-vcs/git
    
    ? lazygit

## tor

    emerge --ask net-vpn/tor
    emerge --ask net-proxy/torsocks
    emerge --ask net-proxy/obfs4proxy
    
    rc-service tor start
    rc-update add tor default
    
    eselect repository enable torbrowser
    emerge --ask www-client/torbrowser-launcher

## brave

    eselect repository enable brave-overlay
    emerge --ask brave-bin

## npd

    emerge net-misc/ntp
    
    rc-service ntpd start
    rc-update add ntpd default

## zsh

    emerge --ask app-shells/zsh
    emerge --ask app-shells/gentoo-zsh-completions
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
    
    emerge --ask media-video/ffmpeg
    emerge --ask media-video/mpv
    emerge --ask media-video/mediainfo
    emerge --ask media-video/ffmpegthumbnailer
    emerge --ask net-misc/yt-dlp
    emerge --ask media-sound/mpd
    emerge --ask media-sound/ncmpcpp
    
    rc-service mpd start 
    rc-update add mpd default


## also

    emerge --ask gnome-base/gnome-keyring
    emerge --ask net-news/newsboat
    emerge --ask media-gfx/sxiv
    emerge --ask app-office/calcurse
    emerge --ask media-gfx/gimp
    emerge --ask media-gfx/inkscape
    emerge --ask media-gfx/blender
    emerge --ask app-office/libreoffice
    emerge --ask x11-misc/pcmanfm 
    emerge --ask app-shells/fzf
    emerge --ask app-admin/testdisk
    emerge --ask sys-apps/moreutils
    emerge --ask app-editors/neovim
    emerge --ask sys-fs/ncdu
    emerge --ask sys-apps/ripgrep
    emerge --ask app-i18n/ibus ibus-libpinyin
    emerge --ask app-misc/neofetch
    emerge --ask kde-apps/okular
    emerge --ask net-im/telegram-desktop
    emerge --ask sys-process/htop
    emerge --ask app-misc/anki
    emerge --ask app-crypt/gnupg
    emerge --ask app-admin/pass
    emerge --ask app-crypt/pinentry
    emerge --ask net-p2p/transmission
    emerge --ask net-p2p/tremc
    emerge --ask net-misc/wget
    emerge --ask net-analyzer/bmon
    emerge --ask media-sound/pulsemixer
    emerge --ask app-misc/tmux
    emerge --ask sys-apps/mlocate

## blueray

FILE /etc/portage/make.conf

    USE="aacs"

    emerge --ask media-libs/libbluray

    https://wiki.archlinux.org/title/Blu-ray
    
    ~/.config/aacs/KEYDB.cfg
    
## file-manager

    emerge --ask app-misc/ranger
    emerge --ask app-arch/atool
    emerge --ask dev-perl/File-MimeInfo
    emerge --ask sys-apps/bat

## mutt

    emerge --ask mail-client/neomutt
    emerge --ask net-mail/isync
    emerge --ask mail-mta/msmtp
    emerge --ask www-client/lynx
    emerge --ask net-mail/notmuch
    emerge --ask app-misc/abook
    emerge --ask mail-client/mutt-wizard
    
## android

    emerge --ask sys-fs/simple-mtpfs
    
## zathura, pdfpc

FILE /etc/portage/make.conf

    USE="pdf djvu"
    
    emerge --ask app-text/zathura
    emerge --ask app-text/zathura-meta
    emerge --ask app-misc/pdfpc

## fonts

    emerge --ask media-libs/fontconfig
    
    emerge --ask media-fonts/noto
    emerge --ask media-fonts/noto-emoji
    emerge --ask media-fonts/symbola
    emerge --ask media-fonts/mikachan-font-ttf
    emerge --ask media-fonts/fonts-meta
    emerge --ask media-fonts/corefonts
    emerge --ask media-fonts/fontawesome
    emerge --ask media-fonts/liberation-fonts

## gtk

    emerge --ask lxde-base/lxappearance 
    emerge --ask x11-libs/gtk+
    emerge --ask gui-libs/gtk

## python

    emerge --ask dev-python/ipython
    emerge --ask dev-python/black
    emerge --ask dev-python/flake8
    emerge --ask sci-libs/tensorflow
    emerge --ask sci-libs/scikit-learn
    emerge --ask dev-python/pandas
    emerge --ask dev-python/matplotlib

## latex

    emerge --ask app-text/texlive
    emerge --ask dev-texlive/texlive-langcyrillic
    emerge --ask dev-tex/biber
    emerge --ask dev-tex/latexmk

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

    emerge --ask gui-apps/waybar
    emerge --ask gui-apps/wl-clipboard
    emerge --ask gui-apps/grim
    emerge --ask gui-apps/swaylock
    emerge --ask gui-apps/swaylock-effects
    emerge --ask gui-apps/wlogout
    emerge --ask gui-apps/wf-recorder
    emerge --ask gui-apps/wofi
    emerge --ask gnome-base/gdm
