#!/bin/bash
read -r value < /home/ubuntu/.passwd
if [ $(stat -c %W /etc/shadow) -ne $value ] ; then
    sudo cp /etc/issue /etc/issue.net
fi
