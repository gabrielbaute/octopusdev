<#
.SYNOPSIS
    Crea un proyecto Python con UV e instala dependencias basicas

.DESCRIPTION
    Ejecuta uv init para crear un proyecto de aplicacion y
    luego instala las dependencias principales y de desarrollo.

.PARAMETER ProjectName
    Nombre del proyecto (ej: "mi_api")

.PARAMETER ProjectPath
    Ruta donde crear el proyecto (default: directorio actual)

.EXAMPLE
    .\01_create_uv_project.ps1 -ProjectName "mi_api"
#>

param(
    [string]$ProjectName,
    [string]$ProjectPath = "."
)

# 1. Verificar UV
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: uv no esta instalado" -ForegroundColor Red
    exit 1
}
Write-Host "UV encontrado" -ForegroundColor Green

# 2. Ruta del proyecto
$fullPath = Join-Path $ProjectPath $ProjectName
Write-Host "Ruta: $fullPath" -ForegroundColor Cyan

# 3. Verificar si existe
if (Test-Path $fullPath) {
    Write-Host "ERROR: El proyecto ya existe en $fullPath" -ForegroundColor Red
    exit 1
}

# 4. Crear proyecto con UV
Push-Location $ProjectPath
Write-Host "Ejecutando: uv init --app --no-package $ProjectName" -ForegroundColor Cyan
uv init --app --no-package $ProjectName

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: uv init fallo" -ForegroundColor Red
    Pop-Location
    exit 1
}

# 5. La carpeta se creó con el nombre exacto
$actualPath = $fullPath
Write-Host "Proyecto creado en: $actualPath" -ForegroundColor Green

# 6. Entrar e instalar dependencias
Push-Location $actualPath
Write-Host "Instalando dependencias..." -ForegroundColor Cyan

$deps = @("fastapi", "pydantic", "pydantic-settings", "sqlmodel", "uvicorn", "aiosqlite", "requests", "jinja2", "passlib", "python-jose")
foreach ($dep in $deps) {
    Write-Host "  - $dep" -ForegroundColor Gray
    uv add $dep
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Fallo al instalar $dep" -ForegroundColor Red
        Pop-Location
        Pop-Location
        exit 1
    }
}

Write-Host "Instalando bumpver (dev)..." -ForegroundColor Cyan
uv add --dev bumpver
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo al instalar bumpver" -ForegroundColor Red
    Pop-Location
    Pop-Location
    exit 1
}

Write-Host "Proyecto listo" -ForegroundColor Green
Pop-Location
Pop-Location
exit 0