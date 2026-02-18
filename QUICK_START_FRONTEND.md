# 🚀 Quick Start - Frontend (Application Publique)

## Démarrage en 3 étapes

### 1️⃣ Démarrer les services Backend

```cmd
# MySQL
net start MySQL80

# Forum Service
cd forum-service
start mvn spring-boot:run

# Recrutement Service
cd recrutement-service
start mvn spring-boot:run
```

### 2️⃣ Démarrer le Frontend

```cmd
cd angular-app/frontend/angular-app
npm install
npm start
```

### 3️⃣ Accéder à l'application

- **Application** : http://localhost:4200
- **Forums** : http://localhost:4200/forums
- **Recrutement** : http://localhost:4200/recrutement

---

## 🎯 Fonctionnalités

### Forums (`/forums`)
- Voir les forums ouverts
- Lire les messages
- Poster un message
- Rechercher

### Recrutement (`/recrutement`)
- Voir les offres ouvertes
- Filtrer par spécialité
- Postuler à une offre

---

## 📝 Fichiers créés

```
angular-app/frontend/angular-app/src/
├── app/
│   ├── models/
│   │   ├── forum.model.ts
│   │   └── recrutement.model.ts
│   ├── services/
│   │   ├── forum.service.ts
│   │   └── recrutement.service.ts
│   └── pages/
│       ├── forums-public/
│       └── recrutement-public/
└── environments/
    ├── environment.ts
    └── environment.prod.ts
```

---

## 🐛 Problèmes courants

**Erreur CORS** → Redémarrez les services Spring Boot

**404 Not Found** → Vérifiez que les services sont démarrés

**Port 4200 occupé** → `ng serve --port 4201`

**MySQL error** → `net start MySQL80`

---

## 📚 Documentation complète

Consultez `GUIDE_INTEGRATION_FRONTEND.md` pour plus de détails.
