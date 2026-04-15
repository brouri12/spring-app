# 🌿 JUNGLE IN ENGLISH — Spring Boot Microservices

[![Esprit](https://img.shields.io/badge/Esprit-School%20of%20Engineering-red)](https://esprit.tn)
[![Academic Year](https://img.shields.io/badge/Academic%20Year-2025--2026-blue)](https://esprit.tn)
[![PIDEV](https://img.shields.io/badge/Project-PIDEV-green)](https://esprit.tn)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.0.2-brightgreen)](https://spring.io)
[![Java](https://img.shields.io/badge/Java-17-orange)](https://openjdk.org)

> Plateforme éducative — Architecture Microservices développée à **Esprit School of Engineering** — PIDEV 2025-2026

---

## 📁 Structure du Projet

```
spring-app/
├── eureka-server/          # Service Discovery (Port 8761)
├── api-gateway/            # API Gateway + JWT (Port 8086)
├── forum-service/          # Service Forum (Port 8082)
└── recrutement-service/    # Service Recrutement (Port 8083)
```

---

## 🚀 Démarrage Rapide

### Prérequis
- Java 17+
- Maven 3.8+
- MySQL 8.0 (XAMPP)
- IntelliJ IDEA

### Ordre de démarrage

```
1. Démarrer MySQL (XAMPP)
2. eureka-server       → http://localhost:8761
3. api-gateway         → http://localhost:8086
4. forum-service       → http://localhost:8082
5. recrutement-service → http://localhost:8083
```

### Bases de données MySQL
```sql
CREATE DATABASE forum_db;
CREATE DATABASE recrutement_db;
```

---

## 🏗️ Architecture Microservices

```
Angular Frontend (4300)     Angular Back-Office (4301)
        │                              │
        └──────────────┬───────────────┘
                       │
              API Gateway (8086)
         ┌─────────────────────────┐
         │  JWT Validation         │
         │  CORS Configuration     │
         │  Load Balancing (lb://) │
         └────────────┬────────────┘
                      │
         ┌────────────┴────────────┐
         │                         │
  Forum Service (8082)   Recrutement Service (8083)
  DB: forum_db           DB: recrutement_db
         │                         │
         └────────────┬────────────┘
                      │
             Eureka Server (8761)
             Service Discovery
```

---

## 📦 Services

### 1. Eureka Server (Port 8761)

Service Discovery Netflix Eureka. Tous les microservices s'enregistrent automatiquement.

- Dashboard : http://localhost:8761
- Stack : Spring Boot 3.2, Spring Cloud 2023.0.0

---

### 2. API Gateway (Port 8086)

Routage centralisé vers les microservices avec CORS global.

**Routes configurées :**
| Route | Destination |
|-------|-------------|
| `/forum/**` | forum-service |
| `/recrutement/**` | recrutement-service |
| `/api/forum/**` | forum-service (direct) |
| `/api/recrutement/**` | recrutement-service (direct) |

**Configuration CORS :**
```properties
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-origins=*
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-methods=GET,POST,PUT,DELETE,PATCH,OPTIONS
```

---

### 3. Forum Service (Port 8082)

Gestion des forums de discussion avec fonctionnalités avancées.

#### Entités
- `Forum` — Forums de discussion
- `MessageForum` — Messages dans les forums
- `Like` — Likes sur les messages
- `Signalement` — Signalements de contenu
- `MediaFile` — Fichiers multimédias uploadés
- `EmailPreference` — Préférences email utilisateur
- `EmailLog` — Historique des emails envoyés

#### Endpoints principaux
```
GET    /api/forum/forums                        # Liste des forums
GET    /api/forum/messages/forum/{id}           # Messages d'un forum
POST   /api/forum/messages                      # Créer un message
PUT    /api/forum/messages/{id}                 # Modifier un message
DELETE /api/forum/messages/{id}                 # Supprimer un message
POST   /api/forum/likes/{messageId}             # Liker un message
POST   /api/forum/signalements                  # Signaler un message
POST   /api/forum/multimedia/upload             # Upload fichier
GET    /api/forum/multimedia/message/{id}       # Médias d'un message
```

#### Fonctionnalités avancées
- ✅ Upload multimédia (images, audio, documents, YouTube)
- ✅ Stockage fichiers sur disque avec organisation par type/date
- ✅ Détection type MIME (Apache Tika)
- ✅ Génération thumbnails (Thumbnailator)
- ✅ Système de likes avec compteur
- ✅ Signalement de contenu
- ✅ Notifications email (Gmail SMTP)
- ✅ Préférences email par utilisateur

#### Swagger UI
```
http://localhost:8082/swagger-ui/index.html
```

---

### 4. Recrutement Service (Port 8083)

Gestion complète du recrutement d'enseignants avec logique métier avancée.

#### Entités
- `OffreRecrutement` — Offres d'emploi (CDI/CDD/Vacataire)
- `CandidatureEnseignant` — Candidatures avec CV (LONGBLOB)
- `AdminNotification` — Notifications in-app pour l'admin

#### Endpoints principaux
```
# Offres
GET    /api/recrutement/offres                          # Toutes les offres
GET    /api/recrutement/offres/statut/{statut}          # Filtrer par statut
POST   /api/recrutement/offres                          # Créer une offre
PUT    /api/recrutement/offres/{id}                     # Modifier
DELETE /api/recrutement/offres/{id}                     # Supprimer
PATCH  /api/recrutement/offres/{id}/fermer              # Fermer
PATCH  /api/recrutement/offres/{id}/rouvrir             # Rouvrir

# Candidatures
POST   /api/recrutement/candidatures/offre/{id}         # Postuler
GET    /api/recrutement/candidatures/offre/{id}         # Par offre
PATCH  /api/recrutement/candidatures/{id}/statut        # Changer statut
GET    /api/recrutement/candidatures/{id}/cv            # Télécharger CV

# Logique métier avancée
GET    /api/recrutement/candidatures/doublon            # Vérifier doublon
GET    /api/recrutement/candidatures/{id}/offre-compatible  # Réaffectation
GET    /api/recrutement/offres/{id}/classement          # Classement par score
GET    /api/recrutement/candidatures/{id}/scoring       # Score détaillé
POST   /api/recrutement/analyse-lettre                  # Analyse NLP lettre

# Notifications
GET    /api/recrutement/notifications/unread            # Non lues
PATCH  /api/recrutement/notifications/{id}/read         # Marquer lu
PATCH  /api/recrutement/notifications/read-all          # Tout marquer lu

# Auth JWT
POST   /api/recrutement/auth/login                      # Obtenir token
```

#### Swagger UI
```
http://localhost:8083/swagger-ui/index.html
```

---

## 🔐 Sécurité JWT

### Fichiers
- `security/JwtUtil.java` — Génération/validation tokens HS256
- `security/JwtAuthFilter.java` — Filtre HTTP (OncePerRequestFilter)
- `security/SecurityConfig.java` — Règles d'accès + CORS
- `controller/AuthController.java` — Endpoint login

### Obtenir un token
```bash
POST http://localhost:8083/api/recrutement/auth/login
Content-Type: application/json

{"username": "admin", "password": "admin123"}
```

### Comptes
| Username | Password | Rôle |
|----------|----------|------|
| `admin` | `admin123` | ADMIN |
| `user` | `user123` | USER |

### Utiliser le token
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

### Fix CORS Spring Security
```java
// OPTIONS preflight toujours autorisé
.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

// CorsConfigurationSource avec allowedOriginPatterns("*")
http.cors(cors -> cors.configurationSource(corsConfigurationSource()))
```

---

## 🔗 OpenFeign — Communication Inter-Services

Le recrutement-service communique avec le forum-service via OpenFeign :

```java
@FeignClient(name = "forum-service", fallback = ForumServiceClientFallback.class)
public interface ForumServiceClient {
    @GetMapping("/api/forum/messages/count-by-email")
    int countMessagesByEmail(@RequestParam("email") String email);
}
```

- Eureka résout automatiquement l'URL via `lb://forum-service`
- Fallback Circuit Breaker si forum-service est indisponible
- `@EnableFeignClients` dans `RecrutementApplication.java`

---

## 🏆 Innovation — Scoring Automatique des Candidatures

### ScoringService.java

Algorithme multi-critères (0-100 points) :

| Critère | Points | Logique |
|---------|--------|---------|
| Expérience | 40 pts | Proportionnel à l'expérience requise |
| Qualité lettre (NLP) | 35 pts | Vocabulaire, mots-clés, structure |
| Rapidité candidature | 15 pts | Dans les 2 premiers jours = 15 pts |
| Complétude dossier | 10 pts | CV, email, nom, prénom |

### Analyse NLP de la lettre de motivation

```
POST http://localhost:8083/api/recrutement/analyse-lettre
Body: {"lettre": "Madame, Monsieur..."}
```

Retourne : qualité (EXCELLENTE/BONNE/CORRECTE/INSUFFISANTE), score, mots-clés pédagogiques trouvés, ratio vocabulaire, conseils d'amélioration.

### Classement par offre

```
GET http://localhost:8083/api/recrutement/offres/{id}/classement
```

Retourne les candidats triés par score décroissant avec rang (🥇🥈🥉) et niveau.

---

## ⏰ Scheduler — Notifications Admin

```java
@Scheduled(cron = "0 30 13 * * *") // Chaque jour à 13:30
public void verifierCandidaturesEnAttente()
```

- Vérifie les offres OUVERTE non expirées
- Crée une `AdminNotification` par offre avec candidatures EN_ATTENTE
- L'admin voit le badge en temps réel (polling Angular 10s)

---

## 📧 Email — Gmail SMTP

```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.properties.mail.smtp.ssl.trust=smtp.gmail.com
```

Email HTML envoyé automatiquement quand l'admin accepte une candidature.

---

## 🧪 Tests JUnit / Mockito

```bash
cd recrutement-service
mvn test
```

### CandidatureServiceTest.java (8 tests)
| Test | Scénario |
|------|----------|
| `postuler_Success` | Candidature créée avec succès |
| `postuler_OffreNotFound` | Offre inexistante → `Optional.empty()` |
| `postuler_DoublonDetecte` | Email déjà utilisé → `RuntimeException` |
| `changerStatut_Acceptee` | Email envoyé automatiquement |
| `changerStatut_Refusee` | Offre reste OUVERTE |
| `estCandidatDoublon_True` | Doublon dans 30 jours |
| `getCandidaturesByOffre` | Liste retournée |
| `estCandidatDoublon_False` | Pas de doublon |

### OffreServiceTest.java (9 tests)
| Test | Scénario |
|------|----------|
| `addOffre` | Date publication auto + statut OUVERTE |
| `getAllOffres` | Liste complète |
| `getOffreById_Found` | Offre trouvée |
| `getOffreById_NotFound` | Optional.empty() |
| `fermerOffre` | Statut → FERMEE |
| `rouvrirOffre` | Statut → OUVERTE |
| `deleteOffre_Success` | Suppression OK |
| `deleteOffre_NotFound` | Retourne false |
| `getOffresByStatut` | Filtrage correct |

---

## 🗄️ Configuration Base de Données

```properties
# forum-service
spring.datasource.url=jdbc:mysql://localhost:3306/forum_db

# recrutement-service
spring.datasource.url=jdbc:mysql://localhost:3306/recrutement_db?maxAllowedPacket=67108864
spring.jpa.hibernate.ddl-auto=update
```

**MySQL max_allowed_packet** configuré à 64MB pour les CVs en LONGBLOB :
```sql
SET GLOBAL max_allowed_packet=67108864;
```

---

## 📋 Logique Métier Avancée

| Fonctionnalité | Endpoint | Description |
|----------------|----------|-------------|
| Empêcher doublon | `POST /candidatures/offre/{id}` | 409 si même email + même offre |
| Détection doublon spécialité | `GET /candidatures/doublon` | Même spécialité dans 30 jours |
| Réaffectation après refus | `GET /candidatures/{id}/offre-compatible` | Offre compatible automatique |
| Scoring candidature | `GET /candidatures/{id}/scoring` | Score 0-100 détaillé |
| Classement par offre | `GET /offres/{id}/classement` | Tri par score avec rang |
| Analyse NLP lettre | `POST /analyse-lettre` | Qualité + mots-clés + conseils |
| Clôture automatique | Scheduler | Offres expirées → FERMEE |
| Notification admin | Scheduler 13:30 | EN_ATTENTE → notification in-app |
| Email acceptation | `PATCH /candidatures/{id}/statut` | Email HTML automatique |

---

## 🎓 Contexte Académique

| Champ | Valeur |
|-------|--------|
| Institution | Esprit School of Engineering |
| Projet | PIDEV (Projet Intégré de Développement) |
| Classe | 3ème Année |
| Année | 2025–2026 |
| Localisation | Tunis, Tunisie |

---

*© 2025-2026 Esprit School of Engineering — Tunisie*
