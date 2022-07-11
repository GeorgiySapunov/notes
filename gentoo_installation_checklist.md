# Чек-лист установки gentoo linux

    lsblk -f

##  1. Разметка диска

    cfdisk - псевдографическая утилита
    fdisk
    gdisk - для автоматической разметке в таблице GPT
     
    К примеру gdisk
    
    gdisk /dev/sdX
    
    Ключ на создание раздела: n (gpt)
    
    Далее согласиться с разделами по умолчанию.
    
    512M - EFI EF00
    2G - swap 8200
    остальное под файловую систему линукс 8300
    
    Форматирование
    
    Boot-раздел -   mkfs.fat -F32 /dev/sda1
    SWAP            mkswap -L swap /dev/sda2
    Включить swap   swapon /dev/sda2
    
    Создание тома и подтомов (субволумов)
    
    mkfs.ext4 -L Gentoo /dev/sda3

## 2. Монтирование разделов

    mount /dev/sda3 /mnt/gentoo
    mkdir /mnt/gentoo/boot
    mount /dev/sda1 /mnt/gentoo/boot
    
    Сверить дату для выбора сборки stage3
    
    date

## 3. Открыть каталог gentoo и скачать образ

    cd /mnt/gentoo

    links https://www.gentoo.org/downloads/mirrors/ - тут выбираем кто ближе

    releases/amd64/autobuilds/<date> - скачать по этому пути, по ближайшей дате

## 4. Распаковать архив stage3

    tar xJvpf stage3-*.tar.xz --xattrs --numeric-owner

    Переменная USE — это одна из самых крутых переменных в Gentoo. Она важна
    при установке программ. Как уже говорилось, все программы компилируются из
    исходников. Это увеличивает время установки, зато позволяет ставить именно
    те части программ, которые нужны данной системе. В этой инструкции
    предполагается, что в качестве графической оболочки будет использоваться
    XFCE. Эта оболочка легче Gnome и KDE, но всё-таки симпатичная и гибкая.
    Рекомендуемое значение этой переменной для пользователя XFCE приведено чуть
    ниже.

    Переменная CFLAGS по умолчанию имеет значение -O2 -pipe.

        -O2 (буква O — Optimization, а не ноль) контролирует общий уровень
        оптимизации. Не рекомендуется менять без острой необходимости.
        Подробнее про возможные значения переменной на
        wiki.gentoo.org/wiki/GCC_optimization#-O.

        -pipe не влияет на сгенерированный код, но ускоряет процесс компиляции.

        -march=... Часто рекомендуют прописать конкретный тип процессора
        (например, -march=core-avx-i, -march=core-avx2, -march=corei7-avx,
        -march=core2, -march=pentium-m и т.д., чтобы программы компилировались
        именно для конкретного типа процессора. Много примеров на
        wiki.gentoo.org/wiki/Safe_CFLAGS). Если архитектура процессора
        неизвестна, в большинстве случаев можно использовать -march=native. Но
        лучше не менять CFLAGS, хорошо не разобравшись в смысле происходящего.

    Переменная MAKEOPTS отвечает за параллелизацию выполняемых операций. Если
    на машине двухъядерный или четырёхъядерный процессор, обычно рекомендуется
    значение MAKEOPTS="-j<количество ядер + 1>", т.е. MAKEOPTS="-j3" для
    двухъядерного и MAKEOPTS="-j5" для четырёхъядерного процессора.

    С помощью текстового редактора nano (или другого по выбору) редактируем
    файл:

    /mnt/gentoo/etc/portage/make.conf

    CFLAGS="-O2 -pipe -march=corei7-avx"
    # Для 8 потоков
    MAKEOPTS="-j5"
    # Для графической оболочки XFCE
    USE="-gnome -kde -minimal -qt4 dbus jpeg lock session startup-notification thunar udev X gtk3 pulsaudio alsa dhcp "

    GENTOO_MIRRORS="https://mirror.yandex.ru/gentoo-distfiles/"

    VIDEO_CARDS="nouveau"

    Для виртуальной машины virtualbox - вписать virtualbox в кавычки

## 5. Выбор зеркала

    mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

    Для основного репозитория Gentoo:

    mkdir /mnt/gentoo/etc/portage/repos.conf
    cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf


    Копируем информацию о DNS

    cp -L /etc/resolv.conf /mnt/gentoo/etc/

## 7. Монтируем необходимые разделы

    mount -t proc proc /mnt/gentoo/proc
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev

## 8. Входим в новое окружение

    chroot /mnt/gentoo /bin/bash
    source /etc/profile
    export PS1="(chroot) $PS1"

    Причерутились

## 9. Обновление списка пакетов для Portage

    Эта команда получит снимок текущего состояния Portage, системы управления
    пакетами в Gentoo.

    emerge-webrsync


    Возможные ошибки:

    !!! Section 'gentoo' in repos.conf has location attribute
    set to nonexistent directory: '/usr/portage'

    !!! Repository x-portage is missing masters attribute in
    /usr/portage/metadata/layout.conf

    Увидев эти ошибки, я прервал операцию, нажав Ctrl + C, и сделал следующее:

    mkdir /usr/portage
    mkdir -p /usr/portage/metadata/ 
    nano -w /usr/portage/metadata/layout.conf

    /usr/portage/metadata/layout.conf и там написать

    masters = gentoo

    После этого emerge-webrsync запустился без ошибок.


## 10. Выбираем правильный профиль - для XFCE искать тот, что default/linux/amd64/**.*/desktop

    eselect profile set 3 - к примеру. Там надо внимательно цифры смореть.


    После обновляем "МИР"

    emerge --ask --update --deep --newuse @world

    Если по какому-то пакету отругался, что надо поменять флаг, делаем следущее

    cd /etc/portage/
    rmdir package.use

    А потом надо создать текстовик, но с ем же именем, с тем же каталогом

    nano -w /etc/portage/package.use

    И там записать что надо делать по типу "ветка/имя_пакета флаги" -флаг - это
    значит определённый модуль задействоваться не будет.

    По факту это пересборка под профиль всего.

## 11. Часовой пояс

    ls /usr/share/zoneinfo - посмотреть и там уже выбрать регион и пояс

    echo "Asia/Vladivostok" > /etc/timezone

    Обновим информацию о часовом поясе в системе:

    emerge --config sys-libs/timezone-data

## 12. Настройка локалей

    nano -w /etc/locale.gen и прописать

    en_US.UTF-8 UTF-8
    ru_RU.UTF-8 UTF-8


    locale-gen


    eselect locale list - и выбрать локаль, но надо выбрать en_US

## 13. Обновляем окружение

    env-update && source /etc/profile && export PS1="(chroot) $PS1"


## 14. Сборка ядра

    emerge --ask sys-kernel/gentoo-sources - ставим исходники

    emerge --ask sys-kernel/genkernel - ставим ядро

    genkernel all - собираем ядро со всем, что есть - это для новичков

    emerge --ask sys-kernel/linux-firmware - установка драйверов ядра

    Создаём fstab 

    nano -w /etc/fstab - и вбить следующее

    /dev/sda1	/boot	ntfs	defaults	0 2 - путь смортим в lsblk

    Либо через UUID

    Для того надо глянуть

    blkid

    И далее вбить 

    UUID точка_монтирования файловая_система аргументы цифры - ориентируйся по шаблону


## 15. Имя машины 

    nano -w /etc/conf.d/hostname

    hostname="user_name"


## 16. Настройка сети. Важно, вам надо узнать имя сетевого интерфейса, хотя бы введя, ip a (Либо поднять /etc/init.d/sshd start и ввести ip a sh)

    Установка netifrc

    Для работы сети установим netifrc и отредактируем /etc/conf.d/net:


    emerge --ask --noreplace net-misc/netifrc

    nano -w /etc/conf.d/net
    config_eno1="dhcp"
    routes_eno1="default via 192.168.0.1"

    ln -s net.lo net.eno1
    rc-update add net.eno1 default

## 17.	HOST
 
    nano -w /etc/hosts

    127.0.0.1 имя_машины localhost
    ::1       localhost

## 18.	Ставим пароль на root

    passwd - не менее 8 символов и сложный, но есть другой вариант:

    Для смены пароля, сначала его шифруем:
    делается это так:
    openssl passwd -1 -salt xyz новый_пароль .
    Копируем то что получилось.
    После этого заходим в файл /etc/shadow и редактируем его и в первой строчке
    где будет ключ это убираем и вставляем то что получилось с той команды.


## 19.	Настройка загрузки и автозагрузки

    nano -w /etc/conf.d/keymaps

    keymap="us"
    windowkeys="YES"
    extended_keymaps=""
    dumpkeys_charset=""

## 20. Установка системных программ

    Чтобы можно было залогиниться в систему:

    emerge --ask app-admin/sysklogd
    rc-update add sysklogd default

    Утилита файловой системы ext4

    emerge --ask sys-fs/e2fsprogs

    emerge --ask net-misc/dhcpcd - сетевая программа

    Установка загрузчика

    emerge --ask sys-boot/grub:2

    Далее если Legacy BOOT

    grub-install /dev/sda

    Если EFI

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

    Далее, чтоб система видела соседей

    emerge --ask --newuse sys-boot/os-prober sys-fs/ntfs3g

    Конфиг граба
    grub-mkconfig -o /boot/grub/grub.cfg 

## 21. Выход и размонтирование

    exit

    umount -l /mnt/gentoo/dev{/shm,/pts,}
    umount /mnt/gentoo{/boot,/sys,/proc,}

    Скрестим пальцы на ногах

    reboot

    Если бандура завелась, выдыхаем, получаем root'a и едем дальше

## 22. Проверить сеть

    ifconfig

    Итак, если после установки Gentoo обнаружится, что вместо eth0 Ethernet адаптер называется eno1, то действуем так:

    Меняем config_eth0 → config_eno1 и routes_eno1 → routes_eth0 в /etc/conf.d/net. Можно вручную, можно командой:

    sed -i 's:eth0:eno1:g' /etc/conf.d/net

    затем выполняем

    ln -s net.lo net.eno1
    rm /etc/init.d/net.eth0
    rc-update add net.eno1 default
    rc-update del net.eth0 

    23. Создаём пользователя

    useradd -m -G users,wheel,audio,video -s /bin/bash user
    passwd user

## 24. Ставим sudo

    emerge --ask app-admin/sudo

    nano -w /etc/sudoers
    Ищем строчку wheel ALL=(ALL:ALL) ALL - раскоментируем

    Если нам потом кажут фигу, дописываем под root
    user ALL=(ALL:ALL) ALL

## 25. Почистим малость

    rm /stage3-* (добить Tab)

## 26.	INPUT_DEVICES

    Для поддержки тачпада нужен synaptics - это у кого ноут
    /etc/portage/make.conf	

    INPUT_DEVICES="evdev synaptics"

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
