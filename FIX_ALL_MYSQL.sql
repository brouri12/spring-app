-- Script Complet pour Résoudre le Problème

-- 1. Augmenter la taille des paquets MySQL
SET GLOBAL max_allowed_packet=16777216;
SET SESSION max_allowed_packet=16777216;

-- 2. Vérifier la modification
SHOW VARIABLES LIKE 'max_allowed_packet';

-- 3. Utiliser la base de données
USE recrutement_db;

-- 4. Voir les candidatures existantes
SELECT id, nom_candidat, prenom_candidat, email, cv_filename 
FROM candidature_enseignant;

-- 5. Supprimer toutes les candidatures de test
DELETE FROM candidature_enseignant;

-- 6. Vérifier que la table est vide
SELECT COUNT(*) as nombre_candidatures FROM candidature_enseignant;

-- 7. Vérifier la structure de la table
DESCRIBE candidature_enseignant;

-- 8. Vérifier les contraintes
SHOW CREATE TABLE candidature_enseignant;

-- Résultat attendu:
-- max_allowed_packet devrait être 16777216
-- La table candidature_enseignant devrait être vide
-- Les colonnes cv_pdf, cv_filename, cv_content_type devraient exister
-- La colonne cv_url NE devrait PAS exister
