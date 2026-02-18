# 🎓 ARCHITECTURE MICROSERVICES COMPLÈTE - ESPRIT

## 📦 PROJET COMPLET

Une architecture microservices complète avec 4 composants :

### 🔷 Eureka Server (Port 8761)
Service Discovery - Registre centralisé des microservices

### 🌐 API Gateway (Port 8080)
Point d'entrée unique - Routage intelligent vers les services

### 🟢 Forum Service (Port 8082)
Gestion du forum académique avec messages et discussions

### 🔵 Recrutement Service (Port 8083)
Gestion du recrutement des enseignants avec candidatures

---

## 🏗️ ARCHITECTURE

```
CLIENT
  ↓
API GATEWAY (8080)
  ↓
EUREKA SERVER (8761)
  ↓
├─ Forum Service (8082) → forum_db
└─ Recrutement Service (8083) → recrutement_db
```

---

## 🚀 DÉMARRAGE RAPIDE

### Option 1 : Script Automatique
```cmd
START_ALL_SERVICES.bat
```

### Option 2 : Démarrage Manuel

#### 1. MySQL
```cmd
net start MySQL80
```

#### 2. Eureka Server
```cmd
cd eureka-server
mvnw spring-boot:run
```
Attendre 30 secondes, puis vérifier : http://localhost:8761

#### 3. Forum Service
```cmd
cd forum-service
mvnw spring-boot:run
```

#### 4. Recrutement Service
```cmd
cd recrutement-service
mvnw spring-boot:run
```

#### 5. API Gateway
```cmd
cd api-gateway
mvnw spring-boot:run
```

---

## 🧪 TESTS

### Via API Gateway (Recommandé)
```http
# Forum
GET http://localhost:8080/api/forum
POST http://localhost:8080/api/forum

# Recrutement
GET http://localhost:8080/api/recrutement/offres
POST http://localhost:8080/api/recrutement/candidatures?offreId=1
```

### Accès Direct (Sans Gateway)
```http
# Forum
GET http://localhost:8082/api/forum

# Recrutement
GET http://localhost:8083/api/recrutement/offres
```

---

## 📊 URLS IMPORTANTES

| Service              | URL                                      |
|---------------------|------------------------------------------|
| Eureka Dashboard    | http://localhost:8761                    |
| API Gateway         | http://localhost:8080                    |
| Forum (via Gateway) | http://localhost:8080/api/forum          |
| Recrutement (via Gateway) | http://localhost:8080/api/recrutement/offres |
| Forum (direct)      | http://localhost:8082/api/forum          |
| Recrutement (direct)| http://localhost:8083/api/recrutement/offres |
| Gateway Routes      | http://localhost:8080/actuator/gateway/routes |

---

## 📚 DOCUMENTATION

- **README_COMPLET.md** : Ce fichier (vue d'ensemble)
- **GUIDE_EUREKA_GATEWAY.md** : Guide détaillé Eureka & Gateway
- **GUIDE_COMPLET_MICROSERVICES.md** : Guide Forum & Recrutement
- **ARCHITECTURE_COMPLETE.md** : Diagrammes d'architecture
- **INSTRUCTIONS_INTELLIJ.md** : Configuration IntelliJ IDEA

---

## 🧪 FICHIERS DE TEST

- **test-gateway.http** : 30 tests via Gateway
- **test-apis.http** : 34 tests directs
- **Microservices_Tests.postman_collection.json** : Collection Postman

---

## 📁 STRUCTURE DU PROJET

```
pidev4/
├── eureka-server/              # Service Discovery
│   ├── src/main/java/tn/esprit/eureka/
│   │   └── EurekaServerApplication.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
├── api-gateway/                # API Gateway
│   ├── src/main/java/tn/esprit/gateway/
│   │   ├── ApiGatewayApplication.java
│   │   └── GatewayConfig.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
├── forum-service/              # Forum Microservice
│   ├── src/main/java/tn/esprit/forum/
│   │   ├── entity/
│   │   ├── repository/
│   │   ├── service/
│   │   ├── controller/
│   │   └── ForumApplication.java
│   └── pom.xml
│
├── recrutement-service/        # Recrutement Microservice
│   ├── src/main/java/tn/esprit/recrutement/
│   │   ├── entity/
│   │   ├── repository/
│   │   ├── service/
│   │   ├── controller/
│   │   └── RecrutementApplication.java
│   └── pom.xml
│
├── START_ALL_SERVICES.bat      # Script de démarrage
├── test-gateway.http           # Tests Gateway
├── test-apis.http              # Tests directs
└── Documentation/              # Guides complets
```

---

## ✅ FONCTIONNALITÉS

### Eureka Server
- ✅ Service Discovery
- ✅ Health Monitoring
- ✅ Dashboard Web
- ✅ Auto-registration

### API Gateway
- ✅ Routing intelligent
- ✅ Load Balancing
- ✅ CORS Management
- ✅ Service Discovery Integration
- ✅ Actuator Endpoints

### Forum Service
- ✅ CRUD Forums
- ✅ CRUD Messages
- ✅ Recherche & Pagination
- ✅ Statistiques
- ✅ Filtrage multi-critères

### Recrutement Service
- ✅ CRUD Offres
- ✅ Gestion Candidatures
- ✅ Workflow de validation
- ✅ Prévention doublons
- ✅ Conversion candidat → enseignant

---

## 🔧 CONFIGURATION

### Ports Utilisés

| Service              | Port  |
|---------------------|-------|
| MySQL               | 3306  |
| Eureka Server       | 8761  |
| Forum Service       | 8082  |
| Recrutement Service | 8083  |
| API Gateway         | 8080  |

### Bases de Données

- **forum_db** : Forums et messages
- **recrutement_db** : Offres et candidatures

---

## 🛠️ TECHNOLOGIES

- **Spring Boot** 3.2.0
- **Spring Cloud** 2023.0.0
- **Spring Cloud Gateway**
- **Netflix Eureka**
- **Spring Data JPA**
- **MySQL** 8.0
- **Lombok**
- **Maven**

---

## 📈 AVANTAGES DE L'ARCHITECTURE

### 🎯 Avec API Gateway
- ✅ Point d'entrée unique (port 8080)
- ✅ Load balancing automatique
- ✅ Sécurité centralisée
- ✅ Monitoring centralisé
- ✅ CORS géré globalement

### 🎯 Avec Eureka
- ✅ Service Discovery automatique
- ✅ Health checks
- ✅ Scalabilité facile
- ✅ Résilience

---

## 🧪 EXEMPLES D'UTILISATION

### Créer un Forum via Gateway
```bash
curl -X POST http://localhost:8080/api/forum \
  -H "Content-Type: application/json" \
  -d '{
    "titre": "Nouveau Forum",
    "description": "Description",
    "niveau": "L1",
    "statut": "OUVERT"
  }'
```

### Postuler à une Offre via Gateway
```bash
curl -X POST "http://localhost:8080/api/recrutement/candidatures?offreId=1" \
  -H "Content-Type: application/json" \
  -d '{
    "nom_candidat": "Dupont",
    "prenom_candidat": "Jean",
    "email": "jean@example.com"
  }'
```

---

## 🐛 DÉPANNAGE

### Services non enregistrés dans Eureka
1. Vérifier qu'Eureka est démarré
2. Attendre 30-60 secondes
3. Vérifier les logs des services

### Gateway ne route pas
1. Vérifier que les services sont dans Eureka
2. Consulter : http://localhost:8080/actuator/gateway/routes
3. Vérifier les logs du Gateway

### Port déjà utilisé
```cmd
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

---

## 📊 MONITORING

### Eureka Dashboard
http://localhost:8761
- Voir tous les services enregistrés
- Statut de santé
- Nombre d'instances

### Gateway Routes
http://localhost:8080/actuator/gateway/routes
- Liste des routes configurées
- Mapping des services

### Gateway Health
http://localhost:8080/actuator/health
- État de santé du Gateway
- Connexion à Eureka

---

## 🎯 CHECKLIST DE DÉMARRAGE

- [ ] MySQL démarré
- [ ] Eureka Server lancé (8761)
- [ ] Eureka Dashboard accessible
- [ ] Forum Service lancé (8082)
- [ ] Recrutement Service lancé (8083)
- [ ] Services visibles dans Eureka
- [ ] API Gateway lancé (8080)
- [ ] Gateway enregistré dans Eureka
- [ ] Test via Gateway réussi
- [ ] Données de test insérées

---

## 🚀 PROCHAINES ÉTAPES

### Sécurité
- [ ] Spring Security
- [ ] JWT Authentication
- [ ] OAuth2

### Monitoring
- [ ] Zipkin (Distributed Tracing)
- [ ] Prometheus (Metrics)
- [ ] Grafana (Dashboards)

### Résilience
- [ ] Circuit Breaker
- [ ] Retry Logic
- [ ] Fallback

### DevOps
- [ ] Docker
- [ ] Kubernetes
- [ ] CI/CD

---

## 📞 SUPPORT

Consultez la documentation :
1. **GUIDE_EUREKA_GATEWAY.md** - Eureka & Gateway
2. **GUIDE_COMPLET_MICROSERVICES.md** - Services métier
3. **ARCHITECTURE_COMPLETE.md** - Architecture détaillée
4. **INSTRUCTIONS_INTELLIJ.md** - Configuration IDE

---

## 🎉 FÉLICITATIONS !

Vous avez maintenant une architecture microservices complète et professionnelle avec :

✅ Service Discovery (Eureka)
✅ API Gateway
✅ 2 Microservices métier
✅ Load Balancing
✅ Health Monitoring
✅ Documentation complète
✅ Tests automatisés

**Bon développement ! 🚀**
