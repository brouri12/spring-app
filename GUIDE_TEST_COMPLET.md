# 🧪 Guide de Test Complet - Application Forum & Recrutement

## 📋 Checklist de Test

### ✅ Phase 1 : Démarrage des Services

#### 1.1 MySQL
- [ ] MySQL est démarré : `net start MySQL80`
- [ ] Connexion possible à MySQL
- [ ] Bases de données créées : `forum_db` et `recrutement_db`

#### 1.2 Eureka Server (Port 8761)
- [ ] Service démarré sans erreur
- [ ] Dashboard accessible : http://localhost:8761
- [ ] Aucune instance enregistrée au démarrage

#### 1.3 Forum Service (Port 8082)
- [ ] Service démarré sans erreur
- [ ] Enregistré dans Eureka (visible sur le dashboard)
- [ ] Swagger UI accessible : http://localhost:8082/swagger-ui/index.html
- [ ] Tables créées dans `forum_db` (Forum, MessageForum)
- [ ] Données de test insérées (2 forums, 5 messages)

#### 1.4 Recrutement Service (Port 8083)
- [ ] Service démarré sans erreur
- [ ] Enregistré dans Eureka (visible sur le dashboard)
- [ ] Swagger UI accessible : http://localhost:8083/swagger-ui/index.html
- [ ] Tables créées dans `recrutement_db` (OffreRecrutement, CandidatureEnseignant)
- [ ] Données de test insérées (2 offres, 2 candidatures)

#### 1.5 API Gateway (Port 8080)
- [ ] Service démarré sans erreur
- [ ] Enregistré dans Eureka
- [ ] Routes configurées vers Forum et Recrutement

#### 1.6 Frontend Angular (Port 4200)
- [ ] Application démarrée sans erreur de compilation
- [ ] Accessible sur http://localhost:4200
- [ ] Aucune erreur dans la console du navigateur

---

### ✅ Phase 2 : Test des APIs Backend

#### 2.1 Forum Service - Swagger UI

**Test 1 : GET /api/forum/forums**
- [ ] Endpoint accessible
- [ ] Retourne 2 forums
- [ ] Champs présents : id, titre, description, cours, niveau, groupe, statut

**Test 2 : GET /api/forum/forums/statut/OUVERT**
- [ ] Retourne uniquement les forums ouverts
- [ ] Statut = "OUVERT" pour tous les résultats

**Test 3 : GET /api/forum/messages/forum/{forumId}**
- [ ] Retourne les messages du forum spécifié
- [ ] Champs présents : id, contenu, auteurId, type_auteur, date_message, statut

**Test 4 : POST /api/forum/messages/forum/{forumId}**
```json
{
  "contenu": "Test message depuis Swagger",
  "auteurId": 1,
  "type_auteur": "ETUDIANT",
  "statut": "ACTIF"
}
```
- [ ] Message créé avec succès (code 201)
- [ ] Message visible dans GET /api/forum/messages/forum/{forumId}

#### 2.2 Recrutement Service - Swagger UI

**Test 1 : GET /api/recrutement/offres**
- [ ] Endpoint accessible
- [ ] Retourne 2 offres
- [ ] Champs présents : id, titre, description, specialite, type_contrat, nombre_postes, date_limite, statut

**Test 2 : GET /api/recrutement/offres/statut/OUVERTE**
- [ ] Retourne uniquement les offres ouvertes
- [ ] Statut = "OUVERTE" pour tous les résultats

**Test 3 : GET /api/recrutement/offres/specialite/{specialite}**
- [ ] Retourne les offres de la spécialité demandée
- [ ] Filtrage correct

**Test 4 : POST /api/recrutement/candidatures/offre/{offreId}**
```json
{
  "nom_candidat": "Dupont",
  "prenom_candidat": "Jean",
  "email": "jean.dupont@example.com",
  "cv_url": "https://example.com/cv.pdf",
  "lettre_motivation": "Je suis très motivé...",
  "statut": "EN_ATTENTE"
}
```
- [ ] Candidature créée avec succès (code 201)
- [ ] Candidature visible dans GET /api/recrutement/candidatures

---

### ✅ Phase 3 : Test du Frontend Angular

#### 3.1 Navigation et Design

**Page d'accueil (http://localhost:4200)**
- [ ] Logo "Wordly" visible avec gradient vert → orange
- [ ] Navbar contient : Courses, Forums, Recrutement, Pricing, About
- [ ] Boutons "Sign In" et "Get Started" visibles
- [ ] Bouton de changement de thème (soleil/lune) fonctionne
- [ ] Menu mobile (hamburger) fonctionne sur petit écran

**Couleurs**
- [ ] Vert principal : `rgb(0,200,151)` utilisé pour les éléments actifs
- [ ] Orange accent : `rgb(255,127,80)` utilisé pour les badges et accents
- [ ] Gradients harmonieux entre vert et orange

#### 3.2 Page Forums (http://localhost:4200/forums)

**Affichage Initial**
- [ ] Header avec gradient vert → orange
- [ ] Icône de forum visible
- [ ] Titre "Forums de Discussion" avec gradient
- [ ] Spinner de chargement (vert) pendant le chargement
- [ ] Liste des forums affichée (2 forums)

**Liste des Forums**
- [ ] Chaque forum affiche : titre, description, niveau, groupe, cours
- [ ] Badge niveau en vert
- [ ] Badge groupe en orange
- [ ] Hover effect sur les cartes de forum
- [ ] Bordure verte sur le forum sélectionné

**Sélection d'un Forum**
- [ ] Clic sur un forum charge ses messages
- [ ] Détails du forum affichés à droite
- [ ] Barre de recherche visible
- [ ] Bouton "Nouveau Message" visible avec gradient vert → orange

**Création de Message**
- [ ] Clic sur "Nouveau Message" affiche le formulaire
- [ ] Textarea pour le contenu
- [ ] Bouton "Envoyer" avec gradient vert → orange
- [ ] Bouton "Annuler" en gris
- [ ] Envoi du message fonctionne
- [ ] Notification toast "Message publié avec succès !" (verte)
- [ ] Message apparaît dans la liste

**Recherche de Messages**
- [ ] Saisie d'un mot-clé dans la barre de recherche
- [ ] Clic sur "Rechercher" ou Enter
- [ ] Messages filtrés affichés
- [ ] Notification toast avec le nombre de résultats

**Affichage des Messages**
- [ ] Avatar avec lettre (E pour étudiant, P pour enseignant)
- [ ] Avatar vert pour ETUDIANT
- [ ] Avatar orange pour ENSEIGNANT
- [ ] Badge type_auteur avec couleur appropriée
- [ ] Date et heure du message
- [ ] Contenu du message
- [ ] Hover effect sur les cartes de message

**Mode Sombre**
- [ ] Clic sur l'icône lune/soleil
- [ ] Fond change en mode sombre
- [ ] Texte reste lisible
- [ ] Couleurs vert et orange conservées

**Responsive**
- [ ] Desktop : Layout 3 colonnes (liste + détails)
- [ ] Tablette : Layout adaptatif
- [ ] Mobile : Liste en pleine largeur, menu hamburger

#### 3.3 Page Recrutement (http://localhost:4200/recrutement)

**Affichage Initial**
- [ ] Header avec gradient vert → orange
- [ ] Titre "Offres de Recrutement"
- [ ] Sous-titre "Rejoignez notre équipe pédagogique"
- [ ] Spinner de chargement (vert) pendant le chargement
- [ ] Liste des offres affichée (2 offres)

**Filtre par Spécialité**
- [ ] Champ de saisie pour la spécialité
- [ ] Bouton "Filtrer" en vert
- [ ] Bouton "Réinitialiser" en gris
- [ ] Filtrage fonctionne correctement
- [ ] Notification toast avec le nombre d'offres trouvées

**Liste des Offres**
- [ ] Chaque offre affiche : titre, spécialité, type_contrat, nombre_postes, date_limite
- [ ] Badge type_contrat en vert
- [ ] Badge nombre_postes en orange
- [ ] Hover effect sur les cartes d'offre
- [ ] Bordure verte sur l'offre sélectionnée

**Sélection d'une Offre**
- [ ] Clic sur une offre affiche ses détails
- [ ] Titre de l'offre en grand
- [ ] Badges : spécialité (vert), type_contrat (orange), nombre_postes (gris)
- [ ] Description complète
- [ ] Niveau requis
- [ ] Date limite formatée
- [ ] Rémunération (si disponible)

**Bouton Postuler**
- [ ] Bouton "Postuler à cette offre" avec gradient vert → orange
- [ ] Bouton désactivé si date expirée
- [ ] Message "Cette offre a expiré" en rouge si date passée

**Formulaire de Candidature**
- [ ] Clic sur "Postuler" affiche le formulaire
- [ ] Champs : Nom, Prénom, Email, URL du CV, Lettre de motivation
- [ ] Tous les champs requis
- [ ] Focus ring vert sur les champs
- [ ] Bouton "Envoyer ma candidature" en vert
- [ ] Bouton "Annuler" en gris
- [ ] Bouton désactivé si champs vides

**Envoi de Candidature**
- [ ] Remplir tous les champs
- [ ] Clic sur "Envoyer ma candidature"
- [ ] Notification toast "Votre candidature a été envoyée avec succès !" (verte)
- [ ] Formulaire se ferme
- [ ] Champs réinitialisés

**Responsive**
- [ ] Desktop : Layout 3 colonnes (liste + détails)
- [ ] Tablette : Layout adaptatif
- [ ] Mobile : Liste en pleine largeur

---

### ✅ Phase 4 : Test des Notifications Toast

#### 4.1 Types de Notifications

**Success (Vert)**
- [ ] Icône de succès (checkmark)
- [ ] Fond vert
- [ ] Animation slide-in depuis la droite
- [ ] Disparaît après 5 secondes
- [ ] Exemple : "Message publié avec succès !"

**Error (Rouge)**
- [ ] Icône d'erreur (X)
- [ ] Fond rouge
- [ ] Animation slide-in depuis la droite
- [ ] Disparaît après 5 secondes
- [ ] Exemple : "Erreur lors du chargement des forums"

**Info (Bleu)**
- [ ] Icône d'information (i)
- [ ] Fond bleu
- [ ] Animation slide-in depuis la droite
- [ ] Disparaît après 5 secondes
- [ ] Exemple : "2 message(s) trouvé(s)"

**Warning (Orange)**
- [ ] Icône d'avertissement (!)
- [ ] Fond orange
- [ ] Animation slide-in depuis la droite
- [ ] Disparaît après 5 secondes

#### 4.2 Gestion des Erreurs

**Erreur Réseau**
- [ ] Arrêter un service backend
- [ ] Tenter une action dans le frontend
- [ ] Notification d'erreur affichée
- [ ] Message d'erreur clair

**Erreur CORS**
- [ ] Vérifier qu'aucune erreur CORS n'apparaît dans la console
- [ ] Toutes les requêtes passent correctement

---

### ✅ Phase 5 : Test de Performance

#### 5.1 Temps de Chargement
- [ ] Page d'accueil : < 2 secondes
- [ ] Page Forums : < 3 secondes
- [ ] Page Recrutement : < 3 secondes
- [ ] Changement de page : < 1 seconde

#### 5.2 Réactivité
- [ ] Clic sur un bouton : réponse immédiate
- [ ] Saisie dans un champ : pas de lag
- [ ] Animations fluides (60 fps)
- [ ] Transitions douces

---

### ✅ Phase 6 : Test de Compatibilité

#### 6.1 Navigateurs
- [ ] Chrome (dernière version)
- [ ] Firefox (dernière version)
- [ ] Edge (dernière version)
- [ ] Safari (si disponible)

#### 6.2 Résolutions d'Écran
- [ ] Desktop : 1920x1080
- [ ] Laptop : 1366x768
- [ ] Tablette : 768x1024
- [ ] Mobile : 375x667

---

## 🐛 Problèmes Connus et Solutions

### Problème 1 : Erreur CORS
**Symptôme** : "Access to XMLHttpRequest has been blocked by CORS policy"
**Solution** :
1. Vérifier que CorsConfig.java existe dans les deux services
2. Redémarrer les services : `mvn clean install && mvn spring-boot:run`
3. Vider le cache du navigateur

### Problème 2 : Port déjà utilisé
**Symptôme** : "Port 8082 is already in use"
**Solution** :
```cmd
netstat -ano | findstr :8082
taskkill /PID <PID> /F
```

### Problème 3 : MySQL non démarré
**Symptôme** : "Communications link failure"
**Solution** :
```cmd
net start MySQL80
```

### Problème 4 : Données de test manquantes
**Symptôme** : Aucune offre ou forum affiché
**Solution** :
1. Vérifier les logs du service au démarrage
2. Vérifier que les données sont insérées dans la base
3. Redémarrer le service

---

## 📊 Rapport de Test

### Résumé
- **Total de tests** : ~100
- **Tests réussis** : ___
- **Tests échoués** : ___
- **Taux de réussite** : ___%

### Bugs Identifiés
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

### Améliorations Suggérées
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

---

## ✅ Validation Finale

- [ ] Tous les services démarrent sans erreur
- [ ] Toutes les pages sont accessibles
- [ ] Toutes les fonctionnalités fonctionnent
- [ ] Aucune erreur dans les consoles (backend et frontend)
- [ ] Design cohérent avec les couleurs vert et orange
- [ ] Notifications toast fonctionnelles
- [ ] Application responsive
- [ ] Mode sombre fonctionnel

**Date du test** : _______________
**Testeur** : _______________
**Statut** : ✅ VALIDÉ / ❌ À CORRIGER
