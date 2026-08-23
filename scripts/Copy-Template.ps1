<#
.SYNOPSIS
    Copia templates desde el repositorio central al proyecto

.DESCRIPTION
    Copia archivos de la carpeta templates a la ruta de destino

.PARAMETER TemplateName
    Nombre del template (ej: "bumpver.toml")

.PARAMETER DestinationPath
    Ruta completa donde copiar el archivo

.PARAMETER TemplateBasePath
    Ruta base donde estan los templates (default: $env:USERPROFILE\.octopusdev\templates)

.EXAMPLE
    Copy-Template -TemplateName "bumpver.toml" -DestinationPath ".\mi_api\.bumpver.toml"
#>

function Copy-Template {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TemplateName,
        
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath,
        
        [string]$TemplateBasePath = "$env:USERPROFILE\.octopusdev\templates"
    )
    
    # Ruta del template
    $templatePath = Join-Path $TemplateBasePath $TemplateName
    
    # Verificar que el template existe
    if (-not (Test-Path $templatePath)) {
        Write-Host "ERROR: Template no encontrado: $TemplateName" -ForegroundColor Red
        Write-Host "Buscado en: $templatePath" -ForegroundColor Yellow
        return $false
    }
    
    # Verificar si el destino ya existe
    if (Test-Path $DestinationPath) {
        Write-Host "El archivo destino ya existe: $DestinationPath" -ForegroundColor Yellow
        Write-Host "Saltando..." -ForegroundColor Gray
        return $true
    }
    
    # Crear directorio destino si no existe
    $destDir = Split-Path -Path $DestinationPath -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -Path $destDir -ItemType Directory -Force | Out-Null
    }
    
    # Copiar el archivo directamente
    Copy-Item -Path $templatePath -Destination $DestinationPath -Force
    
    Write-Host "Template copiado: $TemplateName -> $DestinationPath" -ForegroundColor Green
    return $true
}