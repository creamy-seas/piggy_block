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

#2) check if there was a change of state and exit if it's the same
lastState=$(cat -s ./lastState)
if [ "$lastState" = "$block" ]; then
	echo "no change - Blocakde: $block"
	exit 1
fi

#3) otherwise
echo "$block" > /Users/vladimirantonov/.scripts/lastState
#a) write the required file in place of /etc/hosts
if [ "$block" = "True" ]; then
	cp /Users/vladimirantonov/.scripts/block_on ./hosts
else
	cp /Users/vladimirantonov/.scripts/block_off ./hosts
fi
echo "vladimir" | sudo -S cp /Users/vladimirantonov/.scripts/hosts /etc/hosts
#b) close safari and firefox
fr
killall firefox
killall safari
#c) reload the file configuration
echo "vladimir" | sudo -S dscacheutil -flushcache
echo "vladimir" | sudo -S killall -HUP mDNSResponder
#d) reload safari and firefox
open -a firefox
#e) update the lastState file
echo "Blockade is up: $block"
