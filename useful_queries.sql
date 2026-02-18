-- ========================================
-- REQUÊTES SQL UTILES POUR LES MICROSERVICES
-- ========================================

-- ========================================
-- FORUM SERVICE - forum_db
-- ========================================

USE forum_db;

-- 1. Voir tous les forums
SELECT * FROM forum;

-- 2. Voir tous les messages
SELECT * FROM message_forum;

-- 3. Compter les forums par statut
SELECT statut, COUNT(*) as nombre
FROM forum
GROUP BY statut;

-- 4. Compter les messages par forum
SELECT f.titre, COUNT(m.id_message) as nombre_messages
FROM forum f
LEFT JOIN message_forum m ON f.id_forum = m.forum_id
GROUP BY f.id_forum, f.titre
ORDER BY nombre_messages DESC;

-- 5. Forums les plus actifs (avec le plus de messages)
SELECT f.id_forum, f.titre, f.niveau, COUNT(m.id_message) as nombre_messages
FROM forum f
LEFT JOIN message_forum m ON f.id_forum = m.forum_id
WHERE f.statut = 'OUVERT'
GROUP BY f.id_forum, f.titre, f.niveau
ORDER BY nombre_messages DESC
LIMIT 5;

-- 6. Messages par type d'auteur
SELECT type_auteur, COUNT(*) as nombre
FROM message_forum
WHERE statut = 'ACTIF'
GROUP BY type_auteur;

-- 7. Forums créés aujourd'hui
SELECT * FROM forum
WHERE date_creation = CURDATE();

-- 8. Messages publiés dans les dernières 24h
SELECT * FROM message_forum
WHERE date_message >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
ORDER BY date_message DESC;

-- 9. Forums par niveau
SELECT niveau, COUNT(*) as nombre
FROM forum
GROUP BY niveau
ORDER BY niveau;

-- 10. Rechercher un forum par titre
SELECT * FROM forum
WHERE titre LIKE '%Java%';

-- ========================================
-- RECRUTEMENT SERVICE - recrutement_db
-- ========================================

USE recrutement_db;

-- 11. Voir toutes les offres
SELECT * FROM offre_recrutement;

-- 12. Voir toutes les candidatures
SELECT * FROM candidature_enseignant;

-- 13. Offres par statut
SELECT statut, COUNT(*) as nombre
FROM offre_recrutement
GROUP BY statut;

-- 14. Candidatures par statut
SELECT statut, COUNT(*) as nombre
FROM candidature_enseignant
GROUP BY statut;

-- 15. Offres avec le nombre de candidatures
SELECT o.id_offre, o.titre, o.specialite, COUNT(c.id_candidature) as nombre_candidatures
FROM offre_recrutement o
LEFT JOIN candidature_enseignant c ON o.id_offre = c.offre_id
GROUP BY o.id_offre, o.titre, o.specialite
ORDER BY nombre_candidatures DESC;

-- 16. Candidatures acceptées
SELECT c.nom_candidat, c.prenom_candidat, c.email, o.titre, o.specialite
FROM candidature_enseignant c
JOIN offre_recrutement o ON c.offre_id = o.id_offre
WHERE c.statut = 'ACCEPTEE';

-- 17. Offres ouvertes par spécialité
SELECT specialite, COUNT(*) as nombre
FROM offre_recrutement
WHERE statut = 'OUVERTE'
GROUP BY specialite;

-- 18. Candidatures en attente
SELECT c.id_candidature, c.nom_candidat, c.prenom_candidat, c.email, 
       o.titre as offre_titre, c.date_candidature
FROM candidature_enseignant c
JOIN offre_recrutement o ON c.offre_id = o.id_offre
WHERE c.statut = 'EN_ATTENTE'
ORDER BY c.date_candidature DESC;

-- 19. Offres publiées ce mois
SELECT * FROM offre_recrutement
WHERE MONTH(date_publication) = MONTH(CURDATE())
  AND YEAR(date_publication) = YEAR(CURDATE());

-- 20. Candidats ayant postulé plusieurs fois (détection doublons)
SELECT email, COUNT(*) as nombre_candidatures
FROM candidature_enseignant
GROUP BY email
HAVING COUNT(*) > 1;

-- ========================================
-- STATISTIQUES GLOBALES
-- ========================================

-- 21. Résumé Forum Service
USE forum_db;
SELECT 
    (SELECT COUNT(*) FROM forum) as total_forums,
    (SELECT COUNT(*) FROM forum WHERE statut = 'OUVERT') as forums_ouverts,
    (SELECT COUNT(*) FROM message_forum) as total_messages,
    (SELECT COUNT(*) FROM message_forum WHERE statut = 'ACTIF') as messages_actifs;

-- 22. Résumé Recrutement Service
USE recrutement_db;
SELECT 
    (SELECT COUNT(*) FROM offre_recrutement) as total_offres,
    (SELECT COUNT(*) FROM offre_recrutement WHERE statut = 'OUVERTE') as offres_ouvertes,
    (SELECT COUNT(*) FROM candidature_enseignant) as total_candidatures,
    (SELECT COUNT(*) FROM candidature_enseignant WHERE statut = 'EN_ATTENTE') as candidatures_en_attente,
    (SELECT COUNT(*) FROM candidature_enseignant WHERE statut = 'ACCEPTEE') as candidatures_acceptees;

-- ========================================
-- REQUÊTES DE MAINTENANCE
-- ========================================

-- 23. Supprimer les forums fermés depuis plus de 6 mois
-- USE forum_db;
-- DELETE FROM forum 
-- WHERE statut = 'FERME' 
--   AND date_creation < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 24. Archiver les messages supprimés
-- USE forum_db;
-- UPDATE message_forum 
-- SET statut = 'ARCHIVE' 
-- WHERE statut = 'SUPPRIME' 
--   AND date_message < DATE_SUB(NOW(), INTERVAL 3 MONTH);

-- 25. Fermer automatiquement les offres anciennes
-- USE recrutement_db;
-- UPDATE offre_recrutement 
-- SET statut = 'FERMEE' 
-- WHERE statut = 'OUVERTE' 
--   AND date_publication < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- ========================================
-- REQUÊTES DE DÉPANNAGE
-- ========================================

-- 26. Vérifier la structure des tables
USE forum_db;
DESCRIBE forum;
DESCRIBE message_forum;

USE recrutement_db;
DESCRIBE offre_recrutement;
DESCRIBE candidature_enseignant;

-- 27. Vérifier les contraintes de clés étrangères
USE forum_db;
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'forum_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

USE recrutement_db;
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'recrutement_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 28. Vérifier la taille des bases de données
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema IN ('forum_db', 'recrutement_db')
GROUP BY table_schema;

-- ========================================
-- DONNÉES DE TEST SUPPLÉMENTAIRES
-- ========================================

-- 29. Insérer des forums de test
-- USE forum_db;
-- INSERT INTO forum (titre, description, date_creation, cree_par, niveau, groupe, cours, statut)
-- VALUES 
-- ('Test Forum 1', 'Description test 1', CURDATE(), 1, 'L1', 'TEST-A', 'Test Course', 'OUVERT'),
-- ('Test Forum 2', 'Description test 2', CURDATE(), 1, 'L2', 'TEST-B', 'Test Course', 'OUVERT'),
-- ('Test Forum 3', 'Description test 3', CURDATE(), 1, 'L3', 'TEST-C', 'Test Course', 'FERME');

-- 30. Insérer des offres de test
-- USE recrutement_db;
-- INSERT INTO offre_recrutement (titre, description, specialite, experience_min, date_publication, statut)
-- VALUES 
-- ('Test Offre 1', 'Description test 1', 'Test Specialite', 2, CURDATE(), 'OUVERTE'),
-- ('Test Offre 2', 'Description test 2', 'Test Specialite', 3, CURDATE(), 'OUVERTE'),
-- ('Test Offre 3', 'Description test 3', 'Test Specialite', 5, CURDATE(), 'FERMEE');
