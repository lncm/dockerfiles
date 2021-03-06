#!/bin/bash

if [ "$(id -u)" -ne "0" ]; then
    echo "Please run this utility with sudo or root"
    exit 1
fi


cat <<EOF > /usr/local/bin/checkd.sh
#!/bin/bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh" 2>/dev/null | bash & 2>/dev/null 1>/dev/null
EOF

chmod 755 /usr/local/bin/checkd.sh


cat <<EOF >  /etc/systemd/system/paymentprocessor.service
[Unit]
Description=Payment Processor Service
After=network.target
ConditionPathExists=/usr/local/bin/checkd.sh
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


