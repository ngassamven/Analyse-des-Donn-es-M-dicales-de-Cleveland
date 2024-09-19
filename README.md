# Analyse-des-Donnees-Medicales-de-Cleveland
Ce projet SAS analyse des données médicales provenant de la base de données de Cleveland. L'objectif est d'explorer les données, réaliser des analyses descriptives, et appliquer des techniques de machine learning pour prédire la présence de maladies cardiaques.
# Introduction
Ce projet utilise les données médicales de la Cleveland Clinic, disponibles sur le site UCI Machine Learning Repository. Le code SAS inclus effectue les tâches suivantes :

# Importation et préparation des données
- Statistiques descriptives
- Représentations graphiques
- Analyses bivariées
- Modélisation de régression logistique pour prédire les maladies cardiaques
# Prérequis
-SAS : Le code est écrit en SAS. Vous devez disposer d'une installation SAS pour exécuter le code.
-Connexion Internet : Nécessaire pour télécharger les données depuis le site UCI.
# Importation et Préparation des Données
Le script SAS importe les données depuis le site UCI, nettoie les valeurs manquantes, recode les variables catégorielles et renomme les variables quantitatives pour plus de clarté.

# Étapes :
- Création de la bibliothèque SAS.
- Téléchargement des données via HTTP.
- Importation des données au format CSV.
- Nettoyage des valeurs manquantes.
- Recodage des variables et réorganisation des colonnes.
- Statistiques Descriptives
Le script calcule les effectifs et pourcentages pour les variables catégorielles ainsi que des statistiques descriptives pour les variables quantitatives.

# Méthodes utilisées :
- **PROC FREQ** pour les variables catégorielles
- **PROC MEANS** pour les variables quantitatives
# Représentations Graphiques
Des graphiques sont générés pour visualiser la distribution des variables :
- Diagrammes à barres pour les variables catégorielles
- Histogrammes pour les variables quantitatives
- Boîtes à moustaches pour les variables quantitatives par catégories
# Analyses Bivariées
Des tests statistiques sont réalisés pour examiner les relations entre variables :
-Test du Khi-Deux pour les variables catégorielles
-Test de Shapiro-Wilk pour la normalité
-Test de Mann-Whitney et Test de Student pour comparer des groupes
# Machine Learning
Un modèle de régression logistique est entraîné pour prédire la présence de maladies cardiaques en utilisant les données d'entraînement. Le modèle est évalué sur une base de test.
**Étapes** :
- Séparation des données en ensembles d'entraînement et de test.
- Entraînement du modèle de régression logistique.
- Évaluation du modèle via une matrice de confusion.
# Contributeurs
**NGASSAM KATE Venceslas Osée**: Auteur du code et de l'analyse
