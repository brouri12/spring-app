# 🚀 ORDRE DE DÉMARRAGE - GUIDE VISUEL

## ⚠️ IMPORTANT : RESPECTER CET ORDRE !

```
┌─────────────────────────────────────────────────────────────┐
│                    ORDRE DE DÉMARRAGE                       │
└─────────────────────────────────────────────────────────────┘

1️⃣  MySQL Server
     ↓
     Attendre : 5 secondes
     ↓
2️⃣  Eureka Server (Port 8761)
     ↓
     Attendre : 30 secondes ⏱️
     ↓
3️⃣  Forum Service (Port 8082)
     ↓
     Attendre : 15 secondes
     ↓
4️⃣  Recrutement Service (Port 8083)
     ↓
     Attendre : 15 secondes
     ↓
5️⃣  API Gateway (Port 8080)
     ↓
     Attendre : 15 secondes
     ↓
✅  ARCHITECTURE PRÊTE !
```

---

## 📋 ÉTAPE PAR ÉTAPE

### 1️⃣ MYSQL SERVER

```cmd
net start MySQL80
```

**Vérification** :
```cmd
mysql -u root -p
```

**Temps d'attente** : 5 secondes

---

### 2️⃣ EUREKA SERVER

```cmd
cd eureka-server
mvnw spring-boot:run
```

**Vérification** :
- Ouvrir : http://localhost:8761
- Voir le dashboard Eureka

**Message attendu dans la console** :
```
✅ EUREKA SERVER DÉMARRÉ
📍 Dashboard: http://localhost:8761
```

**Temps d'attente** : 30 secondes ⏱️

**⚠️ IMPORTANT** : Attendre que Eureka soit complètement démarré avant de lancer les autres services !

---

### 3️⃣ FORUM SERVICE

```cmd
cd forum-service
mvnw spring-boot:run
```

**Vérification** :
- Console : `✅ Données initiales insérées : 2 forums et 5 messages`
- Eureka : Voir `FORUM-SERVICE` dans http://localhost:8761
- API : http://localhost:8082/api/forum

**Temps d'attente** : 15 secondes

---

### 4️⃣ RECRUTEMENT SERVICE

```cmd
cd recrutement-service
mvnw spring-boot:run
```

**Vérification** :
- Console : `✅ Données initiales insérées : 2 offres et 2 candidatures`
- Eureka : Voir `RECRUTEMENT-SERVICE` dans http://localhost:8761
- API : http://localhost:8083/api/recrutement/offres

**Temps d'attente** : 15 secondes

---

### 5️⃣ API GATEWAY

```cmd
cd api-gateway
mvnw spring-boot:run
```

**Vérification** :
- Console : `✅ API GATEWAY DÉMARRÉ`
- Eureka : Voir `API-GATEWAY` dans http://localhost:8761
- Routes : http://localhost:8080/actuator/gateway/routes

**Message attendu dans la console** :
```
✅ API GATEWAY DÉMARRÉ
📍 Gateway: http://localhost:8080
Routes disponibles:
  → /forum/**       → Forum Service
  → /recrutement/** → Recrutement Service
```

**Temps d'attente** : 15 secondes

---

## ✅ VÉRIFICATION FINALE

### 1. Eureka Dashboard
```
http://localhost:8761
```

**Vous devez voir 3 services** :
- ✅ API-GATEWAY
- ✅ FORUM-SERVICE
- ✅ RECRUTEMENT-SERVICE

### 2. Test via Gateway
```http
GET http://localhost:8080/api/forum
GET http://localhost:8080/api/recrutement/offres
```

**Résultat attendu** : Données JSON

---

## ⏱️ TEMPS TOTAL

```
MySQL:              5 secondes
Eureka:            30 secondes
Forum:             15 secondes
Recrutement:       15 secondes
Gateway:           15 secondes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL:             80 secondes (~1 min 20 sec)
```

---

## 🔄 ORDRE VISUEL DÉTAILLÉ

```
┌──────────────┐
│    MYSQL     │  ← Démarrer en premier
│   Port 3306  │
└──────┬───────┘
       │
       │ Base de données prête
       │
       ▼
┌──────────────┐
│    EUREKA    │  ← Démarrer en second
│   Port 8761  │     ATTENDRE 30 SECONDES !
└──────┬───────┘
       │
       │ Service Registry prêt
       │
       ├─────────────────┬─────────────────┐
       │                 │                 │
       ▼                 ▼                 ▼
┌──────────┐      ┌──────────┐      ┌──────────┐
│  FORUM   │      │RECRUTEMENT│     │ GATEWAY  │
│   8082   │      │   8083   │      │   8080   │
└────┬─────┘      └────┬─────┘      └────┬─────┘
     │                 │                  │
     │ S'enregistre    │ S'enregistre    │ S'enregistre
     │ dans Eureka     │ dans Eureka     │ dans Eureka
     │                 │                  │
     ▼                 ▼                  ▼
┌──────────┐      ┌──────────┐      ┌──────────┐
│forum_db  │      │recrutement│     │  Prêt à  │
│          │      │    _db    │      │  router  │
└──────────┘      └──────────┘      └──────────┘
```

---

## 🚫 ERREURS COURANTES

### Erreur 1 : Services non enregistrés dans Eureka

**Cause** : Eureka pas complètement démarré

**Solution** :
1. Arrêter tous les services
2. Démarrer Eureka
3. **ATTENDRE 30 SECONDES**
4. Démarrer les autres services

### Erreur 2 : Gateway ne trouve pas les services

**Cause** : Services lancés avant Eureka

**Solution** :
1. Vérifier que les services sont dans Eureka (http://localhost:8761)
2. Redémarrer le Gateway si nécessaire

### Erreur 3 : Port déjà utilisé

**Cause** : Service déjà en cours d'exécution

**Solution** :
```cmd
# Trouver le processus
netstat -ano | findstr :8761

# Tuer le processus
taskkill /PID <PID> /F
```

---

## 🎯 CHECKLIST DE DÉMARRAGE

```
☐ MySQL démarré
   └─→ net start MySQL80

☐ Eureka Server lancé
   └─→ cd eureka-server && mvnw spring-boot:run
   └─→ ⏱️ ATTENDRE 30 SECONDES

☐ Eureka Dashboard accessible
   └─→ http://localhost:8761

☐ Forum Service lancé
   └─→ cd forum-service && mvnw spring-boot:run
   └─→ ⏱️ Attendre 15 secondes

☐ Forum visible dans Eureka
   └─→ Vérifier http://localhost:8761

☐ Recrutement Service lancé
   └─→ cd recrutement-service && mvnw spring-boot:run
   └─→ ⏱️ Attendre 15 secondes

☐ Recrutement visible dans Eureka
   └─→ Vérifier http://localhost:8761

☐ API Gateway lancé
   └─→ cd api-gateway && mvnw spring-boot:run
   └─→ ⏱️ Attendre 15 secondes

☐ Gateway visible dans Eureka
   └─→ Vérifier http://localhost:8761

☐ Test via Gateway
   └─→ GET http://localhost:8080/api/forum
   └─→ GET http://localhost:8080/api/recrutement/offres

✅ ARCHITECTURE OPÉRATIONNELLE !
```

---

## 🔧 SCRIPT AUTOMATIQUE

Pour éviter de faire tout manuellement, utilisez :

```cmd
START_ALL_SERVICES.bat
```

Ce script :
1. ✅ Démarre MySQL
2. ✅ Lance Eureka et attend 30 secondes
3. ✅ Lance Forum Service et attend 10 secondes
4. ✅ Lance Recrutement Service et attend 10 secondes
5. ✅ Lance API Gateway
6. ✅ Affiche toutes les URLs

---

## 📊 MONITORING DU DÉMARRAGE

### Console Eureka
```
http://localhost:8761
```

**Progression attendue** :
```
Temps 0s   : Eureka seul
Temps 30s  : Eureka + Forum
Temps 45s  : Eureka + Forum + Recrutement
Temps 60s  : Eureka + Forum + Recrutement + Gateway
```

### Logs à surveiller

**Eureka** :
```
Registered instance FORUM-SERVICE/...
Registered instance RECRUTEMENT-SERVICE/...
Registered instance API-GATEWAY/...
```

**Services** :
```
DiscoveryClient_FORUM-SERVICE/... - registration status: 204
```

**Gateway** :
```
Mapped [/api/forum/**] onto lb://forum-service
Mapped [/api/recrutement/**] onto lb://recrutement-service
```

---

## 🎉 SUCCÈS !

Quand vous voyez ceci dans Eureka Dashboard :

```
┌─────────────────────────────────────┐
│   Instances currently registered    │
├─────────────────────────────────────┤
│  API-GATEWAY         (1 instance)   │
│  FORUM-SERVICE       (1 instance)   │
│  RECRUTEMENT-SERVICE (1 instance)   │
└─────────────────────────────────────┘
```

**Votre architecture est prête ! 🚀**

---

## 📝 NOTES IMPORTANTES

1. **Toujours démarrer Eureka en premier**
2. **Attendre 30 secondes après Eureka**
3. **Vérifier Eureka Dashboard entre chaque service**
4. **Ne pas fermer les fenêtres de console**
5. **Utiliser le script automatique pour gagner du temps**

---

**Bon démarrage ! 🚀**
