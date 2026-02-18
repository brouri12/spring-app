# 🚀 GUIDE COMPLET - EUREKA SERVER & API GATEWAY

## 📋 TABLE DES MATIÈRES

1. [Eureka Server](#eureka-server)
2. [API Gateway](#api-gateway)
3. [Ordre de Démarrage](#ordre-de-démarrage)
4. [Tests et Vérification](#tests-et-vérification)
5. [Architecture Complète](#architecture-complète)

---

## 🔷 EUREKA SERVER

### Qu'est-ce qu'Eureka Server ?

Eureka Server est un **Service Discovery** (registre de services) qui permet aux microservices de :
- S'enregistrer automatiquement au démarrage
- Se découvrir mutuellement sans connaître leurs adresses IP/ports
- Gérer la haute disponibilité et le load balancing

### Structure du Projet

```
eureka-server/
├── src/main/java/tn/esprit/eureka/
│   └── EurekaServerApplication.java
├── src/main/resources/
│   └── application.properties
└── pom.xml
```

### Configuration

**Port par défaut** : 8761

**application.properties** :
```properties
spring.application.name=eureka-server
server.port=8761

# Ne pas s'enregistrer lui-même
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
```

### Démarrage

#### Option 1 : Via IntelliJ IDEA
1. Ouvrir le projet `eureka-server`
2. Clic droit sur `EurekaServerApplication.java` → Run

#### Option 2 : Via Maven
```cmd
cd eureka-server
mvnw spring-boot:run
```

### Vérification

Ouvrir le navigateur : **http://localhost:8761**

Vous verrez le dashboard Eureka avec :
- Liste des services enregistrés
- Statut de santé
- Informations système

---

## 🌐 API GATEWAY

### Qu'est-ce qu'API Gateway ?

API Gateway est un **point d'entrée unique** pour tous les microservices qui permet de :
- Router les requêtes vers les bons services
- Gérer le load balancing automatique
- Centraliser la gestion CORS
- Ajouter de la sécurité (authentification, rate limiting)
- Monitorer les requêtes

### Structure du Projet

```
api-gateway/
├── src/main/java/tn/esprit/gateway/
│   ├── ApiGatewayApplication.java
│   └── GatewayConfig.java
├── src/main/resources/
│   └── application.properties
└── pom.xml
```

### Configuration

**Port par défaut** : 8080

**Routes configurées** :
```
/forum/**       → Forum Service (port 8082)
/recrutement/** → Recrutement Service (port 8083)
/api/forum/**   → Forum Service (route alternative)
/api/recrutement/** → Recrutement Service (route alternative)
```

### Démarrage

#### Option 1 : Via IntelliJ IDEA
1. Ouvrir le projet `api-gateway`
2. Clic droit sur `ApiGatewayApplication.java` → Run

#### Option 2 : Via Maven
```cmd
cd api-gateway
mvnw spring-boot:run
```

### Vérification

Tester les routes :
```http
GET http://localhost:8080/api/forum
GET http://localhost:8080/api/recrutement/offres
```

---

## 🔄 ORDRE DE DÉMARRAGE

### ⚠️ IMPORTANT : Respecter cet ordre !

```
1️⃣ MySQL Server
   └─→ net start MySQL80

2️⃣ Eureka Server (Port 8761)
   └─→ cd eureka-server
   └─→ mvnw spring-boot:run
   └─→ Attendre 30 secondes

3️⃣ Forum Service (Port 8082)
   └─→ cd forum-service
   └─→ mvnw spring-boot:run
   └─→ Attendre l'enregistrement dans Eureka

4️⃣ Recrutement Service (Port 8083)
   └─→ cd recrutement-service
   └─→ mvnw spring-boot:run
   └─→ Attendre l'enregistrement dans Eureka

5️⃣ API Gateway (Port 8080)
   └─→ cd api-gateway
   └─→ mvnw spring-boot:run
   └─→ Gateway prêt !
```

### Script de Démarrage Automatique

Utilisez le script fourni :
```cmd
START_ALL_SERVICES.bat
```

---

## ✅ TESTS ET VÉRIFICATION

### 1. Vérifier Eureka Dashboard

**URL** : http://localhost:8761

**Services attendus** :
- ✅ FORUM-SERVICE
- ✅ RECRUTEMENT-SERVICE
- ✅ API-GATEWAY

### 2. Tester l'API Gateway

#### Via le Gateway (Port 8080)
```http
# Forum Service via Gateway
GET http://localhost:8080/api/forum
GET http://localhost:8080/api/forum/1
POST http://localhost:8080/api/forum
Content-Type: application/json

{
  "titre": "Test via Gateway",
  "description": "Test",
  "niveau": "L1",
  "statut": "OUVERT"
}

# Recrutement Service via Gateway
GET http://localhost:8080/api/recrutement/offres
GET http://localhost:8080/api/recrutement/offres/1
```

#### Accès Direct (Sans Gateway)
```http
# Forum Service direct
GET http://localhost:8082/api/forum

# Recrutement Service direct
GET http://localhost:8083/api/recrutement/offres
```

### 3. Vérifier les Endpoints Actuator

```http
# Gateway Health
GET http://localhost:8080/actuator/health

# Gateway Routes
GET http://localhost:8080/actuator/gateway/routes
```

---

## 🏗️ ARCHITECTURE COMPLÈTE

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT / FRONTEND                        │
│                  (Angular, React, etc.)                     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ HTTP Requests
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                     API GATEWAY                             │
│                   Port: 8080                                │
│              (Point d'entrée unique)                        │
│                                                             │
│  Routes:                                                    │
│  • /api/forum/**       → Forum Service                     │
│  • /api/recrutement/** → Recrutement Service               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ Service Discovery
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   EUREKA SERVER                             │
│                   Port: 8761                                │
│              (Service Registry)                             │
│                                                             │
│  Services enregistrés:                                      │
│  • forum-service                                            │
│  • recrutement-service                                      │
│  • api-gateway                                              │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
┌────────────────┐      ┌────────────────┐
│ FORUM SERVICE  │      │  RECRUTEMENT   │
│   Port: 8082   │      │    SERVICE     │
│                │      │   Port: 8083   │
└────────┬───────┘      └────────┬───────┘
         │                       │
         ▼                       ▼
┌────────────────┐      ┌────────────────┐
│   forum_db     │      │ recrutement_db │
│    (MySQL)     │      │    (MySQL)     │
└────────────────┘      └────────────────┘
```

---

## 📊 COMPARAISON : AVEC vs SANS GATEWAY

### ❌ SANS API GATEWAY

```
Frontend → http://localhost:8082/api/forum
Frontend → http://localhost:8083/api/recrutement/offres

Problèmes:
- Le frontend doit connaître tous les ports
- Pas de point d'entrée unique
- Difficile à sécuriser
- Pas de load balancing centralisé
```

### ✅ AVEC API GATEWAY

```
Frontend → http://localhost:8080/api/forum
Frontend → http://localhost:8080/api/recrutement/offres

Avantages:
- Point d'entrée unique (port 8080)
- Le frontend ne connaît qu'une seule URL
- Sécurité centralisée
- Load balancing automatique
- Monitoring centralisé
```

---

## 🧪 TESTS COMPLETS

### Test 1 : Vérifier Eureka

```http
GET http://localhost:8761
```

**Résultat attendu** : Dashboard Eureka avec 3 services

### Test 2 : Forum via Gateway

```http
GET http://localhost:8080/api/forum
```

**Résultat attendu** : Liste des forums (JSON)

### Test 3 : Recrutement via Gateway

```http
GET http://localhost:8080/api/recrutement/offres
```

**Résultat attendu** : Liste des offres (JSON)

### Test 4 : Créer un Forum via Gateway

```http
POST http://localhost:8080/api/forum
Content-Type: application/json

{
  "titre": "Test Gateway",
  "description": "Forum créé via API Gateway",
  "cree_par": 1,
  "niveau": "L1",
  "groupe": "TEST",
  "cours": "Test",
  "statut": "OUVERT"
}
```

**Résultat attendu** : Forum créé (Status 201)

### Test 5 : Routes du Gateway

```http
GET http://localhost:8080/actuator/gateway/routes
```

**Résultat attendu** : Liste des routes configurées

---

## 🔧 CONFIGURATION AVANCÉE

### Load Balancing

Le Gateway utilise **Ribbon** (intégré) pour le load balancing :

```properties
# Si vous avez plusieurs instances du même service
spring.cloud.gateway.routes[0].uri=lb://forum-service
```

`lb://` signifie "Load Balanced" - Eureka choisira automatiquement une instance disponible.

### Filtres Personnalisés

Vous pouvez ajouter des filtres dans `GatewayConfig.java` :

```java
.route("forum-service", r -> r
    .path("/forum/**")
    .filters(f -> f
        .addRequestHeader("X-Gateway", "API-Gateway")
        .addResponseHeader("X-Response-Time", "100ms")
    )
    .uri("lb://forum-service"))
```

### Rate Limiting (Limitation de débit)

```java
.route("forum-service", r -> r
    .path("/forum/**")
    .filters(f -> f.requestRateLimiter(c -> c
        .setRateLimiter(redisRateLimiter())
    ))
    .uri("lb://forum-service"))
```

---

## 🐛 DÉPANNAGE

### Problème 1 : Services non enregistrés dans Eureka

**Solution** :
1. Vérifier qu'Eureka est démarré
2. Vérifier `eureka.client.service-url.defaultZone` dans application.properties
3. Attendre 30-60 secondes (délai d'enregistrement)

### Problème 2 : Gateway ne route pas correctement

**Solution** :
1. Vérifier les logs du Gateway
2. Vérifier que les services sont enregistrés dans Eureka
3. Tester l'accès direct aux services (ports 8082, 8083)
4. Vérifier les routes : `http://localhost:8080/actuator/gateway/routes`

### Problème 3 : Erreur CORS

**Solution** :
Vérifier la configuration CORS dans `application.properties` du Gateway :
```properties
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-origins=*
```

### Problème 4 : Port déjà utilisé

**Solution** :
```cmd
# Vérifier les ports utilisés
netstat -ano | findstr :8761
netstat -ano | findstr :8080

# Tuer le processus si nécessaire
taskkill /PID <PID> /F
```

---

## 📝 FICHIERS DE TEST

### test-gateway.http

```http
### Vérifier Eureka
GET http://localhost:8761

### Vérifier Gateway Health
GET http://localhost:8080/actuator/health

### Vérifier Routes Gateway
GET http://localhost:8080/actuator/gateway/routes

### Forum via Gateway
GET http://localhost:8080/api/forum

### Recrutement via Gateway
GET http://localhost:8080/api/recrutement/offres

### Créer Forum via Gateway
POST http://localhost:8080/api/forum
Content-Type: application/json

{
  "titre": "Test Gateway",
  "description": "Test",
  "niveau": "L1",
  "statut": "OUVERT"
}
```

---

## 🎯 CHECKLIST FINALE

### Eureka Server
- [ ] Projet créé
- [ ] Dépendances Maven téléchargées
- [ ] Service démarré sur port 8761
- [ ] Dashboard accessible
- [ ] Services enregistrés visibles

### API Gateway
- [ ] Projet créé
- [ ] Dépendances Maven téléchargées
- [ ] Service démarré sur port 8080
- [ ] Enregistré dans Eureka
- [ ] Routes fonctionnelles
- [ ] CORS configuré

### Tests
- [ ] Accès direct aux services (8082, 8083)
- [ ] Accès via Gateway (8080)
- [ ] Création de ressources via Gateway
- [ ] Vérification des routes Actuator

---

## 🚀 PROCHAINES ÉTAPES

1. **Sécurité** : Ajouter Spring Security + JWT
2. **Monitoring** : Ajouter Zipkin pour le tracing distribué
3. **Resilience** : Ajouter Circuit Breaker (Resilience4j)
4. **Config Server** : Centraliser les configurations
5. **Docker** : Containeriser tous les services

---

**Votre architecture microservices est maintenant complète ! 🎉**
