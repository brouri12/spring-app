# 🧪 TESTER EUREKA & API GATEWAY

## 🎯 OBJECTIF

Démarrer tous les services et vérifier qu'ils sont bien enregistrés dans Eureka, puis tester l'API Gateway.

---

## 📋 ORDRE DE DÉMARRAGE

### 1️⃣ DÉMARRER MYSQL

```cmd
net start MySQL80
```

**Vérification** :
```cmd
net start | findstr MySQL
```

---

### 2️⃣ DÉMARRER EUREKA SERVER

```cmd
cd eureka-server
mvnw spring-boot:run
```

**⏱️ ATTENDRE 30 SECONDES**

**Vérification** :
Ouvrir dans le navigateur :
```
http://localhost:8761
```

Vous devez voir le dashboard Eureka (vide pour l'instant).

---

### 3️⃣ DÉMARRER FORUM SERVICE

**Nouvelle fenêtre de terminal** :
```cmd
cd forum-service
mvnw spring-boot:run
```

**Message attendu** :
```
Started ForumApplication in X seconds
✅ Données initiales insérées : 2 forums et 5 messages
DiscoveryClient_FORUM-SERVICE - registration status: 204
```

**⏱️ ATTENDRE 15 SECONDES**

**Vérification dans Eureka** :
Rafraîchir http://localhost:8761

Vous devez voir :
```
FORUM-SERVICE (1 instance)
```

---

### 4️⃣ DÉMARRER RECRUTEMENT SERVICE

**Nouvelle fenêtre de terminal** :
```cmd
cd recrutement-service
mvnw spring-boot:run
```

**Message attendu** :
```
Started RecrutementApplication in X seconds
✅ Données initiales insérées : 2 offres et 2 candidatures
DiscoveryClient_RECRUTEMENT-SERVICE - registration status: 204
```

**⏱️ ATTENDRE 15 SECONDES**

**Vérification dans Eureka** :
Rafraîchir http://localhost:8761

Vous devez voir :
```
FORUM-SERVICE (1 instance)
RECRUTEMENT-SERVICE (1 instance)
```

---

### 5️⃣ DÉMARRER API GATEWAY

**Nouvelle fenêtre de terminal** :
```cmd
cd api-gateway
mvnw spring-boot:run
```

**Message attendu** :
```
Started ApiGatewayApplication in X seconds
✅ API GATEWAY DÉMARRÉ
📍 Gateway: http://localhost:8080
```

**⏱️ ATTENDRE 15 SECONDES**

**Vérification dans Eureka** :
Rafraîchir http://localhost:8761

Vous devez voir :
```
API-GATEWAY (1 instance)
FORUM-SERVICE (1 instance)
RECRUTEMENT-SERVICE (1 instance)
```

---

## ✅ VÉRIFICATION COMPLÈTE

### 1. Eureka Dashboard

```
http://localhost:8761
```

**Résultat attendu** :

```
┌─────────────────────────────────────────┐
│   Instances currently registered        │
├─────────────────────────────────────────┤
│  API-GATEWAY         (1 instance)       │
│  FORUM-SERVICE       (1 instance)       │
│  RECRUTEMENT-SERVICE (1 instance)       │
└─────────────────────────────────────────┘
```

---

### 2. Tester les Services Directement

#### Forum Service (Direct)
```
http://localhost:8082/api/forum
```

**Résultat** : JSON avec liste de forums ✅

#### Recrutement Service (Direct)
```
http://localhost:8083/api/recrutement/offres
```

**Résultat** : JSON avec liste d'offres ✅

---

### 3. Tester via API Gateway

#### Forum via Gateway
```
http://localhost:8080/api/forum
```

**Résultat** : JSON avec liste de forums (même résultat que direct) ✅

#### Recrutement via Gateway
```
http://localhost:8080/api/recrutement/offres
```

**Résultat** : JSON avec liste d'offres (même résultat que direct) ✅

---

## 🧪 TESTS COMPLETS

### Test 1 : Créer un Forum via Gateway

```bash
curl -X POST http://localhost:8080/api/forum \
  -H "Content-Type: application/json" \
  -d '{
    "titre": "Test via Gateway",
    "description": "Forum créé via API Gateway",
    "cree_par": 1,
    "niveau": "L1",
    "groupe": "TEST",
    "cours": "Test Gateway",
    "statut": "OUVERT"
  }'
```

**Résultat attendu** : Status 201 Created + Forum créé

---

### Test 2 : Créer une Offre via Gateway

```bash
curl -X POST http://localhost:8080/api/recrutement/offres \
  -H "Content-Type: application/json" \
  -d '{
    "titre": "Test via Gateway",
    "description": "Offre créée via API Gateway",
    "specialite": "Test",
    "experience_min": 2,
    "statut": "OUVERTE"
  }'
```

**Résultat attendu** : Status 201 Created + Offre créée

---

### Test 3 : Vérifier le Load Balancing

Faire plusieurs requêtes successives :

```bash
curl http://localhost:8080/api/forum
curl http://localhost:8080/api/forum
curl http://localhost:8080/api/forum
```

**Résultat** : Toutes les requêtes fonctionnent ✅

---

## 📊 TABLEAU RÉCAPITULATIF

| Service | Port | Status | URL Direct | URL via Gateway |
|---------|------|--------|------------|-----------------|
| Eureka | 8761 | ✅ UP | http://localhost:8761 | - |
| Forum | 8082 | ✅ UP | http://localhost:8082/api/forum | http://localhost:8080/api/forum |
| Recrutement | 8083 | ✅ UP | http://localhost:8083/api/recrutement/offres | http://localhost:8080/api/recrutement/offres |
| Gateway | 8080 | ✅ UP | http://localhost:8080 | - |

---

## 🎨 CAPTURE D'ÉCRAN EUREKA

Quand tout fonctionne, Eureka Dashboard affiche :

```
═══════════════════════════════════════════════════════════
                    Eureka Dashboard
═══════════════════════════════════════════════════════════

System Status
  Environment: test
  Data center: default
  Current time: 2026-02-17 20:30:00

General Info
  Total available memory: 1024 MB
  Environment: test
  Number of CPUs: 4

Instance Info
  ipAddr: 192.168.1.x
  status: UP

Instances currently registered with Eureka
───────────────────────────────────────────────────────────

Application         AMIs        Availability Zones    Status
───────────────────────────────────────────────────────────
API-GATEWAY         n/a (1)     (1)                   UP (1)
FORUM-SERVICE       n/a (1)     (1)                   UP (1)
RECRUTEMENT-SERVICE n/a (1)     (1)                   UP (1)

═══════════════════════════════════════════════════════════
```

---

## 🐛 DÉPANNAGE

### Problème 1 : Service ne s'enregistre pas dans Eureka

**Vérifications** :
1. Eureka est démarré ?
2. Attendre 30-60 secondes (délai d'enregistrement)
3. Vérifier les logs du service :
   ```
   DiscoveryClient_XXX - registration status: 204
   ```

**Solution** :
- Redémarrer le service
- Vérifier `eureka.client.service-url.defaultZone` dans application.properties

---

### Problème 2 : Gateway ne route pas

**Vérifications** :
1. Services sont dans Eureka ?
2. Gateway est démarré après les services ?

**Test** :
```
http://localhost:8080/actuator/gateway/routes
```

Vous devez voir les routes configurées.

---

### Problème 3 : Erreur 503 Service Unavailable

**Cause** : Le service cible n'est pas disponible dans Eureka

**Solution** :
1. Vérifier que le service est UP dans Eureka
2. Attendre quelques secondes
3. Réessayer

---

## 📝 COMMANDES RAPIDES

### Vérifier tous les services

```bash
# Eureka
curl http://localhost:8761

# Forum Direct
curl http://localhost:8082/api/forum

# Recrutement Direct
curl http://localhost:8083/api/recrutement/offres

# Forum via Gateway
curl http://localhost:8080/api/forum

# Recrutement via Gateway
curl http://localhost:8080/api/recrutement/offres
```

---

## ✅ CHECKLIST FINALE

- [ ] MySQL démarré
- [ ] Eureka Server démarré (8761)
- [ ] Eureka Dashboard accessible
- [ ] Forum Service démarré (8082)
- [ ] Forum visible dans Eureka
- [ ] Recrutement Service démarré (8083)
- [ ] Recrutement visible dans Eureka
- [ ] API Gateway démarré (8080)
- [ ] Gateway visible dans Eureka
- [ ] Test Forum direct réussi
- [ ] Test Recrutement direct réussi
- [ ] Test Forum via Gateway réussi
- [ ] Test Recrutement via Gateway réussi

---

## 🎉 SUCCÈS !

Quand tous les services sont UP dans Eureka et que les tests via Gateway fonctionnent, votre architecture microservices est opérationnelle ! 🚀

---

**Bon test ! 🎯**
