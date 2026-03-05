# Fix CV Upload Errors - 400 & 409

## Current Errors
- **400 Bad Request**: Backend validation failing
- **409 Conflict**: Email already exists (unique constraint)

## Root Causes

### 1. Database Schema Not Updated
The database still has the old `cv_url` column but the entity expects `cv_pdf`, `cv_filename`, `cv_content_type`.

### 2. Backend Not Recompiled
The backend service needs to be rebuilt with the new entity changes.

### 3. Email Uniqueness
The email field has a unique constraint, so you can't submit multiple candidatures with the same email.

## Solution Steps

### Step 1: Stop Backend Service
```bash
# Stop the recrutement-service if it's running
# Press Ctrl+C in the terminal where it's running
```

### Step 2: Update Database Schema
Run the migration script:

```bash
# Connect to MySQL
mysql -u root -p

# Select the database
USE recrutement_db;

# Run the migration
source DATABASE_MIGRATION_CV_BLOB.sql;

# Or copy-paste these commands:
ALTER TABLE candidature_enseignant 
ADD COLUMN cv_pdf LONGBLOB AFTER email,
ADD COLUMN cv_filename VARCHAR(255) AFTER cv_pdf,
ADD COLUMN cv_content_type VARCHAR(100) AFTER cv_filename;

ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url;

# Verify
DESCRIBE candidature_enseignant;
```

### Step 3: Clean and Rebuild Backend
```bash
cd recrutement-service

# Clean previous build
mvn clean

# Rebuild
mvn install -DskipTests

# Or if using your IDE, do:
# Right-click project → Maven → Reimport
# Then: Run → Clean and Build
```

### Step 4: Restart Backend Service
```bash
cd recrutement-service
mvn spring-boot:run

# Or run from your IDE
```

### Step 5: Clear Existing Test Data (Optional)
If you have test candidatures with duplicate emails:

```sql
-- Delete all candidatures (be careful!)
DELETE FROM candidature_enseignant;

-- Or delete specific ones
DELETE FROM candidature_enseignant WHERE email = 'test@example.com';
```

### Step 6: Test Upload
1. Refresh Angular application (Ctrl+Shift+R)
2. Open candidature form
3. Use a UNIQUE email address
4. Select a PDF file
5. Submit

## Detailed Error Analysis

### 400 Bad Request
**Cause**: Backend validation failing because:
- Old validation expects `cv_url` field
- Database schema mismatch
- Entity not matching database

**Solution**: 
- Update database schema ✅
- Rebuild backend ✅
- Restart service ✅

### 409 Conflict
**Cause**: Email already exists in database

**Solution**: 
- Use different email for each candidature
- Or remove unique constraint (not recommended)
- Or delete old test data

## Verification Checklist

After completing all steps:

- [ ] Database has `cv_pdf`, `cv_filename`, `cv_content_type` columns
- [ ] Database does NOT have `cv_url` column
- [ ] Backend service starts without errors
- [ ] Backend logs show no validation errors
- [ ] Can submit candidature with unique email
- [ ] File uploads successfully
- [ ] Can download CV from table

## Common Issues

### Issue 1: "Column 'cv_url' doesn't exist"
**Solution**: Database migration not run. Run Step 2 again.

### Issue 2: "Column 'cv_pdf' already exists"
**Solution**: Migration already run. Skip Step 2.

### Issue 3: Still getting 400 error
**Solution**: 
1. Check backend logs for exact error
2. Verify entity matches database schema
3. Ensure backend was rebuilt
4. Restart backend service

### Issue 4: Still getting 409 error
**Solution**: 
1. Use a different email address
2. Or delete existing candidature with that email
3. Check if email is truly unique

## Testing Different Scenarios

### Test 1: Valid Upload
```
Email: unique@test.com
File: valid.pdf (< 5MB)
Expected: Success (201 Created)
```

### Test 2: Duplicate Email
```
Email: existing@test.com (already in DB)
File: valid.pdf
Expected: 409 Conflict
```

### Test 3: Large File
```
Email: unique2@test.com
File: large.pdf (> 5MB)
Expected: Frontend validation error
```

### Test 4: Invalid File Type
```
Email: unique3@test.com
File: document.txt
Expected: Frontend validation error
```

## Backend Logs to Check

Look for these in backend console:

### Success:
```
POST /api/recrutement/candidatures/offre/1 - 201 Created
```

### Validation Error (400):
```
Validation failed for object='candidatureEnseignant'
Field error in object 'candidatureEnseignant' on field 'cv_url'
```

### Conflict Error (409):
```
Duplicate entry 'test@example.com' for key 'email'
```

## Quick Fix Commands

### Reset Everything
```bash
# 1. Stop backend
Ctrl+C

# 2. Update database
mysql -u root -p recrutement_db < DATABASE_MIGRATION_CV_BLOB.sql

# 3. Clean test data
mysql -u root -p -e "DELETE FROM recrutement_db.candidature_enseignant;"

# 4. Rebuild backend
cd recrutement-service
mvn clean install -DskipTests

# 5. Restart backend
mvn spring-boot:run
```

## If Still Not Working

1. **Check Entity File**: Verify `CandidatureEnseignant.java` has the correct fields
2. **Check Database**: Run `DESCRIBE candidature_enseignant;`
3. **Check Backend Logs**: Look for exact error message
4. **Check Angular Console**: Look for request payload
5. **Check Network Tab**: See what data is being sent

## Contact Points

If errors persist, check:
1. Backend console output
2. MySQL error logs
3. Angular browser console
4. Network tab in DevTools

Provide these logs for further debugging.
