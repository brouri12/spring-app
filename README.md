# 🎓 Plateforme Éducative - Microservices Spring Boot & Angular

Une plateforme complète de gestion éducative avec architecture microservices, incluant forums avancés, système de recrutement, et fonctionnalités multimédias.

---

## 📋 Table des Matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Fonctionnalités](#fonctionnalités)
- [Technologies](#technologies)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [API Documentation](#api-documentation)
- [Contributeurs](#contributeurs)

---

## � Vue d'ensemble

Cette plateforme éducative offre une solution complète pour la gestion des forums, du recrutement d'enseignants, et de l'interaction entre étudiants et administration. Le projet utilise une architecture microservices moderne avec Spring Boot pour le backend et Angular pour le frontend.

### Objectifs du Projet
- Faciliter la communication entre étudiants via des forums interactifs
- Gérer le processus de recrutement des enseignants
- Offrir une expérience utilisateur moderne et responsive
- Fournir des fonctionnalités multimédias avancées

---

## 🏗️ Architecture

### Architecture Microservices

```
┌─────────────────────────────────────────────────────────────┐
│                     API Gateway (8888)                      │
│                   Spring Cloud Gateway                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Eureka Server (8761)                       │
│                  Service Discovery                          │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Forum      │    │ Recrutement  │    │   Autres     │
│  Service     │    │   Service    │    │  Services    │
│   (8082)     │    │    (8083)    │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
        │                     │
        ▼                     ▼
┌──────────────┐    ┌──────────────┐
│   MySQL      │    │   MySQL      │
│  forum_db    │    │ recrutement  │
└──────────────┘    └──────────────┘
```

### Frontend Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Angular Frontend                         │
├─────────────────────────────────────────────────────────────┤
│  Public App (4300)          │    Back-Office (4301)        │
│  - Forums publics           │    - Gestion forums          │
│  - Recrutement              │    - Gestion recrutement     │
│  - Chatbot                  │    - Analytics               │
│  - Préférences email        │    - Modération              │
└─────────────────────────────────────────────────────────────┘
```

---

## ✨ Fonctionnalités

### 🗣️ Système de Forums Avancé

#### Gestion des Messages
- ✅ Création, modification, suppression de messages
- ✅ Système de likes et réactions
- ✅ Réponses et fils de discussion
- ✅ Signalement de contenu inapproprié
- ✅ Modération automatique et manuelle
- ✅ Statuts des messages (ACTIF, ARCHIVE, SUPPRIME, MODERE)

#### Multimédia
- 📷 **Upload d'images** (JPG, PNG, GIF, WebP - max 5MB)
  - Génération automatique de miniatures
  - Prévisualisation en ligne
  - Compression intelligente
  
- 🎵 **Upload d'audio** (MP3, WAV, OGG - max 10MB)
  - Lecteur audio HTML5 intégré
  - Contrôles de lecture avancés
  
- 📄 **Upload de documents** (PDF, ZIP, DOC, XLS - max 20MB)
  - Téléchargement sécurisé
  - Aperçu des métadonnées
  
- 🎬 **Intégration vidéo** (YouTube, Vimeo)
  - Lecteur intégré
  - Prévisualisation automatique

#### Affichage des Médias
- ✅ Affichage automatique sous chaque message
- ✅ Grille responsive pour tous les types de médias
- ✅ Galerie par forum
- ✅ Filtrage par type de média

### 💬 Chatbot Intelligent

- 🤖 **Assistant virtuel** frontend-only
  - Base de connaissances locale
  - Réponses contextuelles sur:
    - Création de forums
    - Inscription aux cours
    - Processus de recrutement
    - Navigation sur la plateforme
  
- 💾 **Historique des conversations**
  - Sauvegarde dans localStorage
  - Reprise de conversation
  
- 🎨 **Interface moderne**
  - Widget flottant
  - Animations fluides
  - Design responsive

### 📧 Système de Notifications Email

#### Préférences Personnalisables
- ✉️ Nouveaux messages dans les forums suivis
- 💬 Réponses à vos messages
- ❤️ Likes sur vos publications
- 🔔 Mentions (@utilisateur)
- 📢 Annonces importantes
- 🎓 Nouveaux cours disponibles
- 👔 Nouvelles offres d'emploi

#### Fonctionnalités Email
- ✅ Configuration SMTP (Gmail, Outlook, etc.)
- ✅ Templates HTML personnalisés
- ✅ Système de retry automatique
- ✅ Logs d'envoi détaillés
- ✅ Endpoint de test d'email

### 👔 Système de Recrutement

#### Gestion des Offres
- ✅ Création et publication d'offres d'emploi
- ✅ Catégorisation par département
- ✅ Statuts (OUVERTE, FERMEE, POURVUE)
- ✅ Date limite de candidature

#### Gestion des Candidatures
- ✅ Upload de CV (PDF, DOC, DOCX)
- ✅ Lettre de motivation
- ✅ Validation automatique
- ✅ Suivi du statut (EN_ATTENTE, ACCEPTEE, REFUSEE)
- ✅ Stockage sécurisé des documents

### 🌐 Internationalisation

- 🇫🇷 **Français** (langue par défaut)
- 🇬🇧 **Anglais**
- ✅ Changement de langue en temps réel
- ✅ Traductions complètes de l'interface
- ✅ Support ngx-translate

### 🎨 Interface Utilisateur

#### Design Moderne
- ✅ Dark mode / Light mode
- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Animations et transitions fluides
- ✅ Composants réutilisables

#### Composants Personnalisés
- ✅ Modals personnalisés (pas de popups natifs)
- ✅ Notifications toast
- ✅ Formulaires avec validation
- ✅ Tables de données interactives

### 📊 Analytics et Statistiques

- 📈 Statistiques des forums
- 👥 Nombre d'utilisateurs actifs
- 📝 Messages par période
- 🔥 Sujets populaires
- 📊 Taux d'engagement

### 🔒 Sécurité

- ✅ Validation des fichiers uploadés
- ✅ Protection contre les injections
- ✅ CORS configuré
- ✅ Gestion des erreurs globale
- ✅ Logs de sécurité

---

## �️ Technologies

### Backend

#### Framework Principal
- **Spring Boot 3.2.0** - Framework Java
- **Spring Cloud** - Microservices
  - Eureka Server - Service Discovery
  - Spring Cloud Gateway - API Gateway
  - Config Server - Configuration centralisée

#### Base de Données
- **MySQL 8.0** - Base de données relationnelle
- **Spring Data JPA** - ORM
- **Hibernate** - Implémentation JPA

#### Sécurité & Validation
- **Spring Security** - Authentification et autorisation
- **Bean Validation** - Validation des données
- **CORS** - Cross-Origin Resource Sharing

#### Email & Notifications
- **Spring Mail** - Envoi d'emails
- **Thymeleaf** - Templates HTML pour emails

#### Documentation
- **Swagger/OpenAPI 3.0** - Documentation API
- **SpringDoc** - Génération automatique

#### Outils
- **Lombok** - Réduction du code boilerplate
- **MapStruct** - Mapping d'objets
- **Maven** - Gestion des dépendances

### Frontend

#### Framework Principal
- **Angular 18** - Framework TypeScript
- **TypeScript 5.5** - Langage typé

#### UI/UX
- **Tailwind CSS 3.4** - Framework CSS utility-first
- **Angular Material** - Composants UI
- **Font Awesome** - Icônes

#### Internationalisation
- **ngx-translate** - Traductions
- **@ngx-translate/core** - Core i18n
- **@ngx-translate/http-loader** - Chargement des traductions

#### HTTP & State Management
- **HttpClient** - Requêtes HTTP
- **RxJS** - Programmation réactive
- **Observables** - Gestion asynchrone

#### Routing
- **Angular Router** - Navigation
- **Guards** - Protection des routes

#### Outils de Développement
- **Angular CLI** - Ligne de commande
- **Vite** - Build tool rapide
- **ESLint** - Linting
- **Prettier** - Formatage du code

### DevOps & Outils

- **Git** - Contrôle de version
- **GitHub** - Hébergement du code
- **Postman** - Tests API
- **MySQL Workbench** - Gestion de base de données

---

## 📦 Installation

### Prérequis

- **Java 17+** - [Télécharger](https://www.oracle.com/java/technologies/downloads/)
- **Node.js 18+** - [Télécharger](https://nodejs.org/)
- **MySQL 8.0+** - [Télécharger](https://dev.mysql.com/downloads/)
- **Maven 3.8+** - [Télécharger](https://maven.apache.org/download.cgi)
- **Angular CLI** - `npm install -g @angular/cli`

### 1. Cloner les Repositories

```bash
# Backend (Spring Boot)
git clone https://github.com/brouri12/spring-app.git
cd spring-app
git checkout rahma

# Frontend (Angular)
git clone https://github.com/brouri12/angular-app.git
cd angular-app
git checkout rahma
```

### 2. Configuration de la Base de Données

```sql
-- Créer les bases de données
CREATE DATABASE forum_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE recrutement_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Créer un utilisateur (optionnel)
CREATE USER 'pidev_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON forum_db.* TO 'pidev_user'@'localhost';
GRANT ALL PRIVILEGES ON recrutement_db.* TO 'pidev_user'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Configuration Backend

#### Eureka Server
```bash
cd eureka-server
mvn clean install
mvn spring-boot:run
```
**Port**: 8761  
**URL**: http://localhost:8761

#### API Gateway
```bash
cd api-gateway
mvn clean install
mvn spring-boot:run
```
**Port**: 8888  
**URL**: http://localhost:8888

#### Forum Service
```bash
cd forum-service

# Configurer application.properties
# Voir section Configuration ci-dessous

mvn clean install
mvn spring-boot:run
```
**Port**: 8082  
**URL**: http://localhost:8082

#### Recrutement Service
```bash
cd recrutement-service
mvn clean install
mvn spring-boot:run
```
**Port**: 8083  
**URL**: http://localhost:8083

### 4. Configuration Frontend

#### Frontend Public
```bash
cd angular-app/frontend/angular-app
npm install
ng serve --port 4300
```
**Port**: 4300  
**URL**: http://localhost:4300

#### Back-Office
```bash
cd angular-app/back-office
npm install
ng serve --port 4301
```
**Port**: 4301  
**URL**: http://localhost:4301

---

## ⚙️ Configuration

### Backend Configuration

#### forum-service/src/main/resources/application.properties

```properties
# Server Configuration
server.port=8082
spring.application.name=forum-service

# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/forum_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Eureka Configuration
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true

# File Upload Configuration
spring.servlet.multipart.max-file-size=50MB
spring.servlet.multipart.max-request-size=50MB

# File Storage
forum.upload.dir=uploads/
forum.upload.images.max-size=5242880
forum.upload.audio.max-size=10485760
forum.upload.documents.max-size=20971520

# Email Configuration (Gmail)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=YOUR_EMAIL@gmail.com
spring.mail.password=YOUR_APP_PASSWORD
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true

# OpenAI Configuration (Optionnel)
forum.openai.api-key=YOUR_OPENAI_API_KEY_HERE
forum.openai.gpt-model=gpt-4
```

#### recrutement-service/src/main/resources/application.properties

```properties
# Server Configuration
server.port=8083
spring.application.name=recrutement-service

# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/recrutement_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.jpa.hibernate.ddl-auto=update

# Eureka Configuration
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/

# File Upload
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

### Frontend Configuration

#### angular-app/frontend/angular-app/src/environments/environment.ts

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8082/api/forum',
  recrutementApiUrl: 'http://localhost:8083/api/recrutement',
  gatewayUrl: 'http://localhost:8888'
};
```

---

## 🚀 Utilisation

### Démarrage Rapide

#### 1. Démarrer tous les services backend
```bash
# Terminal 1 - Eureka
cd eureka-server && mvn spring-boot:run

# Terminal 2 - Gateway
cd api-gateway && mvn spring-boot:run

# Terminal 3 - Forum Service
cd forum-service && mvn spring-boot:run

# Terminal 4 - Recrutement Service
cd recrutement-service && mvn spring-boot:run
```

#### 2. Démarrer le frontend
```bash
# Terminal 5 - Frontend Public
cd angular-app/frontend/angular-app && ng serve --port 4300

# Terminal 6 - Back-Office (optionnel)
cd angular-app/back-office && ng serve --port 4301
```

#### 3. Accéder à l'application
- **Frontend Public**: http://localhost:4300
- **Back-Office**: http://localhost:4301
- **Eureka Dashboard**: http://localhost:8761
- **Swagger Forum**: http://localhost:8082/swagger-ui.html
- **Swagger Recrutement**: http://localhost:8083/swagger-ui.html

### Fonctionnalités Principales

#### 1. Utiliser le Chatbot
1. Ouvrez http://localhost:4300
2. Cliquez sur l'icône de chat (coin inférieur droit)
3. Posez une question:
   - "Comment créer un forum?"
   - "Comment postuler à une offre?"
   - "Où trouver les cours?"

#### 2. Créer un Message avec Médias
1. Allez sur **Forums** dans le menu
2. Sélectionnez un forum
3. Cliquez **Nouveau Message**
4. Remplissez le titre et le contenu
5. Scrollez vers le bas
6. Section **Ajouter des médias**:
   - Cliquez **Choisir une image** (max 5MB)
   - Cliquez **Choisir un audio** (max 10MB)
   - Cliquez **Choisir un document** (max 20MB)
   - Collez une URL YouTube dans **Lien vidéo**
7. Cliquez **Publier**
8. Les médias s'affichent automatiquement sous le message

#### 3. Configurer les Préférences Email
1. Cliquez sur l'icône **email** dans le header
2. Cochez les notifications souhaitées:
   - ✉️ Nouveaux messages
   - 💬 Réponses
   - ❤️ Likes
   - 🔔 Mentions
3. Cliquez **Enregistrer les préférences**

#### 4. Postuler à une Offre
1. Allez sur **Recrutement**
2. Parcourez les offres disponibles
3. Cliquez **Postuler**
4. Remplissez le formulaire:
   - Nom, prénom, email
   - Téléphone
   - Upload CV (PDF, DOC, DOCX - max 2MB)
   - Lettre de motivation
5. Cliquez **Soumettre la candidature**

#### 5. Changer de Langue
1. Cliquez sur l'icône de langue dans le header
2. Sélectionnez **Français** ou **English**
3. L'interface se met à jour instantanément

---

## 📚 API Documentation

### Forum Service Endpoints

#### Messages
```http
GET    /api/forum/messages              # Liste tous les messages
GET    /api/forum/messages/{id}         # Détails d'un message
POST   /api/forum/messages              # Créer un message
PUT    /api/forum/messages/{id}         # Modifier un message
DELETE /api/forum/messages/{id}         # Supprimer un message
GET    /api/forum/forums/{id}/messages  # Messages d'un forum
```

#### Multimédia
```http
POST   /api/forum/multimedia/upload/image      # Upload image
POST   /api/forum/multimedia/upload/audio      # Upload audio
POST   /api/forum/multimedia/upload/document   # Upload document
POST   /api/forum/multimedia/embed/video       # Intégrer vidéo
GET    /api/forum/multimedia/file/{id}         # Télécharger fichier
GET    /api/forum/multimedia/thumbnail/{id}    # Miniature
DELETE /api/forum/multimedia/file/{id}         # Supprimer fichier
GET    /api/forum/multimedia/message/{id}      # Médias d'un message
GET    /api/forum/multimedia/gallery/{forumId} # Galerie forum
```

#### Email
```http
POST   /api/forum/email/preferences        # Créer préférences
GET    /api/forum/email/preferences/{id}   # Lire préférences
PUT    /api/forum/email/preferences/{id}   # Mettre à jour
POST   /api/forum/email/test               # Envoyer email test
```

#### Interactions
```http
POST   /api/forum/likes                    # Liker un message
DELETE /api/forum/likes/{id}               # Retirer un like
GET    /api/forum/messages/{id}/likes      # Likes d'un message
POST   /api/forum/replies                  # Répondre à un message
GET    /api/forum/messages/{id}/replies    # Réponses d'un message
```

### Recrutement Service Endpoints

#### Offres
```http
GET    /api/recrutement/offres             # Liste des offres
GET    /api/recrutement/offres/{id}        # Détails d'une offre
POST   /api/recrutement/offres             # Créer une offre
PUT    /api/recrutement/offres/{id}        # Modifier une offre
DELETE /api/recrutement/offres/{id}        # Supprimer une offre
```

#### Candidatures
```http
GET    /api/recrutement/candidatures       # Liste des candidatures
GET    /api/recrutement/candidatures/{id}  # Détails candidature
POST   /api/recrutement/candidatures       # Soumettre candidature
PUT    /api/recrutement/candidatures/{id}  # Mettre à jour statut
GET    /api/recrutement/candidatures/cv/{id} # Télécharger CV
```

### Documentation Interactive

- **Swagger Forum**: http://localhost:8082/swagger-ui.html
- **Swagger Recrutement**: http://localhost:8083/swagger-ui.html

---

## 🧪 Tests

### Tests Backend

```bash
# Tester tous les services
cd forum-service
mvn test

cd recrutement-service
mvn test
```

### Tests Frontend

```bash
# Tests unitaires
cd angular-app/frontend/angular-app
ng test

# Tests e2e
ng e2e
```

### Tests API avec Postman

Une collection Postman est disponible: `Microservices_Tests.postman_collection.json`

1. Importer la collection dans Postman
2. Configurer les variables d'environnement
3. Exécuter les tests

---

## 📊 Structure du Projet

### Backend Structure

```
spring-app/
├── eureka-server/              # Service Discovery
├── api-gateway/                # API Gateway
├── forum-service/              # Service Forum
│   ├── src/main/java/
│   │   └── tn/esprit/forum/
│   │       ├── controller/     # REST Controllers
│   │       ├── service/        # Business Logic
│   │       ├── repository/     # Data Access
│   │       ├── entity/         # JPA Entities
│   │       ├── dto/            # Data Transfer Objects
│   │       ├── config/         # Configuration
│   │       └── exception/      # Exception Handling
│   └── src/main/resources/
│       ├── application.properties
│       └── templates/          # Email Templates
└── recrutement-service/        # Service Recrutement
    └── (structure similaire)
```

### Frontend Structure

```
angular-app/
├── frontend/angular-app/       # Application Publique
│   ├── src/app/
│   │   ├── components/         # Composants réutilisables
│   │   │   ├── chatbot-widget/
│   │   │   ├── email-preferences/
│   │   │   ├── language-switcher/
│   │   │   └── modal/
│   │   ├── pages/              # Pages principales
│   │   │   ├── home/
│   │   │   ├── forums-public/
│   │   │   └── recrutement-public/
│   │   ├── services/           # Services Angular
│   │   │   ├── forum.service.ts
│   │   │   ├── multimedia.service.ts
│   │   │   ├── chatbot.service.ts
│   │   │   └── email-preference.service.ts
│   │   ├── models/             # Interfaces TypeScript
│   │   └── guards/             # Route Guards
│   └── public/i18n/            # Fichiers de traduction
│       ├── en.json
│       └── fr.json
└── back-office/                # Application Admin
    └── (structure similaire)
```

---

## 🤝 Contributeurs

- **Équipe de Développement** - Développement complet
- **Branche**: `rahma`
- **Repositories**:
  - Backend: https://github.com/brouri12/spring-app
  - Frontend: https://github.com/brouri12/angular-app

---

## 📝 License

Ce projet est développé dans un cadre éducatif.

---

## 📞 Support

Pour toute question ou problème:
1. Consultez la documentation dans le dossier `/docs`
2. Vérifiez les guides de dépannage
3. Ouvrez une issue sur GitHub

---

## 🎉 Remerciements

Merci à tous les contributeurs qui ont participé au développement de cette plateforme éducative.

---

**Développé avec ❤️ pour l'éducation**
