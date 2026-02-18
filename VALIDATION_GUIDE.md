# Guide des Validations - Services Forum et Recrutement

## 📋 Vue d'ensemble

Ce document décrit toutes les validations de contrôle de saisie implémentées dans les microservices Forum et Recrutement.

---

## 🔵 Forum Service (Port 8082)

### Entité Forum

| Champ | Validations | Message d'erreur |
|-------|-------------|------------------|
| `titre` | - Non vide<br>- 5 à 100 caractères | "Le titre est obligatoire"<br>"Le titre doit contenir entre 5 et 100 caractères" |
| `description` | - Non vide<br>- 10 à 1000 caractères | "La description est obligatoire"<br>"La description doit contenir entre 10 et 1000 caractères" |
| `niveau` | - Non vide<br>- Valeurs: L1, L2, L3, M1, M2 | "Le niveau est obligatoire"<br>"Le niveau doit être L1, L2, L3, M1 ou M2" |
| `date_creation` | - Date passée ou présente | "La date de création ne peut pas être dans le futur" |
| `statut` | - Non vide<br>- Valeurs: OUVERT, FERME, ARCHIVE | "Le statut est obligatoire"<br>"Le statut doit être OUVERT, FERME ou ARCHIVE" |

### Entité MessageForum

| Champ | Validations | Message d'erreur |
|-------|-------------|------------------|
| `contenu` | - Non vide<br>- 1 à 2000 caractères | "Le contenu est obligatoire"<br>"Le contenu doit contenir entre 1 et 2000 caractères" |
| `auteurId` | - Nombre positif | "L'ID de l'auteur doit être positif" |
| `type_auteur` | - Non vide<br>- Valeurs: ETUDIANT, ENSEIGNANT, ADMIN | "Le type d'auteur est obligatoire"<br>"Le type d'auteur doit être ETUDIANT, ENSEIGNANT ou ADMIN" |
| `statut` | - Non vide<br>- Valeurs: ACTIF, SUPPRIME, MODERE | "Le statut est obligatoire"<br>"Le statut doit être ACTIF, SUPPRIME ou MODERE" |

---

## 🟢 Recrutement Service (Port 8083)

### Entité OffreRecrutement

| Champ | Validations | Message d'erreur |
|-------|-------------|------------------|
| `titre` | - Non vide<br>- 5 à 150 caractères | "Le titre est obligatoire"<br>"Le titre doit contenir entre 5 et 150 caractères" |
| `description` | - Non vide<br>- 20 à 2000 caractères | "La description est obligatoire"<br>"La description doit contenir entre 20 et 2000 caractères" |
| `specialite` | - Non vide<br>- 3 à 100 caractères | "La spécialité est obligatoire"<br>"La spécialité doit contenir entre 3 et 100 caractères" |
| `type_contrat` | - Non vide<br>- Valeurs: CDI, CDD, Vacataire | "Le type de contrat est obligatoire"<br>"Le type de contrat doit être CDI, CDD ou Vacataire" |
| `nombre_postes` | - Nombre entre 1 et 50 | "Le nombre de postes doit être entre 1 et 50" |
| `experience_min` | - Nombre entre 0 et 30 | "L'expérience minimale doit être entre 0 et 30 ans" |
| `date_limite` | - Date future | "La date limite doit être dans le futur" |
| `statut` | - Non vide<br>- Valeurs: OUVERTE, FERMEE, POURVUE | "Le statut est obligatoire"<br>"Le statut doit être OUVERTE, FERMEE ou POURVUE" |

### Entité CandidatureEnseignant (avec validateurs personnalisés)

| Champ | Validations | Détails |
|-------|-------------|---------|
| `nom_candidat` | **@ValidName** | - Uniquement des lettres (a-z, A-Z, accents)<br>- 2 à 50 caractères<br>- Commence par une majuscule<br>- Pas de chiffres<br>- Pas de caractères spéciaux consécutifs |
| `prenom_candidat` | **@ValidName** | - Mêmes règles que le nom |
| `email` | **@ValidEmail** | - Format strict: exemple@domaine.com<br>- 5 à 100 caractères<br>- Pas de caractères consécutifs (.. __ --)<br>- Domaine valide avec extension<br>- Partie locale valide (lettres, chiffres, . _ - +) |
| `cv_url` | **@ValidCvUrl** | - URL valide (http:// ou https://)<br>- Extensions acceptées: .pdf, .doc, .docx, .txt<br>- Domaines reconnus: Google Drive, Dropbox, OneDrive, Box, iCloud<br>- Longueur max: 500 caractères |
| `lettre_motivation` | **@ValidLettreMotivation** | - 100 à 2000 caractères<br>- Minimum 20 mots<br>- Au moins une phrase complète (avec point)<br>- Pas que des majuscules<br>- Pas de répétitions excessives<br>- Diversité de vocabulaire (min 15 mots uniques) |
| `statut` | - Non vide<br>- Valeurs: EN_ATTENTE, ACCEPTEE, REFUSEE | "Le statut est obligatoire"<br>"Le statut doit être EN_ATTENTE, ACCEPTEE ou REFUSEE" |

---

## 🔧 Validateurs Personnalisés

### 1. @ValidEmail (EmailValidator)

```java
// Règles de validation:
- Format: partie_locale@domaine.extension
- Longueur: 5-100 caractères
- Partie locale: lettres, chiffres, . _ - +
- Pas de caractères consécutifs: .. __ -- ++
- Domaine: lettres, chiffres, tirets
- Extension: 2-6 caractères

// Exemples valides:
✅ mohamed.benahmed@esprit.tn
✅ fatma_trabelsi@gmail.com
✅ user+tag@example.co.uk

// Exemples invalides:
❌ user..name@example.com (points consécutifs)
❌ @example.com (pas de partie locale)
❌ user@.com (domaine invalide)
```

### 2. @ValidCvUrl (CvUrlValidator)

```java
// Règles de validation:
- URL valide avec protocole http:// ou https://
- Extensions acceptées: .pdf, .doc, .docx, .txt
- Domaines de partage reconnus
- Longueur max: 500 caractères

// Exemples valides:
✅ https://drive.google.com/file/d/123/cv.pdf
✅ https://www.dropbox.com/s/abc/cv.docx
✅ https://onedrive.live.com/download?id=xyz&file=cv.pdf

// Exemples invalides:
❌ http://example.com/cv.jpg (extension non acceptée)
❌ ftp://example.com/cv.pdf (protocole non supporté)
❌ cv.pdf (pas une URL)
```

### 3. @ValidName (NameValidator)

```java
// Règles de validation:
- Uniquement des lettres (avec accents)
- 2 à 50 caractères
- Commence par une majuscule
- Pas de chiffres
- Espaces et tirets autorisés (pas consécutifs)

// Exemples valides:
✅ Mohamed
✅ Ben Ahmed
✅ Marie-Claire
✅ O'Connor

// Exemples invalides:
❌ mohamed (pas de majuscule)
❌ Mohamed123 (contient des chiffres)
❌ M (trop court)
❌ Mohamed--Ali (tirets consécutifs)
```

### 4. @ValidLettreMotivation (LettreMotivationValidator)

```java
// Règles de validation:
- 100 à 2000 caractères
- Minimum 20 mots
- Au moins une phrase complète (avec point)
- Pas que des majuscules
- Pas de répétitions excessives (max 3 fois le même mot)
- Diversité de vocabulaire (min 15 mots uniques)

// Exemple valide:
✅ "Madame, Monsieur, je me permets de vous adresser ma candidature 
    pour le poste d'enseignant. Fort de mes cinq années d'expérience 
    dans l'enseignement supérieur, je suis convaincu de pouvoir 
    apporter une contribution significative à votre établissement..."

// Exemples invalides:
❌ "Je veux ce poste." (trop court, moins de 20 mots)
❌ "JE VEUX CE POSTE MAINTENANT..." (que des majuscules)
❌ "Je je je je je..." (répétitions excessives)
```

---

## 🧪 Tests des Validations

### Via Swagger UI

1. **Forum Service**: http://localhost:8082/swagger-ui.html
2. **Recrutement Service**: http://localhost:8083/swagger-ui.html

### Exemples de tests

#### Test Email Invalide
```json
POST /api/recrutement/candidatures
{
  "nom_candidat": "Benahmed",
  "prenom_candidat": "Mohamed",
  "email": "invalid..email@test.com",  // ❌ Points consécutifs
  "cv_url": "https://drive.google.com/file/d/123/cv.pdf",
  "lettre_motivation": "Lettre valide avec plus de 100 caractères..."
}

// Réponse attendue: 400 Bad Request
{
  "email": "Email invalide. Format attendu : exemple@domaine.com"
}
```

#### Test CV URL Invalide
```json
POST /api/recrutement/candidatures
{
  "nom_candidat": "Benahmed",
  "prenom_candidat": "Mohamed",
  "email": "mohamed@esprit.tn",
  "cv_url": "http://example.com/cv.jpg",  // ❌ Extension non acceptée
  "lettre_motivation": "Lettre valide..."
}

// Réponse attendue: 400 Bad Request
{
  "cv_url": "URL du CV invalide. Doit être une URL valide avec extension .pdf, .doc, .docx ou .txt"
}
```

---

## 📝 Gestion des Erreurs

Les deux services utilisent un `GlobalExceptionHandler` qui retourne les erreurs de validation au format JSON:

```json
{
  "timestamp": "2026-02-18T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Erreur de validation",
  "errors": {
    "email": "Email invalide. Format attendu : exemple@domaine.com",
    "cv_url": "URL du CV invalide"
  }
}
```

---

## ✅ Checklist de Déploiement

- [x] Validations Forum Service implémentées
- [x] Validations Recrutement Service implémentées
- [x] Validateurs personnalisés créés
- [x] GlobalExceptionHandler configuré
- [x] Données de test conformes aux validations
- [x] Tests via Swagger UI disponibles

---

## 🚀 Prochaines Étapes

1. Redémarrer les services pour appliquer les validations
2. Tester via Swagger UI avec des données valides et invalides
3. Intégrer les messages d'erreur dans le frontend Angular
4. Ajouter des tests unitaires pour les validateurs personnalisés
