#!/usr/bin/env bash

# Waybar reset script
# Kills Waybar cleanly, then restarts it in the background

set -e

# Kill all running Waybar instances (if any)
if pgrep -x waybar > /dev/null; then
    pkill -TERM waybar
    sleep 0.5
fi

# Just in case something got stubborn
pkill -KILL waybar 2>/dev/null || true

# Small pause so Wayland doesn’t get grumpy
sleep 0.3

# Restart Waybar
waybar >/tmp/waybar.log 2>&1 & disown
