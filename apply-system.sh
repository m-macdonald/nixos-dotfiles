#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild switch --flake .#desktop
popd
