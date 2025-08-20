# Des fonds sériels aux données structurées. Application au tables du Sénat

> Evaluation de la sortie structurée via LLM pour l'extraction de données issues de documents sériels

> Orienter la dimension évaluation ? évaluer le potentiel des LLms ? pk pas? 
> 
> Faut-il ancrer ça dans qq chose de concret 
> 
> Des fonds sériels aux données structurées. Application au tables du Sénat
> 
> > LE stables permettaient en fait une meilleure vue d'ensemble (référentiel concret, plutôt que les débats). Expliquer la démarche scientifique autour de ces fonds d'archives "BDD papier", qu'on a envie d'informatiser pour faire recoupement / visualisation etc.
> > 
> > Comment identifier un fonds pertinent, évaluer la fiabilité des données structurées
> 
> L'analyse du fonds/de la publication nourrit la démarche d'ingénierie documentaire.

> Biais diachroniques.

> > Faire dataviz toutà lheure !!

## Introduction

> PROBLEMATIQUE, SOURCES DE DONNES STRCTUREES, COMMENT FAIRE
> POUR LES RENDRE ACCESSIBLES AUX HISTORIENS? EN RETIRER LE PLUS DE 
> MATIERE POSSIBLE? QUELS DEFIS, QUELS CHALLENGE?
> ARCHIVES INSTITUTIONNELLES ==> annuaires biographies, tables, lois et
>  décrets. "VALORISER" DES SOURCES : pas de goût de l'archive? "archives 
> sans goût". Traces pas émouvantes mais importante. Rapport émotionnel ? 
> Sources inexploités ou difficies à transcrire. (Dépouillement sans 
> qualité)
> 
> > Histoire et mesure (dernier numéro) (cumulativité). pour mesure divers choses.
> 
> écrire protocole DANS LE CADRE DE l'HISTOIRE (ARCHIVES 
> INSTITUTIONNELLES). Beaucoup de données structurées, mais regorgent 
> d'information, être capable de les extraire pour les lier avec d'autres 
> sources. (Pour savoir combien de fois un tel à fait ça, etc). La 
> bibliographie de la France; Annuaires; tous ces fonds utiles mais "pas 
> agréables à lire). Domaine des données structurées. Comment en tirer le 
> plus de données pour des histoiriens (notamment) : je ne suis pas 
> conduit par une question fermée, mais comment on fait pour mettre en 
> place un protocole expérimental pour en extrait la moelle.

## **Partie 1 — Des sources sérielles : les tables annuelles du sénat**

> Changement d'échelle pour le traitement des volumétries. Changement quantitatif qualitatif. Sous exploité justqu'à récemmment. Le cas d'usage des tables : Pivot/ colonne vertebrales a une base d'orientation pour cesconnaissances là.

> **Objectif** : Problématiser les corpus visés, leur statut intermédiaire entre archives et documentation, et les raisons de leur faible valorisation. Cette partie est fondée sur une réflexion historienne et archivistique.

### **1.1. Identifier un "fonds sériel"**

- Définition d’un fonds sériel (J.O., annuaires, tables, bulletins, etc.).

- Présentation typologique des documents : structure répétitive, production périodique, contenu hétérogène mais normé.

- Exemple central : *Le Journal Officiel* (cf. billet de blog), entre document administratif et outil de publicité politique.

### **1.2. Des sources sans goût ?**

- Absence d’intérêt immédiat pour l’historien : illisibilité, difficulté à les parcourir, faible charge émotionnelle.

- "Archives sans qualité" : rebut technique ou prolégomènes essentiels ?

- Réflexion sur l’émotion, l’intérêt, la lisibilité dans le travail historien.

### **1.3. L’impensé méthodologique de l’historien face aux documents structurés**

- Contradiction : ces documents sont très riches mais rarement exploités de manière cumulative.

- Rappel de l'enjeu cumulatif en histoire (cf. *Histoire & Mesure*) : comment "compter" les lois, les arrêtés, les présences ?

- Besoin de protocoles expérimentaux pour l'extraction et la structuration.

### **1.4. Hypothèse : requalifier ces sources par la technique ?**

- Ces corpus peuvent devenir lisibles, utiles et même analytiques **si une médiation technique les rend manipulables**.

- L’historien ne s’y désintéresse pas par défaut, mais faute d’outils adaptés.

- Cela implique une forme d’intervention "d'ingénierie documentaire".

---

## **Partie 2  l'enjeu des données structurées (état de l'art puis Pipeline)**

> **Objectif**  comment on formalise les données qu'on va produire; et comment on les produit effectivement. Montrer les différentes approches.Ajouter section "sortie attendue". Prompting trop précis etc.

Approche extractive (BERT) / générative. Zero shot. APproche exploratoire, terrain peu balisé de la sortie structurée. état de l'art input => output. Mise en oeuvre.

> IA et Biblitothèque.

Problématique des VLM (cher et couteux à mettre en place, problème d'ordre de lecture; pourquoi Mistral, etc

Intégrer remarque de Sébastien : évaluer clairement les diff. parties. évaluer la performance de la sortie structurée

> Mistral OCR : problème de fiabilité dans l'ordre de lecture. Chaine de traitement orienté texte, plus maîtrisée. Evaluation transposable. NE terme de production de données, chaine de traitement pour avoir les meilleurs données possibles

Produire un premier jeu de données de référence. Servir de base un benchmark pour la suite. Données publiques.

Quelles options (outillage / chaine de traitement /) pour les données structurées. L'opportunité Corpusense. 

Le modèle a base de décodeur est-il plus pertinent ? 

Corpusense approche pour répondre à ça.

> L'aspect 

### **2.1. Mezanno : origine, cadre, ambitions**

- Projet porté par la BnF et l’EPITA, en lien avec SODUCO, ANTRACT, AGODA.

- Objectif : annotation automatique et extraction de données sur des fonds sériels (J.O., Bulletins, Annuaires...).

- Partenariat entre informaticiens, bibliothécaires et historiens.

### **2.2. Un positionnement clair : simplicité, accessibilité, reproductibilité**

- Refus des solutions propriétaires ou complexes (ex : Transkribus, XML/TEI lourd).

- Utilisation de standards simples (JSON), avec des scripts Python légers.

- Design pensé **pour les historien·ne·s non techniciens**, mais curieux.

### **2.3. Corpusense : un prototype de chaîne légère et critique**

- Fonctionnement général : OCR + LLM + structuration + évaluation.

- L'accent mis sur l'ouverture du pipeline (prompt, modèle, schéma, évaluation).

- Exemple d’application sur le *Journal Officiel* : extraction des lois, acteurs, dates, etc.

### **2.4. Premiers retours : forces et limites**

- Résultats encourageants mais perfectibles.

- Dépendance au prompt et au format d’entrée.

- Place de l’historien : non spectateur passif, mais acteur du protocole.

### **2.5. De la chaîne technique à la démarche historienne**

- L’extraction n’est pas une fin en soi, mais un **moyen de lire autrement les sources**.

- Vers une pratique expérimentale en histoire : ce que cela change de pouvoir structurer soi-même des corpus sériels.

# Partie 3 : évaluer : (idée de confiance)

## Partie 3 — Expérimenter pour comprendre : une démarche historienne outillée

Le choix de ce qu'on mesure est orienté. Indicateur aligné valuations.

Les façons d'évaluer; les systèmes d'évaluation; est-ce que ça marche bien ? Quels éléments mesurables (approche p)

### **Introduction**

Les pages qui précèdent ont permis de mettre en évidence une double tension. D’un côté, les corpus sériels — et notamment les publications officielles telles que le *Journal Officiel* — apparaissent comme des sources précieuses pour une histoire de l’État/ activité parmelmentaire, de l’action administrative ou des régularités politiques. D’un autre côté, leur accès reste partiel : ces documents, massifs, redondants posent de réels défis aux pratiques historiennes classiques. Ils sont disponibles, mais peu lisibles pris dans leur singularité (dans le sens qu'ils appellent le distant reading: d'où l'intérêt d'ailleurs de parler ici d'archives). C’est ce paradoxe — sources structurées mais historiquement opaques — que cette dernière partie propose d’interroger par l’expérimentation.

Peut-on concevoir une chaîne de traitement qui rende ces corpus exploitables sans les soumettre à une normalisation contraignante ou à un traitement en boîte noire ? Autrement dit, peut-on instrumenter l’historien sans l’exclure du protocole ? Quel confiance peut-il donner à l'instrument qu'il manipule ?

L’enjeu n'est pas simplement technique. Il s'agit de répondre à une série de questions critiques : que valent les résultats produits ? Sur quels critères les évaluer ? Que révèlent-ils que la lecture humaine ne permettait pas ? Que masquent-ils au contraire ?

Cette partie se donne pour objectif de documenter, analyser et discuter cette expérimentation. Elle s’inscrit dans une démarche réflexive, héritée à la fois de l’histoire quantitative, des humanités numériques et des études critiques sur les données. Il ne s’agit pas de "mettre en boîte" des sources rétives, mais de construire des instruments d’interprétation compatibles avec les exigences de la méthode historienne : contextualisation, vérifiabilité, sensibilité aux biais, articulation entre cas et structure.

Dans cette perspective, les pages qui suivent sont organisées selon un double mouvement :

- d’abord, un temps descriptif : j’y présente le protocole de traitement, les choix effectués, les scripts mobilisés et les spécificités du corpus (*Journal Officiel*) ;

- ensuite, un temps évaluatif et réflexif : j’examine les résultats, j’en teste la robustesse, j’en interroge les usages possibles — en insistant sur ce que ce type de traitement rend visible, mais aussi sur ce qu’il met en risque.

À terme, il s’agit de défendre une position : l’expérimentation technique n’est pas un contresens méthodologique pour l’histoire, mais une manière rigoureuse de faire émerger des questions inédites, de vérifier des hypothèses sur les corpus, et de reconfigurer notre rapport aux sources.

#### 3.1. Objectifs

La troisième partie de ce mémoire propose une mise à l’épreuve concrète des méthodes précédemment décrites, en s’appuyant sur un cas d’étude ciblé : la **Table nominative du Sénat de 1931**, issue du *Journal Officiel* de la Troisième République. 

Ce travail se situe à l’intersection entre ingénierie documentaire et réflexion historiographique : il vise à outiller l’historien·ne confronté·e à des corpus massifs et peu accessibles, en proposant un cadre de traitement reproductible et évaluable.

L’objectif est double :

1. **Valider empiriquement** la pertinence d’une approche d’extraction structurée guidée par schéma, à partir d’une source numérisée bruitée ;
2. **Évaluer rigoureusement** la qualité des sorties générées par un modèle de langage de grande taille (LLM), à l’aide d’un protocole conçu spécifiquement pour les besoins des historien·ne·s.

#### 3.2. Dissection de la source : les enjeux de la structuration

> A passer dans la partie 1 pour avoir un fil. Poser un germe ! Poser un cahier des charges. L'idée: situer la coméptence historien/archiviste tendu vers l'exploitation technique.

Le document traité, la Table nominative de 1931, constitue un index annuel des interventions sénatoriales. Chaque entrée y associe le nom d’un intervenant (sénateur, ministre, etc.) à une série de numéros de page faisant référence à des interventions publiées dans les *Débats parlementaires*. En tant que source sérielle, cette table est particulièrement propice à une structuration automatique, mais elle n’est pas exempte d’enjeux :

* **Variabilité typographique** (parenthèses, abréviations, lignes éclatées) ;
* **Structure implicite** (relations sémantiques non explicites entre entrées et actions) ;
* **Qualité OCR fluctuante**, avec des distorsions de mise en page, des césures de mots, et des caractères erronés.

Ces caractéristiques impliquent que toute tentative d’extraction automatique doit composer avec un **bruit documentaire** important, tout en conservant une interprétabilité suffisante pour une réutilisation scientifique.

---

#### 3.3. Méthodologie d’extraction guidée

L’approche retenue repose sur une chaîne de traitement en deux étapes :

1. **OCR par lot de pages**, en générant plusieurs versions (dont une version "corrigée", une avec segmentation manuelle, et une brute) à l’aide du moteur PERO ;
2. **Génération structurée via LLM** (Ministral 8B Instruct v2410), en injectant un *prompt* soigneusement formulé et un *schéma JSON* strict pour contraindre la sortie.

Le *prompt* explicite les règles d’extraction, les cas particuliers (références croisées, entrées tronquées) et impose un format uniforme (nom \[prénom], liste d'entiers pour les pages).

Le JSON cible est de forme :

```json
{
  "list_of_speakers": [
    {
      "name": "Desjardins (Charles)",
      "page_references": [563]
    },
    ...
  ]
}
```

Cette structuration permet une interopérabilité avec des outils d’analyse ultérieurs (exploration chronologique, croisement avec d’autres bases, etc.).

---

#### 3.4. Protocole d’évaluation : au-delà de la précision/recall

L’évaluation repose sur un **protocole d’appariement optimal** inspiré des métriques en vision par ordinateur et en extraction d’information.

1. **Distance d’entrée** entre une entrée prédite `p` et une référence `g`, définie comme le produit :
   
   * d’une **distance de nom** (Ratcliff/Obershelp),
   * et d’une **distance d’ensemble de pages** (1 - IoU).

2. **Appariement global** par transport optimal entre les ensembles prédits et de référence.

3. **Score final** : l’IMQ (*Integrated Matching Quality*), un AUC continu qui évalue à la fois la complétude et la justesse des prédictions.

Cette méthode évite les biais introduits par les métriques classiques (précision, rappel) dans des contextes à alignement injectif forcé.

---

#### 3.5. Résultats expérimentaux

Les tests ont été menés sur **5 pages** de la Table nominative, représentant 109 entrées. Chaque page a été traitée indépendamment selon trois variantes d’OCR, pour tester la robustesse à la qualité d’entrée.

| Page | IMQ (OCR brut) | IMQ (corrigé) | Nombre d’entrées |
| ---- | -------------- | ------------- | ---------------- |
| 02   | 0.9059         | 0.9513        | 23               |
| 03   | 0.8928         | 0.9430        | 25               |
| 04   | 0.9591         | 0.9821        | 19               |
| 05   | 0.8636         | 0.8778        | 19               |
| 10   | 0.8193         | 0.8966        | 23               |

Quelques observations :

* L’IMQ reste **élevé (> 0.82)** sur l’ensemble des pages, y compris en OCR brut ;
* Les écarts tiennent aux **variations typographiques**, notamment l’usage ou non des parenthèses autour des prénoms ;
* Le modèle **tolère plutôt bien** le bruit OCR, mais certaines erreurs (entrées fusionnées ou indexées) relèvent de **biais de schéma** ou de prompt, plus que de faiblesse algorithmique.

---

#### 3.6. Discussion : que faire des résultats ?

Cette expérimentation montre que l’approche par LLM + JSON structuré permet une extraction :

* **fiable et généralisable** à des sources similaires (autres années du J.O.) ;
* **documentable et critiquable**, grâce au protocole d’évaluation proposé ;
* **suffisamment performante** pour nourrir des bases de données historiques, tout en laissant la porte ouverte à des corrections manuelles.

Mais des limites demeurent :

* **Sensibilité au prompt** (notamment aux instructions de format) ;
* **Ambiguïtés sémantiques** difficilement résolues sans contexte institutionnel ;
* **Non-neutralité des choix de schéma**, qui influe sur la modélisation des données (cf. regroupement de fonctions, cf. nom/prénom).

---

#### 3.7. Contributions et perspectives

Ce cas d’étude a permis de formaliser une méthode d’évaluation rigoureuse pour la structuration de données historiques via LLMs. Les contributions principales de ce travail sont :

* Un **cadre de traitement reproductible** pour l’extraction de données sérielles ;
* Une **méthodologie d’évaluation** adaptée à des formats structurés partiels ;
* Une **vérité terrain annotée** et publiée comme ressource de référence ;
* Une **première intégration dans l’outil Corpusense**, en cours de développement.

Les perspectives ouvertes incluent :

* L’extension à **d’autres tables** du J.O., notamment celles de la Chambre ;
* L’automatisation partielle de l’**optimisation du prompt** ;
* L’étude de **prompts génératifs** ou adaptatifs selon la qualité des documents ;
* La réflexion sur la **place de la structuration dans la chaîne de production historique**, en tant que moment interprétatif à part entière.

> Première passe de détail à valider d'ici demain.

Commençons par une image. Ramon Llull, dans son *Ars Magna*, proposait un système combinatoire fondé sur des disques concentriques mobiles de papier pour générer mécaniquement des questions et des réponses. Ces roues, organisées en cercles imbriqués, permettaient d'associer des concepts symbolisés par des lettres afin de couvrir l'ensemble des champs du savoir. L'objectif était de créer une méthode universelle de raisonnement et de démonstration, basée sur des questions et des réponses, combinant logique, théologie et philosophie. Si cette entreprise n'a aujourd'hui certes pas grande valeur scientifique, elle permet d'imager un travail : celui de la calculabilité d'entités conceptuelles par une traduction symbolique et relationnelle. Il a supposé que le travail intellectuel sur les mots et les choses reposait sur leur calculabilité, laquelle exige une réduction algébrique. Voici donc une métaphore de la mise en données : c'est une *stratégie épistémique* basée sur une modélisation synthétique des phénomènes ou des idées [Lorraine Daston].

Sans prétendre dessiner une histoire en pente douce qui commencerait à Ramon Llull pour aboutir aux ordinateurs modernes -- il serait couteux de postuler que l'*Ars Magna* lullien releverait de la même historicité des machines modernes -- , on veut ici illustrer la notion de *datafication*.

___

# Données et FAIRness : de la valuation et de l'évaluation

La dimension "personnelle" des données, la FAIRNESS ==> implique d'expliciter la "sitaution" des données, de leurs valuations et de leur qualité (évaluation. Nécessité d'évaluer. 

« Most literary scholars would no more simply use the “results” *of a fellow scholar than they would use her toothbrush* » (Responses to Moretti, p. 4). 5
