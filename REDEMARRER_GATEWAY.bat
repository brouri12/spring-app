@echo off
chcp 65001 >nul
echo ========================================
echo   REDÉMARRAGE API GATEWAY
echo ========================================
echo.
echo ⚠️  Arrêtez d'abord le Gateway en cours (Ctrl+C dans son terminal)
echo.
pause

echo Démarrage de l'API Gateway avec la nouvelle configuration...
echo.
cd api-gateway
echo Configuration mise à jour : StripPrefix=1
echo.
echo URLs à tester après démarrage :
echo   - http://localhost:8086/forum/api/forum
echo   - http://localhost:8086/recrutement/api/recrutement/offres
echo.
mvnw spring-boot:run
