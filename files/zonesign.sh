#!/bin/bash
cd /etc/nsd/zones
pwd
echo "Enter zone name you want to sign and rollover"
read zone

echo "Doing stuff for $zone"
echo "Generate key ZSK1"
export ZSK=`ldns-keygen -a ECC-GOST "$zone"`

if [ $? -eq 0 ]; then
    echo "OK. ZSK is $ZSK"
else
    echo FAIL
    exit 1
fi

echo "Generate key ZSK2"
export ZSK2=`ldns-keygen -a ECC-GOST "$zone"`
if [ $? -eq 0 ]; then
    echo "OK. ZSK2 is $ZSK2"
else
    echo FAIL
    exit 1
fi


echo "Generate KSK"
export KSK=`ldns-keygen -k -a ECC-GOST "$zone"`
if [ $? -eq 0 ]; then
    echo "OK. KSK is $KSK"
else
    echo FAIL
    exit 1
fi


echo ""
echo "Now add ZSK2 to the zonefile"
cat $ZSK2.key >> $zone.zone

echo "Signing zone with ZSK and KSK"
sudo ldns-signzone -n -p -s $(head -n 500 /dev/urandom | sha1sum | cut -b 1-16) $zone.zone $ZSK $KSK

echo "Now check nsd.conf file: zone filenames and other options"
echo "Type any letter when you're ready"
read $a

#sudo nano ../nsd.conf


#sudo ldns-signzone -n -p -s $(head -n 500 /dev/urandom | sha1sum | cut -b 1-16) st5.st6.os3.su.zone $ZSK2 $KSK2

echo "Restarting NSD"
sudo service nsd restart

echo "After restart of the zone you have to edit zone file: change serial number, delete new dnskey, add old dnskey"
echo "New DNSKEY is $ZSK2. Check it in you zonefile"
echo "CHANGE YOUR SERIAL"
echo "Type any letter when you're ready"

read $a
cat $zone.zone | grep -i -v "DNSKEY" > $zone.zone.tmp
rm $zone.zone && mv $zone.zone.tmp $zone.zone

cat $ZSK.key >> $zone.zone
nano $zone.zone

echo ""
echo "Resigning zone"

rm $zone.zone.signed
sudo ldns-signzone -n -p -s $(head -n 500 /dev/urandom | sha1sum | cut -b 1-16) $zone.zone $ZSK2 $KSK
sudo service nsd restart

echo "Zone is resigned with a new key. But old key is still in there"
echo "Restart NSD"
echo "..."
echo ""
echo "Type any letter when you're ready for the next step"
read $a

echo "Now we've been waiting a lot, deleting old DNS key"
cat $zone.zone | grep -i -v "DNSKEY" > $zone.zone.tmp
rm $zone.zone && mv $zone.zone.tmp $zone.zone

echo "Resign zone"
rm $zone.zone.signed
sudo ldns-signzone -n -p -s $(head -n 500 /dev/urandom | sha1sum | cut -b 1-16) $zone.zone $ZSK2 $KSK
sudo service nsd restart

echo "Old key's been deleted. Zone is now signed with a new key. NSD server is restarted"
