# Solution Finale - Packet Size Error

## Le Problème Exact

```
Packet for query is too large (1 729 223 > 1 048 576)
```

Votre fichier fait 1.7MB mais MySQL accepte seulement 1MB.

## Solution en 4 Étapes

### Étape 1: Modifier MySQL de Manière Permanente

#### Windows:

1. **Trouvez le fichier my.ini:**
   - Ouvrez l'Explorateur de fichiers
   - Allez à: `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
   - Si pas là: `C:\Program Files\MySQL\MySQL Server 8.0\my.ini`

2. **Éditez le fichier:**
   - Clic droit → "Ouvrir avec" → Notepad
   - Si demandé, exécutez en tant qu'Administrateur

3. **Ajoutez cette ligne sous [mysqld]:**
   ```ini
   [mysqld]
   max_allowed_packet=16M
   ```

4. **Sauvegardez le fichier**

5. **Redémarrez MySQL:**
   - Ouvrez CMD en tant qu'Administrateur
   - Exécutez:
   ```cmd
   net stop MySQL80
   net start MySQL80
   ```
   (Remplacez MySQL80 par le nom de votre service MySQL)

#### Linux/Mac:

```bash
# Éditez le fichier de configuration
sudo nano /etc/mysql/my.cnf

# Ajoutez sous [mysqld]:
[mysqld]
max_allowed_packet=16M

# Sauvegardez (Ctrl+O, Enter, Ctrl+X)

# Redémarrez MySQL
sudo systemctl restart mysql
```

### Étape 2: Vérifier le Changement

```sql
mysql -u root -p

SHOW VARIABLES LIKE 'max_allowed_packet';
```

**Résultat attendu:**
```
+--------------------+----------+
| Variable_name      | Value    |
+--------------------+----------+
| max_allowed_packet | 16777216 |
+--------------------+----------+
```

Si vous voyez `1048576`, MySQL n'a pas été redémarré correctement.

### Étape 3: Nettoyer les Données

```sql
USE recrutement_db;
DELETE FROM candidature_enseignant;
EXIT;
```

### Étape 4: Redémarrer le Backend

```bash
cd recrutement-service

# Arrêtez le service (Ctrl+C)

# Redémarrez
mvn spring-boot:run
```

**Attendez de voir:** `Started RecrutementServiceApplication`

### Étape 5: Tester

1. Rafraîchissez le navigateur (Ctrl+Shift+R)
2. Ouvrez le formulaire
3. Email unique: `test-final-2024@example.com`
4. Sélectionnez votre PDF
5. Soumettez

## Si Vous Ne Trouvez Pas my.ini

### Alternative: Créer un Fichier de Configuration

1. Créez un fichier `my.ini` dans: `C:\ProgramData\MySQL\MySQL Server 8.0\`

2. Contenu:
```ini
[mysqld]
max_allowed_packet=16M
```

3. Redémarrez MySQL

## Si Vous Ne Pouvez Pas Redémarrer MySQL

### Solution Temporaire: Réduire la Taille du Fichier

Dans `recrutement.ts`, changez:

```typescript
const maxSize = 1 * 1024 * 1024; // 1MB au lieu de 5MB
```

Puis utilisez un PDF plus petit (< 1MB).

## Vérification Finale

### 1. MySQL Redémarré?
```cmd
net stop MySQL80
net start MySQL80
```

### 2. max_allowed_packet = 16MB?
```sql
SHOW VARIABLES LIKE 'max_allowed_packet';
```

### 3. Backend Redémarré?
Vérifiez que vous voyez "Started RecrutementServiceApplication" dans la console.

### 4. Données Nettoyées?
```sql
SELECT COUNT(*) FROM candidature_enseignant;
```
Devrait retourner 0.

## Commandes Complètes (Windows)

```cmd
REM 1. Arrêter MySQL
net stop MySQL80

REM 2. Démarrer MySQL
net start MySQL80

REM 3. Vérifier
mysql -u root -p -e "SHOW VARIABLES LIKE 'max_allowed_packet';"

REM 4. Nettoyer
mysql -u root -p -e "USE recrutement_db; DELETE FROM candidature_enseignant;"
```

## Pourquoi SET GLOBAL Ne Suffit Pas?

`SET GLOBAL max_allowed_packet=16777216;` fonctionne SEULEMENT pour les nouvelles connexions.

Les connexions existantes (comme celle du backend) gardent l'ancienne valeur.

C'est pourquoi vous DEVEZ:
1. Modifier le fichier de configuration
2. Redémarrer MySQL
3. Redémarrer le backend

## Résultat Attendu

Après ces étapes, vous devriez voir:
- ✅ Candidature créée avec succès
- ✅ Fichier PDF stocké dans la base
- ✅ Bouton "Télécharger" fonctionne

## Si Ça Ne Marche Toujours Pas

Vérifiez dans cet ordre:
1. MySQL a bien redémarré
2. `max_allowed_packet` = 16777216
3. Backend a bien redémarré APRÈS MySQL
4. Email est unique
5. Fichier < 5MB

---

**La clé: Redémarrer MySQL ET le backend!**
