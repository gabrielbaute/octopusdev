# install.ps1
<#
.SYNOPSIS
    Instala OctopusDev en una nueva máquina
#>

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALANDO OCTOPUSDEV" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Crear directorios
Write-Host "Creando directorios..." -ForegroundColor Gray
New-Item -Path ~\.octopusdev\scripts -ItemType Directory -Force | Out-Null
New-Item -Path ~\.octopusdev\templates -ItemType Directory -Force | Out-Null

# 2. Copiar archivos (asumiendo que el script se ejecuta desde el repo)
$source = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

Write-Host "Copiando scripts..." -ForegroundColor Gray
Copy-Item -Path "$source\scripts\*" -Destination ~\.octopusdev\scripts\ -Recurse -Force

Write-Host "Copiando templates..." -ForegroundColor Gray
Copy-Item -Path "$source\templates\*" -Destination ~\.octopusdev\templates\ -Recurse -Force

Write-Host "Copiando README..." -ForegroundColor Gray
Copy-Item -Path "$source\README.md" -Destination ~\.octopusdev\README.md -Force

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  INSTALACION COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Ubicacion: ~\.octopusdev" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para usar, ejecuta:" -ForegroundColor Yellow
Write-Host "  & ~\.octopusdev\scripts\init_project.ps1 -ProjectName 'mi_proyecto'" -ForegroundColor White
Write-Host ""
Write-Host "O agrega un alias a tu perfil:" -ForegroundColor Yellow
Write-Host '  function oi { & "$env:USERPROFILE\.octopusdev\scripts\init_project.ps1" -ProjectName $args[0] }' -ForegroundColor White
Write-Host ""