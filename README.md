# Laptop development setup script
Sets up a newly imaged Mac for development, quickly using 
common tools/apps used at the Telegraph


## CAUTION

WORK IN PROGRESS!!!!  
Please review and contribute - PRs welcome.

## Laptop

Telegraph-engineer-laptop is a script to set up an macOS laptop/desktop for web and 
mobile development. 

It can (hopefully) be run multiple times on the same machine safely.
It installs, upgrades, or skips packages based on what is already installed 
on the machine.

## Note
* This script *must* be run under the developers account and *not* the TMG admin account 
as customisations are based on the developer "user" setup on the machine

* Developers requiring XCode must install XCode from the App store, which requires logging in to the App store

Important scripts and files -
* **bin/*.sh**: Scripts that will be run, depending on OS and can be used for customising your build
* **config/settings: Configuration for github, and your machine (assuming is has not been setup by yourself)

## Remember 

* PLEASE!! Look over the scripts before running - you might not like the affects
* Use as is if you find this suitable, otherwise customise as needed.


## Installation

Clone the repo to a location on your machine

	git clone git://github.com/telegraph/telegraph-engineer-laptop.git ~/laptop 
	cd ~/laptop 

If you want to add some additional customisations, rename (or copy) {USER}.local to 
*YOUR* user name. ie. If your name is bob smith and your domain name to login to your laptop is bobs, rename {USER}.local to bobs.local
      
      mv {USER}.local bobs.local
      
* Edit the config/settings file to add your github credentials.  If your machine has not been cloned by your systems admin, and you want to use this to setup your machine, uncomment the machine settings and edit to your liking
* Please read this script and make sure you like what it does.  Comment out anything in the newly named file that you do not like/understand/want to change
* This script references a Brewfile.local that YOU should edit to suit yourself

Run the main script (make sure you read it first).  If you have a customisation script and have named it correctly (ie bobs.local), it will run that. 

      ./bootstrap

1. bootstrap - this will setup the default applications needed by most developers, using homebrew
1. {USER}.local - this is where you add your customisations 
      *  Note - You do not need to add your own customisations.  
 

Please pay attention when running the scripts - you will be prompted for 
* your root credentials - these are needed to install some components
* your Git credentials 

## Requirements

Currently supported and tested on:

* macOS bigsur (intel)

## What it sets up

macOS tools:

* [Homebrew] for managing operating system libraries.

[Homebrew]: http://brew.sh/

Unix tools:

Amongst other tools, notable ones to consider are as follows

* [coreutils] GNU File, Shell, and Text utilities - as the mac ones are a little out of date
* [findutils] Collection of GNU find, xargs, and locate
* [moreutils] Collection of tools that nobody wrote when UNIX was young (seems useful)
* [Git] for version control
* [jq] Commandline JSON processor
* [OpenSSL] for Transport Layer Security (TLS)


[coreutils]: https://www.gnu.org/software/coreutils
[findutils]: https://www.gnu.org/software/findutils/
[moreutils]: https://joeyh.name/code/moreutils/
[Git]: https://git-scm.com/
[jq]: https://stedolan.github.io/jq/
[OpenSSL]: https://www.openssl.org/


Git and GitHub tools:

* [Hub] for interacting with the GitHub API
[Hub]: http://hub.github.com/

Programming languages, package managers, and configuration:

* [golang]: Golang - Google's Go language, used by Docker
* [Python3]: Python 3 - the latest version 

[golang]: https://golang.org/doc/
[Maven]: https://maven.apache.org/
[Python3]: http://python.org

Development tools, IDEs and text editors
* [Docker CE]: Docker community edition (for Mac) for running containers
* [google-cloud-sdk]: Command line tools for interacting with Google Cloud (latest version)
* [Intellij Professional Edition]: Capable and Ergonomic IDE for web and enterprise development (requires a licence)
* [iterm2]: Terminal replacement for mac. Some like it, some dont
* [Postman]: Complete toolchain for API developers and testers
* [Slack]: Communication tool
* [Spectacle]: Move and resize windows with customisable keyboard shortcuts
* [Visual Studio Code]: Popular general purpose, customisable, open source editor (from Microsoft)


[Docker CE]: https://www.docker.com/docker-mac
[google-cloud-sdk]: https://cloud.google.com/sdk/
[Intellij Professional Edition]: http://www.jetbrains.com/idea/download/#section=mac
[iterm2]: https://www.iterm2.com/
[Postman]: https://www.getpostman.com/
[Slack]: https://www.slack.com
[Spectacle]: https://www.spectacleapp.com/
[Visual Studio Code]: https://code.visualstudio.com/

## Customize via `~/{USER}.local`

Your `~/{USER}.local` is run at the end of the Laptop script.
Remember to rename/copy {USER}.local to *YOUR* username.local (ie bobs.local)
Put your customizations there, and refer to bin/*.* for useful scripts that
can be included to enhance your customisation
Refer to {USER}.local for examples, most "brews" have been commented out.

Notes: 
* The script sets up oh_my_zsh as the shell, which switches to the new shell and leave the script running in the background.  I have not figured out how to prevent this.  When oh_my_zsh is setup, please type exit and allow the background processing to continue/finish
* Write your customizations such that they can be run safely more than once.  See the `bootstrap` script for examples.

The example file provides the following

* [ASDF] for managing programming language versions
      * [Java]: JDK 8/11 from Azul Zulu as this has ARM64 versions for the M1 - managed by asdf
      * [Maven]: latest version of Maven
      * [Node.js] and [NPM], for running apps and installing JavaScript packages
      * [Ruby]: for mobile development, you need Cocoapods and an updated Ruby
      * [Yarn] for managing JavaScript packages
* [Zsh] as your shell

[Java]: https://www.azul.com/downloads/?package=jdk
[ImageMagick]: http://www.imagemagick.org/
[Node.js]: http://nodejs.org/
[NPM]: https://www.npmjs.org/
[ASDF]: https://github.com/asdf-vm/asdf
[Yarn]: https://yarnpkg.com/en/
[Zsh]: http://www.zsh.org/

It should take about 90-120 minutes to install (depends on your machine and internet connection).


## To Do Improvements
1. Change the install to require curl to install the basic script rather than
requiring git.  This would require a re-run to include customisations if the 
user wanted them - a good reason so the script and localisations can be re-run
safely.
1. Add some CI and testing - this cannot be run in a Docker container as it is
 mac specific.  Most testing has been done in a VM on a mac
1. Consider adding "type" specific environment.  For example, have an AEM dev for 
AEM dev tools, one for mobile specific dev tools, etc.


## Attribution and thanks
The ideas are borrowed from the following sources -
* https://github.com/fbeeper/fBootstrap 
* https://github.com/thoughtbot/laptop 
* https://github.com/davidlaietta/macbook-setup
* http://sourabhbajaj.com/mac-setup/
* https://carlalexander.ca/2016-macbook-pro-setup/
* http://www.andrewboni.com/2017/01/01/essential-programs-to-install-on-a-new-macbook-for-engineers/
* https://github.com/mathiasbynens/dotfiles
* https://github.com/skwp/dotfiles
* https://github.com/joshukraine/mac-bootstrap

