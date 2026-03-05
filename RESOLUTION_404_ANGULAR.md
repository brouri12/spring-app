# 🔧 Résolution Erreur 404 Angular

## 🔴 Erreur Observée

```
Failed to load resource: the server responded with a status of 404 (Not Found)
forum:1
```

## 🎯 Cause du Problème

L'application Angular utilisait l'ancien port du Gateway (8080) au lieu du nouveau port (8086).

## ✅ Solution Appliquée

### 1. Fichiers Modifiés

Les fichiers d'environnement Angular ont été mis à jour :

#### `angular-app/back-office/src/environments/environment.ts`
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8086',
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

#### `angular-app/back-office/src/environments/environment.prod.ts`
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://localhost:8086',
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

#### `angular-app/frontend/angular-app/src/environments/environment.ts`
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8086',
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

#### `angular-app/frontend/angular-app/src/environments/environment.prod.ts`
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://localhost:8086',
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

### 2. Configuration Gateway

Le Gateway a également été corrigé avec `StripPrefix=1` :

```properties
# api-gateway/src/main/resources/application.properties
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=1
spring.cloud.gateway.routes[1].filters[0]=StripPrefix=1
```

## 🚀 Étapes pour Appliquer

### Étape 1 : Redémarrer l'API Gateway

Si le Gateway est en cours d'exécution :

```bash
# Arrêter (Ctrl+C dans le terminal)
# Puis redémarrer :
cd api-gateway
mvnw spring-boot:run
```

Ou utilisez :
```bash
REDEMARRER_GATEWAY.bat
```

### Étape 2 : Redémarrer l'Application Angular

Si Angular est en cours d'exécution :

```bash
# Arrêter (Ctrl+C dans le terminal)
# Puis redémarrer :
cd angular-app/back-office
ng serve
```

Ou utilisez :
```bash
REDEMARRER_ANGULAR.bat
```

### Étape 3 : Vider le Cache du Navigateur

1. Ouvrez DevTools (F12)
2. Cliquez droit sur le bouton Refresh
3. Sélectionnez "Empty Cache and Hard Reload"

Ou utilisez : `Ctrl + Shift + R`

## 🧪 Vérification

### Test 1 : Vérifier les URLs dans la Console

1. Ouvrez l'application : http://localhost:4200
2. Ouvrez DevTools (F12)
3. Allez dans l'onglet **Network**
4. Rechargez la page
5. Vérifiez les requêtes HTTP

**URLs Attendues :**
```
✅ http://localhost:8086/forum/api/forum/forums
✅ http://localhost:8086/recrutement/api/recrutement/offres
```

**URLs Incorrectes (anciennes) :**
```
❌ http://localhost:8080/... (ancien port)
❌ http://localhost:8082/... (accès direct)
❌ http://localhost:8086/forum (manque /api/forum/...)
```

### Test 2 : Tester les URLs Directement

Ouvrez dans le navigateur :

**Forum :**
```
http://localhost:8086/forum/api/forum/forums
```

Résultat attendu : JSON avec la liste des forums

**Recrutement :**
```
http://localhost:8086/recrutement/api/recrutement/offres
```

Résultat attendu : JSON avec la liste des offres

### Test 3 : Vérifier Eureka

Ouvrez : http://localhost:8761

Vérifiez que ces 3 services sont UP :
- FORUM-SERVICE
- RECRUTEMENT-SERVICE
- API-GATEWAY

## 📊 Diagramme des URLs

```
┌─────────────────────────────────────────────────────────┐
│         Angular App (http://localhost:4200)             │
└─────────────────────────────────────────────────────────┘
                           │
                           │ HTTP Request
                           ▼
┌─────────────────────────────────────────────────────────┐
│      API Gateway (http://localhost:8086)                │
│                                                           │
│  Route 1: /forum/** → forum-service (StripPrefix=1)     │
│  Route 2: /recrutement/** → recrutement-service         │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
┌──────────────────┐              ┌──────────────────┐
│  Forum Service   │              │ Recrutement Svc  │
│   Port 8082      │              │   Port 8083      │
│  /api/forum/**   │              │ /api/recrutement │
└──────────────────┘              └──────────────────┘
```

## 🔍 Exemple de Requête Complète

### Requête : Obtenir tous les forums

**1. Angular Service appelle :**
```typescript
this.http.get(`${this.apiUrl}/forums`)
// apiUrl = 'http://localhost:8086/forum/api/forum'
// URL finale = 'http://localhost:8086/forum/api/forum/forums'
```

**2. Gateway reçoit :**
```
GET http://localhost:8086/forum/api/forum/forums
```

**3. Gateway applique StripPrefix=1 :**
```
/forum/api/forum/forums → /api/forum/forums
```

**4. Gateway route vers forum-service :**
```
GET http://forum-service/api/forum/forums
(Résolu via Eureka → http://localhost:8082/api/forum/forums)
```

**5. Forum Service répond :**
```json
[
  {
    "id_forum": 1,
    "titre": "Forum Général",
    ...
  }
]
```

**6. Gateway retourne la réponse à Angular**

## ⚠️ Erreurs Courantes

### Erreur 1 : 404 Not Found

**Symptôme :**
```
GET http://localhost:8086/forum → 404
```

**Cause :** URL incomplète, manque `/api/forum/forums`

**Solution :** Vérifier que les fichiers d'environnement sont corrects et que l'app Angular est redémarrée

### Erreur 2 : CORS Error

**Symptôme :**
```
Access to XMLHttpRequest blocked by CORS policy
```

**Cause :** Configuration CORS du Gateway

**Solution :** Vérifier la configuration CORS dans `api-gateway/application.properties`

### Erreur 3 : 503 Service Unavailable

**Symptôme :**
```
GET http://localhost:8086/forum/api/forum/forums → 503
```

**Cause :** Service non trouvé par le Gateway

**Solution :**
1. Vérifier que le service est UP dans Eureka (http://localhost:8761)
2. Attendre 30 secondes
3. Redémarrer le Gateway

### Erreur 4 : Connection Refused

**Symptôme :**
```
GET http://localhost:8086/... → ERR_CONNECTION_REFUSED
```

**Cause :** Gateway non démarré

**Solution :** Démarrer le Gateway
```bash
cd api-gateway
mvnw spring-boot:run
```

## 📋 Checklist de Résolution

- [ ] Fichiers `environment.ts` mis à jour (port 8086)
- [ ] Fichiers `environment.prod.ts` mis à jour (port 8086)
- [ ] API Gateway redémarré
- [ ] Application Angular redémarrée
- [ ] Cache du navigateur vidé (Ctrl+Shift+R)
- [ ] Eureka Dashboard vérifié (3 services UP)
- [ ] Test URL Forum : http://localhost:8086/forum/api/forum/forums
- [ ] Test URL Recrutement : http://localhost:8086/recrutement/api/recrutement/offres
- [ ] Console du navigateur sans erreurs 404
- [ ] Onglet Network montre les bonnes URLs

## 🎉 Succès !

Si vous voyez dans la console du navigateur :

```
✅ GET http://localhost:8086/forum/api/forum/forums → 200 OK
✅ GET http://localhost:8086/recrutement/api/recrutement/offres → 200 OK
```

Félicitations ! Votre application Angular communique correctement avec les microservices via l'API Gateway ! 🚀

## 📚 Documentation Complémentaire

- **CONFIGURATION_ANGULAR_GATEWAY.md** - Guide complet de configuration
- **FIX_GATEWAY_404.md** - Explication du problème StripPrefix
- **SOLUTION_404_GATEWAY.md** - Solution rapide pour le Gateway
- **TEST_EUREKA_GATEWAY.bat** - Script de test automatique

## 💡 Commandes Rapides

```bash
# Redémarrer le Gateway
REDEMARRER_GATEWAY.bat

# Redémarrer Angular
REDEMARRER_ANGULAR.bat

# Tester le Gateway
TEST_GATEWAY_RAPIDE.bat

# Test complet
TEST_EUREKA_GATEWAY.bat
```
