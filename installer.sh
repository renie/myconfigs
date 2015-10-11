#!/bin/bash

echo "Running installer"

# Storing script directory
current_dir=$(pwd)
script_dir=$(dirname $0)

if [ $script_dir = '.' ]; then
	script_dir="$current_dir"
fi


# Sublime installing
if ! which subl >/dev/null; then
	cd ~/Downloads
	wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
	sudo dpkg -i sublime-text_build-3083_amd64.deb
else
	echo "Sublime is already installed."
fi


# Copying bash scripts session
cd "$script_dir"
if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
cp .bashrc ~
cp .bash_aliases ~

. ~/.bashrc

echo "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs."
