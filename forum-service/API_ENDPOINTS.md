# 📚 Forum Service - API Endpoints Documentation

## 🎯 Base URL
```
http://localhost:8082/api/forum
```

---

## 🔵 1. INTERACTIONS (Likes & Réponses)
**Base:** `/api/forum/interactions`

### Likes
- **POST** `/likes/{messageId}/{utilisateurId}` - Liker un message
- **DELETE** `/likes/{messageId}/{utilisateurId}` - Unliker un message
- **GET** `/likes/{messageId}/count` - Nombre de likes d'un message
- **GET** `/likes/{messageId}/check/{utilisateurId}` - Vérifier si utilisateur a liké
- **GET** `/likes/{messageId}` - Liste des likes d'un message

### Réponses
- **POST** `/reponses` - Créer une réponse (Body: ReponseMessage)
- **GET** `/reponses/{messageId}` - Obtenir les réponses d'un message
- **GET** `/reponses/{messageId}/count` - Nombre de réponses
- **PUT** `/reponses/{reponseId}?contenu=...&utilisateurId=...` - Modifier une réponse
- **DELETE** `/reponses/{reponseId}?utilisateurId=...&typeUtilisateur=...` - Supprimer une réponse

---

## 🟡 2. MODÉRATION (Signalements)
**Base:** `/api/forum/moderation`

- **POST** `/signalements` - Créer un signalement (Body: Signalement)
- **GET** `/signalements/en-attente` - Signalements en attente
- **GET** `/signalements/message/{messageId}` - Signalements d'un message
- **PUT** `/signalements/{signalementId}/traiter?moderateurId=...&decision=...&commentaire=...` - Traiter un signalement
- **GET** `/signalements/multiples` - Messages avec multiples signalements

---

## 🔔 3. NOTIFICATIONS
**Base:** `/api/forum/notifications`

- **GET** `/utilisateur/{utilisateurId}` - Toutes les notifications d'un utilisateur
- **GET** `/utilisateur/{utilisateurId}/non-lues` - Notifications non lues
- **GET** `/utilisateur/{utilisateurId}/non-lues/count` - Nombre de notifications non lues
- **PUT** `/{notificationId}/marquer-lue` - Marquer une notification comme lue
- **PUT** `/utilisateur/{utilisateurId}/marquer-toutes-lues` - Marquer toutes comme lues
- **DELETE** `/{notificationId}?utilisateurId=...` - Supprimer une notification

---

## 🏆 4. BADGES & GAMIFICATION
**Base:** `/api/forum/badges`

- **GET** `/utilisateur/{utilisateurId}` - Badge d'un utilisateur
- **POST** `/utilisateur/{utilisateurId}/points?points=...` - Ajouter des points
- **DELETE** `/utilisateur/{utilisateurId}/points?points=...` - Retirer des points
- **PUT** `/utilisateur/{utilisateurId}/statistiques` - Mettre à jour les statistiques
- **GET** `/top-contributeurs` - Top 10 des contributeurs
- **GET** `/niveau/{niveau}` - Badges par niveau (BRONZE/ARGENT/OR/PLATINE)

---

## 📊 5. ANALYSE & STATISTIQUES
**Base:** `/api/forum/analyse`

- **GET** `/statistiques/globales` - Statistiques globales du forum
- **GET** `/statistiques/par-forum` - Statistiques par forum
- **GET** `/statistiques/par-niveau` - Statistiques par niveau (L1-M2)
- **GET** `/forum-plus-actif` - Forum le plus actif
- **GET** `/etudiant-plus-actif` - Étudiant le plus actif
- **GET** `/engagement/par-groupe` - Taux d'engagement par groupe
- **GET** `/activite/periode?dateDebut=YYYY-MM-DD&dateFin=YYYY-MM-DD` - Analyse par période

---

## 📝 6. FORUMS & MESSAGES (Existants)
**Base:** `/api/forum`

### Forums
- **GET** `/forums` - Tous les forums
- **GET** `/forums/{id}` - Forum par ID
- **POST** `/forums` - Créer un forum
- **PUT** `/forums/{id}` - Modifier un forum
- **DELETE** `/forums/{id}` - Supprimer un forum
- **PATCH** `/forums/{id}/fermer` - Fermer un forum
- **PATCH** `/forums/{id}/rouvrir` - Rouvrir un forum
- **GET** `/forums/recherche?titre=...&page=0&size=10` - Rechercher des forums
- **GET** `/forums/niveau/{niveau}` - Forums par niveau
- **GET** `/forums/statut/{statut}` - Forums par statut
- **GET** `/forums/plus-actifs` - Forums les plus actifs

### Messages
- **GET** `/messages/forum/{id}` - Messages d'un forum
- **POST** `/messages/forum/{forumId}` - Publier un message
- **GET** `/messages/search?keyword=...` - Rechercher des messages
- **PUT** `/messages/{id}` - Modifier un message
- **DELETE** `/messages/{id}` - Supprimer un message
- **GET** `/forums/{id}/messages/count` - Compter les messages d'un forum

---

## 🎮 Système de Points

### Attribution automatique:
- **+10 points** - Publier un message
- **+5 points** - Recevoir un like
- **+3 points** - Publier une réponse

### Niveaux de badges:
- **BRONZE** - 0-99 points
- **ARGENT** - 100-499 points
- **OR** - 500-999 points
- **PLATINE** - 1000+ points

---

## 🔐 Règles Métier

### Contrôle d'accès:
- ✅ Seul l'auteur peut modifier son message/réponse
- ✅ Enseignants et admins peuvent modérer
- ✅ Forums fermés bloquent les publications
- ✅ 3+ signalements = modération automatique

### Notifications automatiques:
- 🔔 Like reçu sur un message
- 🔔 Réponse reçue sur un message
- 🔔 Message supprimé par modération
- 🔔 Nouveau niveau de badge atteint

---

## 🧪 Test avec Swagger
Accédez à: `http://localhost:8082/swagger-ui.html`

## 🚀 Démarrage du service
```bash
cd forum-service
mvn spring-boot:run
```

Le service démarre sur le port **8082**.
