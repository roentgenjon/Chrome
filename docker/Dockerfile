FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    VNC_PORT=5900 \
    WS_PORT=6080 \
    SCREEN_RESOLUTION=1920x1080x24 \
    VNC_PASSWORD=""

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium-browser \
    xvfb \
    x11vnc \
    websockify \
    dbus-x11 \
    xauth \
    openbox \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900 6080

CMD ["/start.sh"]
