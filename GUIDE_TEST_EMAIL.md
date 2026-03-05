# 📧 Guide de Test - Système Email

**Date**: 5 mars 2026  
**Objectif**: Tester les préférences email et l'envoi d'emails

---

## ✅ Corrections Appliquées

### 1. Sauvegarde des Préférences
**Problème**: Le bouton "Enregistrer" ne fonctionnait pas  
**Solution**: Ajout d'une logique pour créer les préférences si elles n'existent pas encore

**Changement dans** `email-preferences.component.ts`:
```typescript
// Avant: Seulement UPDATE
updatePreferences(userId, preferences)

// Après: UPDATE puis CREATE si 404
updatePreferences(userId, preferences)
  .catch(error => {
    if (error.status === 404) {
      createPreferences(preferences)
    }
  })
```

### 2. Endpoint de Test Email
**Ajout**: Nouvel endpoint pour tester l'envoi d'emails  
**Endpoint**: `POST /api/forum/email/test`

---

## 🚀 Test 1: Sauvegarder les Préférences

### Étapes
1. Ouvrez http://localhost:4300
2. Cliquez sur l'icône ✉️ dans le header
3. Cochez/décochez des options
4. Cliquez "Enregistrer les préférences"

### ✅ Résultat Attendu
- Message vert: "Préférences enregistrées avec succès!" ou "Préférences créées avec succès!"
- Pas d'erreur dans la console
- Les préférences sont sauvegardées en base de données

### ❌ Si ça ne marche pas
**Console Browser (F12)**:
```
Erreur 404 → Backend pas démarré
Erreur 500 → Problème base de données
CORS error → Vérifier @CrossOrigin
```

**Vérifier Backend**:
```bash
# Logs backend
tail -f forum-service/logs/application.log

# Tester l'endpoint
curl -X POST http://localhost:8082/api/forum/email/preferences \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "welcomeEmails": true,
    "replyNotifications": true,
    "weeklyDigests": true,
    "mentionAlerts": true,
    "dailySummaries": false,
    "unreadReminders": true,
    "unsubscribeAll": false
  }'
```

---

## 📧 Test 2: Envoyer un Email de Test

### Configuration SMTP
**Fichier**: `forum-service/src/main/resources/application.properties`

**Configuration actuelle**:
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=rahmaelaid6@gmail.com
spring.mail.password=pnbz ufff eslp bipm
```

### ⚠️ Important: Mot de Passe d'Application Gmail

Le mot de passe dans le fichier est un **mot de passe d'application** Gmail (pas votre mot de passe normal).

**Pour créer un mot de passe d'application**:
1. Allez sur https://myaccount.google.com/security
2. Activez la validation en 2 étapes (si pas déjà fait)
3. Allez dans "Mots de passe des applications"
4. Créez un nouveau mot de passe pour "Mail"
5. Copiez le mot de passe généré (16 caractères)
6. Remplacez dans `application.properties`

### Test avec cURL

```bash
# Envoyer un email de test
curl -X POST "http://localhost:8082/api/forum/email/test?email=VOTRE_EMAIL@gmail.com&userId=1"
```

**Remplacez** `VOTRE_EMAIL@gmail.com` par votre vraie adresse email.

### ✅ Résultat Attendu
- Réponse: "Email de test envoyé à VOTRE_EMAIL@gmail.com"
- Email reçu dans votre boîte (vérifiez aussi les spams)
- Sujet: "Bienvenue sur le Forum ESPRIT!"

### ❌ Si l'email n'arrive pas

#### 1. Vérifier les Logs Backend
```bash
tail -f forum-service/logs/application.log | grep -i "mail\|email"
```

**Erreurs communes**:
```
AuthenticationFailedException → Mot de passe incorrect
SMTPSendFailedException → Problème SMTP
MailConnectException → Impossible de se connecter au serveur
```

#### 2. Vérifier la Configuration SMTP
```bash
# Tester la connexion SMTP
telnet smtp.gmail.com 587
```

#### 3. Vérifier Gmail
- Validation en 2 étapes activée ?
- Mot de passe d'application créé ?
- "Accès moins sécurisé" désactivé (normal avec mot de passe d'app)

#### 4. Vérifier les Préférences
```bash
# Vérifier que les préférences permettent l'envoi
curl http://localhost:8082/api/forum/email/preferences/1
```

Doit retourner:
```json
{
  "userId": 1,
  "welcomeEmails": true,
  "unsubscribeAll": false
}
```

---

## 🔧 Test 3: Vérifier en Base de Données

### Vérifier les Préférences
```sql
USE forum_db;
SELECT * FROM email_preference WHERE user_id = 1;
```

### Vérifier les Logs d'Emails
```sql
SELECT * FROM email_log ORDER BY sent_date DESC LIMIT 10;
```

**Colonnes importantes**:
- `success`: true/false
- `error_message`: Message d'erreur si échec
- `retry_count`: Nombre de tentatives

---

## 📊 Scénario Complet

### Étape 1: Configurer SMTP (5 min)
1. Créer un mot de passe d'application Gmail
2. Mettre à jour `application.properties`
3. Redémarrer le backend

### Étape 2: Tester l'Envoi (2 min)
```bash
curl -X POST "http://localhost:8082/api/forum/email/test?email=VOTRE_EMAIL@gmail.com"
```

### Étape 3: Vérifier Réception (1 min)
1. Ouvrir votre boîte email
2. Chercher "Bienvenue sur le Forum ESPRIT"
3. Vérifier les spams si absent

### Étape 4: Tester les Préférences (2 min)
1. Aller sur http://localhost:4300/email-preferences
2. Décocher "Emails de bienvenue"
3. Cliquer "Enregistrer"
4. Renvoyer un email de test
5. Vérifier qu'aucun email n'est reçu

---

## 🎯 Validation Finale

### ✅ Tout fonctionne si:
- [ ] Préférences se sauvegardent sans erreur
- [ ] Message de succès s'affiche
- [ ] Email de test reçu dans la boîte
- [ ] Logs backend montrent "Email sent successfully"
- [ ] Base de données contient les préférences

### ❌ Problèmes Courants

| Problème | Cause | Solution |
|----------|-------|----------|
| Préférences non sauvegardées | Backend arrêté | Démarrer backend |
| Erreur 404 | Endpoint manquant | Vérifier EmailController |
| Email non reçu | Config SMTP incorrecte | Vérifier mot de passe d'app |
| AuthenticationFailed | Mot de passe invalide | Créer nouveau mot de passe d'app |
| Erreur 500 | Base de données | Vérifier MySQL |

---

## 🔐 Sécurité

### ⚠️ Ne JAMAIS commiter les credentials
```properties
# BAD - Ne pas faire ça
spring.mail.password=mon_vrai_mot_de_passe

# GOOD - Utiliser des variables d'environnement
spring.mail.password=${MAIL_PASSWORD}
```

### Variables d'Environnement
```bash
# Linux/Mac
export MAIL_PASSWORD="votre_mot_de_passe"

# Windows
set MAIL_PASSWORD=votre_mot_de_passe

# Puis démarrer l'application
mvn spring-boot:run
```

---

## 📝 Endpoints Email

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/email/preferences` | Créer préférences |
| GET | `/email/preferences/{userId}` | Lire préférences |
| PUT | `/email/preferences/{userId}` | Mettre à jour préférences |
| POST | `/email/test` | Envoyer email de test ⭐ NOUVEAU |

---

## 🎬 Exemple Complet

### 1. Créer les Préférences
```bash
curl -X POST http://localhost:8082/api/forum/email/preferences \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "welcomeEmails": true,
    "replyNotifications": true,
    "weeklyDigests": false,
    "mentionAlerts": true,
    "dailySummaries": false,
    "unreadReminders": true,
    "unsubscribeAll": false
  }'
```

### 2. Lire les Préférences
```bash
curl http://localhost:8082/api/forum/email/preferences/1
```

### 3. Envoyer un Email de Test
```bash
curl -X POST "http://localhost:8082/api/forum/email/test?email=test@example.com&userId=1"
```

### 4. Mettre à Jour les Préférences
```bash
curl -X PUT http://localhost:8082/api/forum/email/preferences/1 \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "welcomeEmails": false,
    "replyNotifications": true,
    "weeklyDigests": false,
    "mentionAlerts": true,
    "dailySummaries": false,
    "unreadReminders": true,
    "unsubscribeAll": false
  }'
```

---

## 🆘 Support

### Logs à Vérifier
```bash
# Logs complets
tail -f forum-service/logs/application.log

# Seulement les emails
tail -f forum-service/logs/application.log | grep -i email

# Seulement les erreurs
tail -f forum-service/logs/application.log | grep ERROR
```

### Tests MySQL
```sql
-- Vérifier la table existe
SHOW TABLES LIKE 'email%';

-- Vérifier les données
SELECT * FROM email_preference;
SELECT * FROM email_log;

-- Supprimer les préférences pour retester
DELETE FROM email_preference WHERE user_id = 1;
```

---

## ✅ Résumé

**Corrections appliquées**:
1. ✅ Logique de sauvegarde améliorée (CREATE si UPDATE échoue)
2. ✅ Endpoint de test email ajouté
3. ✅ Configuration SMTP déjà en place

**Pour tester**:
1. Sauvegarder les préférences dans l'UI
2. Envoyer un email de test avec cURL
3. Vérifier la réception dans votre boîte

**Prêt à tester ! 📧**
