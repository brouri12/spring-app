# 🔧 Dépannage - Système de Traduction

## ❌ Erreur: Angular compilation initialization failed

### Symptôme
```
Error: Debug Failure. Expected C:/.../.tsbuildinfo === C:\...\.tsbuildinfo
```

### Solution
Nettoyer le cache Angular:

```bash
cd angular-app/frontend/angular-app
Remove-Item -Recurse -Force .angular
ng serve
```

## ❌ Erreur: Expected 0 arguments, but got 1

### Symptôme
```
TS2554: Expected 0 arguments, but got 1.
return new TranslateHttpLoader(http);
```

### Solution
✅ **CORRIGÉ** - Le TranslateHttpLoader nécessite 3 paramètres:

```typescript
export function HttpLoaderFactory(http: HttpClient) {
  return new TranslateHttpLoader(http, './assets/i18n/', '.json');
}
```

## ❌ Le bouton FR/EN n'apparaît pas

### Vérifications
1. Vérifier que `<app-language-switcher>` est dans le template
2. Vérifier que `LanguageSwitcherComponent` est dans les imports du composant
3. Vider le cache du navigateur: `Ctrl + Shift + R`

### Solution
```typescript
// Dans le composant .ts
import { LanguageSwitcherComponent } from '../language-switcher/language-switcher.component';

@Component({
  imports: [CommonModule, LanguageSwitcherComponent],
  ...
})
```

```html
<!-- Dans le template .html -->
<app-language-switcher></app-language-switcher>
```

## ❌ Les traductions ne changent pas

### Vérifications
1. Vérifier que `TranslateModule` est dans les imports
2. Vérifier que le pipe `| translate` est utilisé
3. Vérifier que les fichiers JSON existent dans `src/assets/i18n/`

### Solution
```typescript
// Dans le composant .ts
import { TranslateModule } from '@ngx-translate/core';

@Component({
  imports: [CommonModule, TranslateModule],
  ...
})
```

```html
<!-- Dans le template .html -->
<h1>{{ 'FORUMS.TITLE' | translate }}</h1>
```

## ❌ Erreur: Cannot find module '@ngx-translate/core'

### Solution
Installer les packages:

```bash
npm install @ngx-translate/core @ngx-translate/http-loader --save
```

## ❌ Les fichiers JSON ne se chargent pas

### Vérifications
1. Vérifier que les fichiers existent:
   - `src/assets/i18n/fr.json`
   - `src/assets/i18n/en.json`
2. Vérifier la configuration dans `app.config.ts`

### Solution
Vérifier que le HttpLoaderFactory est correctement configuré:

```typescript
export function HttpLoaderFactory(http: HttpClient) {
  return new TranslateHttpLoader(http, './assets/i18n/', '.json');
}

export const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(
      TranslateModule.forRoot({
        defaultLanguage: 'fr',
        loader: {
          provide: TranslateLoader,
          useFactory: HttpLoaderFactory,
          deps: [HttpClient]
        }
      })
    )
  ]
};
```

## ❌ La langue ne persiste pas après rechargement

### Vérification
Vérifier que le TranslationService sauvegarde dans localStorage:

```typescript
setLanguage(lang: string) {
  this.currentLang = lang;
  this.translate.use(lang);
  localStorage.setItem('app-language', lang); // Frontend
  // ou
  localStorage.setItem('backoffice-language', lang); // Back-office
}
```

## 🔄 Commandes Utiles

### Nettoyer le cache
```bash
# Angular cache
Remove-Item -Recurse -Force .angular

# Node modules cache
Remove-Item -Recurse -Force node_modules/.cache
```

### Réinstaller les dépendances
```bash
Remove-Item -Recurse -Force node_modules
npm install
```

### Rebuild complet
```bash
Remove-Item -Recurse -Force .angular
Remove-Item -Recurse -Force dist
ng build
```

## 📝 Checklist de Vérification

### Frontend
- [ ] Packages installés: `@ngx-translate/core`, `@ngx-translate/http-loader`
- [ ] Fichiers JSON créés: `src/assets/i18n/fr.json`, `src/assets/i18n/en.json`
- [ ] `app.config.ts` configuré avec TranslateModule
- [ ] `TranslationService` créé
- [ ] `LanguageSwitcherComponent` créé
- [ ] `TranslateModule` ajouté dans les composants qui l'utilisent
- [ ] Bouton `<app-language-switcher>` ajouté dans le header

### Back-Office
- [ ] Packages installés: `@ngx-translate/core`, `@ngx-translate/http-loader`
- [ ] Fichiers JSON créés: `src/assets/i18n/fr.json`, `src/assets/i18n/en.json`
- [ ] `app.config.ts` configuré avec TranslateModule
- [ ] `TranslationService` créé
- [ ] `LanguageSwitcherComponent` créé
- [ ] `TranslateModule` ajouté dans les composants qui l'utilisent
- [ ] Bouton `<app-language-switcher>` ajouté dans la topbar

## 🎯 Test Rapide

### 1. Vérifier la compilation
```bash
ng build --configuration development
```

Si ça compile sans erreur, c'est bon ✅

### 2. Démarrer le serveur
```bash
ng serve
```

### 3. Ouvrir le navigateur
```
http://localhost:4200
```

### 4. Tester le bouton FR/EN
- Cliquer sur le bouton
- Vérifier que les textes changent
- Rafraîchir la page (F5)
- Vérifier que la langue est conservée

## 📚 Documentation

- [ngx-translate GitHub](https://github.com/ngx-translate/core)
- [Angular i18n Guide](https://angular.io/guide/i18n)
- Voir `README_TRADUCTION.md` pour le guide complet

## 💡 Astuce

Si vous rencontrez des problèmes persistants:

1. Nettoyer tout:
```bash
Remove-Item -Recurse -Force .angular
Remove-Item -Recurse -Force node_modules
npm install
```

2. Redémarrer VS Code

3. Relancer `ng serve`

## ✅ Tout Fonctionne?

Si vous voyez le bouton FR/EN et que les traductions changent, félicitations! 🎉

Le système de traduction est opérationnel.
