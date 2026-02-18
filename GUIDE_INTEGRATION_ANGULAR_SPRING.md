# 🔗 Guide d'Intégration Angular + Spring Boot

## 📋 Vue d'ensemble

Ce guide explique comment intégrer vos microservices Spring Boot (Forum et Recrutement) avec votre application Angular.

---

## ✅ Ce qui a été créé

### 1. Models TypeScript
- `angular-app/back-office/src/app/models/forum.model.ts`
- `angular-app/back-office/src/app/models/recrutement.model.ts`

### 2. Services Angular
- `angular-app/back-office/src/app/services/forum.service.ts`
- `angular-app/back-office/src/app/services/recrutement.service.ts`

### 3. Composants Angular
- `angular-app/back-office/src/app/pages/forum/` (forum.ts, forum.html, forum.css)
- `angular-app/back-office/src/app/pages/recrutement/` (recrutement.ts, recrutement.html, recrutement.css)

### 4. Configuration
- `angular-app/back-office/src/environments/environment.ts`
- `angular-app/back-office/src/environments/environment.prod.ts`
- Mise à jour de `app.config.ts` (HttpClient)
- Mise à jour de `app.routes.ts` (nouvelles routes)
- Mise à jour de `sidebar.ts` (nouveaux liens)

---

## 🚀 Démarrage

### 1. Démarrer les services Spring Boot

Dans l'ordre :

```cmd
# 1. MySQL
net start MySQL80

# 2. Eureka Server (port 8761)
cd eureka-server
mvn spring-boot:run

# 3. Forum Service (port 8082)
cd forum-service
mvn spring-boot:run

# 4. Recrutement Service (port 8083)
cd recrutement-service
mvn spring-boot:run

# 5. API Gateway (port 8080) - OPTIONNEL
cd api-gateway
mvn spring-boot:run
```

### 2. Démarrer l'application Angular

```cmd
cd angular-app/back-office
npm install
npm start
```

L'application sera accessible sur : `http://localhost:4200`

---

## 🔧 Configuration CORS (Spring Boot)

Pour permettre à Angular de communiquer avec vos services, CORS est déjà configuré avec `@CrossOrigin(origins = "*")` dans vos controllers.

Si vous voulez une configuration globale, ajoutez ceci dans chaque service :

```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("http://localhost:4200")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH")
                        .allowedHeaders("*")
                        .allowCredentials(true);
            }
        };
    }
}
```

---

## 📱 Utilisation dans Angular

### Accéder aux pages

- **Forum** : `http://localhost:4200/forum`
- **Recrutement** : `http://localhost:4200/recrutement`

### Navigation

Les liens sont disponibles dans la sidebar :
- Dashboard
- Courses
- Users
- **Forum** ← NOUVEAU
- **Recrutement** ← NOUVEAU
- Analytics

---

## 🎯 Fonctionnalités implémentées

### Forum
- ✅ Lister tous les forums
- ✅ Créer un nouveau forum
- ✅ Supprimer un forum
- ✅ Fermer un forum
- ✅ Afficher les messages d'un forum
- ✅ Créer un nouveau message
- ✅ Filtrage par statut

### Recrutement
- ✅ Lister toutes les offres
- ✅ Créer une nouvelle offre
- ✅ Supprimer une offre
- ✅ Fermer une offre
- ✅ Afficher les candidatures d'une offre
- ✅ Postuler à une offre
- ✅ Accepter/Refuser une candidature
- ✅ Filtrage par statut et spécialité

---

## 🔄 Architecture de communication

```
┌─────────────────┐
│  Angular App    │
│  (Port 4200)    │
└────────┬────────┘
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
      │ Eureka  │
      │  :8761  │
      └─────────┘
           │
           ▼
      ┌─────────┐
      │  MySQL  │
      │  :3306  │
      └─────────┘
```

---

## 🛠️ Personnalisation

### Changer les URLs des APIs

Modifiez `angular-app/back-office/src/environments/environment.ts` :

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api', // Via Gateway
  forumServiceUrl: 'http://localhost:8082/api/forum',
  recrutementServiceUrl: 'http://localhost:8083/api/recrutement'
};
```

### Ajouter un intercepteur HTTP

Pour gérer les erreurs globalement ou ajouter des headers :

```typescript
// http.interceptor.ts
import { HttpInterceptorFn } from '@angular/common/http';

export const httpInterceptor: HttpInterceptorFn = (req, next) => {
  const clonedRequest = req.clone({
    setHeaders: {
      'Content-Type': 'application/json',
      // Ajoutez vos headers ici
    }
  });
  return next(clonedRequest);
};
```

Puis dans `app.config.ts` :

```typescript
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { httpInterceptor } from './interceptors/http.interceptor';

providers: [
  provideHttpClient(withInterceptors([httpInterceptor]))
]
```

---

## 🐛 Dépannage

### Erreur CORS

**Symptôme** : `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution** :
1. Vérifiez que `@CrossOrigin(origins = "*")` est présent dans vos controllers
2. Redémarrez les services Spring Boot
3. Videz le cache du navigateur (Ctrl+Shift+Delete)

### Erreur 404 Not Found

**Symptôme** : `GET http://localhost:8082/api/forum/forums 404`

**Solution** :
1. Vérifiez que le service Spring Boot est démarré
2. Testez l'URL directement dans le navigateur
3. Vérifiez les logs du service

### Erreur de connexion

**Symptôme** : `HttpErrorResponse: 0 Unknown Error`

**Solution** :
1. Vérifiez que MySQL est démarré
2. Vérifiez que tous les services Spring Boot sont démarrés
3. Vérifiez les URLs dans `environment.ts`

### Les données ne s'affichent pas

**Solution** :
1. Ouvrez la console du navigateur (F12)
2. Vérifiez l'onglet Network pour voir les requêtes HTTP
3. Vérifiez l'onglet Console pour les erreurs JavaScript
4. Vérifiez les logs des services Spring Boot

---

## 📊 Tests

### Tester les services Angular

```cmd
cd angular-app/back-office
npm test
```

### Tester les APIs avec curl

```bash
# Forum - Lister tous les forums
curl http://localhost:8082/api/forum/forums

# Recrutement - Lister toutes les offres
curl http://localhost:8083/api/recrutement/offres
```

### Tester avec Swagger

- Forum : `http://localhost:8082/swagger-ui/index.html`
- Recrutement : `http://localhost:8083/swagger-ui/index.html`

---

## 🎨 Personnalisation du style

Les composants utilisent Tailwind CSS. Pour personnaliser :

1. Modifiez les classes dans les fichiers `.html`
2. Ajoutez des styles personnalisés dans les fichiers `.css`
3. Modifiez `tailwind.config.js` pour les couleurs globales

---

## 📚 Ressources

- [Documentation Angular](https://angular.dev)
- [Documentation Spring Boot](https://spring.io/projects/spring-boot)
- [Documentation Tailwind CSS](https://tailwindcss.com)
- [Documentation RxJS](https://rxjs.dev)

---

## ✨ Prochaines étapes

1. **Authentification** : Ajouter JWT pour sécuriser les APIs
2. **Pagination** : Implémenter la pagination pour les listes
3. **Recherche** : Ajouter des filtres de recherche avancés
4. **Upload de fichiers** : Permettre l'upload de CV
5. **Notifications** : Ajouter des notifications en temps réel
6. **Tests** : Écrire des tests unitaires et e2e

---

## 🎉 Félicitations !

Votre application Angular est maintenant intégrée avec vos microservices Spring Boot !

Pour toute question, consultez les logs ou la documentation.
