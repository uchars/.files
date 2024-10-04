while true; do
    BAT_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
    BAT_STATUS=$(cat /sys/class/power_supply/BAT1/status)
    SOUND_VOLUME=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')
    SOUND_MUTED=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
    if [ "$SOUND_MUTED" = "off" ]; then
        SOUND_MUTED="(muted)"
    else
        SOUND_MUTED=""
    fi
    xsetroot -name "$SOUND_VOLUME$SOUND_MUTED | $BAT_CAPACITY% ($BAT_STATUS) | $(date)"
    sleep 1
done
