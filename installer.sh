#!/bin/bash

if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
cp .bashrc ~
cp .bash_aliases ~

. ~/.bashrc

echo "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs."
