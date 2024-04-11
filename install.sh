#!/bin/sh

set -e
export HOME=/home/user
sed -i "/NOPASSWD/s/# //" /etc/sudoers
useradd user -g wheel -G root -p "" -s /bin/zsh
cp -r user /home
chown -R user:wheel ~

if [ -f pkg2.tar.zst ]; then
	tar --zstd -xf pkg2.tar.zst -C /tmp
	pacman -U --noconfirm /tmp/pkg/*
else
	o="-Sy --noconfirm --cachedir /tmp/pkg"
	pacman $o yay
	sudo -u user yay --mflags "--skippgpcheck" $o $(cat list)
	mv -v ~/.cache/yay/*/*.zst /tmp/pkg
	tar --zstd -cf pkg2.tar.zst -C /tmp pkg
fi

for i in dwm st dmenu dwmblocks; do
    git clone --depth 1 https://github.com/dqg/$i.git ~/.local/src/$i
    (cd ~/.local/src/$i && make install)
done

if [ -d vsc ]; then
    for i in vsc/*; do
        sudo -u user codium --install-extension $i
    done
else
    sudo -u user codium --install-extension ms-python.python
    sudo -u user codium --install-extension vscodevim.vim
    sudo -u user codium --install-extension Catppuccin.catppuccin-vsc
    sudo -u user codium --install-extension PKief.material-icon-theme
    sudo -u user codium --install-extension KevinRose.vsc-python-indent
    sudo -u user codium --install-extension oderwat.indent-rainbow

    mv ~/.config/VSCodium/CachedExtensionVSIXs vsc
    for f in vsc/*; do
        mv -v $f $f.vsix
    done
fi

mv /tmp/pkg/* /var/cache/pacman/pkg
rm -r /tmp/pkg
chown -R user:wheel ~
