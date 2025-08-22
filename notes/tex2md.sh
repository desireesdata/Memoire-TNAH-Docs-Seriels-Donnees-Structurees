#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 fichier.tex"
    exit 1
fi

FICHIER="$1"
SORTIE="${FICHIER%.tex}.md"

cp "$FICHIER" "$FICHIER.bak"
cp "$FICHIER" "$SORTIE"

# Titres
sed -i -E 's/\\chapter\{([^}]*)\}/# \1/' "$SORTIE"
sed -i -E 's/\\section\{([^}]*)\}/## \1/' "$SORTIE"
sed -i -E 's/\\subsection\{([^}]*)\}/### \1/' "$SORTIE"
sed -i -E 's/\\subsubsection\{([^}]*)\}/#### \1/' "$SORTIE"

# Italique et gras
sed -i -E 's/\\textit\{([^}]*)\}/*\1*/g' "$SORTIE"
sed -i -E 's/\\emph\{([^}]*)\}/*\1*/g' "$SORTIE"
sed -i -E 's/\\textbf\{([^}]*)\}/**\1**/g' "$SORTIE"

# Guillemets
sed -i -E 's/\\enquote\{([^}]*)\}/"\1"/g' "$SORTIE"

# Citations LaTeX → blockquote Markdown
sed -i -E 's/\\begin\{quote\}/> /g' "$SORTIE"
sed -i -E 's/\\end\{quote\}//g' "$SORTIE"

# Images
sed -i -E 's/\\includegraphics\[.*\]\{([^}]*)\}/![](\1)/g' "$SORTIE"

# Supprimer les commandes LaTeX courantes qui n'ont pas d'équivalent simple
sed -i -E 's/\\noindent//g' "$SORTIE"
sed -i -E 's/\\makebox\[.*\]\{//g' "$SORTIE"
sed -i -E 's/%}//g' "$SORTIE"
sed -i -E 's/\\epigraph\{[^}]*\}\{[^}]*\}//g' "$SORTIE"

echo "Conversion terminée : $SORTIE"
echo "Sauvegarde originale : $FICHIER.bak"
