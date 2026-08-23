<#
.SYNOPSIS
    Inicializa un proyecto desde un archivo de configuración JSON

.DESCRIPTION
    Lee un archivo project-config.json y ejecuta init_project.ps1
    con todos los parámetros definidos en el JSON.

.PARAMETER ConfigPath
    Ruta al archivo de configuración JSON (default: ./project-config.json)

.EXAMPLE
    .\init_from_config.ps1 -ConfigPath ".\project-config.json"

.NOTES
    El archivo JSON debe tener la estructura definida en la documentación.
#>

param(
    [string]$ConfigPath = ".\project-config.json"
)

# --- FUNCIONES DE MENSAJERÍA ---
function Write-Banner { param($Title) Write-Host "`n========================================" -ForegroundColor Cyan; Write-Host "  $Title" -ForegroundColor Yellow; Write-Host "========================================" -ForegroundColor Cyan; Write-Host "" }
function Write-Success { param($Msg) Write-Host "✅ $Msg" -ForegroundColor Green }
function Write-Error { param($Msg) Write-Host "❌ ERROR: $Msg" -ForegroundColor Red }
function Write-Info { param($Msg) Write-Host "  ℹ️ $Msg" -ForegroundColor Gray }

# --- VALIDAR CONFIGURACIÓN ---
Write-Banner "📋 LEYENDO CONFIGURACIÓN"

if (-not (Test-Path $ConfigPath)) {
    Write-Error "Archivo de configuración no encontrado: $ConfigPath"
    Write-Info "Crea un archivo project-config.json en el directorio actual"
    exit 1
}

try {
    $config = Get-Content -Path $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
    Write-Success "Configuración cargada exitosamente"
} catch {
    Write-Error "Error al parsear el JSON: $($_.Exception.Message)"
    exit 1
}

# --- VALIDAR CAMPOS OBLIGATORIOS ---
if (-not $config.project -or -not $config.project.name) {
    Write-Error "El campo 'project.name' es obligatorio"
    exit 1
}

# --- MOSTRAR RESUMEN ---
Write-Info "Proyecto: $($config.project.name)"
Write-Info "Versión: $($config.project.version)"
Write-Info "Ruta: $($config.project.path)"
Write-Info "Incluir tests: $($config.features.with_tests)"
Write-Info ""

# --- CONSTRUIR PARÁMETROS ---
$params = @{
    ProjectName = $config.project.name
    ProjectPath = $config.project.path
    Force = $true  # Desde JSON siempre forzamos
}

if ($config.features.with_tests -eq $true) {
    $params.WithTests = $true
}

if ($config.project.skip_install -eq $true) {
    $params.SkipInstall = $true
}

# --- EJECUTAR INIT_PROJECT ---
Write-Banner "🚀 INICIALIZANDO PROYECTO"

$initScript = Join-Path $PSScriptRoot "init_project.ps1"

if (-not (Test-Path $initScript)) {
    Write-Error "Script init_project.ps1 no encontrado en: $PSScriptRoot"
    exit 1
}

Write-Info "Ejecutando: $initScript"
Write-Info "Parámetros: $($params | ConvertTo-Json -Compress)"

# Ejecutar el script principal
& $initScript @params

if ($LASTEXITCODE -eq 0) {
    Write-Success "Proyecto inicializado exitosamente desde configuración JSON"
} else {
    Write-Error "Error al inicializar el proyecto (código: $LASTEXITCODE)"
    exit $LASTEXITCODE
}