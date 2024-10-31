#!/bin/bash
ip=$(cat /run/cloud-init/instance-data.json | grep public-ipv)
length=${#ip}
if [ $length -gt 10 ] ; then
    ip=$(echo $ip | tr -d '"public-ipv4": "')
    ip=$(echo $ip | tr -d '-')
    ip=$(echo $ip | tr -d ',')
    msg=" Cockpit Web console : https://$ip:9090"
fi
if [ -f /run/cockpit/active.motd ]; then
    echo "$msg" > /run/cockpit/active.motd
fi