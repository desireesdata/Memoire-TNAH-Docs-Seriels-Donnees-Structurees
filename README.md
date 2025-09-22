# Les Tables des noms du Sénat aux données structurées : expérimentation et évaluation d’une chaîne de traitement avec des grands modèles de langue

Ce [mémoire](https://github.com/desireesdata/Memoire-TNAH-Docs-Seriels-Donnees-Structurees/blob/main/hub_master.pdf) porte sur la transformation de documents numérisés en données structurées, à partir d’un cas d’étude : les Tables annuelles du Sénat de 1931, publiées dans le Journal Officiel sous la Troisième République. Ces tables, conçues comme instruments d’orientation dans les débats parlementaires, sont ici mobilisées comme terrain d’expérimentation pour tester la capacité des technologies actuelles à rendre les sources sérielles exploitables. Après une première étape de reconnaissance optique de caractères (OCR), qui convertit les images scannées en texte interrogeable, les informations sont extraites grâce aux grands modèles de langage (LLM). Ceux-ci, guidés par des instructions (prompts) et des schémas formels de données, produisent automatiquement des sorties organisées et comparables. L’évaluation de ces résultats repose sur une vérité terrain construite manuellement et sur des méthodes de comparaison adaptées, comme le transport optimal. Cette recherche interroge ainsi les conditions techniques et épistémologiques qui permettent de fonder la confiance dans les corpus numériques issus de la numérisation.

> https://github.com/desireesdata/Memoire-TNAH-Docs-Seriels-Donnees-Structurees/blob/main/hub_master.pdf

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
