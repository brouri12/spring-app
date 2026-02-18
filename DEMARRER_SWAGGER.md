# 🚀 DÉMARRER SWAGGER - ÉTAPE PAR ÉTAPE

## ⚡ EN 3 ÉTAPES

### 1️⃣ Recompiler le projet
```cmd
cd forum-service
mvnw clean install
```

### 2️⃣ Démarrer le service
```cmd
mvnw spring-boot:run
```

### 3️⃣ Ouvrir Swagger
Cliquez sur ce lien : **http://localhost:8082/swagger-ui/index.html**

---

## 📋 INSTRUCTIONS DÉTAILLÉES

### Étape 1 : Ouvrir le Terminal

**Windows** :
- Appuyez sur `Win + R`
- Tapez `cmd`
- Appuyez sur `Entrée`

**Ou dans IntelliJ** :
- `Alt + F12` pour ouvrir le terminal intégré

---

### Étape 2 : Naviguer vers le projet

```cmd
cd C:\Users\21695\OneDrive\Bureau\pidev4\forum-service
```

Ou si vous êtes déjà dans `pidev4` :
```cmd
cd forum-service
```

---

### Étape 3 : Nettoyer et Recompiler

```cmd
mvnw clean install
```

**Attendez** : Cette commande va :
- Nettoyer les anciens fichiers compilés
- Télécharger la dépendance Swagger
- Compiler le projet
- Exécuter les tests

**Temps estimé** : 30-60 secondes

**Message de succès attendu** :
```
[INFO] BUILD SUCCESS
[INFO] Total time: XX s
```

---

### Étape 4 : Démarrer le Service

```cmd
mvnw spring-boot:run
```

**Attendez** : Le service va démarrer

**Messages attendus** :
```
Started ForumApplication in X seconds
✅ Données initiales insérées : 2 forums et 5 messages
```

**Temps estimé** : 30-45 secondes

---

### Étape 5 : Ouvrir Swagger UI

**Option 1** : Cliquer sur le lien
```
http://localhost:8082/swagger-ui/index.html
```

**Option 2** : Copier-coller dans le navigateur
```
http://localhost:8082/swagger-ui/index.html
```

**Option 3** : URL alternative
```
http://localhost:8082/swagger-ui.html
```

---

## ✅ VÉRIFICATION

### Vous devriez voir :

```
┌─────────────────────────────────────────┐
│  Forum Service API          v1.0.0      │
│                                         │
│  API REST pour la gestion du forum      │
│  académique ESPRIT                      │
│                                         │
│  Servers                                │
│  ▼ http://localhost:8082                │
│                                         │
│  forum-rest-api                         │
│  ▼                                      │
│    GET  /api/forum                      │
│    POST /api/forum                      │
│    GET  /api/forum/{id}                 │
│    ...                                  │
└─────────────────────────────────────────┘
```

---

## 🧪 PREMIER TEST

### Test Simple : Récupérer tous les forums

1. **Cliquez** sur `GET /api/forum`
2. **Cliquez** sur le bouton `Try it out`
3. **Cliquez** sur le bouton `Execute`

**Résultat attendu** :
```json
[
  {
    "id_forum": 1,
    "titre": "Discussion Java Spring Boot",
    "description": "Forum dédié aux questions sur Spring Boot et Java",
    "date_creation": "2026-02-17",
    "niveau": "L3",
    "statut": "OUVERT"
  },
  {
    "id_forum": 2,
    "titre": "Projet Angular - Questions",
    ...
  }
]
```

**Code de réponse** : `200 OK`

---

## 🎯 DEUXIÈME TEST

### Créer un Forum

1. **Cliquez** sur `POST /api/forum`
2. **Cliquez** sur `Try it out`
3. **Modifiez** le JSON :

```json
{
  "titre": "Mon Premier Forum via Swagger",
  "description": "Test de création",
  "cree_par": 1,
  "niveau": "L1",
  "groupe": "TEST",
  "cours": "Test Swagger",
  "statut": "OUVERT"
}
```

4. **Cliquez** sur `Execute`

**Résultat attendu** :
- Code : `201 Created`
- Body : Forum créé avec un nouvel ID

---

## 🐛 PROBLÈMES COURANTS

### Problème 1 : "mvnw n'est pas reconnu"

**Solution** :
```cmd
# Utiliser Maven directement
mvn clean install
mvn spring-boot:run
```

Ou installer Maven : https://maven.apache.org/download.cgi

---

### Problème 2 : Port 8082 déjà utilisé

**Solution** :
```cmd
# Trouver le processus
netstat -ano | findstr :8082

# Tuer le processus
taskkill /PID <PID> /F
```

---

### Problème 3 : Swagger UI ne s'affiche pas

**Solutions** :

1. **Vérifier que le service est démarré**
   ```
   http://localhost:8082/api/forum
   ```
   Si ça fonctionne, le service est OK.

2. **Essayer les URLs alternatives**
   - `http://localhost:8082/swagger-ui/index.html`
   - `http://localhost:8082/swagger-ui.html`
   - `http://localhost:8082/swagger-ui/`

3. **Vérifier les logs**
   Chercher des erreurs dans la console

4. **Redémarrer le service**
   - `Ctrl + C` pour arrêter
   - `mvnw spring-boot:run` pour redémarrer

---

### Problème 4 : Erreur de compilation

**Solution** :
```cmd
# Nettoyer complètement
mvnw clean

# Recompiler
mvnw install

# Redémarrer
mvnw spring-boot:run
```

---

### Problème 5 : MySQL non accessible

**Solution** :
```cmd
# Démarrer MySQL
net start MySQL80

# Vérifier la connexion
mysql -u root -p
```

---

## 📱 DEPUIS INTELLIJ IDEA

### Option 1 : Via Maven Tool Window

1. Ouvrir la vue **Maven** (View → Tool Windows → Maven)
2. Naviguer vers **forum-service → Lifecycle**
3. Double-cliquer sur **clean**
4. Double-cliquer sur **install**
5. Naviguer vers **Plugins → spring-boot**
6. Double-cliquer sur **spring-boot:run**

---

### Option 2 : Via Run Configuration

1. Clic droit sur `ForumApplication.java`
2. **Run 'ForumApplication'**
3. Attendre le démarrage
4. Ouvrir le navigateur : `http://localhost:8082/swagger-ui/index.html`

---

## 🎓 APRÈS LE DÉMARRAGE

### Tester tous les endpoints

1. **GET** - Récupérer les données
2. **POST** - Créer de nouvelles ressources
3. **PUT** - Modifier des ressources
4. **PATCH** - Modifier partiellement
5. **DELETE** - Supprimer des ressources

### Explorer les Schémas

En bas de la page Swagger, cliquez sur **Schemas** pour voir :
- Structure de `Forum`
- Structure de `MessageForum`

### Copier les requêtes cURL

Après chaque test, vous pouvez copier la commande cURL pour l'utiliser en ligne de commande.

---

## 📚 DOCUMENTATION

Pour plus de détails :
- **GUIDE_SWAGGER.md** - Guide complet
- **SWAGGER_QUICK_ACCESS.md** - Accès rapide
- **SWAGGER_INTERFACE.md** - Aperçu visuel

---

## ✅ CHECKLIST FINALE

- [ ] Terminal ouvert
- [ ] Navigué vers forum-service
- [ ] `mvnw clean install` exécuté avec succès
- [ ] `mvnw spring-boot:run` exécuté
- [ ] Service démarré (message de confirmation)
- [ ] Swagger UI ouvert dans le navigateur
- [ ] Premier test réussi (GET /api/forum)
- [ ] Deuxième test réussi (POST /api/forum)

---

## 🎉 FÉLICITATIONS !

Vous avez maintenant Swagger opérationnel sur votre Forum Service !

**URL Swagger** : http://localhost:8082/swagger-ui/index.html

**Bon test ! 🚀**
