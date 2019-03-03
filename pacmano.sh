#!/bin/sh

# Arch Linux: update + reboot if needed
# First version: 2019-03-02
# WARNING: quick and dirtyffective... Usually NOT RECOMMENDED
# Woks for me: I'd rather have an unbootable VPS than a not updated one


DEBUG=
kernel_name=vmlinuz-linux-zen

log_date=/var/log/pacmano/pacmano-$(date +%Y%m%d).log
log_file=/var/log/pacmano_last.log

# Ensure log dir exists
$DEBUG mkdir -pm 755 noconfirm /var/log/pacmano 2>&1 | tee -a $log_file $log_date

# Update pacman and clean cache (keep 1 old version)
$DEBUG date +"%Y%m%d %H%M%S" 2>&1 | tee -a $log_file $log_date

$DEBUG pacman --noconfirm -Syyuu 2>&1 | tee -a $log_file $log_date

$DEBUG date +"%Y%m%d %H%M%S" 2>&1 | tee -a $log_file $log_date

$DEBUG paccache -rk1 2>&1 | tee -a $log_file $log_date

$DEBUG date +"%Y%m%d %H%M%S" 2>&1 | tee -a $log_file $log_date

# Check if/and reboot needed

kernel_boot=$(file /boot/$kernel_name| awk '{print $9}')
kernel_uname=$(uname -r)
$DEBUG echo boot:$kernel_boot uname:$kernel_uname 2>&1 | tee -a $log_file $log_date

if [ "$kernel_boot" != "$kernel_uname" ]
then
	$DEBUG shutdown -r now 2>&1 | tee -a $log_file $log_date
fi
