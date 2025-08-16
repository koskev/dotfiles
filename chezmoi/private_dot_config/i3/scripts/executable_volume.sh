#!/bin/bash

env LANG=en pactl list sinks | grep "Mute: yes" > /dev/null 2>/dev/null
IS_MUTE=$?
VOLUME=$(pactl list sinks | grep  "front-left:" | cut -d "/" -f4 | head -1 | tr -d '[:space:]%')
ICON="\uf026"
COLOR=\#ff0000

if [[ "$IS_MUTE" -eq "0" ]]; then
	COLOR=\#ff0000
	ICON="\uf026"
	VOLUME="mute"
else


	if [[ $VOLUME -gt 25 ]]; then
		COLOR=\#ffff00
		ICON="\uf027"
	fi

	if [[ $VOLUME -gt 50 ]]; then
		COLOR=\#00ff00
		ICON="\uf028"
	fi

	VOLUME=$VOLUME\%
fi


echo "\"full_text\" : \"$ICON $VOLUME\", \"color\" :\"$COLOR\""
#FIX inbalance
pactl set-sink-volume 0 $VOLUME
