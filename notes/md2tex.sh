#!/bin/bash

# Usage: ./md2tx.sh fichier.md  -> produit fichier.tex
# Requiert GNU awk/sed.

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 fichier.md"
  exit 1
fi

FICHIER="$1"
if [ ! -f "$FICHIER" ]; then
  echo "Fichier introuvable: $FICHIER" >&2
  exit 1
fi

SORTIE="${FICHIER%.md}.tex"

cp "$FICHIER" "$FICHIER.bak"
cp "$FICHIER" "$SORTIE"

############################################
# 1) Blockquotes imbriquées -> quote/encadre
#    - '>' niveau 1 -> quote
#    - '>>' ou '> >' (niveau >=2) -> encadre
#    - garde maths $$...$$, lignes vides, listes à l'intérieur
############################################
awk '
BEGIN { cur=0; inmath=0 }

function open_env(lvl){
  if (lvl==1){ print "\\begin{quote}" }
  else if (lvl>=2){ print "\\begin{encadre}" }
}
function close_env(lvl){
  if (lvl==1){ print "\\end{quote}" }
  else if (lvl>=2){ print "\\end{encadre}" }
}

function starts_math(l){ return (l ~ /^[[:space:]]*\$\$/ || l ~ /^[[:space:]]*\\\[/ || l ~ /^[[:space:]]*\\begin\{equation\*?\}/) }
function ends_math(l){ return (l ~ /\$\$[[:space:]]*$/ || l ~ /\\\][[:space:]]*$/ || l ~ /\\end\{equation\*?\}[[:space:]]*$/) }

{
  # si on est dans un bloc de citation ET dans un bloc math, on laisse tout dedans
  if (cur>0 && inmath==1){
    # retire encore un éventuel préfixe de citations dans les lignes math internes
    m2 = match($0, /^[[:space:]]*((>[[:space:]]*)+)/)
    if (m2){
      line2 = substr($0, RLENGTH+1)
      sub(/^[[:space:]]/, "", line2)
      print line2
    } else {
      print $0
    }
    if (ends_math($0)) inmath=0
    next
  }

  # prefixe de citations: espaces + (">" + espaces) répétés
  m = match($0, /^[[:space:]]*((>[[:space:]]*)+)/)
  if (m){
    prefix = substr($0, 1, RLENGTH)
    tmp = prefix; gsub(/[[:space:]]/, "", tmp)
    lvl = gsub(/>/, "", tmp)   # nombre de >

    if (lvl != cur){
      if (cur>0) close_env(cur)
      cur = lvl
      open_env(cur)
    }

    line = substr($0, RLENGTH+1)
    sub(/^[[:space:]]/, "", line)
    print line
    if (starts_math(line)) inmath=1
    next
  }

  # ligne sans ">" mais on est dans un bloc : cas à tolérer
  if (cur>0){
    if ($0 ~ /^[[:space:]]*$/) { print ""; next }                              # vide
    if ($0 ~ /^[[:space:]]*\\qquad/) { print $0; next }                         # \qquad
    if ($0 ~ /^[[:space:]]*(\$\$|\\\[|\\\(|\\begin\{equation\*?\})/) {          # maths ouvertes
      print $0; if (starts_math($0)) inmath=1; next
    }
    if ($0 ~ /^[[:space:]]*([-*+][[:space:]]|[0-9]+[.)][[:space:]])/) {         # listes
      print $0; next
    }
    # sinon, on ferme le bloc
    close_env(cur); cur=0
  }

  print $0
}
END{
  if (cur>0) close_env(cur)
}
' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"

############################################
# 2) Titres
############################################
sed -i -E 's/^#{1} (.*)/\\chapter{\1}/' "$SORTIE"
sed -i -E 's/^#{2} (.*)/\\section{\1}/' "$SORTIE"
sed -i -E 's/^#{3} (.*)/\\subsection{\1}/' "$SORTIE"
sed -i -E 's/^#{4} (.*)/\\subsubsection{\1}/' "$SORTIE"

############################################
# 3) Guillemets droits -> \enquote{}
############################################
sed -i -E 's/"([^"]+)"/\\enquote{\1}/g' "$SORTIE"

############################################
# 4) Gras / Italique
############################################
sed -i -E 's/\*\*([^*]+)\*\*/\\textbf{\1}/g' "$SORTIE"
sed -i -E 's/\*([^*]+)\*/\\emph{\1}/g' "$SORTIE"

############################################
# 4.1) Liens & URLs
############################################
# [texte](https://...) -> \href{url}{texte}
sed -i -E 's/\[([^\]]+)\]\((https?:\/\/[^)]+)\)/\\href{\2}{\1}/g' "$SORTIE"

# URLs nues -> \url{...}
sed -i -E 's#(^|[^\\{])((https?|ftp)://[^\s\}]+)#\1\\url{\2}#g' "$SORTIE"
# 4.2) Pourcentages en texte : "0 %" -> "0 \%"
sed -i -E 's/([0-9]) %/\1 \\%/g' "$SORTIE"


############################################
# 5) Listes Markdown -> LaTeX (gère lignes vides)
############################################
awk '
BEGIN { in_ul=0; in_ol=0 }
function close_all(){
  if (in_ul){ print "\\end{itemize}"; in_ul=0 }
  if (in_ol){ print "\\end{enumerate}"; in_ol=0 }
}
{
  # puces -, *, +
  if ($0 ~ /^[[:space:]]*[-*+][[:space:]]+/) {
    if (!in_ul){ close_all(); print "\\begin{itemize}"; in_ul=1 }
    sub(/^[[:space:]]*[-*+][[:space:]]+/, "\\item ")
    print
    next
  }
  # numérotées 1. ou 1)
  if ($0 ~ /^[[:space:]]*[0-9]+[.)][[:space:]]+/) {
    if (!in_ol){ close_all(); print "\\begin{enumerate}"; in_ol=1 }
    sub(/^[[:space:]]*[0-9]+[.)][[:space:]]+/, "\\item ")
    print
    next
  }
  # ligne vide à l intérieur d une liste : on la garde
  if (($0 ~ /^[[:space:]]*$/) && (in_ul || in_ol)) { print ""; next }

  # fin de liste
  if (in_ul || in_ol) { close_all() }

  print
}
END { close_all() }
' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"

############################################
# 6.3) Citations Markdown [@clé] -> \footcite[][]{clé}
############################################
sed -i -E 's/\[@([A-Za-z0-9_:-]+)\]/\\footcite[][]{\1}/g' "$SORTIE"


############################################
# 6) Images Markdown -> figure LaTeX
#    - retire le chemin et garde le nom de fichier
#    - ajoute \label{fig:basename}
############################################
# ![alt](path/name.ext)
sed -i -E 's/!\[([^]]*)\]\(([^) ]*\/)?([^) \/]+)(\.[A-Za-z0-9]+)( "[^"]*")?\)/\\begin{figure}[htbp]\n\\centering\n\\includegraphics[width=\\linewidth]{\3\4}\n\\caption{\1}\n\\label{fig:\3}\n\\end{figure}/g' "$SORTIE"

# ![](path/name.ext) -> includegraphics simple
sed -i -E 's/!\[\]\(([^) ]*\/)?([^) \/]+(\.[A-Za-z0-9]+))( "[^"]*")?\)/\\noindent\\includegraphics[width=\\linewidth]{\2}/g' "$SORTIE"

# @nom -> \ref{fig:nom}
sed -i -E 's/@([A-Za-z0-9_-]+)/\\ref{fig:\1}/g' "$SORTIE"



############################################
# 7) Nettoyages / cas Markdown -> LaTeX
############################################
# De-escape des citations numeriques Markdown: \[12] -> [12]
sed -i -E 's/\\\[([0-9]+([[:space:]]*,[[:space:]]*[0-9]+)*)\]/[\1]/g' "$SORTIE"
# Plages \[12-14] -> [12-14]
sed -i -E 's/\\\[([0-9]+[[:space:]]*[-–—][[:space:]]*[0-9]+)\]/[\1]/g' "$SORTIE"

echo "Conversion terminee : $SORTIE"
echo "Sauvegarde originale : $FICHIER.bak"

