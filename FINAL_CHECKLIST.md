# ✅ Final Checklist - CV Upload Feature

## Current Status

### Database ✅ (Mostly Done)
- ✅ `cv_pdf` column exists
- ✅ `cv_filename` column exists  
- ✅ `cv_content_type` column exists
- ❓ `cv_url` column - **CHECK IF IT STILL EXISTS**

### Code ✅ (Complete)
- ✅ Angular model updated
- ✅ File upload component implemented
- ✅ File validation (type, size)
- ✅ Base64 encoding
- ✅ Download functionality
- ✅ Error handling for 409

### Backend ⏳ (Needs Rebuild)
- ✅ Entity updated in code
- ⏳ Service needs restart with new entity

---

## Your Action Items

### [ ] 1. Verify Database Schema

```sql
USE recrutement_db;
DESCRIBE candidature_enseignant;
```

**Look for**: Does `cv_url` column still exist?

- **If YES**: Go to item 2
- **If NO**: Skip to item 3

---

### [ ] 2. Remove cv_url Column (If It Exists)

```sql
USE recrutement_db;
ALTER TABLE candidature_enseignant DROP COLUMN cv_url;
```

---

### [ ] 3. Rebuild Backend Service

```bash
# Stop current service (Ctrl+C if running)
cd recrutement-service
mvn clean install -DskipTests
mvn spring-boot:run
```

**Wait for**: "Started RecrutementServiceApplication" message

---

### [ ] 4. Refresh Angular App

In browser: `Ctrl + Shift + R`

---

### [ ] 5. Test Upload

1. Click "Nouvelle Candidature"
2. Fill form with **UNIQUE** email: `testuser1@example.com`
3. Select PDF file (< 5MB)
4. Submit

**Expected**: ✅ Success, candidature appears in table

---

### [ ] 6. Test Download

1. Find candidature in table
2. Click "Télécharger" button

**Expected**: ✅ CV file downloads

---

### [ ] 7. Test Duplicate Email (Should Fail)

1. Click "Nouvelle Candidature"
2. Use **SAME** email: `testuser1@example.com`
3. Submit

**Expected**: ❌ Error "Cet email existe déjà..."

**This is CORRECT behavior!**

---

## Troubleshooting

### Problem: Still getting 409 errors
**Cause**: Email already exists in database  
**Solution**: Use different email OR delete old data:
```sql
DELETE FROM candidature_enseignant WHERE email = 'testuser1@example.com';
```

### Problem: Getting 400 errors
**Cause**: Database schema mismatch  
**Solution**: Verify `cv_url` column is removed (item 2)

### Problem: Backend won't start
**Cause**: Compilation error  
**Solution**: Check backend console for errors, ensure entity matches database

### Problem: File upload not working
**Cause**: Backend not rebuilt  
**Solution**: Complete item 3 again

---

## Success Criteria

You'll know everything works when:

- ✅ Can submit candidature with unique email
- ✅ File uploads without errors
- ✅ Can download CV from table
- ✅ Get clear error for duplicate email
- ✅ Frontend validation works for file size/type

---

## Quick Reference

### Valid Test Emails
```
test1@example.com
test2@example.com
test3@example.com
john.doe.2024@example.com
jane.smith.123@example.com
```

### Clear All Test Data
```sql
USE recrutement_db;
DELETE FROM candidature_enseignant;
```

### Check What Emails Exist
```sql
USE recrutement_db;
SELECT id, nom_candidat, prenom_candidat, email FROM candidature_enseignant;
```

---

## Summary

1. ✅ Code is ready
2. ✅ Database columns exist
3. ❓ Check if cv_url needs removal
4. ⏳ Rebuild backend
5. 📧 Use unique emails

**You're almost there!** Just verify the database schema and rebuild the backend. 🚀
