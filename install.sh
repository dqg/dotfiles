#!/bin/sh

chmod -R 777 scr
scr/package.sh || exit 1
scr/aur.sh || exit 1
