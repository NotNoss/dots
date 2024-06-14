#!/bin/sh

status=$(cat /sys/class/power_supply/BAT0/status)
level=$(cat /sys/class/power_supply/BAT0/capacity)

if [ $status = "Charging" ]; then
  echo "󱐋󰂀 $level"
else
  echo "󰂀 $level"
fi
