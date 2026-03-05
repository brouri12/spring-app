-- Script pour fixer max_allowed_packet MAINTENANT
-- Exécutez ce script avec: mysql -u root -p < FIX_MYSQL_NOW.sql

-- 1. Augmenter pour la session actuelle
SET SESSION max_allowed_packet=67108864;

-- 2. Augmenter globalement (pour toutes les nouvelles connexions)
SET GLOBAL max_allowed_packet=67108864;

-- 3. Vérifier le changement
SHOW VARIABLES LIKE 'max_allowed_packet';

-- 4. Nettoyer les données de test
USE recrutement_db;
DELETE FROM candidature_enseignant;

-- 5. Afficher le résultat
SELECT 'Configuration terminée! Redémarrez maintenant votre backend.' as Message;
