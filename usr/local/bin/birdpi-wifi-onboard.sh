#!/bin/bash
set -e

LOG="/var/log/birdpi-wifi-onboard.log"
echo "[$(date)] Starting BirdPi WiFi Onboarding" | tee -a "$LOG"

# 1. Wait up to 30s for WiFi to connect on wlan0
timeout=30
while [[ $timeout -gt 0 ]]; do
    ssid=$(iwgetid -r)
    if [[ -n "$ssid" ]]; then
        echo "[$(date)] ✅ WiFi connected to SSID: $ssid" | tee -a "$LOG"
        exit 0
    fi
    sleep 2
    ((timeout-=2))
done

echo "[$(date)] ❌ No WiFi found, starting RaspAP AP mode..." | tee -a "$LOG"
sudo systemctl start raspapd.service

# 2. Watch for WiFi connection while AP is up; stop AP if WiFi connects
while true; do
    ssid=$(iwgetid -r)
    if [[ -n "$ssid" ]]; then
        echo "[$(date)] ✅ WiFi connected to SSID: $ssid, stopping RaspAP..." | tee -a "$LOG"
        sudo systemctl stop raspapd.service
        exit 0
    fi
    sleep 5
done
