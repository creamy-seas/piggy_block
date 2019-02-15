#!/bin/bash
logFile="/Users/vladimirantonov/.scripts/log_piggy"
fileLocation="/Users/vladimirantonov/Documents/maria_times.txt"
lastStateFile="/Users/vladimirantonov/.scripts/lastState"
blockLocation="/etc/hosts"
block="True"

#1) get the time, and compare it to the allocated times
#a) get the current day
dayOfWeek=$(date +%u); #1-5 if Monday to Friday
time=$(date +%H%M);
echo "Begin $time" >> "$logFile"

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
lastState=$(cat -s "$lastStateFile")
echo "Last state    : $lastState" >> "$logFile"
echo "Required state: $block" >> "$logFile"
echo "$block" > /Users/vladimirantonov/.scripts/lastState
if [ "$block" = "True" ]; then
	cp /Users/vladimirantonov/.scripts/block_on ./hosts
	echo "> copying BLOCK file to /etc/hosts" >> "$logFile"
else
	cp /Users/vladimirantonov/.scripts/block_off ./hosts
	echo "> copying UNBLOCK file to /etc/hosts" >> "$logFile"
fi
echo "vladimir" | sudo -S mv /Users/vladimirantonov/.scripts/hosts /etc/hosts
echo "vladimir" | sudo -S dscacheutil -flushcache
echo "vladimir" | sudo -S killall -HUP mDNSResponder
#3) check if there was a change of state before reloading anything
if [ "$lastState" != "$block" ]; then
	if [ -n "$(launchctl list | grep firefox)" ]; then
		echo "> reloading firefox" >> "$logFile"
		#osascript -e 'quit app "firefox"'
		echo "vladimir" | sudo -S dscacheutil -flushcache
		echo "vladimir" | sudo -S killall -HUP mDNSResponder
		#osascript -e 'open app "firefox"'
	fi
	if [ -n "$(launchctl list | grep Safari.)" ]; then
		echo "> reloading safari" >> "$logFile"
		#osascript -e 'quit app "Safari"'
		echo "vladimir" | sudo -S dscacheutil -flushcache
		echo "vladimir" | sudo -S killall -HUP mDNSResponder
		#osascript -e 'open app "Safari"'	
	fi 
fi

echo "piggy ===> Blockade is up: $block"
echo "$block" > "$lastStateFile"
echo "Last state    : $block\n" >> "$logFile"
#set browser.startup.page in about:config (in url) to 3
