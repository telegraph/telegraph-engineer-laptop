#!/bin/bash

# import the functions
source bin/functions.sh

fancy_echo "########################################################"
fancy_echo " This is the bootstap script to setup your mac as a     "
fancy_echo " development machine, to get you running asap           "
fancy_echo " This is going to ask for your password.  Only provide  "
fancy_echo " it if you have read this script and fully understand 	"
fancy_echo " what is it going to do to your sytem										"
fancy_echo "																												"
fancy_echo " **************** YOU HAVE BEEN WARNED	****************"
fancy_echo "																												"
fancy_echo "########################################################"


# shellcheck disable=SC2154
# Print out the failure when exiting the script
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

# exit if there is an error
set -e

# assume this works on linux....?
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

########################[ INSTALL depending on OS ]############################
RUNNING_SYSTEM=`uname -s`

# We're on a Mac, let's install and setup using homebrew.
if [ "$RUNNING_SYSTEM" == "Darwin" ]
then

########################[ Updating Mac OS ]####################################
# Update mac software
	fancy_echo "Updating mac os"
		sudo softwareupdate -i -a

########################[ Command line xcode ]#################################
	fancy_echo "Install Apple command line tools"
	COMMANDLINE_TOOLS="/Library/Developer/CommandLineTools"
	if [ ! -d "$COMMANDLINE_TOOLS" ]; then
		xcode-select --install
	fi

########################[ Command line SW ]####################################
	fancy_echo "Using homebrew to install software "
  	sh mac.sh

########################[ Run user customisations ]############################
# run anything from the user local file
	# if [ -f "$USER.local" ]; then
	# 	fancy_echo "Running customisations using preferences from $USER.local"
	# 	# shellcheck disable=SC1090
	# 	sh "$USER.local"
	# fi

########################[ OSX Customisations ]#################################
	# if [ -f "osx-customisations.sh" ]; then
	# fancy_echo "Customising OSX... (inspired by https://github.com/mathiasbynens/dotfiles)"
	# 	# shellcheck disable=SC1090
	#  	sh osx-customisations.sh
	# fi

###############################################################################
########################[ Linux Customisations ]###############################
elif [ "$RUNNING_SYSTEM" == "Linux" ]
then
	fancy_echo "Install for Linux"
	sh linux.sh
else
	fail "Unfortunately your system is not currently supported with this script"
fi


########################[ GIT ]################################################
# fancy_echo "Setup github account on machine"
#   sh git_config.sh

fancy_echo "DONE!"
