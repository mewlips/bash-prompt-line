#!/usr/bin/env bash

ln -sf "$PWD"/bash-prompt-line.sh $HOME/.bash-prompt-line
echo "source $HOME/.bash-prompt-line" >> $HOME/.bashrc
