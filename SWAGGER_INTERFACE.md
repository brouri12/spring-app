# 🎨 INTERFACE SWAGGER - APERÇU VISUEL

## 📍 URL D'ACCÈS

```
http://localhost:8082/swagger-ui/index.html
```

---

## 🖼️ APERÇU DE L'INTERFACE

```
┌─────────────────────────────────────────────────────────────────┐
│  🔍 Explore                                                     │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ http://localhost:8082/v3/api-docs                        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Forum Service API                                    v1.0.0   │
│  API REST pour la gestion du forum académique ESPRIT           │
│                                                                 │
│  Servers                                                        │
│  ▼ http://localhost:8082 - Forum Service - Local              │
│    http://localhost:8080 - Forum Service via API Gateway       │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  forum-rest-api                                                 │
│  ▼                                                              │
│                                                                 │
│  ┌─ GET /api/forum ──────────────────────────────────────┐    │
│  │  getAllForums                                          │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ POST /api/forum ─────────────────────────────────────┐    │
│  │  addForum                                              │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/{id} ─────────────────────────────────┐    │
│  │  getForumById                                          │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ PUT /api/forum/{id} ─────────────────────────────────┐    │
│  │  updateForum                                           │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ DELETE /api/forum/{id} ──────────────────────────────┐    │
│  │  deleteForum                                           │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ PATCH /api/forum/{id}/fermer ───────────────────────┐    │
│  │  fermerForum                                           │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/recherche ────────────────────────────┐    │
│  │  rechercherForums                                      │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/niveau/{niveau} ──────────────────────┐    │
│  │  getForumsByNiveau                                     │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/statut/{statut} ──────────────────────┐    │
│  │  getForumsByStatut                                     │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/plus-actifs ──────────────────────────┐    │
│  │  getForumsPlusActifs                                   │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/{id}/messages ────────────────────────┐    │
│  │  getMessagesByForum                                    │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ POST /api/forum/message ─────────────────────────────┐    │
│  │  publierMessage                                        │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ PUT /api/forum/message/{id} ─────────────────────────┐    │
│  │  modifierMessage                                       │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ DELETE /api/forum/message/{id} ──────────────────────┐    │
│  │  supprimerMessage                                      │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ GET /api/forum/{id}/messages/count ──────────────────┐    │
│  │  compterMessages                                       │    │
│  │  [Try it out]                                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Schemas                                                        │
│  ▼                                                              │
│                                                                 │
│  ┌─ Forum ───────────────────────────────────────────────┐    │
│  │  {                                                     │    │
│  │    "id_forum": 0,                                      │    │
│  │    "titre": "string",                                  │    │
│  │    "description": "string",                            │    │
│  │    "date_creation": "2026-02-17",                      │    │
│  │    "cree_par": 0,                                      │    │
│  │    "niveau": "string",                                 │    │
│  │    "groupe": "string",                                 │    │
│  │    "cours": "string",                                  │    │
│  │    "statut": "string",                                 │    │
│  │    "messages": []                                      │    │
│  │  }                                                     │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─ MessageForum ────────────────────────────────────────┐    │
│  │  {                                                     │    │
│  │    "id_message": 0,                                    │    │
│  │    "contenu": "string",                                │    │
│  │    "date_message": "2026-02-17T21:00:00.000Z",         │    │
│  │    "auteur_id": 0,                                     │    │
│  │    "type_auteur": "string",                            │    │
│  │    "statut": "string"                                  │    │
│  │  }                                                     │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎬 EXEMPLE D'UTILISATION

### Étape 1 : Cliquer sur un endpoint

```
┌─ GET /api/forum ──────────────────────────────────────┐
│  getAllForums                                          │
│  [Try it out] ← CLIQUER ICI                           │
└────────────────────────────────────────────────────────┘
```

### Étape 2 : Le bouton devient "Execute"

```
┌─ GET /api/forum ──────────────────────────────────────┐
│  getAllForums                                          │
│                                                        │
│  Parameters                                            │
│  No parameters                                         │
│                                                        │
│  [Execute] ← CLIQUER ICI                              │
│  [Cancel]                                              │
└────────────────────────────────────────────────────────┘
```

### Étape 3 : Voir le résultat

```
┌─ Responses ───────────────────────────────────────────┐
│                                                        │
│  Code: 200                                             │
│  Details: OK                                           │
│                                                        │
│  Response body                                         │
│  [                                                     │
│    {                                                   │
│      "id_forum": 1,                                    │
│      "titre": "Discussion Java Spring Boot",           │
│      "description": "Forum dédié aux questions...",    │
│      "date_creation": "2026-02-17",                    │
│      "cree_par": 1,                                    │
│      "niveau": "L3",                                   │
│      "groupe": "INFO-A",                               │
│      "cours": "Développement Web",                     │
│      "statut": "OUVERT",                               │
│      "messages": [...]                                 │
│    },                                                  │
│    {                                                   │
│      "id_forum": 2,                                    │
│      "titre": "Projet Angular - Questions",            │
│      ...                                               │
│    }                                                   │
│  ]                                                     │
│                                                        │
│  Response headers                                      │
│  content-type: application/json                        │
│  date: Mon, 17 Feb 2026 21:00:00 GMT                   │
│                                                        │
│  Curl                                                  │
│  curl -X 'GET' \                                       │
│    'http://localhost:8082/api/forum' \                 │
│    -H 'accept: application/json'                       │
│                                                        │
│  Request URL                                           │
│  http://localhost:8082/api/forum                       │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## 🎯 EXEMPLE POST (Créer un Forum)

### Avant d'exécuter

```
┌─ POST /api/forum ─────────────────────────────────────┐
│  addForum                                              │
│                                                        │
│  Request body                                          │
│  application/json                                      │
│                                                        │
│  {                                                     │
│    "titre": "Forum créé via Swagger",                 │
│    "description": "Test Swagger",                     │
│    "cree_par": 100,                                    │
│    "niveau": "L1",                                     │
│    "groupe": "SWAGGER-TEST",                           │
│    "cours": "Test",                                    │
│    "statut": "OUVERT"                                  │
│  }                                                     │
│                                                        │
│  [Execute]                                             │
└────────────────────────────────────────────────────────┘
```

### Après exécution

```
┌─ Responses ───────────────────────────────────────────┐
│                                                        │
│  Code: 201                                             │
│  Details: Created                                      │
│                                                        │
│  Response body                                         │
│  {                                                     │
│    "id_forum": 3,                                      │
│    "titre": "Forum créé via Swagger",                 │
│    "description": "Test Swagger",                     │
│    "date_creation": "2026-02-17",                      │
│    "cree_par": 100,                                    │
│    "niveau": "L1",                                     │
│    "groupe": "SWAGGER-TEST",                           │
│    "cours": "Test",                                    │
│    "statut": "OUVERT",                                 │
│    "messages": []                                      │
│  }                                                     │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## 🎨 CODES COULEUR

Dans l'interface Swagger, les méthodes HTTP ont des couleurs :

```
🟢 GET    - Vert    - Récupérer des données
🟡 POST   - Jaune   - Créer une ressource
🔵 PUT    - Bleu    - Modifier complètement
🟠 PATCH  - Orange  - Modifier partiellement
🔴 DELETE - Rouge   - Supprimer
```

---

## 📱 RESPONSIVE

L'interface Swagger s'adapte à toutes les tailles d'écran :
- 💻 Desktop
- 📱 Tablette
- 📱 Mobile

---

## 🔍 FONCTIONNALITÉS AVANCÉES

### Filtrer les endpoints
```
┌─────────────────────────────────────┐
│ 🔍 Filter by tag                    │
│ [                              ]    │
└─────────────────────────────────────┘
```

### Changer de serveur
```
┌─────────────────────────────────────┐
│ Servers                             │
│ ▼ http://localhost:8082             │
│   http://localhost:8080             │
└─────────────────────────────────────┘
```

### Autorisation (si configurée)
```
┌─────────────────────────────────────┐
│ 🔒 Authorize                        │
│ [Authorize]                         │
└─────────────────────────────────────┘
```

---

## 🎉 AVANTAGES

✅ **Interface intuitive** - Facile à utiliser
✅ **Pas besoin de Postman** - Tout dans le navigateur
✅ **Documentation interactive** - Voir et tester en même temps
✅ **Copier les requêtes cURL** - Pour utiliser en ligne de commande
✅ **Voir les schémas** - Comprendre la structure des données
✅ **Tester rapidement** - En quelques clics

---

## 📚 POUR ALLER PLUS LOIN

Consultez le guide complet : **[GUIDE_SWAGGER.md](GUIDE_SWAGGER.md)**

---

**Profitez de Swagger ! 🚀**
