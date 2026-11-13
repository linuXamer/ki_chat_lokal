#!/usr/bin/env bash
# ===== LocalhorstKI Starter (macOS) =====
# Startet Ollama (falls nötig), lädt das Modell und öffnet
# LocalhorstKI im Browser – mit passenden Einstellungen.

# --- Hier anpassen ---
SERVER="http://localhost:11434/v1"
MODEL="gemma3:4b"
TPL="schreibhelfer"   # Teilname reicht: schreibhelfer, übersetzer, kurz ...
# --- Ende Anpassung ---

# Wichtig für CORS: Die Chat-Seite läuft lokal (file://).
# Läuft die Ollama-App bereits im Hintergrund, gilt die Variable hier NICHT:
# App beenden, dann startet dieses Skript Ollama selbst – oder systemweit setzen:
#   launchctl setenv OLLAMA_ORIGINS "*"   (danach Ollama-App neu starten)
export OLLAMA_ORIGINS="*"

command -v ollama >/dev/null 2>&1 || { echo "[X] Ollama ist nicht installiert: https://ollama.com"; exit 1; }

if ! curl -s -o /dev/null --max-time 2 http://localhost:11434; then
  echo "[i] Starte Ollama ..."
  (ollama serve >/dev/null 2>&1 &)
fi
for i in $(seq 1 30); do
  curl -s -o /dev/null --max-time 2 http://localhost:11434 && break
  sleep 1
done

echo "[i] Stelle Modell $MODEL bereit (erster Download kann dauern) ..."
ollama pull "$MODEL" >/dev/null 2>&1

URL="file://$(cd "$(dirname "$0")/.." && pwd)/index.html?server=$SERVER&model=$MODEL&tpl=$TPL"
echo "[ok] Öffne LocalhorstKI ..."
# Chrome übergeben die URL-Parameter zuverlässig an die Seite.
# (Safari/open kann bei file://-URLs den Teil hinter "?" verwerfen.)
open -a "Google Chrome" "$URL" 2>/dev/null || open "$URL" || echo "Bitte manuell öffnen: $URL"
