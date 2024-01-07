#!/bin/sh

mkdir /x
x="$PWD"

if [ -f pkg2-*.txz ]; then
	pv pkg2-*.txz | tar -JxC /x
	pacman -U --noconfirm /x/*
	[ -n "$1" ] && {
		pacman -Sy --cachedir /x --noconfirm $@ || exit 1
		pacman -Q $@
		(cd /x; tar -c * | pv -s $(du -sb /x | cut -f 1) | xz >$x/x.txz)
		echo "[1;31m$(du pkg2-*.txz | cut -f 1)[0m -> [1;32m$(du x.txz | cut -f 1)[0m"
		echo "[1;31m$(du -h pkg2-*.txz | cut -f 1)[0m -> [1;32m$(du -h x.txz | cut -f 1)[0m"
		mv x.txz pkg2-*.txz
	}
else
	pacman -Sy --cachedir /x --noconfirm $(cat list) || exit 1
	(cd /x; tar -c * | pv -s $(du -sb /x | cut -f 1) | xz >$x/pkg2-$(date "+%Y%m%d").txz)
fi

useradd user -g wheel -G root -p "" -s /bin/zsh
cp -r user /home
echo "permit nopass :wheel" >/etc/doas.conf
chown -R user:wheel /home/user
chmod +x /home/user/.local/bin/*
mv /x/* /var/cache/pacman/pkg
rm -r /x
