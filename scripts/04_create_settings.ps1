<#
.SYNOPSIS
    Crea el modulo de settings con templates

.DESCRIPTION
    Copia los templates de app_settings.py, app_logger.py y app_version.py
    desde el repositorio de templates al proyecto.

.PARAMETER ProjectPath
    Ruta del proyecto

.EXAMPLE
    .\04_create_settings.ps1 -ProjectPath ".\mi_api"
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

# 3. Copiar templates
$templates = @(
    @{
        Template = "settings/app_settings.py.template"
        Destination = "app/settings/app_settings.py"
    },
    @{
        Template = "settings/app_logger.py.template"
        Destination = "app/settings/app_logger.py"
    },
    @{
        Template = "settings/app_version.py.template"
        Destination = "app/settings/app_version.py"
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
    Write-Host "Modulo de settings creado" -ForegroundColor Green
    exit 0
} else {
    Write-Host "ERROR: Error al crear algunos archivos de settings" -ForegroundColor Red
    exit 1
}