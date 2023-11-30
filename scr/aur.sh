#!/bin/sh

mv /x/* /var/cache/pacman/pkg
if [ -f "$(echo pkg3-*.txz)" ]; then
	tar -Jxvf pkg3-*.txz -C /x
	pacman -U --noconfirm /x/*
else
	curl -L "https://builds.garudalinux.org/repos/chaotic-aur/x86_64" |
	grep -o "\"[^<]*\.pkg\.tar\.zst\"" |
	sed "/-git/d; s/\"//g; s/%2B/+/g; s/%3A/:/g" >/tmp/chaotic-aur
	for x in eww-wayland gotop rofi-lbonn-wayland; do
	curl -LO --output-dir /x "https://builds.garudalinux.org/repos/chaotic-aur/x86_64/$(grep "$x" /tmp/chaotic-aur)"
	done
	pacman -Sy && pacman -U --cachedir /x --disable-download-timeout --noconfirm /x/*
	x="$PWD"
	(cd /x && tar -Jcvf $x/pkg3-$(date "+%Y%m%d").txz *.pkg.tar.zst)
fi

chown -R user:wheel /home/user
chmod -R 777 /home/user/.local/bin
rm -r /x
