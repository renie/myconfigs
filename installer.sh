#!/bin/sh

echo "Running installer"


###
# Storing script directory
###
current_dir=$(pwd)
script_dir=$(dirname $0)

if [ $script_dir = '.' ]; then
	script_dir="$current_dir"
fi

backToScriptDir(){
	cd "$script_dir"
}

verifyCommandExistence(){
	return $(which $1 >/dev/null)
}


###
# Sublime installing
###
if verifyCommandExistence subl; then
	echo "Sublime is already installed."
else
	cd ~/Downloads
	wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
	sudo dpkg -i sublime-text_build-3083_amd64.deb
	wget https://sublime.wbond.net/Package%20Control.sublime-package
	cp Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages
	echo "Sublime Text installed."
	echo "Sublime asks for restarting itself for installing everything ¯\_(ツ)_/¯."
fi


###
# Node installing
###
if ! verifyCommandExistence node; then
	echo "NodeJS is already installed."
else
	cd ~/Downloads
	wget https://nodejs.org/dist/v4.2.0/node-v4.2.0-linux-x64.tar.gz
	tar xvzf node-v4.2.0-linux-x64.tar.gz
	sudo cp -rp node-v4.2.0-linux-x64 /usr/local/
	sudo mv /usr/local/node-v4.2.0-linux-x64 /usr/local/node_v420
	sudo ln -s /usr/local/node /usr/local/node_v420
	#set PATH=$PATH:/usr/local/node_v420/bin
	#echo $PATH
	echo "TODO: Add /usr/local/node_v420/bin to PATH."
	echo "NodeJS 4.0.2 installed."
fi


###
# Copying Sublime settings
###
backToScriptDir
cp Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
cp Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/


###
# Copying bash scripts session
###
backToScriptDir
if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
cp .bashrc ~
cp .bash_aliases ~

. ~/.bashrc


###
# Last warnings
###
echo "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs."
