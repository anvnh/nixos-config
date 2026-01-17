#!/usr/bin/env bash
set -euo pipefail

if ! command -v cliphist >/dev/null 2>&1; then
  notify-send "Clipboard" "cliphist is not installed" 2>/dev/null || true
  exit 1
fi
if ! command -v rofi >/dev/null 2>&1; then
  notify-send "Clipboard" "rofi is not installed" 2>/dev/null || true
  exit 1
fi
if ! command -v wl-copy >/dev/null 2>&1; then
  notify-send "Clipboard" "wl-copy is not installed" 2>/dev/null || true
  exit 1
fi

cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/rofi"
thumb_dir="$cache_root/thumbs"
mkdir -p "$thumb_dir"

make_thumb() {
  local key="$1"
  local line="$2"
  local thumb="$thumb_dir/$key.png"

  [[ -f "$thumb" ]] && return 0

  local tmp="$thumb_dir/$key.bin"
  if ! cliphist decode <<<"$line" >"$tmp" 2>/dev/null; then
    rm -f "$tmp"
    return 1
  fi

  if command -v magick >/dev/null 2>&1; then
    magick "$tmp" -thumbnail 256x256^ -gravity center -extent 256x256 "$thumb" 2>/dev/null || true
  elif command -v convert >/dev/null 2>&1; then
    convert "$tmp" -thumbnail 256x256^ -gravity center -extent 256x256 "$thumb" 2>/dev/null || true
  fi

  rm -f "$tmp"
  [[ -f "$thumb" ]]
}

menu_entries() {
  cliphist list | while IFS= read -r line; do
    [[ -n "$line" ]] || continue

    # cliphist format: "<id> <preview>" (id is first token)
    key="${line%% *}"

    # Heuristic: binary entries show as "[[ binary data ... ]]"
    if [[ "$line" == *"[["*"binary"*"data"*" ]]"* || "$line" == *"binary data"* ]]; then
      if make_thumb "$key" "$line"; then
        printf '%s\0icon\x1f%s\n' "$line" "$thumb_dir/$key.png"
      else
        printf '%s\n' "$line"
      fi
    else
      printf '%s\n' "$line"
    fi
  done
}

selection="$(
  menu_entries | rofi -dmenu -i -p "Clipboard" -show-icons -theme-str 'element-icon { size: 72px; }'
)"

[[ -n "${selection:-}" ]] || exit 0

cliphist decode <<<"$selection" | wl-copy
