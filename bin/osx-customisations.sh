#!/bin/bash
# inspired by Mathias Bynens: https://github.com/mathiasbynens/dotfiles

# Get the config path - used to include other files 
SCRIPT_PATH=`dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`
PARENT_PATH=`dirname "$SCRIPT_PATH"`
CONFIG_PATH="$SCRIPT_PATH/config"
BIN_PATH="$SCRIPT_PATH/bin"
echo "Bin path $BIN_PATH"
echo "Config path $CONFIG_PATH"
source "$BIN_PATH/functions.sh"

SETTINGS="$CONFIG_PATH/settings"

echo "Working path for $SETTINGS to be used with osx-customisations.sh"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

echo "Root password needed to run OSX customization of settings:"
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sudoleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Set custom variables                                                        #
###############################################################################

if [ -f "$SETTINGS" ]; then
  echo "Importing settings from $SETTINGS ..."

  source "$SETTINGS"

  
fi
###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "Setting General UI/UX defaults..."


# Menu bar: show battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"

  defaults write com.apple.systemuiserver menuExtras -array \
          "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
          "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
          "/System/Library/CoreServices/Menu Extras/Battery.menu" \
          "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
  # defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Automatically quit printer app once the print jobs complete
  # defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool FALSE

# Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false


# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
 

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
  sudo systemsetup -setrestartfreeze on

# Check for software updates daily, not just once per week
  sudo defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# Coding specific - I've not had an issue, so commenting out until needed
###############################################################################
# # Disable automatic capitalization as it’s annoying when typing code
# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# # Disable smart dashes as they’re annoying when typing code
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# # Disable automatic period substitution as it’s annoying when typing code
# defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# # Disable smart quotes as they’re annoying when typing code
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# # Disable auto-correct
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

  # Disable local Time Machine snapshots
  # sudo tmutil disablelocal

  # Disable hibernation (speeds up entering sleep mode)
  sudo pmset -a hibernatemode 0

  # Remove the sleep image file to save disk space
  sudo rm /Private/var/vm/sleepimage
  # Create a zero-byte file instead…
  sudo touch /Private/var/vm/sleepimage
  # …and make sure it can’t be rewritten
  sudo chflags uchg /Private/var/vm/sleepimage

  # Disable the sudden motion sensor as it’s not useful for SSDs
  sudo pmset -a sms 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Increase sound quality for Bluetooth headphones/headsets
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# # Trackpad app exposé swipe down
#   defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# # Enable access for assistive devices
#   echo -n 'a' | sudo tee /private/var/db/.AccessibilityAPIEnabled > /dev/null 2>&1
#   sudo chmod 444 /private/var/db/.AccessibilityAPIEnabled

# Use scroll gesture with the Ctrl (^) modifier key to zoom
  defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
  defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Follow the keyboard focus while zoomed in
  defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Automatically illuminate built-in MacBook keyboard in low light
  defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 5 minutes
  defaults write com.apple.BezelServices kDimTime -int 300

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
  defaults write NSGlobalDomain AppleLanguages -array "en" "gb"
  defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
  defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
  sudo systemsetup -settimezone "Europe/London" > /dev/null

###############################################################################
# Screen
###############################################################################
# Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable subpixel font rendering on non-Apple LCDs
  defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder: show status bar
###############################################################################
  
# Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
  defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
  defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# # Automatically open a new Finder window when a volume is mounted
#   defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
#   defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
#   defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
  chflags nohidden ~/Library
  chflags nohidden /Library

# Show the /Volumes folder
  sudo chflags nohidden /Volumes

# # Remove Dropbox’s green checkmark icons in Finder
#   file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
#   [ -e "${file}" ] && mv -f "${file}" "${file}.bak"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
# Set the icon size of Dock items to 32 pixels
  defaults write com.apple.dock tilesize -int 32

# Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true

# # Simpler minimize effect
#   defaults write com.apple.dock mineffect -string scale

# # Minimize to application (System Preferences → Dock)
#   defaults write com.apple.dock minimize-to-application -bool true

# Open default on my home folder
  defaults write com.apple.finder NewWindowTargetPath -string "file://localhost/${HOME}"

# # Increase window resize speed for Cocoa applications
#   defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# # Speed up Mission Control animations
#   defaults write com.apple.dock expose-duration-duration -float 0.1

# # Enable AirDrop over Ethernet and on unsupported Macs running Lion
#   defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# # Enable spring loading for all Dock items
#   defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Enable Dashboard
  defaults write com.apple.dashboard mcx-disabled -bool false

# Don't show Dashboard as a Space
  defaults write com.apple.dock dashboard-in-overlay -bool true

# Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

# # Right Dock pinning
#   defaults write com.apple.dock pinning -string right
#   defaults write com.apple.dock orientation -string right

# Enable Dock magnification
  defaults write com.apple.dock magnification -boolean true

# Set the size of the magnification of the dock
  defaults write com.apple.dock largesize -float 64

# Disable dock hidding delay
  defaults write com.apple.Dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
  defaults write com.apple.dock autohide-time-modifier -float 0

# # Reset Launchpad
#   find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete

# Add iOS Simulator to Launchpad
  # ln -s /Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app /Applications/iOS\ Simulator.app

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
  defaults write com.apple.dock wvous-tl-corner -int 2
  defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Dashboard
  defaults write com.apple.dock wvous-tr-corner -int 7
  defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
# Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Prevent Safari from opening "safe" files automatically after downloading
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Disable Safari's thumbnail cache for History and Top Sites
  # defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Remove useless icons from Safari's bookmarks bar
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Warn about fraudulent websites
  defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable Java
  defaults write com.apple.Safari WebKitJavaEnabled -bool false
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false
  
# Block pop-up windows
  defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

###############################################################################
# Spotlight                                                                   #
###############################################################################

# # Hide Spotlight tray-icon (and subsequent helper)
# #sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# # Disable Spotlight indexing for any volume that gets mounted and has not yet
# # been indexed before.
# # Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
#   sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# # Change indexing order and disable some search results
# # Yosemite-specific search results (remove them if your are using OS X 10.9 or older):
# #   MENU_DEFINITION
# #   MENU_CONVERSION
# #   MENU_EXPRESSION
# #   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# #   MENU_WEBSEARCH             (send search queries to Apple)
# #   MENU_OTHER
#   defaults write com.apple.spotlight orderedItems -array \
#     '{"enabled" = 1;"name" = "APPLICATIONS";}' \
#     '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
#     '{"enabled" = 1;"name" = "DIRECTORIES";}' \
#     '{"enabled" = 1;"name" = "PDF";}' \
#     '{"enabled" = 1;"name" = "FONTS";}' \
#     '{"enabled" = 1;"name" = "DOCUMENTS";}' \
#     '{"enabled" = 1;"name" = "MESSAGES";}' \
#     '{"enabled" = 0;"name" = "CONTACT";}' \
#     '{"enabled" = 0;"name" = "EVENT_TODO";}' \
#     '{"enabled" = 1;"name" = "IMAGES";}' \
#     '{"enabled" = 1;"name" = "BOOKMARKS";}' \
#     '{"enabled" = 1;"name" = "MUSIC";}' \
#     '{"enabled" = 0;"name" = "MOVIES";}' \
#     '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
#     '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
#     '{"enabled" = 1;"name" = "SOURCE";}' \
#     '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
#     '{"enabled" = 0;"name" = "MENU_OTHER";}' \
#     '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
#     '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
#     '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
#     '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# # Load new settings before rebuilding the index
#   killall mds > /dev/null 2>&1
# # Make sure indexing is enabled for the main volume
#   sudo mdutil -i on / > /dev/null
# # Rebuild the index from scratch
#   sudo mdutil -E / > /dev/null

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################
# Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# Time Machine                                                                #
###############################################################################
# Prevent Time Machine from prompting to use new hard drives as backup volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
  # hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
###############################################################################
# Show the main window when launching Activity Monitor
  defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
  defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
  defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
  defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Sublime Text                                                                #
###############################################################################
# # Install Sublime Text settings
#   cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

# Create command line link to sublime text
  # ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
  # ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

###############################################################################
# Kill affected applications                                                  #
###############################################################################
#  for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#   "Dock" "Finder" "Mail" "Messages" "Safari" "SizeUp" "SystemUIServer" \
#   "Terminal" "Transmission" "Twitter" "iCal"; do
#   killall "${app}" > /dev/null 2>&1
#  done
  echo "Done. Note that some of these changes require a logout/restart to take effect."
