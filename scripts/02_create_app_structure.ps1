<#
.SYNOPSIS
    Crea la estructura de carpetas para un proyecto FastAPI

.DESCRIPTION
    Genera la estructura modular de carpetas con archivos __init__.py

.PARAMETER ProjectPath
    Ruta del proyecto donde crear la estructura (default: directorio actual)

.EXAMPLE
    .\02_create_app_structure.ps1 -ProjectPath ".\mi_api"
#>

param(
    [string]$ProjectPath = "."
)

# 1. Verificar que la ruta existe
if (-not (Test-Path $ProjectPath)) {
    Write-Host "ERROR: La ruta '$ProjectPath' no existe" -ForegroundColor Red
    exit 1
}
Write-Host "Ruta encontrada: $ProjectPath" -ForegroundColor Green

# 2. Ruta de la carpeta app
$appPath = Join-Path $ProjectPath "app"

# 3. Crear carpeta principal app (si ya existe, la usa)
New-Item -Path $appPath -ItemType Directory -Force | Out-Null
Write-Host "Carpeta app/ lista" -ForegroundColor Green

# 4. Definir estructura de modulos
$modulos = @(
    "api",
    "api/routes",
    "controllers",
    "database",
    "database/models",
    "enums",
    "errors",
    "schemas",
    "services",
    "settings"
)

# 5. Crear cada modulo con su __init__.py
foreach ($modulo in $modulos) {
    $modulePath = Join-Path $appPath $modulo
    New-Item -Path $modulePath -ItemType Directory -Force | Out-Null
    Write-Host "Creado: app/$modulo/" -ForegroundColor Gray
    
    $initFile = Join-Path $modulePath "__init__.py"
    New-Item -Path $initFile -ItemType File -Force | Out-Null
    Write-Host "Creado: app/$modulo/__init__.py" -ForegroundColor Gray
}

Write-Host "Estructura de carpetas creada exitosamente" -ForegroundColor Green
exit 0