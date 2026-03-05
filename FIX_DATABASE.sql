-- Solution 1: Rendre cv_url nullable
ALTER TABLE candidature_enseignant MODIFY COLUMN cv_url VARCHAR(500) NULL;

-- OU Solution 2: Supprimer complètement cv_url (recommandé car on utilise cv_pdf)
-- ALTER TABLE candidature_enseignant DROP COLUMN cv_url;
