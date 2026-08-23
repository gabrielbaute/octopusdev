<#
.SYNOPSIS
    Crea los archivos .env y .env.example para el proyecto

.DESCRIPTION
    Copia .env.example desde templates y genera .env con valores generados
    automáticamente usando openssl para las claves secretas.

.PARAMETER ProjectPath
    Ruta del proyecto

.EXAMPLE
    .\09_create_env_files.ps1 -ProjectPath ".\mi_api"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

# 1. Verificar que la ruta del proyecto existe
if (-not (Test-Path $ProjectPath)) {
    Write-Host "ERROR: La ruta del proyecto '$ProjectPath' no existe" -ForegroundColor Red
    exit 1
}
Write-Host "Ruta del proyecto: $ProjectPath" -ForegroundColor Green

# 2. Cargar Copy-Template
$utilScript = Join-Path $PSScriptRoot "Copy-Template.ps1"
if (-not (Test-Path $utilScript)) {
    Write-Host "ERROR: No se encontro Copy-Template.ps1 en: $utilScript" -ForegroundColor Red
    exit 1
}
. $utilScript

# 3. Copiar .env.example
$destinationExample = Join-Path $ProjectPath ".env.example"
$templateName = "env.example.template"

$result = Copy-Template -TemplateName $templateName -DestinationPath $destinationExample

if (-not $result) {
    Write-Host "ERROR: Error al copiar .env.example" -ForegroundColor Red
    exit 1
}
Write-Host ".env.example creado" -ForegroundColor Green

# 4. Generar .env con valores automaticos
$envPath = Join-Path $ProjectPath ".env"

# Verificar si .env ya existe
if (Test-Path $envPath) {
    Write-Host ".env ya existe, saltando..." -ForegroundColor Yellow
    exit 0
}

Write-Host "Generando .env..." -ForegroundColor Gray

# Generar valores con openssl si esta disponible
function Get-RandomHex {
    param([int]$Length)
    
    # Intentar usar openssl primero
    $openssl = Get-Command openssl -ErrorAction SilentlyContinue
    if ($openssl) {
        $result = openssl rand -hex $Length 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $result.Trim()
        }
    }
    
    # Fallback: usar .NET Random
    $bytes = New-Object byte[] $Length
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $rng.GetBytes($bytes)
    return [System.BitConverter]::ToString($bytes) -replace "-","" | ForEach-Object { $_.ToLower() }
}

$SECRET_KEY = Get-RandomHex 32
$SECURITY_PASSWORD_SALT = Get-RandomHex 16
$JWT_SECRET_KEY = Get-RandomHex 32

# 5. Escribir .env
$envContent = @"
# Aplication
APP_NAME="AppName"

# API
API_HOST="0.0.0.0"
API_PORT=8080

# NTFY
NTFY_TOPIC="ntfy-topic"
NTFY_URL="ntfy-url"

# Security
SECRET_KEY="$SECRET_KEY"
SECURITY_PASSWORD_SALT="$SECURITY_PASSWORD_SALT"
JWT_SECRET_KEY="$JWT_SECRET_KEY"
ACCESS_TOKEN_EXPIRE_MINUTES=60
REFRESH_TOKEN_EXPIRE_MINUTES=10800
"@

$envContent | Out-File -FilePath $envPath -Encoding UTF8

Write-Host ".env creado con valores generados" -ForegroundColor Green
Write-Host "Ubicacion: $envPath" -ForegroundColor Gray

exit 0