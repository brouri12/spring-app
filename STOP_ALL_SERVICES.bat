@echo off
echo ========================================
echo   Arret de tous les services
echo ========================================
echo.

echo Recherche et arret des processus Java (Spring Boot)...

REM Arreter les processus sur les ports specifiques
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8761') do (
    echo Arret d'Eureka Server (port 8761)...
    taskkill /PID %%a /F >nul 2>&1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8082') do (
    echo Arret du Forum Service (port 8082)...
    taskkill /PID %%a /F >nul 2>&1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8083') do (
    echo Arret du Recrutement Service (port 8083)...
    taskkill /PID %%a /F >nul 2>&1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
    echo Arret de l'API Gateway (port 8080)...
    taskkill /PID %%a /F >nul 2>&1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr :4200') do (
    echo Arret du Frontend Angular (port 4200)...
    taskkill /PID %%a /F >nul 2>&1
)

echo.
echo ========================================
echo   Tous les services sont arretes !
echo ========================================
echo.
pause
