# 🚀 QUICK FIX - Run These Commands Now

## The Problem
Your PDF file (1.8MB) is larger than MySQL's packet limit (1MB).

## The Solution (2 minutes)

### Step 1: Open MySQL
```bash
mysql -u root -p
```
Enter your password.

### Step 2: Increase Packet Size
```sql
SET GLOBAL max_allowed_packet=16777216;
```

### Step 3: Verify
```sql
SHOW VARIABLES LIKE 'max_allowed_packet';
```
Should show: `16777216`

### Step 4: Clear Test Data
```sql
USE recrutement_db;
DELETE FROM candidature_enseignant;
EXIT;
```

### Step 5: Restart Backend
```bash
cd recrutement-service
# Press Ctrl+C if running
mvn spring-boot:run
```

### Step 6: Test Upload
1. Refresh browser (Ctrl+Shift+R)
2. Open candidature form
3. Use unique email: `test1@example.com`
4. Select your PDF
5. Submit

## Expected Result
✅ Success! Candidature created and appears in table.

---

**That's it!** The 16MB limit will handle PDFs up to 16MB.
