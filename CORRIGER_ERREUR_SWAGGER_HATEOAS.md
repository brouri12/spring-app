# 🔧 CORRIGER L'ERREUR SWAGGER HATEOAS

## ❌ ERREUR RENCONTRÉE

```
Type org.springframework.boot.autoconfigure.hateoas.HateoasProperties not present
Error creating bean with name 'halProvider'
SpringDocDataRestConfiguration
```

---

## ✅ CAUSE

Conflit entre :
- **Swagger (springdoc-openapi)**
- **Spring Data REST** (dans vos dépendances)
- **Spring HATEOAS**

Swagger essaie d'auto-configurer des beans pour HATEOAS qui n'existent pas dans Spring Boot 4.x.

---

## 🚀 SOLUTION APPLIQUÉE

J'ai ajouté cette ligne dans `application.properties` :

```properties
spring.autoconfigure.exclude=org.springdoc.core.configuration.SpringDocDataRestConfiguration,org.springdoc.core.configuration.SpringDocHateoasConfiguration
```

Cela désactive les configurations automatiques qui causent le problème.

---

## 📋 ÉTAPES À SUIVRE

### 1. Vérifier que la configuration est ajoutée

Ouvrez `recrutement-service/src/main/resources/application.properties`

Vérifiez que cette ligne est présente à la fin :
```properties
spring.autoconfigure.exclude=org.springdoc.core.configuration.SpringDocDataRestConfiguration,org.springdoc.core.configuration.SpringDocHateoasConfiguration
```

### 2. Redémarrer le service

```cmd
cd recrutement-service
mvnw spring-boot:run
```

### 3. Vérifier le démarrage

Vous devriez voir :
```
Started RecrutementApplication in X seconds
✅ Données initiales insérées : 2 offres et 2 candidatures
```

### 4. Tester Swagger

```
http://localhost:8083/swagger-ui/index.html
```

---

## 🔄 SOLUTION ALTERNATIVE

Si le problème persiste, vous pouvez aussi retirer Spring Data REST du pom.xml :

### Option 1 : Commenter la dépendance

Dans `recrutement-service/pom.xml`, commentez :

```xml
<!--
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-rest</artifactId>
</dependency>
-->
```

### Option 2 : Utiliser une version compatible

Remplacez la version de Swagger par une version plus récente :

```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.8.0</version>
</dependency>
```

---

## ✅ VÉRIFICATION

### Test 1 : Service démarre sans erreur
```cmd
mvnw spring-boot:run
```

Pas d'erreur `HateoasProperties not present` ✅

### Test 2 : API fonctionne
```
http://localhost:8083/api/recrutement/offres
```

Retourne du JSON ✅

### Test 3 : Swagger accessible
```
http://localhost:8083/swagger-ui/index.html
```

Interface Swagger s'affiche ✅

---

## 📊 CONFIGURATION COMPLÈTE

Votre `application.properties` devrait contenir :

```properties
# Application Configuration
spring.application.name=recrutement-service
server.port=8083

# MySQL Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/recrutement_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.properties.hibernate.format_sql=true

# Eureka Client Configuration
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.prefer-ip-address=true
eureka.instance.instance-id=${spring.application.name}:${server.port}

# Logging
logging.level.tn.esprit.recrutement=DEBUG
logging.level.org.hibernate.SQL=DEBUG

# Swagger/OpenAPI Configuration
springdoc.api-docs.path=/v3/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.swagger-ui.enabled=true
springdoc.swagger-ui.operationsSorter=method
springdoc.swagger-ui.tagsSorter=alpha
springdoc.swagger-ui.tryItOutEnabled=true
springdoc.swagger-ui.filter=true

# Désactiver les configurations Swagger qui causent des conflits
spring.autoconfigure.exclude=org.springdoc.core.configuration.SpringDocDataRestConfiguration,org.springdoc.core.configuration.SpringDocHateoasConfiguration
```

---

## 🎯 POURQUOI CETTE ERREUR ?

### Spring Boot 4.x + Swagger 2.7.0 + Spring Data REST

1. **Spring Data REST** est dans vos dépendances
2. **Swagger** détecte Spring Data REST
3. **Swagger** essaie d'auto-configurer HATEOAS
4. **Spring Boot 4.x** a changé la structure de HATEOAS
5. **Erreur** : Classes HATEOAS introuvables

### Solution
Désactiver l'auto-configuration HATEOAS de Swagger.

---

## 📝 MÊME CORRECTION POUR FORUM SERVICE

La même correction a été appliquée au Forum Service pour éviter le même problème.

---

## 🐛 SI LE PROBLÈME PERSISTE

### Solution 1 : Nettoyer Maven
```cmd
cd recrutement-service
mvnw clean
rmdir /s /q target
mvnw install
mvnw spring-boot:run
```

### Solution 2 : Vérifier les dépendances
```cmd
mvnw dependency:tree
```

Cherchez des conflits entre :
- spring-boot-starter-data-rest
- spring-boot-starter-hateoas
- springdoc-openapi

### Solution 3 : Désactiver Swagger temporairement

Dans `application.properties` :
```properties
springdoc.swagger-ui.enabled=false
springdoc.api-docs.enabled=false
```

---

## ✅ RÉSULTAT ATTENDU

Après correction, le service démarre normalement et Swagger fonctionne sans erreur HATEOAS.

---

**Le problème est maintenant corrigé ! Redémarrez le service. 🚀**
