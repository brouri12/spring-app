# 🚀 Quick Start - Intégration Angular + Spring Boot

## Démarrage rapide en 3 étapes

### 1️⃣ Démarrer les services Backend (Spring Boot)

```cmd
# MySQL
net start MySQL80

# Eureka Server
cd eureka-server
start mvn spring-boot:run

# Forum Service
cd forum-service
start mvn spring-boot:run

# Recrutement Service
cd recrutement-service
start mvn spring-boot:run
```

### 2️⃣ Démarrer le Frontend (Angular)

```cmd
cd angular-app/back-office
npm install
npm start
```

### 3️⃣ Accéder à l'application

- **Application Angular** : http://localhost:4200
- **Forum** : http://localhost:4200/forum
- **Recrutement** : http://localhost:4200/recrutement

---

## 🎯 Fonctionnalités disponibles

### Page Forum
- Créer, lister, supprimer des forums
- Ajouter des messages
- Fermer un forum

### Page Recrutement
- Créer, lister, supprimer des offres
- Postuler à une offre
- Accepter/Refuser des candidatures

---

## 📝 Fichiers créés

```
angular-app/back-office/src/
├── app/
│   ├── models/
│   │   ├── forum.model.ts
│   │   └── recrutement.model.ts
│   ├── services/
│   │   ├── forum.service.ts
│   │   └── recrutement.service.ts
│   └── pages/
│       ├── forum/
│       │   ├── forum.ts
│       │   ├── forum.html
│       │   └── forum.css
│       └── recrutement/
│           ├── recrutement.ts
│           ├── recrutement.html
│           └── recrutement.css
└── environments/
    ├── environment.ts
    └── environment.prod.ts
```

---

## ⚡ Commandes utiles

```cmd
# Vérifier que MySQL fonctionne
sc query MySQL80

# Vérifier Eureka
curl http://localhost:8761

# Tester Forum API
curl http://localhost:8082/api/forum/forums

# Tester Recrutement API
curl http://localhost:8083/api/recrutement/offres

# Build Angular pour production
cd angular-app/back-office
npm run build
```

---

## 🐛 Problèmes courants

**Angular ne démarre pas** → `npm install` puis `npm start`

**Erreur CORS** → Vérifiez que les services Spring Boot sont démarrés

**404 Not Found** → Vérifiez les URLs dans `environment.ts`

**MySQL error** → `net start MySQL80`

---

Pour plus de détails, consultez `GUIDE_INTEGRATION_ANGULAR_SPRING.md`
