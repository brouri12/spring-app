# Guide de Test des Validations

## 🚀 Démarrage des Services

Les données de test ont été désactivées temporairement pour éviter les erreurs de validation au démarrage.

### 1. Démarrer Eureka Server
```bash
cd eureka-server
mvnw spring-boot:run
```
Attendre que le serveur démarre sur http://localhost:8761

### 2. Démarrer Forum Service
```bash
cd forum-service
mvnw spring-boot:run
```
Service disponible sur http://localhost:8082

### 3. Démarrer Recrutement Service
```bash
cd recrutement-service
mvnw spring-boot:run
```
Service disponible sur http://localhost:8083

### 4. Démarrer API Gateway
```bash
cd api-gateway
mvnw spring-boot:run
```
Gateway disponible sur http://localhost:8080

---

## 📝 Tests via Back-Office Angular

### Test 1: Créer un Forum (Validation OK)

**Données valides:**
- Titre: "Discussion Java Spring Boot" (min 5 caractères)
- Description: "Forum dédié aux questions sur Spring Boot et Java" (min 10 caractères)
- Niveau: Sélectionner "L3" dans la liste
- Groupe: "INFO-A" (min 2 caractères)
- Cours: "Développement Web" (min 3 caractères)

**Résultat attendu:** ✅ Forum créé avec succès

---

### Test 2: Créer un Forum (Validation KO - Titre trop court)

**Données invalides:**
- Titre: "Test" (4 caractères - min 5 requis)
- Description: "Description valide"
- Niveau: "L3"
- Groupe: "INFO-A"
- Cours: "Java"

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
titre: Le titre doit contenir entre 5 et 100 caractères
```

---

### Test 3: Créer un Forum (Validation KO - Description trop courte)

**Données invalides:**
- Titre: "Discussion Java"
- Description: "Test" (4 caractères - min 10 requis)
- Niveau: "L3"
- Groupe: "INFO-A"
- Cours: "Java"

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
description: La description doit contenir entre 10 et 1000 caractères
```

---

### Test 4: Créer un Forum (Validation KO - Niveau invalide)

**Données invalides:**
- Titre: "Discussion Java"
- Description: "Description valide"
- Niveau: "L4" (valeurs acceptées: L1, L2, L3, M1, M2)
- Groupe: "INFO-A"
- Cours: "Java"

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
niveau: Le niveau doit être L1, L2, L3, M1 ou M2
```

---

### Test 5: Créer une Offre de Recrutement (Validation OK)

**Données valides:**
- Titre: "Enseignant Java/Spring Boot" (min 5 caractères)
- Description: "Nous recherchons un enseignant expérimenté en développement Java" (min 20 caractères)
- Spécialité: "Informatique" (min 3 caractères)
- Type de contrat: Sélectionner "CDI"
- Nombre de postes: 2 (entre 1 et 50)
- Expérience minimale: 3 (entre 0 et 30)
- Date limite: Sélectionner une date future
- Statut: "OUVERTE"

**Résultat attendu:** ✅ Offre créée avec succès

---

### Test 6: Postuler à une Offre (Validation OK)

**Données valides:**
- Nom: "Benahmed" (commence par majuscule, lettres uniquement)
- Prénom: "Mohamed" (commence par majuscule, lettres uniquement)
- Email: "mohamed.benahmed@esprit.tn" (format valide)
- CV URL: "https://drive.google.com/file/d/123/cv.pdf" (URL valide avec extension .pdf)
- Lettre de motivation: (min 100 caractères, min 20 mots)
```
Madame, Monsieur, je me permets de vous adresser ma candidature pour le poste d'enseignant en Java et Spring Boot. Fort de mes cinq années d'expérience dans l'enseignement supérieur et le développement d'applications web, je suis convaincu de pouvoir apporter une contribution significative à votre établissement. Ma passion pour la transmission des connaissances et mon expertise technique me permettent d'accompagner efficacement les étudiants dans leur apprentissage.
```

**Résultat attendu:** ✅ Candidature créée avec succès

---

### Test 7: Postuler (Validation KO - Email invalide)

**Données invalides:**
- Nom: "Benahmed"
- Prénom: "Mohamed"
- Email: "invalid..email@test.com" (points consécutifs non autorisés)
- CV URL: "https://drive.google.com/file/d/123/cv.pdf"
- Lettre de motivation: (texte valide)

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
email: Email invalide. Format attendu : exemple@domaine.com (5-100 caractères, domaine valide)
```

---

### Test 8: Postuler (Validation KO - CV URL invalide)

**Données invalides:**
- Nom: "Benahmed"
- Prénom: "Mohamed"
- Email: "mohamed@esprit.tn"
- CV URL: "http://example.com/cv.jpg" (extension .jpg non acceptée)
- Lettre de motivation: (texte valide)

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
cv_url: URL du CV invalide. Doit être une URL valide avec extension .pdf, .doc, .docx ou .txt
```

---

### Test 9: Postuler (Validation KO - Nom invalide)

**Données invalides:**
- Nom: "benahmed" (pas de majuscule)
- Prénom: "Mohamed"
- Email: "mohamed@esprit.tn"
- CV URL: "https://drive.google.com/file/d/123/cv.pdf"
- Lettre de motivation: (texte valide)

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
nom_candidat: Le nom doit contenir uniquement des lettres, commencer par une majuscule, et avoir entre 2 et 50 caractères
```

---

### Test 10: Postuler (Validation KO - Lettre trop courte)

**Données invalides:**
- Nom: "Benahmed"
- Prénom: "Mohamed"
- Email: "mohamed@esprit.tn"
- CV URL: "https://drive.google.com/file/d/123/cv.pdf"
- Lettre de motivation: "Je veux ce poste." (moins de 100 caractères et moins de 20 mots)

**Résultat attendu:** ❌ Erreur affichée
```
Erreur de validation:
lettre_motivation: Lettre de motivation invalide. Doit contenir 100-2000 caractères, au moins 20 mots, et des phrases complètes
```

---

## 🧪 Tests via Swagger UI

### Forum Service
URL: http://localhost:8082/swagger-ui.html

1. Tester POST `/api/forum/forums` avec données valides/invalides
2. Tester POST `/api/forum/messages` avec données valides/invalides

### Recrutement Service
URL: http://localhost:8083/swagger-ui.html

1. Tester POST `/api/recrutement/offres` avec données valides/invalides
2. Tester POST `/api/recrutement/candidatures/offre/{offreId}` avec données valides/invalides

---

## ✅ Checklist de Validation

- [ ] Forum Service démarre sans erreur
- [ ] Recrutement Service démarre sans erreur
- [ ] Création de forum avec données valides fonctionne
- [ ] Création de forum avec données invalides affiche les erreurs
- [ ] Création d'offre avec données valides fonctionne
- [ ] Création d'offre avec données invalides affiche les erreurs
- [ ] Candidature avec email invalide est rejetée
- [ ] Candidature avec CV URL invalide est rejetée
- [ ] Candidature avec nom sans majuscule est rejetée
- [ ] Candidature avec lettre trop courte est rejetée

---

## 📌 Notes Importantes

1. Les données de test sont désactivées pour permettre de tester les validations proprement
2. Les messages d'erreur sont affichés dans l'interface Angular
3. Les erreurs sont aussi visibles dans la console du navigateur (F12)
4. Swagger UI permet de tester directement les endpoints sans passer par Angular
5. Les validations sont appliquées côté backend (Spring Boot)
6. Les erreurs sont retournées au format JSON avec le code HTTP 400

---

## 🔄 Réactiver les Données de Test

Une fois les tests terminés, vous pouvez réactiver les données de test en décommentant le code dans:
- `forum-service/src/main/java/tn/esprit/forum/ForumApplication.java`
- `recrutement-service/src/main/java/tn/esprit/recrutement/RecrutementApplication.java`

Puis redémarrer les services.
