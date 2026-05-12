#!/usr/bin/env bash
set -e

# Virtual display
Xvfb "$DISPLAY" -screen 0 "$SCREEN_RESOLUTION" -nolisten tcp &
XVFB_PID=$!
sleep 1

# Minimal window manager
openbox --config-file /dev/null &
sleep 0.5

# VNC server
if [ -n "$VNC_PASSWORD" ]; then
  mkdir -p ~/.vnc
  x11vnc -storepasswd "$VNC_PASSWORD" ~/.vnc/passwd
  x11vnc -display "$DISPLAY" -rfbport "$VNC_PORT" \
         -rfbauth ~/.vnc/passwd -forever -shared -noxdamage &
else
  x11vnc -display "$DISPLAY" -rfbport "$VNC_PORT" \
         -nopw -forever -shared -noxdamage &
fi
sleep 1

# WebSocket proxy
websockify --web /dev/null "$WS_PORT" "localhost:$VNC_PORT" &
sleep 0.5

# Launch Chrome
exec chromium-browser \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --start-maximized \
  --window-position=0,0 \
  ${CHROME_FLAGS:-} \
  "${START_URL:-https://www.google.com}"
