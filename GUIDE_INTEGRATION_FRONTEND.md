# 🎨 Guide d'Intégration Frontend (Application Publique)

## 📋 Vue d'ensemble

Ce guide explique l'intégration des microservices Spring Boot avec l'application Angular frontend (application publique).

---

## ✅ Ce qui a été créé

### 1. Models TypeScript
- `angular-app/frontend/angular-app/src/app/models/forum.model.ts`
- `angular-app/frontend/angular-app/src/app/models/recrutement.model.ts`

### 2. Services Angular
- `angular-app/frontend/angular-app/src/app/services/forum.service.ts`
- `angular-app/frontend/angular-app/src/app/services/recrutement.service.ts`

### 3. Composants Publics
- `angular-app/frontend/angular-app/src/app/pages/forums-public/` (forums-public.ts, .html, .css)
- `angular-app/frontend/angular-app/src/app/pages/recrutement-public/` (recrutement-public.ts, .html, .css)

### 4. Configuration
- `angular-app/frontend/angular-app/src/environments/environment.ts`
- `angular-app/frontend/angular-app/src/environments/environment.prod.ts`
- Mise à jour de `app.config.ts` (HttpClient)
- Mise à jour de `app.routes.ts` (nouvelles routes)

---

## 🚀 Démarrage

### 1. Démarrer les services Backend

```cmd
# MySQL
net start MySQL80

# Eureka Server
cd eureka-server
start mvn spring-boot:run

# Forum Service
cd forum-service
start mvn spring-boot:run

# Recrutement Service
cd recrutement-service
start mvn spring-boot:run
```

### 2. Démarrer l'application Frontend

```cmd
cd angular-app/frontend/angular-app
npm install
npm start
```

L'application sera accessible sur : `http://localhost:4200`

---

## 🎯 Fonctionnalités implémentées

### Page Forums (`/forums`)
- ✅ Afficher tous les forums ouverts
- ✅ Voir les messages d'un forum
- ✅ Poster un nouveau message
- ✅ Rechercher dans les messages
- ✅ Filtrage par niveau et groupe
- ✅ Interface utilisateur moderne et responsive

### Page Recrutement (`/recrutement`)
- ✅ Afficher toutes les offres ouvertes
- ✅ Filtrer par spécialité
- ✅ Voir les détails d'une offre
- ✅ Postuler à une offre
- ✅ Validation des dates limites
- ✅ Formulaire de candidature complet
- ✅ Messages de succès/erreur

---

## 📱 Navigation

### URLs disponibles

- **Accueil** : `http://localhost:4200/`
- **Cours** : `http://localhost:4200/courses`
- **À propos** : `http://localhost:4200/about`
- **Tarifs** : `http://localhost:4200/pricing`
- **Forums** : `http://localhost:4200/forums` ← NOUVEAU
- **Recrutement** : `http://localhost:4200/recrutement` ← NOUVEAU

---

## 🎨 Design et UX

### Forums
- Layout en 2 colonnes (liste + détails)
- Badges colorés pour les niveaux et groupes
- Distinction visuelle entre étudiants et enseignants
- Barre de recherche intégrée
- Formulaire de message contextuel

### Recrutement
- Header avec gradient attractif
- Filtrage par spécialité
- Cards d'offres avec informations clés
- Formulaire de candidature détaillé
- Validation des dates d'expiration
- Messages de feedback utilisateur

---

## 🔧 Configuration CORS

Les services Spring Boot doivent autoriser les requêtes depuis `http://localhost:4200`.

La configuration CORS a été ajoutée dans :
- `forum-service/src/main/java/tn/esprit/forum/config/CorsConfig.java`
- `recrutement-service/src/main/java/tn/esprit/recrutement/config/CorsConfig.java`

---

## 📊 Architecture

```
┌──────────────────┐
│  Frontend App    │
│  (Port 4200)     │
│                  │
│  - Forums        │
│  - Recrutement   │
└────────┬─────────┘
         │
         │ HTTP Requests
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌────────────┐
│ Forum  │ │Recrutement │
│ :8082  │ │   :8083    │
└────┬───┘ └─────┬──────┘
     │           │
     └─────┬─────┘
           │
           ▼
      ┌─────────┐
      │  MySQL  │
      │  :3306  │
      └─────────┘
```

---

## 🛠️ Personnalisation

### Modifier les URLs des APIs

Éditez `angular-app/frontend/angular-app/src/environments/environment.ts` :

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api',
  forumServiceUrl: 'http://localhost:8082/api/forum',
  recrutementServiceUrl: 'http://localhost:8083/api/recrutement'
};
```

### Ajouter un lien dans la navigation

Éditez le composant de navigation (header/navbar) et ajoutez :

```html
<a routerLink="/forums">Forums</a>
<a routerLink="/recrutement">Recrutement</a>
```

### Personnaliser les couleurs

Les composants utilisent Tailwind CSS. Modifiez `tailwind.config.js` :

```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        secondary: '#8B5CF6',
      }
    }
  }
}
```

---

## 🐛 Dépannage

### Erreur CORS

**Symptôme** : `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution** :
1. Vérifiez que `CorsConfig.java` existe dans les services
2. Redémarrez les services Spring Boot : `mvn clean install && mvn spring-boot:run`
3. Videz le cache du navigateur (Ctrl+Shift+Delete)

### Erreur 404 Not Found

**Symptôme** : `GET http://localhost:8082/api/forum/forums 404`

**Solution** :
1. Vérifiez que le service est démarré : `curl http://localhost:8082/api/forum/forums`
2. Vérifiez les logs du service Spring Boot
3. Testez avec Swagger : `http://localhost:8082/swagger-ui/index.html`

### Les données ne s'affichent pas

**Solution** :
1. Ouvrez la console du navigateur (F12)
2. Vérifiez l'onglet Network pour voir les requêtes
3. Vérifiez l'onglet Console pour les erreurs
4. Assurez-vous que MySQL est démarré

### Port 4200 déjà utilisé

**Solution** :
```cmd
# Trouver le processus
netstat -ano | findstr :4200

# Tuer le processus (remplacez PID par le numéro trouvé)
taskkill /PID <PID> /F

# Ou démarrer sur un autre port
ng serve --port 4201
```

---

## ✨ Fonctionnalités avancées à ajouter

### Authentification
- Login/Register
- JWT tokens
- Guards pour les routes protégées

### Pagination
- Implémenter la pagination pour les listes
- Lazy loading des messages

### Upload de fichiers
- Permettre l'upload de CV directement
- Stockage sur serveur ou cloud

### Notifications
- Notifications en temps réel (WebSocket)
- Emails de confirmation

### Recherche avancée
- Filtres multiples
- Tri personnalisé
- Recherche full-text

---

## 📚 Structure des fichiers

```
angular-app/frontend/angular-app/src/
├── app/
│   ├── models/
│   │   ├── forum.model.ts
│   │   └── recrutement.model.ts
│   ├── services/
│   │   ├── forum.service.ts
│   │   └── recrutement.service.ts
│   ├── pages/
│   │   ├── forums-public/
│   │   │   ├── forums-public.ts
│   │   │   ├── forums-public.html
│   │   │   └── forums-public.css
│   │   └── recrutement-public/
│   │       ├── recrutement-public.ts
│   │       ├── recrutement-public.html
│   │       └── recrutement-public.css
│   ├── app.config.ts
│   └── app.routes.ts
└── environments/
    ├── environment.ts
    └── environment.prod.ts
```

---

## 🎉 Félicitations !

Votre application frontend est maintenant intégrée avec vos microservices Spring Boot !

### Prochaines étapes

1. Testez toutes les fonctionnalités
2. Ajoutez des tests unitaires
3. Optimisez les performances
4. Déployez en production

---

## 📞 Support

Pour toute question :
- Consultez les logs des services Spring Boot
- Vérifiez la console du navigateur (F12)
- Testez les APIs avec Swagger
- Consultez `GUIDE_INTEGRATION_ANGULAR_SPRING.md` pour plus de détails
