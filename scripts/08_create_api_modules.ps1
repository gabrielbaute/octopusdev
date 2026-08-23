<#
.SYNOPSIS
    Crea el modulo API completo con templates

.DESCRIPTION
    Copia todos los templates de la carpeta api/ al proyecto:
    - app_factory.py
    - dependencies.py
    - errors_parser.py
    - include_routers.py
    - routes/health_routes.py

.PARAMETER ProjectPath
    Ruta del proyecto

.EXAMPLE
    .\08_create_api_modules.ps1 -ProjectPath ".\mi_api"
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
        Template = "api/app_factory.py.template"
        Destination = "app/api/app_factory.py"
    },
    @{
        Template = "api/dependencies.py.template"
        Destination = "app/api/dependencies.py"
    },
    @{
        Template = "api/errors_parser.py.template"
        Destination = "app/api/errors_parser.py"
    },
    @{
        Template = "api/include_routers.py.template"
        Destination = "app/api/include_routers.py"
    },
    @{
        Template = "api/routes/health_routes.py.template"
        Destination = "app/api/routes/health_routes.py"
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
    Write-Host "Modulo API creado" -ForegroundColor Green
    exit 0
} else {
    Write-Host "ERROR: Error al crear algunos archivos del modulo API" -ForegroundColor Red
    exit 1
}