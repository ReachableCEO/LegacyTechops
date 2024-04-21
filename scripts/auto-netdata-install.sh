#!/bin/bash
curl -Ss 'https://raw.githubusercontent.com/netdata/netdata-demo-site/master/install-required-packages.sh' >/tmp/kickstart.sh 
bash /tmp/kickstart.sh --dont-wait -i netdata-all
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait


