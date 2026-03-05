# Guide de Démarrage du Backend Forum Service

## Problème
Maven (mvn) n'est pas disponible en ligne de commande sur votre système Windows.

## Solutions

### Solution 1: Démarrer depuis IntelliJ IDEA (RECOMMANDÉ)
1. Ouvrez IntelliJ IDEA
2. Ouvrez le projet `forum-service`
3. Attendez que Maven télécharge les dépendances
4. Localisez la classe principale: `src/main/java/tn/esprit/forum/ForumServiceApplication.java`
5. Cliquez droit sur la classe → "Run 'ForumServiceApplication'"
6. Le service démarrera sur http://localhost:8082

### Solution 2: Installer Maven
1. Téléchargez Maven depuis: https://maven.apache.org/download.cgi
2. Extrayez l'archive dans `C:\Program Files\Apache\maven`
3. Ajoutez au PATH système: `C:\Program Files\Apache\maven\bin`
4. Redémarrez PowerShell
5. Vérifiez: `mvn -version`
6. Puis exécutez:
```powershell
cd forum-service
mvn clean install
mvn spring-boot:run
```

### Solution 3: Utiliser Maven depuis IntelliJ en ligne de commande
Si IntelliJ IDEA est installé, Maven est inclus. Trouvez le chemin:
```powershell
# Exemple de chemin (à adapter selon votre installation)
& "C:\Program Files\JetBrains\IntelliJ IDEA\plugins\maven\lib\maven3\bin\mvn.cmd" -version
```

## État Actuel
✅ Frontend Angular: http://localhost:56322/ (EN COURS)
✅ Back-office Angular: http://localhost:4201/ (EN COURS)
❌ Forum Service: http://localhost:8082 (À DÉMARRER)

## Vérification
Une fois le backend démarré, testez:
```powershell
Invoke-WebRequest -Uri "http://localhost:8082/api/forum/forums" -Method GET
```

## Services et Interfaces
Les services et interfaces de traduction sont correctement configurés dans les deux applications Angular:

### Frontend (http://localhost:56322/)
- ✅ TranslationService configuré
- ✅ LanguageSwitcherComponent créé
- ✅ Fichiers fr.json et en.json avec traductions complètes
- ✅ CustomTranslateLoader configuré dans app.config.ts
- ✅ Langue sauvegardée dans localStorage avec clé 'app-language'

### Back-office (http://localhost:4201/)
- ✅ TranslationService configuré
- ✅ LanguageSwitcherComponent créé
- ✅ Fichiers fr.json et en.json (traduction du titre)
- ✅ CustomTranslateLoader configuré dans app.config.ts
- ✅ Langue sauvegardée dans localStorage avec clé 'backoffice-language'

## Pourquoi les services ne s'affichent pas?
Si vous ne voyez pas le bouton de changement de langue ou les traductions:

1. **Vider le cache du navigateur**: Ctrl + Shift + R
2. **Vérifier la console du navigateur** (F12) pour voir les erreurs
3. **Vérifier que les fichiers JSON sont chargés**: 
   - Ouvrez F12 → Network → Filtrez par "i18n"
   - Vous devriez voir les requêtes vers `/assets/i18n/fr.json` et `/assets/i18n/en.json`

4. **Vérifier que le composant est importé**:
   - Frontend: Le LanguageSwitcher doit être dans le header
   - Back-office: Le LanguageSwitcher doit être dans la topbar

## Prochaines Étapes
Une fois le backend démarré, vous pourrez:
- Tester les fonctionnalités avancées du forum (likes, réponses, signalements)
- Voir les statistiques et badges
- Utiliser la traduction FR/EN dans toute l'application
