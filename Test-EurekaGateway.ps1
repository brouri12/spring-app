# Script PowerShell pour tester Eureka et API Gateway
# Encodage UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   TEST EUREKA SERVER ET API GATEWAY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour tester une URL
function Test-ServiceUrl {
    param(
        [string]$Url,
        [string]$ServiceName
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $ServiceName est accessible" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "❌ $ServiceName n'est pas accessible" -ForegroundColor Red
        return $false
    }
}

# 1. Vérifier MySQL
Write-Host "[1/5] Vérification de MySQL..." -ForegroundColor Yellow
$mysqlService = Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq "Running"}
if ($mysqlService) {
    Write-Host "✅ MySQL est démarré" -ForegroundColor Green
} else {
    Write-Host "❌ MySQL n'est pas démarré !" -ForegroundColor Red
    Write-Host "Démarrez MySQL avec : net start MySQL80" -ForegroundColor Yellow
    pause
    exit 1
}
Write-Host ""

# 2. Vérifier Eureka Server
Write-Host "[2/5] Test Eureka Server (http://localhost:8761)..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
$eurekaUp = Test-ServiceUrl -Url "http://localhost:8761" -ServiceName "Eureka Server"
if (-not $eurekaUp) {
    Write-Host ""
    Write-Host "DÉMARREZ EUREKA SERVER :" -ForegroundColor Yellow
    Write-Host "cd eureka-server" -ForegroundColor White
    Write-Host "mvnw spring-boot:run" -ForegroundColor White
    pause
    exit 1
}
Write-Host ""

# 3. Vérifier Forum Service
Write-Host "[3/5] Test Forum Service (http://localhost:8082)..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
$forumUp = Test-ServiceUrl -Url "http://localhost:8082/actuator/health" -ServiceName "Forum Service"
if (-not $forumUp) {
    Write-Host ""
    Write-Host "DÉMARREZ FORUM SERVICE :" -ForegroundColor Yellow
    Write-Host "cd forum-service" -ForegroundColor White
    Write-Host "mvnw spring-boot:run" -ForegroundColor White
    pause
    exit 1
}
Write-Host ""

# 4. Vérifier Recrutement Service
Write-Host "[4/5] Test Recrutement Service (http://localhost:8083)..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
$recrutementUp = Test-ServiceUrl -Url "http://localhost:8083/actuator/health" -ServiceName "Recrutement Service"
if (-not $recrutementUp) {
    Write-Host ""
    Write-Host "DÉMARREZ RECRUTEMENT SERVICE :" -ForegroundColor Yellow
    Write-Host "cd recrutement-service" -ForegroundColor White
    Write-Host "mvnw spring-boot:run" -ForegroundColor White
    pause
    exit 1
}
Write-Host ""

# 5. Vérifier API Gateway
Write-Host "[5/5] Test API Gateway (http://localhost:8086)..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
$gatewayUp = Test-ServiceUrl -Url "http://localhost:8086/actuator/health" -ServiceName "API Gateway"
if (-not $gatewayUp) {
    Write-Host ""
    Write-Host "DÉMARREZ API GATEWAY :" -ForegroundColor Yellow
    Write-Host "cd api-gateway" -ForegroundColor White
    Write-Host "mvnw spring-boot:run" -ForegroundColor White
    pause
    exit 1
}
Write-Host ""

# Vérifier les services dans Eureka
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   VÉRIFICATION DES SERVICES DANS EUREKA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Récupération des services enregistrés dans Eureka..." -ForegroundColor Yellow
Write-Host ""

try {
    $eurekaApps = Invoke-RestMethod -Uri "http://localhost:8761/eureka/apps" -Headers @{"Accept"="application/json"} -TimeoutSec 10
    
    Write-Host "✅ Services enregistrés dans Eureka :" -ForegroundColor Green
    Write-Host ""
    
    $services = @("FORUM-SERVICE", "RECRUTEMENT-SERVICE", "API-GATEWAY")
    
    foreach ($service in $services) {
        $found = $false
        if ($eurekaApps.applications.application) {
            foreach ($app in $eurekaApps.applications.application) {
                if ($app.name -eq $service) {
                    $found = $true
                    $instanceCount = if ($app.instance -is [Array]) { $app.instance.Count } else { 1 }
                    Write-Host "  ✅ $service est enregistré ($instanceCount instance(s))" -ForegroundColor Green
                    break
                }
            }
        }
        if (-not $found) {
            Write-Host "  ❌ $service n'est PAS enregistré" -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "⚠️  Impossible de récupérer les services depuis Eureka" -ForegroundColor Yellow
    Write-Host "Erreur : $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test des routes via Gateway
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   TEST DES ROUTES VIA API GATEWAY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Test 1: Forum via Gateway (http://localhost:8086/forum/api/forum)..." -ForegroundColor Yellow
Test-ServiceUrl -Url "http://localhost:8086/forum/api/forum" -ServiceName "Forum via Gateway" | Out-Null
Write-Host ""

Write-Host "Test 2: Recrutement via Gateway (http://localhost:8086/recrutement/api/recrutement/offres)..." -ForegroundColor Yellow
Test-ServiceUrl -Url "http://localhost:8086/recrutement/api/recrutement/offres" -ServiceName "Recrutement via Gateway" | Out-Null
Write-Host ""

Write-Host "Test 3: Gateway Routes (http://localhost:8086/actuator/gateway/routes)..." -ForegroundColor Yellow
Test-ServiceUrl -Url "http://localhost:8086/actuator/gateway/routes" -ServiceName "Routes Gateway" | Out-Null
Write-Host ""

# Résumé des URLs
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   RÉSUMÉ DES URLS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 EUREKA DASHBOARD :" -ForegroundColor Magenta
Write-Host "   http://localhost:8761" -ForegroundColor White
Write-Host ""
Write-Host "🔧 API GATEWAY :" -ForegroundColor Magenta
Write-Host "   http://localhost:8086" -ForegroundColor White
Write-Host "   http://localhost:8086/actuator/gateway/routes" -ForegroundColor White
Write-Host ""
Write-Host "💬 FORUM SERVICE :" -ForegroundColor Magenta
Write-Host "   Direct : http://localhost:8082/api/forum" -ForegroundColor White
Write-Host "   Via Gateway : http://localhost:8086/forum/api/forum" -ForegroundColor White
Write-Host "   Swagger : http://localhost:8082/swagger-ui.html" -ForegroundColor White
Write-Host ""
Write-Host "👔 RECRUTEMENT SERVICE :" -ForegroundColor Magenta
Write-Host "   Direct : http://localhost:8083/api/recrutement/offres" -ForegroundColor White
Write-Host "   Via Gateway : http://localhost:8086/recrutement/api/recrutement/offres" -ForegroundColor White
Write-Host "   Swagger : http://localhost:8083/swagger-ui.html" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Ouvrir Eureka Dashboard dans le navigateur
$openBrowser = Read-Host "Voulez-vous ouvrir le dashboard Eureka dans le navigateur ? (O/N)"
if ($openBrowser -eq "O" -or $openBrowser -eq "o") {
    Start-Process "http://localhost:8761"
}

Write-Host ""
Write-Host "Appuyez sur une touche pour quitter..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
