#!/bin/bash
#Script checks the current time again the time table in "fileLocation" and blocks or unblocks youtube.
#a refresh of the browsers is made

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

#b) check time against the time table, and change the block flag
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

#2) check if the blok state is the same as the previous one 
lastState=$(cat -s "$lastStateFile")
echo "Last state    : $lastState" >> "$logFile"
echo "Required state: $block" >> "$logFile"

#3) if the block state has changed execute the second part of the script
if [ "$lastState" != "$block" ]; then
	#a) choose and copy the block or unblock host file
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
	
	#b) reload browser
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
echo "New state    : $block\n" >> "$logFile"
