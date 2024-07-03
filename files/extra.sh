#!/bin/sh

set -e
rm -r /tmp/pkg
ln -sv codium /bin/code

if [ -f pkg3.tar ]; then
    tar -xf pkg3.tar -C /tmp
    for f in /tmp/pkg/CachedExtensionVSIXs/*; do sudo -u user code --install-extension "$f"; done
else
    while read -r x; do
        wget -q --show-progress -P /tmp/pkg/extensions --trust-server-names "https://addons.mozilla.org/firefox/downloads/latest/$x/latest.xpi"
    done < files/ff.txt
    for f in /tmp/pkg/extensions/*; do
        id=$(unzip -p "$f" manifest.json | sed "s/applications/browser_specific_settings/" | jq -r ".browser_specific_settings.gecko.id")
        mv -v "$f" /tmp/pkg/extensions/"$id".xpi
    done

    sudo -u user code $(cat files/vsc.txt)
    cp -r ~/.config/VSCodium/CachedExtensionVSIXs /tmp/pkg
    for f in /tmp/pkg/CachedExtensionVSIXs/*; do mv -v "$f" "$f".vsix; done

    wget -q --show-progress -P /tmp/pkg "https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"
    tar -cf pkg3.tar -C /tmp pkg
fi

mv /tmp/pkg/extensions ~/.mozilla/firefox/user
mv -v /tmp/pkg/catppuccin_mocha-zsh-syntax-highlighting.zsh /usr/share/zsh/plugins
rm -r /tmp/pkg
