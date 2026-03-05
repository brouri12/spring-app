# Guide - Voir les Boutons Update

## Problème
Vous ne voyez pas les boutons "Modifier" (update) dans les tables.

## Solution

### 1. Redémarrer l'Application Angular

L'application Angular doit être redémarrée pour voir les changements:

```bash
# Arrêter le serveur Angular (Ctrl+C dans le terminal)
# Puis redémarrer:
cd angular-app/back-office
ng serve
```

### 2. Vider le Cache du Navigateur

Parfois le navigateur garde l'ancienne version en cache:

1. Ouvrir les DevTools (F12)
2. Clic droit sur le bouton de rafraîchissement
3. Sélectionner "Vider le cache et actualiser de force"

OU

- Windows/Linux: `Ctrl + Shift + R`
- Mac: `Cmd + Shift + R`

### 3. Emplacement des Boutons Update

Les boutons se trouvent dans la colonne "Actions" de chaque table:

#### Page Forum (http://localhost:4200/forum)
Dans la colonne "Actions", vous devriez voir **4 ou 5 boutons**:
1. **Bouton Modifier** (gradient vert-orange) - NOUVEAU ✨
2. **Bouton Message** (bleu)
3. **Bouton Fermer/Rouvrir** (orange/vert)
4. **Bouton Supprimer** (rouge)

#### Page Recrutement (http://localhost:4200/recrutement)
Dans la colonne "Actions", vous devriez voir **4 ou 5 boutons**:
1. **Bouton Modifier** (gradient vert-orange) - NOUVEAU ✨
2. **Bouton Candidature** (bleu)
3. **Bouton Fermer/Rouvrir** (orange/vert)
4. **Bouton Supprimer** (rouge)

### 4. Apparence du Bouton Modifier

Le bouton "Modifier" a:
- **Couleur**: Gradient de vert (rgb(0,200,151)) à orange (rgb(255,127,80))
- **Icône**: Crayon/stylo (edit icon)
- **Position**: Premier bouton dans la colonne Actions
- **Tooltip**: "Modifier" (apparaît au survol)

### 5. Fonctionnement

Quand vous cliquez sur le bouton "Modifier":
1. Un modal s'ouvre
2. Le formulaire est pré-rempli avec les données existantes
3. Le titre du modal change: "Modifier le Forum" ou "Modifier l'Offre"
4. Le bouton de soumission affiche "Mettre à jour" au lieu de "Créer"

### 6. Vérification dans le Code

Si vous voulez vérifier que le code est bien présent, cherchez dans les fichiers:

**Forum:**
```html
<!-- angular-app/back-office/src/app/pages/forum/forum.html -->
<button
  (click)="openUpdateForm(forum); $event.stopPropagation()"
  class="p-2 rounded-lg bg-gradient-to-r from-[rgb(0,200,151)] to-[rgb(255,127,80)] text-white hover:opacity-90 transition"
  title="Modifier"
>
```

**Recrutement:**
```html
<!-- angular-app/back-office/src/app/pages/recrutement/recrutement.html -->
<button
  (click)="openUpdateForm(offre); $event.stopPropagation()"
  class="p-2 rounded-lg bg-gradient-to-r from-[rgb(0,200,151)] to-[rgb(255,127,80)] text-white hover:opacity-90 transition"
  title="Modifier"
>
```

### 7. Vérifier les Erreurs Console

Ouvrez la console du navigateur (F12 → Console) et vérifiez s'il y a des erreurs:
- Erreurs TypeScript
- Erreurs de compilation Angular
- Erreurs HTTP

### 8. Ordre des Boutons dans la Table

De gauche à droite dans la colonne "Actions":

```
┌─────────┬─────────┬──────────────┬──────────┐
│ Modifier│ Message │ Fermer/Ouvrir│ Supprimer│
│ (gradient)│ (bleu) │ (orange/vert)│  (rouge) │
└─────────┴─────────┴──────────────┴──────────┘
```

## Checklist de Dépannage

- [ ] Application Angular redémarrée
- [ ] Cache du navigateur vidé
- [ ] Page rafraîchie (Ctrl+Shift+R)
- [ ] Aucune erreur dans la console
- [ ] Aucune erreur de compilation Angular
- [ ] Fichiers HTML bien sauvegardés
- [ ] Fichiers TypeScript bien sauvegardés

## Si Toujours Pas Visible

Si après tout cela vous ne voyez toujours pas les boutons:

1. Vérifiez que vous êtes sur la bonne page:
   - http://localhost:4200/forum
   - http://localhost:4200/recrutement

2. Vérifiez qu'il y a des données dans la table

3. Envoyez-moi une capture d'écran de:
   - La page complète
   - La console du navigateur (F12)
   - Le terminal où Angular tourne

## Exemple Visuel

Voici à quoi devrait ressembler la colonne Actions:

```
Actions
┌──────────────────────────────────────┐
│ [✏️] [💬] [🔒] [🗑️]                  │  ← Ligne 1
│ [✏️] [💬] [🔓] [🗑️]                  │  ← Ligne 2
│ [✏️] [💬] [🔒] [🗑️]                  │  ← Ligne 3
└──────────────────────────────────────┘

Légende:
✏️ = Modifier (gradient vert-orange)
💬 = Message/Candidature (bleu)
🔒 = Fermer (orange) ou 🔓 = Rouvrir (vert)
🗑️ = Supprimer (rouge)
```
