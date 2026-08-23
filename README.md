# OctopusDev - FastAPI Project Initializer

Sistema de inicialización de proyectos FastAPI con UV y estructura modular predefinida.

## 📁 Estructura del Proyecto

```
~/.octopusdev/
├── scripts/
│   ├── 01_create_uv_project.ps1
│   ├── 02_create_app_structure.ps1
│   ├── 03_create_bumpver_config.ps1
│   ├── 04_create_settings.ps1
│   ├── 05_create_database_manager.ps1
│   ├── 06_create_errors.ps1
│   ├── 07_create_controllers.ps1
│   ├── 08_create_api_modules.ps1
│   ├── 09_create_env_files.ps1
│   ├── Copy-Template.ps1
│   └── init_project.ps1
│
└── templates/
    ├── .bumpver.toml
    ├── env.example.template
    ├── api/
    │   ├── app_factory.py.template
    │   ├── dependencies.py.template
    │   ├── errors_parser.py.template
    │   ├── include_routers.py.template
    │   └── routes/
    │       └── health_routes.py.template
    ├── controllers/
    │   └── base_controller.py.template
    ├── database/
    │   └── database_manager.py.template
    ├── errors/
    │   ├── app_erros.py.template
    │   └── base_error.py.template
    └── settings/
        ├── app_logger.py.template
        ├── app_settings.py.template
        └── app_version.py.template
```

---

## 🚀 Instalación

### 1. Clonar o copiar los archivos

```powershell
# Crear el directorio
mkdir ~\.octopusdev\scripts
mkdir ~\.octopusdev\templates

# Copiar todos los scripts y templates
# (copia los archivos desde este repositorio a ~\.octopusdev\)
```

### 2. Configurar alias en PowerShell (opcional)

Agregar a `$PROFILE`:

```powershell
# Agregar al perfil de PowerShell
function octopus-init {
    param([string]$ProjectName, [string]$ProjectPath = ".")
    & "$env:USERPROFILE\.octopusdev\scripts\init_project.ps1" -ProjectName $ProjectName -ProjectPath $ProjectPath
}

# Alias corto
Set-Alias oi octopus-init
```

Recargar el perfil:

```powershell
. $PROFILE
```

---

## 📖 Uso

### Crear un nuevo proyecto

```powershell
# Ir al directorio donde quieres crear el proyecto
cd C:\Users\usuario\Documents\projects

# Ejecutar el inicializador
& "C:\Users\usuario\.octopusdev\scripts\init_project.ps1" -ProjectName "mi_nuevo_proyecto"
```

**O con alias:**

```powershell
oi -ProjectName "mi_nuevo_proyecto"
```

### Estructura del proyecto creado

```
mi_nuevo_proyecto/
├── .venv/                    # Entorno virtual
├── .gitignore
├── .python-version
├── .bumpver.toml            # Configuración de bumpver
├── .env                     # Variables de entorno (generado)
├── .env.example             # Template de variables de entorno
├── pyproject.toml
├── uv.lock
├── README.md
├── main.py
└── app/
    ├── __init__.py
    ├── api/
    │   ├── __init__.py
    │   ├── app_factory.py
    │   ├── dependencies.py
    │   ├── errors_parser.py
    │   ├── include_routers.py
    │   └── routes/
    │       ├── __init__.py
    │       └── health_routes.py
    ├── controllers/
    │   ├── __init__.py
    │   └── base_controller.py
    ├── database/
    │   ├── __init__.py
    │   ├── database_manager.py
    │   └── models/
    │       └── __init__.py
    ├── enums/
    │   └── __init__.py
    ├── errors/
    │   ├── __init__.py
    │   ├── app_erros.py
    │   └── base_error.py
    ├── schemas/
    │   └── __init__.py
    ├── services/
    │   └── __init__.py
    └── settings/
        ├── __init__.py
        ├── app_settings.py
        ├── app_logger.py
        └── app_version.py
```

---

## 🚀 Ejecutar el proyecto

```powershell
cd mi_nuevo_proyecto

# Activar entorno virtual
.\venv\Scripts\activate

# Ejecutar la API
uv run uvicorn main:app --reload
```

---

## 📦 Despliegue en otra máquina

### Opción 1: Copiar la carpeta completa

```powershell
# En la máquina origen
Copy-Item -Path ~\.octopusdev -Destination "C:\backup\octopusdev" -Recurse

# En la máquina destino
Copy-Item -Path "C:\backup\octopusdev" -Destination ~\.octopusdev -Recurse
```

### Opción 2: Usar un repositorio Git

```bash
# En la máquina origen
cd ~\.octopusdev
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/gabrielbaute/octopusdev.git
git push -u origin main

# En la máquina destino
git clone https://github.com/gabrielbaute/octopusdev.git ~\.octopusdev
```

### Opción 3: Script de instalación automática

```powershell
# install.ps1
Write-Host "Instalando OctopusDev..." -ForegroundColor Cyan

$source = "https://github.com/gabrielbaute/octopusdev/archive/main.zip"
$destination = "$env:TEMP\octopusdev.zip"

Invoke-WebRequest -Uri $source -OutFile $destination
Expand-Archive -Path $destination -DestinationPath "$env:TEMP\octopusdev"

Copy-Item -Path "$env:TEMP\octopusdev\octopusdev-main\*" -Destination ~\.octopusdev -Recurse -Force

Remove-Item -Path $destination -Force
Remove-Item -Path "$env:TEMP\octopusdev" -Recurse -Force

Write-Host "OctopusDev instalado en ~\.octopusdev" -ForegroundColor Green
Write-Host "Agrega el alias a tu perfil para usar 'oi'" -ForegroundColor Yellow
```

---

## 📝 Dependencias Requeridas

| Herramienta | Instalación |
|-------------|-------------|
| **PowerShell 5.1+** | Incluido en Windows 10/11 |
| **UV** | `pip install uv` o desde [astral.sh/uv](https://astral.sh/uv) |
| **openssl** | Incluido en Git Bash o instalar desde [slproweb.com](https://slproweb.com/products/Win32OpenSSL.html) |

---

## 🔧 Personalización

### Agregar un nuevo template

1. Crear el archivo template en `~\.octopusdev\templates\`
2. Crear el script correspondiente en `~\.octopusdev\scripts\`
3. Agregar el paso en `init_project.ps1`

### Modificar templates existentes

Editar los archivos en `~\.octopusdev\templates\` y los cambios se aplicarán a todos los proyectos nuevos.

---

## 📋 Lista de Pasos

| Paso | Script | Descripción |
|------|--------|-------------|
| 1 | `01_create_uv_project.ps1` | Crea proyecto con UV e instala dependencias |
| 2 | `02_create_app_structure.ps1` | Crea estructura de carpetas |
| 3 | `03_create_bumpver_config.ps1` | Configura bumpver |
| 4 | `04_create_settings.ps1` | Crea módulo settings |
| 5 | `05_create_database_manager.ps1` | Crea database_manager |
| 6 | `06_create_errors.ps1` | Crea errores base |
| 7 | `07_create_controllers.ps1` | Crea controladores base |
| 8 | `08_create_api_modules.ps1` | Crea módulo API completo |
| 9 | `09_create_env_files.ps1` | Crea archivos .env |

---

## 📄 Licencia

MIT - Libre de usar y modificar.

---

## 🤝 Contribuciones

Si encuentras errores o tienes sugerencias, abre un issue o pull request en el repositorio.