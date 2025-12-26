#!/usr/bin/env bash
set -euo pipefail

# rmpc on_song_change hook for macOS notifications

TMP_DIR="/tmp/rmpc"
mkdir -p "$TMP_DIR"

ALBUM_ART_PATH="$TMP_DIR/notification_cover"
DEFAULT_ALBUM_ART_PATH="$TMP_DIR/default_album_art.jpg"

# Try to fetch album art; fallback if not available
if ! rmpc albumart --output "$ALBUM_ART_PATH" >/dev/null 2>&1; then
  ALBUM_ART_PATH="$DEFAULT_ALBUM_ART_PATH"
fi

# ensure album art actually exists
if [ ! -f "$ALBUM_ART_PATH" ]; then
    unset ALBUM_ART_PATH
fi

# Show notification via notify-send (Linux)
if command -v notify-send >/dev/null 2>&1; then
  # Use album art if available, otherwise just text
  if [ -n "${ALBUM_ART_PATH:-}" ]; then
      notify-send -i "$ALBUM_ART_PATH" "${TITLE:-Unknown Title}" "${ARTIST:-Unknown Artist} - ${ALBUM:-Unknown Album}"
  else
      notify-send "${TITLE:-Unknown Title}" "${ARTIST:-Unknown Artist} - ${ALBUM:-Unknown Album}"
  fi
else
  >&2 printf 'notify-send not available; notification skipped\n'
fi

# Fetch lyrics if missing
if [ "${HAS_LRC:-}" = "false" ]; then
  mkdir -p "$(dirname "$LRC_FILE")"
  LRCLIB_INSTANCE="https://lrclib.net"

  LYRICS="$(curl -sG \
    -H "Lrclib-Client: rmpc-$VERSION" \
    --data-urlencode "artist_name=$ARTIST" \
    --data-urlencode "track_name=$TITLE" \
    --data-urlencode "album_name=$ALBUM" \
    "$LRCLIB_INSTANCE/api/get" | jq -r '.syncedLyrics')"

  if [ -z "$LYRICS" ] || [ "$LYRICS" = "null" ]; then
    rmpc remote --pid "$PID" status "Lyrics not found for $ARTIST - $TITLE" --level warn
    exit 0
  fi

  {
    echo "[ar:$ARTIST]"
    echo "[al:$ALBUM]"
    echo "[ti:$TITLE]"
    echo "$LYRICS" | sed -E '/^\[(ar|al|ti):/d'
  } >"$LRC_FILE"

  rmpc remote --pid "$PID" indexlrc --path "$LRC_FILE"
fi
