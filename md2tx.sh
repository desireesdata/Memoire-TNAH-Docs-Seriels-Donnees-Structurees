#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 fichier.md"
    exit 1
fi

FICHIER="$1"
SORTIE="${FICHIER%.md}.tex"

cp "$FICHIER" "$FICHIER.bak"
cp "$FICHIER" "$SORTIE"

# Titres
sed -i -E 's/^#{1} (.*)/\\chapter{\1}/' "$SORTIE"
sed -i -E 's/^#{2} (.*)/\\section{\1}/' "$SORTIE"
sed -i -E 's/^#{3} (.*)/\\subsection{\1}/' "$SORTIE"
sed -i -E 's/^#{4} (.*)/\\subsubsection{\1}/' "$SORTIE"

# Blockquotes
sed -i -E '/^>/ { s/^> ?/\\begin{quote}/; s/$/\\end{quote}/ }' "$SORTIE"

# "texte" → \enquote{}
sed -i -E 's/"([^"]+)"/\\enquote{\1}/g' "$SORTIE"

# Gras et italique
sed -i -E 's/\*\*([^*]+)\*\*/\\textbf{\1}/g' "$SORTIE"
sed -i -E 's/\*([^*]+)\*/\\emph{\1}/g' "$SORTIE"

# Listes à puces
# Commence par - et remplace par \item
# Ajoute \begin{itemize} avant la première et \end{itemize} après la dernière
awk '
BEGIN { inlist=0 }
/^-/ {
    if (inlist==0) { print "\\begin{itemize}"; inlist=1 }
    sub(/^- /,"\\item ")
    print
    next
}
{
    if (inlist==1) { print "\\end{itemize}"; inlist=0 }
    print
}
END {
    if (inlist==1) print "\\end{itemize}"
}' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"

# Listes numérotées
awk '
BEGIN { inlist=0 }
/^[0-9]+\. / {
    if (inlist==0) { print "\\begin{enumerate}"; inlist=1 }
    sub(/^[0-9]+\. /,"\\item ")
    print
    next
}
{
    if (inlist==1) { print "\\end{enumerate}"; inlist=0 }
    print
}
END {
    if (inlist==1) print "\\end{enumerate}"
}' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"

echo "Conversion terminée : $SORTIE"
echo "Sauvegarde originale : $FICHIER.bak"
