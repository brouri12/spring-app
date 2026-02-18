-- ═══════════════════════════════════════════════════════════
-- NETTOYER LA BASE DE DONNÉES RECRUTEMENT
-- ═══════════════════════════════════════════════════════════

USE recrutement_db;

-- Supprimer toutes les candidatures (à cause de la clé étrangère)
DELETE FROM candidature_enseignant;

-- Supprimer toutes les offres
DELETE FROM offre_recrutement;

-- Vérifier que les tables sont vides
SELECT COUNT(*) as nb_candidatures FROM candidature_enseignant;
SELECT COUNT(*) as nb_offres FROM offre_recrutement;

-- ═══════════════════════════════════════════════════════════
-- Maintenant vous pouvez redémarrer le service
-- Les données de test seront réinsérées
-- ═══════════════════════════════════════════════════════════
