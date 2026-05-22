# Git Cheatsheet

## Grundkonfiguration

```bash
git config --global user.name "Dein Name"
git config --global user.email "deine@mail.de"
git config --list
```

## Repository erstellen oder klonen

```bash
git init                    # neues Repository erstellen
git clone URL               # Repository herunterladen
```

## Status und Änderungen

```bash
git status                  # aktuellen Zustand anzeigen
git diff                    # nicht vorgemerkte Änderungen anzeigen
git diff --staged           # vorgemerkte Änderungen anzeigen
```

## Dateien vormerken und committen

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

## Historie anzeigen

```bash
git log                     # Commit-Historie anzeigen
git log --oneline           # kompakte Historie anzeigen
git show COMMIT_ID          # Details zu einem Commit anzeigen
```

## Branches

```bash
git branch                      # Branches anzeigen
git branch neuer-branch         # neuen Branch erstellen
git switch branchname           # Branch wechseln
git switch -c neuer-branch      # neuen Branch erstellen und wechseln
```

Ältere Alternative:

```bash
git checkout branchname
git checkout -b neuer-branch
```

## Branches zusammenführen

```bash
git switch main
git merge feature-branch
```

## Remote-Repositories

```bash
git remote -v               # Remotes anzeigen
git remote add origin URL   # Remote hinzufügen
git push -u origin main     # ersten Push ausführen
git push                    # Änderungen hochladen
git pull                    # Änderungen herunterladen und mergen
git fetch                   # Änderungen nur herunterladen
```

## Änderungen rückgängig machen

```bash
git restore datei.txt              # lokale Änderungen verwerfen
git restore --staged datei.txt     # Datei aus Staging entfernen
git reset --soft HEAD~1            # letzten Commit rückgängig machen, Änderungen behalten
git reset --hard HEAD~1            # letzten Commit komplett entfernen
```

Vorsicht:

```bash
git reset --hard
```

Dieser Befehl löscht lokale Änderungen.

## Stash

```bash
git stash                   # Änderungen parken
git stash list              # geparkte Änderungen anzeigen
git stash pop               # letzten Stash wieder anwenden
```

## Tags

```bash
git tag                     # Tags anzeigen
git tag v1.0.0              # Tag erstellen
git push origin v1.0.0      # Tag hochladen
```

## Häufiger Workflow

```bash
git pull
git switch -c feature-name

# Änderungen machen

git status
git add .
git commit -m "Feature hinzugefügt"
git push -u origin feature-name
```

## Nützliche Aliase

```bash
git config --global alias.st status
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.cm "commit -m"
git config --global alias.lg "log --oneline --graph --all"
```
