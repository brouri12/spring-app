# ✅ Vérification Rapide - 2 Minutes

## 🎯 Checklist Ultra-Rapide

Cochez chaque élément pour vérifier que tout fonctionne.

---

## 1️⃣ Services (30 sec)

### Backend
```bash
curl http://localhost:8082/api/forum/forums/statut/OUVERT
```
- [ ] ✅ Répond avec une liste de forums
- [ ] ❌ Erreur → Démarrer le backend

### Frontend
```
http://localhost:4300
```
- [ ] ✅ Page s'affiche
- [ ] ❌ Erreur → Démarrer le frontend

---

## 2️⃣ Chatbot (20 sec)

- [ ] ✅ Icône violette visible en bas à droite
- [ ] ✅ Clic ouvre la fenêtre de chat
- [ ] ✅ Peut taper un message
- [ ] ❌ Invisible → Rechargez (Ctrl+F5)

---

## 3️⃣ Upload Multimédia (30 sec)

1. Allez sur `/forums`
2. Sélectionnez un forum
3. Cliquez "Nouveau Message"
4. Scrollez vers le bas

- [ ] ✅ Section "📎 Ajouter des médias" visible
- [ ] ✅ 4 champs d'upload présents
- [ ] ❌ Invisible → Vérifiez que vous êtes en mode "Nouveau Message"

---

## 4️⃣ Préférences Email (20 sec)

1. Regardez le header en haut à droite
2. Cherchez l'icône 📧 (entre 🌙 et 🌐)

- [ ] ✅ Icône 📧 visible
- [ ] ✅ Clic ouvre `/preferences`
- [ ] ❌ Invisible → Zoomez/dézoomez

---

## 5️⃣ Affichage Médias (20 sec)

1. Créez un message avec un média
2. Regardez sous le texte du message

- [ ] ✅ Section "📎 Fichiers joints" visible
- [ ] ✅ Média affiché correctement
- [ ] ❌ Invisible → Vérifiez que le backend tourne

---

## 📊 Résultat

### ✅ Tout Fonctionne (5/5)
**Félicitations !** Toutes les fonctionnalités sont opérationnelles.

**Prochaine étape** : Consultez `GUIDE_COMPLET_FINAL.md` pour les tests détaillés.

---

### ⚠️ Problèmes Partiels (3-4/5)
**Quelques ajustements nécessaires.**

**Action** : Consultez la section "Dépannage" dans `GUIDE_COMPLET_FINAL.md`.

---

### ❌ Problèmes Majeurs (0-2/5)
**Plusieurs éléments ne fonctionnent pas.**

**Actions** :
1. Vérifiez que les services tournent
2. Rechargez avec Ctrl+F5
3. Consultez `DEMARRAGE_RAPIDE.md`

---

## 🐛 Dépannage Express

### Chatbot Invisible
```bash
# Rechargez la page
Ctrl + F5
```

### Section Média Invisible
```
Assurez-vous d'être en mode "Nouveau Message"
(PAS en mode "Édition")
```

### Backend Ne Répond Pas
```bash
cd forum-service
mvn spring-boot:run
```

### Frontend Ne Répond Pas
```bash
cd angular-app/frontend/angular-app
npm start
```

---

## 📞 Support

### Problème Persistant
→ `GUIDE_COMPLET_FINAL.md` → Section "Dépannage"

### Documentation Complète
→ `INDEX_DOCUMENTATION.md`

### Test Détaillé
→ `GUIDE_TEST_FONCTIONNALITES.md`

---

**Temps total** : 2 minutes  
**Date** : 5 mars 2026  
**Version** : 1.0
