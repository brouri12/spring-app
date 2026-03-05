# CV BLOB Storage Implementation - COMPLETED

## Summary
Changed the CV storage from URL string to BLOB (byte array) in the database, allowing direct file upload and storage of PDF files.

## Changes Made

### 1. Backend Entity Update
**File:** `recrutement-service/src/main/java/tn/esprit/recrutement/entity/CandidatureEnseignant.java`

**Before:**
```java
@NotBlank(message = "L'URL du CV est obligatoire")
@ValidCvUrl(message = "URL du CV invalide...")
private String cv_url;
```

**After:**
```java
@Lob
@Column(name = "cv_pdf", columnDefinition = "LONGBLOB")
private byte[] cv_pdf;

@Column(name = "cv_filename")
private String cv_filename;

@Column(name = "cv_content_type")
private String cv_content_type;
```

**Changes:**
- Removed `cv_url` String field
- Added `cv_pdf` byte array with `@Lob` annotation for BLOB storage
- Added `cv_filename` to store original filename
- Added `cv_content_type` to store MIME type (application/pdf, etc.)

### 2. Angular Model Update
**File:** `angular-app/back-office/src/app/models/recrutement.model.ts`

**Before:**
```typescript
export interface CandidatureEnseignant {
  cv_url: string;
}
```

**After:**
```typescript
export interface CandidatureEnseignant {
  cv_pdf?: string; // Base64 encoded PDF
  cv_filename?: string;
  cv_content_type?: string;
}
```

### 3. Angular Component - File Upload
**File:** `angular-app/back-office/src/app/pages/recrutement/recrutement.ts`

**Updated postuler() method:**
```typescript
postuler() {
  if (!this.selectedFile) {
    this.error = 'Veuillez sélectionner un fichier CV';
    return;
  }

  // Convert file to Base64
  const reader = new FileReader();
  reader.onload = () => {
    const base64String = (reader.result as string).split(',')[1];
    
    const candidatureToCreate = {
      ...this.newCandidature,
      date_candidature: new Date().toISOString().split('T')[0],
      cv_pdf: base64String,
      cv_filename: this.selectedFile!.name,
      cv_content_type: this.selectedFile!.type
    };

    this.recrutementService.postuler(this.selectedOffre!.id!, candidatureToCreate).subscribe({
      // Handle response...
    });
  };

  reader.readAsDataURL(this.selectedFile);
}
```

**Added downloadCV() method:**
```typescript
downloadCV(candidature: CandidatureEnseignant) {
  // Convert Base64 to Blob
  const byteCharacters = atob(candidature.cv_pdf);
  const byteNumbers = new Array(byteCharacters.length);
  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i);
  }
  const byteArray = new Uint8Array(byteNumbers);
  const blob = new Blob([byteArray], { type: candidature.cv_content_type });

  // Create download link
  const url = window.URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = candidature.cv_filename || `CV_${candidature.nom_candidat}.pdf`;
  link.click();
  window.URL.revokeObjectURL(url);
}
```

### 4. Angular Template - Download Button
**File:** `angular-app/back-office/src/app/pages/recrutement/recrutement.html`

**Before:**
```html
<a [href]="candidature.cv_url" target="_blank">
  Voir
</a>
```

**After:**
```html
<button (click)="downloadCV(candidature)">
  <svg><!-- Download icon --></svg>
  Télécharger
</button>
```

## Database Schema Changes

### MySQL/MariaDB
```sql
ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url,
ADD COLUMN cv_pdf LONGBLOB,
ADD COLUMN cv_filename VARCHAR(255),
ADD COLUMN cv_content_type VARCHAR(100);
```

### PostgreSQL
```sql
ALTER TABLE candidature_enseignant 
DROP COLUMN cv_url,
ADD COLUMN cv_pdf BYTEA,
ADD COLUMN cv_filename VARCHAR(255),
ADD COLUMN cv_content_type VARCHAR(100);
```

## How It Works

### Upload Process
1. User selects a PDF/DOC/DOCX file
2. File is validated (size < 5MB, correct type)
3. File is converted to Base64 string using FileReader
4. Base64 string + filename + content type sent to backend
5. Backend converts Base64 to byte array and stores in database

### Download Process
1. User clicks "Télécharger" button
2. Frontend retrieves Base64 string from candidature
3. Base64 is converted back to Blob
4. Blob is downloaded with original filename

## Data Flow

```
User Upload:
File → FileReader → Base64 → HTTP POST → Backend → byte[] → Database

User Download:
Database → byte[] → HTTP GET → Base64 → Frontend → Blob → Download
```

## Advantages

✅ **No external storage needed** - Files stored directly in database
✅ **Transactional integrity** - CV and candidature data in same transaction
✅ **Simple backup** - Database backup includes all files
✅ **No broken links** - Files can't be deleted separately
✅ **Access control** - Database permissions control file access

## Disadvantages

⚠️ **Database size** - Large files increase database size
⚠️ **Performance** - Large BLOBs can slow queries
⚠️ **Memory usage** - Loading files into memory
⚠️ **Backup time** - Larger database takes longer to backup

## Best Practices

### For Production
Consider these improvements:

1. **File Size Limit**: Keep at 5MB or less
2. **Compression**: Compress PDFs before storing
3. **Lazy Loading**: Use `@Lob(fetch = FetchType.LAZY)` to avoid loading files unnecessarily
4. **Separate Table**: Consider storing files in separate table
5. **Cloud Storage**: For large scale, use S3/Azure Blob Storage instead

### Lazy Loading Example
```java
@Lob
@Basic(fetch = FetchType.LAZY)
@Column(name = "cv_pdf", columnDefinition = "LONGBLOB")
private byte[] cv_pdf;
```

## Testing

### Test Upload
1. Open candidature form
2. Select a PDF file (< 5MB)
3. Fill other fields
4. Submit form
5. Verify candidature created successfully

### Test Download
1. View candidatures table
2. Click "Télécharger" button
3. Verify file downloads with correct name
4. Open downloaded file and verify content

### Test Validation
1. Try uploading file > 5MB (should fail)
2. Try uploading .txt file (should fail)
3. Try submitting without file (should fail)

## Files Modified
1. `recrutement-service/src/main/java/tn/esprit/recrutement/entity/CandidatureEnseignant.java`
2. `angular-app/back-office/src/app/models/recrutement.model.ts`
3. `angular-app/back-office/src/app/pages/recrutement/recrutement.ts`
4. `angular-app/back-office/src/app/pages/recrutement/recrutement.html`

## Next Steps
1. Update database schema (run migration)
2. Restart backend service
3. Test file upload functionality
4. Test file download functionality
5. Consider adding lazy loading for production
