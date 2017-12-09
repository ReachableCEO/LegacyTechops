#!/bin/bash
#Install script for snmp on all Linux systems

if [ -f /etc/apt/sources.list ];
then
#Install observium bits
chmod 755 /usr/bin/distro
#Pull down snmpd configuration files
wget  -O /etc/default/snmpd http://txn04-slack-master.tplab.tippingpoint.com/sysmgmt/snmp/debian-default-snmpd
wget  -O /etc/snmp/snmpd.conf http://txn04-slack-master.tplab.tippingpoint.com/sysmgmt/snmp/snmpd.conf 
#Restart snmpd
/etc/init.d/snmpd restart




elif [ -f /etc/yum.conf ];
then
#Fix yum.conf
wget -O /etc/yum/yum.conf http://fezzik.tplab.tippingpoint.com/yum.conf
#Install snmpd
yum -y install net-snmp
#Install observium bits
curl --silent http://txn04-slack-master.tplab.tippingpoint.com/sysmgmt/snmp/distro > /usr/bin/distro 
chmod 755 /usr/bin/distro
#Pull down snmpd configuration files
wget  -O /etc/snmp/snmpd.conf http://txn04-slack-master.tplab.tippingpoint.com/sysmgmt/snmp/snmpd.conf 
wget  -O /etc/sysconfig/snmpd.options http://txn04-slack-master.tplab.tippingpoint.com/sysmgmt/snmp/centos-snmpd.options 
#Restart snmpd
/etc/init.d/snmpd restart
chkconfig snmpd on
fi
