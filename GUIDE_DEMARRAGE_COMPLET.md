# 🚀 Guide de Démarrage Complet - Application Forum & Recrutement

## 📋 Prérequis

- ✅ Java 17 ou supérieur
- ✅ Maven 3.6+
- ✅ Node.js 18+ et npm
- ✅ MySQL 8.0
- ✅ Angular CLI 21+

## 🗄️ Étape 1 : Démarrer MySQL

```cmd
net start MySQL80
```

Vérifier que MySQL est bien démarré sur le port 3306.

## 🔧 Étape 2 : Créer les bases de données

Connectez-vous à MySQL et exécutez :

```sql
CREATE DATABASE IF NOT EXISTS forum_db;
CREATE DATABASE IF NOT EXISTS recrutement_db;
```

## 🌐 Étape 3 : Démarrer les Microservices

### 3.1 Démarrer Eureka Server (Port 8761)

```cmd
cd eureka-server
mvn clean install
mvn spring-boot:run
```

Attendre que Eureka soit complètement démarré (environ 30 secondes).
Vérifier : http://localhost:8761

### 3.2 Démarrer Forum Service (Port 8082)

Dans un nouveau terminal :

```cmd
cd forum-service
mvn clean install
mvn spring-boot:run
```

Vérifier : http://localhost:8082/swagger-ui/index.html

### 3.3 Démarrer Recrutement Service (Port 8083)

Dans un nouveau terminal :

```cmd
cd recrutement-service
mvn clean install
mvn spring-boot:run
```

Vérifier : http://localhost:8083/swagger-ui/index.html

### 3.4 Démarrer API Gateway (Port 8080)

Dans un nouveau terminal :

```cmd
cd api-gateway
mvn clean install
mvn spring-boot:run
```

Vérifier : http://localhost:8080

## 🎨 Étape 4 : Démarrer le Frontend Angular

### 4.1 Installer les dépendances (première fois uniquement)

```cmd
cd angular-app\frontend\angular-app
npm install
```

### 4.2 Démarrer l'application

```cmd
npm start
```

L'application sera accessible sur : **http://localhost:4200**

## ✅ Étape 5 : Vérification

### Vérifier les Services

1. **Eureka Dashboard** : http://localhost:8761
   - Vous devriez voir FORUM-SERVICE et RECRUTEMENT-SERVICE enregistrés

2. **Forum Service Swagger** : http://localhost:8082/swagger-ui/index.html
   - Tester les endpoints `/api/forum/forums` et `/api/forum/messages`

3. **Recrutement Service Swagger** : http://localhost:8083/swagger-ui/index.html
   - Tester les endpoints `/api/recrutement/offres` et `/api/recrutement/candidatures`

### Vérifier le Frontend

1. **Page d'accueil** : http://localhost:4200
   - Vérifier que la navbar contient les liens Forums et Recrutement

2. **Page Forums** : http://localhost:4200/forums
   - Vérifier l'affichage des forums
   - Tester la sélection d'un forum
   - Tester la création d'un message
   - Vérifier les couleurs (vert et orange)

3. **Page Recrutement** : http://localhost:4200/recrutement
   - Vérifier l'affichage des offres
   - Tester le filtrage par spécialité
   - Tester le formulaire de candidature
   - Vérifier les couleurs (vert et orange)

## 🎯 Fonctionnalités à Tester

### Forums
- [ ] Affichage de la liste des forums ouverts
- [ ] Sélection d'un forum
- [ ] Affichage des messages du forum
- [ ] Création d'un nouveau message
- [ ] Recherche dans les messages
- [ ] Notifications toast (succès, erreur, info)
- [ ] Design responsive (mobile, tablette, desktop)
- [ ] Mode sombre/clair

### Recrutement
- [ ] Affichage des offres ouvertes
- [ ] Filtrage par spécialité
- [ ] Sélection d'une offre
- [ ] Affichage des détails de l'offre
- [ ] Formulaire de candidature
- [ ] Validation de la date limite
- [ ] Notifications toast (succès, erreur, info)
- [ ] Design responsive

## 🐛 Résolution des Problèmes

### Erreur CORS

Si vous voyez des erreurs CORS dans la console :

1. Vérifier que les services Spring Boot sont bien démarrés
2. Redémarrer les services avec `mvn clean install && mvn spring-boot:run`
3. Vider le cache du navigateur (Ctrl + Shift + Delete)

### Erreur de connexion à MySQL

```cmd
net start MySQL80
```

Vérifier les credentials dans `application.properties` :
- Username : `root`
- Password : (votre mot de passe MySQL)

### Port déjà utilisé

Si un port est déjà utilisé :

**Windows :**
```cmd
netstat -ano | findstr :8082
taskkill /PID <PID> /F
```

### Erreur npm

Si vous avez des erreurs npm :

```cmd
cd angular-app\frontend\angular-app
rmdir /s /q node_modules
del package-lock.json
npm install
```

## 📊 Architecture Complète

```
┌─────────────────────────────────────────────────────────┐
│                  Frontend Angular (4200)                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Forums     │  │ Recrutement  │  │  Navbar      │  │
│  │   Public     │  │   Public     │  │  (Header)    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│              API Gateway (8080)                          │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│            Eureka Server (8761)                          │
│         Service Discovery & Registry                     │
└─────────────────────────────────────────────────────────┘
                           ↓
        ┌──────────────────┴──────────────────┐
        ↓                                      ↓
┌──────────────────┐              ┌──────────────────┐
│  Forum Service   │              │ Recrutement      │
│    (8082)        │              │   Service        │
│                  │              │    (8083)        │
│  - Forums        │              │  - Offres        │
│  - Messages      │              │  - Candidatures  │
└──────────────────┘              └──────────────────┘
        ↓                                      ↓
┌──────────────────┐              ┌──────────────────┐
│   forum_db       │              │ recrutement_db   │
│   (MySQL)        │              │   (MySQL)        │
└──────────────────┘              └──────────────────┘
```

## 🎨 Palette de Couleurs

- **Vert Principal** : `rgb(0,200,151)` - #00C897
- **Orange Accent** : `rgb(255,127,80)` - #FF7F50
- **Gris Clair** : `#F9FAFB`
- **Gris Foncé** : `#1F2937`

## 📝 Données de Test

### Forums
- **Forum 1** : "Questions sur Java Spring Boot" (Niveau: L3, Groupe: GL1)
- **Forum 2** : "Aide Angular et TypeScript" (Niveau: L3, Groupe: GL2)

### Offres de Recrutement
- **Offre 1** : "Enseignant en Informatique" (Spécialité: Informatique, CDI)
- **Offre 2** : "Professeur de Mathématiques" (Spécialité: Mathématiques, CDD)

## 🎉 Résultat Final

Une fois tous les services démarrés, vous aurez :

✅ Une application complète avec microservices
✅ Une interface moderne avec des couleurs cohérentes (vert et orange)
✅ Un système de notifications toast
✅ Une navigation fluide entre les pages
✅ Un design responsive avec mode sombre
✅ Une intégration complète Frontend ↔ Backend

## 📞 Support

En cas de problème, vérifier :
1. Tous les services sont bien démarrés
2. MySQL est actif
3. Les ports ne sont pas déjà utilisés
4. La configuration CORS est correcte
5. Les dépendances npm sont installées
