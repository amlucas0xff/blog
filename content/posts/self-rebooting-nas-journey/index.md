---
date: 2025-07-27
title: "Self-Rebooting NAS journey: Watchdog got me"
draft: false
author: Alexandre Marcel Lucas
tags:
  - NAS
  - Watchdog
  - Sysadmin
  - TerraMaster
categories:
  - troubleshooting
description: Troubleshooting reboots on a TerraMaster NAS running TrueNAS
---

This month (July 2025), I decided to upgrade my homelab setup by purchasing a TerraMaster NAS device (F4-424). After installing TrueNAS Scale and upgrading the RAM to 16GB (the unit comes with only 4GB), I was excited to finally have a proper storage solution for my homelab. However, my joy quickly turned to frustration when I discovered the device was **mysteriously** rebooting every couple of hours. 

## HW Details

For reference, my setup:
- **Device**: TerraMaster F4-424 (Intel)
- **OS**: TrueNAS Scale 24.04
- **Watchdog**: Intel iTCO_wdt (integrated in PCH chipset)

## The Problem: Clockwork Reboots

I'd just finished setting up my new toy, configured the storage pool with NVMe caching, started playing with some services, and then... reboot. No warning, no error messages, just a clean restart every 2 hours.

My first instinct was to check the usual suspects:
- **Power supply issues?** Nope, using the original PSU from TerraMaster
- **Overheating?** It's winter in São Paulo (around 18°C), and the fans were spinning normally
- **Memory problems?** This is where I spent most of my time investigating — removed one stick, swapped slots, toggled BIOS Memory Mapping on/off

## The Investigation

After enabling SSH in TrueNAS, I logged into the system and started digging through the logs. Here's what I found:

```bash
# Check reboot history
last reboot | head -10
```

The pattern was unmistakable:
```shell
reboot   system boot  6.12.15-producti Sun Jul 27 10:58 - 11:29  (00:31)
reboot   system boot  6.12.15-producti Sun Jul 27 08:57 - 11:29  (02:32)
reboot   system boot  6.12.15-producti Sun Jul 27 06:56 - 11:29  (04:33)
reboot   system boot  6.12.15-producti Sun Jul 27 04:56 - 11:29  (06:33)
reboot   system boot  6.12.15-producti Sun Jul 27 02:55 - 11:29  (08:34)
```

Almost exactly 2 hours between each reboot. 

Digging deeper into the system journal revealed something interesting:

```bash
sudo journalctl --no-pager | grep -i watchdog
```

And there it was:
```
Jul 27 11:29:49 truenas systemd[1]: Using hardware watchdog 'iTCO_wdt', version 6, device /dev/watchdog0
Jul 27 11:29:49 truenas systemd[1]: Watchdog running with a hardware timeout of 10min.
Jul 27 11:29:49 truenas kernel: watchdog: watchdog0: watchdog did not stop!
```

## The Culprit: Hardware Watchdog

The TerraMaster motherboard has an **Intel Timer/Counter Watchdog (iTCO_wdt)** built into the Platform Controller Hub (PCH). This hardware-level watchdog timer is designed to automatically restart the system if it detects that the operating system has become unresponsive.

### My homework: How Watchdog works

Hardware watchdogs serve as the last line of defense against system **hangs**. it basically acts as autonomous fail-safe resource that monitors system activity through periodic "feeding" events.

Here's how the iTCO watchdog works:
1. **BIOS enables** the watchdog timer (For ex: 30-second timeout)
2. **Hardware expects** to be "fed" (reset) regularly by the OS
3. **If not fed**, the hardware assumes the OS has crashed and forces a reboot
4. **TrueNAS systemd** was configured with `RuntimeWatchdogSec=off` (disabled by default)

> **In my case**: The hardware watchdog was starving and forcing reboots every time its timeout expired.

## The Quick Fix: Disable it in BIOS

My immediate solution was to access the BIOS and disable the watchdog function entirely. This stopped the reboots, confirming my diagnosis:

To disable it follow this path: **Fast** > **Watch Dog Controller** > **Disabled**

However, this felt like treating the symptom rather than the disease. The watchdog is actually a valuable feature that can protect against system hangs and kernel panics.

## The Proper Solution: Feed the Beast

Instead of disabling the watchdog entirely, the better approach is to configure the operating system to properly work with it. Here's how to set up TrueNAS (or any systemd-based system) to feed the hardware watchdog:

### Step 1: Check Current Watchdog Status

```bash
# Check available watchdog devices
ls -la /dev/watchdog*

# Check loaded watchdog modules  
lsmod | grep -i watchdog

# Check current systemd watchdog config
systemctl show | grep WatchdogUSec
```

### Step 2: Configure systemd

Edit the systemd configuration:

```bash
sudo vi /etc/systemd/system.conf
```

Change from:
```shell
#RuntimeWatchdogSec=off
#ShutdownWatchdogSec=10min
```

To (or to the values that work for you)
```shell
RuntimeWatchdogSec=15s
ShutdownWatchdogSec=10min
```

### Step 3: Apply the Changes

Reload systemd configuration:
```shell
sudo systemctl daemon-reload
sudo systemctl daemon-reexec
```

### Step 4: Verify the Configuration

Check that the watchdog is being fed properly:
```shell
# Check hardware timeout
cat /sys/class/watchdog/watchdog0/timeout

# Monitor watchdog activity
sudo journalctl -f | grep -i watchdog
```

This configuration ensures that:
1. The watchdog provides protection against genuine system hangs
2. Normal operation won't trigger unwanted reboots
3. If systemd itself crashes, the hardware watchdog will still trigger a recovery reboot

## Troubleshooting Tips

If you're still experiencing issues, here are some common problems and solutions:

### Testing the Watchdog

To test if your watchdog is working correctly, you can temporarily stop systemd from feeding it.
```shell
sudo kill -STOP 1  # Stops PID 1 (systemd)
```

**Warning**: This will cause a reboot after the timeout expires!

## Final Thoughts

This experience reminded me why I love working with hardware and sysadmin challenges. What initially seemed like a defective device turned out to be a valuable learning opportunity. :-)