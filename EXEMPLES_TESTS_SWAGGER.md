# Exemples de Tests via Swagger UI

## ✅ Swagger Fonctionne !

Les validations sont opérationnelles. Voici des exemples de tests à effectuer.

---

## 🟢 Test 1: Créer un Forum VALIDE

### Données à utiliser dans Swagger UI

```json
{
  "titre": "Discussion Java Spring Boot",
  "description": "Forum dédié aux questions sur Spring Boot et Java",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Développement Web",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ✅ Code 201 (Created)
- ✅ Forum créé avec un ID

---

## 🔴 Test 2: Titre trop court (Validation KO)

```json
{
  "titre": "Test",
  "description": "Description valide avec plus de 10 caractères",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400 (Bad Request)
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "titre": "Le titre doit contenir entre 5 et 100 caractères"
  },
  "status": "error"
}
```

---

## 🔴 Test 3: Description trop courte (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Test",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "description": "La description doit contenir entre 10 et 1000 caractères"
  },
  "status": "error"
}
```

---

## 🔴 Test 4: Niveau invalide (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Description valide",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L4",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "niveau": "Le niveau doit être L1, L2, L3, M1 ou M2"
  },
  "status": "error"
}
```

---

## 🔴 Test 5: Statut invalide (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Description valide",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "ACTIVE"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "statut": "Le statut doit être OUVERT, FERME ou ARCHIVE"
  },
  "status": "error"
}
```

---

## 🔴 Test 6: ID créateur non positif (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Description valide",
  "date_creation": "2026-02-18",
  "cree_par": 0,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "cree_par": "L'ID du créateur doit être positif"
  },
  "status": "error"
}
```

---

## 🔴 Test 7: Date de création future (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Description valide",
  "date_creation": "2027-12-31",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "date_creation": "La date de création ne peut pas être dans le futur"
  },
  "status": "error"
}
```

---

## 🔴 Test 8: Groupe trop court (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Description valide",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "groupe": "Le groupe doit contenir entre 2 et 50 caractères"
  },
  "status": "error"
}
```

---

## 🔴 Test 9: Cours trop court (Validation KO)

```json
{
  "titre": "Discussion Java",
  "description": "Description valide",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "JS",
  "statut": "OUVERT"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "cours": "Le cours doit contenir entre 3 et 100 caractères"
  },
  "status": "error"
}
```

---

## 🔴 Test 10: Multiples erreurs (Validation KO)

```json
{
  "titre": "Test",
  "description": "Test",
  "date_creation": "2026-02-18",
  "cree_par": 0,
  "niveau": "L4",
  "groupe": "A",
  "cours": "JS",
  "statut": "ACTIVE"
}
```

### Résultat attendu
- ❌ Code 400
- Message d'erreur avec TOUTES les erreurs :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "titre": "Le titre doit contenir entre 5 et 100 caractères",
    "description": "La description doit contenir entre 10 et 1000 caractères",
    "cree_par": "L'ID du créateur doit être positif",
    "niveau": "Le niveau doit être L1, L2, L3, M1 ou M2",
    "groupe": "Le groupe doit contenir entre 2 et 50 caractères",
    "cours": "Le cours doit contenir entre 3 et 100 caractères",
    "statut": "Le statut doit être OUVERT, FERME ou ARCHIVE"
  },
  "status": "error"
}
```

---

## 📝 Tests pour MessageForum

### 🟢 Message VALIDE

```json
{
  "contenu": "Bonjour, comment configurer Spring Security ?",
  "auteurId": 101,
  "type_auteur": "ETUDIANT",
  "statut": "ACTIF"
}
```

Endpoint : `POST /api/forum/messages?forumId=1`

### 🔴 Contenu vide (Validation KO)

```json
{
  "contenu": "",
  "auteurId": 101,
  "type_auteur": "ETUDIANT",
  "statut": "ACTIF"
}
```

Résultat attendu :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "contenu": "Le contenu est obligatoire"
  },
  "status": "error"
}
```

### 🔴 Type auteur invalide (Validation KO)

```json
{
  "contenu": "Message valide",
  "auteurId": 101,
  "type_auteur": "VISITEUR",
  "statut": "ACTIF"
}
```

Résultat attendu :
```json
{
  "message": "Erreur de validation",
  "errors": {
    "type_auteur": "Le type d'auteur doit être ETUDIANT, ENSEIGNANT ou ADMIN"
  },
  "status": "error"
}
```

---

## 🎯 Recrutement Service - Tests via Swagger

URL : http://localhost:8083/swagger-ui.html

### 🟢 Offre VALIDE

```json
{
  "titre": "Enseignant Java Spring Boot",
  "description": "Nous recherchons un enseignant expérimenté en développement Java et Spring Boot",
  "specialite": "Informatique",
  "niveau_requis": "Master ou Doctorat",
  "type_contrat": "CDI",
  "experience_min": 3,
  "date_publication": "2026-02-18",
  "date_limite": "2026-04-18",
  "statut": "OUVERTE",
  "nombre_postes": 2
}
```

### 🟢 Candidature VALIDE

```json
{
  "nom_candidat": "Benahmed",
  "prenom_candidat": "Mohamed",
  "email": "mohamed.benahmed@esprit.tn",
  "cv_url": "https://drive.google.com/file/d/1234567890/cv-mohamed-benahmed.pdf",
  "lettre_motivation": "Madame, Monsieur, je me permets de vous adresser ma candidature pour le poste d'enseignant en Java et Spring Boot. Fort de mes cinq années d'expérience dans l'enseignement supérieur et le développement d'applications web, je suis convaincu de pouvoir apporter une contribution significative à votre établissement. Ma passion pour la transmission des connaissances et mon expertise technique me permettent d'accompagner efficacement les étudiants dans leur apprentissage. Je reste à votre disposition pour un entretien. Cordialement.",
  "statut": "EN_ATTENTE"
}
```

Endpoint : `POST /api/recrutement/candidatures/offre/{offreId}`

---

## ✅ Conclusion

Les validations fonctionnent parfaitement ! Vous pouvez maintenant :

1. ✅ Tester toutes les validations via Swagger UI
2. ✅ Voir les messages d'erreur détaillés
3. ✅ Créer des données valides
4. ✅ Utiliser le back-office Angular avec confiance

Toutes les contraintes de validation sont appliquées et les messages d'erreur sont clairs et précis.
