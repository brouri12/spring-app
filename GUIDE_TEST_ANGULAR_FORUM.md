# 🧪 Guide de Test - Forum Angular (Back-Office)

## 📋 Prérequis

### 1. Démarrer le backend (forum-service)
```bash
cd forum-service
mvn spring-boot:run
```
Le service démarre sur **http://localhost:8082**

### 2. Démarrer le back-office Angular
```bash
cd angular-app/back-office
npm install  # Si première fois
ng serve --port 4201
```
Le back-office démarre sur **http://localhost:4201**

### 3. Accéder à l'interface
```
http://localhost:4201/forum
```

---

## 🎯 Fonctionnalités Disponibles

### ✅ Fonctionnalités Existantes (déjà testées)
- ✅ Créer un forum
- ✅ Modifier un forum
- ✅ Supprimer un forum
- ✅ Fermer/Rouvrir un forum
- ✅ Publier un message
- ✅ Modifier un message
- ✅ Supprimer un message

### 🆕 Nouvelles Fonctionnalités (à tester)

#### 1. Système de Likes ❤️
**Localisation:** Colonne "Interactions" dans la table des messages

**Actions:**
- Cliquer sur le cœur pour liker un message
- Le cœur devient rouge quand liké
- Le compteur de likes s'incrémente
- Cliquer à nouveau pour unliker
- Le compteur se décrémente

**Points attendus:**
- +5 points pour l'auteur du message quand quelqu'un like
- -5 points quand quelqu'un unlike

#### 2. Système de Réponses 💬
**Localisation:** Colonne "Interactions" dans la table des messages

**Actions:**
- Cliquer sur l'icône de message pour voir les réponses existantes
- Les réponses s'affichent sous le message
- Cliquer sur l'icône de flèche pour répondre
- Un modal s'ouvre pour écrire la réponse
- Publier la réponse
- Le compteur de réponses s'incrémente

**Points attendus:**
- +3 points pour l'auteur de la réponse
- Notification envoyée à l'auteur du message parent

#### 3. Système de Signalement 🚨
**Localisation:** Colonne "Interactions" dans la table des messages

**Actions:**
- Cliquer sur l'icône de drapeau pour signaler
- Un modal s'ouvre avec un formulaire
- Sélectionner un motif (Spam, Contenu inapproprié, etc.)
- Ajouter une description (optionnel)
- Envoyer le signalement

**Modération automatique:**
- Si 3 utilisateurs différents signalent le même message
- Le message passe automatiquement en statut "MODERE"
- L'auteur reçoit une notification

#### 4. Statistiques Globales 📊
**Localisation:** Bouton "Statistiques" en haut à droite

**Affichage:**
- Nombre total de forums
- Nombre total de messages
- Nombre total de likes
- Nombre total de réponses
- Top 5 des contributeurs avec:
  - Nombre de messages
  - Nombre de likes reçus
  - Niveau de badge (BRONZE/ARGENT/OR/PLATINE)
  - Points totaux

#### 5. Badge Utilisateur 🏆
**Localisation:** Bouton "Mon Badge" en haut à droite

**Affichage:**
- Badge actuel (🥉 BRONZE, 🥈 ARGENT, 🥇 OR, 💎 PLATINE)
- Points totaux
- Nombre de messages publiés
- Nombre de likes reçus
- Nombre de réponses données
- Barre de progression vers le prochain niveau

**Niveaux:**
- 🥉 BRONZE: 0-99 points
- 🥈 ARGENT: 100-499 points
- 🥇 OR: 500-999 points
- 💎 PLATINE: 1000+ points

---

## 🧪 Scénarios de Test

### Scénario 1: Tester le système de likes

1. **Créer un forum** (si pas déjà fait)
   - Cliquer sur "Nouveau Forum"
   - Remplir: Titre, Description, Niveau (L1), Groupe (G1), Cours
   - Créer

2. **Publier un message**
   - Sélectionner le forum
   - Cliquer sur "Nouveau Message"
   - Écrire un message
   - Publier

3. **Liker le message**
   - Dans la colonne "Interactions", cliquer sur le cœur
   - ✅ Le cœur devient rouge
   - ✅ Le compteur passe à 1
   - ✅ Message de succès "👍 Message liké !"

4. **Unliker le message**
   - Cliquer à nouveau sur le cœur rouge
   - ✅ Le cœur redevient gris
   - ✅ Le compteur passe à 0

---

### Scénario 2: Tester les réponses

1. **Répondre à un message**
   - Cliquer sur l'icône de flèche (répondre)
   - Un modal s'ouvre
   - Écrire une réponse
   - Cliquer sur "Publier la réponse"
   - ✅ Message de succès "💬 Réponse publiée !"
   - ✅ Le compteur de réponses s'incrémente

2. **Voir les réponses**
   - Cliquer sur l'icône de message (bulle)
   - ✅ Les réponses s'affichent sous le message
   - ✅ Chaque réponse montre: contenu, auteur, date

3. **Masquer les réponses**
   - Cliquer à nouveau sur l'icône de message
   - ✅ Les réponses se cachent

---

### Scénario 3: Tester les signalements

1. **Signaler un message**
   - Cliquer sur l'icône de drapeau
   - Un modal s'ouvre
   - Sélectionner un motif (ex: "Spam")
   - Ajouter une description
   - Cliquer sur "Envoyer le signalement"
   - ✅ Message de succès "🚨 Signalement envoyé !"

2. **Tester la modération automatique** (nécessite 3 signalements)
   - Signaler le même message 3 fois (avec différents utilisateurs via Swagger)
   - ✅ Le message passe en statut "MODERE"
   - ✅ L'auteur reçoit une notification

---

### Scénario 4: Tester les statistiques

1. **Ouvrir les statistiques**
   - Cliquer sur le bouton "Statistiques" en haut à droite
   - Un modal s'ouvre

2. **Vérifier les données**
   - ✅ Nombre de forums affiché
   - ✅ Nombre de messages affiché
   - ✅ Nombre de likes affiché
   - ✅ Nombre de réponses affiché
   - ✅ Top 5 contributeurs avec badges et points

---

### Scénario 5: Tester le badge utilisateur

1. **Ouvrir le badge**
   - Cliquer sur le bouton "Mon Badge" en haut à droite
   - Un modal s'ouvre

2. **Vérifier les données**
   - ✅ Badge actuel affiché (BRONZE par défaut)
   - ✅ Points totaux affichés
   - ✅ Nombre de messages affichés
   - ✅ Nombre de likes reçus affichés
   - ✅ Nombre de réponses affichées
   - ✅ Barre de progression visible

3. **Gagner des points**
   - Publier 5 messages → +50 points (10 points/message)
   - Recevoir 10 likes → +50 points (5 points/like)
   - ✅ Total: 100 points → Badge ARGENT 🥈

---

## 🎮 Scénario Complet: "Devenir Top Contributor"

### Objectif: Atteindre le niveau ARGENT (100 points)

1. **Créer un forum**
   - Titre: "Forum Test L1"
   - Niveau: L1, Groupe: G1, Cours: "Test"

2. **Publier 5 messages** (+50 points)
   - Message 1: "Bonjour à tous !"
   - Message 2: "Question sur le cours"
   - Message 3: "Partage de ressources"
   - Message 4: "Discussion intéressante"
   - Message 5: "Merci pour vos réponses"

3. **Simuler 10 likes** (via Swagger ou autre utilisateur)
   - Liker chaque message 2 fois
   - +50 points (5 points par like reçu)

4. **Vérifier le badge**
   - Cliquer sur "Mon Badge"
   - ✅ Points: 100
   - ✅ Badge: ARGENT 🥈
   - ✅ Notification reçue: "Félicitations ! Vous avez atteint le niveau ARGENT"

5. **Vérifier le classement**
   - Cliquer sur "Statistiques"
   - ✅ Apparaître dans le Top 5 contributeurs

---

## 🐛 Dépannage

### Erreur: "Failed to load resource: the server responded with a status of 404"
➡️ **Solution:** Vérifier que le forum-service est bien démarré sur le port 8082

### Erreur: "CORS policy"
➡️ **Solution:** Les controllers ont déjà `@CrossOrigin(origins = "*")`, redémarrer le backend

### Les likes/réponses ne s'affichent pas
➡️ **Solution:** 
1. Ouvrir la console du navigateur (F12)
2. Vérifier les erreurs réseau
3. Vérifier que l'API répond correctement

### Le badge ne se met pas à jour
➡️ **Solution:** 
1. Fermer et rouvrir le modal "Mon Badge"
2. Ou appeler l'endpoint de mise à jour via Swagger:
   ```
   PUT /api/forum/badges/utilisateur/1/statistiques
   ```

### Les statistiques sont vides
➡️ **Solution:** 
1. S'assurer qu'il y a des données (forums, messages, likes)
2. Vérifier que le backend répond correctement:
   ```
   GET http://localhost:8082/api/forum/analyse/statistiques/globales
   ```

---

## ✅ Checklist de Test

- [ ] Liker un message
- [ ] Unliker un message
- [ ] Compteur de likes correct
- [ ] Répondre à un message
- [ ] Voir les réponses
- [ ] Compteur de réponses correct
- [ ] Signaler un message
- [ ] Voir les statistiques globales
- [ ] Voir le top contributeurs
- [ ] Voir mon badge
- [ ] Progression du badge correcte
- [ ] Points attribués correctement
- [ ] Messages de succès affichés
- [ ] Modals s'ouvrent et se ferment
- [ ] Dark mode fonctionne

---

## 📱 Prochaines Améliorations Possibles

1. **Notifications en temps réel**
   - Afficher un badge avec le nombre de notifications non lues
   - Panel de notifications dans le header

2. **Modération**
   - Page dédiée pour les modérateurs
   - Traiter les signalements en attente
   - Voir les messages avec multiples signalements

3. **Analytics avancées**
   - Graphiques d'activité par période
   - Forum le plus actif
   - Étudiant le plus actif
   - Taux d'engagement par groupe

4. **Recherche intelligente**
   - Recherche par mot-clé dans les messages
   - Filtres avancés

---

## 🎉 Résultat Attendu

Après avoir suivi ce guide, vous devriez avoir:
- ✅ Un système de likes fonctionnel
- ✅ Un système de réponses (threads)
- ✅ Un système de signalement
- ✅ Des statistiques globales
- ✅ Un système de badges et gamification
- ✅ Une interface utilisateur complète et intuitive

Toutes les fonctionnalités avancées du forum sont maintenant disponibles et testables dans l'interface Angular! 🚀
