# CV Upload Feature - Complete Solution Guide

## Current Status ✅

The CV upload feature has been fully implemented in the Angular frontend:

1. ✅ File upload input with validation (PDF, DOC, DOCX, max 5MB)
2. ✅ Base64 encoding for file transmission
3. ✅ Backend entity updated to use BLOB storage
4. ✅ Download functionality for stored CVs
5. ✅ Proper error handling for 409 conflicts

## The 409 Error Explained

### What is happening?
You're seeing this error:
```
Failed to load resource: the server responded with a status of 409 ()
Erreur: Cet email existe déjà. Veuillez utiliser une adresse email différente.
```

### Why is this happening?
The `email` field in the `candidature_enseignant` table has a **UNIQUE constraint**. This means:
- Each email can only be used ONCE in the database
- If you try to submit a candidature with an email that already exists, you get a 409 Conflict error
- This is a **business rule**, not a bug

### This is EXPECTED behavior!
The unique constraint prevents duplicate candidatures from the same person.

## What You Need To Do

### Option 1: Use Different Email Addresses (Recommended for Testing)
When testing the candidature form, use a different email each time:
- `test1@example.com`
- `test2@example.com`
- `test3@example.com`
- etc.

### Option 2: Delete Old Test Data
If you want to reuse the same email, delete the old candidature first:

```sql
-- Connect to MySQL
mysql -u root -p

-- Select database
USE recrutement_db;

-- View existing candidatures
SELECT id, nom_candidat, prenom_candidat, email FROM candidature_enseignant;

-- Delete specific candidature by email
DELETE FROM candidature_enseignant WHERE email = 'test@example.com';

-- Or delete all test candidatures
DELETE FROM candidature_enseignant;
```

### Option 3: Remove Unique Constraint (NOT Recommended)
Only do this if your business requirements allow duplicate emails:

```sql
-- Remove unique constraint
ALTER TABLE candidature_enseignant 
DROP INDEX email;
```

**Warning**: This allows the same person to submit multiple candidatures, which may not be desired.

## Database Migration Required

Before the CV upload feature will work, you MUST run the database migration:

### Step 1: Check Current Schema
```sql
mysql -u root -p
USE recrutement_db;
DESCRIBE candidature_enseignant;
```

### Step 2: Run Migration (if not done yet)
```sql
-- Add new BLOB columns
ALTER TABLE candidature_enseignant 
ADD COLUMN cv_pdf LONGBLOB AFTER email,
ADD COLUMN cv_filename VARCHAR(255) AFTER cv_pdf,
ADD COLUMN cv_content_type VARCHAR(100) AFTER cv_filename;

-- Remove old URL column
ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url;

-- Verify changes
DESCRIBE candidature_enseignant;
```

Expected columns after migration:
- `id`
- `nom_candidat`
- `prenom_candidat`
- `email` (with UNIQUE constraint)
- `cv_pdf` (LONGBLOB)
- `cv_filename` (VARCHAR)
- `cv_content_type` (VARCHAR)
- `lettre_motivation`
- `date_candidature`
- `statut`
- `offre_id`

### Step 3: Rebuild Backend Service
```bash
cd recrutement-service

# Clean previous build
mvn clean

# Rebuild with new entity
mvn install -DskipTests

# Restart service
mvn spring-boot:run
```

## Testing the Feature

### Test Case 1: Successful Upload
1. Open candidature form
2. Fill in details with a **UNIQUE** email: `newuser@test.com`
3. Select a PDF file (< 5MB)
4. Submit
5. **Expected**: Success, candidature appears in table

### Test Case 2: Duplicate Email (409 Error)
1. Open candidature form
2. Fill in details with an **EXISTING** email: `newuser@test.com`
3. Select a PDF file
4. Submit
5. **Expected**: Error message "Cet email existe déjà. Veuillez utiliser une adresse email différente."

### Test Case 3: File Too Large
1. Open candidature form
2. Fill in details
3. Select a file > 5MB
4. **Expected**: Frontend validation error "Le fichier est trop volumineux. Taille maximale: 5MB"

### Test Case 4: Invalid File Type
1. Open candidature form
2. Fill in details
3. Select a .txt or .jpg file
4. **Expected**: Frontend validation error "Format de fichier non valide. Utilisez PDF, DOC ou DOCX"

### Test Case 5: Download CV
1. After successful upload
2. Click "Télécharger" button in candidatures table
3. **Expected**: CV file downloads with original filename

## Error Messages Reference

| Error Code | Message | Cause | Solution |
|------------|---------|-------|----------|
| 409 | "Cet email existe déjà..." | Email already in database | Use different email or delete old candidature |
| 400 | Validation errors | Invalid data format | Check field requirements |
| 404 | "Offre introuvable" | Invalid offre ID | Select valid offre |
| Frontend | "Le fichier est trop volumineux..." | File > 5MB | Use smaller file |
| Frontend | "Format de fichier non valide..." | Wrong file type | Use PDF, DOC, or DOCX |

## Code Changes Made

### 1. Angular Model (`recrutement.model.ts`)
```typescript
export interface CandidatureEnseignant {
  id_candidature?: number;
  nom_candidat: string;
  prenom_candidat: string;
  email: string;
  cv_pdf?: string; // Base64 encoded
  cv_filename?: string;
  cv_content_type?: string;
  lettre_motivation: string;
  date_candidature?: string | Date;
  statut: string;
}
```

### 2. Backend Entity (`CandidatureEnseignant.java`)
```java
@Lob
@Column(name = "cv_pdf", columnDefinition = "LONGBLOB")
private byte[] cv_pdf;

@Column(name = "cv_filename")
private String cv_filename;

@Column(name = "cv_content_type")
private String cv_content_type;
```

### 3. File Upload Handler (`recrutement.ts`)
- File validation (type, size)
- Base64 encoding
- Error handling for 409 conflicts
- Download functionality

## Verification Checklist

Before testing, ensure:

- [ ] Database migration completed
- [ ] Backend service rebuilt and restarted
- [ ] Angular app refreshed (Ctrl+Shift+R)
- [ ] Using unique email addresses for testing
- [ ] File is PDF/DOC/DOCX and < 5MB

## Common Questions

### Q: Why can't I use the same email twice?
**A**: The database has a unique constraint on the email field to prevent duplicate candidatures from the same person.

### Q: Can I remove the unique constraint?
**A**: Yes, but it's not recommended unless your business requirements specifically allow duplicate candidatures.

### Q: What happens to the old cv_url data?
**A**: It will be lost when you drop the column. Make sure to backup if needed.

### Q: Can I store files larger than 5MB?
**A**: Yes, but you need to:
1. Change frontend validation in `onFileSelected()`
2. Increase MySQL `max_allowed_packet` setting
3. Consider using external file storage (S3, etc.) for very large files

### Q: Why Base64 encoding?
**A**: It allows sending binary data (PDF) as JSON text. The backend converts it back to bytes for storage.

## Next Steps

1. **Run database migration** (if not done)
2. **Rebuild backend service**
3. **Test with unique emails**
4. **Verify download functionality**

## Success Indicators

You'll know everything is working when:
- ✅ Can submit candidature with unique email
- ✅ File uploads without errors
- ✅ Can download CV from table
- ✅ Get clear error message for duplicate email
- ✅ Frontend validation works for file size/type

## Need Help?

If you encounter issues:
1. Check backend console logs
2. Check browser console (F12)
3. Check Network tab for request/response
4. Verify database schema matches expected structure
5. Ensure backend was rebuilt after entity changes

---

**Summary**: The 409 error is EXPECTED when using duplicate emails. Use unique email addresses for testing, or delete old test data. The CV upload feature is fully implemented and ready to use once the database migration is complete.
