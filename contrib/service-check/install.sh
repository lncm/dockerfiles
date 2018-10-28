#!/bin/bash

cat <<EOF > /usr/local/bin/checkd.sh
#!/bin/bash
/usr/local/bin/check.sh & 2>/dev/null 1>/dev/null
EOF

chmod 755 /usr/local/bin/checkd.sh

wget -O /usr/local/bin/check.sh "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh"

chmod 755 /usr/local/bin/check.sh
cat <<EOF >  /etc/systemd/system/paymentprocessor.service
[Unit]
Description=Payment Processor Service
After=network.target
ConditionPathExists=/usr/local/bin/checkd.sh
ConditionPathExists=/usr/local/bin/check.sh
ConditionPathExists=/home/pi/data/btc
ConditionPathExists=/home/pi/data/btc/bitcoin.conf
ConditionPathExists=/home/pi/data/btc/chainstate
ConditionPathExists=/home/pi/data/btc/blocks
ConditionPathExists=/home/pi/data/lightningd
ConditionPathExists=/home/pi/data/lightningd/config
ConditionPathExists=/usr/bin/docker
ConditionPathExists=/usr/bin/curl

[Service]
ExecStart=/usr/local/bin/checkd.sh
User=pi
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
systemctl enable paymentprocessor


