<#
.SYNOPSIS
    Crea los archivos de errores usando templates

.DESCRIPTION
    Copia los templates base_error.py y app_erros.py desde el repositorio de templates al proyecto

.PARAMETER ProjectPath
    Ruta del proyecto

.EXAMPLE
    .\06_create_errors.ps1 -ProjectPath ".\mi_api"
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

# 3. Definir templates a copiar
$templates = @(
    @{
        Template = "errors/base_error.py.template"
        Destination = "app/errors/base_error.py"
    },
    @{
        Template = "errors/app_errors.py.template"
        Destination = "app/errors/app_errors.py"
    }
)

$successCount = 0
foreach ($template in $templates) {
    Write-Host "Copiando: $($template.Template)" -ForegroundColor Gray
    
    $destination = Join-Path $ProjectPath $template.Destination
    $result = Copy-Template -TemplateName $template.Template -DestinationPath $destination
    
    if ($result) {
        $successCount++
    }
}

if ($successCount -eq $templates.Count) {
    Write-Host "Archivos de errores creados" -ForegroundColor Green
    exit 0
} else {
    Write-Host "ERROR: Error al crear algunos archivos de errores" -ForegroundColor Red
    exit 1
}