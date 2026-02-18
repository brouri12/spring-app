-- Script de correction du schéma MySQL
-- Exécutez ce script dans MySQL pour ajouter les colonnes manquantes

USE recrutement_db;

-- Vérifier la structure actuelle de la table
DESCRIBE offre_recrutement;

-- Ajouter les colonnes manquantes si elles n'existent pas
ALTER TABLE offre_recrutement 
ADD COLUMN IF NOT EXISTS date_limite DATE AFTER date_publication;

ALTER TABLE offre_recrutement 
ADD COLUMN IF NOT EXISTS experience_min INT AFTER type_contrat;

ALTER TABLE offre_recrutement 
ADD COLUMN IF NOT EXISTS salaire_min DOUBLE AFTER statut;

ALTER TABLE offre_recrutement 
ADD COLUMN IF NOT EXISTS salaire_max DOUBLE AFTER salaire_min;

-- Vérifier la structure mise à jour
DESCRIBE offre_recrutement;

-- Afficher les données existantes
SELECT * FROM offre_recrutement;
