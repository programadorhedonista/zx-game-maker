$python = Get-Command python -ErrorAction SilentlyContinue

if ($null -eq $python) {
    Write-Host "Python no está instalado. Por favor, instala Python antes de continuar." -ForegroundColor Red
    #esperar a que pulse una tecla para no cerrar la ventana
    Read-Host "Pulse una tecla para cerrar..."
    exit 1
}

$pythonVersion = $python.Version.Major + $python.Version.Minor / 100

if ($pythonVersion -lt 3.12) {
    Write-Host "La versión de Python es menor que 3.12. Por favor, instala Python 3.12 o superior." -ForegroundColor Red
    Read-Host "Pulse una tecla para cerrar..."
    exit 1
}

$venv = ".\venv\Scripts\Activate.ps1"

if (-not (Test-Path $venv)) {
    Write-Host "Creando entorno virtual venv..." -ForegroundColor Yellow
    python -m venv venv
}

if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activando entorno virtual venv..." -ForegroundColor Yellow
    .\venv\Scripts\Activate.ps1
}

# Comprobar si el archivo requeriments.txt existe
$requerimentsFile = ".\requeriments.txt"
if (-not (Test-Path $requerimentsFile)) {
    Write-Host "No se encontró el archivo requeriments.txt" -ForegroundColor Red
    Read-Host "Pulse una tecla para cerrar..."
    exit 1
}

# Leer las dependencias de requeriments.txt
$requeriments = Get-Content $requerimentsFile
$installed_packages = & pip freeze
$installed_package_names = $installed_packages -replace '==.*', ''

# Comprobar si todas las dependencias están instaladas
$all_installed = $true
foreach ($requirement in $requeriments) {
    $requirement_name = $requirement -replace '==.*', ''
    if (-not ($installed_package_names -contains $requirement_name)) {
        Write-Host "Falta instalar: $requirement_name" -ForegroundColor Yellow
        $all_installed = $false
    }
}

if ($all_installed) {
    Write-Host "Todas las dependencias ya están instaladas." -ForegroundColor Green
} else {
    Write-Host "Instalando requerimientos..." -ForegroundColor Yellow
    pip install -r .\requeriments.txt
}

Write-Host "Ejecutando build" -ForegroundColor Yellow

python .\build.py