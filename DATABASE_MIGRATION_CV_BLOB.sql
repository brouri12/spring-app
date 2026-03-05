-- Migration Script: Change CV from URL to BLOB storage
-- Database: recrutement_db
-- Date: 2026-02-21

-- Step 1: Add new columns for BLOB storage
ALTER TABLE candidature_enseignant 
ADD COLUMN cv_pdf LONGBLOB AFTER email,
ADD COLUMN cv_filename VARCHAR(255) AFTER cv_pdf,
ADD COLUMN cv_content_type VARCHAR(100) AFTER cv_filename;

-- Step 2: Drop the old cv_url column
ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url;

-- Verify the changes
DESCRIBE candidature_enseignant;

-- Expected columns:
-- id, nom_candidat, prenom_candidat, email, cv_pdf, cv_filename, cv_content_type, 
-- lettre_motivation, date_candidature, statut, offre_id
