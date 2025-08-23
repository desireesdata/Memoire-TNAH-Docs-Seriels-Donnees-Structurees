# Mémoire

## Commandes shell & bash

J'écris mes textes en markdown, avec l'éditeur *Marktext*. C'est plus commode pour moi d'écrire avec ce logiciel d'édition avec sa typographie épurée puis de convertir en LaTex avec des Regex.

Voici mes scripts / regex qui convertissent mes .md en .tex :

```bash
./md2tx.sh partie_2/01.md
biber hub_master

```

**Italiques**

```shell
# Remplace les italiques (entre *X*) par \enquote{X}
sed -E 's/\*(.*?)\*/\\textit{\1}/g' chapitre1.md > chapitre1.tex
```

```shell
# Modifie les marques du markdown présentes dans le .tex et fournit une sauvegarde
sed -i.bak -E 's/\*(.*?)\*/\\textit{\1}/g' hub_master.tex
```

```shell
sed -i.bak -E '/^>/ { s/^>/\\begin{quote}/; s/$/\\end{quote}/ }' hub_master.tex
```

**Restaurer sauvegarde**

```
mv fichier.tex.bak fichier.tex
```

**Script bash pour appliquer toutes les modifications**

```bash
#!/bin/bash

# Vérifie si un fichier a été fourni en argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 fichier.tex"
    exit 1
fi

FICHIER=$1

# Crée une sauvegarde du fichier original
cp "$FICHIER" "$FICHIER.bak"

# Applique la première regex : remplace le texte entre étoiles par \enquote{}
sed -i -E 's/\*(.*?)\*/\\enquote{\1}/g' "$FICHIER"

# Applique la deuxième regex : transforme les paragraphes commençant par > en blocs de citation LaTeX
sed -i -E '/^>/ { s/^>/\\begin{quote}/; s/$/\\end{quote}/ }' "$FICHIER"

echo "Transformations appliquées à $FICHIER. Sauvegarde créée sous $FICHIER.bak."
```
