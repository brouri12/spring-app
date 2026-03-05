# Règles de Validation - Formulaire Candidature

## Erreurs Actuelles

Vous avez deux erreurs de validation:

### 1. Nom du Candidat
**Erreur:** "Le nom/prénom ne doit contenir que des lettres, espaces, tirets ou apostrophes. Il doit commencer par une majuscule"

**Règles:**
- ✅ Doit commencer par une majuscule
- ✅ Peut contenir: lettres, espaces, tirets (-), apostrophes (')
- ❌ Ne peut PAS contenir: chiffres, caractères spéciaux (@, #, etc.)
- ✅ Longueur: 2-50 caractères

**Exemples valides:**
- `Dupont`
- `Jean-Pierre`
- `O'Connor`
- `Marie Anne`
- `Ben Salah`

**Exemples invalides:**
- `dupont` (pas de majuscule)
- `Jean123` (contient des chiffres)
- `Jean@Pierre` (caractère spécial)
- `j` (trop court)

### 2. Lettre de Motivation
**Erreur:** "La lettre de motivation doit contenir plus de diversité dans le vocabulaire"

**Règles:**
- ✅ Longueur: 100-2000 caractères
- ✅ Minimum 20 mots
- ✅ Doit contenir des phrases complètes (avec points)
- ✅ Doit avoir de la diversité dans le vocabulaire
- ❌ Ne peut PAS être répétitive (même mot plusieurs fois)

**Exemple invalide:**
```
Je suis motivé motivé motivé. Je veux travailler travailler travailler.
```
→ Trop répétitif!

**Exemple valide:**
```
Je suis très motivé par cette opportunité de rejoindre votre établissement. 
Mon expérience en enseignement et ma passion pour la transmission des connaissances 
me permettront de contribuer efficacement à vos objectifs pédagogiques. 
J'ai développé des compétences solides en gestion de classe et en adaptation 
des méthodes d'enseignement aux besoins des étudiants. Je serais honoré de 
mettre mon expertise au service de votre institution.
```

## Solution Rapide

### Pour le Nom:
Utilisez un nom simple qui commence par une majuscule:
- `Dupont`
- `Martin`
- `Bernard`

### Pour la Lettre de Motivation:
Écrivez un texte varié d'au moins 100 caractères avec différents mots:

```
Je suis très intéressé par ce poste d'enseignant dans votre établissement. 
Mon parcours académique et professionnel m'a permis d'acquérir des compétences 
solides en pédagogie et en gestion de classe. J'ai une grande passion pour 
la transmission des connaissances et l'accompagnement des étudiants dans leur 
réussite. Je serais honoré de contribuer à vos objectifs éducatifs et de 
participer au développement de votre institution.
```

## Toutes les Règles de Validation

### Nom et Prénom
- Format: Lettres, espaces, tirets, apostrophes uniquement
- Commence par une majuscule
- Longueur: 2-50 caractères

### Email
- Format: `exemple@domaine.com`
- Longueur: 5-100 caractères
- Doit être unique (pas déjà utilisé)

### CV
- Format: PDF, DOC, DOCX
- Taille max: 5MB
- Requis

### Lettre de Motivation
- Longueur: 100-2000 caractères
- Minimum 20 mots
- Phrases complètes (avec ponctuation)
- Vocabulaire varié (pas répétitif)

## Tester Maintenant

1. **Rafraîchissez le navigateur** (Ctrl+Shift+R)
2. **Remplissez le formulaire:**
   - Nom: `Dupont`
   - Prénom: `Jean`
   - Email: `jean.dupont.2024@example.com`
   - CV: Sélectionnez votre PDF
   - Lettre: Copiez l'exemple ci-dessus

3. **Soumettez**

Cette fois, les erreurs de validation s'afficheront clairement dans l'interface!

## Désactiver les Validations (Développement Seulement)

Si vous voulez tester sans ces validations strictes, vous pouvez temporairement les désactiver dans le backend.

**⚠️ NE PAS FAIRE EN PRODUCTION!**

Dans `CandidatureEnseignant.java`, commentez les annotations:

```java
// @ValidName(message = "...")
private String nom_candidat;

// @ValidLettreMotivation(message = "...")
private String lettre_motivation;
```

Puis redémarrez le backend.

## Pourquoi Ces Validations?

Ces validations garantissent:
- ✅ Qualité des données
- ✅ Sécurité (pas d'injection)
- ✅ Cohérence
- ✅ Professionnalisme

Elles sont importantes pour une application de production!
