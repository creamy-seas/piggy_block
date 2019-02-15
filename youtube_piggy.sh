#!/bin/bash
youtube_log="/Users/vladimirantonov/.scripts/youtube_log"
date=$(date +%H%M)
#echo "$date" >> "$youtube_log"
fileLocation="/Users/vladimirantonov/Documents/maria_videos.txt"

cd /Users/vladimirantonov/pepe

while read line; do
 	/usr/local/bin/youtube-dl -o "%(title)s.%(ext)s" -i "$line" #>> "$youtube_log" 2>&1 
done < "$fileLocation"


