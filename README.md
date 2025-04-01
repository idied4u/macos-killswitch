# **MacOS-Killswitch Network Lockdown Utility**

## **Overview**

MacOS-KillSwitch is a powerful tool designed to completely **lock down** and **disable network access** on your macOS system for **high security**. It blocks all network interfaces, disables Bluetooth, USB devices, and Thunderbolt networking, and even sets up a persistent firewall that blocks all inbound and outbound traffic. This tool is ideal for **paranoid security setups**, offline systems, or those needing complete network isolation.

The utility includes two parts:
1. **MacOS-KillSwitch**: The main lockdown script that disables network interfaces, ports, and devices.
2. **Reverse-MacOS**: A reverse script that restores all interfaces, services, and devices to their normal state.

---

## **Features**
- **Lockdown (MacOS-KillSwitch)**:
    - Disables **Wi-Fi** and **Ethernet** interfaces.
    - **Disables Bluetooth** (including discovery and pairing).
    - **Blocks all traffic** using macOS's built-in `pf` firewall.
    - **Disables USB devices** and **Thunderbolt networking**.
    - **Makes the firewall persistent** across reboots by installing a LaunchDaemon.

- **Reverse (Unkill)**:
    - **Re-enables Wi-Fi** and **Ethernet** interfaces.
    - **Restores Bluetooth** and its services.
    - **Reverses firewall settings** by disabling `pf`.
    - **Re-enables USB devices** and **Thunderbolt networking**.
    - **Removes the firewall reapplication LaunchDaemon**.

---

## **Requirements**
- macOS system with root access (administrator privileges).
- **SIP (System Integrity Protection)** should be disabled for full device manipulation (USB/Thunderbolt device blocking and re-enabling).

---

## **How to Use MacOS-KillSwitch**

Open Terminal and navigate to the folder where the scripts are saved. Then make both scripts executable:
