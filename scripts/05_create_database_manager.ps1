<#
.SYNOPSIS
    Crea el database_manager.py usando template

.DESCRIPTION
    Copia el template database_manager.py desde el repositorio de templates al proyecto

.PARAMETER ProjectPath
    Ruta del proyecto

.EXAMPLE
    .\05_create_database_manager.ps1 -ProjectPath ".\mi_api"
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

# 3. Copiar template
$destination = Join-Path $ProjectPath "app/database/database_manager.py"
$templateName = "database/database_manager.py.template"

$result = Copy-Template -TemplateName $templateName -DestinationPath $destination

if ($result) {
    Write-Host "database_manager.py creado" -ForegroundColor Green
    Write-Host "Ubicacion: $destination" -ForegroundColor Gray
    exit 0
} else {
    Write-Host "ERROR: Error al crear database_manager.py" -ForegroundColor Red
    exit 1
}