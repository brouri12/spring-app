# 🔧 Configuration Angular avec API Gateway

## 📝 URLs Correctes

### Architecture des URLs

```
┌─────────────────────────────────────────────────────────────┐
│                     API Gateway (Port 8086)                 │
└─────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
┌──────────────────┐              ┌──────────────────┐
│  Forum Service   │              │ Recrutement Svc  │
│   Port 8082      │              │   Port 8083      │
└──────────────────┘              └──────────────────┘
```

### Mapping des URLs

#### Forum Service

| Accès | URL Complète | Explication |
|-------|--------------|-------------|
| Direct | `http://localhost:8082/api/forum/forums` | Accès direct au service |
| Via Gateway | `http://localhost:8086/forum/api/forum/forums` | Via Gateway avec préfixe `/forum` |

**Détail du routing Gateway :**
```
Client → http://localhost:8086/forum/api/forum/forums
         ↓ Gateway détecte /forum/**
         ↓ StripPrefix=1 retire /forum
Service ← http://localhost:8082/api/forum/forums
```

#### Recrutement Service

| Accès | URL Complète | Explication |
|-------|--------------|-------------|
| Direct | `http://localhost:8083/api/recrutement/offres` | Accès direct au service |
| Via Gateway | `http://localhost:8086/recrutement/api/recrutement/offres` | Via Gateway avec préfixe `/recrutement` |

**Détail du routing Gateway :**
```
Client → http://localhost:8086/recrutement/api/recrutement/offres
         ↓ Gateway détecte /recrutement/**
         ↓ StripPrefix=1 retire /recrutement
Service ← http://localhost:8083/api/recrutement/offres
```

## ✅ Configuration Angular Correcte

### Fichiers d'environnement mis à jour

#### `environment.ts` (Development)

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8086', // API Gateway
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

#### `environment.prod.ts` (Production)

```typescript
export const environment = {
  production: true,
  apiUrl: 'http://localhost:8086', // API Gateway
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

## 📋 Endpoints Complets

### Forum Service

Les services Angular ajoutent `/forums` ou `/messages` à `forumServiceUrl`.

| Méthode Service | URL Finale |
|----------------|------------|
| `getAllForums()` | `http://localhost:8086/forum/api/forum/forums` |
| `getForumById(1)` | `http://localhost:8086/forum/api/forum/forums/1` |
| `createForum()` | `POST http://localhost:8086/forum/api/forum/forums` |
| `getAllMessages()` | `http://localhost:8086/forum/api/forum/messages` |
| `getMessagesByForum(1)` | `http://localhost:8086/forum/api/forum/messages/forum/1` |

### Recrutement Service

Les services Angular ajoutent `/offres` ou `/candidatures` à `recrutementServiceUrl`.

| Méthode Service | URL Finale |
|----------------|------------|
| `getAllOffres()` | `http://localhost:8086/recrutement/api/recrutement/offres` |
| `getOffreById(1)` | `http://localhost:8086/recrutement/api/recrutement/offres/1` |
| `createOffre()` | `POST http://localhost:8086/recrutement/api/recrutement/offres` |
| `getAllCandidatures()` | `http://localhost:8086/recrutement/api/recrutement/candidatures` |
| `postuler(1, data)` | `POST http://localhost:8086/recrutement/api/recrutement/candidatures?offreId=1` |

## 🚀 Redémarrer l'Application Angular

Après avoir mis à jour les fichiers d'environnement, redémarrez l'application :

### Back-Office

```bash
cd angular-app/back-office
ng serve
```

Ou si déjà démarré, arrêtez (Ctrl+C) et redémarrez.

### Frontend

```bash
cd angular-app/frontend/angular-app
ng serve --port 4201
```

## 🧪 Tester les URLs

### Test 1 : Forum via Gateway (Navigateur)

Ouvrez : **http://localhost:8086/forum/api/forum/forums**

Résultat attendu :
```json
[
  {
    "id_forum": 1,
    "titre": "Forum Général",
    "description": "Discussion générale",
    ...
  }
]
```

### Test 2 : Recrutement via Gateway (Navigateur)

Ouvrez : **http://localhost:8086/recrutement/api/recrutement/offres**

Résultat attendu :
```json
[
  {
    "id_offre": 1,
    "titre": "Enseignant Java",
    "description": "Poste d'enseignant",
    ...
  }
]
```

### Test 3 : Depuis l'Application Angular

1. Ouvrez le back-office : **http://localhost:4200**
2. Ouvrez la console du navigateur (F12)
3. Naviguez vers la page Forum ou Recrutement
4. Vérifiez les requêtes HTTP dans l'onglet Network

Vous devriez voir des requêtes vers :
- `http://localhost:8086/forum/api/forum/forums`
- `http://localhost:8086/recrutement/api/recrutement/offres`

## 🔍 Vérifier les Requêtes HTTP

### Dans Chrome DevTools

1. Ouvrez DevTools (F12)
2. Allez dans l'onglet **Network**
3. Filtrez par **XHR** ou **Fetch**
4. Rechargez la page
5. Vérifiez les URLs des requêtes

### Requêtes Attendues

```
✅ GET http://localhost:8086/forum/api/forum/forums → 200 OK
✅ GET http://localhost:8086/recrutement/api/recrutement/offres → 200 OK
```

### Erreurs Possibles

```
❌ GET http://localhost:8086/forum → 404 Not Found
   → Problème : URL incorrecte, manque /api/forum/forums

❌ GET http://localhost:8082/api/forum/forums → CORS Error
   → Problème : Accès direct au service au lieu du Gateway

❌ GET http://localhost:8086/forum/api/forum/forums → 503 Service Unavailable
   → Problème : Service non enregistré dans Eureka
```

## ⚙️ Configuration Gateway (Référence)

Dans `api-gateway/src/main/resources/application.properties` :

```properties
# Route Forum Service
spring.cloud.gateway.routes[0].id=forum-service
spring.cloud.gateway.routes[0].uri=lb://forum-service
spring.cloud.gateway.routes[0].predicates[0]=Path=/forum/**
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=1

# Route Recrutement Service
spring.cloud.gateway.routes[1].id=recrutement-service
spring.cloud.gateway.routes[1].uri=lb://recrutement-service
spring.cloud.gateway.routes[1].predicates[0]=Path=/recrutement/**
spring.cloud.gateway.routes[1].filters[0]=StripPrefix=1

# CORS
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-origins=*
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-methods=GET,POST,PUT,DELETE,PATCH,OPTIONS
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-headers=*
```

## 📊 Checklist de Vérification

- [ ] Fichiers `environment.ts` mis à jour avec port 8086
- [ ] Fichiers `environment.prod.ts` mis à jour avec port 8086
- [ ] API Gateway redémarré avec `StripPrefix=1`
- [ ] Forum Service enregistré dans Eureka (http://localhost:8761)
- [ ] Recrutement Service enregistré dans Eureka
- [ ] Application Angular redémarrée
- [ ] Test URL Forum : http://localhost:8086/forum/api/forum/forums
- [ ] Test URL Recrutement : http://localhost:8086/recrutement/api/recrutement/offres
- [ ] Pas d'erreurs CORS dans la console
- [ ] Pas d'erreurs 404 dans la console

## 🎯 Résumé

### Avant (❌ Ne fonctionnait pas)

```typescript
// Port incorrect
forumServiceUrl: 'http://localhost:8082/api/forum'

// Gateway avec StripPrefix=0
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=0
```

### Après (✅ Fonctionne)

```typescript
// Port correct + préfixe Gateway
forumServiceUrl: 'http://localhost:8086/forum/api/forum'

// Gateway avec StripPrefix=1
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=1
```

## 💡 Conseils

1. **Toujours utiliser le Gateway** en production (port 8086)
2. **Accès direct** (ports 8082, 8083) uniquement pour le développement/debug
3. **Vérifier Eureka** avant de tester le Gateway
4. **Redémarrer Angular** après modification des fichiers d'environnement
5. **Vérifier la console** du navigateur pour les erreurs HTTP

## 🐛 Dépannage

### Erreur : "Failed to load resource: 404"

**Cause** : URL incorrecte ou service non accessible

**Solutions** :
1. Vérifier l'URL dans la console du navigateur
2. Tester l'URL directement dans le navigateur
3. Vérifier que le service est UP dans Eureka
4. Vérifier les logs du Gateway

### Erreur : "CORS policy"

**Cause** : Configuration CORS du Gateway

**Solution** : Vérifier la configuration CORS dans `application.properties` du Gateway

### Erreur : "503 Service Unavailable"

**Cause** : Service non trouvé par le Gateway

**Solutions** :
1. Vérifier que le service est enregistré dans Eureka
2. Attendre 30 secondes que le Gateway rafraîchisse
3. Redémarrer le Gateway

---

✅ Avec cette configuration, votre application Angular communique correctement avec les microservices via l'API Gateway !
