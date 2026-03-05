# 🔧 Fix Gateway 404 Error

## Problème Résolu

L'erreur 404 sur `http://localhost:8086/forum/api/forum` était causée par une mauvaise configuration du `StripPrefix` dans l'API Gateway.

## Changement Effectué

Dans `api-gateway/src/main/resources/application.properties` :

```properties
# AVANT (❌ Ne fonctionnait pas)
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=0

# APRÈS (✅ Fonctionne)
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=1
```

## Explication

### Comment fonctionne StripPrefix ?

`StripPrefix=1` retire le premier segment du path avant de transférer la requête au service.

**Exemple avec Forum Service :**

```
Requête Client → Gateway → Service
────────────────────────────────────
/forum/api/forum → [StripPrefix=1] → /api/forum
```

**Exemple avec Recrutement Service :**

```
Requête Client → Gateway → Service
────────────────────────────────────
/recrutement/api/recrutement/offres → [StripPrefix=1] → /api/recrutement/offres
```

### Pourquoi StripPrefix=0 ne fonctionnait pas ?

Avec `StripPrefix=0`, le Gateway envoyait le path complet au service :

```
❌ /forum/api/forum → [StripPrefix=0] → /forum/api/forum
```

Mais le Forum Service n'a pas de route `/forum/api/forum`, seulement `/api/forum` !

## 🚀 Comment Tester

### 1. Redémarrer l'API Gateway

Si l'API Gateway est déjà en cours d'exécution, vous devez le redémarrer pour appliquer les changements :

```bash
# Arrêter le Gateway (Ctrl+C dans le terminal)
# Puis redémarrer :
cd api-gateway
mvnw spring-boot:run
```

### 2. Tester les URLs

Une fois le Gateway redémarré, testez :

#### Forum Service via Gateway
```bash
curl http://localhost:8086/forum/api/forum
```

Ou dans le navigateur : **http://localhost:8086/forum/api/forum**

#### Recrutement Service via Gateway
```bash
curl http://localhost:8086/recrutement/api/recrutement/offres
```

Ou dans le navigateur : **http://localhost:8086/recrutement/api/recrutement/offres**

### 3. Vérifier les Routes

Vous pouvez voir toutes les routes configurées :

```bash
curl http://localhost:8086/actuator/gateway/routes
```

Ou dans le navigateur : **http://localhost:8086/actuator/gateway/routes**

## 📋 URLs Complètes

### Forum Service

| Type | URL |
|------|-----|
| Direct | http://localhost:8082/api/forum |
| Via Gateway | http://localhost:8086/forum/api/forum |
| Swagger | http://localhost:8082/swagger-ui.html |

### Recrutement Service

| Type | URL |
|------|-----|
| Direct | http://localhost:8083/api/recrutement/offres |
| Via Gateway | http://localhost:8086/recrutement/api/recrutement/offres |
| Swagger | http://localhost:8083/swagger-ui.html |

## 🧪 Script de Test Automatique

Utilisez le script de test pour vérifier que tout fonctionne :

```bash
TEST_EUREKA_GATEWAY.bat
```

Ou avec PowerShell :

```powershell
.\Test-EurekaGateway.ps1
```

## ✅ Résultat Attendu

Après le redémarrage du Gateway, vous devriez voir :

```json
// http://localhost:8086/forum/api/forum
[
  {
    "id_forum": 1,
    "titre": "Forum Général",
    "description": "Discussion générale",
    ...
  }
]
```

## 🔍 Vérification dans les Logs

Dans les logs du Gateway, vous devriez voir :

```
DEBUG o.s.c.g.h.RoutePredicateHandlerMapping : Route matched: forum-service
DEBUG o.s.c.g.h.RoutePredicateHandlerMapping : Mapping [Exchange: GET http://localhost:8086/forum/api/forum] to Route{id='forum-service', uri=lb://forum-service, ...}
```

## 🎯 Configuration Finale

Voici la configuration complète et correcte des routes :

```properties
# Route 1: Forum Service
spring.cloud.gateway.routes[0].id=forum-service
spring.cloud.gateway.routes[0].uri=lb://forum-service
spring.cloud.gateway.routes[0].predicates[0]=Path=/forum/**
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=1

# Route 2: Recrutement Service
spring.cloud.gateway.routes[1].id=recrutement-service
spring.cloud.gateway.routes[1].uri=lb://recrutement-service
spring.cloud.gateway.routes[1].predicates[0]=Path=/recrutement/**
spring.cloud.gateway.routes[1].filters[0]=StripPrefix=1
```

## 💡 Autres Options de Configuration

Si vous voulez des URLs différentes, voici d'autres configurations possibles :

### Option 1 : Sans préfixe (accès direct)
```properties
# Accès : http://localhost:8086/api/forum
spring.cloud.gateway.routes[0].predicates[0]=Path=/api/forum/**
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=0
```

### Option 2 : Avec RewritePath
```properties
# Accès : http://localhost:8086/forum/api/forum
spring.cloud.gateway.routes[0].predicates[0]=Path=/forum/**
spring.cloud.gateway.routes[0].filters[0]=RewritePath=/forum(?<segment>/?.*), $\{segment}
```

### Option 3 : Préfixe personnalisé
```properties
# Accès : http://localhost:8086/services/forum/api/forum
spring.cloud.gateway.routes[0].predicates[0]=Path=/services/forum/**
spring.cloud.gateway.routes[0].filters[0]=StripPrefix=2
```

## 🐛 Dépannage

### Toujours 404 après redémarrage ?

1. Vérifiez que le service est enregistré dans Eureka : http://localhost:8761
2. Vérifiez les logs du Gateway pour les erreurs
3. Testez l'accès direct au service : http://localhost:8082/api/forum
4. Vérifiez les routes : http://localhost:8086/actuator/gateway/routes

### Service non trouvé (503) ?

Cela signifie que le Gateway ne trouve pas le service dans Eureka :
- Vérifiez que le service est UP dans Eureka Dashboard
- Attendez 30 secondes que le Gateway rafraîchisse sa liste de services
- Redémarrez le Gateway

## ✨ Succès !

Si vous voyez les données JSON au lieu de l'erreur 404, félicitations ! Votre API Gateway fonctionne correctement avec Eureka Server. 🎉
