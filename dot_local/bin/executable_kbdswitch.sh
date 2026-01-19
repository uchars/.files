#!/bin/sh
KEYBOARD_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
if [ "$KEYBOARD_LAYOUT" = "us" ]; then
    setxkbmap de
else
    setxkbmap us
fi
