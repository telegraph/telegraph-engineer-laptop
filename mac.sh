#!/bin/sh

source bin/functions.sh

RUNNING_SYSTEM=`uname -s`
# We're on a Mac, make sure the system is up to date, and install the 
# command line tools
if ! [ "$RUNNING_SYSTEM" == "Darwin" ]
then
  fancy_echo "You do not appear to be running macOS                           "
  fancy_echo "Perhaps you where looking for the linux version?                "
  fancy_echo "If so, then may I suggest considering at the linux.sh script ?  "
  exit -1
fi

########################[ Check homebrew is installed ]########################
# Set the install location for homebrew... use the default.
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

# Check to see if homebrew is installed, and if not then install it
if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

########################[ Install homebrew apps ]##############################
fancy_echo "Updating Homebrew formulae ..."
brew update --force # https://github.com/Homebrew/brew/issues/1151
fancy_echo "Updated forcefully"

# Add some formulae... apps that we all want (need)
fancy_echo "Installing apps using homebrew"
brew bundle --file=- <<EOF
  #casks - for extra funtionality
  tap "homebrew/bundle"
  tap "thoughtbot/formulae"
  tap "buo/cask-upgrade"                  # to upgrade all the apps installed by homebrew cask
  tap "homebrew/core"
  tap "homebrew/services"
  tap "caskroom/versions"                 # for java 1.8
  tap "caskroom/cask"
  tap "universal-ctags/universal-ctags"

  # Set applications directory
  cask_args appdir: "/Applications"

  # Unix tools
  brew "universal-ctags", args: ["HEAD"]
  brew "git"
  brew "openssl"
  brew "readline"     # Utilities that one needs.... 

  # GitHub
  brew "hub"

  # Programming language prerequisites and package managers
  brew "libyaml"              # should come after openssl
  brew "coreutils"

  # we're an aws shop...
  brew "awscli"

  # need the latest version of java and maven
  cask "java"  unless system "/usr/libexec/java_home --failfast"
  brew "maven"

  # development tools
  cask "sublime-text"     # programming editor
  cask "intellij-idea"    # manage jetbrains IDEs with their toolbox
  cask "sourcetree"       # Git client
  cask "docker"           # docker - containerise all the things
  cask "kitematic"        # UI for working with docker
  cask "iterm2"           # item - terminal alternative 
  cask "mysqlworkbench"   # mysql work bench
  cask "sequel-pro"       # ui for database management
  cask "postman"          # Postman - for API development and testing

  # video viewer
  cask "vlc"

  # slack
  cask "slack"

  # window management from the keyvoard
  cask "spectacle"

  # combine chat and messaging into one application (slack/whatsapp/etc)
  cask "franz"

EOF

brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*