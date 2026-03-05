@echo off
echo ========================================
echo   DEMARRAGE DES MICROSERVICES
echo ========================================
echo.

echo [1/4] Verification de MySQL...
net start | find "MySQL" >nul
if %errorlevel% neq 0 (
    echo MySQL n'est pas demarre. Demarrage...
    net start MySQL80
) else (
    echo MySQL est deja demarre.
)
echo.

echo [2/4] Verification d'Eureka Server...
echo Assurez-vous qu'Eureka Server tourne sur http://localhost:8761
echo.
pause

echo [3/4] Demarrage de Forum Service (Port 8082)...
start "Forum Service" cmd /k "cd forum-service && mvnw spring-boot:run"
timeout /t 5 >nul
echo.

echo [4/4] Demarrage de Recrutement Service (Port 8083)...
start "Recrutement Service" cmd /k "cd recrutement-service && mvnw spring-boot:run"
echo.

echo ========================================
echo   SERVICES EN COURS DE DEMARRAGE
echo ========================================
echo.
echo Forum Service: http://localhost:8082/api/forum
echo Recrutement Service: http://localhost:8083/api/recrutement/offres
echo Eureka Dashboard: http://localhost:8761
echo.
echo Attendez 30-60 secondes pour le demarrage complet...
echo.
pause
