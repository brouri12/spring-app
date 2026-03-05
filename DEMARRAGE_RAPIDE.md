# ⚡ Démarrage Rapide - Test des Fonctionnalités

## 🚀 En 3 Minutes Chrono

### Étape 1: Démarrer les Services (1 min)

#### Terminal 1 - Backend
```bash
cd forum-service
mvn spring-boot:run
```
**Attendez**: "Started ForumApplication" sur le port 8082

#### Terminal 2 - Frontend
```bash
cd angular-app/frontend/angular-app
npm start
```
**Attendez**: "Compiled successfully" sur le port 4300

---

### Étape 2: Ouvrir le Navigateur (10 sec)
```
http://localhost:4300
```

---

### Étape 3: Tester les 3 Fonctionnalités (2 min)

#### ✅ Test 1: Chatbot (30 sec)
1. Regardez en **bas à droite** → Icône violette 🤖
2. **Cliquez** sur l'icône
3. **Tapez**: "Comment créer un forum?"
4. **Appuyez** sur Entrée
5. ✅ Vous voyez une réponse !

#### ✅ Test 2: Upload Multimédia (1 min)
1. **Allez** sur `/forums` (ou cliquez sur Forums dans le menu)
2. **Cliquez** sur un forum dans la liste de gauche
3. **Cliquez** sur "Nouveau Message"
4. **Tapez** un message
5. **Scrollez** vers le bas
6. ✅ Vous voyez "📎 Ajouter des médias" !
7. **Cliquez** sur "Choisir un fichier" pour Image
8. **Sélectionnez** une image
9. **Cliquez** sur "Publier"
10. ✅ Message et média uploadés !

#### ✅ Test 3: Préférences Email (30 sec)
1. **Regardez** le header en haut à droite
2. **Cherchez** l'icône 📧 (entre 🌙 et 🌐)
3. **Cliquez** sur l'icône
4. ✅ Vous êtes sur `/preferences` !
5. **Activez/Désactivez** des options
6. **Cliquez** sur "Enregistrer"
7. ✅ Préférences sauvegardées !

---

## 🎯 Résultat Attendu

### Vous devriez voir:
- ✅ Icône chatbot violette en bas à droite
- ✅ Section "Ajouter des médias" dans le formulaire de message
- ✅ Icône email dans le header
- ✅ Toutes les fonctionnalités répondent aux clics

### Si vous ne voyez pas:
- ❌ Vérifiez que les 2 services tournent
- ❌ Rechargez avec Ctrl+F5
- ❌ Ouvrez la console (F12) pour voir les erreurs

---

## 📊 Commandes Utiles

### Vérifier les Ports
```bash
# Windows
netstat -ano | findstr :8082
netstat -ano | findstr :4300

# Linux/Mac
lsof -i :8082
lsof -i :4300
```

### Arrêter les Services
```bash
# Dans chaque terminal
Ctrl + C
```

### Nettoyer et Redémarrer
```bash
# Backend
cd forum-service
mvn clean install
mvn spring-boot:run

# Frontend
cd angular-app/frontend/angular-app
rm -rf node_modules package-lock.json
npm install
npm start
```

---

## 🐛 Dépannage Express

### Erreur: Port 8082 déjà utilisé
```bash
# Trouver le processus
netstat -ano | findstr :8082

# Tuer le processus (Windows)
taskkill /PID <PID> /F

# Tuer le processus (Linux/Mac)
kill -9 <PID>
```

### Erreur: Port 4300 déjà utilisé
```bash
# Même chose pour 4300
netstat -ano | findstr :4300
taskkill /PID <PID> /F
```

### Erreur: Module not found
```bash
cd angular-app/frontend/angular-app
npm install
```

### Erreur: Cannot connect to backend
```bash
# Vérifier que le backend tourne
curl http://localhost:8082/api/forum/forums/statut/OUVERT
```

---

## 📝 Checklist Avant de Tester

- [ ] Java 17+ installé
- [ ] Maven installé
- [ ] Node.js 18+ installé
- [ ] npm installé
- [ ] Base de données accessible
- [ ] Ports 8082 et 4300 libres

---

## 🎬 Vidéo de Démonstration (Imaginaire)

```
00:00 - Démarrage du backend
00:30 - Démarrage du frontend
01:00 - Test du chatbot
01:30 - Test de l'upload multimédia
02:30 - Test des préférences email
03:00 - Fin !
```

---

## 📚 Documentation Complète

Pour plus de détails, consultez:
- `GUIDE_TEST_FONCTIONNALITES.md` - Guide complet de test
- `LOCALISATION_FONCTIONNALITES.md` - Où trouver chaque fonctionnalité
- `OU_CLIQUER.md` - Guide visuel étape par étape
- `RESUME_INTEGRATION.md` - Résumé technique

---

## 🎉 Félicitations !

Si vous voyez les 3 fonctionnalités, l'intégration est réussie ! 🎊

Vous pouvez maintenant:
- Utiliser le chatbot pour poser des questions
- Uploader des images, audios, documents et vidéos
- Configurer vos préférences de notification email

---

**Temps total**: 3 minutes  
**Difficulté**: Facile  
**Prérequis**: Backend + Frontend démarrés

---

**Date**: 5 mars 2026  
**Version**: 1.0
