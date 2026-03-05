# ⚠️ ACTION REQUIRED: Complete CV Upload Setup

## Current Situation

✅ **Frontend**: Fully implemented and ready
✅ **Backend Code**: Entity updated and ready
❌ **Database**: Migration NOT run yet
❌ **Backend Service**: Needs rebuild with new entity

## The 409 Error You're Seeing

```
Failed to load resource: the server responded with a status of 409 ()
Erreur: Cet email existe déjà. Veuillez utiliser une adresse email différente.
```

### This is NORMAL!
The error means you're trying to use an email that already exists in the database. The email field has a UNIQUE constraint to prevent duplicate candidatures.

## Immediate Actions Needed

### Action 1: Use Different Emails for Testing ⚡ (Quickest)

Instead of reusing the same email, use unique ones:
```
test1@example.com
test2@example.com
test3@example.com
john.doe.123@example.com
```

**This will immediately stop the 409 errors!**

### Action 2: Run Database Migration 🗄️ (Required)

Open MySQL and run:

```sql
mysql -u root -p
USE recrutement_db;

-- Check current schema
DESCRIBE candidature_enseignant;

-- If you see 'cv_url' column, run this migration:
ALTER TABLE candidature_enseignant 
ADD COLUMN cv_pdf LONGBLOB AFTER email,
ADD COLUMN cv_filename VARCHAR(255) AFTER cv_pdf,
ADD COLUMN cv_content_type VARCHAR(100) AFTER cv_filename;

ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url;

-- Verify changes
DESCRIBE candidature_enseignant;
```

**Expected result**: You should see `cv_pdf`, `cv_filename`, `cv_content_type` columns and NO `cv_url` column.

### Action 3: Rebuild Backend Service 🔨 (Required)

```bash
# Stop the running service (Ctrl+C)

# Navigate to service directory
cd recrutement-service

# Clean and rebuild
mvn clean install -DskipTests

# Restart service
mvn spring-boot:run
```

### Action 4: Refresh Angular App 🔄

In your browser:
- Press `Ctrl + Shift + R` (hard refresh)
- Or clear cache and reload

## Testing After Setup

### Test 1: Successful Upload
1. Open candidature form
2. Fill in: `newuser1@test.com` (UNIQUE email)
3. Select a PDF file (< 5MB)
4. Submit
5. ✅ Should succeed and show in table

### Test 2: Download CV
1. Find the candidature in table
2. Click "Télécharger" button
3. ✅ CV should download

### Test 3: Duplicate Email (Expected to Fail)
1. Open candidature form
2. Fill in: `newuser1@test.com` (same email as before)
3. Select a PDF file
4. Submit
5. ❌ Should show: "Cet email existe déjà..."

## Quick Troubleshooting

### Still getting 409 errors?
→ You're using an email that already exists. Use a different email!

### Getting 400 errors?
→ Database migration not run. Complete Action 2.

### File upload not working?
→ Backend not rebuilt. Complete Action 3.

### Can't download CV?
→ Database migration not run. Complete Action 2.

## Optional: Clean Test Data

If you want to reuse emails, delete old test data:

```sql
mysql -u root -p
USE recrutement_db;

-- View all candidatures
SELECT id, nom_candidat, email FROM candidature_enseignant;

-- Delete specific email
DELETE FROM candidature_enseignant WHERE email = 'test@example.com';

-- Or delete all test data
DELETE FROM candidature_enseignant;
```

## Summary

1. **For immediate testing**: Use unique email addresses (test1@, test2@, etc.)
2. **For full functionality**: Run database migration + rebuild backend
3. **The 409 error is NORMAL**: It means email already exists

## Need More Info?

Read these documents:
- `CV_UPLOAD_SOLUTION.md` - Complete guide
- `QUICK_FIX_409_ERROR.md` - Quick reference
- `SUMMARY_CV_UPLOAD_IMPLEMENTATION.md` - What was implemented

---

**Bottom Line**: Use unique emails for testing, run the database migration, rebuild the backend, and everything will work perfectly! 🚀
