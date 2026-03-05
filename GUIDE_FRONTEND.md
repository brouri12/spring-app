# 🌐 Guide Frontend

## 🔗 Votre Application Frontend

Votre application frontend tourne sur : **http://localhost:52692**

## ✅ Configuration Mise à Jour

J'ai mis à jour la configuration pour accéder directement aux services :

**Avant (ne fonctionnait pas) :**
```typescript
forumServiceUrl: 'http://localhost:8086/forum/api/forum'  // Via Gateway → 404
```

**Maintenant (fonctionne) :**
```typescript
forumServiceUrl: 'http://localhost:8082/api/forum'  // Accès direct → OK ✅
```

## 🚀 Actions à Effectuer

### 1. Arrêter le Frontend

Dans le terminal où le frontend tourne, appuyez sur : **`Ctrl + C`**

### 2. Exécuter le Script de Réparation

```bash
REPARER_FRONTEND.bat
```

Ce script va :
1. Supprimer le cache Angular
2. Afficher la nouvelle configuration
3. Redémarrer le frontend

### 3. Vider le Cache du Navigateur

Une fois le frontend redémarré :
1. Ouvrez l'URL affichée (ex: http://localhost:52692)
2. Appuyez sur **`Ctrl + Shift + R`**

### 4. Vérifier

Les forums devraient maintenant s'afficher ! 🎉

## 📊 URLs du Frontend

Selon le port sur lequel votre frontend tourne :

| Page | URL |
|------|-----|
| Accueil | http://localhost:52692 |
| Forums | http://localhost:52692/forums |
| Recrutement | http://localhost:52692/recrutement |

## 🔍 Vérification

### Dans le Navigateur

1. Ouvrez : http://localhost:52692/forums
2. Les forums devraient s'afficher

### Dans DevTools (F12)

1. Ouvrez DevTools : `F12`
2. Allez dans **Network** → **XHR**
3. Rechargez la page : `Ctrl + Shift + R`
4. Vous devez voir :

```
✅ http://localhost:8082/api/forum/forums → 200 OK
```

**Vous ne devez PAS voir :**
```
❌ http://localhost:8086/... (Gateway)
❌ 404 Not Found
```

## 📋 Checklist

- [ ] Frontend arrêté (Ctrl+C)
- [ ] Script REPARER_FRONTEND.bat exécuté
- [ ] Frontend redémarré
- [ ] Cache navigateur vidé (Ctrl+Shift+R)
- [ ] Forums s'affichent dans l'application
- [ ] Pas d'erreurs dans la console (F12)

## 🎯 Services Backend Requis

Pour que le frontend fonctionne, ces services doivent être démarrés :

### Forum Service (Port 8082)
```bash
cd forum-service
mvnw spring-boot:run
```

Test : http://localhost:8082/api/forum/forums

### Recrutement Service (Port 8083)
```bash
cd recrutement-service
mvnw spring-boot:run
```

Test : http://localhost:8083/api/recrutement/offres

## 🔧 Si Ça Ne Fonctionne Pas

### Vérifier que les Services Sont Démarrés

Ouvrez dans le navigateur :
- http://localhost:8082/api/forum/forums (doit montrer du JSON)
- http://localhost:8083/api/recrutement/offres (doit montrer du JSON)

Si ces URLs ne fonctionnent pas, démarrez les services.

### Vérifier CORS

Si vous voyez une erreur CORS dans la console :
```
Access to XMLHttpRequest blocked by CORS policy
```

Les services doivent avoir CORS activé. Vérifiez dans `application.properties` :
```properties
spring.web.cors.allowed-origins=*
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,PATCH,OPTIONS
spring.web.cors.allowed-headers=*
```

### Vérifier le Port

Le frontend peut tourner sur différents ports :
- 4201 (port par défaut)
- 52692 (port dynamique)
- Autre port

Vérifiez le message dans le terminal après `ng serve` :
```
** Angular Live Development Server is listening on localhost:52692 **
```

## 🎉 Résultat Attendu

Après avoir suivi ces étapes :

**Dans l'application :**
- ✅ Liste des forums affichée
- ✅ Possibilité de créer un forum
- ✅ Possibilité de voir les messages
- ✅ Pas d'erreurs dans la console

**Dans DevTools → Network :**
```
✅ forums → 200 OK
✅ messages/forum/1 → 200 OK
```

---

## 💡 Commandes Rapides

```bash
# Réparer le frontend
REPARER_FRONTEND.bat

# Réparer le back-office
REPARER_ANGULAR_MAINTENANT.bat

# Démarrer Forum Service
cd forum-service && mvnw spring-boot:run

# Démarrer Recrutement Service
cd recrutement-service && mvnw spring-boot:run
```

---

✅ **Votre frontend devrait maintenant fonctionner correctement !**
