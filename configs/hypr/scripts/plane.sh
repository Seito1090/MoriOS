#! /bin/bash
# Script that effectively turn on/off airplane mode on the device

blocked_bluetooth=$(rfkill list bluetooth | grep -o "Soft blocked: yes")
blocked_wifi=$(rfkill list wifi | grep -o "Soft blocked: yes")

if [ -n "$blocked_bluetooth" ]; then
    rfkill unblock bluetooth
else
    rfkill block bluetooth
fi

if [ -n "$blocked_wifi" ]; then
    rfkill unblock wifi
    notify-send -u low "Airplane mode: OFF"
else
    rfkill block wifi
    notify-send -u low "Airplane mode: ON"
fi

