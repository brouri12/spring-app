# 🔧 Corriger l'erreur CORS

## ❌ Erreur

```
Access to XMLHttpRequest at 'http://localhost:8082/api/forum/forums' from origin 'http://localhost:4200' 
has been blocked by CORS policy: Response to preflight request doesn't pass access control check: 
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

## ✅ Solution

### 1. Configuration CORS ajoutée

J'ai créé `CorsConfig.java` dans les deux services :
- `forum-service/src/main/java/tn/esprit/forum/config/CorsConfig.java`
- `recrutement-service/src/main/java/tn/esprit/recrutement/config/CorsConfig.java`

### 2. Redémarrer les services

**IMPORTANT** : Vous devez redémarrer les services Spring Boot pour que la configuration CORS soit prise en compte.

```cmd
# Arrêtez les services en cours (Ctrl+C dans chaque terminal)

# Puis recompilez et redémarrez

# Forum Service
cd forum-service
mvn clean install
mvn spring-boot:run

# Recrutement Service (dans un autre terminal)
cd recrutement-service
mvn clean install
mvn spring-boot:run
```

### 3. Vider le cache du navigateur

Après le redémarrage des services :

1. Ouvrez les DevTools (F12)
2. Clic droit sur le bouton Actualiser
3. Choisissez "Vider le cache et actualiser de force"

OU

1. Ctrl + Shift + Delete
2. Cochez "Images et fichiers en cache"
3. Cliquez sur "Effacer les données"

### 4. Tester à nouveau

Rechargez la page Angular : `http://localhost:4200/forum`

---

## 🔍 Vérification

### Tester CORS avec curl

```cmd
# Test OPTIONS (preflight)
curl -X OPTIONS http://localhost:8082/api/forum/forums ^
  -H "Origin: http://localhost:4200" ^
  -H "Access-Control-Request-Method: GET" ^
  -v

# Vous devriez voir dans la réponse :
# Access-Control-Allow-Origin: http://localhost:4200
# Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS
```

### Vérifier dans les logs Spring Boot

Quand vous faites une requête depuis Angular, vous devriez voir dans les logs :

```
INFO ... Mapped to [tn.esprit.forum.controller.ForumRestAPI#getAllForums()]
```

Si vous voyez une erreur 400 ou 403, c'est que CORS n'est pas correctement configuré.

---

## 🛠️ Alternative : Configuration dans application.properties

Si la configuration Java ne fonctionne pas, ajoutez ceci dans `application.properties` :

```properties
# CORS Configuration
spring.web.cors.allowed-origins=http://localhost:4200
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,PATCH,OPTIONS
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true
spring.web.cors.max-age=3600
```

---

## 🐛 Autres causes possibles

### 1. Port incorrect

Vérifiez que Angular tourne bien sur le port 4200 :
```cmd
netstat -ano | findstr :4200
```

### 2. Service Spring Boot non démarré

Vérifiez que le service est bien démarré :
```cmd
curl http://localhost:8082/api/forum/forums
```

Si vous obtenez une réponse JSON, le service fonctionne.

### 3. Firewall Windows

Parfois le firewall bloque les connexions. Autorisez Java :
- Panneau de configuration → Pare-feu Windows
- Autoriser une application
- Ajoutez Java (java.exe et javaw.exe)

### 4. Proxy ou VPN

Si vous utilisez un proxy ou VPN, désactivez-le temporairement pour tester.

---

## ✅ Checklist de vérification

- [ ] CorsConfig.java créé dans forum-service
- [ ] CorsConfig.java créé dans recrutement-service
- [ ] Services Spring Boot redémarrés avec `mvn clean install`
- [ ] Cache du navigateur vidé
- [ ] Page Angular rechargée
- [ ] Logs Spring Boot vérifiés (pas d'erreur 400/403)
- [ ] Test curl réussi

---

## 🎯 Résultat attendu

Après ces étapes, vous devriez voir dans la console du navigateur :

```
GET http://localhost:8082/api/forum/forums 200 OK
```

Et les forums devraient s'afficher dans l'interface Angular.

---

## 📞 Si le problème persiste

1. Copiez les logs complets du service Spring Boot
2. Copiez les erreurs de la console du navigateur (F12)
3. Vérifiez que MySQL est bien démarré
4. Testez directement l'API avec Swagger : `http://localhost:8082/swagger-ui/index.html`
