# 🏗️ ARCHITECTURE MICROSERVICES COMPLÈTE

## 📊 VUE D'ENSEMBLE

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLIENTS / FRONTEND                          │
│              (Angular, React, Mobile Apps, etc.)                    │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ HTTP/HTTPS Requests
                             │ Port 8080
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          API GATEWAY                                │
│                         Port: 8080                                  │
│                    (Spring Cloud Gateway)                           │
│                                                                     │
│  Fonctionnalités:                                                   │
│  • Routing intelligent                                              │
│  • Load Balancing                                                   │
│  • CORS Management                                                  │
│  • Rate Limiting (optionnel)                                        │
│  • Authentication (optionnel)                                       │
│                                                                     │
│  Routes:                                                            │
│  ├─ /api/forum/**       → FORUM-SERVICE                            │
│  └─ /api/recrutement/** → RECRUTEMENT-SERVICE                      │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ Service Discovery
                             │ Registration & Health Checks
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        EUREKA SERVER                                │
│                         Port: 8761                                  │
│                   (Netflix Eureka Server)                           │
│                                                                     │
│  Services Registry:                                                 │
│  ├─ api-gateway         (1 instance)                               │
│  ├─ forum-service       (1 instance)                               │
│  └─ recrutement-service (1 instance)                               │
│                                                                     │
│  Dashboard: http://localhost:8761                                   │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
┌──────────────────────────┐   ┌──────────────────────────┐
│    FORUM SERVICE         │   │  RECRUTEMENT SERVICE     │
│    Port: 8082            │   │    Port: 8083            │
│                          │   │                          │
│  Endpoints:              │   │  Endpoints:              │
│  • GET /api/forum        │   │  • GET /api/recrutement/ │
│  • POST /api/forum       │   │    offres                │
│  • PUT /api/forum/{id}   │   │  • POST /api/recrutement/│
│  • DELETE /api/forum/{id}│   │    offres                │
│  • GET /api/forum/       │   │  • POST /api/recrutement/│
│    {id}/messages         │   │    candidatures          │
│  • POST /api/forum/      │   │  • PATCH /api/recrutement│
│    message               │   │    /candidatures/{id}/   │
│                          │   │    statut                │
└────────────┬─────────────┘   └────────────┬─────────────┘
             │                              │
             │ JDBC                         │ JDBC
             │                              │
             ▼                              ▼
┌──────────────────────────┐   ┌──────────────────────────┐
│      MYSQL DATABASE      │   │      MYSQL DATABASE      │
│       forum_db           │   │     recrutement_db       │
│       Port: 3306         │   │       Port: 3306         │
│                          │   │                          │
│  Tables:                 │   │  Tables:                 │
│  • forum                 │   │  • offre_recrutement     │
│  • message_forum         │   │  • candidature_enseignant│
└──────────────────────────┘   └──────────────────────────┘
```

---

## 🔄 FLUX DE REQUÊTE

### Exemple : Récupérer tous les forums

```
1. Client envoie:
   GET http://localhost:8080/api/forum
   
2. API Gateway reçoit la requête
   ↓
3. Gateway consulte Eureka:
   "Où est forum-service ?"
   ↓
4. Eureka répond:
   "forum-service est sur localhost:8082"
   ↓
5. Gateway route vers:
   http://localhost:8082/api/forum
   ↓
6. Forum Service traite la requête
   ↓
7. Forum Service interroge MySQL (forum_db)
   ↓
8. MySQL retourne les données
   ↓
9. Forum Service retourne JSON
   ↓
10. Gateway transmet la réponse au Client
```

---

## 🎯 PORTS UTILISÉS

| Service              | Port  | URL                                      |
|---------------------|-------|------------------------------------------|
| MySQL               | 3306  | localhost:3306                           |
| Eureka Server       | 8761  | http://localhost:8761                    |
| Forum Service       | 8082  | http://localhost:8082/api/forum          |
| Recrutement Service | 8083  | http://localhost:8083/api/recrutement    |
| API Gateway         | 8080  | http://localhost:8080                    |

---

## 📡 COMMUNICATION ENTRE SERVICES

```
┌─────────────┐
│   CLIENT    │
└──────┬──────┘
       │
       │ 1. HTTP Request
       │
       ▼
┌─────────────┐
│   GATEWAY   │◄──────┐
└──────┬──────┘       │
       │              │ 3. Service Location
       │              │
       │ 2. Lookup    │
       │              │
       ▼              │
┌─────────────┐       │
│   EUREKA    │───────┘
└─────────────┘
       │
       │ 4. Route to Service
       │
       ▼
┌─────────────┐
│   SERVICE   │
└──────┬──────┘
       │
       │ 5. Database Query
       │
       ▼
┌─────────────┐
│    MYSQL    │
└─────────────┘
```

---

## 🔐 SÉCURITÉ (À IMPLÉMENTER)

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT (Frontend)                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ 1. Login Request
                         │    (username + password)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    API GATEWAY                              │
│                  + AUTHENTICATION                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ 2. Validate Credentials
                         │    Generate JWT Token
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  AUTH SERVICE (Future)                      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ 3. Return JWT Token
                         │
                         ▼
                    ┌─────────┐
                    │ CLIENT  │
                    │ + Token │
                    └────┬────┘
                         │
                         │ 4. Requests with Token
                         │    Authorization: Bearer <token>
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    API GATEWAY                              │
│                  + JWT VALIDATION                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ 5. Forward to Services
                         │    (if token valid)
                         ▼
                  ┌──────────────┐
                  │   SERVICES   │
                  └──────────────┘
```

---

## 📈 SCALABILITÉ

### Configuration Actuelle (1 instance par service)

```
EUREKA
  │
  ├─ api-gateway (1 instance)
  ├─ forum-service (1 instance)
  └─ recrutement-service (1 instance)
```

### Configuration Scalable (Plusieurs instances)

```
EUREKA
  │
  ├─ api-gateway
  │    ├─ Instance 1 (Port 8080)
  │    └─ Instance 2 (Port 8081)
  │
  ├─ forum-service
  │    ├─ Instance 1 (Port 8082)
  │    ├─ Instance 2 (Port 8084)
  │    └─ Instance 3 (Port 8085)
  │
  └─ recrutement-service
       ├─ Instance 1 (Port 8083)
       └─ Instance 2 (Port 8086)
```

**Load Balancing automatique** : Eureka + Gateway distribuent les requêtes entre les instances.

---

## 🔄 HAUTE DISPONIBILITÉ

### Eureka Cluster (Production)

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  EUREKA 1   │◄───►│  EUREKA 2   │◄───►│  EUREKA 3   │
│  Port 8761  │     │  Port 8762  │     │  Port 8763  │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       └───────────────────┴───────────────────┘
                           │
                    ┌──────┴──────┐
                    │  SERVICES   │
                    └─────────────┘
```

---

## 🛠️ TECHNOLOGIES UTILISÉES

```
┌─────────────────────────────────────────────────────────────┐
│                    SPRING ECOSYSTEM                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Spring Boot 3.2.0                                          │
│  ├─ Spring Web                                              │
│  ├─ Spring Data JPA                                         │
│  ├─ Spring Cloud Gateway                                    │
│  └─ Spring Cloud Netflix Eureka                             │
│                                                             │
│  Spring Cloud 2023.0.0                                      │
│  ├─ Service Discovery (Eureka)                              │
│  ├─ API Gateway                                             │
│  └─ Load Balancing (Ribbon)                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    DATABASE & TOOLS                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  MySQL 8.0                                                  │
│  Hibernate/JPA                                              │
│  Lombok                                                     │
│  Maven                                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 MÉTRIQUES ET MONITORING

### Endpoints Actuator Disponibles

```
API Gateway:
├─ /actuator/health          → État de santé
├─ /actuator/info            → Informations
├─ /actuator/gateway/routes  → Routes configurées
└─ /actuator/metrics         → Métriques (si activé)

Services:
├─ /actuator/health          → État de santé
└─ /actuator/info            → Informations
```

### Monitoring Futur (À implémenter)

```
┌─────────────┐
│   ZIPKIN    │  → Distributed Tracing
└─────────────┘

┌─────────────┐
│ PROMETHEUS  │  → Metrics Collection
└─────────────┘

┌─────────────┐
│  GRAFANA    │  → Visualization
└─────────────┘
```

---

## 🚀 DÉPLOIEMENT

### Développement (Actuel)

```
Local Machine
├─ MySQL (localhost:3306)
├─ Eureka Server (localhost:8761)
├─ Forum Service (localhost:8082)
├─ Recrutement Service (localhost:8083)
└─ API Gateway (localhost:8080)
```

### Production (Docker)

```
Docker Compose
├─ mysql-container
├─ eureka-container
├─ forum-service-container (x3 instances)
├─ recrutement-service-container (x2 instances)
└─ api-gateway-container (x2 instances)
```

---

## 🎯 AVANTAGES DE CETTE ARCHITECTURE

### ✅ Scalabilité
- Chaque service peut être scalé indépendamment
- Load balancing automatique

### ✅ Résilience
- Si un service tombe, les autres continuent
- Circuit breaker (à implémenter)

### ✅ Maintenabilité
- Code séparé par domaine métier
- Déploiement indépendant

### ✅ Flexibilité
- Technologie différente par service possible
- Équipes indépendantes

### ✅ Performance
- Cache distribué possible
- Optimisation par service

---

## 📝 ORDRE DE DÉMARRAGE RECOMMANDÉ

```
1️⃣ MySQL Server
   └─→ Base de données

2️⃣ Eureka Server
   └─→ Service Registry

3️⃣ Microservices (Forum, Recrutement)
   └─→ Business Logic

4️⃣ API Gateway
   └─→ Point d'entrée
```

---

## 🔮 ÉVOLUTIONS FUTURES

### Phase 1 : Sécurité
- [ ] Spring Security
- [ ] JWT Authentication
- [ ] OAuth2

### Phase 2 : Monitoring
- [ ] Zipkin (Distributed Tracing)
- [ ] Prometheus (Metrics)
- [ ] Grafana (Dashboards)

### Phase 3 : Résilience
- [ ] Circuit Breaker (Resilience4j)
- [ ] Retry Logic
- [ ] Fallback Mechanisms

### Phase 4 : Configuration
- [ ] Spring Cloud Config Server
- [ ] Centralized Configuration
- [ ] Dynamic Refresh

### Phase 5 : Messaging
- [ ] RabbitMQ / Kafka
- [ ] Event-Driven Architecture
- [ ] Async Communication

### Phase 6 : DevOps
- [ ] Docker Containers
- [ ] Kubernetes Orchestration
- [ ] CI/CD Pipeline

---

**Architecture Microservices Complète et Fonctionnelle ! 🎉**
