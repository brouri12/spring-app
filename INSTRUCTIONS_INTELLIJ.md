# 🎯 Guide IntelliJ IDEA - Configuration et Lancement

## 📥 ÉTAPE 1 : IMPORTER LES PROJETS

### Forum Service

1. **Ouvrir IntelliJ IDEA**
2. **File → Open**
3. Naviguer vers le dossier `forum-service`
4. Sélectionner le dossier et cliquer sur **OK**
5. IntelliJ détectera automatiquement le projet Maven
6. Attendre la fin de l'indexation et du téléchargement des dépendances

### Recrutement Service

1. **File → Open** (dans une nouvelle fenêtre ou le même projet)
2. Naviguer vers le dossier `recrutement-service`
3. Sélectionner le dossier et cliquer sur **OK**
4. Attendre l'indexation

## ⚙️ ÉTAPE 2 : CONFIGURATION MAVEN

### Vérifier la Configuration Maven

1. **File → Settings** (Ctrl+Alt+S)
2. **Build, Execution, Deployment → Build Tools → Maven**
3. Vérifier :
   - Maven home directory : Utiliser le Maven embarqué ou votre installation
   - User settings file : Par défaut
   - Local repository : Par défaut

### Recharger les Projets Maven

1. Ouvrir la vue **Maven** (View → Tool Windows → Maven)
2. Clic droit sur chaque projet → **Reload Project**
3. Attendre la fin du téléchargement des dépendances

## ☕ ÉTAPE 3 : CONFIGURATION JAVA

### Vérifier le JDK

1. **File → Project Structure** (Ctrl+Alt+Shift+S)
2. **Project Settings → Project**
3. **Project SDK** : Sélectionner Java 17
   - Si absent : **Add SDK → Download JDK → Version 17 (Amazon Corretto ou Oracle)**
4. **Project language level** : 17

### Configuration par Module

1. **Project Settings → Modules**
2. Pour chaque module (forum-service, recrutement-service) :
   - **Sources** : Vérifier que `src/main/java` est marqué en bleu (Sources)
   - **Dependencies** : Vérifier que le JDK 17 est sélectionné

## 🗄️ ÉTAPE 4 : CONFIGURATION MYSQL

### Créer une Connexion à la Base de Données

1. **View → Tool Windows → Database**
2. Cliquer sur **+** → **Data Source → MySQL**
3. Configurer :
   ```
   Host: localhost
   Port: 3306
   User: root
   Password: (votre mot de passe)
   Database: (laisser vide pour l'instant)
   ```
4. **Test Connection**
5. **Apply** → **OK**

### Créer les Bases de Données (Optionnel)

Les bases seront créées automatiquement au démarrage, mais vous pouvez les créer manuellement :

1. Dans la vue Database, clic droit sur la connexion MySQL
2. **New → Query Console**
3. Exécuter :
   ```sql
   CREATE DATABASE IF NOT EXISTS forum_db;
   CREATE DATABASE IF NOT EXISTS recrutement_db;
   ```

## 🚀 ÉTAPE 5 : LANCER LES SERVICES

### Méthode 1 : Via la Classe Main

#### Forum Service
1. Ouvrir `ForumApplication.java`
2. Clic droit dans l'éditeur → **Run 'ForumApplication'**
3. Ou cliquer sur l'icône ▶️ verte à côté de la classe

#### Recrutement Service
1. Ouvrir `RecrutementApplication.java`
2. Clic droit → **Run 'RecrutementApplication'**

### Méthode 2 : Via Maven

1. Ouvrir la vue **Maven**
2. Naviguer vers **forum-service → Plugins → spring-boot → spring-boot:run**
3. Double-cliquer pour lancer
4. Répéter pour **recrutement-service**

### Méthode 3 : Créer des Configurations de Lancement

#### Configuration Forum Service
1. **Run → Edit Configurations**
2. Cliquer sur **+** → **Spring Boot**
3. Configurer :
   ```
   Name: Forum Service
   Main class: tn.esprit.forum.ForumApplication
   Use classpath of module: forum-service
   ```
4. **Apply** → **OK**

#### Configuration Recrutement Service
1. **Run → Edit Configurations**
2. Cliquer sur **+** → **Spring Boot**
3. Configurer :
   ```
   Name: Recrutement Service
   Main class: tn.esprit.recrutement.RecrutementApplication
   Use classpath of module: recrutement-service
   ```
4. **Apply** → **OK**

#### Lancer les Configurations
- **Run → Run 'Forum Service'**
- **Run → Run 'Recrutement Service'**

## ✅ ÉTAPE 6 : VÉRIFICATION

### Console IntelliJ

Vérifier dans la console :

#### Forum Service
```
Started ForumApplication in X seconds
✅ Données initiales insérées : 2 forums et 5 messages
```

#### Recrutement Service
```
Started RecrutementApplication in X seconds
✅ Données initiales insérées : 2 offres et 2 candidatures
```

### Eureka Dashboard

1. Ouvrir le navigateur : http://localhost:8761
2. Vérifier que les services sont enregistrés :
   - **FORUM-SERVICE**
   - **RECRUTEMENT-SERVICE**

### Test des APIs

#### Via IntelliJ HTTP Client

Créer un fichier `test-apis.http` :

```http
### Forum Service - Get All Forums
GET http://localhost:8082/api/forum

### Recrutement Service - Get All Offres
GET http://localhost:8083/api/recrutement/offres
```

Cliquer sur ▶️ à côté de chaque requête pour l'exécuter.

#### Via Navigateur

- http://localhost:8082/api/forum
- http://localhost:8083/api/recrutement/offres

## 🔧 ÉTAPE 7 : OUTILS UTILES

### Activer Lombok

1. **File → Settings → Plugins**
2. Rechercher **Lombok**
3. Installer et redémarrer IntelliJ
4. **File → Settings → Build, Execution, Deployment → Compiler → Annotation Processors**
5. Cocher **Enable annotation processing**

### Activer Spring Boot Dashboard

1. **View → Tool Windows → Services**
2. Vous verrez vos applications Spring Boot
3. Vous pouvez les démarrer/arrêter depuis cette vue

### Activer les Endpoints Spring Boot

1. **View → Tool Windows → Endpoints**
2. Voir tous les endpoints REST disponibles
3. Cliquer pour tester directement

## 🐛 DÉPANNAGE

### Problème : Dépendances Maven non résolues

**Solution :**
1. **File → Invalidate Caches → Invalidate and Restart**
2. Ou dans la vue Maven : **Reload All Maven Projects**

### Problème : Erreur "Cannot resolve symbol"

**Solution :**
1. Vérifier que Lombok est installé
2. **File → Settings → Build → Compiler → Annotation Processors**
3. Cocher **Enable annotation processing**

### Problème : Port déjà utilisé

**Solution :**
1. Arrêter l'application en cours
2. Ou modifier le port dans `application.properties`

### Problème : MySQL Connection Failed

**Solution :**
1. Vérifier que MySQL est démarré : `net start MySQL80`
2. Vérifier les credentials dans `application.properties`
3. Tester la connexion dans la vue Database

### Problème : Eureka non accessible

**Solution :**
1. Vérifier qu'Eureka Server tourne sur port 8761
2. Ou désactiver temporairement dans `application.properties` :
   ```properties
   eureka.client.enabled=false
   ```

## 📊 MONITORING

### Logs en Temps Réel

1. **View → Tool Windows → Run**
2. Sélectionner le service actif
3. Voir les logs en temps réel

### Filtrer les Logs

1. Dans la console, utiliser la barre de recherche
2. Filtrer par niveau : ERROR, WARN, INFO, DEBUG

### Endpoints Actuator (si activé)

- http://localhost:8082/actuator/health
- http://localhost:8083/actuator/health

## 🎯 RACCOURCIS CLAVIER UTILES

- **Ctrl+Shift+F10** : Run la classe courante
- **Shift+F10** : Run la dernière configuration
- **Ctrl+F2** : Stop l'application
- **Alt+5** : Ouvrir la vue Debug
- **Alt+4** : Ouvrir la vue Run
- **Ctrl+Shift+A** : Rechercher une action

## 📝 BONNES PRATIQUES

1. **Toujours vérifier MySQL avant de lancer**
2. **Lancer Eureka Server en premier**
3. **Attendre 30-60 secondes pour le démarrage complet**
4. **Vérifier les logs pour les erreurs**
5. **Utiliser le Spring Boot Dashboard pour gérer les services**

---

Bon développement avec IntelliJ IDEA ! 🚀
