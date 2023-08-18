
M1 macs require the path to be updated as homebrew is installed to /opt/homebrew, and is therefore not evaluated as a part of the way Apple evaluates enviroment variables.  On an intel machine homebrew is installed to /usr/local, which is added to the path through /etc/paths.d (from this [stackexhange](https://unix.stackexchange.com/questions/246751/how-to-know-why-and-where-the-path-env-variable-is-set) answer).  According to the homebrew documentation, the following line should be added to .zprofile 


Requirements
- rerunable without messing up system
- optional application installs
- optional machine setting application

Implementation
- use homebrew
- use asdf for version management of various progamming sdks

Assumptions
- stick to using .zsh
- optional prompt to install oh_my_zsh for additional features


