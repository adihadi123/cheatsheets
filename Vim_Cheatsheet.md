# Vim Cheatsheet

## Vim starten

```bash
vim datei.txt       # Datei öffnen oder erstellen
vim README.md       # Markdown-Datei öffnen
```

## Modi in Vim

```text
Normal Mode      Befehle ausführen
Insert Mode      Text schreiben
Visual Mode      Text markieren
Command Mode     Speichern, beenden, suchen
```

Wichtige Taste:

```text
Esc               zurück in den Normal Mode
```

## Text einfügen

Im Normal Mode:

```text
i                 vor dem Cursor einfügen
a                 nach dem Cursor einfügen
o                 neue Zeile darunter öffnen
O                 neue Zeile darüber öffnen
```

## Speichern und Beenden

Im Normal Mode zuerst `:` drücken:

```vim
:w                speichern
:q                beenden
:wq               speichern und beenden
:x                speichern und beenden
:q!               beenden ohne speichern
:w datei.txt      unter anderem Namen speichern
```

## Navigation

```text
h                 nach links
j                 nach unten
k                 nach oben
l                 nach rechts

w                 zum nächsten Wort
b                 zum vorherigen Wort
0                 zum Zeilenanfang
$                 zum Zeilenende
gg                zum Dateianfang
G                 zum Dateiende
```

## Löschen

```text
x                 Zeichen löschen
dd                ganze Zeile löschen
dw                Wort löschen
d$                bis Zeilenende löschen
```

## Kopieren und Einfügen

```text
yy                Zeile kopieren
p                 nach dem Cursor einfügen
P                 vor dem Cursor einfügen
```

## Rückgängig machen und Wiederholen

```text
u                 rückgängig machen
Ctrl + r          rückgängig rückgängig machen
.                 letzten Befehl wiederholen
```

## Suchen

```vim
/text             nach text suchen
n                 nächstes Suchergebnis
N                 vorheriges Suchergebnis
```

## Suchen und Ersetzen

```vim
:%s/alt/neu/g             alle Vorkommen in der Datei ersetzen
:%s/alt/neu/gc            alle ersetzen, aber vorher bestätigen
:s/alt/neu/g              nur in aktueller Zeile ersetzen
```

## Zeilen anzeigen

```vim
:set number               Zeilennummern anzeigen
:set nonumber             Zeilennummern ausblenden
```

## Markieren im Visual Mode

```text
v                 Zeichenweise markieren
V                 ganze Zeilen markieren
Ctrl + v          Block markieren
```

Nach dem Markieren:

```text
y                 kopieren
d                 löschen
```

## Praktischer Workflow mit Git und Markdown

```bash
vim README.md
```

In Vim:

```text
i
# Mein Projekt

Kurze Beschreibung.
Esc
:wq
```

Danach im Terminal:

```bash
git status
git add README.md
git commit -m "Update README"
git push
```

## Wichtigste Vim-Befehle

```text
i                 schreiben
Esc               Befehlsmodus
:w                speichern
:q                beenden
:wq               speichern und beenden
:q!               ohne Speichern beenden
dd                Zeile löschen
yy                Zeile kopieren
p                 einfügen
u                 rückgängig
/text             suchen
```
