# DANGEROUS
# Installs and start/enable the systemd service/timer for pacmano
# Creation: 2019-03-05
# https://wiki.archlinux.org/index.php/Systemd/Timers

DIR_TIMER=/etc/systemd/system
DIR_SCRIPT=/usr/local/bin

# Creation of systemd service (definition/access to the script)
cat > $DIR_TIMER/pacmano.service <<EOF
[Unit]
Description=Launch pacmano - automatic pacman reboot

[Service]
Type=oneshot
ExecStart=$DIR_SCRIPT/pacmano.sh
EOF

# Creation of systemd timer (link to service and timing)
cat > $DIR_TIMER/pacmano.timer <<EOF
[Unit]
Description=Daily system update/upgrade/reboot with pacmano

[Timer]

# once a day, at 2AM
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Install / Start the (timer) service
systemctl daemon-reload
systemctl start pacmano.timer
systemctl enable pacmano.timer

# Last check
systemctl list-timers pacmano.timer
