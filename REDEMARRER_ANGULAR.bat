@echo off
chcp 65001 >nul
echo ========================================
echo   REDÉMARRAGE APPLICATION ANGULAR
echo ========================================
echo.
echo Les fichiers d'environnement ont été mis à jour avec :
echo   - Port Gateway : 8086
echo   - Forum URL : http://localhost:8086/forum/api/forum
echo   - Recrutement URL : http://localhost:8086/recrutement/api/recrutement
echo.
echo ⚠️  Arrêtez d'abord l'application Angular (Ctrl+C dans son terminal)
echo.
pause

echo.
echo Quelle application voulez-vous démarrer ?
echo.
echo 1. Back-Office (port 4200)
echo 2. Frontend (port 4201)
echo 3. Les deux
echo.
set /p choice="Votre choix (1, 2 ou 3) : "

if "%choice%"=="1" goto backoffice
if "%choice%"=="2" goto frontend
if "%choice%"=="3" goto both
goto end

:backoffice
echo.
echo Démarrage du Back-Office...
cd angular-app\back-office
start "Angular Back-Office - Port 4200" cmd /k "ng serve"
goto end

:frontend
echo.
echo Démarrage du Frontend...
cd angular-app\frontend\angular-app
start "Angular Frontend - Port 4201" cmd /k "ng serve --port 4201"
goto end

:both
echo.
echo Démarrage du Back-Office...
cd angular-app\back-office
start "Angular Back-Office - Port 4200" cmd /k "ng serve"
cd ..\..
echo.
echo Démarrage du Frontend...
cd angular-app\frontend\angular-app
start "Angular Frontend - Port 4201" cmd /k "ng serve --port 4201"
goto end

:end
echo.
echo ========================================
echo   APPLICATIONS DÉMARRÉES
echo ========================================
echo.
echo Attendez quelques secondes, puis ouvrez :
echo   - Back-Office : http://localhost:4200
echo   - Frontend : http://localhost:4201
echo.
echo Vérifiez la console du navigateur (F12) pour voir les requêtes HTTP.
echo.
pause
