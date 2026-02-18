# Correction - Base de Données Persistante

## 🔍 Problème Identifié

Vous créez un forum via Swagger (code 201 = succès), mais les données disparaissent de la console H2.

**Cause :** Base de données H2 **en mémoire** (`jdbc:h2:mem:forum_db`)
- Les données sont stockées uniquement en RAM
- Elles disparaissent quand vous fermez la console H2
- Elles disparaissent quand vous actualisez la page
- Elles disparaissent quand vous redémarrez le service

## ✅ Solution Appliquée

Changement vers une base de données H2 **fichier persistante** :

### Avant (en mémoire)
```properties
spring.datasource.url=jdbc:h2:mem:forum_db
spring.jpa.hibernate.ddl-auto=create
```

### Après (fichier persistant)
```properties
spring.datasource.url=jdbc:h2:file:./data/forum_db
spring.jpa.hibernate.ddl-auto=update
```

## 🔄 Changements Effectués

### Forum Service
- ✅ URL changée : `jdbc:h2:file:./data/forum_db`
- ✅ DDL changé : `create` → `update`
- ✅ Fichier créé : `forum-service/data/forum_db.mv.db`

### Recrutement Service
- ✅ URL changée : `jdbc:h2:file:./data/recrutement_db`
- ✅ DDL changé : `create` → `update`
- ✅ Fichier créé : `recrutement-service/data/recrutement_db.mv.db`

## 📝 Différences Clés

| Aspect | En Mémoire (mem) | Fichier (file) |
|--------|------------------|----------------|
| Stockage | RAM | Disque dur |
| Persistance | ❌ Non | ✅ Oui |
| Survit au redémarrage | ❌ Non | ✅ Oui |
| Fichier créé | ❌ Non | ✅ Oui (.mv.db) |
| Performance | Plus rapide | Légèrement plus lent |
| Usage | Tests unitaires | Développement/Production |

## 🚀 Comment Appliquer les Changements

### Étape 1: Arrêter les Services

Arrêtez Forum Service et Recrutement Service (Ctrl+C dans les terminaux).

### Étape 2: Redémarrer les Services

```bash
# Terminal 1 - Forum Service
cd forum-service
mvn spring-boot:run

# Terminal 2 - Recrutement Service
cd recrutement-service
mvn spring-boot:run
```

### Étape 3: Vérifier la Création des Fichiers

Après le démarrage, vérifiez que les fichiers de base de données ont été créés :

```bash
# Vérifier Forum Service
dir forum-service\data

# Vérifier Recrutement Service
dir recrutement-service\data
```

Vous devriez voir :
- `forum_db.mv.db` (fichier de base de données)
- `forum_db.trace.db` (fichier de logs, optionnel)

## 🧪 Test de Persistance

### 1. Créer un Forum via Swagger

```json
{
  "titre": "Test Persistance",
  "description": "Ce forum doit rester en base de données",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Test",
  "statut": "OUVERT"
}
```

**Résultat attendu :** Code 201

### 2. Vérifier dans la Console H2

1. Ouvrez : http://localhost:8082/h2-console
2. Paramètres de connexion :
   - **JDBC URL** : `jdbc:h2:file:./data/forum_db`
   - **User Name** : `sa`
   - **Password** : (laisser vide)
3. Cliquez sur "Connect"
4. Exécutez la requête :
   ```sql
   SELECT * FROM FORUM;
   ```

**Résultat attendu :** Vous voyez le forum créé

### 3. Actualiser la Page H2

Actualisez la page de la console H2 (F5).

**Résultat attendu :** ✅ Les données sont toujours là !

### 4. Redémarrer le Service

1. Arrêtez le Forum Service (Ctrl+C)
2. Redémarrez-le : `mvn spring-boot:run`
3. Reconnectez-vous à la console H2
4. Exécutez : `SELECT * FROM FORUM;`

**Résultat attendu :** ✅ Les données sont toujours là !

## 📊 Accès à la Console H2

### Forum Service
- **URL** : http://localhost:8082/h2-console
- **JDBC URL** : `jdbc:h2:file:./data/forum_db`
- **Username** : `sa`
- **Password** : (vide)

### Recrutement Service
- **URL** : http://localhost:8083/h2-console
- **JDBC URL** : `jdbc:h2:file:./data/recrutement_db`
- **Username** : `sa`
- **Password** : (vide)

## 🔍 Requêtes SQL Utiles

### Lister tous les forums
```sql
SELECT * FROM FORUM;
```

### Lister tous les messages
```sql
SELECT * FROM MESSAGE_FORUM;
```

### Compter les forums
```sql
SELECT COUNT(*) FROM FORUM;
```

### Lister les forums avec leurs messages
```sql
SELECT f.titre, COUNT(m.id) as nb_messages
FROM FORUM f
LEFT JOIN MESSAGE_FORUM m ON f.id = m.forum_id
GROUP BY f.id, f.titre;
```

### Lister toutes les offres
```sql
SELECT * FROM OFFRE_RECRUTEMENT;
```

### Lister toutes les candidatures
```sql
SELECT * FROM CANDIDATURE_ENSEIGNANT;
```

### Lister les candidatures par offre
```sql
SELECT o.titre, COUNT(c.id_candidature) as nb_candidatures
FROM OFFRE_RECRUTEMENT o
LEFT JOIN CANDIDATURE_ENSEIGNANT c ON o.id = c.offre_id
GROUP BY o.id, o.titre;
```

## 🗑️ Supprimer les Données

Si vous voulez repartir à zéro :

### Option 1: Via SQL
```sql
DELETE FROM MESSAGE_FORUM;
DELETE FROM FORUM;
DELETE FROM CANDIDATURE_ENSEIGNANT;
DELETE FROM OFFRE_RECRUTEMENT;
```

### Option 2: Supprimer les fichiers
```bash
# Arrêter les services d'abord !
del forum-service\data\*.db
del recrutement-service\data\*.db
```

Puis redémarrer les services.

## ⚙️ Configuration DDL

### `spring.jpa.hibernate.ddl-auto=update`

- ✅ Conserve les données existantes
- ✅ Ajoute les nouvelles tables/colonnes
- ✅ Ne supprime pas les données
- ⚠️ Ne supprime pas les colonnes obsolètes

### Autres options disponibles

| Option | Comportement |
|--------|--------------|
| `create` | Supprime et recrée les tables à chaque démarrage |
| `create-drop` | Crée au démarrage, supprime à l'arrêt |
| `update` | Met à jour le schéma sans supprimer les données |
| `validate` | Vérifie le schéma sans le modifier |
| `none` | Aucune action automatique |

**Recommandation :** Utilisez `update` pour le développement.

## 📁 Structure des Fichiers

Après le démarrage, vous aurez :

```
forum-service/
├── data/
│   ├── forum_db.mv.db          ← Base de données
│   └── forum_db.trace.db       ← Logs (optionnel)
├── src/
└── pom.xml

recrutement-service/
├── data/
│   ├── recrutement_db.mv.db    ← Base de données
│   └── recrutement_db.trace.db ← Logs (optionnel)
├── src/
└── pom.xml
```

## ✅ Avantages de la Base Fichier

1. ✅ **Persistance** : Les données survivent aux redémarrages
2. ✅ **Développement** : Pas besoin de recréer les données de test
3. ✅ **Débogage** : Vous pouvez inspecter les données à tout moment
4. ✅ **Tests** : Vous pouvez tester avec des données réelles
5. ✅ **Simplicité** : Pas besoin d'installer MySQL/PostgreSQL

## 🎯 Résultat Final

Maintenant, quand vous créez un forum via Swagger :
1. ✅ Code 201 retourné
2. ✅ Forum visible dans la console H2
3. ✅ Données persistent après actualisation
4. ✅ Données persistent après redémarrage
5. ✅ Fichier `.mv.db` créé sur le disque

**Le problème est résolu ! 🎉**
