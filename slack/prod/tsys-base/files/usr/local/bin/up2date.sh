#!/bin/bash

apt-get update
apt-get -y --purge autoremove
apt-get -y autoclean
apt-get -y upgrade
apt-get -y dist-upgrade
