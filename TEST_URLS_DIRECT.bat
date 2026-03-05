@echo off
chcp 65001 >nul
echo ========================================
echo   TEST DIRECT DES URLS
echo ========================================
echo.

echo [1] Test Eureka Server...
curl -s http://localhost:8761 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Eureka accessible
) else (
    echo ❌ Eureka NON accessible - Démarrez-le !
    pause
    exit /b 1
)
echo.

echo [2] Test API Gateway Health...
curl -s http://localhost:8086/actuator/health
echo.
echo.

echo [3] Test Forum Service Direct...
echo URL: http://localhost:8082/api/forum/forums
curl -s http://localhost:8082/api/forum/forums
echo.
echo.

echo [4] Test Forum via Gateway...
echo URL: http://localhost:8086/forum/api/forum/forums
curl -s http://localhost:8086/forum/api/forum/forums
echo.
echo.

echo [5] Test Recrutement Service Direct...
echo URL: http://localhost:8083/api/recrutement/offres
curl -s http://localhost:8083/api/recrutement/offres
echo.
echo.

echo [6] Test Recrutement via Gateway...
echo URL: http://localhost:8086/recrutement/api/recrutement/offres
curl -s http://localhost:8086/recrutement/api/recrutement/offres
echo.
echo.

echo [7] Vérifier les routes du Gateway...
echo URL: http://localhost:8086/actuator/gateway/routes
curl -s http://localhost:8086/actuator/gateway/routes
echo.
echo.

echo ========================================
echo   ANALYSE
echo ========================================
echo.
echo Si vous voyez du JSON ci-dessus, le backend fonctionne.
echo Si vous voyez des erreurs 404, le problème est dans le Gateway.
echo.
echo Ouvrez maintenant dans le navigateur:
echo http://localhost:8086/forum/api/forum/forums
echo.
pause

start http://localhost:8086/forum/api/forum/forums
