#!/bin/sh

ln -sf "$PWD"/bash-prompt-line.bash $HOME/.bash-prompt-line
echo "source $HOME/.bash-prompt-line" >> $HOME/.bashrc
