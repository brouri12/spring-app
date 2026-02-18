# ⚡ QUICK START - DÉMARRAGE RAPIDE

## 🎯 EN 5 MINUTES

### 1️⃣ Démarrer MySQL
```cmd
net start MySQL80
```

### 2️⃣ Lancer tous les services
```cmd
START_ALL_SERVICES.bat
```

### 3️⃣ Attendre 90 secondes ⏱️

### 4️⃣ Vérifier Eureka
Ouvrir : **http://localhost:8761**

Vous devez voir 3 services :
- ✅ API-GATEWAY
- ✅ FORUM-SERVICE
- ✅ RECRUTEMENT-SERVICE

### 5️⃣ Tester via Gateway
```http
GET http://localhost:8080/api/forum
GET http://localhost:8080/api/recrutement/offres
```

---

## 🎨 ARCHITECTURE SIMPLIFIÉE

```
CLIENT
  ↓
GATEWAY (8080) ← Point d'entrée unique
  ↓
EUREKA (8761) ← Registre des services
  ↓
├─ Forum (8082)
└─ Recrutement (8083)
```

---

## 📍 URLS ESSENTIELLES

| Quoi ?              | URL                                      |
|---------------------|------------------------------------------|
| Eureka Dashboard    | http://localhost:8761                    |
| Gateway             | http://localhost:8080                    |
| Forum via Gateway   | http://localhost:8080/api/forum          |
| Recrutement via Gateway | http://localhost:8080/api/recrutement/offres |

---

## 🧪 TEST RAPIDE

### Créer un Forum
```http
POST http://localhost:8080/api/forum
Content-Type: application/json

{
  "titre": "Test",
  "description": "Test rapide",
  "niveau": "L1",
  "statut": "OUVERT"
}
```

### Créer une Offre
```http
POST http://localhost:8080/api/recrutement/offres
Content-Type: application/json

{
  "titre": "Test Offre",
  "description": "Test",
  "specialite": "Test",
  "experience_min": 2,
  "statut": "OUVERTE"
}
```

---

## ✅ CHECKLIST

- [ ] MySQL démarré
- [ ] Script START_ALL_SERVICES.bat lancé
- [ ] Attendre 90 secondes
- [ ] Eureka accessible (http://localhost:8761)
- [ ] 3 services visibles dans Eureka
- [ ] Test GET via Gateway réussi

---

## 🐛 PROBLÈME ?

### Services non visibles dans Eureka
→ Attendre 30 secondes de plus

### Port déjà utilisé
```cmd
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### MySQL non accessible
```cmd
net start MySQL80
```

---

## 📚 DOCUMENTATION COMPLÈTE

- **README_COMPLET.md** : Vue d'ensemble
- **GUIDE_EUREKA_GATEWAY.md** : Guide Eureka & Gateway
- **ARCHITECTURE_COMPLETE.md** : Architecture détaillée

---

## 🎉 C'EST TOUT !

Votre architecture microservices est prête ! 🚀

**Prochaine étape** : Consultez **test-gateway.http** pour 30 tests prêts à l'emploi.
