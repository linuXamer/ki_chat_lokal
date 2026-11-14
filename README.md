# LocalhorstKI 🐦

**Der Ein-Datei-Chat für deine KI – im Heimnetz oder in der Cloud.**

Eine einzige HTML-Datei, die man direkt im Browser öffnet, um mit lokalen Modellen zu chatten – oder über die Server-Profile auch mit Cloud-APIs wie Mistral. Kein Server, kein Build-Prozess, keine externen Abhängigkeiten, kein CDN. Einfach herunterladen, öffnen, loschatten.

> **Datenschutz:** Mit lokalen Servern (LM Studio, Ollama, llama.cpp …) gehen alle Anfragen direkt vom Browser an dein Gerät – nichts verlässt dein Netzwerk. Bei Cloud-Profilen zeigt die Seite das ausdrücklich an.

## Warum „LocalhorstKI"? 🤔

*Localhost* – die Adresse, unter der jeder Homelab-Nerd zuhause ist – trifft auf *Horst* (deutscher Vorname, und zugleich der Nestbau-Ort des Wanderfalken 🐦) und *KI*. Der Name ist Programm: **Dein Rechner ist das Nest, deine Modelle wohnen drin.**

## Warum heißt es nicht mehr „LM Studio Chat"? (Projekt-Geschichte)

Dieses Projekt ist **aus der Praxis mit LM Studio entstanden**: Ich wollte eine einfache Webseite, die ich im Browser aufrufen kann, um direkt mit dem LM-Studio-Server in meinem Heimnetzwerk zu reden – inklusive Modell-Auswahl aus einer Auswahlliste. LM Studio war also der Anlass und bleibt der primäre Anwendungsfall (die Setup-Hinweise im Tool beziehen sich darauf).

Zwei Gründe für den neutralen Namen:

1. **Markenrecht:** „LM Studio" ist der Produktname von [lmstudio.ai](https://lmstudio.ai). Ein Drittanbieter-Projekt unter diesem Namen könnte wie eine offizielle Verbindung aussehen. LM Studio wird hier nur als *kompatibles Backend* genannt.
2. **Technik:** Die Seite spricht die OpenAI-kompatible API (`/v1/models`, `/v1/chat/completions`) – dieselbe Schnittstelle bieten viele Server und Cloud-APIs an. Der Name soll das widerspiegeln.

## ✨ Features

- 🎛️ **Modell-Auswahl per Dropdown** – Modelle werden live vom Server geladen
- 🌊 **Live-Streaming** der Antworten, jederzeit stoppbar
- 📊 **Statistiken** pro Antwort: Token-Anzahl, Tokens/Sekunde, Dauer (soweit vom Server geliefert)
- ⚙️ **Modell-Parameter**: Temperature, Top-P, Top-K, Seed, Max. Tokens, System-Prompt (mit Vorlagen, z. B. Schreibhelfer/Textkorrektur)
- 🖥️ **Server-Profile** – mehrere Server speichern und per Dropdown wechseln, z. B. LM Studio im Büro, Ollama auf dem Homeserver, Mistral in der Cloud
- ☁️ **Cloud-Kennzeichnung**: HTTPS-Profile werden als Cloud erkannt – mit Warnhinweis („Anfragen verlassen dein Heimnetz") und kompatibler Parameter-Auswahl (LM-Studio-Extras wie Top-K/Seed werden dann nicht gesendet)
- 🔗 **URL-Parameter** – Server, Modell & Vorlage per Link vorkonfigurieren (`?server=…&model=…&tpl=…`) – die Basis für die Starter-Scripts
- 📎 **Datei-Anhänge** – zwei Sorten:
  - **Bilder** (für Vision-Modelle): per 📎-Button, Strg+V (Screenshot) oder Drag & Drop
  - **Textdateien** (`.txt`, `.md`, `.json`, `.csv`, Code, Logs … bis 512 KB): der Inhalt wird mit Dateinamen in die Nachricht eingebettet und funktioniert so mit **jedem** Modell. PDFs u. ä. Binärdateien müssen erst in Text umgewandelt werden.
- 🗂️ **Chat-Verläufe** – mehrere Konversationen, gespeichert im Browser (localStorage)
- 📋 **Kopieren** (ganze Antwort oder einzelne Codeblöcke), **Neu generieren**, **Bearbeiten**
- ⬇️ Chat als **Markdown** oder **JSON** exportieren
- 🎨 **Akzentfarbe frei wählbar** (6 Presets + eigener Farbwähler) und 🌙/☀️ **Dark/Light-Theme**
- 🛡️ **Security**: siehe unten
- 📱 Responsive – funktioniert auch auf dem Handy im WLAN

## 🚀 Schnellstart (mit LM Studio)

1. LM Studio öffnen → Tab **Developer** → Modell laden → **Start Server**
2. In den Server-Einstellungen aktivieren: ✅ **Serve on Local Network** und ✅ **Enable CORS**
3. [`index.html`](index.html) herunterladen und per Doppelklick im Browser öffnen
4. Links die Server-URL eintragen (z. B. `http://192.168.178.114:1234`) → **↻** → Modell auswählen
5. Chatten! **Enter** = senden, **Shift+Enter** = neue Zeile

## ⚡ Ein-Klick-Start mit Ollama (Starter-Scripts)

Für Ollama gibt es fertige Starter im Ordner [`starters/`](starters/): **ein Aufruf** – Ollama wird gestartet (falls nötig), das Modell geladen/pullt und LocalhorstKI öffnet sich im Browser, bereits mit Server, Modell und Vorlage vorkonfiguriert.

| System | Start | Script |
|---|---|---|
| **Windows** | Doppelklick | [`starters/start-windows.bat`](starters/start-windows.bat) |
| **Linux** | `bash starters/start-linux.sh` | [`starters/start-linux.sh`](starters/start-linux.sh) |
| **macOS** | `bash starters/start-macos.sh` | [`starters/start-macos.sh`](starters/start-macos.sh) |

**Anpassen:** Oben in jedem Script lassen sich `SERVER`, `MODEL` und `TPL` (Vorlage, Teilname reicht, z. B. `schreibhelfer`) ändern. Voreingestellt: Ollama lokal (`http://localhost:11434/v1`), `gemma3:4b`, Vorlage *Schreibhelfer (Textkorrektur)* – ein guter Start für Textkorrektur auf 8-GB-Laptops.

**Wichtig – CORS:** Die Chat-Seite läuft lokal (`file://`), deshalb braucht Ollama `OLLAMA_ORIGINS=*`.

- Die Scripts setzen die Variable selbst – aber nur für Ollama-Prozesse, die **vom Script gestartet** werden.
- Läuft Ollama bei dir bereits im Hintergrund (Windows-Tray, systemd-Service, macOS-App mit Autostart), setze die Variable systemweit:
  - **Windows:** Systemumgebungsvariable `OLLAMA_ORIGINS` = `*` setzen (Systemeinstellungen → Umgebungsvariablen), Ollama-App beenden und neu starten
  - **Linux:** `sudo systemctl edit ollama` → `[Service]` + `Environment="OLLAMA_ORIGINS=*"` → `sudo systemctl restart ollama`
  - **macOS:** `launchctl setenv OLLAMA_ORIGINS "*"` im Terminal, danach Ollama-App neu starten

**Hinweis Windows:** Das Script nutzt `curl` (ab Windows 10 integriert). Sollte der Standard-Browser die Parameter hinter dem `?` verworfen, stehen im Script fertige Zeilen für Edge/Chrome bereit.

### 🔗 Ohne Script: URL-Parameter

Man kann die Datei auch direkt mit Parametern aufrufen – z. B. als Desktop-Verknüpfung:

```
index.html?server=http://localhost:11434/v1&model=gemma3:4b&tpl=schreibhelfer
index.html?server=https://api.mistral.ai/v1&tpl=schreibhelfer
```

| Parameter | Wirkung |
|---|---|
| `server` | Profil-URL – existierendes Profil wird gewählt, sonst neu angelegt |
| `model` | Modell wird vorausgewählt (sofern auf dem Server vorhanden) |
| `tpl` | Vorlage per Teilname (Groß-/Kleinschreibung egal), z. B. `schreibhelfer`, `uebersetzer`, `kurz` |
| `name` | Name für ein neu angelegtes Profil (optional) |
| `key` | API-Key für ein Profil (optional, z. B. für Cloud-Shortcuts) |

Die Einstellungen werden dabei in den normalen `localStorage` gespeichert – die Parameter sind nur der Startimpuls, danach funktioniert alles wie gewohnt.

## 🧩 Mit welchen KI-Servern kann man LocalhorstKI nutzen?

Die Seite funktioniert mit **allem, was die OpenAI-kompatible Chat-API anbietet**. Ein Server-Profil anlegen (URL + ggf. API-Key), Modelle laden, fertig. Die URL kannst du **mit oder ohne `/v1`** eintragen – die App hängt die API-Pfade (`/v1/models`, `/v1/chat/completions`) selbst an.

| Backend | URL / Port | Anmerkung |
|---|---|---|
| **LM Studio** | `http://IP:1234` | Ursprung des Projekts; CORS in den Server-Einstellungen aktivieren |
| **Ollama** | `http://IP:11434/v1` | OpenAI-Kompatibilität ist eingebaut; CORS per Umgebungsvariable `OLLAMA_ORIGINS=*` erlauben |
| **llama.cpp** (`llama-server`) | `http://IP:8080` | OpenAI-kompatibel ab Werk |
| **vLLM** | `http://IP:8000/v1` | vor allem für Server-Betrieb |
| **Jan, llamafile, LM Studio-Alternativen** | jeweiliger Port | gleiche API-Familie, ausprobieren |
| **Mistral API** | `https://api.mistral.ai/v1` + API-Key | ☁️ Cloud – verlässt dein Netzwerk |
| **OpenRouter, Groq, DeepSeek u. a.** | jeweilige API-URL + Key | ☁️ Cloud – ebenfalls OpenAI-kompatibel |

**Ehrliche Einschränkung:** Ob ein Server aus dem Browser erreichbar ist, entscheidet dessen **CORS-Politik**. Lokale Server kontrollierst du selbst (CORS einschalten, fertig). Cloud-APIs können Browser-Zugriffe einschränken – wenn die Verbindung scheitert, liegt es meist daran, nicht an der Seite.

### Use-Case-Szenarien

- **Homelab:** LM Studio auf dem Gaming-PC, LocalhorstKI auf Handy/Laptop/Tablet im WLAN – jede Rückfrage an lokale Modelle ohne Installation.
- **Zweiter Rechner:** Ollama auf dem Homeserver, dieselbe Datei, anderes Server-Profil.
- **Büro-Laptop / Schreibhelfer:** Einmal das Starter-Script anpassen – ab dann per Doppelklick Ollama + Gemma + Schreibhelfer-Vorlage in einem Rutsch.
- **Cloud-Fähre:** Ein Mistral-Profil für Modelle, die lokal zu groß sind – die Seite kennzeichnet das Profil als Cloud, damit der Unterschied immer sichtbar bleibt.
- **Familie/Freunde:** Einmal die Datei aushändigen, URL eintragen – keine Accounts, keine Installation.

## 🔧 Technik

- Reiner Browser-Client (HTML/CSS/JS in einer Datei), spricht `/v1/models` und `/v1/chat/completions` mit SSE-Streaming
- Profil-URLs funktionieren mit oder ohne `/v1`-Endung (die App normalisiert und ergänzt die API-Pfade selbst)
- Einstellungen und Chats liegen im `localStorage` des Browsers – die Datei selbst ändert sich nie

### 🛡️ Security

Unvertrauenswürdige Eingaben (Modellausgaben) werden als HTML gerendert – deshalb gilt ein zweistufiges Vorgehen:

- **Escape-first-Markdown-Renderer**: Modelltext wird vollständig escaped (`<`, `>`, `"`, `&`), **bevor** der eigene Renderer ein whitelist-basiertes Markup ergänzt (nur `p, h2–h4, ul, ol, li, strong, em, code, pre, a, span`). Links nur mit `https?://`-Schema, kein Markdown-Bild-Syntax.
- **Content-Security-Policy** als zweite Verteidigungslinie: `default-src 'none'` mit SHA-256-Hashes für das Inline-Script/-Style (für Ein-Datei-HTML ohne Server-Backend der geeignete Weg). Sollte doch etwas durchrutschen, blockiert der Browser die Ausführung.
- **Kein `eval`, kein `document.write`, kein `outerHTML`/`insertAdjacentHTML`**; Titel, Status und Fehler laufen über `textContent`.
- **Fremdcode: keiner.** Keine Bibliotheken, kein CDN (u. a. deshalb kein DOMPurify – der eigene Renderer + CSP übernehmen das; das hält die Datei single-file und abhängigkeitsfrei).

**Hinweis:** Änderungen am `<script>`- oder `<style>`-Block ändern die CSP-Hashes – sie müssen dann neu berechnet werden (der Browser zeigt den erwarteten Hash in der Konsole, F12).

### Probleme?

| Symptom | Lösung |
|---|---|
| „Nicht erreichbar" trotz laufendem Server | CORS aktivieren (LM Studio: **Enable CORS** · Ollama: `OLLAMA_ORIGINS`) und Server neu starten |
| Nur vom selben PC erreichbar | **Serve on Local Network** aktivieren; Firewall/Portfreigabe prüfen |
| Cloud-Profil meldet Fehler | API-Key korrekt? URL mit `/v1`? Falls es an CORS liegt: Anbieter-Politik, nicht die Seite |
| Kein Modell in der Auswahl | Server erreichbar, aber kein Modell geladen – Modell laden |
| Starter öffnet Seite ohne Einstellungen | Browser verwirft evtl. URL-Parameter bei `file://` – im Script Browser explizit angeben (Windows/macOS, siehe Kommentare) |
| Seite blockiert nach eigener Änderung | CSP-Hashes im `<meta>` neu berechnen (Konsole zeigt den erwarteten Hash) |
| Verläufe weg | Anderer Browser/privater Modus – Verläufe liegen im `localStorage` des jeweiligen Browsers |

## 📄 Über dieses Projekt / KI-Hinweis

Der **gesamte Code dieser Webseite wurde KI-generiert**: entwickelt mit [Vibe](https://chat.mistral.ai) von Mistral AI (Modell: GLM) im Auftrag und unter Review des Repository-Inhabers.

Dabei gilt:

- **Kein Fremdcode**: Die Seite wurde komplett von Grund auf geschrieben. Es wurde kein Code von anderen Projekten oder Webseiten übernommen – es gibt keine Kopien, keine Frameworks, keine externen Bibliotheken und keine CDN-Einbindungen.
- **Nutzungsrechte**: Nach den Nutzungsbedingungen von Mistral AI gehören die Modellausgaben dem Nutzer. Der Inhaber hat den Code geprüft, freigegeben und als eigenes Projekt unter MIT-Lizenz veröffentlicht.
- **Transparenz**: Dieser Hinweis ist bewusst so gesetzt, wie es heute bei KI-unterstützten Projekten üblich und empfehlenswert ist – für Nutzer, Forks und zukünftige Beiträge.

## 📜 Lizenz

[MIT](LICENSE) – Copyright (c) 2026 Michael Malina

Du darfst die Seite frei nutzen, ändern und weitergeben, solange der Copyright-Hinweis erhalten bleibt. 
