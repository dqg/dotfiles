#!/bin/sh

mkdir /x
if [ -f "$(echo pkg2-*.txz)" ]; then
	tar -Jxvf pkg2-*.txz -C /x
	pacman -U --assume-installed sudo rofi --noconfirm /x/*
else
	pacman -Sy --assume-installed sudo rofi --cachedir /x --disable-download-timeout --noconfirm $(sed "/^#/d" scr/list) || exit 1
	x="$PWD"
	(cd /x && tar -Jcvf $x/pkg2-$(date "+%Y%m%d").txz *.pkg.tar.zst)
fi

useradd user -g wheel -G root -p "" -s /bin/zsh
cp -r user /home
printf "permit nopass :%s as root\n" "wheel" "nobody" >/etc/doas.conf
