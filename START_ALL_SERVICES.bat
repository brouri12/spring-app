@echo off
echo ========================================
echo   Demarrage de tous les services
echo ========================================
echo.

REM Verifier MySQL
echo [1/5] Verification de MySQL...
net start MySQL80 >nul 2>&1
if %errorlevel% equ 0 (
    echo MySQL est deja demarre
) else (
    echo Demarrage de MySQL...
    net start MySQL80
)
echo.

REM Demarrer Eureka Server
echo [2/5] Demarrage d'Eureka Server (port 8761)...
start "Eureka Server" cmd /k "cd eureka-server && mvn spring-boot:run"
timeout /t 30 /nobreak >nul
echo Eureka Server demarre
echo.

REM Demarrer Forum Service
echo [3/5] Demarrage du Forum Service (port 8082)...
start "Forum Service" cmd /k "cd forum-service && mvn spring-boot:run"
timeout /t 20 /nobreak >nul
echo Forum Service demarre
echo.

REM Demarrer Recrutement Service
echo [4/5] Demarrage du Recrutement Service (port 8083)...
start "Recrutement Service" cmd /k "cd recrutement-service && mvn spring-boot:run"
timeout /t 20 /nobreak >nul
echo Recrutement Service demarre
echo.

REM Demarrer API Gateway
echo [5/5] Demarrage de l'API Gateway (port 8080)...
start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run"
timeout /t 15 /nobreak >nul
echo API Gateway demarre
echo.

echo ========================================
echo   Tous les services sont demarres !
echo ========================================
echo.
echo Services disponibles :
echo - Eureka Server : http://localhost:8761
echo - Forum Service : http://localhost:8082/swagger-ui/index.html
echo - Recrutement Service : http://localhost:8083/swagger-ui/index.html
echo - API Gateway : http://localhost:8080
echo.
echo Pour demarrer le frontend Angular :
echo   cd angular-app\frontend\angular-app
echo   npm start
echo.
echo Appuyez sur une touche pour fermer cette fenetre...
pause >nul
