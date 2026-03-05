@echo off
echo ========================================
echo   Demarrage du Frontend Angular
echo ========================================
echo.

cd angular-app\frontend\angular-app

REM Verifier si node_modules existe
if not exist "node_modules\" (
    echo Installation des dependances npm...
    call npm install
    echo.
)

echo Demarrage de l'application Angular...
echo L'application sera disponible sur : http://localhost:4200
echo.
echo Appuyez sur Ctrl+C pour arreter le serveur
echo.

call npm start
