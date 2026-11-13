# LM Studio Chat – Lokal & im Netzwerk

Eine **einzige HTML-Datei**, die man direkt im Browser öffnet, um mit Modellen aus [LM Studio](https://lmstudio.ai/) zu chatten – auf demselben Rechner oder von jedem Gerät im Heimnetzwerk. Kein Server, kein Build-Prozess, keine externen Abhängigkeiten, kein CDN. Einfach herunterladen, öffnen, loschatten.

> **Datenschutz:** Alle Anfragen gehen direkt vom Browser an deinen LM-Studio-Server – nichts verlässt dein Netzwerk.

## ✨ Features

- 🎛️ **Modell-Auswahl per Dropdown** – die Modelle werden live vom Server geladen (`/v1/models`)
- 🌊 **Live-Streaming** der Antworten, jederzeit stoppbar
- 📊 **Statistiken** pro Antwort: Token-Anzahl, Tokens/Sekunde, Dauer
- ⚙️ **Modell-Parameter**: Temperature, Top-P, Top-K, Seed, Max. Tokens, System-Prompt (mit Vorlagen)
- 🖥️ **Server-Profile** – mehrere LM-Studio-Rechner speichern und per Dropdown wechseln
- 🖼️ **Bild-Upload für Vision-Modelle** – per 📎-Button, Strg+V (Screenshot) oder Drag & Drop
- 🗂️ **Chat-Verläufe** – mehrere Konversationen, gespeichert im Browser (localStorage)
- 📋 **Kopieren** (ganze Antwort oder einzelne Codeblöcke), **Neu generieren**, **Bearbeiten**
- ⬇️ Chat als **Markdown** oder **JSON** exportieren
- 🌙/☀️ **Dark/Light-Theme**, Avatare, Zeitstempel, „denkt nach…"-Indikator, optionaler Fertigstellungs-Sound
- 🛡️ **Security**: siehe unten
- 📱 Responsive – funktioniert auch auf dem Handy im WLAN

## 🚀 Schnellstart

### 1. LM Studio vorbereiten

1. LM Studio öffnen → Tab **Developer**
2. Ein Modell laden
3. **Start Server** klicken
4. In den **Server-Einstellungen** aktivieren:
   - ✅ **Serve on Local Network** (damit andere Geräte im Netz den Server erreichen)
   - ✅ **Enable CORS** (damit die Webseite vom Browser aus auf den Server zugreifen darf – ohne das kommt nur „nicht erreichbar")

Standard-Port: `1234`. Die Adresse deines Servers findest du in LM Studio (z. B. `http://192.168.178.114:1234`).

### 2. Webseite öffnen

1. [`index.html`](index.html) herunterladen
2. Datei per Doppelklick im Browser öffnen
3. Links die Server-URL eintragen → **↻** klicken → Modell auswählen
4. Chatten! **Enter** = senden, **Shift+Enter** = neue Zeile

## 🔧 Technik & Voraussetzungen

- LM Studio mit aktiviertem lokalen Server (OpenAI-kompatible API: `/v1/models`, `/v1/chat/completions`)
- Die Seite spricht den Server über dessen **OpenAI-kompatible Endpunkte** an – funktioniert daher grundsätzlich auch mit anderen OpenAI-kompatiblen Servern im Netzwerk (z. B. llama.cpp, Ollama), sofern CORS aktiviert ist
- Alles läuft im Browser: Einstellungen und Chats liegen im `localStorage` des Browsers

### 🛡️ Security

Unvertrauenswürdige Eingaben (Modellausgaben) werden als HTML gerendert – deshalb gilt ein zweistufiges Vorgehen:

- **Escape-first-Markdown-Renderer**: Modelltext wird vollständig escaped (`<`, `>`, `"`, `&`), **bevor** der eigene Renderer ein whitelist-basiertes Markup ergänzt (nur `p, h2–h4, ul, ol, li, strong, em, code, pre, a, span`). Links nur mit `https?://`-Schema, kein Markdown-Bild-Syntax.
- **Content-Security-Policy** als zweite Verteidigungslinie: `default-src 'none'` mit SHA-256-Hashes für das Inline-Script/-Style (für Ein-Datei-HTML ohne Server-Backend der geeignete Weg). Sollte doch etwas durchrutschen, blockiert der Browser die Ausführung.
- **Kein `eval`, kein `document.write`, kein `outerHTML`/`insertAdjacentHTML`**; Titel, Status und Fehler laufen über `textContent`.
- **Fremdcode: keiner.** Keine Bibliotheken, kein CDN (u. a. deshalb kein DOMPurify – der eigene Renderer + CSP übernehmen das; das hält die Datei single-file und abhängigkeitsfrei).

**Hinweis:** Änderungen am `<script>`- oder `<style>`-Block ändern die CSP-Hashes – sie müssen dann neu berechnet werden (siehe Commit-Historie bzw. `openssl`/`sha256` über den Block-Inhalt).

### Probleme?

| Symptom | Lösung |
|---|---|
| „Nicht erreichbar" trotz laufendem Server | In LM Studio **Enable CORS** aktivieren und Server neu starten |
| Nur vom selben PC erreichbar | **Serve on Local Network** aktivieren; Firewall/Portfreigabe prüfen |
| Kein Modell in der Auswahl | Server ist erreichbar, aber es ist kein Modell geladen – Modell in LM Studio laden |
| Verläufe weg | Andere Browser-Instanz/privater Modus – Verläufe liegen im `localStorage` des jeweiligen Browsers |

## 📄 Über dieses Projekt / KI-Hinweis

Der **gesamte Code dieser Webseite wurde KI-generiert**: entwickelt mit [Vibe](https://chat.mistral.ai) von Mistral AI (Modell: GLM) im Auftrag und unter Review des Repository-Inhabers.

Dabei gilt:

- **Kein Fremdcode**: Die Seite wurde komplett von Grund auf geschrieben. Es wurde kein Code von anderen Projekten oder Webseiten übernommen – es gibt keine Kopien, keine Frameworks, keine externen Bibliotheken und keine CDN-Einbindungen.
- **Nutzungsrechte**: Nach den Nutzungsbedingungen von Mistral AI gehören die Modellausgaben dem Nutzer. Der Inhaber hat den Code geprüft, freigegeben und als eigenes Projekt unter MIT-Lizenz veröffentlicht.
- **Transparenz**: Dieser Hinweis ist bewusst so gesetzt, wie es heute bei KI-unterstützten Projekten üblich und empfehlenswert ist – für Nutzer, Forks und zukünftige Beiträge.

## 📜 Lizenz

[MIT](LICENSE) – Copyright (c) 2026 Michael Malina

Du darfst die Seite frei nutzen, ändern und weitergeben, solange der Copyright-Hinweis erhalten bleibt. 
