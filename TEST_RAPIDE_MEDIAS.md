# ⚡ Test Rapide - Affichage des Médias

**Temps**: 3 minutes  
**Objectif**: Vérifier que les médias s'affichent sous les messages

---

## 🚀 Test en 3 Étapes

### Étape 1: Vérifier le Backend (30 secondes)

```bash
# Test 1: Backend tourne ?
curl http://localhost:8082/actuator/health
# Doit retourner: {"status":"UP"}

# Test 2: Endpoint médias existe ?
curl http://localhost:8082/api/forum/multimedia/message/1
# Doit retourner: [] ou [{...}]
# Si erreur 404 → Endpoint manquant
```

**Si erreur**: Démarrer le backend
```bash
cd forum-service
mvn spring-boot:run
```

---

### Étape 2: Créer un Message avec Média (1 minute)

1. Ouvrir http://localhost:4300/forums
2. Sélectionner un forum
3. Cliquer "Nouveau Message"
4. Taper: "Test affichage média"
5. Scroller en bas
6. Cliquer sur "📷 Image"
7. Sélectionner une image
8. Vérifier que "✓ nom_fichier.jpg" s'affiche
9. Cliquer "Publier"

---

### Étape 3: Vérifier l'Affichage (30 secondes)

**Résultat attendu**:
```
┌─────────────────────────────────────┐
│ E  ÉTUDIANT      05/03/2026 06:25  │
├─────────────────────────────────────┤
│ Test affichage média                │
├─────────────────────────────────────┤
│ 📎 Fichiers joints (1)              │ ← DOIT APPARAÎTRE
│ ┌──────────────┐                    │
│ │ 📷 Image     │                    │
│ │ [Preview]    │                    │
│ │ photo.jpg    │                    │
│ │ 2.5 MB       │                    │
│ └──────────────┘                    │
└─────────────────────────────────────┘
```

**Si la section "📎 Fichiers joints" n'apparaît PAS**:
→ Consultez `DEPANNAGE_MEDIAS_NON_AFFICHES.md`

---

## 🔍 Diagnostic Rapide

### Console du Navigateur (F12)

**Ouvrir la console et chercher**:

#### ✅ Bon Signe
```
GET http://localhost:8082/api/forum/multimedia/message/1 200 OK
✅ Médias reçus: [...]
```

#### ❌ Problème
```
GET http://localhost:8082/api/forum/multimedia/message/1 404 (Not Found)
```
**Solution**: Backend pas démarré ou endpoint manquant

```
GET http://localhost:8082/api/forum/multimedia/message/1 Failed to fetch
```
**Solution**: Backend arrêté

```
TypeError: Cannot read property 'get' of undefined
```
**Solution**: Erreur dans le code frontend

---

## 🎯 Checklist Rapide

**Avant de tester**:
- [ ] Backend démarré (port 8082)
- [ ] Frontend démarré (port 4300)
- [ ] Pas d'erreur dans la console

**Pendant le test**:
- [ ] Image sélectionnée (✓ visible)
- [ ] Message publié avec succès
- [ ] Pas d'erreur 500 dans la console

**Après le test**:
- [ ] Section "📎 Fichiers joints" visible
- [ ] Image affichée avec preview
- [ ] Nom et taille du fichier visibles
- [ ] Clic sur l'image fonctionne

---

## 🔧 Solutions Rapides

### Problème 1: Pas de Section "Fichiers joints"

**Cause**: Médias non chargés depuis l'API

**Solution**:
```bash
# Vérifier l'endpoint
curl http://localhost:8082/api/forum/multimedia/message/1

# Si 404, redémarrer le backend
cd forum-service
mvn spring-boot:run
```

---

### Problème 2: Erreur 404 sur l'Endpoint

**Cause**: Endpoint manquant dans `MultimediaController.java`

**Vérifier**:
```java
@GetMapping("/message/{messageId}")
public ResponseEntity<List<MediaFileDTO>> getMediaByMessage(@PathVariable Long messageId) {
    List<MediaFileDTO> media = multimediaService.getMediaByMessage(messageId);
    return ResponseEntity.ok(media);
}
```

**Si absent**: L'endpoint n'a pas été ajouté

---

### Problème 3: Upload Échoue

**Symptômes**:
- Fichier sélectionné mais pas uploadé
- Erreur 500 dans la console
- Message publié mais pas de médias

**Solution**:
```bash
# Vérifier les logs backend
tail -f forum-service/logs/application.log | grep -i error

# Vérifier que le dossier uploads existe
cd forum-service
ls -la uploads/
# Si n'existe pas:
mkdir uploads
```

---

## 📊 Résultats Attendus

### Test Réussi ✅
```
1. Backend répond: ✅
2. Endpoint médias OK: ✅
3. Upload réussi: ✅
4. Section "Fichiers joints" visible: ✅
5. Média affiché: ✅
```

### Test Échoué ❌
```
1. Backend répond: ❌ → Démarrer backend
2. Endpoint médias OK: ❌ → Vérifier MultimediaController
3. Upload réussi: ❌ → Vérifier dossier uploads
4. Section "Fichiers joints" visible: ❌ → Vérifier console
5. Média affiché: ❌ → Vérifier template HTML
```

---

## 🎬 Vidéo de Test (Scénario)

### Minute 1: Préparation
```bash
# Terminal 1
cd forum-service && mvn spring-boot:run

# Terminal 2
cd angular-app/frontend/angular-app && ng serve --port 4300
```

### Minute 2: Test Upload
1. http://localhost:4300/forums
2. Sélectionner forum
3. "Nouveau Message"
4. Ajouter image
5. "Publier"

### Minute 3: Vérification
1. Message apparaît
2. Section "📎 Fichiers joints" visible
3. Image affichée
4. Clic sur image fonctionne

---

## ✅ Validation Finale

**Tout fonctionne si**:
- ✅ Backend sur port 8082
- ✅ Frontend sur port 4300
- ✅ Endpoint `/multimedia/message/{id}` retourne 200
- ✅ Section "Fichiers joints" visible
- ✅ Médias affichés correctement
- ✅ Pas d'erreur dans la console

---

## 🆘 Si Ça Ne Marche Toujours Pas

**Consultez dans cet ordre**:
1. `DEPANNAGE_MEDIAS_NON_AFFICHES.md` - Solutions détaillées
2. `ETAT_FINAL_PROJET.md` - Vue d'ensemble
3. `RESUME_FINAL_SESSION.md` - Résumé complet

**Ou testez**:
```bash
# Tout redémarrer
# Arrêter backend et frontend (Ctrl+C)

# Nettoyer et redémarrer backend
cd forum-service
mvn clean spring-boot:run

# Redémarrer frontend
cd angular-app/frontend/angular-app
ng serve --port 4300

# Vider cache navigateur
# F12 → Console → localStorage.clear() → location.reload()
```

---

**Temps total**: 3 minutes  
**Difficulté**: Facile  
**Résultat**: Médias affichés ! 📸
