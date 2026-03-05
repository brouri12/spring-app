@echo off
chcp 65001 >nul
echo ========================================
echo   RÉPARATION ANGULAR - ACCÈS DIRECT
echo ========================================
echo.
echo La configuration a été changée pour accéder
echo directement aux services (sans passer par le Gateway).
echo.
echo Nouvelle configuration:
echo   - Forum: http://localhost:8082/api/forum
echo   - Recrutement: http://localhost:8083/api/recrutement
echo.
echo ⚠️  IMPORTANT: Arrêtez Angular maintenant (Ctrl+C dans son terminal)
echo.
pause

echo.
echo [1/3] Suppression du cache Angular...
if exist angular-app\back-office\.angular\cache (
    rmdir /s /q angular-app\back-office\.angular\cache
    echo ✅ Cache supprimé
) else (
    echo ℹ️  Pas de cache à supprimer
)
echo.

echo [2/3] Vérification de la nouvelle configuration...
echo.
type angular-app\back-office\src\environments\environment.ts
echo.
echo.

echo [3/3] Redémarrage d'Angular...
echo.
echo ⚠️  Après le démarrage:
echo   1. Ouvrez http://localhost:4200
echo   2. Appuyez sur Ctrl+Shift+R pour vider le cache du navigateur
echo   3. Les forums devraient s'afficher !
echo.
pause

cd angular-app\back-office
echo Démarrage de ng serve...
echo.
ng serve
