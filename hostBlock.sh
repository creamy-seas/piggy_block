#!/bin/bash
#This function recieves "True" or "False" as inputs
#Copies the required block domain file to /etc/hosts and flushes the cache

logFile="/dev/null"#"/Users/vladimirantonov/.scripts/log_piggy"
blockFile="/Users/vladimirantonov/.scripts/block_on"
unblockFile="/Users/vladimirantonov/.scripts/block_off"

if [ "$1" = "True" ]; then
        cp "$blockFile" /tmp/hosts
        echo "> copying BLOCK file to /etc/hosts" >> "$logFile"
else
        cp "$unblockFile" /tmp/hosts
        echo "> copying UNBLOCK file to /etc/hosts" >> "$logFile"
fi

echo "vladimir" | sudo -S mv /tmp/hosts /etc/hosts 
a=$(cat /etc/hosts | grep youtube)
echo "> wrote \""$a"\"" >> "$logFile"
echo "vladimir" | sudo -S dscacheutil -flushcache
echo "vladimir" | sudo -S killall -HUP mDNSResponder && echo "> flushed cache" >> "$logFile"
