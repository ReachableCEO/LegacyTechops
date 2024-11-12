#!/bin/bash
for subnet in $(cat subnets); do
zendisc run --now --monitor localhost --deviceclass /Discovered --parallel 8 --net $subnet
done

