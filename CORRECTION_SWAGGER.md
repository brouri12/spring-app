# Correction de Swagger UI

## 🔧 Modifications Apportées

1. ✅ Mise à jour de springdoc-openapi de 2.1.0 vers 2.7.0 dans forum-service
2. ✅ Suppression de la dépendance dupliquée
3. ✅ Simplification de la configuration Swagger dans application.properties

## 📝 Étapes pour Appliquer les Corrections

### Étape 1: Arrêter le Forum Service

Si le service est en cours d'exécution, arrêtez-le (Ctrl+C dans le terminal ou arrêtez le processus).

### Étape 2: Nettoyer et Recompiler

Ouvrez un terminal dans le dossier `forum-service` et exécutez :

```bash
# Nettoyer le projet
mvn clean

# Recompiler avec les nouvelles dépendances
mvn install -DskipTests
```

Cela va télécharger la nouvelle version de springdoc-openapi (2.7.0) et recompiler le projet.

### Étape 3: Redémarrer le Service

```bash
mvn spring-boot:run
```

Attendez que le service démarre complètement (message "Started ForumApplication").

### Étape 4: Tester Swagger UI

Ouvrez votre navigateur et allez sur :
- http://localhost:8082/swagger-ui.html
- OU http://localhost:8082/swagger-ui/index.html

Vous devriez maintenant voir l'interface Swagger UI sans erreur 500.

---

## 🧪 Vérification

### Test 1: API Docs JSON

```bash
curl http://localhost:8082/v3/api-docs
```

Devrait retourner un JSON avec la documentation OpenAPI (pas d'erreur 500).

### Test 2: Swagger UI

Ouvrez http://localhost:8082/swagger-ui.html dans votre navigateur.

Vous devriez voir :
- Liste des endpoints (ForumRestAPI)
- Possibilité de tester les endpoints directement
- Documentation des modèles (Forum, MessageForum)

---

## 🎯 Test des Endpoints via Swagger UI

### 1. GET /api/forum/forums

1. Cliquez sur "GET /api/forum/forums"
2. Cliquez sur "Try it out"
3. Cliquez sur "Execute"
4. Résultat attendu : `[]` (liste vide) avec code 200

### 2. POST /api/forum/forums (Données valides)

1. Cliquez sur "POST /api/forum/forums"
2. Cliquez sur "Try it out"
3. Remplacez le JSON par :

```json
{
  "titre": "Discussion Java Spring Boot",
  "description": "Forum dédié aux questions sur Spring Boot et Java",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Développement Web",
  "statut": "OUVERT"
}
```

4. Cliquez sur "Execute"
5. Résultat attendu : Code 201 avec le forum créé

### 3. POST /api/forum/forums (Données invalides - Test validation)

Testez avec un titre trop court :

```json
{
  "titre": "Test",
  "description": "Description valide",
  "date_creation": "2026-02-18",
  "cree_par": 1,
  "niveau": "L3",
  "groupe": "INFO-A",
  "cours": "Java",
  "statut": "OUVERT"
}
```

Résultat attendu : Code 400 avec message d'erreur :
```json
{
  "titre": "Le titre doit contenir entre 5 et 100 caractères"
}
```

---

## 🔄 Si Swagger ne fonctionne toujours pas

### Option 1: Vérifier les logs

Regardez les logs du service dans le terminal. Cherchez les messages d'erreur contenant "swagger" ou "openapi".

### Option 2: Vérifier la version de Spring Boot

Le projet utilise Spring Boot 4.0.2. Vérifiez que c'est compatible avec springdoc-openapi 2.7.0.

Si problème, essayez de downgrader Spring Boot à 3.2.x :

Dans `pom.xml`, changez :
```xml
<version>4.0.2</version>
```
vers
```xml
<version>3.2.2</version>
```

Puis recompilez : `mvn clean install -DskipTests`

### Option 3: Désactiver temporairement Swagger

Si Swagger continue de causer des problèmes, vous pouvez le désactiver temporairement :

Dans `application.properties`, ajoutez :
```properties
springdoc.swagger-ui.enabled=false
springdoc.api-docs.enabled=false
```

L'API continuera de fonctionner normalement, vous pourrez tester via le back-office Angular ou cURL.

---

## ✅ Résultat Attendu

Après ces corrections, Swagger UI devrait :
- ✅ S'afficher sans erreur 500
- ✅ Montrer tous les endpoints du ForumRestAPI
- ✅ Permettre de tester les endpoints directement
- ✅ Afficher les schémas des modèles (Forum, MessageForum)
- ✅ Montrer les contraintes de validation dans la documentation

---

## 📌 Note Importante

Même si Swagger ne fonctionne pas, l'API est opérationnelle et vous pouvez :
1. Tester via le back-office Angular (recommandé)
2. Tester via cURL ou Postman
3. Tester via des outils comme Insomnia ou HTTPie

Les validations fonctionnent correctement indépendamment de Swagger.
