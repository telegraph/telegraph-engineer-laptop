#!/bin/bash

# Get the config path - used to include other files 
SCRIPT_PATH=$(dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")")
PARENT_PATH=$(dirname "$SCRIPT_PATH")
CONFIG_PATH="$PARENT_PATH/config"
BIN_PATH="$PARENT_PATH/bin"
source "$BIN_PATH/functions.sh"

source "$PARENT_PATH/bin/functions.sh"

fancy_echo $CONFIG_PATH

# work out which version of mac os we are running needed 
# as the HOMEBREW_PREFIX needs to be set differently 
MAJOR_MAC_VERSION=$(sw_vers -productVersion | awk -F '.' '{print $1}')

	# Set the install location for homebrew... otherwise use the default.
if [ "$MAJOR_MAC_VERSION" == "10" ]; then
  HOMEBREW_PREFIX="/usr/local"
else
  HOMEBREW_PREFIX="/opt/homebrew"
fi

# useful for updating zshrc without duplicating entries
append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

########################[ OH MY ZSH ]#########################################
# Assumes you want ZSH and not BASH
if [ ! -d "$HOME/.oh-my-zsh" ]; then

	fancy_echo "Setup oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  # add brew path to zshrc file, recommended by "brew doctor", but only if home brew 
  # is installed
  if ! command -v brew >/dev/null; then
    fancy_echo "Updating path for homebrew apps"
    append_to_zshrc '# recommended by brew doctor'
    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="$HOMEBREW_PREFIX/bin:$PATH"' 1
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
  fi

fi