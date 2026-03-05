# ⚡ À FAIRE MAINTENANT

## Étape 1: Modifier my.ini (Permanent)

1. **Ouvrez l'Explorateur Windows**
2. **Allez à:** `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
3. **Ouvrez avec Notepad** (clic droit → Exécuter en tant qu'administrateur)
4. **Cherchez la ligne:** `[mysqld]`
5. **Ajoutez en dessous:**
   ```ini
   max_allowed_packet=16M
   ```
6. **Sauvegardez** (Ctrl+S)

## Étape 2: Redémarrer MySQL

**Ouvrez CMD en tant qu'Administrateur:**

```cmd
net stop MySQL80
net start MySQL80
```

## Étape 3: Vérifier

```cmd
mysql -u root -p -e "SHOW VARIABLES LIKE 'max_allowed_packet';"
```

**Vous devez voir:** `16777216`

## Étape 4: Nettoyer

```cmd
mysql -u root -p -e "USE recrutement_db; DELETE FROM candidature_enseignant;"
```

## Étape 5: Redémarrer Backend

```bash
cd recrutement-service
# Ctrl+C pour arrêter
mvn spring-boot:run
```

**Attendez:** "Started RecrutementServiceApplication"

## Étape 6: Tester

1. Rafraîchissez le navigateur: **Ctrl+Shift+R**
2. Ouvrez le formulaire de candidature
3. Email: `test-final-success@example.com`
4. Sélectionnez votre PDF
5. Cliquez "Envoyer la Candidature"

## ✅ Résultat Attendu

**Message de succès** et la candidature apparaît dans le tableau avec un bouton "Télécharger".

---

## Si Vous Ne Trouvez Pas my.ini

Cherchez dans:
- `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
- `C:\Program Files\MySQL\MySQL Server 8.0\my.ini`
- `C:\MySQL\my.ini`

Ou créez-le dans `C:\ProgramData\MySQL\MySQL Server 8.0\`

---

**Important:** Redémarrez MySQL AVANT de redémarrer le backend!
