# Solution Finale - Forcer la Recréation des Tables

## 🔧 Changement Appliqué

J'ai modifié temporairement la configuration pour forcer Hibernate à recréer les tables :

**Changé de :**
```properties
spring.jpa.hibernate.ddl-auto=update
```

**Vers :**
```properties
spring.jpa.hibernate.ddl-auto=create
```

⚠️ **ATTENTION :** Cela va supprimer et recréer les tables à chaque démarrage !

---

## 🚀 Actions à Effectuer MAINTENANT

### 1. Arrêter les Services

Dans les terminaux où les services tournent :
- Appuyez sur **Ctrl+C** pour arrêter Forum Service
- Appuyez sur **Ctrl+C** pour arrêter Recrutement Service

### 2. Redémarrer les Services

**Terminal 1 - Forum Service :**
```bash
cd forum-service
mvn spring-boot:run
```

**Terminal 2 - Recrutement Service :**
```bash
cd recrutement-service
mvn spring-boot:run
```

### 3. Attendre le Démarrage Complet

Dans les logs, vous devriez voir :
```
Hibernate: drop table if exists offre_recrutement
Hibernate: drop table if exists candidature_enseignant
Hibernate: create table offre_recrutement (...)
Hibernate: create table candidature_enseignant (...)
```

Cela confirme que les tables sont recréées avec le bon schéma.

### 4. Tester via Swagger

**Créer une Offre :**

http://localhost:8083/swagger-ui.html

```json
{
  "titre": "Enseignant Java Spring Boot",
  "description": "Nous recherchons un enseignant expérimenté en développement Java et Spring Boot pour enseigner aux étudiants",
  "specialite": "Informatique",
  "niveau_requis": "Master ou Doctorat",
  "type_contrat": "CDI",
  "experience_min": 3,
  "date_publication": "2026-02-18",
  "date_limite": "2026-04-18",
  "statut": "OUVERTE",
  "nombre_postes": 2,
  "salaire_min": 2500.0,
  "salaire_max": 3500.0
}
```

**Résultat attendu :** ✅ Code 201

### 5. Vérifier dans MySQL

Ouvrez MySQL Workbench ou phpMyAdmin :
- Base : `recrutement_db`
- Table : `offre_recrutement`
- Vous devriez voir l'offre créée !

---

## ⚙️ Remettre la Configuration Normale (IMPORTANT)

Une fois que tout fonctionne, **ARRÊTEZ les services** et remettez la configuration normale :

Je vais le faire pour vous maintenant...
