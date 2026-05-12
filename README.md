# Chrome Remote Browser

Chrome im Browser nutzen – gehostet auf GitHub Pages, Chrome läuft lokal oder auf einem Server im Docker-Container.

## Architektur

```
Browser (GitHub Pages)
  ↕ WebSocket (ws/wss)
websockify (Port 6080)
  ↕ VNC-Protokoll
x11vnc (Port 5900)
  ↕ X11
Xvfb + Openbox
  ↕
Chromium
```

## Schnellstart

### 1. Docker-Container starten

```bash
# Repository klonen
git clone https://github.com/roentgenjon/Chrome.git
cd Chrome

# Container bauen und starten
docker compose up -d
```

Chrome ist jetzt erreichbar auf `localhost:6080`.

### 2. GitHub Pages öffnen

Gehe zur GitHub Pages URL des Repositories und gib `localhost:6080` als Server ein.

> **Tipp:** Für lokalen Betrieb funktioniert das direkt. Für Remote-Zugriff muss Port 6080 erreichbar sein.

## Konfiguration

Umgebungsvariablen in `docker-compose.yml`:

| Variable | Standard | Beschreibung |
|----------|----------|--------------|
| `SCREEN_RESOLUTION` | `1920x1080x24` | Bildschirmauflösung |
| `VNC_PASSWORD` | leer | VNC-Passwort (empfohlen setzen!) |
| `START_URL` | `https://www.google.com` | Start-URL |
| `CHROME_FLAGS` | leer | Zusätzliche Chrome-Flags |

### Passwort setzen

```yaml
# docker-compose.yml
environment:
  VNC_PASSWORD: "mein-sicheres-passwort"
```

### Remote-Zugriff mit HTTPS/WSS

Für GitHub Pages (HTTPS) muss die WebSocket-Verbindung verschlüsselt sein (`wss://`).
Nginx als SSL-Proxy einrichten:

```nginx
server {
    listen 443 ssl;
    server_name deine-domain.de;
    # ... SSL-Zertifikat ...

    location /websockify {
        proxy_pass http://localhost:6080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```

Dann im Browser `deine-domain.de:443` (mit HTTPS) als Host angeben.

## URL-Parameter

Direkte Verbindung via URL:

```
https://roentgenjon.github.io/Chrome/?host=mein-server.de&port=443&pass=passwort
```

## Voraussetzungen

- Docker & Docker Compose
- Für Remote-Zugriff: offener Port 6080 (oder 443 mit nginx)
