# Solution Alternative - Limite 1MB

## Ce qui a été fait

J'ai réduit la limite de taille de fichier de **5MB à 1MB** pour correspondre à la limite actuelle de MySQL.

## Avantages

✅ Pas besoin de modifier MySQL
✅ Pas besoin de redémarrer le backend
✅ Fonctionne immédiatement
✅ Plus rapide pour les uploads

## Inconvénient

❌ Les fichiers > 1MB seront rejetés

## Comment Utiliser

1. **Rafraîchissez le navigateur** (Ctrl+Shift+R)
2. **Utilisez un fichier PDF < 1MB**
3. **Ou compressez votre PDF** (voir ci-dessous)

## Comment Compresser un PDF

### Option 1: En Ligne (Gratuit)

**Sites recommandés:**
- https://www.ilovepdf.com/compress_pdf
- https://smallpdf.com/compress-pdf
- https://www.pdf2go.com/compress-pdf

**Étapes:**
1. Allez sur un de ces sites
2. Uploadez votre PDF
3. Téléchargez la version compressée
4. Utilisez ce fichier dans le formulaire

### Option 2: Adobe Acrobat

1. Ouvrez votre PDF dans Adobe Acrobat
2. Fichier → Enregistrer sous autre → PDF de taille réduite
3. Choisissez la compatibilité
4. Enregistrez

### Option 3: Logiciels Gratuits

**Windows:**
- PDFtk Free
- PDF24 Creator

**Mac:**
- Aperçu (Preview)
  1. Ouvrez le PDF
  2. Fichier → Exporter
  3. Filtre Quartz → Reduce File Size

**Linux:**
```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf
```

## Tester Maintenant

1. **Rafraîchissez** le navigateur (Ctrl+Shift+R)
2. **Préparez un PDF < 1MB** (compressez si nécessaire)
3. **Remplissez le formulaire:**
   - Nom: `Dupont`
   - Prénom: `Jean`
   - Email: `test.compress.2024@example.com`
   - CV: Votre PDF compressé (< 1MB)
   - Lettre: Texte varié de 100+ caractères
4. **Soumettez**

## Vérifier la Taille d'un Fichier

**Windows:**
- Clic droit sur le fichier → Propriétés
- Regardez "Taille"

**Mac:**
- Clic droit → Lire les informations
- Regardez "Taille"

**Linux:**
```bash
ls -lh fichier.pdf
```

## Si Vous Voulez Garder 5MB

Vous devrez augmenter `max_allowed_packet` dans MySQL:

1. Éditez `my.ini` (Windows) ou `my.cnf` (Linux/Mac)
2. Ajoutez sous `[mysqld]`:
   ```ini
   max_allowed_packet=16M
   ```
3. Redémarrez MySQL
4. Redémarrez le backend
5. Changez la limite dans le code à 5MB

## Recommandations

Pour une application professionnelle:

- **1MB** est suffisant pour un CV bien formaté
- Les CVs de 1-2 pages en PDF font généralement 200-500KB
- Si votre CV fait > 1MB, il contient probablement:
  - Des images haute résolution (à compresser)
  - Des polices embarquées inutiles
  - Des métadonnées excessives

Un CV professionnel optimisé devrait faire **< 500KB**.

## Résumé

✅ **Solution immédiate:** Limite réduite à 1MB
✅ **Fonctionne maintenant:** Pas de configuration MySQL nécessaire
✅ **Utilisez:** Un PDF compressé < 1MB
✅ **Ou:** Augmentez MySQL si vous avez vraiment besoin de > 1MB

---

**Cette solution fonctionne IMMÉDIATEMENT sans aucune configuration!**
