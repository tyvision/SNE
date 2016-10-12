#!/bin/bash
#cd /etc/nsd/zones

zone="st5.os3.su"
ZSK="Kst5.os3.su.+012+59575"
KSK="Kst5.os3.su.+012+55325"

echo "Removing old signed zone file to backup. It will be deleted if any issues will happen"

mv $zone.zone.signed $zone.zone.signed.backup

echo "Resigning zone $zone"
echo "Write a script which uses db of keys, old keys and working keys" 

sudo ldns-signzone -n -p -s $(head -n 500 /dev/urandom | sha1sum | cut -b 1-16) $zone.zone $ZSK2 $KSK
if [ $? -eq 0 ]; then
    echo "Zone is resigned"
else
    echo "Fail resigning zone"
    exit 1
fi

echo "Restarting NSD"
sudo service nsd restart
if [ $? -eq 0 ]; then
    echo "NSD is running with new zone (check /var/log/nsd.log for more info)"
    sudo rm $zone.zone.signed.backup
else
    echo "Failed restarting NSD (check /var/log/nsd.log for more info)"
    exit 1
fi