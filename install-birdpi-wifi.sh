#!/bin/bash

set -e

echo "== BirdPi WiFi Onboarding Installer =="

# 1. Install RaspAP
if [ ! -d "/etc/raspap" ]; then
    echo "-- Downloading and installing RaspAP..."
    curl -sL https://install.raspap.com | bash -s -- --yes
else
    echo "-- RaspAP appears to already be installed. Skipping install."
fi

# 2. Disable RaspAP AP mode at boot
# echo "-- Disabling RaspAP service by default..."
# sudo systemctl stop raspapd.service || true
# sudo systemctl disable raspapd.service || true

# 3. Copy onboarding script
echo "-- Copying birdpi-wifi-onboard.sh..."
sudo install -m 755 ./usr/local/bin/birdpi-wifi-onboard.sh /usr/local/bin/birdpi-wifi-onboard.sh

# 4. Copy systemd service
echo "-- Copying birdpi-wifi-onboard.service..."
sudo install -m 644 ./etc/systemd/system/birdpi-wifi-onboard.service /etc/systemd/system/birdpi-wifi-onboard.service

# 5. Reload and enable your onboarding service
echo "-- Enabling birdpi-wifi-onboard.service..."
sudo systemctl daemon-reload
sudo systemctl enable birdpi-wifi-onboard.service
sudo systemctl restart birdpi-wifi-onboard.service

echo "== Install complete! =="
echo "Check /var/log/birdpi-wifi-onboard.log for onboarding logs."
echo "To test, reboot your Pi and try without WiFi to see the onboarding AP."

