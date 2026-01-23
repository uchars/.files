#!/usr/bin/env sh
APP_ID="sysscratch"
CMD="$@"

CURRENT_PID=$(swaymsg -t get_tree | jq -r ".. | select(.app_id? == \"$APP_ID\") | .pid // empty")

if [ -n "$CURRENT_PID" ]; then
    if ps -p "$CURRENT_PID" -o args= | grep -q -- "$CMD"; then
        # kill same app
        kill "$CURRENT_PID" 2>/dev/null
        exit 0
    else
        # kill other app before spawnign next
        kill "$CURRENT_PID" 2>/dev/null
        sleep 0.1
    fi
fi

alacritty --class "$APP_ID" -e $CMD &

for _ in $(seq 1 20); do
    if swaymsg -t get_tree | jq -e ".. | select(.app_id? == \"$APP_ID\")" >/dev/null; then
        swaymsg "[app_id=\"$APP_ID\"] move scratchpad"
        swaymsg "[app_id=\"$APP_ID\"] scratchpad show"
        exit 0
    fi
    sleep 0.05
done
exit 1

