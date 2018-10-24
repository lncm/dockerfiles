# Service checker for PI services

This is a looping bash script which checks that the node is online

## Invocation

```bash
./check.sh &
```

or

```bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh" 2>/dev/null | bash &
```


## Put it into a system service

```bash
cat <<EOF >  /etc/systemd/system/paymentprocessor.service

[Unit]
Description=Payment Processor Service
After=network.target
ConditionPathExists=/home/pi/data/btc
ConditionPathExists=/home/pi/data/btc/bitcoin.conf
ConditionPathExists=/home/pi/data/btc/chainstate
ConditionPathExists=/home/pi/data/btc/blocks
ConditionPathExists=/home/pi/data/lightningd
ConditionPathExists=/home/pi/data/lightningd/config
ConditionPathExists=/usr/bin/docker
ConditionPathExists=/usr/bin/curl

[Service]
ExecStart=/usr/bin/curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh" 2>/dev/null | bash &
User=pi
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

```
