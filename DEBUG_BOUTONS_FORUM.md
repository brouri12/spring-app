# 🐛 Débogage - Boutons Non Fonctionnels

## 🔍 Diagnostic

Les boutons Like, Répondre et Signaler ne fonctionnent pas. Voici comment diagnostiquer:

---

## Étape 1: Ouvrir la Console du Navigateur

1. **Appuyez sur F12** dans votre navigateur
2. **Allez dans l'onglet "Console"**
3. **Rechargez la page** (Ctrl+R)

### Ce que vous devriez voir:

```
🔄 Chargement des messages pour le forum: X
✅ Messages chargés: Y
📊 Chargement des stats pour le message: Z
❤️ Likes pour message Z : 0
💬 Réponses pour message Z : 0
✅ User like status pour message Z : false
```

### Si vous voyez des erreurs rouges:

Notez les erreurs et passez à l'étape 2.

---

## Étape 2: Vérifier les Requêtes HTTP

1. Dans les DevTools (F12), allez dans l'onglet **"Network"** (Réseau)
2. **Rechargez la page** (Ctrl+R)
3. **Cliquez sur un bouton Like**
4. **Observez les requêtes**

### Requêtes attendues:

Quand vous chargez les messages:
```
GET http://localhost:8082/api/forum/messages/forum/1
GET http://localhost:8082/api/forum/interactions/likes/10/count
GET http://localhost:8082/api/forum/interactions/reponses/10/count
GET http://localhost:8082/api/forum/interactions/likes/10/check/1
```

Quand vous cliquez sur Like:
```
POST http://localhost:8082/api/forum/interactions/likes/10/1
```

### Erreurs possibles:

#### ❌ Erreur 404 (Not Found)
**Cause:** Les endpoints n'existent pas dans le backend
**Solution:** Vérifier que le backend a bien les nouveaux controllers

#### ❌ Erreur 500 (Internal Server Error)
**Cause:** Erreur dans le backend (base de données, etc.)
**Solution:** Vérifier les logs du backend

#### ❌ Erreur CORS
**Cause:** Le backend bloque les requêtes depuis Angular
**Solution:** Vérifier que `@CrossOrigin(origins = "*")` est présent dans les controllers

#### ❌ Erreur de connexion
**Cause:** Le backend n'est pas démarré
**Solution:** Démarrer le backend

---

## Étape 3: Vérifier le Backend

### 3.1 Vérifier que le backend est démarré

```bash
# Dans un terminal
cd forum-service
mvn spring-boot:run
```

Attendez de voir:
```
Started ForumServiceApplication in X seconds
```

### 3.2 Tester les endpoints manuellement

Ouvrez un navigateur et testez:

```
http://localhost:8082/api/forum/interactions/likes/1/count
```

**Résultat attendu:**
```json
{"count": 0}
```

Si vous voyez une erreur 404, les controllers ne sont pas chargés.

### 3.3 Vérifier Swagger

Accédez à:
```
http://localhost:8082/swagger-ui.html
```

Vous devriez voir les nouveaux controllers:
- InteractionController
- ModerationController
- NotificationController
- BadgeController
- AnalyseController

---

## Étape 4: Solutions Courantes

### Solution 1: Redémarrer le Backend

```bash
# Arrêter le backend (Ctrl+C)
cd forum-service
mvn clean install
mvn spring-boot:run
```

### Solution 2: Vérifier que les Controllers Existent

```bash
# Vérifier que les fichiers existent
ls forum-service/src/main/java/tn/esprit/forum/controller/
```

Vous devriez voir:
- InteractionController.java
- ModerationController.java
- NotificationController.java
- BadgeController.java
- AnalyseController.java

### Solution 3: Vérifier les Logs du Backend

Dans le terminal où le backend tourne, cherchez des erreurs comme:
```
ERROR: Failed to start bean 'requestMappingHandlerMapping'
ERROR: Circular dependency
ERROR: Bean creation exception
```

### Solution 4: Vérifier la Base de Données

Les nouvelles tables doivent exister:
- like_message
- reponse_message
- signalement
- notification_forum
- badge_utilisateur

Si elles n'existent pas, le backend ne peut pas fonctionner.

---

## Étape 5: Test Manuel via Swagger

1. **Accédez à:** http://localhost:8082/swagger-ui.html

2. **Trouvez:** `interaction-controller`

3. **Testez:** `POST /api/forum/interactions/likes/{messageId}/{utilisateurId}`
   - messageId: 10
   - utilisateurId: 1

4. **Cliquez sur "Execute"**

**Résultat attendu:** Status 201 Created

Si ça fonctionne dans Swagger mais pas dans Angular, le problème est dans le frontend.

---

## Étape 6: Vérifier le Code Angular

### 6.1 Vérifier que les méthodes existent

Ouvrez la console et tapez:
```javascript
// Dans la console du navigateur
angular.getComponent(document.querySelector('app-forum'))
```

Vous devriez voir l'objet du composant avec les méthodes:
- toggleLike
- openReponseForm
- openSignalementForm

### 6.2 Vérifier les événements

Ajoutez un `console.log` temporaire:

Dans `forum.ts`, modifiez `toggleLike`:
```typescript
toggleLike(messageId: number) {
  console.log('🔴 CLICK LIKE DETECTÉ pour message:', messageId);
  // ... reste du code
}
```

Rechargez et cliquez sur Like. Si vous ne voyez pas le log, l'événement n'est pas déclenché.

---

## 🆘 Checklist de Dépannage

- [ ] Backend démarré (port 8082)
- [ ] Swagger accessible (http://localhost:8082/swagger-ui.html)
- [ ] Nouveaux controllers visibles dans Swagger
- [ ] Test manuel dans Swagger fonctionne
- [ ] Angular démarré (port 4201)
- [ ] Console du navigateur ouverte (F12)
- [ ] Onglet Network ouvert
- [ ] Pas d'erreurs rouges dans la console
- [ ] Requêtes HTTP visibles dans Network
- [ ] Requêtes retournent 200/201 (pas 404/500)

---

## 📸 Captures d'Écran Utiles

### Console - Logs Attendus:
```
🔄 Chargement des messages pour le forum: 1
✅ Messages chargés: 2
📊 Chargement des stats pour le message: 10
❤️ Likes pour message 10 : 0
💬 Réponses pour message 10 : 0
✅ User like status pour message 10 : false
```

### Network - Requêtes Attendues:
```
GET /api/forum/messages/forum/1          200 OK
GET /api/forum/interactions/likes/10/count    200 OK
GET /api/forum/interactions/reponses/10/count 200 OK
GET /api/forum/interactions/likes/10/check/1  200 OK
```

### Swagger - Controllers Attendus:
```
- interaction-controller
  - POST /api/forum/interactions/likes/{messageId}/{utilisateurId}
  - DELETE /api/forum/interactions/likes/{messageId}/{utilisateurId}
  - GET /api/forum/interactions/likes/{messageId}/count
  - ...
```

---

## 🎯 Prochaines Étapes

1. **Suivez les étapes 1-6** ci-dessus
2. **Notez les erreurs** que vous voyez
3. **Partagez les logs** de la console et du backend
4. **Testez dans Swagger** pour isoler le problème

Bonne chance! 🚀
