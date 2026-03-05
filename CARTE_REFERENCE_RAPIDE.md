# 🎴 Carte de Référence Rapide

Guide ultra-condensé pour retrouver rapidement l'information.

---

## 🚀 Démarrage Express

```bash
# Backend
cd forum-service && mvn spring-boot:run

# Frontend
cd angular-app/frontend/angular-app && ng serve --port 4300
```

**URLs**:
- Backend: http://localhost:8082
- Frontend: http://localhost:4300

---

## 📍 Localisation des Fonctionnalités

| Fonctionnalité | Emplacement | Action |
|----------------|-------------|--------|
| 💬 Chatbot | Coin inférieur droit | Cliquer sur l'icône |
| ✉️ Email | Header → Icône email | Cliquer pour ouvrir |
| 📎 Upload | Forums → Nouveau Message | Scroller en bas |
| 📸 Affichage | Sous chaque message | Automatique |

---

## 🔗 Endpoints Backend

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/multimedia/upload/image` | Upload image |
| POST | `/multimedia/upload/audio` | Upload audio |
| POST | `/multimedia/upload/document` | Upload document |
| POST | `/multimedia/embed/video` | Embed YouTube |
| GET | `/multimedia/file/{id}` | Télécharger fichier |
| GET | `/multimedia/message/{id}` | Médias d'un message ⭐ |
| GET | `/multimedia/gallery/{forumId}` | Galerie forum |
| POST | `/email/preferences` | Sauver préférences |
| GET | `/email/preferences/{userId}` | Lire préférences |

---

## 📁 Fichiers Clés

### Backend
```
forum-service/src/main/java/tn/esprit/forum/
├── entity/
│   ├── MediaFile.java
│   ├── EmailPreference.java
│   └── EmailLog.java
├── repository/
│   ├── MediaFileRepository.java
│   ├── EmailPreferenceRepository.java
│   └── EmailLogRepository.java
├── service/
│   ├── FileStorageService.java
│   ├── MultimediaService.java ⭐
│   └── EmailService.java
└── controller/
    ├── MultimediaController.java ⭐
    └── EmailController.java
```

### Frontend
```
angular-app/frontend/angular-app/src/app/
├── services/
│   ├── multimedia.service.ts ⭐
│   ├── email-preference.service.ts
│   └── chatbot.service.ts
├── components/
│   ├── chatbot-widget/
│   └── email-preferences/
└── pages/
    └── forums-public/
        ├── forums-public.ts ⭐
        └── forums-public.html
```

⭐ = Modifié dans cette session

---

## 🎨 Types de Médias

| Type | Formats | Taille Max | Affichage |
|------|---------|------------|-----------|
| 📷 Image | JPG, PNG, GIF, WebP | 5 MB | Miniature cliquable |
| 🎵 Audio | MP3, WAV, OGG | 10 MB | Lecteur HTML5 |
| 📄 Document | PDF, ZIP, DOC, XLS | 20 MB | Bouton télécharger |
| 🎬 Vidéo | YouTube, Vimeo | - | Player intégré |

---

## 🐛 Dépannage Express

| Problème | Solution |
|----------|----------|
| Médias non affichés | Backend démarré ? Port 8082 ? |
| Erreur 404 | Endpoint manquant ou backend arrêté |
| Section upload absente | Mode "Nouveau" (pas "Modifier") |
| CORS error | Vérifier `@CrossOrigin` dans controllers |
| Chatbot ne répond pas | Vérifier console (F12) |

---

## 📚 Documentation

| Document | Contenu | Temps |
|----------|---------|-------|
| `START_HERE.md` | Point d'entrée | 1 min |
| `TEST_COMPLET_3MIN.md` | Test rapide | 3 min |
| `OU_TROUVER_LES_FONCTIONNALITES.md` | Guide visuel | 2 min |
| `ETAT_FINAL_PROJET.md` | État complet | 5 min |
| `RESUME_SESSION_ACTUELLE.md` | Changements récents | 2 min |

---

## ✅ Checklist Rapide

### Avant de Tester
- [ ] Backend démarré (8082)
- [ ] Frontend démarré (4300)
- [ ] Navigateur ouvert

### Test Chatbot
- [ ] Icône visible
- [ ] Fenêtre s'ouvre
- [ ] Réponse reçue

### Test Upload
- [ ] Section visible
- [ ] Fichier sélectionné
- [ ] Upload réussi

### Test Affichage
- [ ] Médias sous message
- [ ] Section "Fichiers joints"
- [ ] Preview fonctionne

---

## 🎯 Commandes Utiles

```bash
# Tester endpoint backend
curl http://localhost:8082/api/forum/multimedia/message/1

# Voir les logs backend
tail -f forum-service/logs/application.log

# Rebuild frontend
cd angular-app/frontend/angular-app && ng build

# Nettoyer cache Angular
rm -rf .angular/cache
```

---

## 📊 Statistiques Projet

| Catégorie | Nombre |
|-----------|--------|
| Endpoints REST | 13 |
| Entités | 3 |
| Services Backend | 3 |
| Services Frontend | 3 |
| Composants | 2 |
| Documents | 28 |

---

## 🔑 Points Clés

1. **Upload**: Uniquement en mode "Nouveau Message"
2. **Affichage**: Automatique après upload
3. **Backend**: Requis pour médias et email
4. **Chatbot**: Fonctionne sans backend
5. **Ports**: 8082 (backend), 4300 (frontend)

---

## 🆘 Support Rapide

### Console Erreurs
```javascript
// Vérifier les erreurs
F12 → Console → Filtrer "error"
```

### Backend Logs
```bash
# Voir les erreurs backend
grep ERROR forum-service/logs/application.log
```

### Test API
```bash
# Tester si backend répond
curl http://localhost:8082/actuator/health
```

---

## 🎉 Validation Finale

**Tout fonctionne si**:
- ✅ Chatbot répond
- ✅ Upload réussit
- ✅ Médias s'affichent
- ✅ Pas d'erreurs console

---

**Imprimez cette carte pour référence rapide ! 📄**
