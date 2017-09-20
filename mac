#!/bin/sh

# Welcome to the telegraph developer machine setup script!
# This is based heavily on the thoughbot laptop setup 
# (https://github.com/thoughtbot/laptop)
# and other setups.
# See README for thanks and references

successfully() {
  $* || (echo "failed" 1>&2 && exit 1)
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e


echo "
#########################################################################
Your password (assuming you are setup as an admin) is need to install the 
latest Max OS updates and to ensure permssions on homebrew are setup 
correctly.
Please make sure you have read this script and are happy to provide 
your password.
Talisman prompts for input on first run, please answer yes
#########################################################################
"
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sudoleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##########################[ Update and install Mac Sw ]########################

RUNNING_SYSTEM=`uname -s`
# We're on a Mac, make sure the system is up to date, and install the 
# command line tools
if [ "$RUNNING_SYSTEM" == "Darwin" ]
then

  sudo softwareupdate -i -a

  echo "Install Apple command line tools"
  COMMANDLINE_TOOLS="/Library/Developer/CommandLineTools"
  if [ ! -d "$COMMANDLINE_TOOLS" ]; then
    xcode-select --install
  fi
fi

##################################[ Homebrew location ]########################
# /usr/local is the supported location.  See homebrew docs for why.
# Setup for individual users may work, but is not recommended
HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

####################[ Install applications using brew ]########################
if ! command -v brew >/dev/null; then
  echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

fi

if brew list | grep -Fq brew-cask; then
  echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

echo "Updating Homebrew formulae ..."
brew update --force # https://github.com/Homebrew/brew/issues/1151
brew bundle --file=- <<EOF
tap "thoughtbot/formulae"
tap "caskroom/cask"
tap "homebrew/services"
tap "universal-ctags/universal-ctags"

# to upgrade all the apps installed by homebrew cask
tap "buo/cask-upgrade"

# Unix tools
brew "universal-ctags", args: ["HEAD"]
brew "git"
brew "openssl"

# GitHub
brew "hub"

# Programming language prerequisites and package managers
brew "libyaml" # should come after openssl
brew "coreutils"
brew "yarn"

# cask tools
# cask "gpgtools"       # we use MacGPG2, so this is not required

# need the latest version of java and maven
# cask "java"             # not sure if this is needed, as the developer build has java 1.8 installed
brew "maven"

# Set applications directory - should be earlier?
cask_args appdir: "/Applications"

# programming editor
cask "sublime-text"

# IntelliJ community edition and professional version
# professional version requires a licence, not setup with this script
cask "intellij-idea-ce"
cask "intellij-idea"

# Git client
cask "sourcetree"

# docker - containerise all the things
cask "docker"

# UI for working with docker
cask "kitematic"

# video viewer
cask "vlc"

# slack - some people like to use the application
cask "slack"

# window management from the keyvoard
cask "spectacle"

# item
cask "iterm2"

# combine chat and messaging into one application (slack/whatsapp/etc)
cask "franz"

# mysql work bench
cask "mysqlworkbench"

# Postman - for API development and testing
cask "postman"

EOF

##########################################[ Setup Git ]########################
# setup git, but only if this is the first run
# could extract this out for running later on an adhoc basis
if [ ! -f "$HOME/.gitconfig" ]; then

  echo "###### What is your Github username... #################################"
    successfully read GITHUB_USERNAME
  echo "###### What is the email you use with your Github account... ###########"
    successfully read GITHUB_MAIL

  echo "###### Checking for SSH key, generating one if it doesn't exist ...#####"
    [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa -C "$GITHUB_MAIL" -f ~/.ssh/id_rsa
  
  echo "Copying public key to clipboard. Paste it into your Github account ..."
    [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
    successfully open https://github.com/settings/ssh

  echo "##### Setting git global defaults... ###################################"
    git config --global user.name $GITHUB_USERNAME
    git config --global user.email $GITHUB_MAIL
    git config --global github.user $GITHUB_USERNAME
    git config --global push.default simple   # current?
    git config --global core.excludesfile $DIR/git/.gitignore_global
    git config --global color.ui true
    git config --global core.editor "subl -w"

  echo "
  ####################################################################################
  Your ssh credentials have been copied to you clipboard
  Please paste them into Github before continuing.  
  If you do not follow this step the script will fail and exit.
  ####################################################################################
  "
  # Copies the contents of the id_rsa.pub file to your clipboard
  pbcopy < ~/.ssh/id_rsa.pub
  
  # Wait for the user to confirm they've copied the key tp Github
  echo "Continue? (y)es/(n)o"
  successfully read "y"

  echo "Accept Github fingerprint: (16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48)"
  echo "Testing connection to Github"
    ssh -T git@github.com

else
  echo "Git already setup"
fi

# check if there is a gitignore_global in the users home directory, and ignore
# if it has been previously setup
if [ -f "~/.gitignore_global" ]; then
  echo "Setting up a senisble .gitignore_global.  Edit it as needed ..."
  cp gitignore_global "$HOME/.gitignore_global"
fi

# Install Talisman, from Throughbot.  Adds a git hook to validate a change set 
# to be pushed to a git repo, such as SSH keys, auth tokens, private keys etc.  
# This is barebones install at the moment, but could be customised
# Talisman is added as a git hook to all repos, so added to git-templates
# Check to make sure there isnt already a pre-push hook
echo "Installing Talisman as a pre-commit hook"
if [ ! -f "$HOME/.git-templates/hooks/pre-push" ]; then 
  curl https://thoughtworks.github.io/talisman/install.sh > "$HOME/install-talisman.sh"
  # The talisman script checks the local .git/hooks repo first to see if it is 
  # installed.  Force the check to run from the users home folder, but CD'ing to it
  cd $HOME
  chmod +x install-talisman.sh
  ./install-talisman.sh
  rm install-talisman.sh
fi 

#################################[ run customisations ]########################
# run anything from the user local file
echo "Running customisations"
echo "Checking preferences from $USER.local"
if [ -f "$USER.local" ]; then
  echo "Running your customizations from $USER.local ..."
  # shellcheck disable=SC1090
  . "$USER.local"
fi


###########################################[ clean up ]########################
echo "Cleaning up old Homebrew formulae ..."
brew cleanup
brew cask cleanup

echo "DONE!"

exit
