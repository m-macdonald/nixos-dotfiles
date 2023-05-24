#! /usr/bin/env bash
files=(/mnt/nas/media/images/pixiv/*)

random_background=${files[RANDOM % ${#files[@]}]}

if ! ps -ef | grep -v grep | grep -q "swww-daemon"; then
  swww init
fi

swww img "$random_background"
