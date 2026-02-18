# Migration vers MySQL

## ✅ Modifications Appliquées

Les configurations ont été changées de H2 vers MySQL pour les deux services.

---

## 📋 Prérequis

### 1. Installer MySQL

Si MySQL n'est pas installé, téléchargez et installez-le :
- **Windows** : https://dev.mysql.com/downloads/installer/
- **Recommandation** : MySQL Community Server 8.0 ou supérieur

### 2. Démarrer MySQL

Assurez-vous que le service MySQL est démarré :

**Windows :**
```bash
# Vérifier le statut
net start | findstr MySQL

# Démarrer MySQL si nécessaire
net start MySQL80
```

**Ou via Services Windows :**
1. Appuyez sur `Win + R`
2. Tapez `services.msc`
3. Cherchez "MySQL80" ou "MySQL"
4. Clic droit → Démarrer

### 3. Vérifier la Connexion MySQL

Testez la connexion :

```bash
mysql -u root -p
```

Si vous n'avez pas de mot de passe, appuyez simplement sur Entrée.

---

## 🔧 Configuration Appliquée

### Forum Service

```properties
# MySQL Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/forum_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.properties.hibernate.format_sql=true
```

**Base de données créée automatiquement** : `forum_db`

### Recrutement Service

```properties
# MySQL Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/recrutement_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.properties.hibernate.format_sql=true
```

**Base de données créée automatiquement** : `recrutement_db`

---

## ⚙️ Personnaliser la Configuration

### Si vous avez un mot de passe MySQL

Modifiez dans `application.properties` :

```properties
spring.datasource.username=root
spring.datasource.password=votre_mot_de_passe
```

### Si MySQL est sur un autre port

Par défaut MySQL utilise le port 3306. Si différent :

```properties
spring.datasource.url=jdbc:mysql://localhost:VOTRE_PORT/forum_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
```

### Si vous utilisez un autre utilisateur

```properties
spring.datasource.username=votre_utilisateur
spring.datasource.password=votre_mot_de_passe
```

---

## 🚀 Démarrage des Services

### Étape 1: Arrêter les Services Actuels

Si les services sont en cours d'exécution, arrêtez-les (Ctrl+C).

### Étape 2: Redémarrer les Services

```bash
# Terminal 1 - Forum Service
cd forum-service
mvn spring-boot:run

# Terminal 2 - Recrutement Service
cd recrutement-service
mvn spring-boot:run
```

### Étape 3: Vérifier les Logs

Dans les logs, vous devriez voir :

```
Hibernate: create table forum (...)
Hibernate: create table message_forum (...)
```

Cela confirme que les tables sont créées dans MySQL.

---

## 🔍 Vérifier les Bases de Données MySQL

### Via MySQL Command Line

```bash
# Se connecter à MySQL
mysql -u root -p

# Lister les bases de données
SHOW DATABASES;

# Vous devriez voir :
# - forum_db
# - recrutement_db

# Utiliser la base forum_db
USE forum_db;

# Lister les tables
SHOW TABLES;

# Voir la structure d'une table
DESCRIBE forum;

# Voir les données
SELECT * FROM forum;
```

### Via MySQL Workbench (Interface Graphique)

1. Ouvrez MySQL Workbench
2. Connectez-vous à votre serveur local
3. Vous verrez les bases `forum_db` et `recrutement_db`
4. Explorez les tables et les données

### Via phpMyAdmin (Si installé)

1. Ouvrez http://localhost/phpmyadmin
2. Connectez-vous avec vos identifiants MySQL
3. Sélectionnez `forum_db` ou `recrutement_db`
4. Explorez les tables

---

## 📊 Requêtes SQL Utiles

### Forum Service

```sql
-- Utiliser la base de données
USE forum_db;

-- Lister tous les forums
SELECT * FROM forum;

-- Lister tous les messages
SELECT * FROM message_forum;

-- Compter les forums
SELECT COUNT(*) FROM forum;

-- Forums avec leurs messages
SELECT f.titre, COUNT(m.id) as nb_messages
FROM forum f
LEFT JOIN message_forum m ON f.id = m.forum_id
GROUP BY f.id, f.titre;
```

### Recrutement Service

```sql
-- Utiliser la base de données
USE recrutement_db;

-- Lister toutes les offres
SELECT * FROM offre_recrutement;

-- Lister toutes les candidatures
SELECT * FROM candidature_enseignant;

-- Compter les offres
SELECT COUNT(*) FROM offre_recrutement;

-- Offres avec leurs candidatures
SELECT o.titre, COUNT(c.id_candidature) as nb_candidatures
FROM offre_recrutement o
LEFT JOIN candidature_enseignant c ON o.id = c.offre_id
GROUP BY o.id, o.titre;
```

---

## 🧪 Test Complet

### 1. Créer un Forum via Swagger

http://localhost:8082/swagger-ui.html

```json
{
  "titre": "Test MySQL",
  "description": "Ce forum est stocké dans MySQL",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Base de Données",
  "statut": "OUVERT"
}
```

### 2. Vérifier dans MySQL

```bash
mysql -u root -p
```

```sql
USE forum_db;
SELECT * FROM forum;
```

Vous devriez voir votre forum !

### 3. Tester la Persistance

1. Arrêtez le service Forum (Ctrl+C)
2. Redémarrez-le : `mvn spring-boot:run`
3. Vérifiez à nouveau dans MySQL

✅ Les données sont toujours là !

---

## 🔄 Différences H2 vs MySQL

| Aspect | H2 | MySQL |
|--------|-----|-------|
| Type | Base embarquée | Serveur de base de données |
| Installation | Aucune | Requise |
| Performance | Rapide (en mémoire) | Très rapide (optimisé) |
| Production | ❌ Non recommandé | ✅ Recommandé |
| Console Web | ✅ Intégrée | ❌ Externe (Workbench, phpMyAdmin) |
| Persistance | Fichier ou mémoire | Toujours persistante |
| Multi-utilisateurs | ❌ Limité | ✅ Oui |

---

## ⚠️ Problèmes Courants et Solutions

### Erreur : "Access denied for user 'root'@'localhost'"

**Solution :**
1. Vérifiez votre mot de passe MySQL
2. Mettez à jour `application.properties` avec le bon mot de passe

### Erreur : "Communications link failure"

**Solution :**
1. Vérifiez que MySQL est démarré : `net start MySQL80`
2. Vérifiez le port (par défaut 3306)

### Erreur : "Unknown database 'forum_db'"

**Solution :**
L'option `createDatabaseIfNotExist=true` devrait créer la base automatiquement.
Si ça ne fonctionne pas, créez-la manuellement :

```sql
CREATE DATABASE forum_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE recrutement_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Erreur : "Table 'forum_db.forum' doesn't exist"

**Solution :**
Vérifiez que `spring.jpa.hibernate.ddl-auto=update` est bien configuré.
Les tables devraient être créées automatiquement au démarrage.

---

## 🗑️ Supprimer les Données

### Supprimer toutes les données (garder les tables)

```sql
USE forum_db;
DELETE FROM message_forum;
DELETE FROM forum;

USE recrutement_db;
DELETE FROM candidature_enseignant;
DELETE FROM offre_recrutement;
```

### Supprimer les bases de données complètement

```sql
DROP DATABASE forum_db;
DROP DATABASE recrutement_db;
```

Puis redémarrez les services pour les recréer.

---

## 📁 Structure des Bases de Données

### forum_db

```
Tables:
├── forum
│   ├── id (BIGINT, PRIMARY KEY)
│   ├── titre (VARCHAR)
│   ├── description (VARCHAR)
│   ├── date_creation (DATE)
│   ├── cree_par (BIGINT)
│   ├── niveau (VARCHAR)
│   ├── groupe (VARCHAR)
│   ├── cours (VARCHAR)
│   └── statut (VARCHAR)
│
└── message_forum
    ├── id (BIGINT, PRIMARY KEY)
    ├── contenu (VARCHAR)
    ├── date_message (DATETIME)
    ├── auteur_id (BIGINT)
    ├── type_auteur (VARCHAR)
    ├── statut (VARCHAR)
    └── forum_id (BIGINT, FOREIGN KEY)
```

### recrutement_db

```
Tables:
├── offre_recrutement
│   ├── id (BIGINT, PRIMARY KEY)
│   ├── titre (VARCHAR)
│   ├── description (VARCHAR)
│   ├── specialite (VARCHAR)
│   ├── niveau_requis (VARCHAR)
│   ├── type_contrat (VARCHAR)
│   ├── experience_min (INT)
│   ├── date_publication (DATE)
│   ├── date_limite (DATE)
│   ├── statut (VARCHAR)
│   ├── salaire_min (DOUBLE)
│   ├── salaire_max (DOUBLE)
│   └── nombre_postes (INT)
│
└── candidature_enseignant
    ├── id_candidature (BIGINT, PRIMARY KEY)
    ├── nom_candidat (VARCHAR)
    ├── prenom_candidat (VARCHAR)
    ├── email (VARCHAR, UNIQUE)
    ├── cv_url (VARCHAR)
    ├── lettre_motivation (VARCHAR)
    ├── date_candidature (DATE)
    ├── statut (VARCHAR)
    └── offre_id (BIGINT, FOREIGN KEY)
```

---

## ✅ Avantages de MySQL

1. ✅ **Production-ready** : Utilisé par des millions d'applications
2. ✅ **Performance** : Optimisé pour les grandes quantités de données
3. ✅ **Fiabilité** : Transactions ACID, intégrité référentielle
4. ✅ **Outils** : MySQL Workbench, phpMyAdmin, etc.
5. ✅ **Scalabilité** : Peut gérer des millions d'enregistrements
6. ✅ **Sécurité** : Gestion avancée des utilisateurs et permissions

---

## 🎯 Résultat Final

Maintenant vos services utilisent MySQL :
- ✅ Données persistantes dans MySQL
- ✅ Bases de données créées automatiquement
- ✅ Tables créées automatiquement
- ✅ Prêt pour la production
- ✅ Accessible via MySQL Workbench ou ligne de commande

**La migration vers MySQL est terminée ! 🎉**
