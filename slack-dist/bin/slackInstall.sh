#!/bin/bash
#TSYS Slack installer
#Use as a reference for other TSYS scripts

#######################################################################################################################################################
#Global variables
#######################################################################################################################################################


export MGMT_INT="$(netstat -rn |grep 0.0.0.0|awk '{print $NF}' |head -n1 )"
export ENVIP="$(echo $MGMT_IP|awk -F '.' '{print $2}')"

export DIST_SERVER="http://tsys-techops.turnsys.net/"
export DIST_ROOT_PATH="slack-dist"

#######################################################################################################################################################
#Execution begins
#######################################################################################################################################################

#######################################################################################################################################################
#Step 1. determine server type and site
#######################################################################################################################################################

#Will be useful later when we have fleets of kvm/lxc etc machines, commented out for now. 

#if [ $(hostname -s|egrep -i -c -E 'ts|ts[0-9]|ts[0-9][0-9]|ts[0-9][0-9][0-9]|linux') -eq 1 ]; then
#export server_type=ts
#fi

#if [ $(hostname -s|egrep -c -E 'cvm') -eq 1 ]; then
#export server_type=cvm
#fi


case $server_type in
        ts)
                export SERVER_TYPE="ts"
                ;;
        cvm)
                export SERVER_TYPE="cvm"
                ;;
        bvm)
                export SERVER_TYPE="bvm"
                ;;
        *)
                export SERVER_TYPE="prod"
                ;;
esac

case $ENVIP in
	253)
		export SITE="ovh"
		;;
	251)
		export SITE="aus"
		;;
	40)
		export SITE="satx"
		;;
	*)
		esac


#######################################################################################################################################################
#Step 2: Fixup the /etc/hosts file
#######################################################################################################################################################
#Static /etc/hosts bits
cat  > /etc/hosts << HOSTFILESTATIC
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
HOSTFILESTATIC

#Dynamic /etc/hosts bits
cat >> /etc/hosts <<HOSTFILEDYNAMIC
127.0.1.1 $(hostname) $(hostname -s) 
$MGMT_IP $(hostname) $(hostname -s) 
HOSTFILEDYNAMIC

#######################################################################################################################################################
#Step 3: Grab slack runtime bits and deploy slack
#######################################################################################################################################################
curl $DIST_SERVER/$DIST_ROOT_PATH/distro  > /usr/bin/distro 
chmod +x /usr/bin/distro

apt-get -y install make perl rsync

mkdir /tmp/slackDist
wget $DIST_SERVER/$DIST_ROOT_PATH/slackDist.tar.gz -O /tmp/slackDist/slackDist.tar.gz
cd /tmp/slackDist
tar xvfz slackDist.tar.gz
make install
cd /tmp
rm -rf slackDist

mkdir /root/.ssh
chmod 700 /root/.ssh
chown -R root:root /root/.ssh

wget $DIST_SERVER/$DIST_ROOT_PATH/env/$SITE/SlackConfig-$SITE-$SERVER_TYPE.config -O /etc/slack.conf
wget $DIST_SERVER/$DIST_ROOT_PATH/env/$SITE/SlackSSH-$SITE-$SERVER_TYPE.config -O /root/.ssh/config
wget $DIST_SERVER/$DIST_ROOT_PATH/env/$SITE/SlackSSH-$SITE-$SERVER_TYPE.key -O /root/.ssh/SlackSSH-$SITE-$SERVER_TYPE.key
chmod 400 /root/.ssh/SlackSSH-$SITE-$SERVER_TYPE.key
chmod 400 /root/.ssh/config