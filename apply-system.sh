#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild switch --flake .#nixtop
popd
