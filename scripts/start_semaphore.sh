#!/usr/bin/env sh
sudo touch /etc/systemd/system/semaphore.service

sudo cat > /etc/systemd/system/semaphore.service <<EOF
[Unit]
Description=Semaphore Ansible
Documentation=https://github.com/semaphoreui/semaphore
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/bin/semaphore server --config=/etc/semaphore/config.json
SyslogIdentifier=semaphore
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl unmask semaphore.service
sudo systemctl start semaphore
sudo systemctl status semaphore
sudo systemctl enable semaphore
