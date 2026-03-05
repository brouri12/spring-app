@echo off
chcp 65001 >nul
echo ========================================
echo   TEST APPLICATION COMPLÈTE
echo ========================================
echo.

echo Ce script va:
echo 1. Tester le backend (Gateway + Services)
echo 2. Vérifier la configuration Angular
echo 3. Vous guider pour tester dans le navigateur
echo.
pause

echo.
echo ========================================
echo   PARTIE 1: TEST BACKEND
echo ========================================
echo.

echo [1.1] Test Eureka...
curl -s http://localhost:8761 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Eureka accessible
) else (
    echo ❌ Eureka NON accessible
    echo.
    echo DÉMARREZ EUREKA:
    echo cd eureka-server
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
)

echo [1.2] Test Gateway...
curl -s http://localhost:8086/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Gateway accessible
) else (
    echo ❌ Gateway NON accessible
    echo.
    echo DÉMARREZ GATEWAY:
    echo cd api-gateway
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
)

echo [1.3] Test Forum Service...
curl -s http://localhost:8082/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Forum Service accessible
) else (
    echo ❌ Forum Service NON accessible
    echo.
    echo DÉMARREZ FORUM SERVICE:
    echo cd forum-service
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
)

echo [1.4] Test Recrutement Service...
curl -s http://localhost:8083/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Recrutement Service accessible
) else (
    echo ❌ Recrutement Service NON accessible
    echo.
    echo DÉMARREZ RECRUTEMENT SERVICE:
    echo cd recrutement-service
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   PARTIE 2: TEST GATEWAY ROUTING
echo ========================================
echo.

echo [2.1] Test Forum via Gateway...
curl -s http://localhost:8086/forum/api/forum/forums >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Forum accessible via Gateway
) else (
    echo ❌ Forum NON accessible via Gateway
    echo Vérifiez les logs du Gateway
)

echo [2.2] Test Recrutement via Gateway...
curl -s http://localhost:8086/recrutement/api/recrutement/offres >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Recrutement accessible via Gateway
) else (
    echo ❌ Recrutement NON accessible via Gateway
    echo Vérifiez les logs du Gateway
)

echo.
echo ========================================
echo   PARTIE 3: CONFIGURATION ANGULAR
echo ========================================
echo.

echo [3.1] Vérification environment.ts...
findstr "8086" angular-app\back-office\src\environments\environment.ts >nul
if %errorlevel% equ 0 (
    echo ✅ Port 8086 trouvé dans environment.ts
) else (
    echo ❌ Port 8086 NON trouvé dans environment.ts
    echo Le fichier n'a pas été mis à jour correctement
)

echo.
echo Configuration actuelle:
type angular-app\back-office\src\environments\environment.ts
echo.

echo.
echo ========================================
echo   PARTIE 4: INSTRUCTIONS NAVIGATEUR
echo ========================================
echo.
echo L'application Angular doit être démarrée avec:
echo   cd angular-app\back-office
echo   ng serve
echo.
echo Ensuite, dans le navigateur:
echo.
echo 1. Ouvrez: http://localhost:4200
echo.
echo 2. Ouvrez DevTools (F12)
echo.
echo 3. Allez dans l'onglet Network
echo.
echo 4. Cochez "Disable cache"
echo.
echo 5. Videz le cache: Ctrl+Shift+R
echo.
echo 6. Naviguez vers la page Forum
echo.
echo 7. Dans Network, vérifiez les URLs:
echo    ✅ Doit voir: http://localhost:8086/forum/api/forum/forums
echo    ❌ Ne doit PAS voir: http://localhost:8080/...
echo    ❌ Ne doit PAS voir: http://localhost:8082/...
echo.
echo 8. Vérifiez le Status:
echo    ✅ Doit être: 200 OK
echo    ❌ Si 404: Problème de routing Gateway
echo    ❌ Si 503: Service non trouvé dans Eureka
echo    ❌ Si CORS: Problème de configuration CORS
echo.
echo ========================================
echo   URLS À TESTER DANS LE NAVIGATEUR
echo ========================================
echo.
echo Backend (doivent montrer du JSON):
echo   http://localhost:8761 (Eureka Dashboard)
echo   http://localhost:8086/forum/api/forum/forums
echo   http://localhost:8086/recrutement/api/recrutement/offres
echo.
echo Frontend:
echo   http://localhost:4200 (Application Angular)
echo.
pause

echo.
echo Voulez-vous ouvrir ces URLs dans le navigateur ? (O/N)
set /p open="Votre choix: "

if /i "%open%"=="O" (
    start http://localhost:8761
    timeout /t 2 /nobreak >nul
    start http://localhost:8086/forum/api/forum/forums
    timeout /t 2 /nobreak >nul
    start http://localhost:4200
)

echo.
echo ========================================
echo   FIN DU TEST
echo ========================================
