# general aliases
function mcd() {
    mkdir $1 && cd $1
}

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

alias hosts='sudo vim /etc/hosts'
alias ports='netstat -tulanp'
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pserver='sudo python -m SimpleHTTPServer'
alias runrc='source ~/.bashrc'

#GIT aliases
alias gco="git checkout "
alias gpu="git pull origin "

#XCLIP
cb() {
	local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
	
	# Check that xclip is installed.
	if ! type xclip > /dev/null 2>&1; then
		echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
	# Check user is not root (root doesn't have access to user xorg server)
	elif [[ "$USER" == "root" ]]; then
		echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
	else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
		input="$(< /dev/stdin)"
    # Else, fetch input from params
	else
		input="$*"
	fi
		if [ -z "$input" ]; then  # If no input, print usage message.
			echo "Copies a string to the clipboard."
			echo "Usage: cb <string>"
			echo "       echo <string> | cb"
		else
			# Copy input to clipboard
			echo -n "$input" | xclip -selection c
			# Truncate text for status
			if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
			# Print status.
			echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
		fi
	fi
}
# Copy contents of a file
function cbf() { cat "$1" | cb; }  
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"
