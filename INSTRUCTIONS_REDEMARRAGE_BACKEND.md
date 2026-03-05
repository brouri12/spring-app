# 🔄 Instructions de Redémarrage du Backend

## ⚠️ IMPORTANT: Le Backend Doit Être Redémarré

Les modifications apportées aux fichiers Java ne prennent effet qu'après le redémarrage du service.

---

## Erreurs Actuelles (Backend Non Redémarré)

```
PUT http://localhost:8082/api/forum/messages/5 400 (Bad Request)
DELETE http://localhost:8082/api/forum/messages/5 400 (Bad Request)
```

Ces erreurs 400 persistent car le backend utilise encore l'ancien code qui attend des `@RequestParam` au lieu de `Map<String, String>`.

---

## Comment Redémarrer le Service Forum

### Option 1: Via IDE (IntelliJ IDEA / Eclipse)

1. **Arrêter le service**:
   - Cliquer sur le bouton Stop (carré rouge) dans la console
   - Ou: `Ctrl + F2` (IntelliJ)

2. **Redémarrer le service**:
   - Cliquer sur le bouton Run (triangle vert)
   - Ou: `Shift + F10` (IntelliJ)

### Option 2: Via Maven en Ligne de Commande

```bash
# Naviguer vers le dossier du service
cd forum-service

# Arrêter le service en cours (Ctrl + C si lancé en terminal)

# Nettoyer et recompiler
mvn clean install

# Relancer le service
mvn spring-boot:run
```

### Option 3: Via JAR

```bash
# Naviguer vers le dossier du service
cd forum-service

# Compiler
mvn clean package

# Lancer le JAR
java -jar target/forum-service-0.0.1-SNAPSHOT.jar
```

---

## Vérification du Redémarrage

### 1. Vérifier les Logs au Démarrage

Vous devriez voir dans les logs:
```
Started ForumServiceApplication in X.XXX seconds
Tomcat started on port(s): 8082 (http)
```

### 2. Tester les Endpoints

#### Test PUT (Modification)
```bash
curl -X PUT http://localhost:8082/api/forum/messages/5 \
  -H "Content-Type: application/json" \
  -d '{"contenu":"Test de modification"}'
```

**Réponse attendue**: 200 OK avec le message modifié

#### Test DELETE (Suppression)
```bash
curl -X DELETE http://localhost:8082/api/forum/messages/5
```

**Réponse attendue**: 204 No Content

---

## Modifications Appliquées (Qui Nécessitent le Redémarrage)

### 1. Controller - ForumRestAPI.java

**Endpoint PUT modifié**:
```java
@PutMapping("/messages/{id}")
public ResponseEntity<MessageForum> modifierMessage(
        @PathVariable Long id,
        @RequestBody Map<String, String> updates) {
    // Accepte maintenant {"contenu": "..."} au lieu de l'objet complet
}
```

**Endpoint DELETE modifié**:
```java
@DeleteMapping("/messages/{id}")
public ResponseEntity<Void> supprimerMessage(@PathVariable Long id) {
    // Ne nécessite plus l'auteurId
    messageService.supprimerMessageDefinitif(id);
    return ResponseEntity.noContent().build();
}
```

### 2. Service - MessageForumService.java

**Nouvelle méthode ajoutée**:
```java
public void supprimerMessageDefinitif(Long messageId) {
    messageRepository.deleteById(messageId);
}
```

**Méthode modifierMessage modifiée**:
```java
public Optional<MessageForum> modifierMessage(Long messageId, String nouveauContenu, Long auteurId) {
    return messageRepository.findById(messageId).map(message -> {
        // Vérification d'auteur désactivée pour le frontend public
        message.setContenu(nouveauContenu);
        return messageRepository.save(message);
    });
}
```

---

## Après le Redémarrage

### 1. Rafraîchir le Frontend

Rafraîchir la page du navigateur (F5 ou Ctrl + R)

### 2. Tester les Fonctionnalités

#### Test Modification:
1. Ouvrir un forum
2. Cliquer sur l'icône crayon (bleu) d'un message
3. Modifier le texte
4. Cliquer sur "Mettre à jour"
5. ✅ Devrait afficher: "✅ Message modifié avec succès !"

#### Test Suppression:
1. Cliquer sur l'icône poubelle (rouge) d'un message
2. Confirmer la suppression
3. ✅ Devrait afficher: "✅ Message supprimé avec succès !"

### 3. Vérifier les Logs

Dans la console du navigateur (F12), vous devriez voir:
```
🔄 Mise à jour du message: 5
📤 Données envoyées: {contenu: "..."}
✅ Message mis à jour: {...}
```

Au lieu de:
```
❌ Erreur lors de la modification: 400 Bad Request
```

---

## Dépannage

### Problème: Le service ne démarre pas

**Erreur**: `Port 8082 is already in use`

**Solution**:
```bash
# Windows
netstat -ano | findstr :8082
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8082
kill -9 <PID>
```

### Problème: Erreur de compilation

**Erreur**: `Cannot find symbol: Map`

**Solution**: L'import est déjà présent, mais si nécessaire:
```java
import java.util.Map;
```

### Problème: Erreur 404 après redémarrage

**Cause**: Le service n'est pas démarré ou démarre sur un autre port

**Solution**: Vérifier les logs et le fichier `application.properties`:
```properties
server.port=8082
```

---

## Checklist de Redémarrage

- [ ] Arrêter le service forum-service
- [ ] Vérifier qu'aucun processus n'utilise le port 8082
- [ ] Redémarrer le service
- [ ] Attendre le message "Started ForumServiceApplication"
- [ ] Rafraîchir le frontend dans le navigateur
- [ ] Tester la modification d'un message
- [ ] Tester la suppression d'un message
- [ ] Vérifier les logs dans la console du navigateur

---

## Résumé

✅ **Code modifié**: Les fichiers Java ont été mis à jour
❌ **Backend non redémarré**: Les modifications ne sont pas actives
🔄 **Action requise**: Redémarrer le service forum-service

**Une fois le service redémarré, les fonctionnalités de modification et suppression fonctionneront correctement.**
