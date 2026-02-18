# 🎓 Projet Final Complet - Microservices avec Validations et MySQL

## 📊 Vue d'Ensemble du Projet

Projet de microservices Spring Boot avec Angular pour la gestion de forums académiques et de recrutement d'enseignants, incluant des validations complètes et une base de données MySQL.

---

## 🏗️ Architecture Complète

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Angular                          │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │   Back-Office    │         │  Frontend Public │         │
│  │   (Port 4200)    │         │   (Port 4201)    │         │
│  └──────────────────┘         └──────────────────┘         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    API Gateway (Port 8080)                   │
└─────────────────────────────────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
┌──────────────────────┐    ┌──────────────────────┐
│   Forum Service      │    │ Recrutement Service  │
│    (Port 8082)       │    │    (Port 8083)       │
└──────────────────────┘    └──────────────────────┘
         │                           │
         ▼                           ▼
┌──────────────────────┐    ┌──────────────────────┐
│   MySQL Database     │    │   MySQL Database     │
│     forum_db         │    │   recrutement_db     │
└──────────────────────┘    └──────────────────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │   Eureka Server       │
                │    (Port 8761)        │
                └───────────────────────┘
```

---

## 🗄️ Bases de Données MySQL

### forum_db

**Tables :**

1. **forum**
   - id (BIGINT, PK, AUTO_INCREMENT)
   - titre (VARCHAR(100))
   - description (VARCHAR(1000))
   - date_creation (DATE)
   - cree_par (BIGINT)
   - niveau (VARCHAR(2)) - L1, L2, L3, M1, M2
   - groupe (VARCHAR(50))
   - cours (VARCHAR(100))
   - statut (VARCHAR(20)) - OUVERT, FERME, ARCHIVE

2. **message_forum**
   - id (BIGINT, PK, AUTO_INCREMENT)
   - contenu (VARCHAR(2000))
   - date_message (DATETIME)
   - auteur_id (BIGINT)
   - type_auteur (VARCHAR(20)) - ETUDIANT, ENSEIGNANT, ADMIN
   - statut (VARCHAR(20)) - ACTIF, SUPPRIME, MODERE
   - forum_id (BIGINT, FK → forum.id)

### recrutement_db

**Tables :**

1. **offre_recrutement**
   - id (BIGINT, PK, AUTO_INCREMENT)
   - titre (VARCHAR(150))
   - description (VARCHAR(2000))
   - specialite (VARCHAR(100))
   - niveau_requis (VARCHAR(100))
   - type_contrat (VARCHAR(20)) - CDI, CDD, Vacataire
   - experience_min (INT)
   - date_publication (DATE)
   - date_limite (DATE)
   - statut (VARCHAR(20)) - OUVERTE, FERMEE, POURVUE
   - salaire_min (DOUBLE)
   - salaire_max (DOUBLE)
   - nombre_postes (INT)

2. **candidature_enseignant**
   - id_candidature (BIGINT, PK, AUTO_INCREMENT)
   - nom_candidat (VARCHAR(50))
   - prenom_candidat (VARCHAR(50))
   - email (VARCHAR(100), UNIQUE)
   - cv_url (VARCHAR(500))
   - lettre_motivation (VARCHAR(2000))
   - date_candidature (DATE)
   - statut (VARCHAR(20)) - EN_ATTENTE, ACCEPTEE, REFUSEE
   - offre_id (BIGINT, FK → offre_recrutement.id)

---

## 🔐 Validations Implémentées

### Forum Service

#### Entité Forum
```java
@NotBlank(message = "Le titre est obligatoire")
@Size(min = 5, max = 100)
private String titre;

@NotBlank(message = "La description est obligatoire")
@Size(min = 10, max = 1000)
private String description;

@NotBlank(message = "Le niveau est obligatoire")
@Pattern(regexp = "L1|L2|L3|M1|M2")
private String niveau;

@NotBlank(message = "Le groupe est obligatoire")
@Size(min = 2, max = 50)
private String groupe;

@NotBlank(message = "Le cours est obligatoire")
@Size(min = 3, max = 100)
private String cours;

@NotNull(message = "La date de création est obligatoire")
@PastOrPresent
private LocalDate date_creation;

@NotNull(message = "L'ID du créateur est obligatoire")
@Positive
private Long cree_par;

@NotBlank(message = "Le statut est obligatoire")
@Pattern(regexp = "OUVERT|FERME|ARCHIVE")
private String statut;
```

#### Entité MessageForum
```java
@NotBlank(message = "Le contenu est obligatoire")
@Size(min = 1, max = 2000)
private String contenu;

@NotNull(message = "L'ID de l'auteur est obligatoire")
@Positive
private Long auteurId;

@NotBlank(message = "Le type d'auteur est obligatoire")
@Pattern(regexp = "ETUDIANT|ENSEIGNANT|ADMIN")
private String type_auteur;

@NotBlank(message = "Le statut est obligatoire")
@Pattern(regexp = "ACTIF|SUPPRIME|MODERE")
private String statut;
```

### Recrutement Service

#### Entité OffreRecrutement
```java
@NotBlank(message = "Le titre est obligatoire")
@Size(min = 5, max = 150)
private String titre;

@NotBlank(message = "La description est obligatoire")
@Size(min = 20, max = 2000)
private String description;

@NotBlank(message = "La spécialité est obligatoire")
@Size(min = 3, max = 100)
private String specialite;

@NotBlank(message = "Le type de contrat est obligatoire")
@Pattern(regexp = "CDI|CDD|Vacataire")
private String type_contrat;

@NotNull(message = "Le nombre de postes est obligatoire")
@Min(value = 1)
@Max(value = 50)
private Integer nombre_postes;

@NotNull(message = "L'expérience minimale est obligatoire")
@Min(value = 0)
@Max(value = 30)
private Integer experience_min;

@NotNull(message = "La date limite est obligatoire")
@Future
private LocalDate date_limite;

@NotBlank(message = "Le statut est obligatoire")
@Pattern(regexp = "OUVERTE|FERMEE|POURVUE")
private String statut;
```

#### Entité CandidatureEnseignant (Validateurs Personnalisés)
```java
@NotBlank(message = "Le nom du candidat est obligatoire")
@ValidName
private String nom_candidat;

@NotBlank(message = "Le prénom du candidat est obligatoire")
@ValidName
private String prenom_candidat;

@NotBlank(message = "L'email est obligatoire")
@ValidEmail
@Column(unique = true)
private String email;

@NotBlank(message = "L'URL du CV est obligatoire")
@ValidCvUrl
private String cv_url;

@NotBlank(message = "La lettre de motivation est obligatoire")
@ValidLettreMotivation
@Column(length = 2000)
private String lettre_motivation;

@NotBlank(message = "Le statut est obligatoire")
@Pattern(regexp = "EN_ATTENTE|ACCEPTEE|REFUSEE")
private String statut;
```

---

## 🛠️ Validateurs Personnalisés

### 1. @ValidEmail (EmailValidator)

**Règles :**
- Format : partie_locale@domaine.extension
- Longueur : 5-100 caractères
- Partie locale : lettres, chiffres, . _ - +
- Pas de caractères consécutifs : .. __ -- ++
- Domaine valide avec extension (2-6 caractères)

**Exemples valides :**
- ✅ mohamed.benahmed@esprit.tn
- ✅ fatma_trabelsi@gmail.com
- ✅ user+tag@example.co.uk

**Exemples invalides :**
- ❌ user..name@example.com (points consécutifs)
- ❌ @example.com (pas de partie locale)
- ❌ user@.com (domaine invalide)

### 2. @ValidCvUrl (CvUrlValidator)

**Règles :**
- URL valide avec protocole http:// ou https://
- Extensions acceptées : .pdf, .doc, .docx, .txt
- Domaines reconnus : Google Drive, Dropbox, OneDrive, Box, iCloud
- Longueur max : 500 caractères

**Exemples valides :**
- ✅ https://drive.google.com/file/d/123/cv.pdf
- ✅ https://www.dropbox.com/s/abc/cv.docx
- ✅ https://onedrive.live.com/download?id=xyz&file=cv.pdf

**Exemples invalides :**
- ❌ http://example.com/cv.jpg (extension non acceptée)
- ❌ ftp://example.com/cv.pdf (protocole non supporté)
- ❌ cv.pdf (pas une URL)

### 3. @ValidName (NameValidator)

**Règles :**
- Uniquement des lettres (avec accents)
- 2-50 caractères
- Commence par une majuscule
- Pas de chiffres
- Espaces et tirets autorisés (pas consécutifs)

**Exemples valides :**
- ✅ Mohamed
- ✅ Ben Ahmed
- ✅ Marie-Claire
- ✅ O'Connor

**Exemples invalides :**
- ❌ mohamed (pas de majuscule)
- ❌ Mohamed123 (contient des chiffres)
- ❌ M (trop court)
- ❌ Mohamed--Ali (tirets consécutifs)

### 4. @ValidLettreMotivation (LettreMotivationValidator)

**Règles :**
- 100-2000 caractères
- Minimum 20 mots
- Au moins une phrase complète (avec point)
- Pas que des majuscules
- Pas de répétitions excessives (max 3 fois le même mot)
- Diversité de vocabulaire (min 15 mots uniques)

---

## 🚀 Démarrage du Projet

### Prérequis

1. **Java 17** ou supérieur
2. **Maven 3.6+**
3. **Node.js 18+** et npm
4. **MySQL 8.0+**
5. **Angular CLI** : `npm install -g @angular/cli`

### Étape 1: Démarrer MySQL

```bash
# Windows
net start MySQL80

# Vérifier
mysql -u root -p
```

### Étape 2: Démarrer les Services Backend

```bash
# Terminal 1 - Eureka Server
cd eureka-server
mvn spring-boot:run

# Terminal 2 - Forum Service
cd forum-service
mvn spring-boot:run

# Terminal 3 - Recrutement Service
cd recrutement-service
mvn spring-boot:run

# Terminal 4 - API Gateway (optionnel)
cd api-gateway
mvn spring-boot:run
```

### Étape 3: Démarrer le Frontend Angular

```bash
# Terminal 5 - Back-Office
cd angular-app/back-office
npm install
ng serve

# Terminal 6 - Frontend Public (optionnel)
cd angular-app/frontend/angular-app
npm install
ng serve --port 4201
```

---

## 🌐 URLs d'Accès

### Backend

| Service | URL | Description |
|---------|-----|-------------|
| Eureka Dashboard | http://localhost:8761 | Service Discovery |
| Forum Service API | http://localhost:8082/api/forum | API REST Forum |
| Forum Swagger | http://localhost:8082/swagger-ui.html | Documentation Forum |
| Recrutement Service API | http://localhost:8083/api/recrutement | API REST Recrutement |
| Recrutement Swagger | http://localhost:8083/swagger-ui.html | Documentation Recrutement |
| API Gateway | http://localhost:8080 | Point d'entrée unique |

### Frontend

| Application | URL | Description |
|-------------|-----|-------------|
| Back-Office | http://localhost:4200 | Interface d'administration |
| Frontend Public | http://localhost:4201 | Interface publique |

### Base de Données

| Outil | URL | Identifiants |
|-------|-----|--------------|
| MySQL Command Line | `mysql -u root -p` | root / (votre mot de passe) |
| MySQL Workbench | localhost:3306 | root / (votre mot de passe) |
| phpMyAdmin | http://localhost/phpmyadmin | root / (votre mot de passe) |

---

## 📝 Exemples de Requêtes API

### Forum Service

#### Créer un Forum
```bash
POST http://localhost:8082/api/forum/forums
Content-Type: application/json

{
  "titre": "Discussion Java Spring Boot",
  "description": "Forum dédié aux questions sur Spring Boot et Java",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Développement Web",
  "statut": "OUVERT"
}
```

#### Lister tous les Forums
```bash
GET http://localhost:8082/api/forum/forums
```

#### Créer un Message
```bash
POST http://localhost:8082/api/forum/messages?forumId=1
Content-Type: application/json

{
  "contenu": "Bonjour, comment configurer Spring Security ?",
  "auteurId": 101,
  "type_auteur": "ETUDIANT",
  "statut": "ACTIF"
}
```

### Recrutement Service

#### Créer une Offre
```bash
POST http://localhost:8083/api/recrutement/offres
Content-Type: application/json

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
  "nombre_postes": 2
}
```

#### Postuler à une Offre
```bash
POST http://localhost:8083/api/recrutement/candidatures/offre/1
Content-Type: application/json

{
  "nom_candidat": "Benahmed",
  "prenom_candidat": "Mohamed",
  "email": "mohamed.benahmed@esprit.tn",
  "cv_url": "https://drive.google.com/file/d/123/cv.pdf",
  "lettre_motivation": "Madame, Monsieur, je me permets de vous adresser ma candidature pour le poste d'enseignant en Java et Spring Boot. Fort de mes cinq années d'expérience dans l'enseignement supérieur et le développement d'applications web, je suis convaincu de pouvoir apporter une contribution significative à votre établissement. Ma passion pour la transmission des connaissances et mon expertise technique me permettent d'accompagner efficacement les étudiants dans leur apprentissage. Je reste à votre disposition pour un entretien. Cordialement.",
  "statut": "EN_ATTENTE"
}
```

---

## 🗃️ Requêtes SQL Utiles

### Forum Database

```sql
-- Utiliser la base de données
USE forum_db;

-- Lister tous les forums
SELECT * FROM forum ORDER BY date_creation DESC;

-- Compter les forums par statut
SELECT statut, COUNT(*) as nombre 
FROM forum 
GROUP BY statut;

-- Forums avec le nombre de messages
SELECT 
    f.id,
    f.titre,
    f.niveau,
    f.groupe,
    COUNT(m.id) as nb_messages
FROM forum f
LEFT JOIN message_forum m ON f.id = m.forum_id
GROUP BY f.id, f.titre, f.niveau, f.groupe
ORDER BY nb_messages DESC;

-- Messages récents
SELECT 
    m.contenu,
    m.type_auteur,
    m.date_message,
    f.titre as forum_titre
FROM message_forum m
JOIN forum f ON m.forum_id = f.id
WHERE m.statut = 'ACTIF'
ORDER BY m.date_message DESC
LIMIT 10;
```

### Recrutement Database

```sql
-- Utiliser la base de données
USE recrutement_db;

-- Lister toutes les offres ouvertes
SELECT * FROM offre_recrutement 
WHERE statut = 'OUVERTE' 
ORDER BY date_limite ASC;

-- Offres avec le nombre de candidatures
SELECT 
    o.id,
    o.titre,
    o.specialite,
    o.type_contrat,
    o.date_limite,
    COUNT(c.id_candidature) as nb_candidatures
FROM offre_recrutement o
LEFT JOIN candidature_enseignant c ON o.id = c.offre_id
GROUP BY o.id, o.titre, o.specialite, o.type_contrat, o.date_limite
ORDER BY nb_candidatures DESC;

-- Candidatures en attente
SELECT 
    c.nom_candidat,
    c.prenom_candidat,
    c.email,
    o.titre as offre_titre,
    c.date_candidature
FROM candidature_enseignant c
JOIN offre_recrutement o ON c.offre_id = o.id
WHERE c.statut = 'EN_ATTENTE'
ORDER BY c.date_candidature DESC;

-- Statistiques par spécialité
SELECT 
    specialite,
    COUNT(*) as nb_offres,
    SUM(nombre_postes) as total_postes
FROM offre_recrutement
WHERE statut = 'OUVERTE'
GROUP BY specialite;
```

---

## 📚 Documentation Créée

1. ✅ **VALIDATION_GUIDE.md** - Guide complet des validations
2. ✅ **GUIDE_TEST_VALIDATIONS.md** - Guide de test détaillé
3. ✅ **DEMARRAGE_SERVICES.md** - Instructions de démarrage
4. ✅ **TEST_SANS_SWAGGER.md** - Tests alternatifs
5. ✅ **CORRECTION_SWAGGER.md** - Correction de Swagger UI
6. ✅ **EXEMPLES_TESTS_SWAGGER.md** - Exemples de tests Swagger
7. ✅ **CORRECTION_BASE_DONNEES.md** - Migration H2 → Fichier
8. ✅ **MIGRATION_MYSQL.md** - Migration vers MySQL
9. ✅ **RESUME_FINAL_VALIDATIONS.md** - Résumé des validations
10. ✅ **PROJET_FINAL_COMPLET.md** - Ce document

---

## 🎯 Fonctionnalités Complètes

### Backend
- ✅ Architecture microservices
- ✅ Service Discovery avec Eureka
- ✅ API Gateway pour routage
- ✅ Validations complètes avec messages personnalisés
- ✅ 4 validateurs personnalisés réutilisables
- ✅ GlobalExceptionHandler pour gestion centralisée des erreurs
- ✅ Documentation Swagger interactive
- ✅ Base de données MySQL persistante
- ✅ CORS configuré pour Angular
- ✅ Logs détaillés pour débogage

### Frontend
- ✅ Interface Back-Office complète (CRUD)
- ✅ Interface Frontend Public (consultation)
- ✅ Formulaires avec validation côté client
- ✅ Affichage des erreurs de validation backend
- ✅ Listes déroulantes pour valeurs fixes
- ✅ Placeholders informatifs
- ✅ Ajout automatique des dates
- ✅ Design responsive avec Tailwind CSS
- ✅ Notifications toast pour feedback utilisateur

---

## 🏆 Points Forts du Projet

1. **Architecture Moderne** : Microservices avec Spring Cloud
2. **Validations Robustes** : Côté backend avec validateurs personnalisés
3. **Base de Données Production** : MySQL avec persistance garantie
4. **Documentation Complète** : Swagger UI + 10 fichiers de documentation
5. **Interface Intuitive** : Angular avec design moderne
6. **Gestion d'Erreurs** : Messages clairs et précis
7. **Prêt pour Production** : Configuration MySQL, validations, logs

---

## 📞 Support et Maintenance

### Logs des Services

Les logs sont affichés dans les terminaux où les services sont lancés.

**Niveaux de log configurés :**
- Application : DEBUG
- Hibernate SQL : DEBUG
- Spring : INFO

### Problèmes Courants

| Problème | Solution |
|----------|----------|
| Service ne démarre pas | Vérifier que le port n'est pas déjà utilisé |
| Erreur MySQL | Vérifier que MySQL est démarré |
| Erreur 400 validation | Vérifier les données envoyées |
| Swagger 500 | Vérifier la version springdoc-openapi |
| CORS error | Vérifier CorsConfig.java |

---

## ✅ Checklist de Vérification

### Backend
- [ ] MySQL démarré et accessible
- [ ] Eureka Server démarré (http://localhost:8761)
- [ ] Forum Service démarré (http://localhost:8082)
- [ ] Recrutement Service démarré (http://localhost:8083)
- [ ] Les deux services apparaissent dans Eureka
- [ ] Swagger UI accessible et fonctionnel
- [ ] Bases de données créées (forum_db, recrutement_db)

### Frontend
- [ ] Back-Office démarré (http://localhost:4200)
- [ ] Connexion aux APIs backend réussie
- [ ] Formulaires affichent tous les champs
- [ ] Messages d'erreur s'affichent correctement

### Tests
- [ ] Création de forum avec données valides fonctionne
- [ ] Validation rejette les données invalides
- [ ] Messages d'erreur sont clairs et précis
- [ ] Données persistent dans MySQL
- [ ] Swagger UI permet de tester les endpoints

---

## 🎓 Conclusion

Le projet est maintenant **complet et opérationnel** avec :
- ✅ Architecture microservices professionnelle
- ✅ Validations complètes et robustes
- ✅ Base de données MySQL production-ready
- ✅ Documentation exhaustive
- ✅ Interface utilisateur moderne
- ✅ Prêt pour déploiement

**Date de finalisation** : 18 février 2026  
**Statut** : ✅ Projet complet, testé et documenté  
**Technologies** : Spring Boot 4.0.2, Angular 21, MySQL 8.0, Eureka, Swagger

---

**🎉 Félicitations ! Le projet est terminé et prêt à l'emploi ! 🎉**
