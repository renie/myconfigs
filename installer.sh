#!/bin/bash

echo "Running installer"

# Storing script directory
current_dir=$(pwd)
script_dir=$(dirname $0)

if [ $script_dir = '.' ]; then
	script_dir="$current_dir"
fi

backToScriptDir(){
	cd "$script_dir"
}


# Sublime installing
if ! which subl >/dev/null; then
	cd ~/Downloads
	wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
	sudo dpkg -i sublime-text_build-3083_amd64.deb
	wget https://sublime.wbond.net/Package%20Control.sublime-package
	cp Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages
else
	echo "Sublime is already installed."
fi

# Copying Sublime settings
backToScriptDir
cp Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
cp Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/

# Copying bash scripts session
backToScriptDir
if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
cp .bashrc ~
cp .bash_aliases ~

. ~/.bashrc

# Last warnings
echo "Sublime Text asks for restarting itself for installing everything ¯\_(ツ)_/¯"
echo "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs."
