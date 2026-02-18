# 🎓 Application Forum & Recrutement - Documentation Complète

## 📖 Vue d'Ensemble

Application web complète avec architecture microservices pour la gestion de forums de discussion et d'offres de recrutement pour un établissement d'enseignement.

### 🎨 Design
- **Palette de couleurs** : Vert `rgb(0,200,151)` et Orange `rgb(255,127,80)`
- **Interface moderne** : Design responsive avec mode sombre
- **Animations fluides** : Transitions et effets hover
- **Notifications toast** : Feedback utilisateur en temps réel

### 🏗️ Architecture

```
Frontend Angular (Port dynamique)
         ↓
API Gateway (8080)
         ↓
Eureka Server (8761)
         ↓
    ┌────┴────┐
    ↓         ↓
Forum      Recrutement
Service    Service
(8082)     (8083)
    ↓         ↓
forum_db   recrutement_db
```

---

## 🚀 Démarrage Rapide

### Méthode 1 : Scripts Automatiques (Recommandé)

#### 1. Démarrer tous les services backend
```cmd
START_ALL_SERVICES.bat
```

#### 2. Démarrer le frontend
```cmd
START_FRONTEND.bat
```

### Méthode 2 : Démarrage Manuel

#### 1. MySQL
```cmd
net start MySQL80
```

#### 2. Eureka Server
```cmd
cd eureka-server
mvn spring-boot:run
```

#### 3. Forum Service
```cmd
cd forum-service
mvn spring-boot:run
```

#### 4. Recrutement Service
```cmd
cd recrutement-service
mvn spring-boot:run
```

#### 5. API Gateway
```cmd
cd api-gateway
mvn spring-boot:run
```

#### 6. Frontend Angular
```cmd
cd angular-app\frontend\angular-app
npm start
```

---

## 📁 Structure du Projet

```
pidev4/
├── eureka-server/              # Service Discovery (8761)
├── api-gateway/                # API Gateway (8080)
├── forum-service/              # Microservice Forum (8082)
│   ├── src/main/java/tn/esprit/forum/
│   │   ├── config/
│   │   │   └── CorsConfig.java         # Configuration CORS
│   │   ├── controller/
│   │   │   ├── ForumController.java
│   │   │   └── MessageForumController.java
│   │   ├── entity/
│   │   │   ├── Forum.java
│   │   │   └── MessageForum.java
│   │   ├── repository/
│   │   ├── service/
│   │   └── ForumApplication.java
│   └── src/main/resources/
│       └── application.properties
├── recrutement-service/        # Microservice Recrutement (8083)
│   ├── src/main/java/tn/esprit/recrutement/
│   │   ├── config/
│   │   │   └── CorsConfig.java         # Configuration CORS
│   │   ├── controller/
│   │   │   ├── OffreRecrutementController.java
│   │   │   └── CandidatureController.java
│   │   ├── entity/
│   │   │   ├── OffreRecrutement.java
│   │   │   └── CandidatureEnseignant.java
│   │   ├── repository/
│   │   ├── service/
│   │   └── RecrutementApplication.java
│   └── src/main/resources/
│       └── application.properties
└── angular-app/
    ├── back-office/            # Interface d'administration
    └── frontend/
        └── angular-app/        # Interface publique
            ├── src/app/
            │   ├── components/
            │   │   ├── header/             # Navbar
            │   │   └── notification/       # Système de notifications
            │   ├── pages/
            │   │   ├── forums-public/      # Page Forums
            │   │   └── recrutement-public/ # Page Recrutement
            │   ├── models/
            │   │   ├── forum.model.ts
            │   │   └── recrutement.model.ts
            │   ├── services/
            │   │   ├── forum.service.ts
            │   │   ├── recrutement.service.ts
            │   │   ├── notification.service.ts
            │   │   └── theme.ts
            │   ├── interceptors/
            │   │   └── http-error.interceptor.ts
            │   └── app.routes.ts
            └── src/environments/
                └── environment.ts
```

---

## 🔧 Configuration

### Backend (Spring Boot)

#### Forum Service - application.properties
```properties
spring.application.name=forum-service
server.port=8082
spring.datasource.url=jdbc:mysql://localhost:3306/forum_db
spring.datasource.username=root
spring.datasource.password=
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

#### Recrutement Service - application.properties
```properties
spring.application.name=recrutement-service
server.port=8083
spring.datasource.url=jdbc:mysql://localhost:3306/recrutement_db
spring.datasource.username=root
spring.datasource.password=
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

#### Configuration CORS (Les 2 services)
```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOriginPatterns("http://localhost:*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(true)
                        .maxAge(3600);
            }
        };
    }
}
```

### Frontend (Angular)

#### environment.ts
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api',
  forumServiceUrl: 'http://localhost:8082/api/forum',
  recrutementServiceUrl: 'http://localhost:8083/api/recrutement'
};
```

---

## 🎯 Fonctionnalités

### 📝 Forums de Discussion

#### Fonctionnalités Utilisateur
- ✅ Consultation des forums ouverts
- ✅ Affichage des messages par forum
- ✅ Création de nouveaux messages
- ✅ Recherche dans les messages
- ✅ Filtrage par statut (OUVERT/FERME)

#### Fonctionnalités Techniques
- ✅ CRUD complet via API REST
- ✅ Swagger UI pour tester les endpoints
- ✅ Données de test pré-insérées
- ✅ Gestion des statuts (ACTIF/ARCHIVE)
- ✅ Types d'auteurs (ETUDIANT/ENSEIGNANT)

### 💼 Recrutement

#### Fonctionnalités Utilisateur
- ✅ Consultation des offres ouvertes
- ✅ Filtrage par spécialité
- ✅ Affichage des détails d'une offre
- ✅ Formulaire de candidature
- ✅ Validation de la date limite

#### Fonctionnalités Techniques
- ✅ CRUD complet via API REST
- ✅ Swagger UI pour tester les endpoints
- ✅ Données de test pré-insérées
- ✅ Gestion des statuts (OUVERTE/FERMEE/POURVUE)
- ✅ Statuts de candidature (EN_ATTENTE/ACCEPTEE/REFUSEE)

---

## 🌐 Endpoints API

### Forum Service (8082)

#### Forums
- `GET /api/forum/forums` - Liste tous les forums
- `GET /api/forum/forums/{id}` - Détails d'un forum
- `GET /api/forum/forums/statut/{statut}` - Forums par statut
- `POST /api/forum/forums` - Créer un forum
- `PUT /api/forum/forums/{id}` - Modifier un forum
- `DELETE /api/forum/forums/{id}` - Supprimer un forum

#### Messages
- `GET /api/forum/messages` - Liste tous les messages
- `GET /api/forum/messages/{id}` - Détails d'un message
- `GET /api/forum/messages/forum/{forumId}` - Messages d'un forum
- `GET /api/forum/messages/search?keyword={keyword}` - Recherche
- `POST /api/forum/messages/forum/{forumId}` - Créer un message
- `PUT /api/forum/messages/{id}` - Modifier un message
- `DELETE /api/forum/messages/{id}` - Supprimer un message

### Recrutement Service (8083)

#### Offres
- `GET /api/recrutement/offres` - Liste toutes les offres
- `GET /api/recrutement/offres/{id}` - Détails d'une offre
- `GET /api/recrutement/offres/statut/{statut}` - Offres par statut
- `GET /api/recrutement/offres/specialite/{specialite}` - Offres par spécialité
- `POST /api/recrutement/offres` - Créer une offre
- `PUT /api/recrutement/offres/{id}` - Modifier une offre
- `DELETE /api/recrutement/offres/{id}` - Supprimer une offre

#### Candidatures
- `GET /api/recrutement/candidatures` - Liste toutes les candidatures
- `GET /api/recrutement/candidatures/{id}` - Détails d'une candidature
- `GET /api/recrutement/candidatures/offre/{offreId}` - Candidatures d'une offre
- `POST /api/recrutement/candidatures/offre/{offreId}` - Postuler
- `PUT /api/recrutement/candidatures/{id}` - Modifier une candidature
- `DELETE /api/recrutement/candidatures/{id}` - Supprimer une candidature

---

## 🎨 Interface Utilisateur

### Navigation
- **Accueil** : Page d'accueil avec présentation
- **Courses** : Liste des cours
- **Forums** : Forums de discussion publics
- **Recrutement** : Offres de recrutement
- **Pricing** : Tarifs
- **About** : À propos

### Composants Principaux

#### Header (Navbar)
- Logo "Wordly" avec gradient vert → orange
- Navigation desktop et mobile
- Bouton de changement de thème (clair/sombre)
- Boutons "Sign In" et "Get Started"

#### Notifications Toast
- **Success** : Fond vert, icône checkmark
- **Error** : Fond rouge, icône X
- **Info** : Fond bleu, icône i
- **Warning** : Fond orange, icône !
- Auto-dismiss après 5 secondes
- Animation slide-in depuis la droite

#### Page Forums
- Liste des forums avec badges (niveau, groupe)
- Sélection d'un forum pour voir les messages
- Formulaire de création de message
- Barre de recherche
- Avatars colorés (vert pour étudiants, orange pour enseignants)

#### Page Recrutement
- Liste des offres avec badges (type contrat, postes)
- Filtre par spécialité
- Détails de l'offre sélectionnée
- Formulaire de candidature
- Validation de la date limite

---

## 🐛 Résolution des Problèmes

### Erreur CORS
**Symptôme** : "Access to XMLHttpRequest has been blocked by CORS policy"

**Solution** :
```cmd
RESTART_BACKEND.bat
```
Ou manuellement :
```cmd
cd forum-service
mvn clean install
mvn spring-boot:run
```

### Port déjà utilisé
**Symptôme** : "Port 8082 is already in use"

**Solution** :
```cmd
netstat -ano | findstr :8082
taskkill /PID <PID> /F
```

### MySQL non démarré
**Symptôme** : "Communications link failure"

**Solution** :
```cmd
net start MySQL80
```

### Erreurs de compilation Angular
**Solution** :
```cmd
cd angular-app\frontend\angular-app
rmdir /s /q node_modules
del package-lock.json
npm install
```

---

## 📚 Documentation Disponible

- `GUIDE_DEMARRAGE_COMPLET.md` - Guide de démarrage détaillé
- `GUIDE_TEST_COMPLET.md` - Checklist de tests complète
- `INTEGRATION_COMPLETE.md` - Détails de l'intégration
- `CORRECTION_CORS_PORT.md` - Configuration CORS
- `START_ALL_SERVICES.bat` - Script de démarrage backend
- `START_FRONTEND.bat` - Script de démarrage frontend
- `STOP_ALL_SERVICES.bat` - Script d'arrêt
- `RESTART_BACKEND.bat` - Script de redémarrage backend

---

## 🔐 Sécurité

### Développement
- CORS configuré pour accepter tous les ports localhost
- Credentials autorisés pour les cookies/sessions
- Headers autorisés : tous (*)

### Production (À implémenter)
- [ ] Spécifier les domaines exacts autorisés
- [ ] Configurer HTTPS
- [ ] Limiter les méthodes HTTP
- [ ] Implémenter l'authentification JWT
- [ ] Ajouter la validation des entrées
- [ ] Configurer les rate limits

---

## 📊 Technologies Utilisées

### Backend
- **Java 17**
- **Spring Boot 3.x**
- **Spring Cloud (Eureka, Gateway)**
- **MySQL 8.0**
- **Maven**
- **Swagger/OpenAPI**

### Frontend
- **Angular 21**
- **TypeScript**
- **Tailwind CSS**
- **RxJS**
- **Angular Router**
- **Angular Forms**

---

## 🎉 Statut du Projet

✅ **COMPLET ET FONCTIONNEL**

- [x] Architecture microservices opérationnelle
- [x] Services backend avec CRUD complet
- [x] Configuration CORS flexible
- [x] Interface Angular moderne et responsive
- [x] Système de notifications toast
- [x] Design cohérent avec palette de couleurs
- [x] Mode sombre fonctionnel
- [x] Documentation complète
- [x] Scripts de démarrage automatiques

---

## 👥 Utilisation

### Pour les Développeurs
1. Cloner le projet
2. Configurer MySQL
3. Exécuter `START_ALL_SERVICES.bat`
4. Exécuter `START_FRONTEND.bat`
5. Accéder à http://localhost:4200 (ou le port affiché)

### Pour les Testeurs
1. Suivre le `GUIDE_TEST_COMPLET.md`
2. Vérifier toutes les fonctionnalités
3. Remplir le rapport de test

### Pour les Utilisateurs Finaux
1. Accéder à l'application via le navigateur
2. Naviguer entre Forums et Recrutement
3. Consulter, créer des messages, postuler aux offres

---

## 📞 Support

En cas de problème :
1. Consulter la section "Résolution des Problèmes"
2. Vérifier les logs des services
3. Consulter la documentation spécifique
4. Vérifier que tous les services sont démarrés

---

## 🚀 Prochaines Étapes (Optionnel)

- [ ] Authentification et autorisation (JWT)
- [ ] Upload de fichiers (CV, documents)
- [ ] Notifications en temps réel (WebSocket)
- [ ] Pagination des résultats
- [ ] Export de données (PDF, Excel)
- [ ] Statistiques et analytics
- [ ] Tests unitaires et d'intégration
- [ ] CI/CD Pipeline
- [ ] Containerisation (Docker)
- [ ] Déploiement cloud

---

**Version** : 1.0.0  
**Date** : Février 2026  
**Statut** : Production Ready
