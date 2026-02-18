-- Script pour recréer les tables MySQL avec le bon schéma
-- ATTENTION : Ce script supprime toutes les données existantes !

-- Supprimer les tables existantes
DROP TABLE IF EXISTS candidature_enseignant;
DROP TABLE IF EXISTS offre_recrutement;

-- Les tables seront recréées automatiquement par Hibernate au prochain démarrage du service
-- avec le schéma correct incluant toutes les colonnes

-- Pour vérifier après le redémarrage du service :
-- USE recrutement_db;
-- DESCRIBE offre_recrutement;
-- DESCRIBE candidature_enseignant;
