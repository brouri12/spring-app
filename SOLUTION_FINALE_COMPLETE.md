# Solution Finale Complète - Upload CV

## Diagnostic

```
Taille du fichier: 1.74 MB
Limite MySQL: 1 MB
Erreur: Packet for query is too large
```

## Solution Immédiate (3 étapes)

### 1. Augmenter max_allowed_packet MySQL

#### Méthode A: Temporaire (test rapide)
```sql
mysql -u root -p

SET GLOBAL max_allowed_packet = 16777216;  -- 16MB
SET SESSION max_allowed_packet = 16777216;

SHOW VARIABLES LIKE 'max_allowed_packet';

EXIT;
```

#### Méthode B: Permanent (recommandé)

**Windows:**
1. Trouvez `my.ini`:
   - `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
   - Ou `C:\Program Files\MySQL\MySQL Server 8.0\my.ini`

2. Ajoutez sous `[mysqld]`:
```ini
[mysqld]
max_allowed_packet=16M
```

3. Redémarrez MySQL (CMD en Administrateur):
```cmd
net stop MySQL80
net start MySQL80
```

**Linux/Mac:**
```bash
sudo nano /etc/mysql/my.cnf

# Ajoutez:
[mysqld]
max_allowed_packet=16M

# Sauvegardez et redémarrez:
sudo systemctl restart mysql
```

**Docker:**
```yaml
# docker-compose.yml
services:
  mysql:
    image: mysql:8
    command: ["--max-allowed-packet=16M"]
```

### 2. Nettoyer les Données de Test

```sql
mysql -u root -p

USE recrutement_db;
DELETE FROM candidature_enseignant;

EXIT;
```

### 3. Redémarrer le Backend

```bash
cd recrutement-service

# Arrêtez (Ctrl+C)

# Redémarrez
mvn spring-boot:run
```

**Attendez:** `Started RecrutementServiceApplication`

## Vérifications

### 1. MySQL
```sql
SHOW VARIABLES LIKE 'max_allowed_packet';
```
**Attendu:** `16777216` (16MB)

### 2. Backend
J'ai ajouté dans `application.properties`:
```properties
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

### 3. Frontend
Limite actuelle: 5MB (dans `recrutement.ts`)

## Test Final

1. **Rafraîchissez le navigateur:** Ctrl+Shift+R
2. **Ouvrez le formulaire de candidature**
3. **Utilisez un email UNIQUE:** `test-success-2024@example.com`
4. **Sélectionnez votre PDF** (< 5MB)
5. **Soumettez**

**Résultat attendu:** ✅ Candidature créée avec succès!

## Si Ça Ne Marche Toujours Pas

### Problème 1: max_allowed_packet toujours à 1MB

**Cause:** MySQL n'a pas été redémarré

**Solution:**
```cmd
# Windows (CMD en Admin)
net stop MySQL80
net start MySQL80

# Linux/Mac
sudo systemctl restart mysql
```

### Problème 2: Backend ne voit pas le changement

**Cause:** Le backend a gardé l'ancienne connexion

**Solution:** Redémarrez le backend APRÈS avoir redémarré MySQL

### Problème 3: Email déjà utilisé

**Cause:** Email existe déjà dans la base

**Solution:**
```sql
DELETE FROM candidature_enseignant WHERE email = 'votre@email.com';
```

### Problème 4: Fichier trop volumineux

**Cause:** Fichier > 5MB

**Solution:** Utilisez un fichier plus petit OU augmentez la limite frontend

## Limites Actuelles

| Niveau | Limite | Configuration |
|--------|--------|---------------|
| Frontend | 5MB | `recrutement.ts` ligne ~155 |
| Backend | 10MB | `application.properties` |
| MySQL | 16MB | `my.ini` / `my.cnf` |

## Solution Long Terme (Recommandée)

### Problème avec BLOB en Base de Données

❌ **Inconvénients:**
- Augmente la taille de la base
- Ralentit les backups
- Limite de taille
- Performances réduites

✅ **Solution: Stockage Externe**

### Option 1: Système de Fichiers Local

```java
// Sauvegarder
String uploadDir = "uploads/cv/";
String filename = UUID.randomUUID() + "_" + originalFilename;
Files.write(Paths.get(uploadDir + filename), bytes);

// En DB: stocker seulement le chemin
candidature.setCvPath(uploadDir + filename);
```

### Option 2: Cloud Storage (AWS S3, Azure Blob, MinIO)

```java
// Upload vers S3
s3Client.putObject(bucketName, filename, file);
String url = s3Client.getUrl(bucketName, filename);

// En DB: stocker l'URL
candidature.setCvUrl(url);
```

### Avantages du Stockage Externe

- ✅ Pas de limite de taille
- ✅ Meilleures performances
- ✅ Base de données plus légère
- ✅ Backups plus rapides
- ✅ CDN possible pour téléchargements rapides

## Migration vers Stockage Externe (Futur)

Si vous voulez migrer plus tard:

1. **Créer un dossier uploads:**
```bash
mkdir -p uploads/cv
```

2. **Modifier l'entité:**
```java
@Column(name = "cv_path")
private String cvPath;  // Au lieu de byte[] cv_pdf
```

3. **Modifier le service:**
```java
// Sauvegarder le fichier
String filename = UUID.randomUUID() + "_" + candidature.getCvFilename();
Files.write(Paths.get("uploads/cv/" + filename), cvBytes);
candidature.setCvPath("uploads/cv/" + filename);
```

4. **Modifier le téléchargement:**
```java
// Lire depuis le fichier
byte[] cvBytes = Files.readAllBytes(Paths.get(candidature.getCvPath()));
return ResponseEntity.ok()
    .contentType(MediaType.APPLICATION_PDF)
    .body(cvBytes);
```

## Commandes Rapides

### Tout Réinitialiser

```bash
# 1. MySQL
mysql -u root -p -e "SET GLOBAL max_allowed_packet=16777216; USE recrutement_db; DELETE FROM candidature_enseignant;"

# 2. Redémarrer MySQL (Windows)
net stop MySQL80 && net start MySQL80

# 3. Backend
cd recrutement-service
mvn clean spring-boot:run
```

### Vérifier Tout

```sql
-- MySQL
SHOW VARIABLES LIKE 'max_allowed_packet';
SELECT COUNT(*) FROM candidature_enseignant;
DESCRIBE candidature_enseignant;
```

## Checklist Finale

- [ ] MySQL `max_allowed_packet` = 16MB
- [ ] MySQL redémarré
- [ ] Backend redémarré APRÈS MySQL
- [ ] Base de données nettoyée
- [ ] Frontend rafraîchi (Ctrl+Shift+R)
- [ ] Email unique utilisé
- [ ] Fichier < 5MB
- [ ] Configuration Spring Boot ajoutée

## Résultat Attendu

Après toutes ces étapes:

1. ✅ Upload de CV fonctionne
2. ✅ Fichiers jusqu'à 5MB acceptés
3. ✅ Téléchargement fonctionne
4. ✅ Pas d'erreur 409

## Support

Si le problème persiste:

1. **Vérifiez les logs backend** pour l'erreur exacte
2. **Vérifiez la console navigateur** (F12) pour le message complet
3. **Vérifiez MySQL:**
   ```sql
   SHOW VARIABLES LIKE 'max_allowed_packet';
   ```
4. **Vérifiez que le backend a bien redémarré** après MySQL

---

**La clé du succès:** Redémarrer MySQL, PUIS redémarrer le backend!
