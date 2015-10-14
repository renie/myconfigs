#!/bin/bash
inittime=$(date +%s)

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
# Variables
###
nodeversion="4.2.0"
while [ "$1" != "" ]; do
    case $1 in
        -n | --nodeversion )   shift
            nodeversion=$1
        ;;
        * )
			echo "Invalid param: $1"
            exit 1
    esac
    shift
done


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
fi


###
# Copying Sublime settings
###
backToScriptDir
cp Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
cp Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/
echo "Sublime asks for restarting itself for installing everything ¯\_(ツ)_/¯."


###
# Node installing
###
nodev=${nodeversion//./""}
nodefile="node-v$nodeversion-linux-x64.tar.gz"
nodepath="node-v$nodeversion-linux-x64"
nodeurl="https://nodejs.org/dist/v$nodeversion/$nodefile"

if verifyCommandExistence node; then
	echo "NodeJS is already installed."
else
	cd ~/Downloads
	wget $nodeurl
	tar xvzf $nodefile
	sudo cp -rp $nodepath /usr/local/
	sudo mv /usr/local/$nodepath /usr/local/node_v$nodev
	sudo ln -s /usr/local/node_v$nodev/bin/node /usr/local/bin/node
	sudo ln -s /usr/local/node_v$nodev/bin/npm /usr/local/bin/npm
	echo "NodeJS $nodeversion installed."
fi


###
# Grunt and bower installing
###
echo "Installing Grunt."
sudo npm install -g grunt-cli
echo "Grunt installed."
echo "Installing Bower."
sudo npm install -g bower
echo "Bower installed."


###
# Copying bash scripts session
###
backToScriptDir
if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
echo "Your bashrc was backed up at ~/.bashrc__bkp ."
cp .bashrc ~
echo "Your bashrc updated."
cp .bash_aliases ~
echo "Your bash_aliases updated."

. ~/.bashrc
echo "Your bashrc executed."

finaltime=$(date +%s)
t=$(($finaltime-$inittime))

echo "Time spent: $t s"


###
# Last warnings
###
echo "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs."
