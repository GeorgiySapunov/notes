## 27. ИКСЫ!!! XORG!!!

    lspci | grep -i vga - узнаем, что у нас за видеокарта

    nano -w /etc/portage/make.conf

    VIDEO_CARDS="intel"       # для Intel 1st Generation
    VIDEO_CARDS="intel i915"  # для Intel 2nd and 3rd Generation
    VIDEO_CARDS="intel i965"  # для Intel 4-9th Generation
    VIDEO_CARDS="radeon"      # для карт AMD/ATI
    VIDEO_CARDS="nouveau"     # для карт Nvidia

    Вписать нужное

    emerge --ask --changed-use --deep @world - обновление "МИРА" с учётом изменений в файле /etc/portage/make.conf


    Установка Xorg

    emerge --ask xorg-server twm xorg-drivers xterm (xorg-x11 - для виртуалки)

    Обноовление и применение профиля

    env-update
    source /etc/profile

## 28. Установка XFCE

    nano -w /etc/portage/make.conf

    XFCE_PLUGINS="battery brightness clock power" - Это для ноутов
    USE="-gnome -kde -minimal -qt4 dbus jpeg lock session startup-notification thunar udev X gtk3 pulsaudio alsa dhcp"

## 29. Ставим XFCE 

    emerge --ask xfce-base/xfce4-meta xfce-extra/xfce4-notifyd app-editors/mousepad x11-terms/tilda media-sound/pavucontrol x11-themes/gtk-engines-xfce 

    emerge --ask lxdm

    env-update && source /etc/profile - обновляем и перечитываем профиль
     
    echo XSESSION="Xfce4" > /etc/env.d/90xsession - для автостарта XFCE при старте самих иксов

    /etc/init.d/dbus start

    rc-update add dbus default

    emerge --ask gui-libs/display-manager-init - система инициализации менеджера
    rc-update add display-manager default - стартовый дисплейный менеджер и меняем там конфиг

    nano -w /etc/conf.d/display-manager

    Меняем значение, чтоб было
    DISPLAYMANAGER="lxdm"


    /etc/lxdm/lxdm.conf

    Ищем #autologin=dgod раскоментируем и меняем имя пользователя на свой. Это автовход


## 30. reboot

## 31. Полезный софт, вдруг пригодится

    emerge --ask xfce-extra/xfce4-mixer xfce-extra/xfce4-volumed xfce-extra/xfce4-power-manager xfce-extra/xfce4-battery-plugin x11-terms/xfce4-terminal xfce-extra/thunar-volman xfce-extra/thunar-archive-plugin xfce-base/xfce4-appfinder app-editors/mousepad xfce4-xkb-plugin 


    Evince умеет смотреть pdf и djvu. Для Evince по умолчанию отключён флаг djvu, а флаг gnome стоит. Чтобы добавить djvu и убрать gnome, пропишите
    sudo nano -w /etc/portage/package.use

    app-text/evince -gnome djvu

    И ставим его

    emerge --ask app-text/evince

    Браузеры и прочее

    sudo emerge --jobs=2 --ask xfce4-xkb-plugin

    sudo emerge --jobs=2 --ask dev-vcs/git app-misc/mc net-p2p/qbittorrent net-p2p/qbittorrent x11-drivers/nvidia-drivers net-misc/wget dev-ruby/git x11-drivers/nvidia-drivers www-client/firefox www-client/google-chrome app-portage/gentoolkit app-portage/eix

    Для установки 32битных версий видеодрайвера надо дописать в package.use

    sudo nano -w /etc/portage/package.use
    ветка/пакет abi_x86_32

## 32. Кириллица в виртуальных консолях

    Если в виртуальной консоли (те, что открываются по Ctrl + Alt + F1…F6) кириллица не отображается корректно, чиним так (информация взята с oldnix.org и немного подредактирована).

    Осторожно, после выполнения этих комманд могут сменить вид все шрифты в системе, в браузере и т.д. Исследуйте этот вопрос, если это важно. Я не уверен, что ставить нужно все пакеты. 

    Установим шрифты с поддержкой кириллицы:
    emerge freefonts corefonts cronyx-fonts terminus-font

    Проверьте, что в /etc/locale.gen стоят правильные настройки

    Если было что-то другое, то замените и примените новые настройки к системе:

    locale-gen

    Добавьте в /etc/rc.conf

    unicode="YES"

    Далее

    sudo nano -w /etc/conf.d/consolefont

    consolefont="cyr-sun16"

    sudo nano -w /etc/conf.d/keymaps
    keymap="-u ru"

    Теперь проверьте, переключается ли язык в виртуальных консолях и корректно ли отображаются русские буквы. Если нет, то в файл /etc/conf.d/keymaps добавьте dumpkeys_charset="koi8-r" и снова перезапустите /etc/init.d/keymaps restart.


## 33. Горячие клавиши не работают

    /etc/init.d/consolekit start
    rc-update add consolekit default

## 34. Не работает звук и вебкамера

    При попытке запустить xfce4-mixer появляется ошибка

    Это может быть связано с тем, что пользователь не добавлен в группу audio. Чтобы добавить его в audio (и в video для работы вебкамеры), можно сделать так:

    gpasswd -a user audio
    gpasswd -a user video

    Пользователи NVidia

    Для пользователей NVidia имеется возможность запустить nvidia-xconfig с целью генерации файла xorg.conf для выбранной видеокарты. Без этого шага xorg.conf необходимо создать вручную как описано ниже. Отсутствующий xorg.conf иногда будет выводить ошибку "No screens found" при попытке выполнить startx.

    Драйвер NVidia будет работать только после перезагрузки, так что сделайте это после выполнения nvidia-xconfig.
    root #nvidia-xconfig

    Возможно и рекомендуется установить для OpenGL аппаратный рендеринг вместо программного:
    root# eselect opengl set nvidia
