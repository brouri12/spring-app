# ✅ Test de la Navbar - Frontend

## 📋 Configuration actuelle

La navbar est déjà configurée avec Forum et Recrutement !

### Liens dans la navbar

```typescript
navLinks = [
  { name: 'Courses', path: '/courses' },
  { name: 'Forums', path: '/forums' },        ✅
  { name: 'Recrutement', path: '/recrutement' }, ✅
  { name: 'Pricing', path: '/pricing' },
  { name: 'About', path: '/about' },
];
```

### Couleurs configurées

- **Couleur normale** : Gris (texte par défaut)
- **Couleur hover** : `rgb(0,200,151)` (vert)
- **Couleur active** : `rgb(0,200,151)` (vert)
- **Transition** : 200ms smooth

---

## 🚀 Pour tester

### 1. Démarrer les services Backend

```cmd
# MySQL
net start MySQL80

# Forum Service
cd forum-service
mvn spring-boot:run

# Recrutement Service
cd recrutement-service
mvn spring-boot:run
```

### 2. Démarrer le Frontend

```cmd
cd angular-app/frontend/angular-app
npm start
```

### 3. Ouvrir l'application

Ouvrez votre navigateur : `http://localhost:4200`

---

## ✅ Tests à effectuer

### Desktop (écran large)

1. **Vérifier que les liens sont visibles**
   - [ ] Courses
   - [ ] Forums ← NOUVEAU
   - [ ] Recrutement ← NOUVEAU
   - [ ] Pricing
   - [ ] About

2. **Tester le hover**
   - Passez la souris sur chaque lien
   - La couleur doit changer en vert `rgb(0,200,151)`

3. **Tester la navigation**
   - Cliquez sur **Forums**
   - Vous devez être redirigé vers `/forums`
   - Le lien doit être en vert (actif)
   
   - Cliquez sur **Recrutement**
   - Vous devez être redirigé vers `/recrutement`
   - Le lien doit être en vert (actif)

### Mobile (écran petit)

1. **Ouvrir le menu hamburger**
   - Cliquez sur l'icône ☰ en haut à droite

2. **Vérifier les liens dans le menu**
   - [ ] Courses
   - [ ] Forums ← NOUVEAU
   - [ ] Recrutement ← NOUVEAU
   - [ ] Pricing
   - [ ] About

3. **Tester la navigation**
   - Cliquez sur **Forums**
   - Le menu doit se fermer automatiquement
   - Vous devez être sur la page Forums

---

## 🎨 Apparence attendue

### Desktop
```
┌─────────────────────────────────────────────────────────────┐
│ Wordly | Courses | Forums | Recrutement | Pricing | About   │
└─────────────────────────────────────────────────────────────┘
```

### Mobile
```
┌──────────────────┐
│ Wordly        ☰  │
├──────────────────┤
│ Courses          │
│ Forums           │ ← NOUVEAU
│ Recrutement      │ ← NOUVEAU
│ Pricing          │
│ About            │
└──────────────────┘
```

---

## 🐛 Si ça ne fonctionne pas

### Problème 1 : Les liens ne sont pas visibles

**Solution** :
```cmd
# Arrêtez l'application (Ctrl+C)
# Redémarrez
cd angular-app/frontend/angular-app
npm start
```

### Problème 2 : Erreur 404 sur /forums ou /recrutement

**Vérifiez** :
1. Les services backend sont démarrés
2. MySQL est démarré
3. Pas d'erreur dans la console du navigateur (F12)

**Solution** :
```cmd
# Vérifier que les services sont accessibles
curl http://localhost:8082/api/forum/forums
curl http://localhost:8083/api/recrutement/offres
```

### Problème 3 : Erreur CORS

**Solution** :
```cmd
# Redémarrer les services backend
cd forum-service
mvn clean install
mvn spring-boot:run

cd recrutement-service
mvn clean install
mvn spring-boot:run
```

### Problème 4 : Les couleurs ne s'appliquent pas

**Vérifiez** :
1. Tailwind CSS est bien configuré
2. Le fichier `tailwind.config.js` existe
3. Pas d'erreur de compilation

**Solution** :
```cmd
# Vider le cache et redémarrer
cd angular-app/frontend/angular-app
rm -rf .angular
npm start
```

---

## 📸 Captures d'écran attendues

### 1. Navbar Desktop
- Tous les liens alignés horizontalement
- Forums et Recrutement entre Courses et Pricing
- Couleur verte au hover

### 2. Page Forums
- Liste des forums à gauche
- Messages à droite
- Formulaire pour poster un message

### 3. Page Recrutement
- Liste des offres à gauche
- Détails de l'offre à droite
- Formulaire de candidature

---

## ✅ Checklist finale

- [ ] Navbar visible sur desktop
- [ ] Navbar visible sur mobile (menu hamburger)
- [ ] Lien Forums présent
- [ ] Lien Recrutement présent
- [ ] Couleur verte au hover
- [ ] Couleur verte quand actif
- [ ] Navigation vers /forums fonctionne
- [ ] Navigation vers /recrutement fonctionne
- [ ] Page Forums s'affiche correctement
- [ ] Page Recrutement s'affiche correctement
- [ ] Pas d'erreur dans la console

---

## 🎉 Résultat attendu

Après ces tests, vous devriez avoir :
- ✅ Navbar avec Forums et Recrutement
- ✅ Couleurs vertes cohérentes
- ✅ Navigation fonctionnelle
- ✅ Pages qui s'affichent correctement
- ✅ Aucune erreur

---

## 📞 Commandes utiles

```cmd
# Vérifier que l'app Angular tourne
netstat -ano | findstr :4200

# Vérifier les services backend
curl http://localhost:8082/api/forum/forums
curl http://localhost:8083/api/recrutement/offres

# Voir les logs en temps réel
# Dans le terminal où tourne npm start

# Ouvrir la console du navigateur
# Appuyez sur F12
```

---

Tout est déjà configuré ! Il suffit de démarrer l'application et tester. 🚀
