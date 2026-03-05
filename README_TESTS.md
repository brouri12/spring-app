# 🧪 Guide de Test - Eureka Server & API Gateway

## 📁 Fichiers de Test Disponibles

### Scripts de Démarrage
- **`DEMARRER_TOUS_SERVICES.bat`** - Démarre automatiquement tous les services dans des fenêtres séparées

### Scripts de Test
- **`TEST_EUREKA_GATEWAY.bat`** - Script CMD pour tester tous les services
- **`Test-EurekaGateway.ps1`** - Script PowerShell avec interface colorée
- **`TESTER_TOUS_SERVICES.bat`** - Script de test complet (ancien)

### Documentation
- **`GUIDE_TEST_EUREKA_GATEWAY.md`** - Guide détaillé avec toutes les URLs et commandes

---

## 🚀 Démarrage Rapide (Méthode Recommandée)

### Étape 1 : Démarrer MySQL
```bash
net start MySQL80
```

### Étape 2 : Démarrer tous les services
```bash
DEMARRER_TOUS_SERVICES.bat
```

Ce script va :
1. Vérifier que MySQL est démarré
2. Ouvrir 4 fenêtres CMD pour :
   - Eureka Server (port 8761)
   - Forum Service (port 8082)
   - Recrutement Service (port 8083)
   - API Gateway (port 8086)
3. Attendre que tous les services soient prêts

⏱️ **Temps d'attente** : Environ 2 minutes

### Étape 3 : Tester les services

#### Option A : Script CMD
```bash
TEST_EUREKA_GATEWAY.bat
```

#### Option B : Script PowerShell (Recommandé - Plus joli)
```powershell
.\Test-EurekaGateway.ps1
```

---

## 🎯 Ce que les Scripts Testent

### ✅ Vérifications Effectuées

1. **MySQL** - Vérifie que MySQL est démarré
2. **Eureka Server** - Teste l'accès à http://localhost:8761
3. **Forum Service** - Teste l'accès à http://localhost:8082
4. **Recrutement Service** - Teste l'accès à http://localhost:8083
5. **API Gateway** - Teste l'accès à http://localhost:8086
6. **Enregistrement Eureka** - Vérifie que tous les services sont enregistrés dans Eureka
7. **Routing Gateway** - Teste l'accès aux services via le Gateway

### 📊 Résultat Attendu

```
✅ MySQL est démarré
✅ Eureka Server est accessible
✅ Forum Service est accessible
✅ Recrutement Service est accessible
✅ API Gateway est accessible

Services enregistrés dans Eureka :
  ✅ FORUM-SERVICE est enregistré
  ✅ RECRUTEMENT-SERVICE est enregistré
  ✅ API-GATEWAY est enregistré

✅ Forum accessible via Gateway
✅ Recrutement accessible via Gateway
✅ Routes Gateway accessibles
```

---

## 🌐 URLs Importantes

### Eureka Dashboard
**http://localhost:8761**

Vous devez voir 3 services enregistrés :
- FORUM-SERVICE (1 instance)
- RECRUTEMENT-SERVICE (1 instance)
- API-GATEWAY (1 instance)

### API Gateway
- **Health** : http://localhost:8086/actuator/health
- **Routes** : http://localhost:8086/actuator/gateway/routes

### Accès via Gateway
- **Forum** : http://localhost:8086/forum/api/forum
- **Recrutement** : http://localhost:8086/recrutement/api/recrutement/offres

### Accès Direct (sans Gateway)
- **Forum** : http://localhost:8082/api/forum
- **Recrutement** : http://localhost:8083/api/recrutement/offres

### Swagger UI
- **Forum** : http://localhost:8082/swagger-ui.html
- **Recrutement** : http://localhost:8083/swagger-ui.html

---

## 🔧 Démarrage Manuel (Si vous préférez)

### Terminal 1 : Eureka Server
```bash
cd eureka-server
mvnw spring-boot:run
```
Attendre : `Started EurekaServerApplication in X seconds`

### Terminal 2 : Forum Service
```bash
cd forum-service
mvnw spring-boot:run
```
Attendre : `Started ForumApplication in X seconds`

### Terminal 3 : Recrutement Service
```bash
cd recrutement-service
mvnw spring-boot:run
```
Attendre : `Started RecrutementApplication in X seconds`

### Terminal 4 : API Gateway
```bash
cd api-gateway
mvnw spring-boot:run
```
Attendre : `Started ApiGatewayApplication in X seconds`

---

## 🧪 Tests Manuels avec cURL

### Tester Eureka
```bash
# Dashboard HTML
curl http://localhost:8761

# API JSON
curl http://localhost:8761/eureka/apps -H "Accept: application/json"
```

### Tester Forum Service
```bash
# Direct
curl http://localhost:8082/api/forum

# Via Gateway
curl http://localhost:8086/forum/api/forum
```

### Tester Recrutement Service
```bash
# Direct
curl http://localhost:8083/api/recrutement/offres

# Via Gateway
curl http://localhost:8086/recrutement/api/recrutement/offres
```

### Tester Gateway Routes
```bash
curl http://localhost:8086/actuator/gateway/routes
```

---

## 🐛 Résolution de Problèmes

### Problème : Service non enregistré dans Eureka

**Symptômes** :
- Le service ne apparaît pas dans http://localhost:8761
- Erreur dans les logs : `Cannot execute request on any known server`

**Solutions** :
1. Vérifier qu'Eureka Server est démarré EN PREMIER
2. Attendre 30-60 secondes après le démarrage du service
3. Vérifier dans `application.properties` :
   ```properties
   eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
   ```
4. Redémarrer le service

### Problème : Gateway retourne 404

**Symptômes** :
- http://localhost:8086/forum/api/forum retourne 404
- Accès direct fonctionne : http://localhost:8082/api/forum

**Solutions** :
1. Vérifier que le service est UP dans Eureka Dashboard
2. Vérifier les routes : http://localhost:8086/actuator/gateway/routes
3. Vérifier les logs du Gateway pour les erreurs
4. Attendre 1-2 minutes que le Gateway découvre les services

### Problème : Port déjà utilisé

**Symptômes** :
```
Port 8082 was already in use
```

**Solutions** :
```bash
# Trouver le processus
netstat -ano | findstr :8082

# Tuer le processus (remplacer 1234 par le PID)
taskkill /PID 1234 /F
```

### Problème : MySQL non démarré

**Symptômes** :
```
Communications link failure
```

**Solutions** :
```bash
# Démarrer MySQL
net start MySQL80

# Vérifier le statut
net start | find "MySQL"
```

---

## 📋 Checklist de Vérification

Avant de dire que tout fonctionne, vérifiez :

- [ ] MySQL est démarré
- [ ] Eureka Dashboard accessible (http://localhost:8761)
- [ ] 3 services visibles dans Eureka Dashboard
- [ ] Forum accessible directement (http://localhost:8082/api/forum)
- [ ] Recrutement accessible directement (http://localhost:8083/api/recrutement/offres)
- [ ] Forum accessible via Gateway (http://localhost:8086/forum/api/forum)
- [ ] Recrutement accessible via Gateway (http://localhost:8086/recrutement/api/recrutement/offres)
- [ ] Swagger Forum fonctionne (http://localhost:8082/swagger-ui.html)
- [ ] Swagger Recrutement fonctionne (http://localhost:8083/swagger-ui.html)

---

## 🎓 Comprendre l'Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Eureka Server                        │
│                  (Service Registry)                     │
│                   localhost:8761                        │
└─────────────────────────────────────────────────────────┘
                           ▲
                           │ Registration
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Forum Service│  │  Recrutement │  │ API Gateway  │
│  Port 8082   │  │  Port 8083   │  │  Port 8086   │
└──────────────┘  └──────────────┘  └──────────────┘
                                            ▲
                                            │
                                            │ Routing
                                            │
                                    ┌───────┴────────┐
                                    │   Client       │
                                    │  (Browser)     │
                                    └────────────────┘
```

### Flux de Communication

1. **Enregistrement** : Chaque service s'enregistre auprès d'Eureka au démarrage
2. **Découverte** : API Gateway interroge Eureka pour trouver les services
3. **Routing** : Gateway route les requêtes vers les services appropriés
4. **Load Balancing** : Gateway fait du load balancing si plusieurs instances

---

## 💡 Conseils

### Ordre de Démarrage Recommandé
1. MySQL
2. Eureka Server (attendre 30s)
3. Forum + Recrutement (en parallèle, attendre 40s)
4. API Gateway (attendre 30s)

### Ordre d'Arrêt Recommandé
1. API Gateway
2. Forum + Recrutement
3. Eureka Server
4. MySQL (optionnel)

### Logs à Surveiller
- `DiscoveryClient_SERVICE-NAME - registration status: 204` ✅ Bon
- `Cannot execute request on any known server` ❌ Eureka non accessible
- `Fetching config from server at` ✅ Config Server (si utilisé)

---

## 📞 Support

Pour plus de détails, consultez :
- **GUIDE_TEST_EUREKA_GATEWAY.md** - Guide complet
- Logs des services dans les fenêtres CMD
- Eureka Dashboard : http://localhost:8761

---

## 🎉 Succès !

Si tous les tests passent, vous avez :
- ✅ Une architecture microservices fonctionnelle
- ✅ Service Discovery avec Eureka
- ✅ API Gateway opérationnel
- ✅ Routing et Load Balancing configurés
- ✅ Services accessibles via Swagger

Vous pouvez maintenant développer et tester vos APIs ! 🚀
