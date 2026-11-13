#!/usr/bin/env bash
# ===== LocalhorstKI Starter (Linux) =====
# Startet Ollama (falls nötig), lädt das Modell und öffnet
# LocalhorstKI im Browser – mit passenden Einstellungen.

# --- Hier anpassen ---
SERVER="http://localhost:11434/v1"
MODEL="gemma3:4b"
TPL="schreibhelfer"   # Teilname reicht: schreibhelfer, übersetzer, kurz ...
# --- Ende Anpassung ---

# Wichtig für CORS: Die Chat-Seite läuft lokal (file://),
# Ollama muss deshalb Anfragen von lokalen Seiten erlauben.
# Läuft Ollama als systemd-Service, gilt die Variable hier NICHT – dann:
#   sudo systemctl edit ollama
#   [Service]
#   Environment="OLLAMA_ORIGINS=*"
#   sudo systemctl restart ollama
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
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL" >/dev/null 2>&1
elif command -v firefox >/dev/null 2>&1; then
  firefox "$URL" >/dev/null 2>&1 &
elif command -v google-chrome >/dev/null 2>&1; then
  google-chrome "$URL" >/dev/null 2>&1 &
else
  echo "Bitte manuell öffnen: $URL"
fi
