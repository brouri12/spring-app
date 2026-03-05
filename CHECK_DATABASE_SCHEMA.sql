-- Check current database schema
USE recrutement_db;

-- Show all columns in candidature_enseignant table
DESCRIBE candidature_enseignant;

-- Check if cv_url column still exists
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'recrutement_db'
  AND TABLE_NAME = 'candidature_enseignant'
ORDER BY ORDINAL_POSITION;
