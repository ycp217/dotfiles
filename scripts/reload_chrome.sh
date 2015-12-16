#!/bin/bash

# This script use AppleScript to reload a tab in Chrome then go back to iTerm.
# Takes 1 link as argument.
# e.g. reload_chrome.sh 'https://google.com/'

echo
echo "reload Chrome"
LINK="$1"
if [ "${LINK: -1}" != "/" ]; then
    LINK="$LINK/"
fi
echo $LINK
osascript <<EOD
    tell application "Google Chrome"
	activate
    set theUrl to "$LINK"
	
	if (count every window) = 0 then
		make new window
	end if
	
	set found to false
	set theTabIndex to -1
	repeat with theWindow in every window
		set theTabIndex to 0
		repeat with theTab in every tab of theWindow
			set theTabIndex to theTabIndex + 1
			if theTab's URL = theUrl then
				set found to true
				exit
			end if
		end repeat
		
		if found then
			exit repeat
		end if
	end repeat
	
	if found then
		tell theTab to reload
		set theWindow's active tab index to theTabIndex
		set index of theWindow to 1
	else
		tell window 1 to make new tab with properties {URL:theUrl}
	end if
end tell
EOD
osascript <<EOD
    tell application "iTerm"
        activate
    end tell
EOD
