

### Un cadre conceptuel pour la cohérence des données : la théorie des faisceaux

Pour évaluer la qualité d'une extraction de données, il ne suffit pas de compter les correspondances exactes ; il faut aussi mesurer la cohérence structurelle du résultat. C'est ici que la théorie des topos de Grothendieck, bien qu'abstraite, offre un puissant cadre conceptuel. Au lieu de voir les données comme un simple ensemble de valeurs, cette théorie les modélise comme une catégorie dont les objets sont les entités (par exemple, un intervenant ou un dossier) et les morphismes sont les relations entre elles.

Dans cet univers formel, nous pouvons définir un faisceau idéal, qui est une attribution de valeurs parfaitement cohérente et sans ambiguïté à chaque entité. Cet idéal est la "vérité" de nos données. En revanche, le résultat de notre extraction est un faisceau bruité, une approximation qui peut comporter des erreurs, des données manquantes ou des incohérences.

L'enjeu de l'évaluation n'est alors plus un simple problème de comptage, mais une question de recollement : dans quelle mesure le faisceau bruité peut-il se "recoller" pour former le faisceau idéal ? La métrique que nous cherchons doit quantifier cette "divergence" ou ce "coût de recollement". Notre méthode, inspirée de cette intuition, vise à mesurer la qualité d'une extraction en calculant la distance entre le faisceau prédit et le faisceau idéal de référence.



Oui, c'est une excellente idée d'ajouter une formulation mathématique pour faire le pont entre la théorie et la méthode concrète. Elle agira comme une passerelle logique vers la section suivante de votre article.

Voici une formulation mathématique qui peut suivre le paragraphe que nous avons rédigé :

### Formulation mathématique du problème

Soit C une catégorie qui modélise la structure de notre document de référence. On définit sur ce site un faisceau idéal FG​ qui associe des données parfaitement cohérentes à chaque objet de C. L'ensemble des données de référence (Ground Truth), G=(g1​,g2​,...,gn​), est l'ensemble des sections (les "valeurs") de ce faisceau.

Le processus d'extraction génère un faisceau bruité FP​, dont les sections sont l'ensemble de données prédit, P=(p1​,p2​,...,pm​). L'objectif de notre évaluation est de quantifier la "distance" entre FG​ et FP​.

La métrique IMQ est construite à partir d'une distance de recollement, d:G×P→[0,1], qui mesure la dissimilitude entre une section de FG​ et une section de FP​. En utilisant le transport optimal, nous trouvons une correspondance π (un appariement) entre G et P qui minimise la "perte de cohérence" totale, c'est-à-dire :

Couˆt de recollement=πmin​i=1∑n​d(gi​,π(gi​))

L'IMQ se présente alors comme une fonction qui transforme ce coût de recollement en un score de qualité, mesurant à quel point le faisceau bruité FP​ se rapproche du faisceau idéal FG​.

La raison pour laquelle on parle de faisceau est qu'il s'agit d'une notion mathématique précise qui capte l'idée que des informations locales doivent se recoller de manière cohérente pour former une information globale.

### L'intuition du faisceau

Le mot français "faisceau" vient du latin *fascis*, qui signifie "paquet" ou "ensemble lié". L'intuition est la même :

- Imaginez que vous ayez une grande carte. Un faisceau sur cette carte est un ensemble de données, par exemple des valeurs de température.

- Chaque petite région de la carte a ses propres valeurs locales de température, qui sont les sections locales du faisceau.

- Si vous avez deux régions qui se chevauchent, le faisceau garantit que les valeurs de température sur le chevauchement sont parfaitement cohérentes.

- C'est la condition de recollement : si vous connaissez toutes les températures locales sur de petites régions, vous pouvez les "recoller" de manière unique pour obtenir une température globale sur l'ensemble de la carte.

### Le faisceau appliqué aux données

Dans votre cas, l'idée de "faisceau" est utilisée pour modéliser la cohérence sémantique et structurelle de vos données.

- Les "régions" de votre "carte" sont les objets de votre catégorie : les dossiers, les pages, les intervenants.

- Les sections locales sont les données que vous attribuez à chaque objet. Par exemple, pour un intervenant, la section locale pourrait être son nom et la liste de pages où il est mentionné.

- La condition de recollement est la règle qui garantit que si le même intervenant apparaît dans deux pages différentes, ses informations sont cohérentes et peuvent être "recollées" pour créer une entrée unique pour l'ensemble du dossier.

Ainsi, parler de faisceau est une manière mathématiquement rigoureuse de dire que l'évaluation des données ne consiste pas à comparer des points isolés, mais à mesurer la qualité du **recollement de l'information à travers une structure hiérarchique**. L'IMQ est une métrique concrète de cette qualité de recollement.
