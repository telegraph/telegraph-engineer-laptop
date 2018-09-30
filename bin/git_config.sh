#!/bin/bash

# Get the config path - used to include other files 
SCRIPT_PATH=`dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`
PARENT_PATH=`dirname "$SCRIPT_PATH"`
CONFIG_PATH="$PARENT_PATH/config"
BIN_PATH="$PARENT_PATH/bin"
source "$BIN_PATH/functions.sh"

##########################################[ Setup Git ]########################
# setup git, but only if this is the first run
# could extract this out for running later on an adhoc basis
# do this first (even with the stock install of git) so the user does not need
# to sit waiting for the script to complete
if [ ! -f "$HOME/.gitconfig" ]; then

  if [ -f "$CONFIG_PATH/settings" ]; then
    fancy_echo "Importing settings from settings ..."
    
    source "$CONFIG_PATH/settings"

    fancy_echo "###### Using $GITHUB_USERNAME for your github username ##################"
    fancy_echo "###### Using $GITHUB_MAIL for your github email #########################"
    
  else

    fancy_echo "###### What is your Github username... #################################"
      successfully read GITHUB_USERNAME
    fancy_echo "###### What is the email you use with your Github account... ###########"
      successfully read GITHUB_MAIL

  fi

  fancy_echo "###### Checking for SSH key, generating one if it doesn't exist ...#####"
    [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa -C "$GITHUB_MAIL" -f ~/.ssh/id_rsa
  
  fancy_echo "Copying public key to clipboard. Paste it into your Github account ..."
    [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
    successfully open https://github.com/settings/ssh

  fancy_echo "##### Setting git global defaults... ###################################"
    git config --global user.name $GITHUB_USERNAME
    git config --global user.email $GITHUB_MAIL
    git config --global github.user $GITHUB_USERNAME
    git config --global push.default simple   # current?
    git config --global core.excludesfile $DIR/git/.gitignore_global
    git config --global color.ui true
    git config --global core.editor "subl -w"

  fancy_echo "
  ####################################################################################
  Your ssh credentials have been copied to you clipboard
  Please paste them into Github before continuing.  
  If you do not follow this step the script will fail and exit.
  ####################################################################################
  "
  # Copies the contents of the id_rsa.pub file to your clipboard
  pbcopy < ~/.ssh/id_rsa.pub
  
  # Wait for the user to confirm they've copied the key tp Github
  fancy_echo "Continue? (y)es/(n)o"
  successfully read "y"

  fancy_echo "Testing connection to Github"
  fancy_echo "Accept Github fingerprint: (16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48)"

  # # get the error message back from git to see it the setup was ok
  # errormessage=`ssh -T git@github.com 2>&1 `
  # if [ "$errormessage" = "Hi $GITHUB_USERNAME! You've successfully authenticated, but GitHub does not provide shell access." ]; then
  #   echo "Successfully setup github access with your credentials"
  # else
  #   echo "You will need to revisit the github setup"
  # fi
  # echo $errormessage

  # Disable exit on non 0, check the access and re-enable exit on non 0.  the ablove does not work...
  set +e
  errormessage=`ssh -T git@github.com 2>&1 `
  fancy_echo $errormessage
  set -e

else

  fancy_echo "Git already setup"

fi


# check if there is a gitignore_global in the users home directory, and ignore
# if it has been previously setup, otherwise setup some sensible defaults
if [ -f "~/.gitignore_global" ]; then
  fancy_echo "Setting up a senisble .gitignore_global.  Edit it as needed ..."
  cp "${CONFIG_PATH}/gitignore_global" "$HOME/.gitignore_global"
fi


# Install Talisman, from Throughbot.  Adds a git hook to validate a change set 
# to be pushed to a git repo, such as SSH keys, auth tokens, private keys etc.  
# This is barebones install at the moment, but could be customised
# Talisman is added as a git hook to all repos, so added to git-templates
# Check to make sure there isnt already a pre-push hook
fancy_echo "Installing Talisman as a pre-commit hook"
if [ ! -f "$HOME/.git-templates/hooks/pre-push" ]; then 
  curl https://thoughtworks.github.io/talisman/install.sh > "$HOME/install-talisman.sh"
  # The talisman script checks the local .git/hooks repo first to see if it is 
  # installed.  Force the check to run from the users home folder, but CD'ing to it
  cd $HOME
  chmod +x install-talisman.sh
  ./install-talisman.sh
  rm install-talisman.sh
fi 