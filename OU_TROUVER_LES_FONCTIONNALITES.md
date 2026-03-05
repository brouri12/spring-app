# 📍 Où Trouver les Fonctionnalités

Guide visuel rapide pour localiser les 3 fonctionnalités principales.

---

## 1. 💬 Chatbot Widget

### Emplacement
**Coin inférieur droit de TOUTES les pages**

```
┌─────────────────────────────────────────────────┐
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                                        ┌──────┐ │
│                                        │ 💬   │ │
│                                        │ Chat │ │
│                                        └──────┘ │
└─────────────────────────────────────────────────┘
```

### Comment l'utiliser
1. Cliquez sur l'icône de chat
2. Une fenêtre s'ouvre
3. Tapez votre question
4. Appuyez sur Entrée ou cliquez "Envoyer"

### Questions à tester
- "Comment créer un forum?"
- "Comment m'inscrire?"
- "Quels sont les cours disponibles?"

---

## 2. ✉️ Préférences Email

### Emplacement
**Header → Icône Email**

```
┌─────────────────────────────────────────────────┐
│ 🏠 Accueil  📚 Cours  💬 Forums  ✉️ Email  👤  │
│                                      ↑          │
│                                   CLIQUEZ ICI   │
└─────────────────────────────────────────────────┘
```

### Navigation
1. Cliquez sur l'icône ✉️ dans le header
2. Vous êtes redirigé vers `/email-preferences`
3. Page avec formulaire de préférences

### Options disponibles
- ☑️ Recevoir des notifications par email
- ☑️ Nouveaux messages dans mes forums
- ☑️ Réponses à mes messages
- ☑️ Likes sur mes messages

---

## 3. 📎 Upload de Médias

### Emplacement
**Forums → Nouveau Message → Bas du formulaire**

```
Navigation:
/forums → Sélectionner un forum → "Nouveau Message"

┌─────────────────────────────────────────────────┐
│ Nouveau Message                                 │
├─────────────────────────────────────────────────┤
│ Type d'auteur: [Étudiant ▼]                    │
│                                                 │
│ Message:                                        │
│ ┌─────────────────────────────────────────────┐ │
│ │ Écrivez votre message ici...                │ │
│ │                                             │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ 📎 Ajouter des médias (optionnel)              │
│                                                 │
│ 📷 Image (JPG, PNG, GIF - max 5MB)             │
│ [Choisir un fichier]                           │
│                                                 │
│ 🎵 Audio (MP3, WAV - max 10MB)                 │
│ [Choisir un fichier]                           │
│                                                 │
│ 📄 Document (PDF, ZIP, DOC - max 20MB)         │
│ [Choisir un fichier]                           │
│                                                 │
│ 🎬 Vidéo YouTube (URL)                          │
│ [https://www.youtube.com/watch?v=...]          │
│                                                 │
│ [Publier]  [Annuler]                           │
└─────────────────────────────────────────────────┘
```

### Étapes détaillées
1. Allez sur `/forums`
2. Cliquez sur un forum dans la liste de gauche
3. Cliquez sur le bouton vert "Nouveau Message"
4. Remplissez le message
5. **Scrollez vers le bas**
6. Section "Ajouter des médias (optionnel)"
7. Sélectionnez vos fichiers
8. Cliquez "Publier"

### ⚠️ Important
- ✅ Section visible en mode "Nouveau Message"
- ❌ Section cachée en mode "Modifier Message"
- C'est normal et intentionnel !

---

## 4. 📸 Affichage des Médias

### Emplacement
**Sous chaque message du forum**

```
┌─────────────────────────────────────────────────┐
│ 👤 ÉTUDIANT                   📅 05/03/2026     │
├─────────────────────────────────────────────────┤
│                                                 │
│ Voici mon message avec des fichiers !          │
│                                                 │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ 📎 Fichiers joints (3)                          │
│                                                 │
│ ┌──────────────┐  ┌──────────────┐            │
│ │ 📷 Image     │  │ 🎵 Audio     │            │
│ │              │  │              │            │
│ │ [Preview]    │  │ ▶️ ━━━━━━━  │            │
│ │              │  │              │            │
│ │ photo.jpg    │  │ audio.mp3    │            │
│ │ 2.5 MB       │  │ 5.1 MB       │            │
│ └──────────────┘  └──────────────┘            │
│                                                 │
│ ┌──────────────┐                               │
│ │ 🎬 YouTube   │                               │
│ │              │                               │
│ │ [Player]     │                               │
│ │              │                               │
│ └──────────────┘                               │
│                                                 │
│ ❤️ 5  💬 3  ↩️ Répondre  🚩 Signaler            │
└─────────────────────────────────────────────────┘
```

### Comment voir
1. Créez un message avec des médias (voir section 3)
2. Le message apparaît dans la liste
3. Les médias s'affichent automatiquement sous le texte
4. Section "📎 Fichiers joints (X)"

### Types d'affichage
- **Images**: Miniature cliquable
- **Audio**: Lecteur HTML5 avec contrôles
- **Documents**: Bouton de téléchargement
- **Vidéos**: Lecteur YouTube intégré

---

## 🎯 Checklist Rapide

Pour vérifier que tout fonctionne:

### ✅ Chatbot
- [ ] Icône visible en bas à droite
- [ ] Clic ouvre la fenêtre de chat
- [ ] Peut envoyer des messages
- [ ] Reçoit des réponses

### ✅ Préférences Email
- [ ] Icône email visible dans le header
- [ ] Clic redirige vers `/email-preferences`
- [ ] Formulaire avec cases à cocher
- [ ] Bouton "Enregistrer" fonctionne

### ✅ Upload de Médias
- [ ] Bouton "Nouveau Message" visible
- [ ] Formulaire s'ouvre
- [ ] Section médias visible en bas
- [ ] Peut sélectionner des fichiers
- [ ] Bouton "Publier" fonctionne

### ✅ Affichage des Médias
- [ ] Médias visibles sous les messages
- [ ] Section "Fichiers joints (X)" affichée
- [ ] Images prévisualisées
- [ ] Audio jouable
- [ ] Documents téléchargeables
- [ ] Vidéos YouTube intégrées

---

## 🔍 Dépannage Visuel

### Problème: Je ne vois pas le chatbot
**Regardez ici**:
```
                                        ┌──────┐
                                        │ 💬   │ ← ICI
                                        └──────┘
```
Si absent: Vérifiez que `ChatbotWidgetComponent` est importé dans `app.ts`

### Problème: Je ne vois pas l'icône email
**Regardez ici**:
```
🏠 Accueil  📚 Cours  💬 Forums  ✉️ ← ICI  👤
```
Si absent: Vérifiez `header.html`

### Problème: Je ne vois pas la section médias
**Vérifiez**:
1. Êtes-vous en mode "Nouveau Message" ? (pas "Modifier")
2. Avez-vous scrollé jusqu'en bas du formulaire ?
3. La section est après le champ "Message"

### Problème: Les médias ne s'affichent pas sous les messages
**Vérifiez**:
1. Le backend tourne sur le port 8082 ?
2. Le message a des médias uploadés ?
3. La console montre des erreurs ?

---

## 📱 Responsive

### Desktop
- Chatbot: Coin inférieur droit
- Médias: Grille 2 colonnes

### Mobile
- Chatbot: Coin inférieur droit (plus petit)
- Médias: Grille 1 colonne

---

## 🎨 Couleurs pour Repérer

### Chatbot
- Bouton: Vert `rgb(0,200,151)`
- Icône: Blanc sur fond vert

### Préférences Email
- Icône: Gris dans le header
- Bouton Enregistrer: Vert

### Upload Médias
- Titre section: Vert `rgb(0,200,151)`
- Boutons fichier: Vert

### Affichage Médias
- Bordure: Gris clair
- Hover: Vert `rgb(0,200,151)`
- Icônes: Couleurs variées (bleu, violet, rouge)

---

**Tout est là, il suffit de regarder au bon endroit ! 👀**
