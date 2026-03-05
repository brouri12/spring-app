@echo off
echo ========================================
echo   Redemarrage des Services Backend
echo ========================================
echo.

echo [1/4] Arret des services existants...
echo.

REM Arreter Forum Service (port 8082)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8082') do (
    echo Arret du Forum Service...
    taskkill /PID %%a /F >nul 2>&1
)

REM Arreter Recrutement Service (port 8083)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8083') do (
    echo Arret du Recrutement Service...
    taskkill /PID %%a /F >nul 2>&1
)

echo Services arretes
echo.
timeout /t 3 /nobreak >nul

echo [2/4] Rebuild du Forum Service...
cd forum-service
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo ERREUR lors du build du Forum Service
    pause
    exit /b 1
)
cd ..
echo.

echo [3/4] Rebuild du Recrutement Service...
cd recrutement-service
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo ERREUR lors du build du Recrutement Service
    pause
    exit /b 1
)
cd ..
echo.

echo [4/4] Demarrage des services...
echo.

REM Demarrer Forum Service
echo Demarrage du Forum Service (port 8082)...
start "Forum Service" cmd /k "cd forum-service && mvn spring-boot:run"
timeout /t 15 /nobreak >nul

REM Demarrer Recrutement Service
echo Demarrage du Recrutement Service (port 8083)...
start "Recrutement Service" cmd /k "cd recrutement-service && mvn spring-boot:run"
timeout /t 15 /nobreak >nul

echo.
echo ========================================
echo   Services redemarres avec succes !
echo ========================================
echo.
echo Services disponibles :
echo - Forum Service : http://localhost:8082/swagger-ui/index.html
echo - Recrutement Service : http://localhost:8083/swagger-ui/index.html
echo.
echo La configuration CORS accepte maintenant tous les ports localhost
echo Vous pouvez rafraichir votre application Angular
echo.
pause
