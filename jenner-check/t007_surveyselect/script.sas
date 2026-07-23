/* --- Donnees medicales de Cleveland : import + preparation (d'apres projet_final.sas) --- */
/* Echantillon des lignes de data.csv, lu en ligne pour un bundle autonome.       */
/* VAR12/VAR13 sont caracteres pour accepter le marqueur manquant "?".            */
DATA donnees;
INPUT VAR1 VAR2 VAR3 VAR4 VAR5 VAR6 VAR7 VAR8 VAR9 VAR10 VAR11 VAR12 $ VAR13 $ VAR14;
DATALINES;
63 1 1 145 233 1 2 150 0 2.3 3 0 6 0
67 1 4 160 286 0 2 108 1 1.5 2 3 3 2
67 1 4 120 229 0 2 129 1 2.6 2 2 7 1
37 1 3 130 250 0 0 187 0 3.5 3 0 3 0
41 0 2 130 204 0 2 172 0 1.4 1 0 3 0
56 1 2 120 236 0 0 178 0 0.8 1 0 3 0
62 0 4 140 268 0 2 160 0 3.6 3 2 3 3
57 0 4 120 354 0 0 163 1 0.6 1 0 3 0
63 1 4 130 254 0 2 147 0 1.4 2 1 7 2
53 1 4 140 203 1 2 155 1 3.1 3 0 7 1
57 1 4 140 192 0 0 148 0 0.4 2 0 6 0
56 0 2 140 294 0 2 153 0 1.3 2 0 3 0
56 1 3 130 256 1 2 142 1 0.6 2 1 6 2
44 1 2 120 263 0 0 173 0 0 1 0 7 0
52 1 3 172 199 1 0 162 0 0.5 1 0 7 0
57 1 3 150 168 0 0 174 0 1.6 1 0 3 0
48 1 2 110 229 0 0 168 0 1 3 0 7 1
54 1 4 140 239 0 0 160 0 1.2 1 0 3 0
48 0 3 130 275 0 0 139 0 0.2 1 0 3 0
49 1 2 130 266 0 0 171 0 0.6 1 0 3 0
64 1 1 110 211 0 2 144 1 1.8 2 0 3 0
58 0 1 150 283 1 2 162 0 1 1 0 3 0
58 1 2 120 284 0 2 160 0 1.8 2 0 3 1
58 1 3 132 224 0 2 173 0 3.2 1 2 7 3
60 1 4 130 206 0 2 132 1 2.4 2 2 7 4
50 0 3 120 219 0 0 158 0 1.6 2 0 3 0
58 0 3 120 340 0 0 172 0 0 1 0 3 0
66 0 1 150 226 0 0 114 0 2.6 3 0 3 0
43 1 4 150 247 0 0 171 0 1.5 1 0 3 0
40 1 4 110 167 0 2 114 1 2 2 0 7 3
69 0 1 140 239 0 0 151 0 1.8 1 2 3 0
60 1 4 117 230 1 0 160 1 1.4 1 2 7 2
64 1 3 140 335 0 0 158 0 0 1 0 3 1
59 1 4 135 234 0 0 161 0 0.5 2 0 7 0
53 0 3 128 216 0 2 115 0 0 1 0 ? 0
52 1 3 138 223 0 0 169 0 0 1 ? 3 0
43 1 4 132 247 1 2 143 1 0.1 2 ? 7 1
52 1 4 128 204 1 0 156 1 1 2 0 ? 2
58 1 2 125 220 0 0 144 0 0.4 2 ? 7 0
38 1 3 138 175 0 0 173 0 0 1 ? 3 0
;
RUN;

/* Supprimer les valeurs manquantes */
DATA donnees;
SET donnees;
IF VAR12 = "?" OR VAR13 = "?" THEN DELETE;
RUN;

/* Recodage des variables categorielles */
DATA donnees;
SET donnees;
LENGTH Sexe $6. Angine $32. Glycemie $32. ECG $32. AngineApresSport $3. PenteECG $16. Fluoroscopie $32. Thalassemie $32. Maladie $3.;
IF VAR2 = 1 THEN Sexe = "Homme";
IF VAR2 = 0 THEN Sexe = "Femme";
IF VAR3 = 1 THEN Angine = "Angine stable";
IF VAR3 = 2 THEN Angine = "Angine instable";
IF VAR3 = 3 THEN Angine = "Douleur non angineuse";
IF VAR3 = 4 THEN Angine = "Asymptomatique";
IF VAR6 = 1 THEN Glycemie = "Glycemie > 120mg/dl";
IF VAR6 = 0 THEN Glycemie = "Glycemie < 120mg/dl";
IF VAR7 = 0 THEN ECG = "Normal";
IF VAR7 = 1 THEN ECG = "Anomalies";
IF VAR7 = 2 THEN ECG = "Hypertrophie";
IF VAR9 = 0 THEN AngineApresSport = "Non";
IF VAR9 = 1 THEN AngineApresSport = "Oui";
IF VAR11 = 1 THEN PenteECG = "En hausse";
IF VAR11 = 2 THEN PenteECG = "Stable";
IF VAR11 = 3 THEN PenteECG = "En baisse";
IF VAR14 = 0 THEN Maladie = "Non";
IF VAR14 = 1 THEN Maladie = "Oui";
IF VAR14 = 2 THEN Maladie = "Oui";
IF VAR14 = 3 THEN Maladie = "Oui";
IF VAR14 = 4 THEN Maladie = "Oui";
DROP VAR2 VAR3 VAR6 VAR7 VAR9 VAR11;
RUN;

/* Renommer les variables quantitatives */
DATA donnees;
SET donnees(rename = (VAR1 = Age VAR4 = Tension VAR5 = Cholesterol VAR8 = FreqCardiaque VAR10 = AngineECG));
RUN;

/* Reordonner les variables */
DATA donnees;
RETAIN Age Sexe Angine Tension Cholesterol Glycemie ECG FreqCardiaque AngineApresSport AngineECG PenteECG Maladie;
SET donnees;
RUN;

/************************************* MACHINE LEARNING *************************************/
/* Separation apprentissage/test par sondage aleatoire simple (code de l'auteur) */
PROC SURVEYSELECT DATA = donnees METHOD = SRS SEED = 2 OUTALL SAMPRATE = 0.8 OUT = donnees2;
RUN;

/* Base d'apprentissage/entrainement */
DATA train;
SET donnees2;
IF selected = 1;
RUN;

/* Base de test */
DATA test;
SET donnees2;
IF selected = 0;
RUN;

/* Repartition du partage train/test */
PROC FREQ DATA = donnees2;
TABLES selected / NOCUM;
TITLE "Repartition apprentissage (1) / test (0)";
FOOTNOTE "Donnees : Clinique medicale de Cleveland (Etats-Unis)";
RUN;
