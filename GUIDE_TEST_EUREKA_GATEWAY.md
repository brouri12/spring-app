# Guide de Test - Eureka Server & API Gateway

## 🚀 Démarrage Rapide

### Option 1 : Démarrage Automatique
```bash
DEMARRER_TOUS_SERVICES.bat
```
Attend 2 minutes, puis :
```bash
TEST_EUREKA_GATEWAY.bat
```

### Option 2 : Démarrage Manuel

#### 1. Démarrer MySQL
```bash
net start MySQL80
```

#### 2. Démarrer Eureka Server (Terminal 1)
```bash
cd eureka-server
mvnw spring-boot:run
```
Attendre le message : `Started EurekaServerApplication`

#### 3. Démarrer Forum Service (Terminal 2)
```bash
cd forum-service
mvnw spring-boot:run
```
Attendre : `Started ForumApplication`

#### 4. Démarrer Recrutement Service (Terminal 3)
```bash
cd recrutement-service
mvnw spring-boot:run
```
Attendre : `Started RecrutementApplication`

#### 5. Démarrer API Gateway (Terminal 4)
```bash
cd api-gateway
mvnw spring-boot:run
```
Attendre : `Started ApiGatewayApplication`

---

## 📊 Vérification dans Eureka Dashboard

### Accéder au Dashboard
Ouvrez : **http://localhost:8761**

### Services à vérifier
Dans la section "Instances currently registered with Eureka", vous devez voir :

✅ **FORUM-SERVICE** - 1 instance
- Status: UP
- Instance ID: forum-service:8082

✅ **RECRUTEMENT-SERVICE** - 1 instance
- Status: UP
- Instance ID: recrutement-service:8083

✅ **API-GATEWAY** - 1 instance
- Status: UP
- Instance ID: api-gateway:8086

---

## 🔧 Test de l'API Gateway

### 1. Vérifier la santé du Gateway
```bash
curl http://localhost:8086/actuator/health
```
Réponse attendue :
```json
{"status":"UP"}
```

### 2. Voir les routes configurées
```bash
curl http://localhost:8086/actuator/gateway/routes
```

### 3. Tester Forum via Gateway
```bash
# Direct
curl http://localhost:8082/api/forum

# Via Gateway
curl http://localhost:8086/forum/api/forum
```

### 4. Tester Recrutement via Gateway
```bash
# Direct
curl http://localhost:8083/api/recrutement/offres

# Via Gateway
curl http://localhost:8086/recrutement/api/recrutement/offres
```

---

## 📝 URLs Importantes

### Eureka Server
- **Dashboard** : http://localhost:8761
- **API Apps** : http://localhost:8761/eureka/apps

### API Gateway (Port 8086)
- **Health** : http://localhost:8086/actuator/health
- **Routes** : http://localhost:8086/actuator/gateway/routes
- **Forum via Gateway** : http://localhost:8086/forum/api/forum
- **Recrutement via Gateway** : http://localhost:8086/recrutement/api/recrutement/offres

### Forum Service (Port 8082)
- **API Direct** : http://localhost:8082/api/forum
- **Swagger UI** : http://localhost:8082/swagger-ui.html
- **API Docs** : http://localhost:8082/v3/api-docs
- **Health** : http://localhost:8082/actuator/health

### Recrutement Service (Port 8083)
- **API Direct** : http://localhost:8083/api/recrutement/offres
- **Swagger UI** : http://localhost:8083/swagger-ui.html
- **API Docs** : http://localhost:8083/v3/api-docs
- **Health** : http://localhost:8083/actuator/health

---

## 🧪 Tests avec Swagger

### Forum Service
1. Ouvrir : http://localhost:8082/swagger-ui.html
2. Tester les endpoints :
   - `GET /api/forum` - Liste des forums
   - `POST /api/forum` - Créer un forum
   - `GET /api/forum/{id}` - Détails d'un forum

### Recrutement Service
1. Ouvrir : http://localhost:8083/swagger-ui.html
2. Tester les endpoints :
   - `GET /api/recrutement/offres` - Liste des offres
   - `POST /api/recrutement/offres` - Créer une offre
   - `GET /api/recrutement/offres/{id}` - Détails d'une offre
   - `POST /api/recrutement/candidatures?offreId={id}` - Postuler

---

## ⚠️ Résolution de Problèmes

### Service non enregistré dans Eureka

**Symptôme** : Le service ne apparaît pas dans le dashboard Eureka

**Solutions** :
1. Vérifier que Eureka Server est démarré en premier
2. Attendre 30-60 secondes après le démarrage du service
3. Vérifier les logs du service pour :
   ```
   DiscoveryClient_SERVICE-NAME - registration status: 204
   ```
4. Vérifier la configuration dans `application.properties` :
   ```properties
   eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
   eureka.instance.prefer-ip-address=true
   ```

### Gateway ne route pas correctement

**Symptôme** : Erreur 404 ou 503 via le Gateway

**Solutions** :
1. Vérifier que les services sont UP dans Eureka
2. Vérifier les routes : http://localhost:8086/actuator/gateway/routes
3. Vérifier les logs du Gateway pour les erreurs de routing
4. Tester l'accès direct au service (sans Gateway)

### Erreur "Cannot execute request on any known server"

**Symptôme** : Erreur lors de l'arrêt du service

**Cause** : Eureka Server n'est pas accessible lors de la désinscription

**Solution** : 
- C'est normal si vous arrêtez Eureka avant les services
- Arrêtez toujours les services clients avant Eureka Server
- Ou ignorez cette erreur (elle n'affecte pas le fonctionnement)

### Port déjà utilisé

**Symptôme** : `Port 8082 was already in use`

**Solutions** :
```bash
# Windows - Trouver le processus
netstat -ano | findstr :8082

# Tuer le processus (remplacer PID)
taskkill /PID <PID> /F
```

---

## 📋 Checklist de Vérification

- [ ] MySQL est démarré
- [ ] Eureka Server est accessible (http://localhost:8761)
- [ ] Forum Service apparaît dans Eureka Dashboard
- [ ] Recrutement Service apparaît dans Eureka Dashboard
- [ ] API Gateway apparaît dans Eureka Dashboard
- [ ] Forum accessible directement (http://localhost:8082/api/forum)
- [ ] Recrutement accessible directement (http://localhost:8083/api/recrutement/offres)
- [ ] Forum accessible via Gateway (http://localhost:8086/forum/api/forum)
- [ ] Recrutement accessible via Gateway (http://localhost:8086/recrutement/api/recrutement/offres)
- [ ] Swagger Forum fonctionne (http://localhost:8082/swagger-ui.html)
- [ ] Swagger Recrutement fonctionne (http://localhost:8083/swagger-ui.html)

---

## 🎯 Commandes Utiles

### Vérifier les services dans Eureka (JSON)
```bash
curl http://localhost:8761/eureka/apps -H "Accept: application/json"
```

### Vérifier les routes du Gateway
```bash
curl http://localhost:8086/actuator/gateway/routes | json_pp
```

### Tester un endpoint via Gateway
```bash
curl -X GET http://localhost:8086/forum/api/forum
curl -X GET http://localhost:8086/recrutement/api/recrutement/offres
```

### Vérifier la santé de tous les services
```bash
curl http://localhost:8761/actuator/health
curl http://localhost:8082/actuator/health
curl http://localhost:8083/actuator/health
curl http://localhost:8086/actuator/health
```

---

## 📞 Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs de chaque service
2. Consultez le dashboard Eureka
3. Testez l'accès direct aux services avant de tester via Gateway
4. Vérifiez que tous les ports sont disponibles (8761, 8082, 8083, 8086)
