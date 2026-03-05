# Quick Fix: 409 Conflict Error

## The Problem
```
Failed to load resource: the server responded with a status of 409 ()
Erreur: Cet email existe déjà. Veuillez utiliser une adresse email différente.
```

## The Cause
The email field has a **UNIQUE constraint** in the database. You're trying to use an email that already exists.

## Quick Solutions

### Solution 1: Use Different Email (Fastest)
Instead of:
```
test@example.com
```

Use:
```
test1@example.com
test2@example.com
test3@example.com
unique-email-123@example.com
```

### Solution 2: Delete Old Test Data
```sql
mysql -u root -p
USE recrutement_db;
DELETE FROM candidature_enseignant WHERE email = 'test@example.com';
```

### Solution 3: Delete All Test Candidatures
```sql
mysql -u root -p
USE recrutement_db;
DELETE FROM candidature_enseignant;
```

## This is NOT a Bug!
The 409 error is **expected behavior** when you try to use a duplicate email. The system is working correctly by preventing duplicate candidatures.

## Before Testing CV Upload

Make sure you've completed these steps:

### 1. Database Migration
```sql
mysql -u root -p
USE recrutement_db;

-- Check if migration needed
DESCRIBE candidature_enseignant;

-- If you see 'cv_url' column, run migration:
ALTER TABLE candidature_enseignant 
ADD COLUMN cv_pdf LONGBLOB AFTER email,
ADD COLUMN cv_filename VARCHAR(255) AFTER cv_pdf,
ADD COLUMN cv_content_type VARCHAR(100) AFTER cv_filename;

ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url;
```

### 2. Rebuild Backend
```bash
cd recrutement-service
mvn clean install -DskipTests
mvn spring-boot:run
```

### 3. Refresh Angular
Press `Ctrl + Shift + R` in browser

## Test Checklist

- [ ] Database migrated (cv_pdf, cv_filename, cv_content_type columns exist)
- [ ] Backend rebuilt and running
- [ ] Using UNIQUE email address
- [ ] File is PDF/DOC/DOCX
- [ ] File is less than 5MB

## Expected Results

✅ **Success**: Candidature created, appears in table, CV can be downloaded

❌ **409 Error**: Email already exists → Use different email

❌ **400 Error**: Database not migrated → Run migration

❌ **File validation error**: Wrong file type or too large → Use valid PDF < 5MB

---

**Remember**: Each candidature needs a unique email address!
