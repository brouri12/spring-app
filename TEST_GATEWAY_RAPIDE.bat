@echo off
chcp 65001 >nul
echo ========================================
echo   TEST RAPIDE API GATEWAY
echo ========================================
echo.

echo [1] Test Gateway Health...
curl -s http://localhost:8086/actuator/health
echo.
echo.

echo [2] Test Forum via Gateway...
echo URL: http://localhost:8086/forum/api/forum
echo.
curl -s http://localhost:8086/forum/api/forum
echo.
echo.

echo [3] Test Recrutement via Gateway...
echo URL: http://localhost:8086/recrutement/api/recrutement/offres
echo.
curl -s http://localhost:8086/recrutement/api/recrutement/offres
echo.
echo.

echo [4] Voir les Routes du Gateway...
echo URL: http://localhost:8086/actuator/gateway/routes
echo.
curl -s http://localhost:8086/actuator/gateway/routes
echo.
echo.

echo ========================================
echo   TEST TERMINÉ
echo ========================================
echo.
echo Si vous voyez des données JSON ci-dessus, tout fonctionne ! ✅
echo Si vous voyez des erreurs 404, redémarrez le Gateway.
echo.
pause
