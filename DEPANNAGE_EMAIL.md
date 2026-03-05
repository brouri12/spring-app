# 🔧 Dépannage Email - Solutions Rapides

Guide de résolution des problèmes email les plus courants.

---

## 🚨 Problème 1: Bouton "Enregistrer" ne fait rien

### Symptômes
- Clic sur "Enregistrer" → Rien ne se passe
- Pas de message de succès
- Pas d'erreur visible

### Diagnostic
```javascript
// Ouvrir la console (F12)
// Chercher les erreurs
```

### Solutions

#### A. Backend pas démarré
```bash
# Vérifier si le backend tourne
curl http://localhost:8082/actuator/health

# Si erreur, démarrer le backend
cd forum-service
mvn spring-boot:run
```

#### B. Erreur 404
```bash
# Tester l'endpoint
curl -X POST http://localhost:8082/api/forum/email/preferences \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"welcomeEmails":true,"replyNotifications":true,"weeklyDigests":true,"mentionAlerts":true,"dailySummaries":false,"unreadReminders":true,"unsubscribeAll":false}'
```

**Si erreur 404**: L'endpoint n'existe pas
- Vérifier que `EmailController.java` a bien la méthode `createPreferences`
- Redémarrer le backend

#### C. Erreur CORS
**Console montre**: `Access-Control-Allow-Origin`

**Solution**:
```java
// Vérifier dans EmailController.java
@CrossOrigin(origins = "*")  // ← Doit être présent
public class EmailController {
```

---

## 🚨 Problème 2: Email non reçu

### Symptômes
- Endpoint retourne "Email envoyé"
- Mais aucun email dans la boîte
- Pas d'email dans les spams

### Diagnostic Rapide
```bash
# 1. Vérifier les logs backend
tail -f forum-service/logs/application.log | grep -i "mail\|email"

# 2. Tester l'endpoint
curl -X POST "http://localhost:8082/api/forum/email/test?email=VOTRE_EMAIL@gmail.com"
```

### Solutions

#### A. Mot de passe Gmail incorrect

**Erreur dans les logs**:
```
AuthenticationFailedException: 535-5.7.8 Username and Password not accepted
```

**Solution**:
1. Aller sur https://myaccount.google.com/security
2. Activer la validation en 2 étapes
3. Créer un mot de passe d'application:
   - Sélectionner "Mail"
   - Sélectionner "Autre (nom personnalisé)"
   - Taper "Forum ESPRIT"
   - Copier le mot de passe (16 caractères)
4. Mettre à jour `application.properties`:
```properties
spring.mail.password=xxxx xxxx xxxx xxxx
```
5. Redémarrer le backend

#### B. Configuration SMTP incorrecte

**Vérifier** `application.properties`:
```properties
# Doit être exactement comme ça
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=rahmaelaid6@gmail.com
spring.mail.password=pnbz ufff eslp bipm
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true
```

#### C. Préférences bloquent l'envoi

**Vérifier les préférences**:
```bash
curl http://localhost:8082/api/forum/email/preferences/1
```

**Si** `unsubscribeAll: true` → Aucun email ne sera envoyé

**Solution**:
```bash
# Mettre à jour
curl -X PUT http://localhost:8082/api/forum/email/preferences/1 \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"welcomeEmails":true,"replyNotifications":true,"weeklyDigests":true,"mentionAlerts":true,"dailySummaries":false,"unreadReminders":true,"unsubscribeAll":false}'
```

#### D. Email dans les spams

**Vérifier**:
1. Ouvrir Gmail
2. Aller dans "Spam"
3. Chercher "Forum ESPRIT"

**Si trouvé**:
- Marquer comme "Non spam"
- Ajouter à la liste blanche

---

## 🚨 Problème 3: Erreur 500 lors de la sauvegarde

### Symptômes
- Message rouge: "Erreur lors de l'enregistrement"
- Console montre erreur 500

### Diagnostic
```bash
# Vérifier les logs backend
tail -f forum-service/logs/application.log | grep ERROR
```

### Solutions

#### A. Base de données non accessible

**Erreur dans les logs**:
```
CommunicationsException: Communications link failure
```

**Solution**:
```bash
# Vérifier MySQL
mysql -u root -p

# Si erreur, démarrer MySQL
# Windows
net start MySQL80

# Linux
sudo systemctl start mysql

# Mac
brew services start mysql
```

#### B. Table manquante

**Erreur dans les logs**:
```
Table 'forum_db.email_preference' doesn't exist
```

**Solution**:
```sql
-- Se connecter à MySQL
mysql -u root -p

-- Créer la base si nécessaire
CREATE DATABASE IF NOT EXISTS forum_db;

-- Redémarrer le backend pour créer les tables
-- (avec spring.jpa.hibernate.ddl-auto=update)
```

#### C. Contrainte de clé unique

**Erreur dans les logs**:
```
Duplicate entry '1' for key 'email_preference.user_id'
```

**Cause**: Les préférences existent déjà pour cet utilisateur

**Solution**: Utiliser PUT au lieu de POST
```bash
# Au lieu de POST /preferences
# Utiliser PUT /preferences/1
curl -X PUT http://localhost:8082/api/forum/email/preferences/1 \
  -H "Content-Type: application/json" \
  -d '{...}'
```

---

## 🚨 Problème 4: Message "Préférences créées" mais pas sauvegardées

### Symptômes
- Message vert s'affiche
- Mais après refresh, les préférences sont perdues

### Diagnostic
```sql
-- Vérifier en base de données
USE forum_db;
SELECT * FROM email_preference WHERE user_id = 1;
```

### Solutions

#### A. Transaction non commitée

**Vérifier** `application.properties`:
```properties
# Doit être présent
spring.jpa.properties.hibernate.connection.autocommit=true
```

#### B. Erreur silencieuse

**Vérifier les logs**:
```bash
tail -f forum-service/logs/application.log | grep -i "rollback\|exception"
```

---

## 🔍 Checklist de Diagnostic

### Avant de Tester
- [ ] Backend démarré (port 8082)
- [ ] Frontend démarré (port 4300)
- [ ] MySQL démarré
- [ ] Base de données `forum_db` existe

### Test Sauvegarde Préférences
- [ ] Pas d'erreur 404
- [ ] Pas d'erreur 500
- [ ] Message de succès affiché
- [ ] Données en base de données

### Test Envoi Email
- [ ] Configuration SMTP correcte
- [ ] Mot de passe d'application valide
- [ ] Préférences permettent l'envoi
- [ ] Email reçu (ou dans spams)

---

## 🛠️ Commandes Utiles

### Tester Backend
```bash
# Health check
curl http://localhost:8082/actuator/health

# Tester préférences
curl http://localhost:8082/api/forum/email/preferences/1

# Tester email
curl -X POST "http://localhost:8082/api/forum/email/test?email=test@example.com"
```

### Vérifier Base de Données
```sql
-- Tables email
SHOW TABLES LIKE 'email%';

-- Préférences
SELECT * FROM email_preference;

-- Logs d'emails
SELECT * FROM email_log ORDER BY sent_date DESC LIMIT 10;

-- Supprimer pour retester
DELETE FROM email_preference WHERE user_id = 1;
```

### Logs Backend
```bash
# Tous les logs
tail -f forum-service/logs/application.log

# Seulement emails
tail -f forum-service/logs/application.log | grep -i email

# Seulement erreurs
tail -f forum-service/logs/application.log | grep ERROR
```

---

## 📞 Support Rapide

### Erreur Commune #1: AuthenticationFailedException
**Cause**: Mot de passe Gmail incorrect  
**Solution**: Créer un mot de passe d'application

### Erreur Commune #2: 404 Not Found
**Cause**: Endpoint manquant ou backend arrêté  
**Solution**: Vérifier EmailController et redémarrer backend

### Erreur Commune #3: CORS Error
**Cause**: @CrossOrigin manquant  
**Solution**: Ajouter @CrossOrigin(origins = "*") sur le controller

### Erreur Commune #4: Email non reçu
**Cause**: Configuration SMTP ou préférences  
**Solution**: Vérifier application.properties et préférences utilisateur

### Erreur Commune #5: Duplicate Entry
**Cause**: Préférences existent déjà  
**Solution**: Utiliser PUT au lieu de POST

---

## ✅ Validation Finale

**Tout fonctionne si**:
```bash
# 1. Backend répond
curl http://localhost:8082/actuator/health
# → {"status":"UP"}

# 2. Préférences se sauvegardent
curl -X POST http://localhost:8082/api/forum/email/preferences -H "Content-Type: application/json" -d '{"userId":1,"welcomeEmails":true,"replyNotifications":true,"weeklyDigests":true,"mentionAlerts":true,"dailySummaries":false,"unreadReminders":true,"unsubscribeAll":false}'
# → {"userId":1,"welcomeEmails":true,...}

# 3. Email de test envoyé
curl -X POST "http://localhost:8082/api/forum/email/test?email=VOTRE_EMAIL@gmail.com"
# → "Email de test envoyé à VOTRE_EMAIL@gmail.com"

# 4. Email reçu dans la boîte
# → Vérifier Gmail (et spams)
```

---

**Si rien ne fonctionne, consultez `GUIDE_TEST_EMAIL.md` pour un guide complet ! 📧**
