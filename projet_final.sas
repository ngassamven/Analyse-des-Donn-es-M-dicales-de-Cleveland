/************************************* IMPORTATION ET PRÉPARATION DES DONNÉES *************************************/

/* Création d'une bibliothèque */
/* ATTENTION : Remplacer le "VotreIdentifiantSAS" par votre identifiant utilisateur SAS (il est indiqué en bas à droite de la page) */
LIBNAME projet "/home/VotreIdentifiantSAS/Projet";

/* Requête HTTP pour récupérer les données depuis le site (UCI Machine Learning) */
FILENAME donnees TEMP;
PROC HTTP URL = "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
	METHOD = "GET"
	OUT = donnees;
RUN;

/* Importation des données */
PROC IMPORT FILE = donnees DBMS = CSV OUT = projet.donnees REPLACE;
	GUESSINGROWS=MAX;
	GETNAMES = NO;
RUN;

/* Supprimer les valeurs manquantes */
DATA projet.donnees;
SET projet.donnees;
IF VAR12 = "?" OR VAR13 = "?" THEN DELETE;
RUN;

/* Recodage des variables catégorielles */
DATA projet.donnees;
SET projet.donnees;
LENGTH Sexe $6. Angine $32. Glycemie $32. ECG $32. AngineApresSport $3. PenteECG $16. Fluoroscopie $32. Thalassemie $32. Maladie $3.;
IF VAR2 = 1 THEN Sexe = "Homme";
IF VAR2 = 0 THEN Sexe = "Femme";
IF VAR3 = 1 THEN Angine = "Angine stable";
IF VAR3 = 2 THEN Angine = "Angine instable";
IF VAR3 = 3 THEN Angine = "Douleur non angineuse";
IF VAR3 = 4 THEN Angine = "Asymptomatique";
IF VAR6 = 1 THEN Glycemie = "Glycémie > 120mg/dl";
IF VAR6 = 0 THEN Glycemie = "Glycémie < 120mg/dl";
IF VAR7 = 0 THEN ECG = "Normal";
IF VAR7 = 1 THEN ECG = "Anomalies";
IF VAR7 = 2 THEN ECG = "Hypertrophie";
IF VAR9 = 0 THEN AngineApresSport = "Non";
IF VAR9 = 1 THEN AngineApresSport = "Oui";
IF VAR11 = 1 THEN PenteECG = "En hausse";
IF VAR11 = 2 THEN PenteECG = "Stable";
IF VAR11 = 3 THEN PenteECG = "En baisse";
IF VAR12 = 0 THEN Fluoroscopie = "Absence d'anomalie";
IF VAR12 = 1 THEN Fluoroscopie = "Faible";
IF VAR12 = 2 THEN Fluoroscopie = "Moyen";
IF VAR12 = 3 THEN Fluoroscopie = "Élevé";
IF VAR13 = 3 THEN Thalassemie = "Absence d'anomalie";
IF VAR13 = 6 THEN Thalassemie = "Thalassémie sous contrôle";
IF VAR13 = 7 THEN Thalassemie = "Thalassémie instable";
IF VAR14 = 0 THEN Maladie = "Non";
IF VAR14 = 1 THEN Maladie = "Oui";
IF VAR14 = 2 THEN Maladie = "Oui";
IF VAR14 = 3 THEN Maladie = "Oui";
IF VAR14 = 4 THEN Maladie = "Oui";
DROP VAR2 VAR3 VAR6 VAR7 VAR9 VAR11 VAR12 VAR13 VAR14;
RUN;

/* Renommer les variables quantitatives */
DATA projet.donnees;
SET projet.donnees(rename = (
VAR1 = Age
VAR4 = Tension
VAR5 = Cholesterol
VAR8 = FreqCardiaque
VAR10 = AngineECG));
RUN;

/* Réordonner les variables */
DATA projet.donnees;
RETAIN Age Sexe Angine Tension Cholesterol Glycemie ECG FreqCardiaque AngineApresSport AngineECG PenteECG Fluoroscopie Thalassemie Maladie;
SET projet.donnees;
RUN;

/* Affichage du tableau de données */
PROC PRINT DATA = projet.donnees;
RUN;

/************************************* STATISTIQUES DESCRIPTIVES *************************************/

/* Calcul des effectifs et des pourcentages pour les variables catégorielles*/
%MACRO effectifs_pourcentages(variable);
PROC FREQ DATA = projet.donnees;
TITLE "Tableau d'effectifs et de pourcentages de la variable &variable";
TABLE &variable / NOCUM;
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%effectifs_pourcentages(Maladie);
%effectifs_pourcentages(Sexe);
%effectifs_pourcentages(Angine);

/* Calcul de statistiques descriptives pour les variables quantitatives */
%MACRO stats_variables_quantitatives(variable_quantitative);
PROC MEANS DATA = projet.donnees N MEAN STD MIN Q1 MEDIAN Q3 MAX MAXDEC = 2;
TITLE "Statistiques descriptives de la variable &variable_quantitative";
VAR &variable_quantitative;
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%stats_variables_quantitatives(Age);
%stats_variables_quantitatives(Tension);
%stats_variables_quantitatives(Cholesterol);

/************************************* REPRÉSENTATIONS GRAPHIQUES *************************************/

/* Macro pour créer un diagramme à barres (variables catégorielles) */
%MACRO diagramme_barres(variable, couleur);
PROC SGPLOT DATA = projet.donnees;
VBAR &variable / DATALABEL FILLATTRS=(COLOR=&couleur) OUTLINEATTRS=(COLOR="black") CATEGORYORDER=respasc;
TITLE "Répartition des patients de la population selon la variable &variable";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
YAXIS LABEL = "Effectifs";
RUN;
%MEND;

/* Application de la macro */
%diagramme_barres(Maladie, "bigb");
%diagramme_barres(Sexe, "pink");
%diagramme_barres(Angine, "VIPK");

/* Macro pour créer un histogramme (variables quantitatives) */
%MACRO histogramme(variable, valeur_binstart, valeur_binwidth, couleur);
PROC SGPLOT DATA = projet.donnees;
HISTOGRAM &variable / SCALE = count DATALABEL = count BINSTART = &valeur_binstart BINWIDTH = &valeur_binwidth SHOWBINS FILLATTRS=(COLOR=&couleur);
/*
DENSITY &variable;
DENSITY &variable / TYPE = kernel;
KEYLEGEND / LOCATION = inside POSITION = topright ACROSS = 1 NOBORDER LINELENGTH = 20;
*/
TITLE "Répartition des patients de la population selon la variable &variable";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
YAXIS LABEL = "Effectifs";
RUN;
%MEND;

/* Application de la macro */
%histogramme(Age, 20, 5, "vlibg");
%histogramme(Tension, 80, 10, "pink");
%histogramme(Cholesterol, 100, 25, "lioy");

/* Macro pour créer un diagramme à barres bivarié (variables catégorielles) */
%MACRO diagramme_barres_bivarie(variable_interet, variable_explicative);
PROC SGPLOT DATA = projet.donnees;
VBAR &variable_explicative / GROUP = &variable_interet DATALABEL GROUPDISPLAY=cluster;
TITLE "Répartition des patients de la population selon la variable &variable_explicative et la variable &variable_interet";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
YAXIS LABEL = "Effectifs";
RUN;
%MEND;

/* Application de la macro */
%diagramme_barres_bivarie(Maladie, Sexe);
%diagramme_barres_bivarie(Maladie, Angine);
%diagramme_barres_bivarie(Maladie, Glycemie);

/* Macro pour créer une boîte à moustaches (variables quantitative/catégorielle) */
%MACRO boxplot(variable_interet, variable_explicative);
PROC SGPLOT DATA = projet.donnees;
VBOX &variable_explicative / CATEGORY=&variable_interet GROUP=&variable_interet;
TITLE "Boîtes à moustaches des patients selon la variable &variable_explicative et la variable &variable_interet";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
KEYLEGEND / LOCATION = inside POSITION = topright ACROSS = 1 NOBORDER LINELENGTH = 20;
RUN;
%MEND;

/* Application de la macro */
%boxplot(Maladie, Age);
%boxplot(Maladie, Tension);
%boxplot(Maladie, Cholesterol);

/************************************* ANALYSES BIVARIÉES *************************************/

/* Macro pour créer un tableau croisé pour deux variables catégorielles */
%MACRO tableaux_croises(variable_interet, variable_explicative);
PROC TABULATE DATA = projet.donnees;
TITLE "Tableau croisé des variables &variable_interet et &variable_explicative (effectifs et pourcentages)";
CLASS &variable_explicative &variable_interet;
TABLE &variable_explicative, &variable_interet*(N ROWPCTN);
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%tableaux_croises(Maladie, Sexe);
%tableaux_croises(Maladie, Angine);
%tableaux_croises(Maladie, Glycemie);

/* Macro pour calculer les moyennes conditionnelles */
%MACRO moyennes_conditionnelles(variable_interet, variable_explicative);
PROC MEANS DATA = projet.donnees MEAN MIN MEDIAN MAX MAXDEC = 2;
TITLE "Moyennes conditionnelles de la variable &variable_interet selon la variable &variable_explicative";
CLASS &variable_interet;
VAR &variable_explicative;
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%moyennes_conditionnelles(Maladie, Age);
%moyennes_conditionnelles(Maladie, Tension);
%moyennes_conditionnelles(Maladie, Cholesterol);

/* Test du Khi-Deux
Hypothèses du test :
H0 : Les deux variables sont indépendantes (si p-value > 0,05)
H1 : Les deux variables sont dependantes (si p-value < 0,05)
*/
%MACRO KhiDeux(variable_interet, variable_explicative);
PROC FREQ DATA = projet.donnees;
TABLES &variable_explicative * &variable_interet / CHISQ;
TITLE "Test du Khi-Deux d'indépendance entre la variable &variable_explicative et la variable &variable_interet";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%KhiDeux(Maladie, Sexe); /* H1 */
%KhiDeux(Maladie, Angine); /* H1 */
%KhiDeux(Maladie, Glycemie); /* H0 */

/* Test de Shapiro-Wilk
Hypothèses du test :
H0 : L'échantillon suit une distribution normale (si p-value > 0,05)
H1 : L'échantillon ne suit pas une distribution normale (si p-value < 0,05)
*/
%MACRO ShapiroWilk(variable_a_tester);
PROC UNIVARIATE DATA = projet.donnees NORMAL;
VAR &variable_a_tester;
TITLE "Test de Shapiro-Wilk pour la variable &variable_a_tester";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%ShapiroWilk(Age); /* H1 */
%ShapiroWilk(Tension); /* H1 */
%ShapiroWilk(Cholesterol); /* H1 */

/* Test de Mann-Whitney (on l'applique que si on choisit l'hypothèse H1 au test de Shapiro-Wilk)
Hypothèses du test :
H0 : Il n'y a pas de différence significative entre la moyenne des deux variables (si p-value > 0,05)
H1 : Il y a une différence significative entre la moyenne des deux variables (si p-value < 0,05)
*/
%MACRO MannWhitney(variable_interet, variable_explicative);
PROC NPAR1WAY DATA = projet.donnees WILCOXON;
CLASS &variable_interet;
VAR &variable_explicative;
TITLE "Test de Mann-Whitney pour les variable &variable_explicative et &variable_interet";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;

/* Application de la macro */
%MannWhitney(Maladie, Age); /* H1 */
%MannWhitney(Maladie, Tension); /* H1 */
%MannWhitney(Maladie, Cholesterol); /* H1 */

/* Test de Student (on l'applique que si on choisit l'hypothèse H0 au test de Shapiro-Wilk)
Hypothèses du test :
H0 : Il n'y a pas de différence significative entre la moyenne des deux variables (si p-value > 0,05)
H1 : Il y a une différence significative entre la moyenne des deux variables (si p-value < 0,05)
%MACRO Student(variable_interet, variable_explicative);
PROC TTEST DATA = projet.donnees;
CLASS &variable_interet;
VAR &variable_explicative;
TITLE "Test de Student pour les variable &variable_explicative et &variable_interet";
FOOTNOTE "Données : Clinique médicale de Cleveland (Etats-Unis)";
RUN;
%MEND;
%Student(Maladie, Cholesterol);
*/

/************************************* MACHINE LEARNING *************************************/

/* Séparation du jeu de données en base d'apprentissage/entrainement et de test */
PROC SURVEYSELECT DATA = projet.donnees METHOD = SRS SEED = 2 OUTALL SAMPRATE = 0.8 OUT = projet.donnees2;
RUN;
PROC PRINT DATA = projet.donnees2;
RUN;

/* Création de la base d'apprentissage/entrainement */
DATA projet.train;
SET projet.donnees2;
IF selected = 1;
RUN;
PROC PRINT DATA = projet.train;
RUN;

/* Création de la base de test */
DATA projet.test;
SET projet.donnees2;
IF selected = 0;
RUN;
PROC PRINT DATA = projet.test;
RUN;

/* Modèle de régression logistique */
PROC LOGISTIC DATA = projet.train PLOTS = (oddsratio(cldisplay = serifarrow) roc);
TITLE "Modèle de régression logistique (Machine Learning)";
CLASS Sexe Angine Glycemie ECG AngineApresSport PenteECG Fluoroscopie Thalassemie / PARAM = glm;
MODEL Maladie(event = "Oui") = Sexe Angine Glycemie ECG AngineApresSport PenteECG Fluoroscopie Thalassemie Age Tension Cholesterol FreqCardiaque AngineECG / LINK = logit LACKFIT SELECTION = backward SLSTAY = 0.05 TECHNIQUE = fisher;
SCORE DATA = projet.test OUT = projet.predictions;
RUN;

/* Test de Hosmer et Lemeshow
Hypothèses :
H0 : L'ajustement du modèle aux données est bon (si p-value > 0,05)
H1 : L'ajustement du modèle aux données est mauvais (si p-value < 0,05)
Puisque la p-value est supérieure à 0.05, alors on choisit H0.
*/

/* Formatage du tableau contenant les prédictions */
DATA projet.predictions(DROP = Selected F_Maladie I_Maladie P_Non P_Oui);
SET projet.predictions;
LENGTH Prediction $5.;
IF P_Oui > 0.5 THEN Prediction = "Oui";
IF P_Oui < 0.5 THEN Prediction = "Non";
RUN;

/* Affichage de la matrice de confusion */
PROC TABULATE DATA = projet.predictions;
TITLE "Matrice de confusion";
CLASS Maladie Prediction;
TABLE (Maladie),(Prediction)*(N);
RUN;

/* Ajout d'une colonne interprétant les résultats */
DATA projet.predictions;
SET projet.predictions;
LENGTH Resultat $32.;
IF Maladie = "Oui" AND Prediction = "Oui" THEN Resultat = "Vrai positif";
IF Maladie = "Non" AND Prediction = "Non" THEN Resultat = "Vrai négatif";
IF Maladie = "Oui" AND Prediction = "Non" THEN Resultat = "Faux négatif";
IF Maladie = "Non" AND Prediction = "Oui" THEN Resultat = "Faux positif";
RUN;

/* Affichage des prédictions */
PROC PRINT DATA = projet.predictions;
RUN;




