# 🔗 TOUS LES LIENS SWAGGER

## 📍 SERVICES DISPONIBLES

### 🟢 FORUM SERVICE (Port 8082)

#### Swagger UI
```
http://localhost:8082/swagger-ui/index.html
```

#### Documentation OpenAPI
```
http://localhost:8082/v3/api-docs
```

#### API Direct
```
http://localhost:8082/api/forum
```

---

### 🔵 RECRUTEMENT SERVICE (Port 8083)

#### Swagger UI
```
http://localhost:8083/swagger-ui/index.html
```

#### Documentation OpenAPI
```
http://localhost:8083/v3/api-docs
```

#### API Direct
```
http://localhost:8083/api/recrutement/offres
```

---

### 🌐 VIA API GATEWAY (Port 8080)

#### Forum via Gateway
```
http://localhost:8080/api/forum
```

#### Recrutement via Gateway
```
http://localhost:8080/api/recrutement/offres
```

---

### 🔷 EUREKA SERVER (Port 8761)

#### Dashboard
```
http://localhost:8761
```

---

## 🚀 DÉMARRAGE RAPIDE

### Forum Service
```cmd
cd forum-service
mvnw clean install
mvnw spring-boot:run
```
Puis ouvrir : http://localhost:8082/swagger-ui/index.html

---

### Recrutement Service
```cmd
cd recrutement-service
mvnw clean install
mvnw spring-boot:run
```
Puis ouvrir : http://localhost:8083/swagger-ui/index.html

---

## 📊 TABLEAU RÉCAPITULATIF

| Service | Port | Swagger UI | API Direct |
|---------|------|------------|------------|
| Forum | 8082 | [Swagger](http://localhost:8082/swagger-ui/index.html) | [API](http://localhost:8082/api/forum) |
| Recrutement | 8083 | [Swagger](http://localhost:8083/swagger-ui/index.html) | [API](http://localhost:8083/api/recrutement/offres) |
| Gateway | 8080 | - | [Forum](http://localhost:8080/api/forum) / [Recrutement](http://localhost:8080/api/recrutement/offres) |
| Eureka | 8761 | - | [Dashboard](http://localhost:8761) |

---

## 📚 DOCUMENTATION

### Forum Service
- **GUIDE_SWAGGER.md** - Guide complet Forum
- **SWAGGER_QUICK_ACCESS.md** - Accès rapide

### Recrutement Service
- **SWAGGER_RECRUTEMENT.md** - Guide complet Recrutement

### Général
- **TOUS_LES_LIENS_SWAGGER.md** - Ce fichier

---

## ✅ ORDRE DE DÉMARRAGE

```
1️⃣ MySQL Server
2️⃣ Eureka Server (ATTENDRE 30 SEC)
3️⃣ Forum Service
4️⃣ Recrutement Service
5️⃣ API Gateway
```

Ou utilisez :
```cmd
START_ALL_SERVICES.bat
```

---

## 🎯 TESTS RAPIDES

### Forum
```
GET http://localhost:8082/swagger-ui/index.html
→ GET /api/forum
→ Try it out → Execute
```

### Recrutement
```
GET http://localhost:8083/swagger-ui/index.html
→ GET /api/recrutement/offres
→ Try it out → Execute
```

---

## 🔧 DÉPANNAGE

### Swagger ne s'affiche pas

1. Vérifier que le service est démarré
2. Essayer les URLs alternatives :
   - `/swagger-ui/index.html`
   - `/swagger-ui.html`
   - `/swagger-ui/`
3. Vérifier l'API directement
4. Recompiler : `mvnw clean install`

### Erreur Eureka

Démarrer Eureka en premier :
```cmd
cd eureka-server
mvnw spring-boot:run
```

---

**Bon test avec Swagger ! 🚀**
