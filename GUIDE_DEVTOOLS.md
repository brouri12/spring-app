# 🔍 Guide DevTools - Identifier le Problème 404

## 🎯 Objectif

Identifier exactement quelle URL cause l'erreur 404 et pourquoi.

## 📋 Étapes Détaillées

### Étape 1 : Ouvrir DevTools

1. Ouvrez l'application : **http://localhost:4200**
2. Appuyez sur **F12** (ou Clic droit → Inspecter)
3. DevTools s'ouvre (généralement en bas ou à droite)

### Étape 2 : Aller dans l'onglet Network

1. Cliquez sur l'onglet **Network** (Réseau)
2. Cochez **Preserve log** (Conserver le journal)
3. Cochez **Disable cache** (Désactiver le cache)

### Étape 3 : Vider le Cache et Recharger

1. Appuyez sur **Ctrl + Shift + R** (hard reload)
2. Ou : Clic droit sur le bouton Refresh → "Empty Cache and Hard Reload"

### Étape 4 : Observer les Requêtes

Dans l'onglet Network, vous verrez toutes les requêtes HTTP.

#### 4.1 Filtrer les Requêtes

- Cliquez sur **XHR** pour voir uniquement les requêtes AJAX
- Ou tapez `localhost:8086` dans le filtre

#### 4.2 Identifier les Requêtes

Cherchez les requêtes qui commencent par :
- `forum/api/forum/forums`
- `recrutement/api/recrutement/offres`

#### 4.3 Vérifier les URLs Complètes

Cliquez sur une requête pour voir les détails :

**Onglet Headers :**
- **Request URL** : L'URL complète de la requête

**URLs Correctes :**
```
✅ http://localhost:4200/           (Page Angular)
✅ http://localhost:8086/forum/api/forum/forums
✅ http://localhost:8086/recrutement/api/recrutement/offres
```

**URLs Incorrectes :**
```
❌ http://localhost:8080/...        (Ancien port)
❌ http://localhost:8082/...        (Accès direct au service)
❌ http://localhost:4200/forum      (Route Angular, pas une requête API)
❌ forum:1                          (URL relative incorrecte)
```

### Étape 5 : Analyser les Erreurs

#### Cas 1 : Erreur 404 sur une requête API

**Symptôme :**
```
Request URL: http://localhost:8086/forum/api/forum/forums
Status: 404 Not Found
```

**Causes possibles :**
1. Gateway mal configuré (StripPrefix incorrect)
2. Service non enregistré dans Eureka
3. URL incorrecte

**Solution :**
1. Testez l'URL directement dans le navigateur
2. Vérifiez Eureka Dashboard : http://localhost:8761
3. Vérifiez les logs du Gateway

#### Cas 2 : Erreur 404 sur "forum:1"

**Symptôme :**
```
Request URL: forum:1
Status: 404 Not Found
```

**Cause :**
Le navigateur essaie de charger une ressource avec une URL relative incorrecte.

**Solution :**
1. Vider complètement le cache du navigateur
2. Supprimer le cache Angular : `rmdir /s /q angular-app\back-office\.angular\cache`
3. Redémarrer Angular
4. Tester en mode navigation privée

#### Cas 3 : Erreur 503 Service Unavailable

**Symptôme :**
```
Request URL: http://localhost:8086/forum/api/forum/forums
Status: 503 Service Unavailable
```

**Cause :**
Le Gateway ne trouve pas le service dans Eureka.

**Solution :**
1. Vérifiez Eureka Dashboard : http://localhost:8761
2. Vérifiez que FORUM-SERVICE est UP
3. Attendez 30 secondes que le Gateway rafraîchisse
4. Redémarrez le Gateway si nécessaire

#### Cas 4 : Erreur CORS

**Symptôme :**
```
Access to XMLHttpRequest at 'http://localhost:8086/...' from origin 'http://localhost:4200' 
has been blocked by CORS policy
```

**Cause :**
Configuration CORS du Gateway incorrecte.

**Solution :**
Vérifiez dans `api-gateway/application.properties` :
```properties
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-origins=*
```

### Étape 6 : Vérifier la Console

1. Allez dans l'onglet **Console**
2. Cherchez les erreurs en rouge

**Erreurs courantes :**

```javascript
// ❌ Erreur de chargement
Failed to load resource: the server responded with a status of 404 (Not Found)

// ❌ Erreur CORS
Access to XMLHttpRequest blocked by CORS policy

// ❌ Erreur de connexion
net::ERR_CONNECTION_REFUSED

// ✅ Pas d'erreur (bon signe)
```

### Étape 7 : Tester les Réponses

Dans l'onglet Network, cliquez sur une requête réussie (200 OK) :

**Onglet Response :**
- Vous devez voir du JSON avec les données

**Exemple de réponse correcte :**
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

## 🔍 Scénarios de Diagnostic

### Scénario A : Aucune Requête vers localhost:8086

**Observation :**
- Aucune requête XHR vers `localhost:8086`
- Ou requêtes vers `localhost:8080` ou `localhost:8082`

**Cause :**
Angular utilise l'ancienne configuration.

**Solution :**
1. Vérifiez `environment.ts` : doit contenir `localhost:8086`
2. Supprimez le cache Angular
3. Redémarrez Angular
4. Videz le cache du navigateur

### Scénario B : Requêtes vers localhost:8086 mais 404

**Observation :**
- Requêtes vers `http://localhost:8086/forum/api/forum/forums`
- Status : 404 Not Found

**Cause :**
Problème de routing dans le Gateway.

**Solution :**
1. Testez l'URL directement dans le navigateur
2. Vérifiez la configuration du Gateway (StripPrefix=1)
3. Redémarrez le Gateway
4. Vérifiez les logs du Gateway

### Scénario C : Requêtes vers localhost:8086 mais 503

**Observation :**
- Requêtes vers `http://localhost:8086/forum/api/forum/forums`
- Status : 503 Service Unavailable

**Cause :**
Service non trouvé par le Gateway.

**Solution :**
1. Vérifiez Eureka : http://localhost:8761
2. Vérifiez que le service est UP
3. Attendez 30 secondes
4. Redémarrez le Gateway

### Scénario D : Erreur "forum:1"

**Observation :**
- Requête vers `forum:1`
- Status : 404 Not Found

**Cause :**
Cache du navigateur ou problème de base href.

**Solution :**
1. Mode navigation privée (Ctrl+Shift+N)
2. Vider complètement le cache
3. Vérifier `<base href="/">` dans index.html
4. Supprimer le cache Angular et redémarrer

## 📊 Tableau de Diagnostic

| Symptôme | Cause Probable | Solution |
|----------|----------------|----------|
| Pas de requêtes vers 8086 | Config Angular incorrecte | Vérifier environment.ts |
| Requêtes vers 8080 | Ancienne config en cache | Vider cache + redémarrer |
| 404 sur /forum/api/forum/forums | Gateway mal configuré | Vérifier StripPrefix=1 |
| 503 Service Unavailable | Service non dans Eureka | Vérifier Eureka Dashboard |
| CORS Error | Config CORS incorrecte | Vérifier application.properties |
| forum:1 | Cache navigateur | Mode privé + vider cache |
| Connection Refused | Service non démarré | Démarrer le service |

## 🎯 Checklist de Vérification

Dans DevTools → Network :

- [ ] Requêtes XHR visibles
- [ ] Requêtes vers `localhost:8086` (pas 8080, 8082, 8083)
- [ ] URLs complètes : `/forum/api/forum/forums`
- [ ] Status : 200 OK (pas 404, 503)
- [ ] Response : JSON avec données
- [ ] Pas d'erreurs CORS
- [ ] Pas d'erreurs dans Console

## 💡 Astuces

### Astuce 1 : Copier la Requête

Clic droit sur une requête → **Copy** → **Copy as cURL**

Collez dans un terminal pour tester :
```bash
curl 'http://localhost:8086/forum/api/forum/forums'
```

### Astuce 2 : Rejouer une Requête

Clic droit sur une requête → **Replay XHR**

### Astuce 3 : Voir les Headers

Cliquez sur une requête → Onglet **Headers**
- Request Headers : Ce que Angular envoie
- Response Headers : Ce que le serveur répond

### Astuce 4 : Filtrer par Domaine

Dans le filtre, tapez : `localhost:8086`

Seules les requêtes vers le Gateway seront affichées.

## 🚀 Test Rapide

1. Ouvrez : http://localhost:4200
2. F12 → Network → XHR
3. Ctrl+Shift+R (hard reload)
4. Cherchez : `forum/api/forum/forums`
5. Vérifiez : URL complète et Status

**Si tout est OK :**
```
✅ Request URL: http://localhost:8086/forum/api/forum/forums
✅ Status: 200 OK
✅ Response: [{"id_forum":1,...}]
```

**Si problème :**
- Prenez une capture d'écran
- Notez l'URL exacte et le Status
- Consultez le tableau de diagnostic ci-dessus

---

✅ Avec ce guide, vous pouvez identifier précisément où se situe le problème !
