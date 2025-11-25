#!/usr/bin/env bash

TEMP_FILE="/tmp/gammastep_temp"
DEFAULT_TEMP=3500
STEP=500
MIN_TEMP=1500
MAX_TEMP=6500

# Hàm notify
notify_user() {
      notify-send -h string:x-canonical-private-synchronous:nightshift \
            -u low -t 2000 "Night Shift Control" "$1"
      }

# Lấy nhiệt độ hiện tại
if [ -f "$TEMP_FILE" ]; then
      CURRENT=$(cat "$TEMP_FILE")
else
      CURRENT=$DEFAULT_TEMP
fi

case "$1" in
      toggle)
            if pgrep -x "gammastep" > /dev/null; then
                  pkill gammastep
                  notify_user "Disabled"
            else
                  gammastep -O "$CURRENT" &
                  notify_user "Enabled: ${CURRENT}K"
            fi
            ;;
      up)
            NEW_TEMP=$((CURRENT + STEP))
            if [ "$NEW_TEMP" -le "$MAX_TEMP" ]; then
                  echo "$NEW_TEMP" > "$TEMP_FILE"
                  pkill gammastep
                  sleep 0.1
                  gammastep -O "$NEW_TEMP" &
                  notify_user "Increased: ${NEW_TEMP}K"
            else
                  notify_user "Max temp reached (${CURRENT}K)"
            fi
            ;;
      down)
            NEW_TEMP=$((CURRENT - STEP))
            if [ "$NEW_TEMP" -ge "$MIN_TEMP" ]; then
                  echo "$NEW_TEMP" > "$TEMP_FILE"
                  # Ép chạy lại ngay lập tức
                  pkill gammastep
                  sleep 0.1
                  gammastep -O "$NEW_TEMP" &
                  notify_user "Decreased: ${NEW_TEMP}K"
            else
                  notify_user "Min temp reached (${CURRENT}K)"
            fi
            ;;
      *)
            echo "Usage: $0 {toggle|up|down}"
            exit 1
            ;;
esac
