#!/bin/bash
inotifywait -m -e open /etc/shadow | while read path action file; do
    sudo cp /etc/motd.first /etc/motd
    sudo cp /etc/issue /etc/issue.net
done
