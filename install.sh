#!/usr/bin/env bash

git clone https://github.com/jamescherti/minimal-emacs.d ~/.config/emacs

ln -sf $PWD/pre-init.el ~/.config/emacs/pre-init.el
ln -sf $PWD/post-init.el ~/.config/emacs/post-init.el
ln -sf $PWD/pre-early-init.el ~/.config/emacs/pre-early-init.el 
