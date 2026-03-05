@echo off
chcp 65001 >nul
echo ========================================
echo   DIAGNOSTIC CONFIGURATION ANGULAR
echo ========================================
echo.

echo [1] Vérification des fichiers d'environnement...
echo.

echo --- Back-Office environment.ts ---
type angular-app\back-office\src\environments\environment.ts
echo.
echo.

echo --- Back-Office environment.prod.ts ---
type angular-app\back-office\src\environments\environment.prod.ts
echo.
echo.

echo [2] Vérification du service Forum...
echo.
findstr /n "apiUrl" angular-app\back-office\src\app\services\forum.service.ts
echo.
echo.

echo [3] Test des URLs du Gateway...
echo.

echo Test Forum via Gateway:
curl -s http://localhost:8086/forum/api/forum/forums
echo.
echo.

echo Test Recrutement via Gateway:
curl -s http://localhost:8086/recrutement/api/recrutement/offres
echo.
echo.

echo [4] Vérification Eureka...
echo.
curl -s http://localhost:8761/eureka/apps -H "Accept: application/json" > eureka_check.json 2>nul
if exist eureka_check.json (
    echo Services enregistrés dans Eureka:
    findstr /i "forum-service recrutement-service api-gateway" eureka_check.json
    del eureka_check.json >nul 2>&1
) else (
    echo ❌ Impossible de contacter Eureka
)
echo.
echo.

echo ========================================
echo   INSTRUCTIONS
echo ========================================
echo.
echo Si les URLs ci-dessus montrent des données JSON, le backend fonctionne.
echo.
echo Si l'application Angular montre toujours l'erreur 404:
echo.
echo 1. Arrêtez l'application Angular (Ctrl+C)
echo 2. Supprimez le dossier .angular/cache:
echo    rmdir /s /q angular-app\back-office\.angular\cache
echo.
echo 3. Redémarrez Angular:
echo    cd angular-app\back-office
echo    ng serve
echo.
echo 4. Dans le navigateur:
echo    - Ouvrez DevTools (F12)
echo    - Allez dans Application ^> Storage ^> Clear site data
echo    - Ou appuyez sur Ctrl+Shift+R (hard reload)
echo.
pause
