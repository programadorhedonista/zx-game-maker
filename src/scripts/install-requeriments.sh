#!/bin/bash

if command -v python &> /dev/null; then
    echo "Python está instalado."
else
    echo "Python no está instalado. Por favor, instala Python antes de continuar."
    read -p "Pulse una tecla para cerrar..."
    exit 1
fi

# Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
    echo "Creando entorno virtual venv..."
    python -m venv venv
fi

# Activar entorno virtual si no está activado
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Activando entorno virtual venv..."
    source venv/bin/activate
fi

requirementsFile="./requeriments.txt"

# Comprobar si el archivo requeriments.txt existe
if [ ! -f "$requirementsFile" ]; then
    echo "No se encontró el archivo requeriments.txt"
    read -p "Pulse una tecla para cerrar..."
    exit 1
fi

# Leer las dependencias de requeriments.txt
requeriments=$(cat "$requirementsFile")

# Obtener las dependencias instaladas
installed_packages=$(pip freeze)

# Comprobar si todas las dependencias están instaladas
all_installed=true
for requirement in $requeriments; do
    requirement_name=$(echo $requirement | sed 's/==.*//')
    if ! echo "$installed_packages" | grep -iq "$requirement_name"; then
        echo "Falta instalar: $requirement_name"
        all_installed=false
    fi
done

if [ "$all_installed" = false ]; then
    echo "Instalando requerimientos..."
    pip install -r "$requirementsFile"
fi

rm -f venv/bin/bin2tap.py