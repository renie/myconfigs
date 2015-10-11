#!/bin/bash

if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
cp .bashrc ~
cp .bash_aliases ~

. ~/.bashrc
