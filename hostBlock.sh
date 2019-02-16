#!/bin/bash
#function checks input for "True" of "False" -> blocks or unblocks are required by copying file and flushing cache
logFile="/Users/vladimirantonov/.scripts/log_piggy"
blockFile="/Users/vladimirantonov/.scripts/block_on"
unblockFile="/Users/vladimirantonov/.scripts/block_off"

if [ "$1" = "True" ]; then
        cp "$blockFile" /tmp/hosts
        echo "> copying BLOCK file to /etc/hosts" >> "$logFile"
else
        cp "$unblockFile" /tmp/hosts
        echo "> copying UNBLOCK file to /etc/hosts" >> "$logFile"
fi

echo "vladimir" | sudo -S mv /tmp/hosts /etc/hosts && echo "> copied" >> "$logFile"
echo "vladimir" | sudo -S dscacheutil -flushcache
echo "vladimir" | sudo -S killall -HUP mDNSResponder
