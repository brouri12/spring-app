# 📚 GUIDE COMPLET - MICROSERVICES SPRING BOOT

## 🟢 MODULE 1 : FORUM SERVICE

### ✅ Structure créée
```
forum-service/
├── src/main/java/tn/esprit/forum/
│   ├── entity/
│   │   ├── Forum.java
│   │   └── MessageForum.java
│   ├── repository/
│   │   ├── ForumRepository.java
│   │   └── MessageForumRepository.java
│   ├── service/
│   │   ├── ForumService.java
│   │   └── MessageForumService.java
│   ├── controller/
│   │   └── ForumRestAPI.java
│   └── ForumApplication.java
├── src/main/resources/
│   └── application.properties
└── pom.xml
```

### 📋 PHASE 1 : PRÉPARATION

#### 1. Démarrer MySQL
```cmd
# Vérifier que MySQL est démarré
net start MySQL80
```

#### 2. Créer la base de données (optionnel - auto-créée)
```sql
CREATE DATABASE forum_db;
```

#### 3. Vérifier Eureka Server
Assurez-vous qu'Eureka Server tourne sur `http://localhost:8761`

### 🚀 PHASE 2 : LANCEMENT DU SERVICE

#### Option 1 : Via IntelliJ IDEA
1. Ouvrir IntelliJ IDEA
2. File → Open → Sélectionner `forum-service`
3. Attendre l'indexation Maven
4. Clic droit sur `ForumApplication.java` → Run

#### Option 2 : Via Maven
```cmd
cd forum-service
mvnw clean install
mvnw spring-boot:run
```

### ✅ PHASE 3 : VÉRIFICATION

1. **Console** : Vérifier le message
   ```
   ✅ Données initiales insérées : 2 forums et 5 messages
   ```

2. **Eureka Dashboard** : http://localhost:8761
   - Vérifier que `FORUM-SERVICE` est enregistré

3. **Test API** : http://localhost:8082/api/forum

### 🧪 PHASE 4 : TESTS DES ENDPOINTS

#### GET - Récupérer tous les forums
```http
GET http://localhost:8082/api/forum
```

#### GET - Récupérer un forum par ID
```http
GET http://localhost:8082/api/forum/1
```

#### POST - Créer un nouveau forum
```http
POST http://localhost:8082/api/forum
Content-Type: application/json

{
  "titre": "Discussion Python",
  "description": "Forum pour les questions Python",
  "cree_par": 3,
  "niveau": "L2",
  "groupe": "INFO-C",
  "cours": "Programmation Python",
  "statut": "OUVERT"
}
```

#### PUT - Modifier un forum
```http
PUT http://localhost:8082/api/forum/1
Content-Type: application/json

{
  "titre": "Discussion Java Spring Boot - Mise à jour",
  "description": "Forum mis à jour",
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Développement Web",
  "statut": "OUVERT"
}
```

#### DELETE - Supprimer un forum
```http
DELETE http://localhost:8082/api/forum/1
```

#### PATCH - Fermer un forum
```http
PATCH http://localhost:8082/api/forum/1/fermer
```

#### GET - Messages d'un forum
```http
GET http://localhost:8082/api/forum/1/messages
```

#### POST - Publier un message
```http
POST http://localhost:8082/api/forum/message?forumId=1
Content-Type: application/json

{
  "contenu": "Nouveau message de test",
  "auteur_id": 103,
  "type_auteur": "ETUDIANT",
  "statut": "ACTIF"
}
```

#### PUT - Modifier un message
```http
PUT http://localhost:8082/api/forum/message/1?contenu=Message modifié&auteurId=101
```

#### DELETE - Supprimer un message
```http
DELETE http://localhost:8082/api/forum/message/1?auteurId=101
```

#### GET - Compter les messages
```http
GET http://localhost:8082/api/forum/1/messages/count
```

#### GET - Forums les plus actifs
```http
GET http://localhost:8082/api/forum/plus-actifs
```

#### GET - Recherche par titre (avec pagination)
```http
GET http://localhost:8082/api/forum/recherche?titre=Java&page=0&size=10
```

#### GET - Forums par niveau
```http
GET http://localhost:8082/api/forum/niveau/L3
```

#### GET - Forums par statut
```http
GET http://localhost:8082/api/forum/statut/OUVERT
```

---

## 🔵 MODULE 2 : RECRUTEMENT SERVICE

### ✅ Structure créée
```
recrutement-service/
├── src/main/java/tn/esprit/recrutement/
│   ├── entity/
│   │   ├── OffreRecrutement.java
│   │   └── CandidatureEnseignant.java
│   ├── repository/
│   │   ├── OffreRepository.java
│   │   └── CandidatureRepository.java
│   ├── service/
│   │   ├── OffreService.java
│   │   └── CandidatureService.java
│   ├── controller/
│   │   └── RecrutementRestAPI.java
│   └── RecrutementApplication.java
├── src/main/resources/
│   └── application.properties
└── pom.xml
```

### 📋 PHASE 1 : PRÉPARATION

#### 1. Créer la base de données (optionnel - auto-créée)
```sql
CREATE DATABASE recrutement_db;
```

### 🚀 PHASE 2 : LANCEMENT DU SERVICE

#### Option 1 : Via IntelliJ IDEA
1. File → Open → Sélectionner `recrutement-service`
2. Attendre l'indexation Maven
3. Clic droit sur `RecrutementApplication.java` → Run

#### Option 2 : Via Maven
```cmd
cd recrutement-service
mvnw clean install
mvnw spring-boot:run
```

### ✅ PHASE 3 : VÉRIFICATION

1. **Console** : Vérifier le message
   ```
   ✅ Données initiales insérées : 2 offres et 2 candidatures
   ```

2. **Eureka Dashboard** : http://localhost:8761
   - Vérifier que `RECRUTEMENT-SERVICE` est enregistré

3. **Test API** : http://localhost:8083/api/recrutement/offres

### 🧪 PHASE 4 : TESTS DES ENDPOINTS

#### GET - Récupérer toutes les offres
```http
GET http://localhost:8083/api/recrutement/offres
```

#### GET - Récupérer une offre par ID
```http
GET http://localhost:8083/api/recrutement/offres/1
```

#### POST - Créer une nouvelle offre
```http
POST http://localhost:8083/api/recrutement/offres
Content-Type: application/json

{
  "titre": "Enseignant Cybersécurité",
  "description": "Recherche enseignant spécialisé en cybersécurité",
  "specialite": "Cybersécurité",
  "experience_min": 4,
  "statut": "OUVERTE"
}
```

#### PUT - Modifier une offre
```http
PUT http://localhost:8083/api/recrutement/offres/1
Content-Type: application/json

{
  "titre": "Enseignant Java/Spring Boot - Senior",
  "description": "Description mise à jour",
  "specialite": "Développement Web",
  "experience_min": 5,
  "statut": "OUVERTE"
}
```

#### DELETE - Supprimer une offre
```http
DELETE http://localhost:8083/api/recrutement/offres/1
```

#### PATCH - Fermer une offre
```http
PATCH http://localhost:8083/api/recrutement/offres/1/fermer
```

#### GET - Offres par statut
```http
GET http://localhost:8083/api/recrutement/offres/statut/OUVERTE
```

#### GET - Offres par spécialité
```http
GET http://localhost:8083/api/recrutement/offres/specialite/Intelligence%20Artificielle
```

#### GET - Toutes les candidatures
```http
GET http://localhost:8083/api/recrutement/candidatures
```

#### POST - Postuler à une offre
```http
POST http://localhost:8083/api/recrutement/candidatures?offreId=1
Content-Type: application/json

{
  "nom_candidat": "Gharbi",
  "prenom_candidat": "Ahmed",
  "email": "ahmed.gharbi@example.com",
  "cv_url": "https://example.com/cv/ahmed.pdf",
  "lettre_motivation": "Je suis très motivé pour ce poste..."
}
```

#### PATCH - Changer le statut d'une candidature
```http
PATCH http://localhost:8083/api/recrutement/candidatures/1/statut?statut=ACCEPTEE
```

```http
PATCH http://localhost:8083/api/recrutement/candidatures/2/statut?statut=REFUSEE
```

#### GET - Candidatures par offre
```http
GET http://localhost:8083/api/recrutement/candidatures/offre/1
```

#### GET - Candidatures par statut
```http
GET http://localhost:8083/api/recrutement/candidatures/statut/EN_ATTENTE
```

#### GET - Filtrer par spécialité
```http
GET http://localhost:8083/api/recrutement/candidatures/specialite/Développement%20Web
```

#### POST - Convertir en enseignant
```http
POST http://localhost:8083/api/recrutement/candidatures/1/convertir
```

---

## 🛠️ OUTILS DE TEST RECOMMANDÉS

### 1. Postman
- Importer les requêtes ci-dessus
- Créer une collection pour chaque service

### 2. cURL (Windows CMD)
```cmd
curl http://localhost:8082/api/forum
curl http://localhost:8083/api/recrutement/offres
```

### 3. Navigateur Web
- Pour les requêtes GET uniquement
- http://localhost:8082/api/forum
- http://localhost:8083/api/recrutement/offres

---

## 🔧 DÉPANNAGE

### Problème : Port déjà utilisé
```properties
# Changer le port dans application.properties
server.port=8084
```

### Problème : MySQL non accessible
```properties
# Vérifier les credentials dans application.properties
spring.datasource.username=root
spring.datasource.password=votre_mot_de_passe
```

### Problème : Eureka non trouvé
```properties
# Désactiver temporairement Eureka
eureka.client.enabled=false
```

---

## 📊 ARCHITECTURE GLOBALE

```
┌─────────────────┐
│  Eureka Server  │
│   Port: 8761    │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼────┐
│ Forum │ │ Recru │
│ 8082  │ │ 8083  │
└───┬───┘ └───┬───┘
    │         │
┌───▼─────────▼───┐
│   MySQL Server  │
│  forum_db       │
│  recrutement_db │
└─────────────────┘
```

---

## ✅ CHECKLIST FINALE

### Forum Service
- [ ] MySQL démarré
- [ ] Base forum_db créée (auto)
- [ ] Eureka Server actif
- [ ] Service démarré sur port 8082
- [ ] 2 forums insérés
- [ ] 5 messages insérés
- [ ] Enregistré dans Eureka
- [ ] Tests API réussis

### Recrutement Service
- [ ] Base recrutement_db créée (auto)
- [ ] Service démarré sur port 8083
- [ ] 2 offres insérées
- [ ] 2 candidatures insérées
- [ ] Enregistré dans Eureka
- [ ] Tests API réussis

---

## 🎯 PROCHAINES ÉTAPES

1. Ajouter la validation des données (@Valid, @NotNull)
2. Implémenter la gestion des exceptions globale
3. Ajouter Spring Security pour l'authentification
4. Créer une Gateway API (Spring Cloud Gateway)
5. Ajouter des tests unitaires et d'intégration
6. Dockeriser les microservices
7. Ajouter Swagger/OpenAPI pour la documentation

---

## 📞 SUPPORT

En cas de problème :
1. Vérifier les logs dans la console
2. Vérifier que MySQL est démarré
3. Vérifier que les ports ne sont pas occupés
4. Vérifier la configuration dans application.properties

Bon développement ! 🚀
