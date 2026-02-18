# 🎯 Guide Test Swagger - Candidature

## ✅ PROBLÈME RÉSOLU

**Erreur** : `No property 'id' found for type 'CandidatureEnseignant'`

**Cause** : L'ID était envoyé avec la valeur 0, ce qui empêchait la génération automatique.

**Solution** : L'ID est maintenant forcé à `null` dans le service avant la sauvegarde.

---

## 📝 COMMENT TESTER SUR SWAGGER

### 1. Accéder à Swagger
```
http://localhost:8083/swagger-ui/index.html
```

### 2. Créer une Candidature (POST)

**Endpoint** : `POST /api/recrutement/candidatures`

**Paramètre** : `offreId=9` (ou un autre ID d'offre existante)

**Body JSON** :
```json
{
  "nom_candidat": "Dupont",
  "prenom_candidat": "Jean",
  "email": "jean.dupont@example.com",
  "cv_url": "http://example.com/cv.pdf",
  "lettre_motivation": "Je suis très motivé pour ce poste...",
  "date_candidature": "2026-02-17",
  "statut": "EN_ATTENTE"
}
```

**OU** (si vous voulez garder le format avec id_candidature) :
```json
{
  "id_candidature": 0,
  "nom_candidat": "Dupont",
  "prenom_candidat": "Jean",
  "email": "jean.dupont@example.com",
  "cv_url": "http://example.com/cv.pdf",
  "lettre_motivation": "Je suis très motivé pour ce poste...",
  "date_candidature": "2026-02-17",
  "statut": "EN_ATTENTE"
}
```

**Note** : L'ID sera automatiquement ignoré et généré par la base de données.

---

## 🔄 REDÉMARRER LE SERVICE

Pour appliquer les modifications :

```cmd
cd recrutement-service
mvn clean install
mvn spring-boot:run
```

---

## ✅ TESTS COMPLETS

### Test 1 : Créer une candidature
```
POST http://localhost:8083/api/recrutement/candidatures?offreId=9
```

### Test 2 : Lister toutes les candidatures
```
GET http://localhost:8083/api/recrutement/candidatures
```

### Test 3 : Candidatures par offre
```
GET http://localhost:8083/api/recrutement/candidatures/offre/9
```

### Test 4 : Changer le statut
```
PATCH http://localhost:8083/api/recrutement/candidatures/1/statut?statut=ACCEPTEE
```

---

## ⚠️ ERREURS POSSIBLES

### Erreur 409 : "Vous avez déjà postulé à cette offre"
**Cause** : L'email existe déjà pour cette offre.
**Solution** : Utilisez un autre email.

### Erreur 400 : "Offre introuvable"
**Cause** : L'offreId n'existe pas.
**Solution** : Vérifiez les offres disponibles avec `GET /api/recrutement/offres`

---

## 📊 VÉRIFIER LES DONNÉES

### Lister les offres disponibles
```
GET http://localhost:8083/api/recrutement/offres
```

Vous devriez voir les offres avec leurs IDs (9, 10, etc.)

---

## 🎉 RÉSULTAT ATTENDU

Après le POST, vous devriez recevoir :
```json
{
  "id_candidature": 11,
  "nom_candidat": "Dupont",
  "prenom_candidat": "Jean",
  "email": "jean.dupont@example.com",
  "cv_url": "http://example.com/cv.pdf",
  "lettre_motivation": "Je suis très motivé pour ce poste...",
  "date_candidature": "2026-02-17",
  "statut": "EN_ATTENTE"
}
```

**Status Code** : `201 Created`
