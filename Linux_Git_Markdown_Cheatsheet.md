# Linux, Git & Markdown Cheatsheet

Ein kompaktes Cheatsheet für die Arbeit im Terminal, mit Git und mit Markdown-Dateien wie `README.md`.

## Inhaltsverzeichnis

- [1. Linux Cheatsheet](#1-linux-cheatsheet)
  - [1.1 Navigation](#11-navigation)
  - [1.2 Dateien und Ordner](#12-dateien-und-ordner)
  - [1.3 Dateien anzeigen und durchsuchen](#13-dateien-anzeigen-und-durchsuchen)
  - [1.4 Rechte und Besitzer](#14-rechte-und-besitzer)
  - [1.5 Prozesse](#15-prozesse)
  - [1.6 Speicher und System](#16-speicher-und-system)
  - [1.7 Pakete installieren](#17-pakete-installieren)
  - [1.8 Netzwerk](#18-netzwerk)
  - [1.9 Weiterleitungen und Pipes](#19-weiterleitungen-und-pipes)
- [2. Git Cheatsheet](#2-git-cheatsheet)
  - [2.1 Grundkonfiguration](#21-grundkonfiguration)
  - [2.2 Repository starten](#22-repository-starten)
  - [2.3 Status und Änderungen](#23-status-und-änderungen)
  - [2.4 Dateien vormerken und committen](#24-dateien-vormerken-und-committen)
  - [2.5 Commit-Historie](#25-commit-historie)
  - [2.6 Branches](#26-branches)
  - [2.7 Branches zusammenführen](#27-branches-zusammenführen)
  - [2.8 Remote-Repositories](#28-remote-repositories)
  - [2.9 Änderungen rückgängig machen](#29-änderungen-rückgängig-machen)
  - [2.10 Stash](#210-stash)
  - [2.11 Häufiger Git-Workflow](#211-häufiger-git-workflow)
- [3. Markdown für Git](#3-markdown-für-git)
  - [3.1 Typische Markdown-Dateien](#31-typische-markdown-dateien)
  - [3.2 Grundstruktur einer README.md](#32-grundstruktur-einer-readmemd)
  - [3.3 Überschriften](#33-überschriften)
  - [3.4 Text formatieren](#34-text-formatieren)
  - [3.5 Listen](#35-listen)
  - [3.6 Checkboxen](#36-checkboxen)
  - [3.7 Links](#37-links)
  - [3.8 Bilder](#38-bilder)
  - [3.9 Dateien im Repository verlinken](#39-dateien-im-repository-verlinken)
  - [3.10 Codeblöcke](#310-codeblöcke)
  - [3.11 Tabellen](#311-tabellen)
  - [3.12 Hinweise und Zitate](#312-hinweise-und-zitate)
  - [3.13 Markdown-Dateien über Terminal erstellen](#313-markdown-dateien-über-terminal-erstellen)
  - [3.14 README mit Git hinzufügen](#314-readme-mit-git-hinzufügen)
- [4. Mini-Projekt: Dokumentation im Repository](#4-mini-projekt-dokumentation-im-repository)
- [5. Merksätze](#5-merksätze)

---

# 1. Linux Cheatsheet

## 1.1 Navigation

```bash
pwd                 # aktuellen Ordner anzeigen
ls                  # Dateien anzeigen
ls -la              # alle Dateien inkl. versteckter Dateien anzeigen
cd ordnername       # in Ordner wechseln
cd ..               # eine Ebene zurück
cd ~                # ins Home-Verzeichnis wechseln
clear               # Terminal leeren
```

## 1.2 Dateien und Ordner

```bash
touch datei.txt             # neue leere Datei erstellen
mkdir ordner                # Ordner erstellen
cp datei.txt kopie.txt      # Datei kopieren
cp -r ordner zielordner     # Ordner kopieren
mv alt.txt neu.txt          # Datei umbenennen oder verschieben
rm datei.txt                # Datei löschen
rm -r ordner                # Ordner löschen
```

Achtung: `rm` löscht Dateien direkt. Es gibt im Terminal normalerweise keinen Papierkorb.

## 1.3 Dateien anzeigen und durchsuchen

```bash
cat datei.txt               # Datei komplett anzeigen
less datei.txt              # Datei seitenweise anzeigen
head datei.txt              # erste Zeilen anzeigen
tail datei.txt              # letzte Zeilen anzeigen
tail -f logdatei.log        # Datei live verfolgen
grep "text" datei.txt       # nach Text suchen
grep -r "text" ordner/      # rekursiv in Ordner suchen
```

## 1.4 Rechte und Besitzer

```bash
chmod +x script.sh          # Datei ausführbar machen
chmod 755 datei             # Rechte setzen
chown user:gruppe datei     # Besitzer ändern
```

Wichtige Rechte:

```text
r = read / lesen
w = write / schreiben
x = execute / ausführen
```

Beispiel:

```bash
chmod 755 script.sh
```

Bedeutung:

```text
Besitzer: lesen, schreiben, ausführen
Gruppe:   lesen, ausführen
Andere:   lesen, ausführen
```

## 1.5 Prozesse

```bash
ps aux                  # laufende Prozesse anzeigen
top                     # Prozesse live anzeigen
htop                    # bessere Prozessansicht, falls installiert
kill PID                # Prozess beenden
kill -9 PID             # Prozess erzwingen beenden
```

## 1.6 Speicher und System

```bash
df -h                   # Speicherplatz der Laufwerke anzeigen
du -sh ordner/          # Größe eines Ordners anzeigen
free -h                 # RAM anzeigen
uname -a                # Systeminfos anzeigen
whoami                  # aktuellen Benutzer anzeigen
```

## 1.7 Pakete installieren

Debian und Ubuntu:

```bash
sudo apt update
sudo apt install paketname
sudo apt remove paketname
```

Fedora:

```bash
sudo dnf install paketname
```

Arch Linux:

```bash
sudo pacman -S paketname
```

## 1.8 Netzwerk

```bash
ping google.com             # Verbindung testen
ip a                        # IP-Adressen anzeigen
curl https://example.com    # Website oder API abrufen
wget URL                    # Datei herunterladen
ssh user@server             # per SSH verbinden
scp datei user@server:/pfad # Datei auf Server kopieren
```

## 1.9 Weiterleitungen und Pipes

```bash
befehl > datei.txt          # Ausgabe in Datei schreiben, Datei wird überschrieben
befehl >> datei.txt         # Ausgabe an Datei anhängen
befehl1 | befehl2           # Ausgabe von Befehl 1 an Befehl 2 weitergeben
grep "error" log.txt | less # Fehler suchen und seitenweise anzeigen
```

---

# 2. Git Cheatsheet

## 2.1 Grundkonfiguration

```bash
git config --global user.name "Dein Name"
git config --global user.email "deine@mail.de"
git config --list
```

## 2.2 Repository starten

```bash
git init                    # neues Git-Repository erstellen
git clone URL               # bestehendes Repository klonen
```

## 2.3 Status und Änderungen

```bash
git status                  # aktuellen Zustand anzeigen
git diff                    # nicht vorgemerkte Änderungen anzeigen
git diff --staged           # vorgemerkte Änderungen anzeigen
```

## 2.4 Dateien vormerken und committen

```bash
git add datei.txt           # eine Datei vormerken
git add .                   # alle Änderungen vormerken
git commit -m "Nachricht"   # Commit erstellen
```

Typischer Ablauf:

```bash
git status
git add .
git commit -m "Beschreibung der Änderung"
```

## 2.5 Commit-Historie

```bash
git log                     # Commit-Verlauf anzeigen
git log --oneline           # kompakte Ansicht
git show COMMIT_ID          # Details zu einem Commit anzeigen
```

## 2.6 Branches

```bash
git branch                   # Branches anzeigen
git branch neuer-branch      # neuen Branch erstellen
git checkout branchname      # Branch wechseln
git checkout -b neuer-branch # erstellen und direkt wechseln
```

Moderne Alternative:

```bash
git switch branchname
git switch -c neuer-branch
```

## 2.7 Branches zusammenführen

```bash
git merge branchname        # Branch in aktuellen Branch mergen
```

Beispiel:

```bash
git switch main
git merge feature-login
```

## 2.8 Remote-Repositories

```bash
git remote -v               # Remotes anzeigen
git remote add origin URL   # Remote hinzufügen
git push -u origin main     # ersten Push ausführen
git push                    # Änderungen hochladen
git pull                    # Änderungen herunterladen und mergen
git fetch                   # Änderungen nur herunterladen
```

## 2.9 Änderungen rückgängig machen

```bash
git restore datei.txt          # nicht vorgemerkte Änderungen verwerfen
git restore --staged datei.txt # Datei aus Staging entfernen
git reset --soft HEAD~1        # letzten Commit rückgängig machen, Änderungen behalten
git reset --hard HEAD~1        # letzten Commit komplett löschen
```

Achtung:

```bash
git reset --hard
```

Dieser Befehl löscht lokale Änderungen unwiderruflich.

## 2.10 Stash

```bash
git stash                   # Änderungen kurz parken
git stash list              # Stashes anzeigen
git stash pop               # letzten Stash wieder anwenden
```

## 2.11 Häufiger Git-Workflow

```bash
git pull
git switch -c feature-name
# Änderungen machen
git status
git add .
git commit -m "Feature hinzugefügt"
git push -u origin feature-name
```

---

# 3. Markdown für Git

## 3.1 Typische Markdown-Dateien

```text
README.md          # Startseite / Projektbeschreibung
CONTRIBUTING.md    # Regeln für Mitarbeit
CHANGELOG.md       # Änderungen pro Version
LICENSE.md         # Lizenzinformationen
docs/              # Dokumentationsordner
```

Eine `README.md` wird auf Plattformen wie GitHub oder GitLab meist automatisch als Projektstartseite angezeigt.

## 3.2 Grundstruktur einer README.md

````md
# Projektname

Kurze Beschreibung des Projekts.

## Installation

```bash
git clone https://github.com/user/projekt.git
cd projekt
npm install
```

## Nutzung

```bash
npm start
```

## Features

- Feature 1
- Feature 2
- Feature 3

## Projektstruktur

```text
projekt/
├── src/
├── docs/
├── README.md
└── package.json
```

## Lizenz

MIT
````

## 3.3 Überschriften

```md
# Überschrift 1
## Überschrift 2
### Überschrift 3
#### Überschrift 4
```

Sinnvolle README-Struktur:

```md
# Projektname
## Installation
## Nutzung
## Beispiele
## Lizenz
```

## 3.4 Text formatieren

```md
**fett**
*kursiv*
***fett und kursiv***
~~durchgestrichen~~
`Inline-Code`
```

## 3.5 Listen

Ungeordnete Liste:

```md
- Punkt 1
- Punkt 2
  - Unterpunkt
  - Unterpunkt
```

Geordnete Liste:

```md
1. Erster Schritt
2. Zweiter Schritt
3. Dritter Schritt
```

## 3.6 Checkboxen

```md
- [x] README erstellen
- [x] Git-Repository initialisieren
- [ ] Tests schreiben
- [ ] Deployment vorbereiten
```

## 3.7 Links

```md
[GitHub](https://github.com)
[Zur Installation](#installation)
[Zur Projektstruktur](#projektstruktur)
```

Bei Überschriften mit Leerzeichen werden in Links meist Bindestriche verwendet:

```md
## Erste Schritte
[Erste Schritte](#erste-schritte)
```

## 3.8 Bilder

```md
![Beschreibung des Bildes](pfad/zum/bild.png)
```

Beispiel:

```md
![Screenshot der App](docs/images/screenshot.png)
```

Empfohlene Struktur:

```text
projekt/
├── README.md
└── docs/
    └── images/
        └── screenshot.png
```

## 3.9 Dateien im Repository verlinken

```md
[Zur Dokumentation](docs/installation.md)
[Zum Changelog](CHANGELOG.md)
[Zur Lizenz](LICENSE.md)
```

Beispiel-Projekt:

```text
projekt/
├── README.md
├── CHANGELOG.md
├── LICENSE.md
└── docs/
    ├── installation.md
    └── usage.md
```

Links in `README.md`:

```md
- [Installation](docs/installation.md)
- [Nutzung](docs/usage.md)
- [Changelog](CHANGELOG.md)
- [Lizenz](LICENSE.md)
```

## 3.10 Codeblöcke

Markdown-Beispiel für einen Codeblock:

````md
```bash
git status
git add .
git commit -m "README aktualisiert"
```
````

Mit Syntax-Highlighting:

````md
```python
print("Hallo Welt")
```
````

Häufige Sprachen für Codeblöcke:

```text
bash
python
javascript
html
css
json
yaml
sql
text
md
```

## 3.11 Tabellen

```md
| Befehl | Bedeutung |
|---|---|
| `git status` | Status anzeigen |
| `git add .` | Änderungen vormerken |
| `git commit -m "msg"` | Commit erstellen |
| `git push` | Änderungen hochladen |
```

Ergebnis:

| Befehl | Bedeutung |
|---|---|
| `git status` | Status anzeigen |
| `git add .` | Änderungen vormerken |
| `git commit -m "msg"` | Commit erstellen |
| `git push` | Änderungen hochladen |

## 3.12 Hinweise und Zitate

```md
> Hinweis: Vor dem Push immer `git status` prüfen.
```

GitHub unterstützt außerdem spezielle Hinweise:

```md
> [!NOTE]
> Allgemeiner Hinweis.

> [!WARNING]
> Vorsicht bei `git reset --hard`.

> [!TIP]
> Nutze `git log --oneline` für eine kompakte Historie.
```

## 3.13 Markdown-Dateien über Terminal erstellen

```bash
touch README.md
touch CHANGELOG.md
mkdir docs
touch docs/installation.md
touch docs/usage.md
```

Dateien öffnen oder bearbeiten:

```bash
nano README.md
code README.md
vim README.md
```

Inhalt schnell einfügen:

```bash
echo "# Mein Projekt" > README.md
echo "Kurze Beschreibung." >> README.md
```

Unterschied:

```text
>   überschreibt die Datei
>>  hängt Text an die Datei an
```

## 3.14 README mit Git hinzufügen

```bash
git status
git add README.md
git commit -m "Add README"
git push
```

Mehrere Markdown-Dateien hinzufügen:

```bash
git add README.md CHANGELOG.md docs/
git commit -m "Add project documentation"
git push
```

---

# 4. Mini-Projekt: Dokumentation im Repository

Dieses Mini-Projekt erstellt eine einfache Dokumentationsstruktur für ein Git-Repository.

## 4.1 Ordner und Dateien erstellen

```bash
mkdir mein-projekt
cd mein-projekt
git init

mkdir docs
mkdir docs/images

touch README.md
touch CHANGELOG.md
touch docs/installation.md
touch docs/usage.md
```

## 4.2 README-Grundgerüst einfügen

```bash
cat > README.md <<'README'
# Mein Projekt

Kurze Beschreibung des Projekts.

## Inhaltsverzeichnis

- [Installation](docs/installation.md)
- [Nutzung](docs/usage.md)
- [Changelog](CHANGELOG.md)

## Features

- Feature 1
- Feature 2
- Feature 3

## Git Workflow

```bash
git status
git add .
git commit -m "Update documentation"
git push
```

## Lizenz

MIT
README
```

## 4.3 Dokumentation committen

```bash
git status
git add README.md CHANGELOG.md docs/
git commit -m "Add project documentation"
```

Wenn ein Remote-Repository existiert:

```bash
git remote add origin URL
git push -u origin main
```

---

# 5. Merksätze

```text
Linux: bewegen, anzeigen, verändern, Rechte setzen.
Git: ändern, adden, committen, pushen.
Markdown: strukturieren, formatieren, verlinken, dokumentieren.
```

Wichtigste Kombination für Dokumentation:

```bash
code README.md
git add README.md
git commit -m "Update README"
git push
```

