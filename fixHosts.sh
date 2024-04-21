#!/bin/bash

MGMT_INT=$(netstat -rn|grep 0.0.0.0|head -n1|awk '{print $NF}')
PFV_MGMT_IP=$(ifconfig $MGMT_INT|grep inet|grep 10.251 -c)
OVH_MGMT_IP=$(ifconfig $MGMT_INT|grep inet|grep 10.253 -c)


#######################################################################################################################################################
#Step 2: Fixup the /etc/hosts file
#######################################################################################################################################################



if [ $PFV_MGMT_IP -eq 1 ]; then
#Static /etc/hosts bits
cat  > /etc/hosts << HOSTFILESTATIC
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
HOSTFILESTATIC

#Dynamic /etc/hosts bits
cat >> /etc/hosts <<HOSTFILEDYNAMIC
127.0.1.1 $(hostname).pfv.turnsys.net $(hostname -s)
HOSTFILEDYNAMIC

fi

if [ $OVH_MGMT_IP -eq 1 ]; then
#Static /etc/hosts bits
cat  > /etc/hosts << HOSTFILESTATIC
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
HOSTFILESTATIC

#Dynamic /etc/hosts bits
cat >> /etc/hosts <<HOSTFILEDYNAMIC
127.0.1.1 $(hostname).turnsys.net $(hostname -s)
HOSTFILEDYNAMIC

fi
