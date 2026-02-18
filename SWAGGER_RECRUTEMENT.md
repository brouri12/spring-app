# 📘 SWAGGER - RECRUTEMENT SERVICE

## 🔗 LIENS SWAGGER

### Interface Swagger UI (Principale)
```
http://localhost:8083/swagger-ui/index.html
```

### Alternative
```
http://localhost:8083/swagger-ui.html
```

### Documentation OpenAPI (JSON)
```
http://localhost:8083/v3/api-docs
```

---

## 🚀 DÉMARRAGE

### 1. Arrêter le service (si déjà lancé)
```
Ctrl + C
```

### 2. Recompiler avec Swagger
```cmd
cd recrutement-service
mvnw clean install
```

### 3. Démarrer le service
```cmd
mvnw spring-boot:run
```

### 4. Ouvrir Swagger UI
```
http://localhost:8083/swagger-ui/index.html
```

---

## 🎨 INTERFACE SWAGGER

Vous verrez :

```
┌─────────────────────────────────────────────────────────┐
│         Recrutement Service API - v1.0.0                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Servers:                                               │
│  • http://localhost:8083 (Local)                        │
│  • http://localhost:8080 (via Gateway)                  │
│                                                         │
│  recrutement-rest-api                                   │
│  ├─ GET    /api/recrutement/offres                      │
│  ├─ POST   /api/recrutement/offres                      │
│  ├─ GET    /api/recrutement/offres/{id}                 │
│  ├─ PUT    /api/recrutement/offres/{id}                 │
│  ├─ DELETE /api/recrutement/offres/{id}                 │
│  ├─ PATCH  /api/recrutement/offres/{id}/fermer          │
│  ├─ GET    /api/recrutement/offres/statut/{statut}      │
│  ├─ GET    /api/recrutement/offres/specialite/{spec}    │
│  ├─ GET    /api/recrutement/candidatures                │
│  ├─ POST   /api/recrutement/candidatures                │
│  ├─ PATCH  /api/recrutement/candidatures/{id}/statut    │
│  ├─ GET    /api/recrutement/candidatures/offre/{id}     │
│  ├─ GET    /api/recrutement/candidatures/statut/{s}     │
│  ├─ GET    /api/recrutement/candidatures/specialite/{s} │
│  └─ POST   /api/recrutement/candidatures/{id}/convertir │
│                                                         │
│  Schemas:                                               │
│  • OffreRecrutement                                     │
│  • CandidatureEnseignant                                │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 TESTS RAPIDES

### 1️⃣ GET - Toutes les offres
1. Cliquer sur **GET /api/recrutement/offres**
2. Cliquer sur **Try it out**
3. Cliquer sur **Execute**

**Résultat** : Liste de 2 offres

---

### 2️⃣ POST - Créer une offre
1. Cliquer sur **POST /api/recrutement/offres**
2. Cliquer sur **Try it out**
3. Modifier le JSON :

```json
{
  "titre": "Enseignant Data Science",
  "description": "Recherche enseignant spécialisé en Data Science et Machine Learning",
  "specialite": "Data Science",
  "experience_min": 3,
  "statut": "OUVERTE"
}
```

4. Cliquer sur **Execute**

**Résultat** : Offre créée avec un ID

---

### 3️⃣ GET - Toutes les candidatures
1. Cliquer sur **GET /api/recrutement/candidatures**
2. Cliquer sur **Try it out**
3. Cliquer sur **Execute**

**Résultat** : Liste de 2 candidatures

---

### 4️⃣ POST - Postuler à une offre
1. Cliquer sur **POST /api/recrutement/candidatures**
2. Cliquer sur **Try it out**
3. Remplir **offreId** : `1`
4. Modifier le JSON :

```json
{
  "nom_candidat": "Dupont",
  "prenom_candidat": "Marie",
  "email": "marie.dupont@example.com",
  "cv_url": "https://example.com/cv/marie.pdf",
  "lettre_motivation": "Je suis très intéressée par ce poste..."
}
```

5. Cliquer sur **Execute**

**Résultat** : Candidature créée

---

### 5️⃣ PATCH - Accepter une candidature
1. Cliquer sur **PATCH /api/recrutement/candidatures/{id}/statut**
2. Cliquer sur **Try it out**
3. Remplir **id** : `1`
4. Remplir **statut** : `ACCEPTEE`
5. Cliquer sur **Execute**

**Résultat** : Candidature acceptée + Offre marquée comme POURVUE

---

### 6️⃣ GET - Offres par statut
1. Cliquer sur **GET /api/recrutement/offres/statut/{statut}**
2. Cliquer sur **Try it out**
3. Remplir **statut** : `OUVERTE`
4. Cliquer sur **Execute**

**Résultat** : Offres ouvertes

---

### 7️⃣ GET - Candidatures par offre
1. Cliquer sur **GET /api/recrutement/candidatures/offre/{id}**
2. Cliquer sur **Try it out**
3. Remplir **id** : `1`
4. Cliquer sur **Execute**

**Résultat** : Candidatures pour l'offre 1

---

### 8️⃣ POST - Convertir en enseignant
1. Cliquer sur **POST /api/recrutement/candidatures/{id}/convertir**
2. Cliquer sur **Try it out**
3. Remplir **id** : `1`
4. Cliquer sur **Execute**

**Résultat** : Message de confirmation

---

## 📊 ENDPOINTS DISPONIBLES

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | /api/recrutement/offres | Toutes les offres |
| POST | /api/recrutement/offres | Créer une offre |
| GET | /api/recrutement/offres/{id} | Offre par ID |
| PUT | /api/recrutement/offres/{id} | Modifier une offre |
| DELETE | /api/recrutement/offres/{id} | Supprimer une offre |
| PATCH | /api/recrutement/offres/{id}/fermer | Fermer une offre |
| GET | /api/recrutement/offres/statut/{statut} | Offres par statut |
| GET | /api/recrutement/offres/specialite/{spec} | Offres par spécialité |
| GET | /api/recrutement/candidatures | Toutes les candidatures |
| POST | /api/recrutement/candidatures | Postuler |
| PATCH | /api/recrutement/candidatures/{id}/statut | Changer statut |
| GET | /api/recrutement/candidatures/offre/{id} | Candidatures par offre |
| GET | /api/recrutement/candidatures/statut/{s} | Candidatures par statut |
| GET | /api/recrutement/candidatures/specialite/{s} | Filtrer par spécialité |
| POST | /api/recrutement/candidatures/{id}/convertir | Convertir en enseignant |

---

## 🔍 SCHÉMAS

### OffreRecrutement
```json
{
  "id_offre": 0,
  "titre": "string",
  "description": "string",
  "specialite": "string",
  "experience_min": 0,
  "date_publication": "2026-02-17",
  "statut": "string",
  "candidatures": []
}
```

### CandidatureEnseignant
```json
{
  "id_candidature": 0,
  "nom_candidat": "string",
  "prenom_candidat": "string",
  "email": "string",
  "cv_url": "string",
  "lettre_motivation": "string",
  "date_candidature": "2026-02-17",
  "statut": "string"
}
```

---

## 🎯 WORKFLOW COMPLET

### Scénario : Recruter un enseignant

1. **Créer une offre** (POST /offres)
2. **Voir les offres ouvertes** (GET /offres/statut/OUVERTE)
3. **Candidat postule** (POST /candidatures?offreId=1)
4. **Voir les candidatures** (GET /candidatures/offre/1)
5. **Accepter une candidature** (PATCH /candidatures/1/statut?statut=ACCEPTEE)
6. **Convertir en enseignant** (POST /candidatures/1/convertir)

---

## 🐛 DÉPANNAGE

### Swagger ne s'affiche pas

**Solutions** :
1. Vérifier que le service est démarré
2. Essayer : `http://localhost:8083/swagger-ui/index.html`
3. Essayer : `http://localhost:8083/swagger-ui.html`
4. Vérifier l'API : `http://localhost:8083/api/recrutement/offres`

### Erreur Eureka

Si vous voyez des erreurs Eureka, démarrez Eureka en premier :
```cmd
cd eureka-server
mvnw spring-boot:run
```

---

## 📚 LIENS UTILES

### Recrutement Service
- Swagger UI : http://localhost:8083/swagger-ui/index.html
- API Docs : http://localhost:8083/v3/api-docs
- API Direct : http://localhost:8083/api/recrutement/offres

### Via Gateway
- API Gateway : http://localhost:8080/api/recrutement/offres

### Eureka
- Dashboard : http://localhost:8761

---

## ✅ CHECKLIST

- [ ] Dépendance Swagger ajoutée
- [ ] SwaggerConfig.java créé
- [ ] Configuration dans application.properties
- [ ] Service recompilé (`mvnw clean install`)
- [ ] Service démarré
- [ ] Swagger UI accessible
- [ ] Tests effectués

---

**Profitez de Swagger pour tester votre API Recrutement ! 🎉**
