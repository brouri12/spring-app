-- ========================================
-- SCRIPT DE CRÉATION DES BASES DE DONNÉES
-- ========================================

-- Création de la base de données pour Forum Service
CREATE DATABASE IF NOT EXISTS forum_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Création de la base de données pour Recrutement Service
CREATE DATABASE IF NOT EXISTS recrutement_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Vérification des bases créées
SHOW DATABASES;

-- Sélectionner la base forum_db
USE forum_db;

-- Afficher les tables (après le premier lancement du service)
-- SHOW TABLES;

-- Sélectionner la base recrutement_db
USE recrutement_db;

-- Afficher les tables (après le premier lancement du service)
-- SHOW TABLES;

-- ========================================
-- REQUÊTES DE VÉRIFICATION (Optionnel)
-- ========================================

-- Vérifier les forums insérés
-- USE forum_db;
-- SELECT * FROM forum;
-- SELECT * FROM message_forum;

-- Vérifier les offres et candidatures insérées
-- USE recrutement_db;
-- SELECT * FROM offre_recrutement;
-- SELECT * FROM candidature_enseignant;

-- ========================================
-- NETTOYAGE (Si besoin de recommencer)
-- ========================================

-- ATTENTION : Ces commandes suppriment toutes les données !
-- DROP DATABASE IF EXISTS forum_db;
-- DROP DATABASE IF EXISTS recrutement_db;
