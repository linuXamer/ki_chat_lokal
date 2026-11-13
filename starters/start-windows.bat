@echo off
setlocal EnableExtensions
REM ===== LocalhorstKI Starter (Windows) =====
REM Startet Ollama (falls noetig), laedt das Modell und oeffnet
REM LocalhorstKI im Browser - mit passenden Einstellungen.

REM --- Hier anpassen ---
set "SERVER=http://localhost:11434/v1"
set "MODEL=gemma3:4b"
REM Vorlage: Teilname reicht, z.B. "schreibhelfer", "uebersetzer", "kurz"
set "TPL=schreibhelfer"
REM --- Ende Anpassung ---

REM Wichtig fuer CORS: Die Chat-Seite laeuft lokal (file://),
REM Ollama muss deshalb Anfragen von lokalen Seiten erlauben.
REM Gilt nur fuer Ollama-Prozesse, die AB HIER gestartet werden.
REM Laeuft Ollama bereits im Hintergrund (Tray/App-Autostart), beende es
REM vorher ODER setze OLLAMA_ORIGINS systemweit (siehe README).
set "OLLAMA_ORIGINS=*"

where ollama >nul 2>&1
if errorlevel 1 goto noollama

curl -s -o NUL --max-time 2 http://localhost:11434
if errorlevel 1 goto startollama
goto pull

:startollama
echo [i] Starte Ollama ...
start "Ollama" /min cmd /c "ollama serve"

:waitloop
timeout /t 1 /nobreak >nul
curl -s -o NUL --max-time 2 http://localhost:11434
if errorlevel 1 goto waitloop

:pull
echo [i] Stelle Modell %MODEL% bereit (erster Download kann dauern) ...
ollama pull %MODEL% >nul 2>&1

for %%I in ("%~dp0..") do set "ROOT=%%~fI"
set "ROOTFWD=%ROOT:\=/%"
set "URL=file:///%ROOTFWD%/index.html?server=%SERVER%&model=%MODEL%&tpl=%TPL%"
echo [ok] Oeffne LocalhorstKI ...
start "" "%URL%"
REM Falls der Standard-Browser die Parameter hinter "?" verwirft,
REM Browser explizit starten (eine Zeile aktivieren):
REM start msedge "%URL%"
REM start chrome "%URL%"
exit /b 0

:noollama
echo [X] Ollama nicht gefunden. Installation: https://ollama.com/download
pause
exit /b 1
