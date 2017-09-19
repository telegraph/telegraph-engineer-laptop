# Laptop develompent setup script
Sets up a newly imaged Mac for development, quickly using 
common tools/apps used at the Telegraph


## CAUTION


WORK IN PROGRESS!!!!

<br/>
## Laptop

Laptop is a script to set up an macOS laptop/desktop for web and 
mobile development. 

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages based on what is already installed 
on the machine.

## Note
* This script *must* be run under the developers account and *not* the TMG admin account 
as customisations are based on the developer "user" setup on the machine

* Developers requiring XCode must install XCode from the App store, XCode 
cannot be installed with this script

## Attribution and thanks
The ideas are borrowed from the following sources -
* https://github.com/thoughtbot/laptop 
* https://github.com/davidlaietta/macbook-setup
* http://sourabhbajaj.com/mac-setup/
* https://carlalexander.ca/2016-macbook-pro-setup/
* http://www.andrewboni.com/2017/01/01/essential-programs-to-install-on-a-new-macbook-for-engineers/


## Remember 

* PLEASE!! Look over the scripts before running - you might not like the affects
* Use as is if you find this suitable, otherwise customise as needed.


## Installation

Clone the repo to a location on your machine

	git clone git://github.com/telegraph/laptop.git ~/laptop 
	cd ~/laptop 

Rename (or copy) {USER}.local to *YOUR* user name. ie. bobs.local
      
      mv {USER}.local bobs.local

Run the main script (make sure you read it first.)

      ./mac

Please pay attention when running the scripts - you will be prompted for 
* your Git credentials 
* your root credentials - these are needed to install some components

## Requirements


Currently supported and tested on:

* macOS Sierra (10.12)

## What it sets up

macOS tools:

* [Homebrew] for managing operating system libraries.

[Homebrew]: http://brew.sh/

Unix tools:

* [Exuberant Ctags] for indexing files for vim tab completion
* [Git] for version control
* [OpenSSL] for Transport Layer Security (TLS)
* [Zsh] as your shell

[Exuberant Ctags]: http://ctags.sourceforge.net/
[Git]: https://git-scm.com/
[OpenSSL]: https://www.openssl.org/
[Zsh]: http://www.zsh.org/

Git and GitHub tools:

* [Hub] for interacting with the GitHub API
* [Sourcetree] UI for interfacing with Git and Stash.  Login with your Google credentials
[Hub]: http://hub.github.com/
[Sourcetree]: https://www.sourcetreeapp.com/ 

Programming languages, package managers, and configuration:

* [Java]: latest version of Java
* [Maven]: latest version of Maven

Development tools, IDEs and text editors
* [Sublime Text]: A sophisticated text editor for code, markup and prose (requires a licence)
* [Intellij Professional Edition]: Capable and Ergonomic IDE for web and enterprise development (requires a licence)
* [Intellij Community Edition]: Capable and Ergonomic IDE for JVM and Android development 
* [Docker CE]: Docker community edition (for Mac) for running containers
* [Kitematic]: UI for running containers and discovering new ones through a simple UI
* [Slack]: Communication tool
* [Spectacle]: Move and resize windows with customisable keyboard shortcuts
* [iterm2]: Terminal replacement for mac. Some like it, some dont
* [franz]: Franz is a free messaging app and combines chat & messaging services into one application.
* [MySql Workbench]: MySQL Workbench is a unified visual tool for database architects, developers, and DBAs. 
* [Postman]: Complete toolchain for API developers and testers

[Sublime Text]: https://www.sublimetext.com/
[Java]: https://www.java.com/en/
[Maven]: https://maven.apache.org/
[Intellij Professional Edition]: http://www.jetbrains.com/idea/download/#section=mac
[Intellij Community Edition]: http://www.jetbrains.com/idea/download/#section=mac
[Docker CE]: https://www.docker.com/docker-mac
[Kitematic]: https://kitematic.com/
[Slack]: https://www.slack.com
[Spectacle]: https://www.spectacleapp.com/
[iterm2]: https://www.iterm2.com/
[franz]: http://meetfranz.com/
[MySql Workbench]: https://www.mysql.com/products/workbench/
[Postman]: https://www.getpostman.com/


## Customize via `~/laptop/{USER}.local`

Your `~/laptop/{USER}.local` is run at the end of the Laptop script.
Remember to rename/copy {USER}.local to *YOUR* username.local (ie bobs.local)
Put your customizations there.
Refer to {USER}.local for examples:

Note: Write your customizations such that they can be run safely more than once.
See the `mac` script for examples.

The example file provides the following

* [ASDF] for managing programming language versions
* [Node.js] and [NPM], for running apps and installing JavaScript packages
* [Yarn] for managing JavaScript packages

[ImageMagick]: http://www.imagemagick.org/
[Node.js]: http://nodejs.org/
[NPM]: https://www.npmjs.org/
[ASDF]: https://github.com/asdf-vm/asdf
[Yarn]: https://yarnpkg.com/en/

It should take less than 15 minutes to install (depends on your machine).

## To Do Improvements
1. Split out the git credentials into a separate file to allow it to be run 
without the check first.  
2. Change the install to require curl to install the basic script rather than
requiring git.  This would require a re-run to include customisations if the 
user wanted them - a good reason to the script and localisations can be re-run
safely.
3. Add some CI and testing - this cannot be run in a Docker container as it is
 mac specific
