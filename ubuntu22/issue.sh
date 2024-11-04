#!/bin/bash
sudo inotifywait -m -e open /etc/shadow | while read path action file; do
    sudo cp /etc/motd.final /etc/motd
    sudo cp /etc/issue /etc/issue.net
done
