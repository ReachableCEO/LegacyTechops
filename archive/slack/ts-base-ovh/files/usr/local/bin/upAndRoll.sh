#!/bin/bash

apt-get update
apt-get -y --purge autoremove
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y --purge autoremove
/sbin/reboot

