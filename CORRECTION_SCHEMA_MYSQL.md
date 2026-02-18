# Correction - Schéma MySQL Incomplet

## 🔍 Problème Identifié

Erreur lors de la création d'une candidature :

```
JDBC exception executing SQL [Unknown column 'or1_0.date_limite' in 'field list']
```

**Cause :** La table `offre_recrutement` dans MySQL ne contient pas toutes les colonnes définies dans l'entité Java `OffreRecrutement`.

**Colonnes manquantes probables :**
- `date_limite`
- `experience_min`
- `salaire_min`
- `salaire_max`

---

## ✅ Solution 1: Ajouter les Colonnes Manquantes (Recommandé)

Cette solution conserve vos données existantes.

### Étape 1: Se Connecter à MySQL

```bash
mysql -u root -p
```

### Étape 2: Vérifier la Structure Actuelle

```sql
USE recrutement_db;
DESCRIBE offre_recrutement;
```

Vous verrez probablement qu'il manque certaines colonnes.

### Étape 3: Ajouter les Colonnes Manquantes

```sql
-- Ajouter date_limite
ALTER TABLE offre_recrutement 
ADD COLUMN date_limite DATE AFTER date_publication;

-- Ajouter experience_min
ALTER TABLE offre_recrutement 
ADD COLUMN experience_min INT DEFAULT 0 AFTER type_contrat;

-- Ajouter salaire_min
ALTER TABLE offre_recrutement 
ADD COLUMN salaire_min DOUBLE DEFAULT NULL AFTER statut;

-- Ajouter salaire_max
ALTER TABLE offre_recrutement 
ADD COLUMN salaire_max DOUBLE DEFAULT NULL AFTER salaire_min;
```

### Étape 4: Vérifier la Structure Mise à Jour

```sql
DESCRIBE offre_recrutement;
```

Vous devriez maintenant voir toutes les colonnes :
- id
- titre
- description
- specialite
- niveau_requis
- type_contrat
- experience_min ✅ (nouvelle)
- date_publication
- date_limite ✅ (nouvelle)
- statut
- salaire_min ✅ (nouvelle)
- salaire_max ✅ (nouvelle)
- nombre_postes

### Étape 5: Mettre à Jour les Données Existantes

Si vous avez des offres existantes, mettez à jour les nouvelles colonnes :

```sql
-- Mettre à jour les offres existantes avec des valeurs par défaut
UPDATE offre_recrutement 
SET 
    date_limite = DATE_ADD(date_publication, INTERVAL 30 DAY),
    experience_min = 0
WHERE date_limite IS NULL;
```

### Étape 6: Redémarrer le Service

```bash
# Arrêter le service (Ctrl+C)
cd recrutement-service
mvn spring-boot:run
```

### Étape 7: Tester

Retestez votre candidature via Swagger.

---

## ✅ Solution 2: Recréer les Tables (Plus Simple)

Cette solution supprime toutes les données existantes mais garantit un schéma correct.

### Étape 1: Se Connecter à MySQL

```bash
mysql -u root -p
```

### Étape 2: Supprimer les Tables

```sql
USE recrutement_db;

-- Supprimer les tables (ordre important à cause des clés étrangères)
DROP TABLE IF EXISTS candidature_enseignant;
DROP TABLE IF EXISTS offre_recrutement;
```

### Étape 3: Redémarrer le Service

```bash
# Arrêter le service (Ctrl+C)
cd recrutement-service
mvn spring-boot:run
```

Hibernate va recréer automatiquement les tables avec le bon schéma.

### Étape 4: Vérifier le Schéma

```sql
USE recrutement_db;
DESCRIBE offre_recrutement;
DESCRIBE candidature_enseignant;
```

### Étape 5: Créer des Données de Test

Créez une nouvelle offre via Swagger ou le back-office.

---

## ✅ Solution 3: Forcer Hibernate à Recréer les Tables

### Étape 1: Modifier application.properties

Changez temporairement :

```properties
# ATTENTION : Cela supprimera toutes les données !
spring.jpa.hibernate.ddl-auto=create
```

### Étape 2: Redémarrer le Service

```bash
cd recrutement-service
mvn spring-boot:run
```

Les tables seront supprimées et recréées avec le bon schéma.

### Étape 3: Remettre la Configuration Normale

Après le démarrage, arrêtez le service et remettez :

```properties
spring.jpa.hibernate.ddl-auto=update
```

### Étape 4: Redémarrer le Service

```bash
mvn spring-boot:run
```

---

## 🔍 Vérification du Schéma Complet

### Table offre_recrutement

```sql
DESCRIBE offre_recrutement;
```

**Colonnes attendues :**

| Colonne | Type | Null | Key | Default | Extra |
|---------|------|------|-----|---------|-------|
| id | bigint | NO | PRI | NULL | auto_increment |
| titre | varchar(150) | NO | | NULL | |
| description | varchar(2000) | NO | | NULL | |
| specialite | varchar(100) | NO | | NULL | |
| niveau_requis | varchar(100) | YES | | NULL | |
| type_contrat | varchar(20) | NO | | NULL | |
| experience_min | int | YES | | NULL | |
| date_publication | date | YES | | NULL | |
| date_limite | date | NO | | NULL | |
| statut | varchar(20) | NO | | NULL | |
| salaire_min | double | YES | | NULL | |
| salaire_max | double | YES | | NULL | |
| nombre_postes | int | NO | | NULL | |

### Table candidature_enseignant

```sql
DESCRIBE candidature_enseignant;
```

**Colonnes attendues :**

| Colonne | Type | Null | Key | Default | Extra |
|---------|------|------|-----|---------|-------|
| id_candidature | bigint | NO | PRI | NULL | auto_increment |
| nom_candidat | varchar(50) | NO | | NULL | |
| prenom_candidat | varchar(50) | NO | | NULL | |
| email | varchar(100) | NO | UNI | NULL | |
| cv_url | varchar(500) | NO | | NULL | |
| lettre_motivation | varchar(2000) | NO | | NULL | |
| date_candidature | date | YES | | NULL | |
| statut | varchar(20) | NO | | NULL | |
| offre_id | bigint | YES | MUL | NULL | |

---

## 🧪 Test Après Correction

### 1. Créer une Offre

```json
POST http://localhost:8083/api/recrutement/offres

{
  "titre": "Enseignant Java Spring Boot",
  "description": "Nous recherchons un enseignant expérimenté en développement Java et Spring Boot",
  "specialite": "Informatique",
  "niveau_requis": "Master ou Doctorat",
  "type_contrat": "CDI",
  "experience_min": 3,
  "date_publication": "2026-02-18",
  "date_limite": "2026-04-18",
  "statut": "OUVERTE",
  "nombre_postes": 2,
  "salaire_min": 2500.0,
  "salaire_max": 3500.0
}
```

**Résultat attendu :** ✅ Code 201

### 2. Créer une Candidature

```json
POST http://localhost:8083/api/recrutement/candidatures/offre/1

{
  "nom_candidat": "Rahma",
  "prenom_candidat": "Elaid",
  "email": "rahmaelaid6@gmail.com",
  "cv_url": "http://localhost:8086",
  "lettre_motivation": "Madame, Monsieur, je me permets de vous adresser ma candidature pour le poste d'enseignant en informatique. Fort de mes cinq années d'expérience dans l'enseignement supérieur et le développement d'applications web, je suis convaincu de pouvoir apporter une contribution significative à votre établissement. Ma passion pour la transmission des connaissances et mon expertise technique me permettent d'accompagner efficacement les étudiants dans leur apprentissage. Je reste à votre disposition pour un entretien afin de discuter de ma candidature. Cordialement.",
  "statut": "EN_ATTENTE"
}
```

**Résultat attendu :** ✅ Code 201

### 3. Vérifier dans MySQL

```sql
USE recrutement_db;

SELECT * FROM offre_recrutement;
SELECT * FROM candidature_enseignant;
```

**Résultat attendu :** ✅ Vous voyez les données créées

---

## 🔄 Même Problème pour Forum Service ?

Si vous avez le même problème avec le Forum Service, appliquez la même solution :

```sql
USE forum_db;

-- Vérifier la structure
DESCRIBE forum;
DESCRIBE message_forum;

-- Si des colonnes manquent, les ajouter
-- Ou supprimer et recréer les tables
DROP TABLE IF EXISTS message_forum;
DROP TABLE IF EXISTS forum;
```

Puis redémarrez le Forum Service.

---

## 📝 Prévention Future

Pour éviter ce problème à l'avenir :

### 1. Utiliser create-drop en Développement

Dans `application.properties` (développement uniquement) :

```properties
# Développement : Recrée les tables à chaque démarrage
spring.jpa.hibernate.ddl-auto=create-drop
```

### 2. Utiliser update en Production

```properties
# Production : Met à jour le schéma sans supprimer les données
spring.jpa.hibernate.ddl-auto=update
```

### 3. Utiliser Flyway ou Liquibase

Pour une gestion professionnelle des migrations de schéma :

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

---

## ✅ Checklist de Vérification

Après avoir appliqué la correction :

- [ ] Tables supprimées ou colonnes ajoutées
- [ ] Service redémarré
- [ ] Schéma vérifié avec DESCRIBE
- [ ] Création d'offre fonctionne (code 201)
- [ ] Création de candidature fonctionne (code 201)
- [ ] Données visibles dans MySQL
- [ ] Données visibles dans phpMyAdmin
- [ ] Données visibles dans le back-office Angular

---

## 🎯 Résultat Final

Après cette correction :

1. ✅ Le schéma MySQL correspond à l'entité Java
2. ✅ Toutes les colonnes sont présentes
3. ✅ Les candidatures peuvent être créées
4. ✅ Les données sont persistées correctement
5. ✅ Plus d'erreur "Unknown column"

**Le problème de schéma est résolu ! 🎉**
