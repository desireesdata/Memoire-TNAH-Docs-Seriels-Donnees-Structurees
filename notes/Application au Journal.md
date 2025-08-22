#### Application au *Journal Officiel*

Dans le cas des *Tables nominatives* du Sénat, une approche extractive basée sur BERT pourrait, en théorie, permettre de repérer automatiquement :

- les **noms de sénateurs** (entités personnes),
- les **objets des interventions** (thèmes ou intitulés),
- les **références paginées** (entités numériques).

Un modèle entraîné sur des annotations manuelles tirées d’un sous-ensemble des tables pourrait apprendre à reconnaître ces structures dans l’ensemble du corpus. L’avantage serait une extraction relativement robuste face aux variations de mise en page ou aux erreurs d’OCR. Toutefois, le coût de constitution d’un corpus annoté suffisamment large reste un obstacle majeur. C’est ce qui explique l’intérêt croissant pour les approches génératives, qui cherchent à s’affranchir de ce verrou en exploitant les capacités des grands modèles de langage.

L'approche du surlignage 1 to 1.

**Principe** : le modèle apprend à repérer les entités dans un texte via des annotations.

- **Modèles supervisés classiques** : CRF, SVM, MaxEnt
  
- **Neuraux séquentiels** : BiLSTM-CRF, CNN-LSTM
  
- **Transformers extractifs** : BERT, RoBERTa, CamemBERT en mode NER  
  => Avantage : généralise mieux, bonne précision  
  => Limite : nécessite des données annotées et un entraînement
