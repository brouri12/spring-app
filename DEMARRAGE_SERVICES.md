# Guide de Démarrage des Services

## ⚠️ Problème Actuel

Les erreurs 400 lors du chargement des données indiquent que les services backend ne démarrent pas correctement ou qu'il y a un problème avec les données.

## 🔧 Solution Rapide

### Étape 1: Nettoyer les bases de données H2

Les bases de données H2 peuvent être corrompues. Supprimez-les :

```bash
# Supprimer toutes les bases de données H2
del /s *.db
```

### Étape 2: Vérifier que les services ne sont pas déjà en cours

```bash
# Arrêter tous les processus Java
taskkill /F /IM java.exe
```

### Étape 3: Démarrer les services dans l'ordre

#### 1. Eureka Server (Port 8761)

Ouvrez un terminal dans le dossier `eureka-server` et exécutez :

```bash
# Si Maven est installé globalement
mvn spring-boot:run

# OU si vous avez Maven Wrapper
./mvnw spring-boot:run

# OU via votre IDE (IntelliJ IDEA, Eclipse, VS Code)
# Clic droit sur EurekaServerApplication.java > Run
```

Attendez que le message suivant apparaisse :
```
Started EurekaServerApplication in X seconds
```

Vérifiez : http://localhost:8761

#### 2. Forum Service (Port 8082)

Ouvrez un NOUVEAU terminal dans le dossier `forum-service` et exécutez :

```bash
mvn spring-boot:run
```

Attendez le message :
```
Started ForumApplication in X seconds
⚠️ Insertion des données de test désactivée temporairement
✅ Service démarré avec succès
```

Vérifiez : http://localhost:8082/swagger-ui.html

#### 3. Recrutement Service (Port 8083)

Ouvrez un NOUVEAU terminal dans le dossier `recrutement-service` et exécutez :

```bash
mvn spring-boot:run
```

Attendez le message :
```
Started RecrutementApplication in X seconds
⚠️ Insertion des données de test désactivée temporairement
✅ Service démarré avec succès
```

Vérifiez : http://localhost:8083/swagger-ui.html

#### 4. API Gateway (Port 8080) - OPTIONNEL

Ouvrez un NOUVEAU terminal dans le dossier `api-gateway` et exécutez :

```bash
mvn spring-boot:run
```

---

## 🐛 Diagnostic des Erreurs

### Erreur 400 sur GET /api/forum/forums

Cela signifie que :
1. Le service Forum ne démarre pas correctement
2. Il y a une erreur dans le code
3. La base de données est corrompue

**Solution :**
- Vérifiez les logs du service Forum dans le terminal
- Cherchez les messages d'erreur en rouge
- Vérifiez que le port 8082 n'est pas déjà utilisé

### Erreur 400 sur GET /api/recrutement/offres

Même diagnostic que pour le Forum Service.

**Solution :**
- Vérifiez les logs du service Recrutement dans le terminal
- Cherchez les messages d'erreur en rouge
- Vérifiez que le port 8083 n'est pas déjà utilisé

---

## 📋 Checklist de Vérification

Avant de tester l'interface Angular :

- [ ] Eureka Server démarre sans erreur (http://localhost:8761)
- [ ] Forum Service démarre sans erreur (http://localhost:8082/swagger-ui.html)
- [ ] Recrutement Service démarre sans erreur (http://localhost:8083/swagger-ui.html)
- [ ] Les deux services apparaissent dans Eureka Dashboard
- [ ] Aucun message d'erreur rouge dans les logs
- [ ] Les bases de données H2 sont créées (fichiers .db dans les dossiers des services)

---

## 🔍 Vérification via Swagger UI

### Forum Service - http://localhost:8082/swagger-ui.html

1. Testez GET `/api/forum/forums` - Devrait retourner `[]` (liste vide)
2. Si erreur 400 ou 500, regardez les logs du service

### Recrutement Service - http://localhost:8083/swagger-ui.html

1. Testez GET `/api/recrutement/offres` - Devrait retourner `[]` (liste vide)
2. Si erreur 400 ou 500, regardez les logs du service

---

## 🚀 Alternative : Démarrer via IDE

Si Maven n'est pas installé ou ne fonctionne pas :

### IntelliJ IDEA
1. Ouvrez chaque projet (eureka-server, forum-service, recrutement-service)
2. Trouvez la classe principale (*Application.java)
3. Clic droit > Run

### VS Code
1. Installez l'extension "Spring Boot Extension Pack"
2. Ouvrez chaque projet
3. Utilisez la vue "Spring Boot Dashboard"
4. Cliquez sur le bouton "Run" pour chaque service

### Eclipse
1. Importez les projets Maven
2. Clic droit sur le projet > Run As > Spring Boot App

---

## 📝 Notes Importantes

1. **Ordre de démarrage** : Toujours démarrer Eureka en premier
2. **Temps de démarrage** : Chaque service prend 20-30 secondes pour démarrer
3. **Ports** : Vérifiez qu'aucun autre programme n'utilise les ports 8761, 8082, 8083
4. **Données de test** : Désactivées pour éviter les erreurs de validation
5. **Logs** : Surveillez les logs dans les terminaux pour détecter les erreurs

---

## 🆘 Si les services ne démarrent toujours pas

1. **Vérifiez Java** : `java -version` (doit être Java 17 ou supérieur)
2. **Vérifiez Maven** : `mvn -version`
3. **Nettoyez les projets** :
   ```bash
   cd forum-service
   mvn clean install
   
   cd ../recrutement-service
   mvn clean install
   
   cd ../eureka-server
   mvn clean install
   ```
4. **Regardez les logs complets** dans les terminaux
5. **Partagez les messages d'erreur** pour diagnostic

---

## ✅ Une fois les services démarrés

1. Ouvrez le back-office Angular : http://localhost:4200 (ou le port affiché)
2. Naviguez vers "Forum" ou "Recrutement"
3. Créez des données via les formulaires
4. Les validations s'afficheront en cas d'erreur
