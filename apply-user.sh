#!/bin/sh
pushd ~/.dotfiles
sudo nix build .#homeConfigurations.maddux.activationPackage
./result/activate
popd
