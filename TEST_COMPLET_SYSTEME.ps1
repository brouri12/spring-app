# Script de Test Complet du Systeme
# Execution: .\TEST_COMPLET_SYSTEME.ps1

Write-Host "`n=== TEST COMPLET DU SYSTEME - PIDEV 4 ===" -ForegroundColor Cyan
Write-Host ""

# Fonction pour tester un endpoint
function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Method = "GET"
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -Method $Method -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        Write-Host "  OK $Name" -ForegroundColor Green -NoNewline
        Write-Host " (Status: $($response.StatusCode))" -ForegroundColor Gray
        return $true
    } catch {
        Write-Host "  ERREUR $Name" -ForegroundColor Red -NoNewline
        if ($_.Exception.Response) {
            Write-Host " (Status: $($_.Exception.Response.StatusCode.value__))" -ForegroundColor Gray
        } else {
            Write-Host " (Non accessible)" -ForegroundColor Gray
        }
        return $false
    }
}

# Test 1: Services Angular
Write-Host "1. Services Angular" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

$frontendOk = Test-Endpoint "Frontend Public" "http://localhost:56322"
$backofficeOk = Test-Endpoint "Back-Office" "http://localhost:4201"

# Test 2: Backend Forum Service
Write-Host "`n2. Backend Forum Service (Port 8082)" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

$endpoints = @(
    @{Name="Forums"; Url="http://localhost:8082/api/forum/forums"},
    @{Name="Messages"; Url="http://localhost:8082/api/forum/messages"},
    @{Name="Interactions (Likes)"; Url="http://localhost:8082/api/interactions/likes"},
    @{Name="Notifications"; Url="http://localhost:8082/api/notifications"},
    @{Name="Badges"; Url="http://localhost:8082/api/badges"},
    @{Name="Statistiques"; Url="http://localhost:8082/api/analyse/statistiques"}
)

$backendSuccess = 0
foreach ($endpoint in $endpoints) {
    if (Test-Endpoint $endpoint.Name $endpoint.Url) {
        $backendSuccess++
    }
}

# Test 3: Fichiers de Traduction
Write-Host "`n3. Fichiers de Traduction i18n" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

$translationFiles = @(
    "angular-app/frontend/angular-app/src/assets/i18n/fr.json",
    "angular-app/frontend/angular-app/src/assets/i18n/en.json",
    "angular-app/back-office/src/assets/i18n/fr.json",
    "angular-app/back-office/src/assets/i18n/en.json"
)

$translationSuccess = 0
foreach ($file in $translationFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        Write-Host "  OK $file" -ForegroundColor Green -NoNewline
        Write-Host " ($size bytes)" -ForegroundColor Gray
        $translationSuccess++
    } else {
        Write-Host "  ERREUR $file" -ForegroundColor Red -NoNewline
        Write-Host " (Fichier manquant)" -ForegroundColor Gray
    }
}

# Test 4: Services TypeScript
Write-Host "`n4. Services TypeScript" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------" -ForegroundColor DarkGray

$services = @(
    "angular-app/frontend/angular-app/src/app/services/translation.service.ts",
    "angular-app/frontend/angular-app/src/app/components/language-switcher/language-switcher.component.ts",
    "angular-app/back-office/src/app/services/translation.service.ts",
    "angular-app/back-office/src/app/components/language-switcher/language-switcher.component.ts"
)

$servicesSuccess = 0
foreach ($service in $services) {
    if (Test-Path $service) {
        Write-Host "  OK $service" -ForegroundColor Green
        $servicesSuccess++
    } else {
        Write-Host "  ERREUR $service" -ForegroundColor Red
    }
}

# Resume Final
Write-Host "`n=== RESUME DES TESTS ===" -ForegroundColor Cyan
Write-Host ""

$totalTests = 2 + $endpoints.Count + $translationFiles.Count + $services.Count
$angularSuccess = 0
if ($frontendOk) { $angularSuccess++ }
if ($backofficeOk) { $angularSuccess++ }
$totalSuccess = $angularSuccess + $backendSuccess + $translationSuccess + $servicesSuccess

Write-Host "  Services Angular:        " -NoNewline
if ($frontendOk -and $backofficeOk) {
    Write-Host "OK 2/2" -ForegroundColor Green
} else {
    Write-Host "ERREUR $angularSuccess/2" -ForegroundColor Red
}

Write-Host "  Backend Endpoints:       " -NoNewline
if ($backendSuccess -eq $endpoints.Count) {
    Write-Host "OK $backendSuccess/$($endpoints.Count)" -ForegroundColor Green
} else {
    Write-Host "ERREUR $backendSuccess/$($endpoints.Count)" -ForegroundColor Red
}

Write-Host "  Fichiers Traduction:     " -NoNewline
if ($translationSuccess -eq $translationFiles.Count) {
    Write-Host "OK $translationSuccess/$($translationFiles.Count)" -ForegroundColor Green
} else {
    Write-Host "ERREUR $translationSuccess/$($translationFiles.Count)" -ForegroundColor Red
}

Write-Host "  Services TypeScript:     " -NoNewline
if ($servicesSuccess -eq $services.Count) {
    Write-Host "OK $servicesSuccess/$($services.Count)" -ForegroundColor Green
} else {
    Write-Host "ERREUR $servicesSuccess/$($services.Count)" -ForegroundColor Red
}

Write-Host "`n  TOTAL:                   " -NoNewline
$percentage = [math]::Round(($totalSuccess / $totalTests) * 100, 1)
if ($percentage -eq 100) {
    Write-Host "OK $totalSuccess/$totalTests ($percentage%)" -ForegroundColor Green
} elseif ($percentage -ge 80) {
    Write-Host "ATTENTION $totalSuccess/$totalTests ($percentage%)" -ForegroundColor Yellow
} else {
    Write-Host "ERREUR $totalSuccess/$totalTests ($percentage%)" -ForegroundColor Red
}

# URLs d'acces
Write-Host "`n=== URLS D'ACCES ===" -ForegroundColor Cyan
Write-Host ""

if ($frontendOk) {
    Write-Host "  Frontend Public:      " -NoNewline -ForegroundColor White
    Write-Host "http://localhost:56322/" -ForegroundColor Cyan
}

if ($backofficeOk) {
    Write-Host "  Back-Office:          " -NoNewline -ForegroundColor White
    Write-Host "http://localhost:4201/" -ForegroundColor Cyan
}

if ($backendSuccess -gt 0) {
    Write-Host "  Backend API:          " -NoNewline -ForegroundColor White
    Write-Host "http://localhost:8082/api/" -ForegroundColor Cyan
    Write-Host "  Swagger UI:           " -NoNewline -ForegroundColor White
    Write-Host "http://localhost:8082/swagger-ui.html" -ForegroundColor Cyan
}

# Conseils
Write-Host "`n=== CONSEILS ===" -ForegroundColor Cyan
Write-Host ""

if ($percentage -lt 100) {
    Write-Host "  ATTENTION: Certains services ne sont pas accessibles!" -ForegroundColor Yellow
    Write-Host ""
    
    if (-not $frontendOk) {
        Write-Host "  Frontend:" -ForegroundColor White
        Write-Host "    cd angular-app/frontend/angular-app" -ForegroundColor Gray
        Write-Host "    npm start" -ForegroundColor Gray
        Write-Host ""
    }
    
    if (-not $backofficeOk) {
        Write-Host "  Back-Office:" -ForegroundColor White
        Write-Host "    cd angular-app/back-office" -ForegroundColor Gray
        Write-Host "    ng serve --port 4201" -ForegroundColor Gray
        Write-Host ""
    }
    
    if ($backendSuccess -lt $endpoints.Count) {
        Write-Host "  Backend:" -ForegroundColor White
        Write-Host "    Demarrer depuis IntelliJ IDEA" -ForegroundColor Gray
        Write-Host "    Ou consulter: DEMARRAGE_BACKEND.md" -ForegroundColor Gray
        Write-Host ""
    }
} else {
    Write-Host "  OK: Tous les services fonctionnent correctement!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Pour tester la traduction:" -ForegroundColor White
    Write-Host "    1. Ouvrez http://localhost:56322/" -ForegroundColor Gray
    Write-Host "    2. Cliquez sur le bouton FR/EN dans le header" -ForegroundColor Gray
    Write-Host "    3. Verifiez que les textes changent de langue" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "  Documentation complete: ETAT_ACTUEL_SYSTEME.md" -ForegroundColor Cyan
Write-Host ""
