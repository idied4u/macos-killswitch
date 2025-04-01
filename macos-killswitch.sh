#!/bin/bash

echo "=== Vanishing: macOS Network Lockdown ==="

# Must run as root
if [ "$EUID" -ne 0 ]; then
  echo "Run this script as root (sudo)."
  exit 1
fi

echo "[+] Disabling Wi-Fi..."
networksetup -setairportpower Wi-Fi off

echo "[+] Disabling Ethernet interfaces..."
ifconfig en0 down 2>/dev/null
ifconfig en1 down 2>/dev/null

echo "[+] Disabling Bluetooth..."
defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
killall -HUP blued 2>/dev/null

echo "[+] Unloading discovery and AirDrop-related daemons..."
launchctl unload -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist 2>/dev/null
killall -9 discoveryd mDNSResponder 2>/dev/null

echo "[+] Creating and enabling full-block pf firewall rules..."
cat <<EOF > /etc/pf.conf
block in all
block out all
EOF

pfctl -f /etc/pf.conf
pfctl -e

echo "[+] Installing launch daemon to enforce firewall at boot..."
cat <<EOF > /Library/LaunchDaemons/com.silentkill.firewall.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.silentkill.firewall</string>
  <key>ProgramArguments</key>
  <array>
    <string>/sbin/pfctl</string>
    <string>-f</string>
    <string>/etc/pf.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF

chmod 644 /Library/LaunchDaemons/com.silentkill.firewall.plist
chown root:wheel /Library/LaunchDaemons/com.silentkill.firewall.plist
launchctl load /Library/LaunchDaemons/com.silentkill.firewall.plist

# Disable USB & Thunderbolt
echo "[+] Disabling USB devices and Thunderbolt..."
# Disable all USB devices (including networking devices)
sudo kextunload -b com.apple.driver.AppleUSBHostMergeProperties
sudo kextunload -b com.apple.driver.AppleUSBXHCI

# Disable Thunderbolt networking (if any)
sudo defaults write /Library/Preferences/com.apple.networking.thunderbolt EthernetMode -string "disabled"

echo ">>> SilentKill macOS lockdown complete. This machine is now OFFLINE and hardened."
