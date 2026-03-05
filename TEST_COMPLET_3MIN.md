# ⚡ Test Complet en 3 Minutes

Guide ultra-rapide pour tester les 3 fonctionnalités principales.

---

## 🚀 Prérequis (30 secondes)

### Backend
```bash
cd forum-service
mvn spring-boot:run
```
✅ Doit tourner sur http://localhost:8082

### Frontend
```bash
cd angular-app/frontend/angular-app
ng serve --port 4300
```
✅ Doit tourner sur http://localhost:4300

---

## 1️⃣ Test Chatbot (30 secondes)

### Actions
1. Ouvrez http://localhost:4300
2. Regardez en bas à droite → Icône 💬
3. Cliquez sur l'icône
4. Tapez: "Comment créer un forum?"
5. Appuyez sur Entrée

### ✅ Résultat attendu
- Fenêtre de chat s'ouvre
- Message envoyé visible
- Réponse du bot apparaît
- Historique sauvegardé

### ❌ Si ça ne marche pas
- Vérifiez la console (F12)
- Vérifiez que `ChatbotWidgetComponent` est dans `app.ts`

---

## 2️⃣ Test Préférences Email (30 secondes)

### Actions
1. Cliquez sur l'icône ✉️ dans le header
2. Cochez "Nouveaux messages"
3. Cochez "Réponses à mes messages"
4. Cliquez "Enregistrer"

### ✅ Résultat attendu
- Redirection vers `/email-preferences`
- Formulaire avec cases à cocher
- Message de confirmation après sauvegarde

### ❌ Si ça ne marche pas
- Erreur 404 ? → Backend pas démarré
- Icône absente ? → Vérifiez `header.html`

---

## 3️⃣ Test Upload de Médias (1 minute)

### Actions
1. Allez sur http://localhost:4300/forums
2. Cliquez sur un forum (ex: "Forum de Jungle")
3. Cliquez "Nouveau Message" (bouton vert)
4. Remplissez:
   - Type: Étudiant
   - Message: "Test avec médias"
5. Scrollez vers le bas
6. Section "Ajouter des médias"
7. Sélectionnez une image
8. Cliquez "Publier"

### ✅ Résultat attendu
- Formulaire s'ouvre
- Section médias visible en bas
- Fichier sélectionné (✓ nom du fichier)
- Message publié avec succès
- **Médias visibles sous le message** ⭐

### ❌ Si ça ne marche pas
- Section médias absente ? → Vérifiez que vous êtes en mode "Nouveau" (pas "Modifier")
- Upload échoue ? → Backend pas démarré
- Médias ne s'affichent pas ? → Vérifiez la console

---

## 4️⃣ Test Affichage des Médias (1 minute)

### Actions
1. Après avoir publié le message (étape 3)
2. Regardez sous le texte du message
3. Section "📎 Fichiers joints (1)"
4. Cliquez sur l'image pour l'agrandir

### ✅ Résultat attendu
```
┌─────────────────────────────────────┐
│ Test avec médias                    │
├─────────────────────────────────────┤
│ 📎 Fichiers joints (1)              │
│                                     │
│ ┌──────────────┐                   │
│ │ 📷 Image     │                   │
│ │              │                   │
│ │ [Preview]    │                   │
│ │              │                   │
│ │ photo.jpg    │                   │
│ │ 2.5 MB       │                   │
│ └──────────────┘                   │
└─────────────────────────────────────┘
```

### ❌ Si ça ne marche pas
- Médias absents ? → Backend pas démarré
- Erreur 404 ? → Endpoint `/api/forum/multimedia/message/{id}` manquant
- Console montre erreurs ? → Vérifiez les logs backend

---

## 🎯 Checklist Complète

### Avant de commencer
- [ ] Backend démarré (port 8082)
- [ ] Frontend démarré (port 4300)
- [ ] Navigateur ouvert sur http://localhost:4300

### Test 1: Chatbot
- [ ] Icône visible en bas à droite
- [ ] Fenêtre s'ouvre au clic
- [ ] Message envoyé
- [ ] Réponse reçue

### Test 2: Préférences Email
- [ ] Icône email dans header
- [ ] Page `/email-preferences` accessible
- [ ] Cases à cocher fonctionnent
- [ ] Sauvegarde réussie

### Test 3: Upload Médias
- [ ] Bouton "Nouveau Message" visible
- [ ] Section médias en bas du formulaire
- [ ] Fichier sélectionné
- [ ] Upload réussi

### Test 4: Affichage Médias
- [ ] Section "Fichiers joints" visible
- [ ] Image prévisualisée
- [ ] Clic agrandit l'image
- [ ] Taille du fichier affichée

---

## 🐛 Dépannage Rapide

### Erreur: "Failed to load resource: 404"
**Cause**: Backend pas démarré ou endpoint manquant  
**Solution**: Vérifiez que le backend tourne sur le port 8082

### Erreur: "Cannot read property of undefined"
**Cause**: Données manquantes  
**Solution**: Vérifiez que le forum a des messages

### Erreur: "CORS policy"
**Cause**: Backend ne permet pas les requêtes depuis le frontend  
**Solution**: Vérifiez `@CrossOrigin(origins = "*")` dans les controllers

### Section médias absente
**Cause**: Mode "Modifier" au lieu de "Nouveau"  
**Solution**: Cliquez sur "Nouveau Message" (pas sur "Modifier")

### Médias ne s'affichent pas
**Cause**: Endpoint backend manquant ou backend arrêté  
**Solution**: 
1. Vérifiez que le backend tourne
2. Testez: `curl http://localhost:8082/api/forum/multimedia/message/1`
3. Vérifiez les logs backend

---

## 📊 Résultats Attendus

### Tous les tests passent ✅
**Félicitations !** Tout fonctionne correctement.

### Certains tests échouent ⚠️
**Consultez**:
- `ETAT_FINAL_PROJET.md` - État complet du projet
- `OU_TROUVER_LES_FONCTIONNALITES.md` - Guide visuel
- Console du navigateur (F12)
- Logs du backend

---

## 🎬 Scénario Complet (3 minutes)

### Minute 1: Chatbot
1. Ouvrir http://localhost:4300
2. Cliquer sur le chatbot
3. Poser une question
4. Vérifier la réponse

### Minute 2: Upload
1. Aller sur `/forums`
2. Sélectionner un forum
3. Créer un nouveau message avec une image
4. Publier

### Minute 3: Vérification
1. Vérifier que le message apparaît
2. Vérifier que l'image s'affiche sous le message
3. Cliquer sur l'image pour l'agrandir
4. Tester les préférences email

---

## ✅ Validation Finale

Si tous ces points sont verts, le projet est 100% fonctionnel:

- ✅ Chatbot répond aux questions
- ✅ Préférences email se sauvegardent
- ✅ Upload de médias fonctionne
- ✅ Médias s'affichent sous les messages
- ✅ Images cliquables
- ✅ Pas d'erreurs dans la console

---

## 🎉 Succès !

**Tout fonctionne ?** Parfait ! Vous avez maintenant:
- 3 fonctionnalités avancées intégrées
- 13 endpoints REST backend
- Interface utilisateur complète
- Documentation exhaustive

**Prochaines étapes**:
- Tester avec différents types de fichiers
- Tester sur mobile
- Configurer SMTP pour les emails
- Ajouter plus de messages au chatbot

---

**Temps total**: 3 minutes  
**Difficulté**: Facile  
**Résultat**: Projet complet et fonctionnel ! 🚀
