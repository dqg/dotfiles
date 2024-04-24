#!/bin/bash

set -e
[ -d chrome ] || {
    l="https://clients2.google.com/service/update2/crx"
    p="?response=redirect&acceptformat=crx2,crx3&prodversion=200.0"
    grep -v "#" files/chrome.txt | while read -r extension; do
        x="&x=id%3D$extension%26uc"
        wget -q --show-progress --trust-server-names -P chrome "$l$p$x"
    done
    for f in chrome/*; do
        mv -v "$f" "${f,,}"
    done
}

cp -r chrome ~/.local/share
mkdir -p /opt/google/chrome-unstable/extensions
for f in ~/.local/share/chrome/*; do
    v="${f#*_}" v="${v%.*}" v="${v//_/.}"
    x="${f##*/}"
    echo "$v"
    printf '{\n\t"external_crx": "%s",\n\t"external_version": "%s"\n}\n' \
    "$f" "$v" >/opt/google/chrome-unstable/extensions/"${x%%_*}".json
done