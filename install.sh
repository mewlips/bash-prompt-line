#!/bin/sh

ln -sf "$PWD"/bash-prompt-line.$HOME/.bash-prompt-line
echo "source $HOME/.bash-prompt-line" >> $HOME/.bashrc
