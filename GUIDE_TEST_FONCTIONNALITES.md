# 🧪 Guide de Test des Fonctionnalités Avancées du Forum

## ✅ Fonctionnalités Intégrées

### 1. 🤖 Chatbot Widget (Frontend uniquement)
**Localisation**: Coin inférieur droit de toutes les pages

**Comment tester**:
1. Ouvrez n'importe quelle page de l'application
2. Cherchez l'icône violette du chatbot en bas à droite
3. Cliquez sur l'icône pour ouvrir le chat
4. Tapez une question (ex: "Comment créer un forum?")
5. Le chatbot répond avec des informations stockées localement

**Fonctionnalités**:
- ✅ Conversation interactive
- ✅ Historique sauvegardé dans localStorage
- ✅ Bouton pour effacer l'historique
- ✅ Interface moderne et responsive

---

### 2. 📎 Upload Multimédia dans les Messages
**Localisation**: Formulaire de création de message dans `/forums`

**Comment tester**:
1. Allez sur `/forums`
2. Sélectionnez un forum
3. Cliquez sur "Nouveau Message"
4. Remplissez le message
5. **Nouvelle section visible**: "Ajouter des médias (optionnel)"

**Types de médias supportés**:
- 📷 **Images**: JPG, PNG, GIF, WebP (max 5MB)
- 🎵 **Audio**: MP3, WAV, OGG (max 10MB)
- 📄 **Documents**: PDF, ZIP, DOC, DOCX, XLS, XLSX (max 20MB)
- 🎬 **Vidéos YouTube**: Collez l'URL YouTube

**Processus**:
1. Sélectionnez un ou plusieurs fichiers
2. Le nom du fichier s'affiche en vert avec ✓
3. Cliquez sur "Publier"
4. Les fichiers sont uploadés automatiquement après la création du message

**API Backend utilisée**:
- `POST /api/forum/multimedia/upload/image`
- `POST /api/forum/multimedia/upload/audio`
- `POST /api/forum/multimedia/upload/document`
- `POST /api/forum/multimedia/embed/video`

---

### 3. 📧 Préférences Email
**Localisation**: Icône email dans le header (en haut à droite)

**Comment tester**:
1. Cherchez l'icône d'enveloppe 📧 dans le header
2. Cliquez dessus pour accéder à `/preferences`
3. Page de configuration des notifications email

**Options disponibles**:
- ✅ Emails de bienvenue
- ✅ Notifications de réponse
- ✅ Digest hebdomadaire (dimanche)
- ✅ Alertes de mention (@username)
- ✅ Résumé quotidien (18h)
- ✅ Rappels de discussions non lues
- ❌ Se désabonner de tout

**Fonctionnalités**:
- Toggle switches modernes
- Sauvegarde automatique
- Messages de confirmation
- Préférences par défaut si non configurées

**API Backend utilisée**:
- `GET /api/forum/email/preferences/{userId}`
- `PUT /api/forum/email/preferences/{userId}`

---

## 🚀 Démarrage des Services

### Backend (Forum Service)
```bash
cd forum-service
mvn spring-boot:run
```
**Port**: 8082
**URL**: http://localhost:8082

### Frontend Public
```bash
cd angular-app/frontend/angular-app
npm install
npm start
```
**Port**: 4300
**URL**: http://localhost:4300

### Frontend Back-Office
```bash
cd angular-app/back-office
npm install
npm start
```
**Port**: 4301
**URL**: http://localhost:4301

---

## 🔍 Vérification Visuelle

### Chatbot Widget
- [ ] Icône violette visible en bas à droite
- [ ] Clic ouvre la fenêtre de chat
- [ ] Messages s'affichent correctement
- [ ] Bouton "Effacer" fonctionne

### Upload Multimédia
- [ ] Section "Ajouter des médias" visible dans le formulaire
- [ ] 4 champs d'upload présents (image, audio, document, vidéo)
- [ ] Validation des formats fonctionne
- [ ] Validation de la taille fonctionne
- [ ] Nom du fichier s'affiche après sélection

### Préférences Email
- [ ] Icône email visible dans le header
- [ ] Page `/preferences` accessible
- [ ] 7 options de notification affichées
- [ ] Toggle switches fonctionnent
- [ ] Bouton "Enregistrer" fonctionne

---

## 🐛 Dépannage

### Le chatbot n'apparaît pas
- Vérifiez que `<app-chatbot-widget>` est dans `app.html`
- Vérifiez que `ChatbotWidgetComponent` est importé dans `app.ts`
- Rechargez la page avec Ctrl+F5

### Les champs d'upload ne s'affichent pas
- Vérifiez que vous êtes en mode "Nouveau Message" (pas édition)
- Vérifiez que `MultimediaService` est injecté dans `forums-public.ts`
- Vérifiez la console pour les erreurs

### L'icône email n'apparaît pas
- Vérifiez que le lien est dans `header.html`
- Vérifiez que la route `/preferences` existe dans `app.routes.ts`
- Vérifiez que `EmailPreferencesComponent` est importé

### Erreur backend
- Vérifiez que le backend tourne sur le port 8082
- Vérifiez les logs du backend pour les erreurs
- Vérifiez que la base de données est accessible

---

## 📊 Endpoints API Disponibles

### Multimédia
- `POST /api/forum/multimedia/upload/image` - Upload image
- `POST /api/forum/multimedia/upload/audio` - Upload audio
- `POST /api/forum/multimedia/upload/document` - Upload document
- `POST /api/forum/multimedia/embed/video` - Embed YouTube
- `GET /api/forum/multimedia/file/{id}` - Télécharger fichier
- `GET /api/forum/multimedia/thumbnail/{id}` - Miniature
- `DELETE /api/forum/multimedia/file/{id}` - Supprimer
- `GET /api/forum/multimedia/gallery/{forumId}` - Galerie

### Email
- `GET /api/forum/email/preferences/{userId}` - Récupérer préférences
- `PUT /api/forum/email/preferences/{userId}` - Mettre à jour
- `POST /api/forum/email/send-welcome/{userId}` - Email de bienvenue

### Chatbot
- ❌ Pas d'API backend (frontend uniquement avec localStorage)

---

## 📝 Notes Importantes

1. **Chatbot**: Fonctionne entièrement côté frontend, pas besoin du backend
2. **Multimédia**: Nécessite le backend sur le port 8082
3. **Email**: Nécessite configuration SMTP dans `application.properties`
4. **Stockage**: Les fichiers sont stockés dans `uploads/` à la racine du projet backend

---

## ✨ Prochaines Étapes

Pour améliorer l'expérience utilisateur:
1. Afficher les médias uploadés dans la liste des messages
2. Ajouter une galerie de médias par forum
3. Implémenter la transcription audio (nécessite OpenAI API)
4. Ajouter des notifications email réelles (nécessite SMTP)
5. Améliorer le chatbot avec plus de connaissances

---

**Date de création**: 5 mars 2026
**Version**: 1.0
