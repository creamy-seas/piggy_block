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

#2) run python script to generate new content of "/etc/hosts" file
#newFileContent=$(python shield.py "$blockLocation" "$block" 2>&1)

#3) write the required file in place of /etc/hosts
if [ "$block" = "True" ]; then
	cp /Users/vladimirantonov
fi
echo "vladimir" | sudo -S cp /Users/vladimirantonov/.scripts/block_on /etc/hosts
#3) reload the file configuration
echo "vladimir" | sudo -S dscacheutil -flushcache
echo "Blockade is up: $block"
