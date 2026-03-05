# 📸 Guide Visuel - Où Trouver la Section Média

## ⚠️ IMPORTANT: Mode "Nouveau Message" vs "Édition"

La section "Ajouter des médias" s'affiche **UNIQUEMENT** en mode "Nouveau Message".

Elle **NE S'AFFICHE PAS** en mode "Édition de message existant".

---

## ✅ CORRECT: Mode "Nouveau Message"

### Étape 1: Aller sur Forums
```
http://localhost:4300/forums
```

### Étape 2: Sélectionner un Forum
```
┌──────────────┬────────────────────────────────┐
│ Forums Actifs│                                │
│              │                                │
│ ┌──────────┐ │                                │
│ │ Forum 1  │ │ ← CLIQUEZ ICI                  │
│ └──────────┘ │                                │
└──────────────┴────────────────────────────────┘
```

### Étape 3: Cliquer sur "Nouveau Message"
```
┌────────────────────────────────────────────────┐
│ [Rechercher...]                                │
│                                                │
│ ┌────────────────────────────────────────────┐ │
│ │ + Nouveau Message                          │ │ ← CLIQUEZ ICI
│ └────────────────────────────────────────────┘ │ (PAS sur éditer !)
│                                                │
│ Message 1  [Éditer] [Supprimer] ← NE PAS CLIQUER
│ Message 2  [Éditer] [Supprimer] ← NE PAS CLIQUER
└────────────────────────────────────────────────┘
```

### Étape 4: Remplir le Formulaire
```
┌─────────────────────────────────────────┐
│ Nouveau Message                    [✖]  │ ← Titre = "Nouveau Message"
├─────────────────────────────────────────┤
│ Type d'auteur: [Étudiant ▼]             │
│                                         │
│ Message:                                │
│ ┌─────────────────────────────────────┐ │
│ │ Tapez votre message ici...          │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ⬇️ SCROLLEZ VERS LE BAS ⬇️              │
└─────────────────────────────────────────┘
```

### Étape 5: Voir la Section Média
```
┌─────────────────────────────────────────┐
│ ... (suite du formulaire)               │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ 📎 Ajouter des médias (optionnel)      │ ← ICI !
│                                         │
│ 📷 Image (JPG, PNG, GIF - max 5MB)     │
│ [Choisir un fichier]                    │
│                                         │
│ 🎵 Audio (MP3, WAV - max 10MB)         │
│ [Choisir un fichier]                    │
│                                         │
│ 📄 Document (PDF, ZIP - max 20MB)      │
│ [Choisir un fichier]                    │
│                                         │
│ 🎬 Vidéo YouTube (URL)                  │
│ [https://youtube.com/...]               │
│                                         │
│ [Publier] [Annuler]                     │
└─────────────────────────────────────────┘
```

---

## ❌ INCORRECT: Mode "Édition"

### Ce Que Vous Faites (INCORRECT)
```
┌────────────────────────────────────────────────┐
│ Message 1  [Éditer] [Supprimer]                │
│            ↑                                   │
│      VOUS CLIQUEZ ICI                          │
│      = MODE ÉDITION                            │
│      = PAS DE SECTION MÉDIA                    │
└────────────────────────────────────────────────┘
```

### Modal en Mode Édition (PAS DE MÉDIA)
```
┌─────────────────────────────────────────┐
│ Modifier le Message                [✖]  │ ← Titre = "Modifier"
├─────────────────────────────────────────┤
│ Type d'auteur: [Étudiant ▼]             │
│                                         │
│ Message:                                │
│ ┌─────────────────────────────────────┐ │
│ │ Contenu du message existant...      │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ❌ PAS DE SECTION MÉDIA                 │
│                                         │
│ [Mettre à jour] [Annuler]               │
└─────────────────────────────────────────┘
```

**Pourquoi ?** En mode édition, on ne peut pas ajouter de nouveaux médias.

---

## 🎯 Résumé Visuel

### ✅ POUR VOIR LA SECTION MÉDIA
```
Forums → Sélectionner Forum → "Nouveau Message" → Scrollez
                                      ↑
                              CLIQUEZ ICI !
```

### ❌ NE PAS FAIRE
```
Forums → Sélectionner Forum → Message existant → "Éditer"
                                                      ↑
                                              PAS ICI !
```

---

## 🔍 Comment Savoir Si Vous Êtes au Bon Endroit

### Indices Visuels

#### ✅ Mode "Nouveau Message" (CORRECT)
- Titre du modal: "Nouveau Message"
- Champs vides
- Bouton: "Publier"
- Section média visible après scroll

#### ❌ Mode "Édition" (INCORRECT)
- Titre du modal: "Modifier le Message"
- Champs pré-remplis avec le message existant
- Bouton: "Mettre à jour"
- PAS de section média

---

## 📸 Capture d'Écran de Votre Problème

D'après votre capture d'écran, vous êtes sur la page des préférences email, pas sur le formulaire de message.

Pour voir la section média:
1. Fermez la page des préférences
2. Allez sur `/forums`
3. Suivez les étapes ci-dessus

---

## 🎨 Correction de la Couleur du Texte

### Problème Résolu
Le texte dans le textarea est maintenant:
- **Mode clair**: Noir (`text-gray-900`)
- **Mode dark**: Blanc (`text-white`)

### Test
1. Ouvrez le formulaire "Nouveau Message"
2. Tapez du texte
3. ✅ Le texte doit être visible (noir ou blanc selon le thème)

---

## 📞 Besoin d'Aide ?

### La section média n'apparaît toujours pas ?
1. Vérifiez que vous êtes en mode "Nouveau Message"
2. Scrollez vers le bas dans le modal
3. Rechargez la page (Ctrl+F5)

### Le texte est toujours invisible ?
1. Rechargez la page (Ctrl+F5)
2. Vérifiez le thème (clair/dark)
3. Essayez de changer de thème

---

**Date**: 5 mars 2026  
**Version**: 1.0
