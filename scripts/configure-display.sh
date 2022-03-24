#!/bin/sh

laptop_variant="$(cat /sys/devices/virtual/dmi/id/product_name)"

if [[ "$laptop_variant" == "ZenBook UX434FL_UX434FL" ]]; then
    # Monitor info:
    # eDP-1     -> Laptop display
    # HDMI-1    -> Touchpad display
    # HDMI-2    -> Display connected to HDMI port

    # Determine if monitor is connected
    if xrandr | grep 'HDMI-2 connected'; then
        best_resolution=$(xrandr |\
            grep -A5 'HDMI-2 connected' |\
            grep -v '30.00' |\
            tail -n+2 |\
            head -n+1 |\
            xargs |\
            cut -d' ' -f1)
        
        xrandr \
            --output HDMI-1 --off \
            --output HDMI-2 --primary --mode $best_resolution --pos 0x0 --rotate normal \
            --output eDP-1 --mode 1920x1080 --right-of HDMI-2 --rotate normal
    else
        xrandr \
            --output HDMI-1 --off \
            --output HDMI-2 --off \
            --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
    fi
fi
