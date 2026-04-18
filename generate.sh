#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 config_player.xml serversettings.xml" >&2
  exit 2
fi

CONFIGPLAYER="$1"
SERVERSETTINGS="$2"

# ==========================================================================================

CONTENTPACKAGES_PTRN='contentpackages>'

if [[ ! -f "$CONFIGPLAYER" ]]; then
  echo "Source not found: $CONFIGPLAYER" >&2
  exit 3
fi

# get first and last matching line numbers
mapfile -t LINES < <(grep -nF "$CONTENTPACKAGES_PTRN" "$CONFIGPLAYER" | cut -d: -f1)
if [[ ${#LINES[@]} -lt 1 ]]; then
  echo "Pattern not found: $CONTENTPACKAGES_PTRN" >&2
  exit 4
fi

FIRST="${LINES[0]}"
LAST="${LINES[-1]}"

CONTENTPACKAGES=$(sed -n "${FIRST},${LAST}p" "$CONFIGPLAYER")

# ==========================================================================================

# Make temporary SERVERSETTINGS file wo/ contentpackages
[[ -f "$SERVERSETTINGS" ]] || { echo "File not found: $SERVERSETTINGS" >&2; exit 4; }
TMP=$(mktemp)
FIRST=$(grep -nF "$CONTENTPACKAGES_PTRN" "$SERVERSETTINGS" | head -n1 | cut -d: -f1 || true)
LAST=$( grep -nF "$CONTENTPACKAGES_PTRN" "$SERVERSETTINGS" | tail -n1 | cut -d: -f1 || true)
if [[ -z "$FIRST" || -z "$LAST" ]]; then
  cp $SERVERSETTINGS $TMP
else
  sed "${FIRST},${LAST}d" "$SERVERSETTINGS" > "$TMP"
fi

# Paste <contentpackages> block to the end of <serversettings> block 
SERVERSETTINGS_PTRN='</serversettings>'
last_ln=$(grep -nF "$SERVERSETTINGS_PTRN" "$TMP" | tail -n1 | cut -d: -f1 || true)
if [[ -z "$last_ln" ]]; then
  echo "Pattern not found in target: $SERVERSETTINGS_PTRN" >&2
  exit 5
fi

# Cannot reuse the same file bc sed operates on streams
TMP2=$(mktemp)
{
  sed -n "1,$((last_ln-1))p" "$TMP"
  echo "$CONTENTPACKAGES"
  sed -n "${last_ln},\$p" "$TMP"
} > "$TMP2"

# ==========================================================================================

# Remove any ^M symbols left after paste
sed -i 's///g' $TMP2 

# Change mod paths to $PWD/Installed
sed -E -i "s|(path=\")[^\"]*/Installed/|\1$PWD/Installed/|g" $TMP2

# Apply changes to serversettings.xml
mv --backup $TMP2 $SERVERSETTINGS
