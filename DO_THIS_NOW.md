# 🎯 DO THIS NOW - Simple Steps

## The columns already exist! That's good news.

## Step 1: Check if cv_url still exists

Run this in MySQL:

```sql
USE recrutement_db;
DESCRIBE candidature_enseignant;
```

Look for a column named `cv_url` in the output.

---

## Step 2A: If you SEE cv_url column

Run this to remove it:

```sql
USE recrutement_db;
ALTER TABLE candidature_enseignant DROP COLUMN cv_url;
```

---

## Step 2B: If you DON'T see cv_url column

Great! Migration is complete. Skip to Step 3.

---

## Step 3: Rebuild Backend

```bash
cd recrutement-service
mvn clean install -DskipTests
mvn spring-boot:run
```

Wait for the service to start (you'll see "Started RecrutementServiceApplication" in the console).

---

## Step 4: Test CV Upload

1. Go to your Angular app in browser
2. Press `Ctrl + Shift + R` to refresh
3. Click "Nouvelle Candidature"
4. Fill in the form with a **UNIQUE** email like: `test123@example.com`
5. Click the file upload button and select a PDF
6. Click "Envoyer la Candidature"

---

## Expected Results

✅ **Success**: Candidature appears in the table with a "Télécharger" button

❌ **409 Error**: You used an email that already exists
   - **Solution**: Use a different email OR delete old data:
   ```sql
   DELETE FROM candidature_enseignant WHERE email = 'test123@example.com';
   ```

---

## Quick Delete All Test Data (Optional)

If you want to start fresh:

```sql
USE recrutement_db;
DELETE FROM candidature_enseignant;
```

---

## That's It!

The feature is ready. Just:
1. ✅ Check/remove cv_url column
2. ✅ Rebuild backend
3. ✅ Use unique emails for testing

**The 409 error is NORMAL when you reuse an email!**
