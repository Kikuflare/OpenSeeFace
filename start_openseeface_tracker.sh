#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="/tmp/openseeface_tracker.pid"
LOG_FILE="/tmp/openseeface_tracker.log"

if [ -f "$PID_FILE" ]; then
  PID="$(cat "$PID_FILE")"
  if kill -0 "$PID" >/dev/null 2>&1; then
    echo "OpenSeeFace tracker already running PID=$PID"
    exit 0
  else
    rm -f "$PID_FILE"
  fi
fi

TRACKER_CMD=("$SCRIPT_DIR/venv/bin/python" "$SCRIPT_DIR/facetracker.py" -c 0 -W 1280 -H 720 --discard-after 0 --scan-every 0 --no-3d-adapt 1 --max-feature-updates 900 --ip 127.0.0.1 --port 11573 -v 0 --log-output "$LOG_FILE")

echo "Starting OpenSeeFace tracker..."
nohup "${TRACKER_CMD[@]}" >>"$LOG_FILE" 2>&1 &
TRACKER_PID=$!
echo "$TRACKER_PID" > "$PID_FILE"

echo "Tracker started PID=$TRACKER_PID"
sleep 1
if ! kill -0 "$TRACKER_PID" >/dev/null 2>&1; then
  echo "Tracker failed to start"
  exit 1
fi
