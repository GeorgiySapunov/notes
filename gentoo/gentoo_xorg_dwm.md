    emerge --deep --newuse --update --verbose @world xorg-server elogind network-manager dbus

    rc-update add NetworkManager default
