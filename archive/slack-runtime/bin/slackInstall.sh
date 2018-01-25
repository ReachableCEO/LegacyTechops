#!/bin/bash
#A script to bootstrap slack onto any TURNSYS managed system in any environment. 
#Use this as a template for writing TURNSYS shell scripts

slack-install()
{

wget http://toolbox.turnsys.net/sysinfra/slack/bin/distro  -O /usr/bin/distro 
chmod +x /usr/bin/distro

apt-get -y install make perl rsync

mkdir /tmp/slackDist
wget http://toolbox.turnsys.net/sysinfra/slack/slackDist.tar.gz -O /tmp/slackDist/slackDist.tar.gz
cd /tmp/slackDist
tar xvfz slackDist.tar.gz
make install
cd /tmp
rm -rf slackDist

mkdir /root/.ssh
chmod 700 /root/.ssh
chown -R root:root /root/.ssh

wget http://toolbox.turnsys.net/sysinfra/slack/env/SlackConfig-$SERVER_TYPE.config -O /etc/slack.conf

wget http://toolbox.turnsys.net/sysinfra/slack/env/SlackSSH-$SERVER_TYPE.config -O /root/.ssh/config
chmod 400 /root/.ssh/config

wget http://toolbox.turnsys.net/sysinfra/slack/env/SlackSSH-$SERVER_TYPE.key -O /root/.ssh/SlackSSH-$SERVER_TYPE.key
chmod 400 /root/.ssh/SlackSSH-$SERVER_TYPE.key
}


#######################################################################################################################################################
#main() #For ease of searching
# Script starts here
# This code serves as a generic template for entrypoint code which is able to handle multi distro, multi environment execution.
# !!!!! DO NOT WRAP IN A FUNCTION. THESE ARE GLOBAL VARIABLES !!!!!
#######################################################################################################################################################

#If we have a fleet later, we can use this code to do fleet stuff
#if [ $(hostname -s|egrep -i -c -E 'ts|ts[0-9]|ts[0-9][0-9]|ts[0-9][0-9][0-9]|linux') -eq 1 ]; then
#export server_type=ts
#fi


case $server_type in
        ts)
                export SERVER_TYPE="ts"
                ;;
        *)
                export SERVER_TYPE="prod"
                ;;
esac

#######################################################################################################################################################
#Kick everything off
#
slack-install
