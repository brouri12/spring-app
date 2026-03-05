@echo off
chcp 65001 >nul
echo ========================================
echo   DÉMARRAGE DE TOUS LES SERVICES
echo ========================================
echo.
echo Ce script va ouvrir 4 fenêtres CMD pour :
echo   1. Eureka Server (port 8761)
echo   2. Forum Service (port 8082)
echo   3. Recrutement Service (port 8083)
echo   4. API Gateway (port 8086)
echo.
echo ⚠️  IMPORTANT : Vérifiez que MySQL est démarré !
echo.
pause

REM Vérifier MySQL
net start | find "MySQL" >nul
if %errorlevel% neq 0 (
    echo ❌ MySQL n'est pas démarré !
    echo Démarrez MySQL avec : net start MySQL80
    pause
    exit /b 1
)

echo ✅ MySQL est démarré
echo.
echo Démarrage des services...
echo.

REM Démarrer Eureka Server
echo [1/4] Démarrage Eureka Server...
start "Eureka Server - Port 8761" cmd /k "cd eureka-server && echo Démarrage Eureka Server... && mvnw spring-boot:run"
timeout /t 5 /nobreak >nul

REM Attendre que Eureka soit prêt
echo Attente du démarrage d'Eureka (30 secondes)...
timeout /t 30 /nobreak >nul

REM Démarrer Forum Service
echo [2/4] Démarrage Forum Service...
start "Forum Service - Port 8082" cmd /k "cd forum-service && echo Démarrage Forum Service... && mvnw spring-boot:run"
timeout /t 5 /nobreak >nul

REM Démarrer Recrutement Service
echo [3/4] Démarrage Recrutement Service...
start "Recrutement Service - Port 8083" cmd /k "cd recrutement-service && echo Démarrage Recrutement Service... && mvnw spring-boot:run"
timeout /t 5 /nobreak >nul

REM Attendre que les services soient prêts
echo Attente du démarrage des services (40 secondes)...
timeout /t 40 /nobreak >nul

REM Démarrer API Gateway
echo [4/4] Démarrage API Gateway...
start "API Gateway - Port 8086" cmd /k "cd api-gateway && echo Démarrage API Gateway... && mvnw spring-boot:run"

echo.
echo ========================================
echo   TOUS LES SERVICES SONT EN COURS DE DÉMARRAGE
echo ========================================
echo.
echo Attendez environ 2 minutes que tous les services soient prêts.
echo.
echo Ensuite, exécutez : TEST_EUREKA_GATEWAY.bat
echo.
echo Ou ouvrez dans votre navigateur :
echo   http://localhost:8761  (Eureka Dashboard)
echo.
pause
