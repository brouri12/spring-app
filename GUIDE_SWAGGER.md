# 📘 GUIDE SWAGGER - FORUM SERVICE

## 🔗 LIENS SWAGGER

### Interface Swagger UI (Recommandé)
```
http://localhost:8082/swagger-ui/index.html
```

ou

```
http://localhost:8082/swagger-ui.html
```

### Documentation OpenAPI (JSON)
```
http://localhost:8082/v3/api-docs
```

---

## 🚀 DÉMARRAGE

### 1. Assurez-vous que le Forum Service est démarré

```cmd
cd forum-service
mvnw spring-boot:run
```

### 2. Attendez le message de confirmation

```
Started ForumApplication in X seconds
✅ Données initiales insérées : 2 forums et 5 messages
```

### 3. Ouvrez Swagger UI

Ouvrez votre navigateur et allez sur :
```
http://localhost:8082/swagger-ui/index.html
```

---

## 🎨 INTERFACE SWAGGER

Vous verrez une interface interactive avec :

```
┌─────────────────────────────────────────────────────────┐
│              Forum Service API - v1.0.0                 │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Servers:                                               │
│  • http://localhost:8082 (Local)                        │
│  • http://localhost:8080 (via Gateway)                  │
│                                                         │
│  forum-rest-api                                         │
│  ├─ GET    /api/forum                                   │
│  ├─ POST   /api/forum                                   │
│  ├─ GET    /api/forum/{id}                              │
│  ├─ PUT    /api/forum/{id}                              │
│  ├─ DELETE /api/forum/{id}                              │
│  ├─ PATCH  /api/forum/{id}/fermer                       │
│  ├─ GET    /api/forum/recherche                         │
│  ├─ GET    /api/forum/niveau/{niveau}                   │
│  ├─ GET    /api/forum/statut/{statut}                   │
│  ├─ GET    /api/forum/plus-actifs                       │
│  ├─ GET    /api/forum/{id}/messages                     │
│  ├─ POST   /api/forum/message                           │
│  ├─ PUT    /api/forum/message/{id}                      │
│  ├─ DELETE /api/forum/message/{id}                      │
│  └─ GET    /api/forum/{id}/messages/count               │
│                                                         │
│  Schemas:                                               │
│  • Forum                                                │
│  • MessageForum                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 TESTER LES ENDPOINTS

### 1️⃣ GET - Récupérer tous les forums

1. Cliquez sur **GET /api/forum**
2. Cliquez sur **Try it out**
3. Cliquez sur **Execute**

**Résultat attendu** : Liste de 2 forums (données de test)

---

### 2️⃣ GET - Récupérer un forum par ID

1. Cliquez sur **GET /api/forum/{id}**
2. Cliquez sur **Try it out**
3. Entrez `1` dans le champ **id**
4. Cliquez sur **Execute**

**Résultat attendu** : Détails du forum avec ID 1

---

### 3️⃣ POST - Créer un nouveau forum

1. Cliquez sur **POST /api/forum**
2. Cliquez sur **Try it out**
3. Modifiez le JSON dans le champ **Request body** :

```json
{
  "titre": "Forum créé via Swagger",
  "description": "Test de création depuis l'interface Swagger",
  "cree_par": 100,
  "niveau": "L1",
  "groupe": "SWAGGER-TEST",
  "cours": "Test Swagger",
  "statut": "OUVERT"
}
```

4. Cliquez sur **Execute**

**Résultat attendu** : Status 201 Created + Forum créé avec un ID

---

### 4️⃣ PUT - Modifier un forum

1. Cliquez sur **PUT /api/forum/{id}**
2. Cliquez sur **Try it out**
3. Entrez `1` dans le champ **id**
4. Modifiez le JSON :

```json
{
  "titre": "Forum modifié via Swagger",
  "description": "Description mise à jour",
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Développement Web",
  "statut": "OUVERT"
}
```

5. Cliquez sur **Execute**

**Résultat attendu** : Status 200 OK + Forum mis à jour

---

### 5️⃣ PATCH - Fermer un forum

1. Cliquez sur **PATCH /api/forum/{id}/fermer**
2. Cliquez sur **Try it out**
3. Entrez `1` dans le champ **id**
4. Cliquez sur **Execute**

**Résultat attendu** : Status 200 OK + Forum avec statut "FERME"

---

### 6️⃣ GET - Rechercher des forums

1. Cliquez sur **GET /api/forum/recherche**
2. Cliquez sur **Try it out**
3. Remplissez les paramètres :
   - **titre** : `Java`
   - **page** : `0`
   - **size** : `10`
4. Cliquez sur **Execute**

**Résultat attendu** : Forums contenant "Java" dans le titre

---

### 7️⃣ GET - Forums par niveau

1. Cliquez sur **GET /api/forum/niveau/{niveau}**
2. Cliquez sur **Try it out**
3. Entrez `L3` dans le champ **niveau**
4. Cliquez sur **Execute**

**Résultat attendu** : Forums de niveau L3

---

### 8️⃣ GET - Forums les plus actifs

1. Cliquez sur **GET /api/forum/plus-actifs**
2. Cliquez sur **Try it out**
3. Cliquez sur **Execute**

**Résultat attendu** : Top 5 des forums avec le plus de messages

---

### 9️⃣ GET - Messages d'un forum

1. Cliquez sur **GET /api/forum/{id}/messages**
2. Cliquez sur **Try it out**
3. Entrez `1` dans le champ **id**
4. Cliquez sur **Execute**

**Résultat attendu** : Liste des messages du forum 1

---

### 🔟 POST - Publier un message

1. Cliquez sur **POST /api/forum/message**
2. Cliquez sur **Try it out**
3. Remplissez les paramètres :
   - **forumId** : `1`
4. Modifiez le JSON :

```json
{
  "contenu": "Message publié via Swagger UI",
  "auteur_id": 999,
  "type_auteur": "ETUDIANT",
  "statut": "ACTIF"
}
```

5. Cliquez sur **Execute**

**Résultat attendu** : Status 201 Created + Message créé

---

### 1️⃣1️⃣ GET - Compter les messages

1. Cliquez sur **GET /api/forum/{id}/messages/count**
2. Cliquez sur **Try it out**
3. Entrez `1` dans le champ **id**
4. Cliquez sur **Execute**

**Résultat attendu** : `{"count": 3}` (ou plus)

---

### 1️⃣2️⃣ DELETE - Supprimer un forum

1. Cliquez sur **DELETE /api/forum/{id}**
2. Cliquez sur **Try it out**
3. Entrez `3` dans le champ **id** (ou l'ID d'un forum créé)
4. Cliquez sur **Execute**

**Résultat attendu** : Status 204 No Content

---

## 🎯 FONCTIONNALITÉS SWAGGER

### 🔄 Changer de Serveur

En haut de l'interface, vous pouvez choisir :
- **http://localhost:8082** - Accès direct au service
- **http://localhost:8080** - Accès via API Gateway

### 📋 Copier les Requêtes cURL

Après avoir exécuté une requête, vous pouvez copier la commande cURL :
1. Cliquez sur **Execute**
2. Descendez jusqu'à **Curl**
3. Copiez la commande

Exemple :
```bash
curl -X 'GET' \
  'http://localhost:8082/api/forum' \
  -H 'accept: application/json'
```

### 📥 Télécharger la Spécification OpenAPI

Cliquez sur le lien en haut : `/v3/api-docs`

Vous obtiendrez un fichier JSON que vous pouvez :
- Importer dans Postman
- Utiliser pour générer du code client
- Partager avec d'autres développeurs

---

## 🎨 PERSONNALISATION

### Modifier les Informations de l'API

Éditez `SwaggerConfig.java` :

```java
Info info = new Info()
    .title("Votre Titre")
    .version("2.0.0")
    .description("Votre description")
    .contact(contact)
    .license(license);
```

### Ajouter des Annotations aux Endpoints

Dans `ForumRestAPI.java`, ajoutez :

```java
@Operation(summary = "Récupérer tous les forums", 
           description = "Retourne la liste complète des forums")
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Succès"),
    @ApiResponse(responseCode = "500", description = "Erreur serveur")
})
@GetMapping
public ResponseEntity<List<Forum>> getAllForums() {
    return ResponseEntity.ok(forumService.getAllForums());
}
```

---

## 📊 CODES DE RÉPONSE HTTP

| Code | Signification | Quand ? |
|------|---------------|---------|
| 200  | OK | Requête réussie (GET, PUT, PATCH) |
| 201  | Created | Ressource créée (POST) |
| 204  | No Content | Suppression réussie (DELETE) |
| 400  | Bad Request | Données invalides |
| 403  | Forbidden | Accès refusé (ex: modifier message d'un autre) |
| 404  | Not Found | Ressource introuvable |
| 500  | Internal Server Error | Erreur serveur |

---

## 🔍 SCHÉMAS (MODELS)

En bas de la page Swagger, vous trouverez les schémas :

### Forum
```json
{
  "id_forum": 0,
  "titre": "string",
  "description": "string",
  "date_creation": "2026-02-17",
  "cree_par": 0,
  "niveau": "string",
  "groupe": "string",
  "cours": "string",
  "statut": "string",
  "messages": []
}
```

### MessageForum
```json
{
  "id_message": 0,
  "contenu": "string",
  "date_message": "2026-02-17T21:00:00.000Z",
  "auteur_id": 0,
  "type_auteur": "string",
  "statut": "string"
}
```

---

## 🐛 DÉPANNAGE

### Swagger UI ne s'affiche pas

**Vérifications** :
1. Service démarré ? `http://localhost:8082/api/forum` fonctionne ?
2. Dépendance ajoutée dans `pom.xml` ?
3. Redémarrer le service après ajout de la dépendance

### Erreur 404 sur /swagger-ui

**Solution** :
Essayez ces URLs :
- `http://localhost:8082/swagger-ui/index.html`
- `http://localhost:8082/swagger-ui.html`
- `http://localhost:8082/swagger-ui/`

### Les endpoints ne s'affichent pas

**Solution** :
1. Vérifier que `@RestController` est présent sur le contrôleur
2. Vérifier que `@RequestMapping("/api/forum")` est correct
3. Redémarrer le service

---

## 📝 CONFIGURATION DANS application.properties

Ajoutez ces propriétés pour personnaliser Swagger :

```properties
# Swagger Configuration
springdoc.api-docs.path=/v3/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.swagger-ui.enabled=true
springdoc.swagger-ui.operationsSorter=method
springdoc.swagger-ui.tagsSorter=alpha
springdoc.swagger-ui.tryItOutEnabled=true
```

---

## 🎯 AVANTAGES DE SWAGGER

✅ **Interface interactive** - Tester sans Postman
✅ **Documentation automatique** - Toujours à jour
✅ **Génération de code client** - Pour différents langages
✅ **Partage facile** - URL unique pour toute l'équipe
✅ **Validation des données** - Voir les schémas requis
✅ **Export OpenAPI** - Standard de l'industrie

---

## 🚀 PROCHAINES ÉTAPES

### Ajouter Swagger aux autres services

1. **Recrutement Service** :
```
http://localhost:8083/swagger-ui/index.html
```

2. **API Gateway** :
```
http://localhost:8080/swagger-ui/index.html
```

### Ajouter des annotations détaillées

```java
@Tag(name = "Forum Management", description = "APIs pour gérer les forums")
@Operation(summary = "Créer un forum", description = "Crée un nouveau forum de discussion")
@Parameter(name = "id", description = "ID du forum", required = true)
```

---

## 📚 RESSOURCES

- Documentation SpringDoc : https://springdoc.org/
- Spécification OpenAPI : https://swagger.io/specification/
- Swagger Editor : https://editor.swagger.io/

---

## ✅ CHECKLIST

- [ ] Dépendance Swagger ajoutée dans pom.xml
- [ ] SwaggerConfig.java créé
- [ ] Service Forum démarré
- [ ] Swagger UI accessible : http://localhost:8082/swagger-ui/index.html
- [ ] Tous les endpoints visibles
- [ ] Tests réussis via Swagger UI

---

**Profitez de Swagger pour tester votre API ! 🎉**
