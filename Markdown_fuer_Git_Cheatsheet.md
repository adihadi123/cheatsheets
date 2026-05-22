# Markdown Cheatsheet für Git

## Typische Markdown-Dateien

```text
README.md          # Projektbeschreibung
CONTRIBUTING.md    # Regeln für Mitarbeit
CHANGELOG.md       # Änderungen pro Version
LICENSE.md         # Lizenzinformationen
docs/              # Dokumentationsordner
```

## Überschriften

```md
# Überschrift 1
## Überschrift 2
### Überschrift 3
#### Überschrift 4
```

Typische README-Struktur:

```md
# Projektname

Kurze Beschreibung.

## Installation

## Nutzung

## Features

## Lizenz
```

## Text formatieren

```md
**fett**
*kursiv*
***fett und kursiv***
~~durchgestrichen~~
`Inline-Code`
```

## Listen

```md
- Punkt 1
- Punkt 2
  - Unterpunkt

1. Erster Schritt
2. Zweiter Schritt
3. Dritter Schritt
```

## Checkboxen

```md
- [x] README erstellen
- [x] Git-Repository initialisieren
- [ ] Tests schreiben
- [ ] Deployment vorbereiten
```

## Links

```md
[GitHub](https://github.com)
[Zur Installation](#installation)
[Zur Dokumentation](docs/installation.md)
```

## Bilder

```md
![Beschreibung](pfad/zum/bild.png)
```

Beispiel:

```md
![Screenshot](docs/images/screenshot.png)
```

## Dateien im Repository verlinken

```md
[Installation](docs/installation.md)
[Nutzung](docs/usage.md)
[Changelog](CHANGELOG.md)
[Lizenz](LICENSE.md)
```

## Codeblöcke

Markdown-Code:

````md
```bash
git status
git add .
git commit -m "README aktualisiert"
```
````

Häufige Sprachen für Syntax-Highlighting:

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

## Tabellen

```md
| Befehl | Bedeutung |
|---|---|
| `git status` | Status anzeigen |
| `git add .` | Änderungen vormerken |
| `git commit -m "msg"` | Commit erstellen |
| `git push` | Änderungen hochladen |
```

## Hinweise und Warnungen

```md
> Hinweis: Vor dem Push immer `git status` prüfen.
```

GitHub unterstützt außerdem:

```md
> [!NOTE]
> Allgemeiner Hinweis.

> [!WARNING]
> Vorsicht bei gefährlichen Befehlen.

> [!TIP]
> Praktischer Tipp.
```

## Markdown-Dateien über Terminal erstellen

```bash
touch README.md
touch CHANGELOG.md
mkdir docs
touch docs/installation.md
touch docs/usage.md
```

Dateien bearbeiten:

```bash
nano README.md
vim README.md
code README.md
```

Text per Terminal einfügen:

```bash
echo "# Mein Projekt" > README.md
echo "Kurze Beschreibung." >> README.md
```

```text
>   überschreibt die Datei
>>  hängt Text an die Datei an
```

## README mit Git hinzufügen

```bash
git status
git add README.md
git commit -m "Add README"
git push
```

Mehrere Dokumentationsdateien hinzufügen:

```bash
git add README.md CHANGELOG.md docs/
git commit -m "Add project documentation"
git push
```
