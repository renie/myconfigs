#!/bin/bash
inittime=$(date +%s)



printf "\nInstaller...\n\n\n"



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
# Storing system info
###
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

if [ -f /etc/debian_version ]; then
	OS="D"
elif [ -f /etc/redhat-release ]; then
	OS="R"
else
	OS=$(uname -s)
fi



###
# Setting variables
###
nodeversion="4.2.0"
nodearch=$ARCH
while [ "$1" != "" ]; do
	case $1 in
		--nodeversion )   shift
			nodeversion=$1
		;;
		--nodearch )   shift
			nodearch=$1
		;;
		-h )   shift
			printf "Allowed parametes:\n\n"
			printf "\t--nodeversion\t\tVersion of NodeJS you want. Check available versions on https://nodejs.org/en/download/releases/ \n"
			printf "\t\t\t\t(io.js not included)\n"
			printf "\t\t\t\t(default: 4.0.2)\n\n"

			printf "\t--nodearch\t\tArchiteture of NodeJS you want\n"
			printf "\t\t\t\t(default: 64)\n"
			printf "\n\n\n"
			exit 1
		;;
		* )
			printf "Invalid param: $1\n\n\n"
			exit 1
	esac
	shift
done



printf "Running installer\n\n"



if [ $OS == "D" ]; then

	###
	# Git installing
	###
	printf "GIT install...\n"

	if verifyCommandExistence git; then
		printf "Git is already installed.\n"
	else
		sudo apt-get install git
		printf "GIT installed.\n\n"
	fi

	###
	# Sublime installing
	###
	printf "Sublime install...\n"

	if verifyCommandExistence subl; then
		printf "Sublime is already installed.\n"
	else
		cd ~/Downloads
		wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
		sudo dpkg -i sublime-text_build-3083_amd64.deb
		wget https://sublime.wbond.net/Package%20Control.sublime-package

		if [ ! -d ~/.config/sublime-text-3/Installed\ Packages]; then
			mkdir -p ~/.config/sublime-text-3/Installed\ Packages
		fi

		cp Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages

		printf "Sublime Text installed.\n"
	fi

	###
	# Copying Sublime settings
	###
	backToScriptDir
	if [ ! -d ~/.config/sublime-text-3/Packages/User/]; then
		mkdir -p ~/.config/sublime-text-3/Packages/User/
	fi

	cp Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
	cp Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/
	printf "Sublime asks for restarting itself for installing everything ¯\_(ツ)_/¯.\n\n"

else
	printf "This script cannot install Sublime in your system yet. For now we just support Debian like systems."
fi



###
# Node installing
###
printf "NodeJS install...\n"
nodev=${nodeversion//./""}
nodefile="node-v$nodeversion-linux-x$nodearch.tar.gz"
nodepath="node-v$nodeversion-linux-x$nodearch"
nodeurl="https://nodejs.org/dist/v$nodeversion/$nodefile"

if verifyCommandExistence node; then
	printf "NodeJS is already installed.\n\n"
else
	cd ~/Downloads
	wget $nodeurl
	tar xvzf $nodefile
	sudo cp -rp $nodepath /usr/local/
	sudo mv /usr/local/$nodepath /usr/local/node_v$nodev
	sudo ln -s /usr/local/node_v$nodev/bin/node /usr/local/bin/node
	sudo ln -s /usr/local/node_v$nodev/bin/npm /usr/local/bin/npm
	printf "NodeJS $nodeversion installed.\n\n"
fi



###
# Grunt and bower installing
###
printf "Installing Grunt...\n"
sudo npm install -g grunt-cli
printf "Grunt installed.\n\n"
printf "Installing Bower...\n"
sudo npm install -g bower
printf "Bower installed.\n\n"



###
# Copying bash scripts session
###
printf "Copying aliases and environment configs...\n"
backToScriptDir
if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
printf "Your bashrc was backed up at ~/.bashrc__bkp .\n"
cp .bashrc ~
printf "Your bashrc was updated.\n"
cp .bash_aliases ~
printf "Your bash_aliases was updated.\n"

. ~/.bashrc
printf "Your bashrc was executed.\n\n"



###
# Ending timer
###
finaltime=$(date +%s)
t=$(($finaltime-$inittime))

printf "Time spent: $t s\n\n"



###
# Last warnings
###
printf "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs.\n\n"
printf "Install process finished!!"
printf "\n\n\n"
