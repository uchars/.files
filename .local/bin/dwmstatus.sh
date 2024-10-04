#!/bin/bash
source $HOME/.config/alias.sh

while true; do
    BAT_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
    BAT_STATUS=$(cat /sys/class/power_supply/BAT1/status)
    SOUND_VOLUME=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')
    SOUND_MUTED=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
    SPOTIFY_STR=""
    SERVICE="org.mpris.MediaPlayer2.spotify"
    if dbus-send --print-reply --type=method_call --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2 string:Identity >/dev/null 2>/dev/null; then
        SPOTIFY_STATE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)')
        SPOTIFY_TITLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d \" -f 2)
        SPOTIFY_STR="($SPOTIFY_STATE) $SPOTIFY_TITLE |"
    fi
    if [ "$SOUND_MUTED" = "off" ]; then
        SOUND_MUTED="(muted)"
    else
        SOUND_MUTED=""
    fi
    xsetroot -name "$SPOTIFY_STR $SOUND_VOLUME$SOUND_MUTED | $BAT_CAPACITY% ($BAT_STATUS) | $(date)"
    sleep 1
done
