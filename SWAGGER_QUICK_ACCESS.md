# ⚡ ACCÈS RAPIDE SWAGGER

## 🔗 LIENS DIRECTS

### Forum Service
```
http://localhost:8082/swagger-ui/index.html
```

### Documentation OpenAPI (JSON)
```
http://localhost:8082/v3/api-docs
```

---

## 🚀 DÉMARRAGE RAPIDE

### 1. Démarrer le service
```cmd
cd forum-service
mvnw spring-boot:run
```

### 2. Ouvrir Swagger
Cliquez sur ce lien : **http://localhost:8082/swagger-ui/index.html**

### 3. Tester un endpoint
1. Cliquez sur **GET /api/forum**
2. Cliquez sur **Try it out**
3. Cliquez sur **Execute**

---

## 📋 TESTS RAPIDES

### Récupérer tous les forums
```
GET /api/forum
→ Try it out → Execute
```

### Créer un forum
```
POST /api/forum
→ Try it out
→ Modifier le JSON
→ Execute
```

### Récupérer un forum
```
GET /api/forum/{id}
→ Try it out
→ id: 1
→ Execute
```

---

## 🎯 EXEMPLE DE CRÉATION

```json
{
  "titre": "Test Swagger",
  "description": "Forum créé via Swagger",
  "cree_par": 1,
  "niveau": "L1",
  "groupe": "TEST",
  "cours": "Test",
  "statut": "OUVERT"
}
```

---

## 📚 GUIDE COMPLET

Pour plus de détails, consultez : **[GUIDE_SWAGGER.md](GUIDE_SWAGGER.md)**

---

**Bon test ! 🎉**
