# 🔄 Redémarrage après correction de l'erreur 409

## ⚠️ Problème actuel

La base de données MySQL contient encore les anciennes colonnes (`id_offre`, `id_candidature`, etc.) mais le code Java cherche maintenant `id`.

**Erreur :**
```
Unknown column 'or1_0.id' in 'field list'
```

## ✅ Solution appliquée

J'ai changé temporairement la configuration JPA de `update` à `create` pour recréer les tables :

### Fichiers modifiés :
- `recrutement-service/src/main/resources/application.properties`
- `forum-service/src/main/resources/application.properties`

```properties
# Avant
spring.jpa.hibernate.ddl-auto=update

# Maintenant (temporaire)
spring.jpa.hibernate.ddl-auto=create
```

## 📋 Étapes de redémarrage

### 1. Arrêter tous les services
- Forum Service (port 8082)
- Recrutement Service (port 8083)
- API Gateway (port 8080) - optionnel
- Eureka Server (port 8761) - optionnel

### 2. Redémarrer les services

**Option A : Redémarrage complet (recommandé)**
```
1. Eureka Server (port 8761) → Attendre 30 secondes
2. Forum Service (port 8082) → Attendre que "Started ForumApplication" apparaisse
3. Recrutement Service (port 8083) → Attendre que "Started RecrutementApplication" apparaisse
4. API Gateway (port 8080)
```

**Option B : Redémarrage rapide (si Eureka tourne déjà)**
```
1. Forum Service (port 8082)
2. Recrutement Service (port 8083)
```

### 3. Vérifier les logs

Vous devriez voir dans les logs :
```
Hibernate: drop table if exists candidature_enseignant
Hibernate: drop table if exists offre_recrutement
Hibernate: create table candidature_enseignant (id bigint not null auto_increment, ...)
Hibernate: create table offre_recrutement (id bigint not null auto_increment, ...)
✅ Données initiales insérées : 2 offres et 2 candidatures
```

### 4. Tester via Swagger

#### Recrutement Service
URL : http://localhost:8083/swagger-ui/index.html

**1. Vérifier les offres existantes :**
```
GET /api/recrutement/offres
```
Devrait retourner 2 offres avec `id: 1` et `id: 2`

**2. Créer une nouvelle candidature :**
```json
POST /api/recrutement/candidatures?offreId=1
{
  "nom_candidat": "Test",
  "prenom_candidat": "User",
  "email": "test.user@example.com",
  "cv_url": "https://example.com/cv.pdf",
  "lettre_motivation": "Je suis très intéressé par ce poste",
  "statut": "EN_ATTENTE"
}
```

**Résultat attendu :**
- ✅ Status 201 Created
- ✅ JSON avec l'objet créé incluant `id: 3`

#### Forum Service
URL : http://localhost:8082/swagger-ui/index.html

**1. Vérifier les forums existants :**
```
GET /api/forum/forums
```

**2. Créer un nouveau message :**
```json
POST /api/forum/messages?forumId=1
{
  "auteurId": 100,
  "contenu": "Ceci est un message de test",
  "type_auteur": "ETUDIANT"
}
```

## 🔧 Après les tests réussis

Une fois que tout fonctionne, vous pouvez remettre `update` pour éviter de perdre les données à chaque redémarrage :

### Remettre la configuration normale

**recrutement-service/src/main/resources/application.properties :**
```properties
spring.jpa.hibernate.ddl-auto=update
```

**forum-service/src/main/resources/application.properties :**
```properties
spring.jpa.hibernate.ddl-auto=update
```

## 📊 Structure des tables après correction

### Table `offre_recrutement`
```sql
CREATE TABLE offre_recrutement (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,  -- ✅ Nouveau nom
  titre VARCHAR(255),
  description VARCHAR(2000),
  specialite VARCHAR(255),
  experience_min INT,
  date_publication DATE,
  statut VARCHAR(50)
);
```

### Table `candidature_enseignant`
```sql
CREATE TABLE candidature_enseignant (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,  -- ✅ Nouveau nom
  nom_candidat VARCHAR(255),
  prenom_candidat VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  cv_url VARCHAR(255),
  lettre_motivation VARCHAR(2000),
  date_candidature DATE,
  statut VARCHAR(50),
  offre_id BIGINT,
  FOREIGN KEY (offre_id) REFERENCES offre_recrutement(id)
);
```

## ⚠️ Important

- **Mode `create`** : Supprime et recrée les tables à chaque démarrage (perte de données)
- **Mode `update`** : Conserve les données et met à jour la structure si nécessaire
- Utilisez `create` uniquement pour cette première migration, puis repassez en `update`

## 🎯 Résumé

1. ✅ Configuration changée en `create`
2. 🔄 Redémarrer les services
3. ✅ Tester via Swagger
4. 🔧 Remettre en `update` après validation
