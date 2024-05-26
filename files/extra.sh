#!/bin/bash

set -e
mkdir -p /usr/share/chromium/extensions
# base url
l="https://clients2.google.com/service/update2/crx"
# query string
l+="?response=redirect&acceptformat=crx2,crx3&prodversion=200.0"
# extension parameter
l+="&x=uc%26id%3D"

wget -q --show-progress -P /usr/share/zsh/plugins "https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"
sudo -u user code $(cat files/vsc.txt)

while read -r x; do
    wget -q --show-progress --trust-server-names -P ~/.local/share/chrome "$l$x"
done < <(grep -v "#" files/crx.txt)

for f in ~/.local/share/chrome/*; do
    x=$(basename "${f,,}" .crx)
    v="${f#*_}" v="${v%.*}" v="${v//_/.}"
    echo "$v"
    printf '{\n\t"external_crx": "%s",\n\t"external_version": "%s"\n}\n' "$f" "$v" >/usr/share/chromium/extensions/"$x".json
done