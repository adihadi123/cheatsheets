# Linux Cheatsheet

## Navigation

```bash
pwd                 # aktuellen Ordner anzeigen
ls                  # Dateien anzeigen
ls -la              # alle Dateien inkl. versteckter anzeigen
cd ordnername       # in Ordner wechseln
cd ..               # eine Ebene zurück
cd ~                # ins Home-Verzeichnis wechseln
clear               # Terminal leeren
```

## Dateien und Ordner

```bash
touch datei.txt             # neue leere Datei erstellen
mkdir ordner                # Ordner erstellen
mkdir -p ordner/unterordner # mehrere Ebenen erstellen
cp datei.txt kopie.txt      # Datei kopieren
cp -r ordner zielordner     # Ordner kopieren
mv alt.txt neu.txt          # Datei umbenennen
mv datei.txt ordner/        # Datei verschieben
rm datei.txt                # Datei löschen
rm -r ordner                # Ordner löschen
```

## Dateien anzeigen

```bash
cat datei.txt               # komplette Datei anzeigen
less datei.txt              # Datei seitenweise anzeigen
head datei.txt              # erste Zeilen anzeigen
tail datei.txt              # letzte Zeilen anzeigen
tail -f logdatei.log        # Datei live verfolgen
```

## Suchen

```bash
grep "text" datei.txt       # Text in Datei suchen
grep -r "text" ordner/      # Text rekursiv in Ordner suchen
find . -name "*.txt"        # Dateien nach Namen suchen
find . -type d              # Ordner suchen
find . -type f              # Dateien suchen
```

## Rechte

```bash
chmod +x script.sh          # Datei ausführbar machen
chmod 755 script.sh         # Rechte setzen
chown user:gruppe datei     # Besitzer ändern
```

```text
r = read / lesen
w = write / schreiben
x = execute / ausführen
```

## Prozesse

```bash
ps aux              # laufende Prozesse anzeigen
top                 # Prozesse live anzeigen
htop                # bessere Prozessansicht, falls installiert
kill PID            # Prozess beenden
kill -9 PID         # Prozess sofort beenden
```

## Speicher und System

```bash
df -h               # Speicherplatz anzeigen
du -sh ordner/      # Größe eines Ordners anzeigen
free -h             # RAM anzeigen
uname -a            # Systeminfos anzeigen
whoami              # aktuellen Benutzer anzeigen
date                # Datum und Uhrzeit anzeigen
```

## Paketverwaltung

Debian / Ubuntu:

```bash
sudo apt update
sudo apt install paketname
sudo apt remove paketname
```

Fedora:

```bash
sudo dnf install paketname
sudo dnf remove paketname
```

Arch:

```bash
sudo pacman -S paketname
sudo pacman -R paketname
```

## Netzwerk

```bash
ping example.com                # Verbindung testen
ip a                            # IP-Adressen anzeigen
curl https://example.com        # Website oder API abrufen
wget URL                        # Datei herunterladen
ssh user@server                 # SSH-Verbindung starten
scp datei user@server:/pfad     # Datei auf Server kopieren
```

## Ausgabe weiterleiten

```bash
befehl > datei.txt              # Ausgabe in Datei schreiben
befehl >> datei.txt             # Ausgabe an Datei anhängen
befehl1 | befehl2               # Ausgabe weiterleiten
grep "error" log.txt | less     # Fehler suchen und anzeigen
```
