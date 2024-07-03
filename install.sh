#!/bin/sh

set -e
export HOME="/home/user"

sed -i "/NOPASSWD/s/# //" /etc/sudoers
useradd user -g wheel -G root -p "" -s /bin/zsh
cp -r user /home
chown -R user:wheel ~

if [ -f pkg2.tar ]; then
    tar -xf pkg2.tar -C /tmp
    pacman -U --noconfirm /tmp/pkg/*.zst
else
    sudo -u user yay -Sy --noconfirm --cachedir /tmp/pkg --mflags "--skippgpcheck" $(grep -v "#" files/pkg.txt)
    mv -v ~/.cache/yay/*/*.pkg.tar.zst /tmp/pkg
    tar -cf pkg2.tar -C /tmp pkg
fi

mkdir ~/.cache/lf
mv /tmp/pkg/* /var/cache/pacman/pkg
files/extra.sh
chown -R user:wheel ~
