# 🌍 Guide d'Implémentation de la Traduction i18n

## ✅ Étapes Complétées

### 1. Installation des dépendances
```bash
cd angular-app/frontend/angular-app
npm install @ngx-translate/core @ngx-translate/http-loader --save
```

### 2. Fichiers créés

#### Fichiers de traduction JSON
- ✅ `src/assets/i18n/fr.json` - Traductions françaises
- ✅ `src/assets/i18n/en.json` - Traductions anglaises

#### Service de traduction
- ✅ `src/app/services/translation.service.ts` - Service pour gérer les langues

#### Composant de sélection de langue
- ✅ `src/app/components/language-switcher/language-switcher.component.ts` - Bouton FR/EN

#### Configuration
- ✅ `src/app/app.config.ts` - Configuration de TranslateModule

## 📝 Modifications à Faire Manuellement

### 1. Mettre à jour le Header (`src/app/components/header/header.html`)

Remplacer les textes statiques par des clés de traduction:

```html
<!-- Remplacer -->
{{ link.name }}
<!-- Par -->
{{ link.name | translate }}

<!-- Remplacer -->
Sign In
<!-- Par -->
{{ 'HEADER.SIGN_IN' | translate }}

<!-- Remplacer -->
Get Started
<!-- Par -->
{{ 'HEADER.GET_STARTED' | translate }}
```

Ajouter le composant language-switcher dans le header (après le bouton theme):

```html
<!-- Desktop Actions -->
<div class="hidden md:flex items-center gap-4">
  <button (click)="themeService.toggleTheme()" ...>
    <!-- Theme toggle SVG -->
  </button>
  
  <!-- AJOUTER ICI -->
  <app-language-switcher></app-language-switcher>
  
  <button ...>{{ 'HEADER.SIGN_IN' | translate }}</button>
  <button ...>{{ 'HEADER.GET_STARTED' | translate }}</button>
</div>
```

### 2. Mettre à jour Forums Public (`src/app/pages/forums-public/forums-public.html`)

Remplacer tous les textes par des clés de traduction. Exemples:

```html
<!-- Titre -->
<h1>{{ 'FORUMS.TITLE' | translate }}</h1>
<p>{{ 'FORUMS.SUBTITLE' | translate }}</p>

<!-- Boutons -->
<button>{{ 'FORUMS.STATISTICS' | translate }}</button>
<button>{{ 'FORUMS.MY_BADGE' | translate }}</button>
<button>{{ 'FORUMS.NEW_MESSAGE' | translate }}</button>

<!-- Placeholder -->
<input [placeholder]="'FORUMS.SEARCH_PLACEHOLDER' | translate" />

<!-- Messages -->
<p>{{ 'FORUMS.NO_MESSAGES' | translate }}</p>
<p>{{ 'FORUMS.BE_FIRST' | translate }}</p>

<!-- Interactions -->
<span>{{ 'FORUMS.INTERACTIONS.LIKE' | translate }}</span>
<span>{{ 'FORUMS.INTERACTIONS.REPLY' | translate }}</span>
<span>{{ 'FORUMS.INTERACTIONS.REPORT' | translate }}</span>
```

### 3. Mettre à jour Recrutement Public (`src/app/pages/recrutement-public/recrutement-public.html`)

```html
<!-- Titre -->
<h1>{{ 'RECRUITMENT.TITLE' | translate }}</h1>
<p>{{ 'RECRUITMENT.SUBTITLE' | translate }}</p>

<!-- Filtres -->
<input [placeholder]="'RECRUITMENT.FILTER_PLACEHOLDER' | translate" />
<button>{{ 'RECRUITMENT.FILTER' | translate }}</button>
<button>{{ 'RECRUITMENT.RESET' | translate }}</button>

<!-- Boutons -->
<button>{{ 'RECRUITMENT.APPLY' | translate }}</button>
<button>{{ 'RECRUITMENT.EXPIRED' | translate }}</button>

<!-- Modal -->
<label>{{ 'RECRUITMENT.MODAL.LAST_NAME' | translate }} *</label>
<label>{{ 'RECRUITMENT.MODAL.FIRST_NAME' | translate }} *</label>
<label>{{ 'RECRUITMENT.MODAL.EMAIL' | translate }} *</label>
<label>{{ 'RECRUITMENT.MODAL.CV' | translate }} *</label>
<label>{{ 'RECRUITMENT.MODAL.COVER_LETTER' | translate }} *</label>
```

### 4. Ajouter TranslateModule dans les composants

Pour chaque composant qui utilise des traductions, ajouter `TranslateModule` dans les imports:

```typescript
import { TranslateModule } from '@ngx-translate/core';

@Component({
  selector: 'app-forums-public',
  standalone: true,
  imports: [CommonModule, FormsModule, ModalComponent, TranslateModule], // Ajouter TranslateModule
  templateUrl: './forums-public.html',
  styleUrls: ['./forums-public.css']
})
```

Composants à modifier:
- ✅ `src/app/components/header/header.ts` (déjà fait)
- ⏳ `src/app/pages/forums-public/forums-public.ts`
- ⏳ `src/app/pages/recrutement-public/recrutement-public.ts`

### 5. Mettre à jour les notifications dans les composants TypeScript

Remplacer les messages de notification par des traductions:

```typescript
// Avant
this.notificationService.success('✅ Message publié avec succès !');

// Après
import { TranslateService } from '@ngx-translate/core';

constructor(private translate: TranslateService) {}

this.translate.get('FORUMS.NOTIFICATIONS.MESSAGE_PUBLISHED').subscribe(msg => {
  this.notificationService.success(msg);
});
```

## 🎨 Utilisation du Pipe translate

### Dans les templates HTML

```html
<!-- Texte simple -->
<p>{{ 'FORUMS.TITLE' | translate }}</p>

<!-- Avec paramètres -->
<p>{{ 'FORUMS.MESSAGES_COUNT' | translate:{count: messages.length} }}</p>

<!-- Dans les attributs -->
<input [placeholder]="'FORUMS.SEARCH_PLACEHOLDER' | translate" />
<button [title]="'FORUMS.INTERACTIONS.LIKE' | translate">...</button>
```

### Dans les composants TypeScript

```typescript
import { TranslateService } from '@ngx-translate/core';

constructor(private translate: TranslateService) {}

// Traduction synchrone (si déjà chargée)
const text = this.translate.instant('FORUMS.TITLE');

// Traduction asynchrone (recommandé)
this.translate.get('FORUMS.TITLE').subscribe(text => {
  console.log(text);
});

// Traduction avec paramètres
this.translate.get('FORUMS.MESSAGES_COUNT', {count: 5}).subscribe(text => {
  console.log(text); // "5 messages"
});
```

## 🔧 Fonctionnalités du Service de Traduction

```typescript
import { TranslationService } from './services/translation.service';

constructor(private translationService: TranslationService) {}

// Changer de langue
this.translationService.setLanguage('en'); // ou 'fr'

// Obtenir la langue actuelle
const currentLang = this.translationService.getCurrentLanguage();

// Basculer entre FR et EN
this.translationService.toggleLanguage();

// Obtenir les langues disponibles
const langs = this.translationService.getAvailableLanguages(); // ['fr', 'en']
```

## 📦 Structure des Fichiers de Traduction

Les fichiers JSON sont organisés par sections:

```json
{
  "HEADER": { ... },           // Navigation principale
  "FORUMS": {                  // Page forums
    "TITLE": "...",
    "INTERACTIONS": { ... },   // Sous-section interactions
    "MODAL": { ... },          // Sous-section modals
    "NOTIFICATIONS": { ... }   // Sous-section notifications
  },
  "RECRUITMENT": {             // Page recrutement
    "MODAL": { ... }
  },
  "COMMON": { ... }            // Éléments communs
}
```

## 🚀 Pour Tester

1. Démarrer l'application:
```bash
cd angular-app/frontend/angular-app
ng serve
```

2. Ouvrir `http://localhost:4200`

3. Cliquer sur le bouton FR/EN dans le header pour changer de langue

4. La langue est sauvegardée dans le localStorage et persiste entre les sessions

## 📝 Ajouter de Nouvelles Traductions

1. Ajouter la clé dans `fr.json`:
```json
{
  "FORUMS": {
    "NEW_KEY": "Nouveau texte en français"
  }
}
```

2. Ajouter la même clé dans `en.json`:
```json
{
  "FORUMS": {
    "NEW_KEY": "New text in English"
  }
}
```

3. Utiliser dans le template:
```html
<p>{{ 'FORUMS.NEW_KEY' | translate }}</p>
```

## ⚠️ Points Importants

1. **Toujours ajouter TranslateModule** dans les imports du composant
2. **Utiliser des clés en MAJUSCULES** avec des points pour la hiérarchie
3. **Garder la même structure** dans fr.json et en.json
4. **Tester les deux langues** après chaque modification
5. **La langue est sauvegardée** dans localStorage automatiquement

## 🎯 Prochaines Étapes

1. ✅ Installer les dépendances
2. ✅ Créer les fichiers de traduction
3. ✅ Créer le service et le composant language-switcher
4. ✅ Configurer l'application
5. ⏳ Mettre à jour le header avec les traductions
6. ⏳ Mettre à jour la page forums avec les traductions
7. ⏳ Mettre à jour la page recrutement avec les traductions
8. ⏳ Mettre à jour les notifications dans les composants TypeScript
9. ⏳ Tester les deux langues sur toutes les pages

## 📚 Documentation

- [ngx-translate Documentation](https://github.com/ngx-translate/core)
- [Angular i18n Guide](https://angular.io/guide/i18n)
