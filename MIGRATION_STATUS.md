# Database Migration Status

## Good News! ✅

The error message `#1060 - Nom du champ 'cv_content_type' déjà utilisé` means the columns **already exist**!

This means the migration was already partially or fully completed.

## What To Do Now

### Step 1: Check Current Schema

Run this in MySQL:

```sql
USE recrutement_db;
DESCRIBE candidature_enseignant;
```

### Step 2: Check If cv_url Still Exists

Look at the output from Step 1. You should see:

**✅ Good (Migration Complete)**:
- `cv_pdf` (longblob)
- `cv_filename` (varchar)
- `cv_content_type` (varchar)
- NO `cv_url` column

**⚠️ Needs Action (Migration Incomplete)**:
- `cv_pdf` (longblob) ✅
- `cv_filename` (varchar) ✅
- `cv_content_type` (varchar) ✅
- `cv_url` (varchar) ❌ Still exists!

### Step 3: If cv_url Still Exists, Remove It

```sql
USE recrutement_db;
ALTER TABLE candidature_enseignant DROP COLUMN cv_url;
```

### Step 4: Verify Final Schema

```sql
DESCRIBE candidature_enseignant;
```

**Expected columns**:
1. `id` (bigint, PK)
2. `nom_candidat` (varchar)
3. `prenom_candidat` (varchar)
4. `email` (varchar, UNIQUE)
5. `cv_pdf` (longblob)
6. `cv_filename` (varchar)
7. `cv_content_type` (varchar)
8. `lettre_motivation` (varchar)
9. `date_candidature` (date)
10. `statut` (varchar)
11. `offre_id` (bigint, FK)

## Next Steps After Verifying Schema

### 1. Rebuild Backend Service

```bash
cd recrutement-service
mvn clean install -DskipTests
mvn spring-boot:run
```

### 2. Test CV Upload

1. Refresh Angular app (Ctrl+Shift+R)
2. Open candidature form
3. Use UNIQUE email: `test1@example.com`
4. Select PDF file (< 5MB)
5. Submit
6. ✅ Should work!

## About the 409 Error

The 409 error you're seeing is **NORMAL** and **EXPECTED** when you try to use an email that already exists.

### Solution: Use Different Emails

For each test, use a unique email:
- `test1@example.com`
- `test2@example.com`
- `test3@example.com`
- `john.doe.2024@example.com`

### Or: Delete Old Test Data

```sql
USE recrutement_db;

-- View existing candidatures
SELECT id, nom_candidat, prenom_candidat, email FROM candidature_enseignant;

-- Delete all test data
DELETE FROM candidature_enseignant;

-- Or delete specific email
DELETE FROM candidature_enseignant WHERE email = 'test@example.com';
```

## Summary

1. ✅ Database columns already exist (that's why you got the error)
2. ⚠️ Check if `cv_url` column still exists and remove it if needed
3. 🔨 Rebuild backend service
4. 📧 Use unique email addresses for testing
5. 🎉 Feature should work perfectly!

## Quick Commands

```bash
# Check schema
mysql -u root -p -e "USE recrutement_db; DESCRIBE candidature_enseignant;"

# Remove cv_url if it exists
mysql -u root -p -e "USE recrutement_db; ALTER TABLE candidature_enseignant DROP COLUMN cv_url;"

# Clear test data
mysql -u root -p -e "USE recrutement_db; DELETE FROM candidature_enseignant;"

# Rebuild backend
cd recrutement-service && mvn clean install -DskipTests && mvn spring-boot:run
```

---

**Bottom Line**: The new columns already exist! Just verify the schema, remove `cv_url` if it's still there, rebuild the backend, and use unique emails for testing. 🚀
