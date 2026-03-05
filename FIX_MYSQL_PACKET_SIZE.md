# Fix MySQL Packet Size Error

## The Real Problem

The error message shows:
```
Packet for query is too large (1 827 155 > 1 048 576). 
You can change this value on the server by setting the 'max_allowed_packet' variable.
```

Your PDF file is about 1.8MB, but MySQL's `max_allowed_packet` is only 1MB (default).

## Solution: Increase MySQL Packet Size

### Option 1: Temporary Fix (Session Only)

Run this in MySQL:

```sql
SET GLOBAL max_allowed_packet=16777216;
```

This sets it to 16MB (16 * 1024 * 1024 bytes).

**Note**: This will reset when MySQL restarts.

### Option 2: Permanent Fix (Recommended)

#### For Windows:

1. Find your MySQL configuration file:
   - Usually at: `C:\ProgramData\MySQL\MySQL Server X.X\my.ini`
   - Or: `C:\Program Files\MySQL\MySQL Server X.X\my.ini`

2. Open `my.ini` with administrator privileges (Notepad as Admin)

3. Find the `[mysqld]` section and add or modify:
   ```ini
   [mysqld]
   max_allowed_packet=16M
   ```

4. Restart MySQL service:
   ```bash
   # Open Command Prompt as Administrator
   net stop MySQL80
   net start MySQL80
   ```
   (Replace MySQL80 with your MySQL service name)

#### For Linux/Mac:

1. Edit MySQL config:
   ```bash
   sudo nano /etc/mysql/my.cnf
   # or
   sudo nano /etc/my.cnf
   ```

2. Add under `[mysqld]`:
   ```ini
   [mysqld]
   max_allowed_packet=16M
   ```

3. Restart MySQL:
   ```bash
   sudo systemctl restart mysql
   # or
   sudo service mysql restart
   ```

### Option 3: Quick Fix via MySQL Command Line

```bash
# Connect to MySQL
mysql -u root -p

# Set the packet size
SET GLOBAL max_allowed_packet=16777216;

# Verify the change
SHOW VARIABLES LIKE 'max_allowed_packet';

# Exit
EXIT;
```

## Verify the Change

After making the change, verify it:

```sql
SHOW VARIABLES LIKE 'max_allowed_packet';
```

You should see:
```
+--------------------+----------+
| Variable_name      | Value    |
+--------------------+----------+
| max_allowed_packet | 16777216 |
+--------------------+----------+
```

## Restart Backend Service

After changing MySQL settings:

```bash
cd recrutement-service
# Stop if running (Ctrl+C)
mvn spring-boot:run
```

## Test Again

1. Refresh Angular app (Ctrl+Shift+R)
2. Clear old test data:
   ```sql
   DELETE FROM candidature_enseignant;
   ```
3. Try uploading a PDF again with a unique email

## Recommended Packet Sizes

- **16MB** (16777216 bytes) - Good for most PDFs
- **32MB** (33554432 bytes) - For larger files
- **64MB** (67108864 bytes) - Maximum recommended

## Alternative: Reduce File Size

If you can't change MySQL settings, reduce the frontend validation:

In `recrutement.ts`, change:
```typescript
const maxSize = 5 * 1024 * 1024; // 5MB
```

To:
```typescript
const maxSize = 1 * 1024 * 1024; // 1MB (to match MySQL limit)
```

But it's better to increase MySQL's limit!

## Summary

1. Run: `SET GLOBAL max_allowed_packet=16777216;` in MySQL
2. Or edit `my.ini`/`my.cnf` and add `max_allowed_packet=16M`
3. Restart MySQL service
4. Restart backend service
5. Clear test data: `DELETE FROM candidature_enseignant;`
6. Test with unique email

This will fix the packet size error! 🚀
