# Script de Verification du Menu de Navigation
# Execution: .\VERIFIER_MENU.ps1

Write-Host "`n=== VERIFICATION DU MENU DE NAVIGATION ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Verifier que l'application est en cours
Write-Host "1. Test de l'application frontend" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

try {
    $response = Invoke-WebRequest -Uri "http://localhost:56322" -Method GET -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  OK Application accessible" -ForegroundColor Green
    Write-Host "  URL: http://localhost:56322/" -ForegroundColor Gray
    $appRunning = $true
} catch {
    Write-Host "  ERREUR Application non accessible" -ForegroundColor Red
    $appRunning = $false
}

# Test 2: Verifier les fichiers sources
Write-Host "`n2. Verification des fichiers sources" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

$headerTs = "angular-app/frontend/angular-app/src/app/components/header/header.ts"
$headerHtml = "angular-app/frontend/angular-app/src/app/components/header/header.html"
$routes = "angular-app/frontend/angular-app/src/app/app.routes.ts"
$frJson = "angular-app/frontend/angular-app/src/assets/i18n/fr.json"
$enJson = "angular-app/frontend/angular-app/src/assets/i18n/en.json"

$filesOk = 0

if (Test-Path $headerTs) {
    Write-Host "  OK Header TypeScript" -ForegroundColor Green
    $filesOk++
} else {
    Write-Host "  ERREUR Header TypeScript manquant" -ForegroundColor Red
}

if (Test-Path $headerHtml) {
    Write-Host "  OK Header HTML" -ForegroundColor Green
    $filesOk++
} else {
    Write-Host "  ERREUR Header HTML manquant" -ForegroundColor Red
}

if (Test-Path $routes) {
    Write-Host "  OK Routes" -ForegroundColor Green
    $filesOk++
} else {
    Write-Host "  ERREUR Routes manquant" -ForegroundColor Red
}

if (Test-Path $frJson) {
    Write-Host "  OK Traductions FR" -ForegroundColor Green
    $filesOk++
} else {
    Write-Host "  ERREUR Traductions FR manquant" -ForegroundColor Red
}

if (Test-Path $enJson) {
    Write-Host "  OK Traductions EN" -ForegroundColor Green
    $filesOk++
} else {
    Write-Host "  ERREUR Traductions EN manquant" -ForegroundColor Red
}

# Test 3: Verifier le contenu du header.ts
Write-Host "`n3. Verification du contenu de header.ts" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

if (Test-Path $headerTs) {
    $content = Get-Content $headerTs -Raw
    
    $checksOk = 0
    
    if ($content -match "navLinks") {
        Write-Host "  OK navLinks defini" -ForegroundColor Green
        $checksOk++
    } else {
        Write-Host "  ERREUR navLinks non trouve" -ForegroundColor Red
    }
    
    if ($content -match "HEADER.COURSES") {
        Write-Host "  OK COURSES" -ForegroundColor Green
        $checksOk++
    } else {
        Write-Host "  ERREUR COURSES non trouve" -ForegroundColor Red
    }
    
    if ($content -match "HEADER.FORUMS") {
        Write-Host "  OK FORUMS" -ForegroundColor Green
        $checksOk++
    } else {
        Write-Host "  ERREUR FORUMS non trouve" -ForegroundColor Red
    }
    
    if ($content -match "HEADER.RECRUITMENT") {
        Write-Host "  OK RECRUITMENT" -ForegroundColor Green
        $checksOk++
    } else {
        Write-Host "  ERREUR RECRUITMENT non trouve" -ForegroundColor Red
    }
    
    if ($content -match "HEADER.PRICING") {
        Write-Host "  OK PRICING" -ForegroundColor Green
        $checksOk++
    } else {
        Write-Host "  ERREUR PRICING non trouve" -ForegroundColor Red
    }
    
    if ($content -match "HEADER.ABOUT") {
        Write-Host "  OK ABOUT" -ForegroundColor Green
        $checksOk++
    } else {
        Write-Host "  ERREUR ABOUT non trouve" -ForegroundColor Red
    }
} else {
    Write-Host "  ERREUR Fichier header.ts non trouve" -ForegroundColor Red
    $checksOk = 0
}

# Test 4: Verifier les traductions
Write-Host "`n4. Verification des traductions" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

if (Test-Path $frJson) {
    $frContent = Get-Content $frJson -Raw | ConvertFrom-Json
    
    if ($frContent.HEADER) {
        Write-Host "  OK Section HEADER existe en francais" -ForegroundColor Green
        
        if ($frContent.HEADER.COURSES) {
            Write-Host "    OK HEADER.COURSES = '$($frContent.HEADER.COURSES)'" -ForegroundColor Green
        }
        if ($frContent.HEADER.FORUMS) {
            Write-Host "    OK HEADER.FORUMS = '$($frContent.HEADER.FORUMS)'" -ForegroundColor Green
        }
        if ($frContent.HEADER.RECRUITMENT) {
            Write-Host "    OK HEADER.RECRUITMENT = '$($frContent.HEADER.RECRUITMENT)'" -ForegroundColor Green
        }
        if ($frContent.HEADER.PRICING) {
            Write-Host "    OK HEADER.PRICING = '$($frContent.HEADER.PRICING)'" -ForegroundColor Green
        }
        if ($frContent.HEADER.ABOUT) {
            Write-Host "    OK HEADER.ABOUT = '$($frContent.HEADER.ABOUT)'" -ForegroundColor Green
        }
    } else {
        Write-Host "  ERREUR Section HEADER manquante" -ForegroundColor Red
    }
}

# Test 5: Tester les URLs
if ($appRunning) {
    Write-Host "`n5. Test des URLs de navigation" -ForegroundColor Yellow
    Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray
    
    $urls = @(
        "http://localhost:56322/",
        "http://localhost:56322/courses",
        "http://localhost:56322/forums",
        "http://localhost:56322/recrutement",
        "http://localhost:56322/pricing",
        "http://localhost:56322/about"
    )
    
    $urlsOk = 0
    foreach ($url in $urls) {
        try {
            $response = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
            Write-Host "  OK $url" -ForegroundColor Green
            $urlsOk++
        } catch {
            Write-Host "  ERREUR $url" -ForegroundColor Red
        }
    }
}

# Resume
Write-Host "`n=== RESUME ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "  Application:             " -NoNewline
if ($appRunning) {
    Write-Host "OK En cours" -ForegroundColor Green
} else {
    Write-Host "ERREUR Non accessible" -ForegroundColor Red
}

Write-Host "  Fichiers sources:        " -NoNewline
if ($filesOk -eq 5) {
    Write-Host "OK $filesOk/5" -ForegroundColor Green
} else {
    Write-Host "ERREUR $filesOk/5" -ForegroundColor Red
}

Write-Host "  Configuration navLinks:  " -NoNewline
if ($checksOk -eq 6) {
    Write-Host "OK $checksOk/6" -ForegroundColor Green
} else {
    Write-Host "ERREUR $checksOk/6" -ForegroundColor Red
}

if ($appRunning) {
    Write-Host "  URLs accessibles:        " -NoNewline
    if ($urlsOk -eq 6) {
        Write-Host "OK $urlsOk/6" -ForegroundColor Green
    } else {
        Write-Host "ERREUR $urlsOk/6" -ForegroundColor Red
    }
}

# Conclusion
Write-Host "`n=== CONCLUSION ===" -ForegroundColor Cyan
Write-Host ""

if ($appRunning -and $filesOk -eq 5 -and $checksOk -eq 6) {
    Write-Host "  OK Le menu de navigation est correctement configure!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Si vous ne voyez pas le menu dans le navigateur:" -ForegroundColor Yellow
    Write-Host "    1. Videz le cache: Ctrl + Shift + R" -ForegroundColor Gray
    Write-Host "    2. Rechargez la page: F5" -ForegroundColor Gray
    Write-Host "    3. Verifiez la console: F12" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Le menu devrait apparaitre en haut de la page:" -ForegroundColor White
    Write-Host "    Cours  Forums  Recrutement  Tarifs  A propos" -ForegroundColor Cyan
} else {
    Write-Host "  ATTENTION Des problemes ont ete detectes!" -ForegroundColor Yellow
    Write-Host ""
    
    if (-not $appRunning) {
        Write-Host "  Action requise: Demarrer l application" -ForegroundColor White
        Write-Host "    cd angular-app/frontend/angular-app" -ForegroundColor Gray
        Write-Host "    npm start" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "  Documentation: MENU_NAVIGATION_FRONTEND.md" -ForegroundColor Cyan
Write-Host ""
