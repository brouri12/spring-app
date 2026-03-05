# 🔧 Dépannage Erreur 404 Angular

## 🔴 Erreur Persistante

```
Failed to load resource: the server responded with a status of 404 (Not Found)
forum:1
```

## 🎯 Causes Possibles

1. **Cache Angular** - L'ancienne configuration est en cache
2. **Cache Navigateur** - Le navigateur utilise l'ancienne version
3. **Application non redémarrée** - Les changements ne sont pas appliqués
4. **Backend non accessible** - Le Gateway ou les services ne fonctionnent pas

## ✅ Solution Complète (Étape par Étape)

### Étape 1 : Vérifier le Backend

#### 1.1 Vérifier Eureka
Ouvrez : **http://localhost:8761**

Vous devez voir 3 services :
- ✅ FORUM-SERVICE
- ✅ RECRUTEMENT-SERVICE
- ✅ API-GATEWAY

Si un service manque, démarrez-le :
```bash
# Forum Service
cd forum-service
mvnw spring-boot:run

# Recrutement Service
cd recrutement-service
mvnw spring-boot:run

# API Gateway
cd api-gateway
mvnw spring-boot:run
```

#### 1.2 Tester le Gateway directement

Ouvrez dans le navigateur ou utilisez curl :

**Forum :**
```bash
curl http://localhost:8086/forum/api/forum/forums
```

**Recrutement :**
```bash
curl http://localhost:8086/recrutement/api/recrutement/offres
```

Si vous voyez du JSON, le backend fonctionne ✅

Si vous avez une erreur 404, le problème est dans le Gateway → Voir **FIX_GATEWAY_404.md**

### Étape 2 : Vérifier la Configuration Angular

#### 2.1 Vérifier environment.ts

```bash
type angular-app\back-office\src\environments\environment.ts
```

Doit contenir :
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8086',
  forumServiceUrl: 'http://localhost:8086/forum/api/forum',
  recrutementServiceUrl: 'http://localhost:8086/recrutement/api/recrutement'
};
```

Si ce n'est pas le cas, le fichier n'a pas été mis à jour correctement.

#### 2.2 Diagnostic automatique

```bash
DIAGNOSTIC_ANGULAR.bat
```

### Étape 3 : Nettoyer le Cache Angular

#### 3.1 Arrêter l'application

Dans le terminal où Angular tourne, appuyez sur `Ctrl+C`

#### 3.2 Supprimer le cache

```bash
rmdir /s /q angular-app\back-office\.angular\cache
```

Ou utilisez le script :
```bash
NETTOYER_ET_REDEMARRER_ANGULAR.bat
```

#### 3.3 Redémarrer Angular

```bash
cd angular-app\back-office
ng serve
```

Attendez le message :
```
✔ Browser application bundle generation complete.
✔ Compiled successfully.
```

### Étape 4 : Nettoyer le Cache du Navigateur

#### Option 1 : Hard Reload (Recommandé)

1. Ouvrez l'application : http://localhost:4200
2. Ouvrez DevTools : `F12`
3. Clic droit sur le bouton Refresh (à côté de la barre d'adresse)
4. Sélectionnez **"Empty Cache and Hard Reload"**

#### Option 2 : Raccourci clavier

Appuyez sur : `Ctrl + Shift + R`

#### Option 3 : Effacer les données du site

1. Ouvrez DevTools : `F12`
2. Allez dans l'onglet **Application**
3. Dans le menu de gauche : **Storage**
4. Cliquez sur **Clear site data**
5. Rechargez la page : `F5`

### Étape 5 : Vérifier les Requêtes HTTP

#### 5.1 Ouvrir Network Tab

1. Ouvrez DevTools : `F12`
2. Allez dans l'onglet **Network**
3. Cochez **Preserve log**
4. Rechargez la page : `F5`

#### 5.2 Filtrer les requêtes

- Filtrez par **XHR** ou **Fetch**
- Cherchez les requêtes vers `localhost:8086`

#### 5.3 Vérifier les URLs

**URLs Correctes :**
```
✅ http://localhost:8086/forum/api/forum/forums
✅ http://localhost:8086/recrutement/api/recrutement/offres
```

**URLs Incorrectes :**
```
❌ http://localhost:8080/... (ancien port)
❌ http://localhost:8082/... (accès direct)
❌ http://localhost:8086/forum (manque /api/forum/forums)
❌ forum:1 (URL relative incorrecte)
```

#### 5.4 Vérifier les réponses

Cliquez sur une requête pour voir :
- **Status** : Doit être `200 OK`
- **Response** : Doit contenir du JSON

Si Status = 404 :
- Vérifier l'URL de la requête
- Vérifier que le Gateway est démarré
- Vérifier que le service est enregistré dans Eureka

Si Status = 503 :
- Le service n'est pas trouvé par le Gateway
- Vérifier Eureka Dashboard

Si CORS Error :
- Vérifier la configuration CORS du Gateway

## 🔍 Diagnostic Avancé

### Vérifier le Service Forum

```bash
# Voir le code du service
type angular-app\back-office\src\app\services\forum.service.ts
```

Doit contenir :
```typescript
private apiUrl = environment.forumServiceUrl;

getAllForums(): Observable<Forum[]> {
  return this.http.get<Forum[]>(`${this.apiUrl}/forums`);
}
```

URL finale construite : `http://localhost:8086/forum/api/forum/forums`

### Vérifier les Logs Angular

Dans le terminal où Angular tourne, cherchez :
```
✔ Compiled successfully.
```

Si vous voyez des erreurs TypeScript, corrigez-les avant de continuer.

### Vérifier les Logs du Navigateur

Dans la console du navigateur (F12 → Console), cherchez :
- Erreurs HTTP (en rouge)
- Warnings (en jaune)
- Messages de votre application

## 📋 Checklist de Dépannage

### Backend
- [ ] MySQL est démarré
- [ ] Eureka Server est accessible (http://localhost:8761)
- [ ] Forum Service est UP dans Eureka
- [ ] Recrutement Service est UP dans Eureka
- [ ] API Gateway est UP dans Eureka
- [ ] Test Gateway Forum : http://localhost:8086/forum/api/forum/forums → 200 OK
- [ ] Test Gateway Recrutement : http://localhost:8086/recrutement/api/recrutement/offres → 200 OK

### Frontend
- [ ] Fichier environment.ts contient port 8086
- [ ] Cache Angular supprimé (.angular/cache)
- [ ] Application Angular redémarrée
- [ ] Compilation réussie (✔ Compiled successfully)
- [ ] Cache navigateur vidé (Ctrl+Shift+R)
- [ ] DevTools Network montre requêtes vers localhost:8086
- [ ] Requêtes retournent 200 OK
- [ ] Pas d'erreurs dans la console

## 🛠️ Scripts Utiles

```bash
# Diagnostic complet
DIAGNOSTIC_ANGULAR.bat

# Nettoyer et redémarrer Angular
NETTOYER_ET_REDEMARRER_ANGULAR.bat

# Tester le Gateway
TEST_GATEWAY_RAPIDE.bat

# Test complet
TEST_EUREKA_GATEWAY.bat
```

## 💡 Astuces

### 1. Mode Incognito

Testez dans une fenêtre de navigation privée pour éviter les problèmes de cache :
- Chrome : `Ctrl + Shift + N`
- Firefox : `Ctrl + Shift + P`

### 2. Désactiver le Cache (DevTools)

1. Ouvrez DevTools : `F12`
2. Allez dans **Network**
3. Cochez **Disable cache**
4. Gardez DevTools ouvert

### 3. Vérifier les Variables d'Environnement

Dans la console du navigateur, tapez :
```javascript
// Cela ne fonctionnera pas directement, mais vous pouvez vérifier
// les requêtes HTTP dans l'onglet Network
```

### 4. Logs Détaillés

Ajoutez des logs dans le service :
```typescript
getAllForums(): Observable<Forum[]> {
  console.log('URL appelée:', `${this.apiUrl}/forums`);
  return this.http.get<Forum[]>(`${this.apiUrl}/forums`);
}
```

## 🐛 Erreurs Spécifiques

### Erreur : "forum:1"

**Cause** : Le navigateur essaie de charger une URL relative incorrecte

**Solutions** :
1. Vider le cache du navigateur (Ctrl+Shift+R)
2. Vérifier qu'il n'y a pas de `<link>` ou `<script>` avec href="forum" dans index.html
3. Redémarrer Angular après avoir vidé le cache

### Erreur : "net::ERR_CONNECTION_REFUSED"

**Cause** : Le serveur n'est pas accessible

**Solutions** :
1. Vérifier que le Gateway est démarré (http://localhost:8086/actuator/health)
2. Vérifier le port dans environment.ts
3. Vérifier le firewall

### Erreur : "CORS policy"

**Cause** : Configuration CORS du Gateway

**Solution** : Vérifier dans `api-gateway/application.properties` :
```properties
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-origins=*
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-methods=GET,POST,PUT,DELETE,PATCH,OPTIONS
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-headers=*
```

## 🎯 Solution Radicale

Si rien ne fonctionne, procédure complète :

### 1. Arrêter tout
```bash
# Arrêter Angular (Ctrl+C)
# Arrêter Gateway (Ctrl+C)
# Arrêter Forum Service (Ctrl+C)
# Arrêter Recrutement Service (Ctrl+C)
# Arrêter Eureka (Ctrl+C)
```

### 2. Nettoyer
```bash
# Supprimer cache Angular
rmdir /s /q angular-app\back-office\.angular\cache

# Supprimer node_modules (optionnel, si vraiment nécessaire)
# rmdir /s /q angular-app\back-office\node_modules
# cd angular-app\back-office
# npm install
```

### 3. Redémarrer dans l'ordre
```bash
# 1. Eureka
cd eureka-server
mvnw spring-boot:run

# Attendre 30 secondes

# 2. Forum Service
cd forum-service
mvnw spring-boot:run

# 3. Recrutement Service
cd recrutement-service
mvnw spring-boot:run

# Attendre 30 secondes

# 4. API Gateway
cd api-gateway
mvnw spring-boot:run

# Attendre 30 secondes

# 5. Angular
cd angular-app\back-office
ng serve
```

### 4. Tester
1. Vérifier Eureka : http://localhost:8761
2. Tester Gateway : http://localhost:8086/forum/api/forum/forums
3. Ouvrir Angular en mode incognito : http://localhost:4200

## 📞 Support

Si le problème persiste après toutes ces étapes :

1. Exécutez : `DIAGNOSTIC_ANGULAR.bat`
2. Prenez une capture d'écran de :
   - La console du navigateur (F12 → Console)
   - L'onglet Network (F12 → Network)
   - Le terminal Angular
3. Vérifiez les logs du Gateway pour les erreurs

---

✅ Après avoir suivi ces étapes, votre application devrait fonctionner correctement !
