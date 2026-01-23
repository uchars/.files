#!/usr/bin/env sh
if swaymsg -t get_tree | jq -e '.. | select(.app_id? == "bluetui")' >/dev/null; then
    swaymsg '[app_id="bluetui"] scratchpad show'
    exit 0
fi
alacritty --class bluetui -e bluetui &
for _ in $(seq 1 20); do
    if swaymsg -t get_tree | jq -e '.. | select(.app_id? == "bluetui")' >/dev/null; then
        swaymsg '[app_id="bluetui"] move scratchpad'
        swaymsg '[app_id="bluetui"] scratchpad show'
        exit 0
    fi
    sleep 0.05
done

