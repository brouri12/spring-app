@echo off
chcp 65001 >nul
echo ========================================
echo   NETTOYAGE ET REDÉMARRAGE ANGULAR
echo ========================================
echo.

echo ⚠️  Ce script va:
echo   1. Supprimer le cache Angular
echo   2. Redémarrer l'application
echo.
echo Assurez-vous d'avoir arrêté l'application Angular (Ctrl+C)
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

echo [2/3] Vérification de la configuration...
echo.
echo Configuration actuelle (environment.ts):
type angular-app\back-office\src\environments\environment.ts
echo.
echo.

echo [3/3] Démarrage de l'application...
echo.
echo ⚠️  IMPORTANT: Après le démarrage, dans le navigateur:
echo   1. Ouvrez DevTools (F12)
echo   2. Clic droit sur le bouton Refresh
echo   3. Sélectionnez "Empty Cache and Hard Reload"
echo   OU appuyez sur Ctrl+Shift+R
echo.
pause

cd angular-app\back-office
echo Démarrage de ng serve...
echo.
ng serve
