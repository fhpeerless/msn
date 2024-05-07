#!/bin/bash
if ! pgrep -x "apphub" > /dev/null
then
    echo "$(date) - apphub is not running. Attempting to start." >> /aanode/123.txt
    sudo /aanode/apphub-linux-amd64/apphub service start >> /aanode/123.txt 2>&1
else
    echo "$(date) - apphub is already running." >> /aanode/123.txt
fi