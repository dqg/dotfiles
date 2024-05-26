#!/bin/sh

set -e
export HOME="/home/user"

sed -i "/NOPASSWD/s/# //" /etc/sudoers
useradd user -g wheel -G root -p "" -s /bin/zsh
cp -r user /home
chown -R user:wheel ~

if [ -f pkg2.tar.zst ]; then
    tar --zstd -xf pkg2.tar.zst -C /tmp
    pacman -U --noconfirm /tmp/pkg/*.zst
else
    sudo -u user yay -Sy --noconfirm --cachedir /tmp/pkg --mflags "--skippgpcheck" $(grep -v "#" files/pkg.txt)
    mv -v ~/.cache/yay/*/*.zst /tmp/pkg
    tar --zstd -cf pkg2.tar.zst -C /tmp pkg
fi

ln -sv codium /bin/code
ln -sv chromium /bin/chrome
mv /tmp/pkg/* /var/cache/pacman/pkg
rm -r /tmp/pkg
files/extra.sh
chown -R user:wheel ~