#!/bin/bash
sudo /usr/sbin/dpkg-reconfigure tzdata
sudo /usr/sbin/dpkg-reconfigure locales

cd .dotfiles
stow .x
stow bash
stow colors
stow compton
stow local
cd config
stow -t ~ dunst
stow -t ~ i3-gaps
stow -t ~ polybar
stow -t ~ rofi
stow -t ~ zathura
