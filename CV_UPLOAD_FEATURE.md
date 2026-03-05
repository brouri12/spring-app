# CV Upload Feature - COMPLETED

## Summary
Changed the CV URL input field to a file upload field in the candidature form, allowing users to upload CV files directly instead of providing a URL.

## Changes Made

### 1. HTML Template Update
**File:** `angular-app/back-office/src/app/pages/recrutement/recrutement.html`

**Before:**
```html
<div>
  <label>URL du CV *</label>
  <input
    [(ngModel)]="newCandidature.cv_url"
    name="cv_url"
    placeholder="https://..."
    type="text"
  />
</div>
```

**After:**
```html
<div>
  <label>CV *</label>
  <input
    type="file"
    (change)="onFileSelected($event)"
    accept=".pdf,.doc,.docx"
    class="file-input-styled"
  />
  <p>Fichier sélectionné: {{ selectedFileName }}</p>
  <p>Formats acceptés: PDF, DOC, DOCX (Max 5MB)</p>
</div>
```

### 2. TypeScript Component Update
**File:** `angular-app/back-office/src/app/pages/recrutement/recrutement.ts`

**Added Properties:**
```typescript
selectedFile: File | null = null;
selectedFileName: string = '';
```

**Added Method:**
```typescript
onFileSelected(event: Event) {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    const file = input.files[0];
    
    // Validate file size (5MB max)
    const maxSize = 5 * 1024 * 1024;
    if (file.size > maxSize) {
      this.error = 'Le fichier est trop volumineux. Taille maximale: 5MB';
      return;
    }

    // Validate file type
    const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    if (!allowedTypes.includes(file.type)) {
      this.error = 'Format de fichier non valide. Utilisez PDF, DOC ou DOCX';
      return;
    }

    this.selectedFile = file;
    this.selectedFileName = file.name;
    this.error = '';
  }
}
```

**Updated postuler() Method:**
```typescript
postuler() {
  if (!this.selectedFile) {
    this.error = 'Veuillez sélectionner un fichier CV';
    return;
  }

  const candidatureToCreate = {
    ...this.newCandidature,
    date_candidature: new Date().toISOString().split('T')[0],
    cv_url: `uploads/cv/${this.selectedFile.name}` // Placeholder URL
  };

  // Submit candidature...
}
```

## Features

### File Upload Input
- **Styled file input** with gradient button
- **File type restriction**: Only PDF, DOC, DOCX
- **File size limit**: Maximum 5MB
- **Visual feedback**: Shows selected filename
- **Dark mode support**: Full styling for dark theme

### Validation
1. **File size validation**: Rejects files larger than 5MB
2. **File type validation**: Only accepts PDF, DOC, DOCX formats
3. **Required field**: Must select a file before submitting
4. **Error messages**: Clear feedback for validation failures

### User Experience
- Shows selected filename after choosing a file
- Displays accepted formats and size limit
- Styled upload button with gradient colors
- Hover effects on file input button
- Clear error messages

## File Input Styling

The file input has custom styling:
- **Upload button**: Gradient from green to orange (template colors)
- **Button text**: "Choose File" (browser default)
- **Hover effect**: Opacity change
- **Dark mode**: Adjusted colors for dark theme

## Important Notes

### Current Implementation
The current implementation creates a **placeholder URL** for the CV:
```typescript
cv_url: `uploads/cv/${this.selectedFile.name}`
```

### For Production
To implement actual file upload, you need to:

1. **Create a file upload endpoint** in the backend:
```java
@PostMapping("/upload/cv")
public ResponseEntity<String> uploadCV(@RequestParam("file") MultipartFile file) {
    // Save file to server or cloud storage
    // Return the file URL
    String fileUrl = fileStorageService.store(file);
    return ResponseEntity.ok(fileUrl);
}
```

2. **Update the Angular service** to upload the file first:
```typescript
uploadCV(file: File): Observable<string> {
  const formData = new FormData();
  formData.append('file', file);
  return this.http.post<string>(`${this.apiUrl}/upload/cv`, formData);
}
```

3. **Update the postuler() method** to upload file before creating candidature:
```typescript
postuler() {
  if (!this.selectedFile) return;

  // First upload the CV file
  this.recrutementService.uploadCV(this.selectedFile).subscribe({
    next: (cvUrl) => {
      // Then create candidature with the returned URL
      const candidatureToCreate = {
        ...this.newCandidature,
        date_candidature: new Date().toISOString().split('T')[0],
        cv_url: cvUrl
      };
      
      this.recrutementService.postuler(this.selectedOffre.id, candidatureToCreate).subscribe({
        // Handle success...
      });
    },
    error: (err) => {
      this.error = 'Erreur lors du téléchargement du CV';
    }
  });
}
```

## Testing

1. Open the candidature form
2. Click on the file input
3. Select a PDF, DOC, or DOCX file
4. Verify the filename appears below the input
5. Try uploading a file larger than 5MB (should show error)
6. Try uploading an invalid file type (should show error)
7. Submit the form with a valid file

## Files Modified
1. `angular-app/back-office/src/app/pages/recrutement/recrutement.html`
2. `angular-app/back-office/src/app/pages/recrutement/recrutement.ts`
