# 🔗 TOUTES LES URLS SWAGGER À ESSAYER

## ⚡ ESSAYEZ CES URLS DANS L'ORDRE

### 1️⃣ URL Principale (Spring Boot 3.x/4.x)
```
http://localhost:8082/swagger-ui/index.html
```
✅ **C'EST CELLE-CI QU'IL FAUT UTILISER !**

---

### 2️⃣ URL Alternative 1
```
http://localhost:8082/swagger-ui.html
```

---

### 3️⃣ URL Alternative 2
```
http://localhost:8082/swagger-ui/
```

---

### 4️⃣ URL Alternative 3
```
http://localhost:8082/swagger-ui
```

---

## 📄 DOCUMENTATION OPENAPI

### JSON
```
http://localhost:8082/v3/api-docs
```

### YAML
```
http://localhost:8082/v3/api-docs.yaml
```

---

## ✅ VÉRIFICATION DE L'API

Avant de tester Swagger, vérifiez que votre API fonctionne :

### API Forum
```
http://localhost:8082/api/forum
```

**Résultat attendu** : JSON avec liste de forums

---

### Actuator Health
```
http://localhost:8082/actuator/health
```

**Résultat attendu** : `{"status":"UP"}`

---

### Actuator Mappings (voir tous les endpoints)
```
http://localhost:8082/actuator/mappings
```

---

## 🔧 SI AUCUNE URL NE FONCTIONNE

### Étape 1 : Arrêter le service
```
Ctrl + C
```

### Étape 2 : Recompiler
```cmd
cd forum-service
mvnw clean install
```

### Étape 3 : Redémarrer
```cmd
mvnw spring-boot:run
```

### Étape 4 : Attendre le message
```
Started ForumApplication in X seconds
```

### Étape 5 : Réessayer
```
http://localhost:8082/swagger-ui/index.html
```

---

## 📊 TABLEAU RÉCAPITULATIF

| URL | Description | Probabilité |
|-----|-------------|-------------|
| `/swagger-ui/index.html` | URL standard Spring Boot 3+ | ⭐⭐⭐⭐⭐ |
| `/swagger-ui.html` | URL alternative | ⭐⭐⭐⭐ |
| `/swagger-ui/` | Sans index.html | ⭐⭐⭐ |
| `/v3/api-docs` | Documentation JSON | ⭐⭐⭐⭐⭐ |

---

## 🎯 TEST RAPIDE

Copiez-collez ces commandes dans votre navigateur :

```
http://localhost:8082/swagger-ui/index.html
http://localhost:8082/swagger-ui.html
http://localhost:8082/swagger-ui/
http://localhost:8082/v3/api-docs
```

---

## 💡 ASTUCE

Si vous voyez du JSON en allant sur `/v3/api-docs`, cela signifie que Swagger est bien installé !

Dans ce cas, l'URL Swagger UI est forcément l'une de celles-ci :
- `http://localhost:8082/swagger-ui/index.html`
- `http://localhost:8082/swagger-ui.html`

---

## 🔍 VÉRIFIER DANS LES LOGS

Après le démarrage, cherchez dans les logs :

```
Mapped "{[/swagger-ui/index.html]}"
```

ou

```
springdoc-openapi started
```

Cela vous indiquera l'URL exacte.

---

## 📞 ALTERNATIVE : POSTMAN

Si Swagger ne fonctionne vraiment pas, utilisez :

1. **Postman** avec la collection fournie
2. **test-apis.http** dans IntelliJ
3. **cURL** en ligne de commande

Ces méthodes fonctionnent toujours ! 🎯

---

**Bonne chance ! 🚀**
