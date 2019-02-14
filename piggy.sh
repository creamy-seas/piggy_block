#!/bin/bash
fileLocation="/Users/vladimirantonov/Documents/maria_times.txt"
blockLocation="/etc/hosts"
block="True"

#1) get the time, and compare it to the allocated times
#a) get the current day
dayOfWeek=$(date +%u); #1-5 if Monday to Friday
time=$(date +%H%M);

#b) perform comparisson and change block variable if necessary
tempD=1
while read line; do
	#c) if day is found, match the time
	if [ "$tempD" -eq "$dayOfWeek" ] ; then
		tempStart=$(echo "$line" | awk '{print $2}')
		tempEnd=$(echo "$line" | awk '{print $3}')	
		#d) if time matches, unblock
		if [ "$time" -ge "$tempStart" -a "$tempEnd" -ge "$time" ]; then
			block="False"
		fi
	fi
	tempD=$((tempD+1))
done < "$fileLocation"

#2) copt the files over and reload cache
echo "$block" > /Users/vladimirantonov/.scripts/lastState
if [ "$block" = "True" ]; then
	cp /Users/vladimirantonov/.scripts/block_on ./hosts
else
	cp /Users/vladimirantonov/.scripts/block_off ./hosts
fi
echo "vladimir" | sudo -S cp /Users/vladimirantonov/.scripts/hosts /etc/hosts
echo "vladimir" | sudo -S dscacheutil -flushcache
echo "vladimir" | sudo -S killall -HUP mDNSResponder

#3) check if there was a change of state before reloading anything
lastState=$(cat -s ./lastState)
if [ "$lastState" != "$block" ]; then
	if [ -n "$(launchctl list | grep firefox)" ]; then
		echo "piggy ===> reloading firefox"
		osascript -e 'quit app "firefox"'
		sleep 1
		osascript -e 'open app "firefox"'
	fi
	if [ -n "$(launchctl list | grep Safari.)" ]; then
		echo "piggy ===> reloading safari"
		osascript -e 'quit app "Safari"'
		sleep 1
		osascript -e 'open app "Safari"'	
	fi 
fi

echo "piggy ===> Blockade is up: $block"
#set browser.startup.page in about:config (in url) to 3
