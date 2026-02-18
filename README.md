# 🎓 Projet Microservices - Forum & Recrutement ESPRIT

Système de gestion de forums académiques et de recrutement d'enseignants avec architecture microservices Spring Boot et interface Angular.

---

## 🚀 Démarrage Rapide

### 1. Démarrer MySQL
```bash
net start MySQL80
```

### 2. Démarrer les Services Backend
```bash
# Terminal 1 - Eureka
cd eureka-server && mvn spring-boot:run

# Terminal 2 - Forum
cd forum-service && mvn spring-boot:run

# Terminal 3 - Recrutement
cd recrutement-service && mvn spring-boot:run
```

### 3. Démarrer le Frontend
```bash
cd angular-app/back-office && ng serve
```

### 4. Accéder aux Interfaces
- **Back-Office** : http://localhost:4200
- **Forum Swagger** : http://localhost:8082/swagger-ui.html
- **Recrutement Swagger** : http://localhost:8083/swagger-ui.html
- **Eureka Dashboard** : http://localhost:8761

---

## 📋 Prérequis

- Java 17+
- Maven 3.6+
- Node.js 18+
- MySQL 8.0+
- Angular CLI

---

## 🏗️ Architecture

```
Frontend Angular (4200)
         ↓
API Gateway (8080)
         ↓
    ┌────┴────┐
    ↓         ↓
Forum (8082)  Recrutement (8083)
    ↓         ↓
MySQL         MySQL
forum_db      recrutement_db
         ↓
Eureka Server (8761)
```

---

## 🔐 Validations Implémentées

### Forum
- Titre : 5-100 caractères
- Description : 10-1000 caractères
- Niveau : L1, L2, L3, M1, M2
- Statut : OUVERT, FERME, ARCHIVE

### Recrutement
- Titre : 5-150 caractères
- Description : 20-2000 caractères
- Type contrat : CDI, CDD, Vacataire
- Date limite : Future

### Candidature (Validateurs Personnalisés)
- ✅ Email : Format strict, domaine valide
- ✅ CV URL : Extensions .pdf/.doc/.docx/.txt
- ✅ Nom/Prénom : Lettres uniquement, majuscule
- ✅ Lettre motivation : 100-2000 car, 20+ mots

---

## 🗄️ Base de Données MySQL

### Connexion
```bash
mysql -u root -p
```

### Bases de données
- `forum_db` - Forums et messages
- `recrutement_db` - Offres et candidatures

### Requêtes utiles
```sql
USE forum_db;
SELECT * FROM forum;
SELECT * FROM message_forum;

USE recrutement_db;
SELECT * FROM offre_recrutement;
SELECT * FROM candidature_enseignant;
```

---

## 📚 Documentation

| Fichier | Description |
|---------|-------------|
| [PROJET_FINAL_COMPLET.md](PROJET_FINAL_COMPLET.md) | Documentation complète du projet |
| [MIGRATION_MYSQL.md](MIGRATION_MYSQL.md) | Guide de migration vers MySQL |
| [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md) | Guide des validations |
| [EXEMPLES_TESTS_SWAGGER.md](EXEMPLES_TESTS_SWAGGER.md) | Exemples de tests |

---

## 🧪 Tests

### Via Swagger UI
1. Ouvrir http://localhost:8082/swagger-ui.html
2. Tester POST /api/forum/forums avec données valides
3. Vérifier les validations avec données invalides

### Via MySQL
```sql
USE forum_db;
SELECT * FROM forum;
```

---

## 🛠️ Technologies

**Backend :**
- Spring Boot 4.0.2
- Spring Cloud (Eureka, Gateway)
- MySQL 8.0
- Hibernate/JPA
- Swagger/OpenAPI 2.7.0
- Lombok
- Bean Validation

**Frontend :**
- Angular 21
- TypeScript
- Tailwind CSS
- RxJS

---

## 📊 Endpoints Principaux

### Forum Service (8082)
- `GET /api/forum/forums` - Lister forums
- `POST /api/forum/forums` - Créer forum
- `GET /api/forum/messages` - Lister messages
- `POST /api/forum/messages?forumId={id}` - Créer message

### Recrutement Service (8083)
- `GET /api/recrutement/offres` - Lister offres
- `POST /api/recrutement/offres` - Créer offre
- `POST /api/recrutement/candidatures/offre/{id}` - Postuler

---

## ⚙️ Configuration

### MySQL (application.properties)
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/forum_db?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=
```

### Ports
- Eureka : 8761
- Forum : 8082
- Recrutement : 8083
- Gateway : 8080
- Angular : 4200

---

## 🎯 Fonctionnalités

✅ CRUD complet pour forums et messages  
✅ CRUD complet pour offres et candidatures  
✅ Validations côté backend avec messages personnalisés  
✅ 4 validateurs personnalisés (Email, CV, Nom, Lettre)  
✅ Interface Angular responsive  
✅ Documentation Swagger interactive  
✅ Base de données MySQL persistante  
✅ Architecture microservices avec Eureka  

---

## 🐛 Dépannage

### MySQL ne démarre pas
```bash
net start MySQL80
```

### Port déjà utilisé
```bash
# Trouver le processus
netstat -ano | findstr :8082
# Tuer le processus
taskkill /PID <PID> /F
```

### Erreur de validation
Vérifier les logs du service et consulter [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md)

---

## 👥 Auteurs

Projet développé pour ESPRIT - École Supérieure Privée d'Ingénierie et de Technologies

---

## 📝 Licence

Ce projet est développé à des fins éducatives.

---

## 🎉 Statut

✅ **Projet Complet et Opérationnel**

- Architecture microservices fonctionnelle
- Validations complètes implémentées
- Base de données MySQL configurée
- Documentation exhaustive
- Prêt pour déploiement

**Date de finalisation** : 18 février 2026
