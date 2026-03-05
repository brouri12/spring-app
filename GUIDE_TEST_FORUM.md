# 🧪 Guide de Test - Fonctionnalités Forum Avancées

## 📋 Prérequis

1. **Démarrer le service forum:**
```bash
cd forum-service
mvn spring-boot:run
```

2. **Accéder à Swagger:**
```
http://localhost:8082/swagger-ui.html
```

---

## 🎯 Scénarios de Test

### 1️⃣ Test du Système de Likes

#### Étape 1: Liker un message
```
POST /api/forum/interactions/likes/{messageId}/{utilisateurId}
Exemple: POST /api/forum/interactions/likes/1/1
```
✅ **Résultat attendu:** 
- Like créé
- +5 points pour l'auteur du message
- Notification envoyée à l'auteur

#### Étape 2: Vérifier le nombre de likes
```
GET /api/forum/interactions/likes/1/count
```
✅ **Résultat attendu:** `{"count": 1}`

#### Étape 3: Unliker
```
DELETE /api/forum/interactions/likes/1/1
```
✅ **Résultat attendu:** -5 points retirés

---

### 2️⃣ Test des Réponses (Threads)

#### Étape 1: Créer une réponse
```
POST /api/forum/interactions/reponses
Body:
{
  "messageParentId": 1,
  "auteurId": 2,
  "contenu": "Excellente question ! Voici ma réponse..."
}
```
✅ **Résultat attendu:**
- Réponse créée
- +3 points pour l'auteur de la réponse
- Notification envoyée à l'auteur du message parent

#### Étape 2: Obtenir les réponses
```
GET /api/forum/interactions/reponses/1
```

#### Étape 3: Modifier une réponse (seul l'auteur)
```
PUT /api/forum/interactions/reponses/{reponseId}?contenu=Nouveau contenu&utilisateurId=2
```

---

### 3️⃣ Test de la Modération

#### Étape 1: Créer un signalement
```
POST /api/forum/moderation/signalements
Body:
{
  "messageId": 1,
  "signalePar": 3,
  "motif": "Contenu inapproprié",
  "description": "Ce message contient du spam"
}
```

#### Étape 2: Créer 2 autres signalements (même message)
```
POST /api/forum/moderation/signalements
Body: { "messageId": 1, "signalePar": 4, "motif": "Spam" }

POST /api/forum/moderation/signalements
Body: { "messageId": 1, "signalePar": 5, "motif": "Spam" }
```
✅ **Résultat attendu:** Message automatiquement modéré après 3 signalements

#### Étape 3: Voir les signalements en attente
```
GET /api/forum/moderation/signalements/en-attente
```

#### Étape 4: Traiter un signalement
```
PUT /api/forum/moderation/signalements/{signalementId}/traiter?moderateurId=1&decision=TRAITE&commentaire=Signalement validé
```

---

### 4️⃣ Test des Notifications

#### Étape 1: Voir les notifications d'un utilisateur
```
GET /api/forum/notifications/utilisateur/1
```

#### Étape 2: Voir les notifications non lues
```
GET /api/forum/notifications/utilisateur/1/non-lues
```

#### Étape 3: Compter les notifications non lues
```
GET /api/forum/notifications/utilisateur/1/non-lues/count
```

#### Étape 4: Marquer une notification comme lue
```
PUT /api/forum/notifications/{notificationId}/marquer-lue
```

#### Étape 5: Marquer toutes comme lues
```
PUT /api/forum/notifications/utilisateur/1/marquer-toutes-lues
```

---

### 5️⃣ Test du Système de Badges

#### Étape 1: Voir le badge d'un utilisateur
```
GET /api/forum/badges/utilisateur/1
```
✅ **Résultat attendu:** Points, niveau, statistiques

#### Étape 2: Ajouter des points manuellement
```
POST /api/forum/badges/utilisateur/1/points?points=50
```

#### Étape 3: Voir le top 10 des contributeurs
```
GET /api/forum/badges/top-contributeurs
```

#### Étape 4: Mettre à jour les statistiques
```
PUT /api/forum/badges/utilisateur/1/statistiques
```

---

### 6️⃣ Test des Statistiques & Analyses

#### Étape 1: Statistiques globales
```
GET /api/forum/analyse/statistiques/globales
```
✅ **Résultat attendu:** Nombre total de forums, messages, likes, réponses, top 5 contributeurs

#### Étape 2: Statistiques par forum
```
GET /api/forum/analyse/statistiques/par-forum
```

#### Étape 3: Statistiques par niveau
```
GET /api/forum/analyse/statistiques/par-niveau
```

#### Étape 4: Forum le plus actif
```
GET /api/forum/analyse/forum-plus-actif
```

#### Étape 5: Étudiant le plus actif
```
GET /api/forum/analyse/etudiant-plus-actif
```

#### Étape 6: Taux d'engagement par groupe
```
GET /api/forum/analyse/engagement/par-groupe
```

#### Étape 7: Analyse par période
```
GET /api/forum/analyse/activite/periode?dateDebut=2024-01-01&dateFin=2024-12-31
```

---

### 7️⃣ Test des Règles Métier

#### Test 1: Bloquer publication si forum fermé
```
1. PATCH /api/forum/forums/1/fermer
2. POST /api/forum/messages/forum/1 (avec un message)
```
✅ **Résultat attendu:** Erreur "Impossible de publier : le forum est fermé"

#### Test 2: Seul l'auteur peut modifier
```
PUT /api/forum/interactions/reponses/1?contenu=Test&utilisateurId=999
```
✅ **Résultat attendu:** Erreur "Seul l'auteur peut modifier sa réponse"

#### Test 3: Modération automatique
```
Créer 3 signalements pour le même message
```
✅ **Résultat attendu:** Message passe en statut "MODERE"

---

## 🎮 Scénario Complet de Test

### Scénario: "Étudiant actif devient Top Contributor"

1. **Créer un forum:**
```
POST /api/forum/forums
Body: { "titre": "Forum L1 Info", "niveau": "L1", "groupe": "G1", "statut": "OUVERT" }
```

2. **Publier 5 messages:**
```
POST /api/forum/messages/forum/{forumId}
Body: { "auteurId": 1, "contenu": "Message 1", "type_auteur": "ETUDIANT" }
(Répéter 5 fois)
```
✅ Points: 5 × 10 = 50 points

3. **Recevoir 10 likes:**
```
POST /api/forum/interactions/likes/{messageId}/2
(Répéter pour 10 likes différents)
```
✅ Points: 10 × 5 = 50 points (Total: 100 points → ARGENT)

4. **Publier 20 réponses:**
```
POST /api/forum/interactions/reponses
(Répéter 20 fois)
```
✅ Points: 20 × 3 = 60 points (Total: 160 points)

5. **Vérifier le badge:**
```
GET /api/forum/badges/utilisateur/1
```
✅ **Résultat attendu:** Niveau ARGENT, 160 points

6. **Vérifier le classement:**
```
GET /api/forum/badges/top-contributeurs
```
✅ **Résultat attendu:** Utilisateur 1 dans le top 10

---

## 📊 Vérification des Notifications

Après chaque action, vérifier les notifications:
```
GET /api/forum/notifications/utilisateur/{userId}/non-lues
```

Types de notifications attendues:
- 🔔 **LIKE** - "Quelqu'un a aimé votre message"
- 🔔 **REPONSE** - "Quelqu'un a répondu à votre message"
- 🔔 **SIGNALEMENT** - "Votre message a été supprimé"
- 🔔 **BADGE** - "Félicitations ! Vous avez atteint le niveau ARGENT"

---

## ✅ Checklist de Test

- [ ] Likes fonctionnent (ajout/retrait)
- [ ] Points attribués correctement
- [ ] Réponses créées avec succès
- [ ] Threads de discussion visibles
- [ ] Signalements créés
- [ ] Modération automatique à 3 signalements
- [ ] Notifications envoyées
- [ ] Notifications marquées comme lues
- [ ] Badges calculés correctement
- [ ] Niveaux de badges mis à jour
- [ ] Top contributeurs affiché
- [ ] Statistiques globales correctes
- [ ] Forum fermé bloque les publications
- [ ] Seul l'auteur peut modifier
- [ ] Recherche de messages fonctionne

---

## 🐛 Dépannage

### Erreur: "Message non trouvé"
➡️ Vérifier que le message existe: `GET /api/forum/messages/forum/{forumId}`

### Erreur: "Forum fermé"
➡️ Rouvrir le forum: `PATCH /api/forum/forums/{id}/rouvrir`

### Erreur: "Seul l'auteur peut modifier"
➡️ Utiliser le bon `utilisateurId` (celui de l'auteur)

### Pas de notifications
➡️ Vérifier que les actions génèrent des notifications (like, réponse, etc.)

---

## 📱 Prochaine Étape: Intégration Angular

Une fois les tests backend validés, nous intégrerons ces fonctionnalités dans l'interface Angular du back-office.
