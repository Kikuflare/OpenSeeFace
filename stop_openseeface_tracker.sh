#!/usr/bin/env bash
set -euo pipefail

PID_FILE="/tmp/openseeface_tracker.pid"

if [ ! -f "$PID_FILE" ]; then
  echo "No OpenSeeFace tracker PID file found."
  exit 0
fi

PID="$(cat "$PID_FILE")"
if kill -0 "$PID" >/dev/null 2>&1; then
  echo "Stopping OpenSeeFace tracker PID=$PID"
  kill "$PID"
  sleep 1
  if kill -0 "$PID" >/dev/null 2>&1; then
    echo "Tracker did not exit, forcing kill"
    kill -9 "$PID" >/dev/null 2>&1 || true
  fi
else
  echo "Tracker PID=$PID is not running."
fi
rm -f "$PID_FILE"
