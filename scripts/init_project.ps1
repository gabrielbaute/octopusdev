<#
.SYNOPSIS
    Inicializa un proyecto FastAPI completo con todas las configuraciones

.DESCRIPTION
    Ejecuta todos los scripts de inicializacion en el orden correcto:
    1. Crea proyecto con UV e instala dependencias
    2. Crea estructura de carpetas
    3. Configura bumpver
    4. Crea modulo de settings
    5. Crea database_manager
    6. Crea errores base
    7. Crea controladores base
    8. Crea modulo API completo

.PARAMETER ProjectName
    Nombre del proyecto

.PARAMETER ProjectPath
    Ruta donde crear el proyecto (default: directorio actual)

.EXAMPLE
    .\init_project.ps1 -ProjectName "mi_api"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [string]$ProjectPath = "."
)

# 1. Mostrar inicio
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INICIALIZADOR DE PROYECTO FASTAPI" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Nombre del proyecto: " -NoNewline
Write-Host $ProjectName -ForegroundColor Gray
Write-Host "Ruta: " -NoNewline
Write-Host $ProjectPath -ForegroundColor Gray
Write-Host ""

# 2. Funcion para ejecutar scripts
function Invoke-ScriptStep {
    param(
        [string]$Step,
        [string]$ScriptName,
        [string]$Description,
        [hashtable]$Parameters
    )
    
    Write-Host ""
    Write-Host ("PASO " + $Step + ": " + $Description) -ForegroundColor Magenta
    Write-Host "----------------------------------------" -ForegroundColor Magenta
    
    $scriptPath = Join-Path $PSScriptRoot ($ScriptName + ".ps1")
    
    if (-not (Test-Path $scriptPath)) {
        Write-Host ("ERROR: Script no encontrado: " + $ScriptName + ".ps1") -ForegroundColor Red
        return $false
    }
    
    Write-Host ("Ejecutando: " + $ScriptName + ".ps1") -ForegroundColor Gray
    & $scriptPath @Parameters
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ("Paso " + $Step + " completado") -ForegroundColor Green
        return $true
    } else {
        Write-Host ("Paso " + $Step + " fallo") -ForegroundColor Red
        return $false
    }
}

# 3. Paso 1: Crear proyecto con UV
$success = Invoke-ScriptStep -Step "1" -ScriptName "01_create_uv_project" -Description "Crear proyecto con UV" -Parameters @{
    ProjectName = $ProjectName
    ProjectPath = $ProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 1" -ForegroundColor Red
    exit 1
}

# 4. Ruta completa del proyecto
$fullProjectPath = Join-Path $ProjectPath $ProjectName

# 5. Paso 2: Crear estructura de carpetas
$success = Invoke-ScriptStep -Step "2" -ScriptName "02_create_app_structure" -Description "Crear estructura de carpetas" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 2" -ForegroundColor Red
    exit 1
}

# 6. Paso 3: Configurar bumpver
$success = Invoke-ScriptStep -Step "3" -ScriptName "03_create_bumpver_config" -Description "Configurar bumpver" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 3" -ForegroundColor Red
    exit 1
}

# 7. Paso 4: Crear modulo settings
$success = Invoke-ScriptStep -Step "4" -ScriptName "04_create_settings" -Description "Crear modulo settings" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 4" -ForegroundColor Red
    exit 1
}

# 8. Paso 5: Crear database_manager
$success = Invoke-ScriptStep -Step "5" -ScriptName "05_create_database_manager" -Description "Crear database_manager" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 5" -ForegroundColor Red
    exit 1
}

# 9. Paso 6: Crear errores base
$success = Invoke-ScriptStep -Step "6" -ScriptName "06_create_errors" -Description "Crear errores base" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 6" -ForegroundColor Red
    exit 1
}

# 10. Paso 7: Crear controladores base
$success = Invoke-ScriptStep -Step "7" -ScriptName "07_create_controllers" -Description "Crear controladores base" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 7" -ForegroundColor Red
    exit 1
}

# 11. Paso 8: Crear modulo API completo
$success = Invoke-ScriptStep -Step "8" -ScriptName "08_create_api_modules" -Description "Crear modulo API completo" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 8" -ForegroundColor Red
    exit 1
}

# 12. Paso 9: Crear archivos .env
$success = Invoke-ScriptStep -Step "9" -ScriptName "09_create_env_files" -Description "Crear archivos .env" -Parameters @{
    ProjectPath = $fullProjectPath
}

if (-not $success) {
    Write-Host "ERROR: Inicializacion fallida en el Paso 9" -ForegroundColor Red
    exit 1
}

# 12. Resumen final
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PROYECTO INICIALIZADO EXITOSAMENTE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host ("Ubicacion: " + $fullProjectPath) -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "  1. cd " -NoNewline
Write-Host $fullProjectPath -ForegroundColor White
Write-Host "  2. .\.venv\Scripts\activate" -ForegroundColor White
Write-Host "  3. code ." -ForegroundColor White
Write-Host ""

exit 0