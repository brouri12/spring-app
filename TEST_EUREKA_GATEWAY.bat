@echo off
chcp 65001 >nul
echo ========================================
echo   TEST EUREKA SERVER ET API GATEWAY
echo ========================================
echo.

REM Vérifier MySQL
echo [1/5] Vérification de MySQL...
net start | find "MySQL" >nul
if %errorlevel% neq 0 (
    echo ❌ MySQL n'est pas démarré !
    echo Démarrez MySQL avec : net start MySQL80
    pause
    exit /b 1
) else (
    echo ✅ MySQL est démarré
)
echo.

REM Vérifier Eureka Server
echo [2/5] Test Eureka Server (http://localhost:8761)...
timeout /t 2 /nobreak >nul
curl -s http://localhost:8761 >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Eureka Server n'est pas accessible !
    echo.
    echo DÉMARREZ EUREKA SERVER :
    echo cd eureka-server
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Eureka Server est accessible
)
echo.

REM Vérifier Forum Service
echo [3/5] Test Forum Service (http://localhost:8082)...
timeout /t 2 /nobreak >nul
curl -s http://localhost:8082/actuator/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Forum Service n'est pas accessible !
    echo.
    echo DÉMARREZ FORUM SERVICE :
    echo cd forum-service
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Forum Service est accessible
)
echo.

REM Vérifier Recrutement Service
echo [4/5] Test Recrutement Service (http://localhost:8083)...
timeout /t 2 /nobreak >nul
curl -s http://localhost:8083/actuator/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Recrutement Service n'est pas accessible !
    echo.
    echo DÉMARREZ RECRUTEMENT SERVICE :
    echo cd recrutement-service
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Recrutement Service est accessible
)
echo.

REM Vérifier API Gateway
echo [5/5] Test API Gateway (http://localhost:8086)...
timeout /t 2 /nobreak >nul
curl -s http://localhost:8086/actuator/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ API Gateway n'est pas accessible !
    echo.
    echo DÉMARREZ API GATEWAY :
    echo cd api-gateway
    echo mvnw spring-boot:run
    echo.
    pause
    exit /b 1
) else (
    echo ✅ API Gateway est accessible
)
echo.

echo ========================================
echo   VÉRIFICATION DES SERVICES DANS EUREKA
echo ========================================
echo.
echo Récupération des services enregistrés dans Eureka...
echo.

curl -s http://localhost:8761/eureka/apps -H "Accept: application/json" > eureka_apps.json 2>nul

if exist eureka_apps.json (
    echo ✅ Services enregistrés dans Eureka :
    echo.
    
    findstr /i "forum-service" eureka_apps.json >nul
    if %errorlevel% equ 0 (
        echo   ✅ FORUM-SERVICE est enregistré
    ) else (
        echo   ❌ FORUM-SERVICE n'est PAS enregistré
    )
    
    findstr /i "recrutement-service" eureka_apps.json >nul
    if %errorlevel% equ 0 (
        echo   ✅ RECRUTEMENT-SERVICE est enregistré
    ) else (
        echo   ❌ RECRUTEMENT-SERVICE n'est PAS enregistré
    )
    
    findstr /i "api-gateway" eureka_apps.json >nul
    if %errorlevel% equ 0 (
        echo   ✅ API-GATEWAY est enregistré
    ) else (
        echo   ❌ API-GATEWAY n'est PAS enregistré
    )
    
    del eureka_apps.json >nul 2>&1
) else (
    echo ⚠️  Impossible de récupérer les services depuis Eureka
)
echo.

echo ========================================
echo   TEST DES ROUTES VIA API GATEWAY
echo ========================================
echo.

echo Test 1: Forum via Gateway (http://localhost:8086/forum/api/forum)...
curl -s http://localhost:8086/forum/api/forum >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Forum accessible via Gateway
) else (
    echo ❌ Forum non accessible via Gateway
    echo    Essayez aussi: http://localhost:8082/api/forum (direct)
)
echo.

echo Test 2: Recrutement via Gateway (http://localhost:8086/recrutement/api/recrutement/offres)...
curl -s http://localhost:8086/recrutement/api/recrutement/offres >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Recrutement accessible via Gateway
) else (
    echo ❌ Recrutement non accessible via Gateway
)
echo.

echo Test 3: Gateway Routes (http://localhost:8086/actuator/gateway/routes)...
curl -s http://localhost:8086/actuator/gateway/routes >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Routes Gateway accessibles
) else (
    echo ❌ Routes Gateway non accessibles
)
echo.

echo ========================================
echo   RÉSUMÉ DES URLS
echo ========================================
echo.
echo 📊 EUREKA DASHBOARD :
echo    http://localhost:8761
echo.
echo 🔧 API GATEWAY :
echo    http://localhost:8086
echo    http://localhost:8086/actuator/gateway/routes
echo.
echo 💬 FORUM SERVICE :
echo    Direct : http://localhost:8082/api/forum
echo    Via Gateway : http://localhost:8086/forum/api/forum
echo    Swagger : http://localhost:8082/swagger-ui.html
echo.
echo 👔 RECRUTEMENT SERVICE :
echo    Direct : http://localhost:8083/api/recrutement/offres
echo    Via Gateway : http://localhost:8086/recrutement/api/recrutement/offres
echo    Swagger : http://localhost:8083/swagger-ui.html
echo.
echo ========================================
echo   COMMANDES UTILES
echo ========================================
echo.
echo Voir les services dans Eureka (JSON) :
echo curl http://localhost:8761/eureka/apps -H "Accept: application/json"
echo.
echo Voir les routes du Gateway :
echo curl http://localhost:8086/actuator/gateway/routes
echo.
echo ========================================
pause
