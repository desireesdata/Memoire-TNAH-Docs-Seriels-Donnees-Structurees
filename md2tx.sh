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
# 1) Blockquotes imbriquees -> quote/encadre
#    - '>' niveau 1 -> quote
#    - '>>' ou '> >' (niveau >=2) -> encadre
#    - garde maths $$...$$, lignes vides, listes a l'interieur
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
    # retire encore un eventuel prefixe de citations dans les lignes math internes
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

  # prefixe de citations: espaces + (">" + espaces) repetes
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

  # ligne sans ">" mais on est dans un bloc : cas a tolerer
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
# 5) Listes Markdown -> LaTeX (gere lignes vides)
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
  # numerotees 1. ou 1)
  if ($0 ~ /^[[:space:]]*[0-9]+[.)][[:space:]]+/) {
    if (!in_ol){ close_all(); print "\\begin{enumerate}"; in_ol=1 }
    sub(/^[[:space:]]*[0-9]+[.)][[:space:]]+/, "\\item ")
    print
    next
  }
  # ligne vide a l interieur d une liste : on la garde
  if (($0 ~ /^[[:space:]]*$/) && (in_ul || in_ol)) { print ""; next }
  # fin de liste
  if (in_ul || in_ol) { close_all() }
  print
}
END { close_all() }
' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"

############################################
# 6) Images Markdown -> figure LaTeX
#    - retire le chemin et garde le nom de fichier
#    - ajoute \label{fig:basename}
############################################
# ![alt](path/name.ext)
sed -i -E 's/!\[([^]]*)\]\(([^) ]*\/)?([^) \/]+)(\.[A-Za-z0-9]+)( "[^"]*")?\)/\\begin{figure}[htbp]\n\\centering\n\\includegraphics[width=\\linewidth]{\3\4}\n\\caption{\1}\n\\label{fig:\3}\n\\end{figure}/g' "$SORTIE"
# ![](path/name.ext) -> includegraphics simple
sed -i -E 's/!\[\]\(([^) ]*\/)?([^) \/]+(\.[A-Za-z0-9]+))( "[^"]*")?\)/\\noindent\\includegraphics[width=\\linewidth]{\2}/g' "$SORTIE"

############################################
# 6.3) Citations Markdown -> \footcite (biblatex)
#   [@key]                 -> \footcite[][]{key}
#   [@key, note]          -> \footcite[][note]{key}
#   [text @key]           -> \footcite[text][]{key}
#   [text @key, note]     -> \footcite[text][note]{key}
############################################
############################################
# Citations Markdown -> \footcite (biblatex)
#   [@key]                 -> \footcite[][]{key}
#   [@key, note]          -> \footcite[][note]{key}
#   [text @key]           -> \footcite[text][]{key}
#   [text @key, note]     -> \footcite[text][note]{key}
############################################
# [texte @cle, note] -> \footcite[texte][note]{cle}
# [texte @cle, note] -> \footcite[texte][note]{cle}
sed -i -E 's#\[([^@\]]*)[[:space:]]*@[[:space:]]*([A-Za-z0-9_.:-]+)[[:space:]]*,[[:space:]]*([^]]+)\]#\\footcite[\1][\3]{\2}#g' "$SORTIE"

# [@cle, note] -> \footcite[][note]{cle}
sed -i -E 's#\[@[[:space:]]*([A-Za-z0-9_.:-]+)[[:space:]]*,[[:space:]]*([^]]+)\]#\\footcite[][\2]{\1}#g' "$SORTIE"

# [texte @cle] -> \footcite[texte][]{cle}
sed -i -E 's#\[([^@\]]*)[[:space:]]*@[[:space:]]*([A-Za-z0-9_.:-]+)\]#\\footcite[\1][]{\2}#g' "$SORTIE"

# [@cle] -> \footcite[][]{cle}
sed -i -E 's#\[@[[:space:]]*([A-Za-z0-9_.:-]+)\]#\\footcite[][]{\1}#g' "$SORTIE"

############################################
# 6.4) References de figures: @nom hors crochets -> \ref{fig:nom}
############################################
############################################
# @nom -> \ref{fig:nom} (hors crochets seulement)
############################################
############################################
# 6.4) Références de figures: @nom hors crochets -> \ref{fig:nom}
# (version POSIX awk, sans gensub)
############################################
awk '
{
  s = $0
  out = ""
  depth = 0
  i = 1
  L = length(s)
  while (i <= L) {
    c = substr(s, i, 1)

    # suivi du niveau de crochets [...]
    if (c == "[") { depth++ ; out = out c ; i++ ; continue }
    if (c == "]" && depth > 0) { depth-- ; out = out c ; i++ ; continue }

    # si hors crochets et on voit un @, tente de capturer la clé
    if (depth == 0 && c == "@") {
      j = i + 1
      key = ""
      while (j <= L) {
        ch = substr(s, j, 1)
        if (ch ~ /[A-Za-z0-9_-]/) { key = key ch ; j++ } else { break }
      }
      if (length(key) > 0) {
        out = out "\\ref{fig:" key "}"
        i = j
        continue
      }
      # sinon, pas une clé: on laisse le @ tel quel
    }

    out = out c
    i++
  }
  print out
}
' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"


############################################
# 6.5) Maths inline ecrites comme \$...\$ et indices \_
############################################
# \$...$ -> $...$
sed -i -E 's/\\\$(.*?)\\\$/\$\1\$/g' "$SORTIE"
# Dans les segments math $...$, convertir \_ -> _ uniquement a l interieur
awk '{
  out=""; 
  n = split($0, a, /\$/);
  for (i=1; i<=n; i++){
    seg = a[i];
    if (i % 2 == 0) { gsub(/\\_/, "_", seg) }  # pairs = dans $...$
    out = out seg;
    if (i < n) out = out "$";
  }
  print out;
}' "$SORTIE" > "${SORTIE}.tmp" && mv "${SORTIE}.tmp" "$SORTIE"

############################################
# 7) Nettoyages / cas Markdown -> LaTeX
############################################
# De-escape des citations numeriques Markdown: \[12] -> [12]
sed -i -E 's/\\\[([0-9]+([[:space:]]*,[[:space:]]*[0-9]+)*)\]/[\1]/g' "$SORTIE"
# Plages \[12-14] -> [12-14]
sed -i -E 's/\\\[([0-9]+[[:space:]]*[-–—][[:space:]]*[0-9]+)\]/[\1]/g' "$SORTIE"

echo "Conversion terminee : $SORTIE"
echo "Sauvegarde originale : $FICHIER.bak"