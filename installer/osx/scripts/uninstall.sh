#!/bin/sh

# Author: MaidSafe 

# Unload the vault manager daemon 
#sudo launchctl unload -w /Library/LaunchDaemons/com.lifestuff.invigilator.plist

# Remove the configuration file
#sudo rm com.lifestuff.invigilator.plist

# Remove the whole application bundle
sudo rm -r /Applications/LifeStuff.app
