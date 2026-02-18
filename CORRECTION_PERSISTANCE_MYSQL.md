# Correction - Persistance des Données dans MySQL

## 🔍 Problème Identifié

Les données s'affichent dans le front-end et le back-office mais ne sont pas visibles dans phpMyAdmin/MySQL.

**Cause possible :**
- Les transactions ne sont pas committées automatiquement
- Isolation de transaction incorrecte
- Cache Hibernate non synchronisé avec MySQL

## ✅ Solutions Appliquées

### 1. Configuration Transaction Auto-Commit

Ajout dans `application.properties` :

```properties
# Transaction Configuration - Force commit
spring.jpa.properties.hibernate.connection.autocommit=true
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true

# URL avec autoReconnect
spring.datasource.url=jdbc:mysql://localhost:3306/forum_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&autoReconnect=true
```

### 2. Redémarrer les Services

**IMPORTANT** : Vous devez redémarrer les services pour appliquer les changements !

```bash
# Arrêter les services (Ctrl+C dans chaque terminal)

# Redémarrer Forum Service
cd forum-service
mvn spring-boot:run

# Redémarrer Recrutement Service
cd recrutement-service
mvn spring-boot:run
```

---

## 🧪 Test de Vérification

### Étape 1: Créer une Offre via le Back-Office

1. Ouvrez http://localhost:4200
2. Allez dans "Recrutement"
3. Cliquez sur "+ Nouvelle"
4. Remplissez le formulaire :
   ```
   Titre: Test Persistance MySQL
   Description: Cette offre doit apparaître dans phpMyAdmin immédiatement
   Spécialité: Informatique
   Niveau requis: Master
   Type de contrat: CDI
   Nombre de postes: 1
   Expérience minimale: 0
   Date limite: [Date future]
   ```
5. Cliquez sur "Créer"

### Étape 2: Vérifier IMMÉDIATEMENT dans phpMyAdmin

1. Ouvrez phpMyAdmin : http://localhost/phpmyadmin
2. Sélectionnez la base `recrutement_db`
3. Cliquez sur la table `offre_recrutement`
4. Cliquez sur "Parcourir" ou exécutez :
   ```sql
   SELECT * FROM offre_recrutement ORDER BY id DESC LIMIT 1;
   ```

**Résultat attendu :** ✅ Vous voyez l'offre que vous venez de créer !

### Étape 3: Actualiser phpMyAdmin

Cliquez sur le bouton "Actualiser" dans phpMyAdmin ou appuyez sur F5.

**Résultat attendu :** ✅ Les données sont toujours là !

---

## 🔄 Vérification Alternative via MySQL Command Line

```bash
# Se connecter à MySQL
mysql -u root -p

# Utiliser la base de données
USE recrutement_db;

# Voir les dernières offres
SELECT id, titre, specialite, statut, date_publication 
FROM offre_recrutement 
ORDER BY id DESC 
LIMIT 5;

# Compter les offres
SELECT COUNT(*) as total_offres FROM offre_recrutement;
```

---

## 🐛 Si le Problème Persiste

### Solution 1: Vérifier les Logs Hibernate

Dans les logs du service, cherchez :

```
Hibernate: insert into offre_recrutement (...)
```

Si vous voyez cette ligne, cela signifie que Hibernate essaie d'insérer les données.

### Solution 2: Vérifier l'Isolation de Transaction

Ajoutez dans `application.properties` :

```properties
# Niveau d'isolation de transaction
spring.jpa.properties.hibernate.connection.isolation=2
```

Valeurs possibles :
- 1 = READ_UNCOMMITTED
- 2 = READ_COMMITTED (recommandé)
- 4 = REPEATABLE_READ
- 8 = SERIALIZABLE

### Solution 3: Désactiver le Cache de Second Niveau

Ajoutez dans `application.properties` :

```properties
# Désactiver le cache de second niveau
spring.jpa.properties.hibernate.cache.use_second_level_cache=false
spring.jpa.properties.hibernate.cache.use_query_cache=false
```

### Solution 4: Forcer le Flush Immédiat

Modifiez les services pour ajouter `flush()` :

**Exemple dans OffreService :**

```java
@Service
@RequiredArgsConstructor
public class OffreService {
    
    private final OffreRepository offreRepository;
    
    @Transactional
    public OffreRecrutement addOffre(OffreRecrutement offre) {
        OffreRecrutement saved = offreRepository.save(offre);
        offreRepository.flush(); // Force l'écriture immédiate
        return saved;
    }
}
```

### Solution 5: Vérifier la Configuration MySQL

Vérifiez que MySQL n'est pas en mode READ-ONLY :

```sql
-- Se connecter à MySQL
mysql -u root -p

-- Vérifier le mode
SHOW VARIABLES LIKE 'read_only';

-- Si read_only = ON, désactivez-le
SET GLOBAL read_only = OFF;
```

### Solution 6: Vérifier les Permissions MySQL

```sql
-- Vérifier les permissions de l'utilisateur root
SHOW GRANTS FOR 'root'@'localhost';

-- Vous devriez voir :
-- GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost'
```

---

## 📊 Diagnostic Complet

### Test 1: Insertion Directe via MySQL

```sql
USE recrutement_db;

INSERT INTO offre_recrutement 
(titre, description, specialite, niveau_requis, type_contrat, experience_min, date_publication, date_limite, statut, nombre_postes)
VALUES 
('Test Direct MySQL', 'Test insertion directe', 'Test', 'Master', 'CDI', 0, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'OUVERTE', 1);

-- Vérifier
SELECT * FROM offre_recrutement WHERE titre = 'Test Direct MySQL';
```

Si cela fonctionne, le problème vient de l'application Spring Boot.

### Test 2: Vérifier la Connexion Spring Boot

Dans les logs au démarrage, cherchez :

```
HikariPool-1 - Starting...
HikariPool-1 - Start completed.
```

Cela confirme que la connexion à MySQL est établie.

### Test 3: Activer les Logs de Transaction

Ajoutez dans `application.properties` :

```properties
# Logs de transaction
logging.level.org.springframework.transaction=DEBUG
logging.level.org.hibernate.engine.transaction=DEBUG
```

Redémarrez et regardez les logs lors de la création d'une offre.

---

## 🔧 Configuration Complète Recommandée

### application.properties (Recrutement Service)

```properties
# MySQL Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/recrutement_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&autoReconnect=true&useUnicode=true&characterEncoding=UTF-8
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=

# Connection Pool Configuration
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.properties.hibernate.format_sql=true

# Transaction Configuration
spring.jpa.properties.hibernate.connection.autocommit=true
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true
spring.jpa.properties.hibernate.connection.isolation=2

# Cache Configuration
spring.jpa.properties.hibernate.cache.use_second_level_cache=false
spring.jpa.properties.hibernate.cache.use_query_cache=false

# Logging
logging.level.tn.esprit.recrutement=DEBUG
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE
logging.level.org.springframework.transaction=DEBUG
```

---

## ✅ Checklist de Vérification

Après avoir appliqué les corrections :

- [ ] Services redémarrés
- [ ] Logs montrent "Hibernate: insert into..."
- [ ] Création d'offre via back-office réussie
- [ ] Données visibles dans phpMyAdmin immédiatement
- [ ] Actualisation de phpMyAdmin conserve les données
- [ ] Redémarrage du service conserve les données

---

## 🎯 Résultat Attendu

Après ces corrections :

1. ✅ Vous créez une offre via le back-office
2. ✅ L'offre s'affiche immédiatement dans le back-office
3. ✅ L'offre s'affiche immédiatement dans le frontend public
4. ✅ L'offre est IMMÉDIATEMENT visible dans phpMyAdmin
5. ✅ L'offre reste visible après actualisation de phpMyAdmin
6. ✅ L'offre reste visible après redémarrage du service

**Les données doivent être persistées en temps réel dans MySQL ! 🎉**
