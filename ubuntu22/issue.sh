#!/bin/bash
read -r value < /home/ubuntu/.passwd
if [ $(stat -c %W /etc/shadow) -ne $value ] ; then
    sudo cp /etc/issue /etc/issue.net
    echo -e "\n$(stat -c %W /etc/shadow)\n`date +%y-%m-%d`\n Passwd Changed" > /home/kadap/.passwd
fi
