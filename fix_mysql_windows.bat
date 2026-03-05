@echo off
echo ========================================
echo Fix MySQL Packet Size - Windows
echo ========================================
echo.

echo Etape 1: Arret de MySQL...
net stop MySQL80
if %errorlevel% neq 0 (
    echo ERREUR: Impossible d'arreter MySQL. Executez ce script en tant qu'Administrateur!
    pause
    exit /b 1
)
echo MySQL arrete avec succes.
echo.

echo Etape 2: Demarrage de MySQL...
net start MySQL80
if %errorlevel% neq 0 (
    echo ERREUR: Impossible de demarrer MySQL!
    pause
    exit /b 1
)
echo MySQL demarre avec succes.
echo.

echo Etape 3: Verification de max_allowed_packet...
mysql -u root -p -e "SHOW VARIABLES LIKE 'max_allowed_packet';"
echo.

echo Etape 4: Nettoyage des donnees de test...
mysql -u root -p -e "USE recrutement_db; DELETE FROM candidature_enseignant;"
echo.

echo ========================================
echo Configuration terminee!
echo ========================================
echo.
echo Prochaines etapes:
echo 1. Redemarrez votre backend (mvn spring-boot:run)
echo 2. Rafraichissez votre navigateur (Ctrl+Shift+R)
echo 3. Testez avec un email unique
echo.
pause
