@echo off
echo ========================================
echo   Demarrage de l'application complete
echo ========================================
echo.

echo [1/5] Demarrage de MySQL...
net start MySQL80
if %errorlevel% neq 0 (
    echo ERREUR: MySQL n'a pas pu demarrer
    pause
    exit /b 1
)
echo MySQL demarre avec succes!
echo.

echo [2/5] Demarrage du Forum Service...
start "Forum Service" cmd /k "cd forum-service && mvn spring-boot:run"
timeout /t 5 /nobreak > nul
echo.

echo [3/5] Demarrage du Recrutement Service...
start "Recrutement Service" cmd /k "cd recrutement-service && mvn spring-boot:run"
timeout /t 5 /nobreak > nul
echo.

echo [4/5] Attente du demarrage des services (30 secondes)...
timeout /t 30 /nobreak
echo.

echo [5/5] Demarrage du Frontend Angular...
start "Angular Frontend" cmd /k "cd angular-app\frontend\angular-app && npm start"
echo.

echo ========================================
echo   Tous les services sont en cours de demarrage!
echo ========================================
echo.
echo Services:
echo - MySQL: Port 3306
echo - Forum Service: http://localhost:8082
echo - Recrutement Service: http://localhost:8083
echo - Frontend Angular: http://localhost:4200
echo.
echo Attendez quelques secondes puis ouvrez:
echo http://localhost:4200
echo.
echo Appuyez sur une touche pour fermer cette fenetre...
pause > nul
