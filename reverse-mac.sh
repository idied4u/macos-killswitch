#!/bin/bash

echo "=== macOS Network Lockdown: RE-ENABLED ==="

# Must run as root
if [ "$EUID" -ne 0 ]; then
  echo "Run this script as root (sudo)."
  exit 1
fi

echo "[+] Re-enabling Wi-Fi..."
networksetup -setairportpower Wi-Fi on

echo "[+] Re-enabling Ethernet interfaces..."
ifconfig en0 up 2>/dev/null
ifconfig en1 up 2>/dev/null

echo "[+] Re-enabling Bluetooth..."
defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 1
killall -HUP blued 2>/dev/null

echo "[+] Re-enabling AirDrop and mDNSResponder..."
launchctl load -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist 2>/dev/null
killall -9 discoveryd mDNSResponder 2>/dev/null

echo "[+] Reversing pf firewall..."
pfctl -d

echo "[+] Removing launch daemon to stop firewall reapplication..."
rm /Library/LaunchDaemons/com.silentkill.firewall.plist

echo "[+] Re-enabling USB and Thunderbolt devices..."
# Enable USB devices
sudo kextload -b com.apple.driver.AppleUSBHostMergeProperties
sudo kextload -b com.apple.driver.AppleUSBXHCI

# Re-enable Thunderbolt networking
sudo defaults write /Library/Preferences/com.apple.networking.thunderbolt EthernetMode -string "enabled"

echo ">>> SilentKill macOS reverse complete. The system is now back online."
