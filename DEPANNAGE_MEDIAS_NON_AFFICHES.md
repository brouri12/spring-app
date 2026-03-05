# 🔧 Dépannage - Médias Non Affichés

**Date**: 5 mars 2026  
**Problème**: Les médias uploadés ne s'affichent pas sous les messages

---

## ❌ Symptôme

Vous voyez le message mais pas la section "📎 Fichiers joints" en dessous:

```
┌─────────────────────────────────────┐
│ E  ÉTUDIANT      05/03/2026 06:25  │
├─────────────────────────────────────┤
│ test ttest                          │
│                                     │
│ ❤️ 0  💬 0  ↩️ Répondre  🚩 Signaler │
└─────────────────────────────────────┘
```

**Attendu**:
```
┌─────────────────────────────────────┐
│ E  ÉTUDIANT      05/03/2026 06:25  │
├─────────────────────────────────────┤
│ test ttest                          │
├─────────────────────────────────────┤
│ 📎 Fichiers joints (2)              │
│ ┌──────────┐  ┌──────────┐         │
│ │ 📷 Image │  │ 🎵 Audio │         │
│ └──────────┘  └──────────┘         │
│                                     │
│ ❤️ 0  💬 0  ↩️ Répondre  🚩 Signaler │
└─────────────────────────────────────┘
```

---

## 🔍 Causes Possibles

### 1. Backend Pas Démarré
Le frontend ne peut pas charger les médias si le backend ne répond pas.

### 2. Médias Non Uploadés
Le message a été créé mais les médias n'ont pas été uploadés avec succès.

### 3. Endpoint Manquant
L'endpoint `/api/forum/multimedia/message/{id}` ne répond pas.

### 4. Erreur JavaScript
Une erreur dans le code empêche l'affichage.

---

## ✅ Solutions

### Solution 1: Vérifier le Backend

**Test rapide**:
```bash
# Vérifier que le backend tourne
curl http://localhost:8082/actuator/health
```

**Résultat attendu**:
```json
{"status":"UP"}
```

**Si erreur**: Démarrer le backend
```bash
cd forum-service
mvn spring-boot:run
```

---

### Solution 2: Vérifier l'Endpoint Médias

**Test avec un ID de message**:
```bash
# Remplacez 1 par l'ID de votre message
curl http://localhost:8082/api/forum/multimedia/message/1
```

**Résultat attendu**:
```json
[]  // Tableau vide si pas de médias
// OU
[
  {
    "id": 1,
    "messageId": 1,
    "mediaType": "IMAGE",
    "fileUrl": "/api/forum/multimedia/file/1",
    "originalFilename": "photo.jpg",
    "fileSize": 2500000
  }
]
```

**Si erreur 404**: L'endpoint n'existe pas
- Vérifiez que `MultimediaController.java` a la méthode `getMediaByMessage`
- Redémarrez le backend

---

### Solution 3: Vérifier la Console du Navigateur

**Étapes**:
1. Ouvrir http://localhost:4300/forums
2. Appuyer sur F12
3. Aller dans l'onglet "Console"
4. Chercher les erreurs rouges

**Erreurs communes**:

#### Erreur: "Failed to load resource: 404"
```
GET http://localhost:8082/api/forum/multimedia/message/1 404 (Not Found)
```

**Cause**: Endpoint manquant ou backend arrêté

**Solution**:
```bash
# Vérifier le backend
curl http://localhost:8082/api/forum/multimedia/message/1

# Si 404, vérifier MultimediaController.java
# Doit avoir:
@GetMapping("/message/{messageId}")
public ResponseEntity<List<MediaFileDTO>> getMediaByMessage(@PathVariable Long messageId)
```

#### Erreur: "Cannot read property 'get' of undefined"
```
TypeError: Cannot read property 'get' of undefined
```

**Cause**: `messageMedia` Map non initialisée

**Solution**: Vérifier dans `forums-public.ts`:
```typescript
messageMedia: Map<number, MediaFileDTO[]> = new Map();
```

---

### Solution 4: Vérifier que les Médias Ont Été Uploadés

**Étapes**:
1. Créer un nouveau message
2. Ajouter une image
3. Vérifier que le nom du fichier s'affiche (✓ photo.jpg)
4. Cliquer "Publier"
5. Ouvrir la console (F12)
6. Chercher les requêtes POST vers `/multimedia/upload/`

**Résultat attendu dans la console**:
```
POST http://localhost:8082/api/forum/multimedia/upload/image 200 OK
```

**Si erreur 500**: Problème d'upload
- Vérifier les logs backend
- Vérifier que le dossier `uploads/` existe
- Vérifier les permissions

---

### Solution 5: Forcer le Rechargement des Médias

**Test manuel dans la console**:
```javascript
// Ouvrir la console (F12)
// Taper:
localStorage.clear()
location.reload()
```

---

## 🧪 Test Complet Étape par Étape

### Étape 1: Vérifier le Backend (30 secondes)
```bash
# Terminal 1
cd forum-service
mvn spring-boot:run

# Attendre "Started ForumServiceApplication"
```

### Étape 2: Vérifier le Frontend (30 secondes)
```bash
# Terminal 2
cd angular-app/frontend/angular-app
ng serve --port 4300

# Attendre "Compiled successfully"
```

### Étape 3: Tester l'Endpoint (10 secondes)
```bash
# Terminal 3
curl http://localhost:8082/api/forum/multimedia/message/1
```

**Si retourne `[]`**: OK, pas de médias pour ce message  
**Si retourne JSON avec données**: OK, médias existent  
**Si erreur 404**: Endpoint manquant

### Étape 4: Créer un Message avec Média (2 minutes)
1. Ouvrir http://localhost:4300/forums
2. Sélectionner un forum
3. Cliquer "Nouveau Message"
4. Remplir le message: "Test avec image"
5. Scroller en bas
6. Section "Ajouter des médias"
7. Sélectionner une image
8. Vérifier que "✓ nom_fichier.jpg" s'affiche
9. Cliquer "Publier"

### Étape 5: Vérifier l'Affichage (10 secondes)
1. Le message apparaît dans la liste
2. Sous le texte, chercher "📎 Fichiers joints (1)"
3. L'image doit s'afficher

**Si pas de section "Fichiers joints"**:
- Ouvrir la console (F12)
- Chercher les erreurs
- Vérifier les requêtes réseau (onglet Network)

---

## 🔧 Vérifications Techniques

### 1. Vérifier le Code Frontend

**Fichier**: `angular-app/frontend/angular-app/src/app/pages/forums-public/forums-public.ts`

**Méthode `loadMessages` doit contenir**:
```typescript
loadMessages(forumId: number) {
  this.forumService.getMessagesByForum(forumId).subscribe({
    next: (data) => {
      this.messages = data.filter(m => m.statut === 'ACTIF');
      // IMPORTANT: Charger les médias pour chaque message
      this.messages.forEach(message => {
        if (message.id) {
          this.loadMessageStats(message.id);
          this.loadMessageMedia(message.id);  // ← Doit être présent
        }
      });
      this.cdr.detectChanges();
    },
    error: (err: any) => {
      this.notificationService.error(err.customMessage || 'Erreur');
    }
  });
}
```

**Méthode `loadMessageMedia` doit être**:
```typescript
loadMessageMedia(messageId: number) {
  this.multimediaService.getMediaByMessage(messageId).subscribe({
    next: (media) => {
      this.messageMedia.set(messageId, media);
      this.cdr.detectChanges();
    },
    error: (err) => console.error('Erreur chargement médias:', err)
  });
}
```

**Si commenté ou absent**: Décommenter ou ajouter

---

### 2. Vérifier le Template HTML

**Fichier**: `angular-app/frontend/angular-app/src/app/pages/forums-public/forums-public.html`

**Chercher cette section** (après le contenu du message):
```html
<!-- Médias Attachés -->
@if (messageMedia.get(message.id!) && messageMedia.get(message.id!)!.length > 0) {
  <div class="mb-4 space-y-3">
    <h4 class="text-sm font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"></path>
      </svg>
      Fichiers joints ({{ messageMedia.get(message.id!)!.length }})
    </h4>
    <!-- Grille de médias -->
  </div>
}
```

**Si absent**: La section n'a pas été ajoutée

---

### 3. Vérifier le Service Multimédia

**Fichier**: `angular-app/frontend/angular-app/src/app/services/multimedia.service.ts`

**Doit contenir**:
```typescript
getMediaByMessage(messageId: number): Observable<MediaFileDTO[]> {
  return this.http.get<MediaFileDTO[]>(`${this.apiUrl}/message/${messageId}`);
}
```

**Si absent**: Ajouter la méthode

---

## 📊 Diagnostic Rapide

### Checklist de Vérification

**Backend**:
- [ ] Backend démarré (port 8082)
- [ ] Endpoint `/multimedia/message/{id}` existe
- [ ] Endpoint retourne 200 (pas 404)
- [ ] Dossier `uploads/` existe

**Frontend**:
- [ ] Frontend démarré (port 4300)
- [ ] Méthode `loadMessageMedia()` appelée
- [ ] Méthode `getMediaByMessage()` existe dans le service
- [ ] Section HTML médias présente dans le template
- [ ] Pas d'erreur dans la console

**Upload**:
- [ ] Fichier sélectionné (✓ nom visible)
- [ ] Upload réussi (200 OK)
- [ ] Médias sauvegardés en base de données

---

## 🎯 Solution Rapide (5 minutes)

### Si Rien Ne S'Affiche

**1. Redémarrer tout**:
```bash
# Arrêter backend et frontend (Ctrl+C)

# Redémarrer backend
cd forum-service
mvn clean spring-boot:run

# Redémarrer frontend (autre terminal)
cd angular-app/frontend/angular-app
ng serve --port 4300
```

**2. Vider le cache**:
```javascript
// Console du navigateur (F12)
localStorage.clear()
location.reload()
```

**3. Créer un nouveau message avec média**:
- Nouveau message
- Ajouter une image
- Publier
- Vérifier l'affichage

**4. Vérifier la console**:
- F12 → Console
- Chercher les erreurs rouges
- Chercher les requêtes vers `/multimedia/`

---

## 📝 Logs à Vérifier

### Backend
```bash
tail -f forum-service/logs/application.log | grep -i "multimedia\|media"
```

**Chercher**:
```
GET /api/forum/multimedia/message/1
Returning X media files for message 1
```

### Frontend (Console)
**Chercher**:
```
🔍 Chargement des médias pour message: 1
✅ Médias reçus: [...]
```

---

## ✅ Validation

**Tout fonctionne si**:
- ✅ Backend répond sur port 8082
- ✅ Endpoint `/multimedia/message/{id}` retourne 200
- ✅ Section "Fichiers joints" visible sous le message
- ✅ Médias affichés (image, audio, document, vidéo)
- ✅ Pas d'erreur dans la console

---

## 🆘 Besoin d'Aide ?

### Problème Persiste ?

**Envoyez-moi**:
1. Capture d'écran de la console (F12)
2. Résultat de: `curl http://localhost:8082/api/forum/multimedia/message/1`
3. Logs backend (dernières 50 lignes)

**Ou consultez**:
- `ETAT_FINAL_PROJET.md` - Vue d'ensemble
- `GUIDE_TEST_EMAIL.md` - Tests similaires
- `RESUME_FINAL_SESSION.md` - Résumé complet

---

**Les médias devraient maintenant s'afficher ! 📸**
