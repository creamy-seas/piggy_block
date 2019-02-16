#!/bin/bash

#1) setup file variables
videoFileLocation="/Users/vladimirantonov/Documents/maria_videos.txt"
youtube_log="/Users/vladimirantonov/.scripts/youtube_log"
logFile="/Users/vladimirantonov/.scripts/log_piggy"
lastStateFile="/Users/vladimirantonov/.scripts/lastState"

#2) write date to log
date=$(date +%H:%M:%S)
echo "$date" >> "$youtube_log"

#3) remove youtube block
lastState=$(cat -s "$lastStateFile")
if [ "$lastState" = "True" ]; then
	sh hostBlock.sh False
	echo "> youtube-dl interfering" >> "$logFile"
fi

#4) download best mp4, or keep size below 200M
cd /Users/vladimirantonov/pepe
while read line; do
	/usr/local/bin/youtube-dl -o "%(title)s.%(ext)s" -i -f "best[ext=mp4]/best[filesize<200M]" "$line"
done < "$videoFileLocation" 2>>"$youtube_log"

#4) get the last line
	/usr/local/bin/youtube-dl -o "%(title)s.%(ext)s" -i -f "best[ext=m4a]/best[filesize<200M]" "$(tail -n 1 "$videoFileLocation")" 2>"$youtube_log"

#5) replace block by changing the lastState variable - piggy.sh will deal with this change
if [ "$lastState" = "True" ]; then
	echo "False" > "$lastStateFile"
fi
