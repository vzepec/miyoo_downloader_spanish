#!/bin/sh

# GitHub API variables
GITHUB_RAW_URL_NES="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/download_nes_spa.sh"
GITHUB_RAW_URL_PSX="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/download_psx_spa.sh"
TOKEN="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"
LOCAL_FILE_NES="downloaders/download_nes_spa.sh"
LOCAL_FILE_PSX="downloaders/download_psx_spa.sh"

# Función para verificar si hay cambios en el archivo
check_for_updates() {
  local file_to_update="$1"
  local GITHUB_RAW_URL="$2"
  clear
  echo "Buscando actualizaciones para $file_to_update ..."

  # Crear un archivo temporal
  TEMP_FILE=$(mktemp)
  if [ ! -f "$TEMP_FILE" ]; then
    echo "No se pudo crear un archivo temporal."
    exit 1
  fi
  curl -s -k -H "Authorization: token $TOKEN" --connect-timeout 10 -f -o "$TEMP_FILE" "$GITHUB_RAW_URL" || {
    echo "Error al descargar el archivo. Verifica la conexion y el token."
    rm -f "$TEMP_FILE"
    exit 1
  }

  if [ ! -s "$TEMP_FILE" ]; then
    echo "El archivo descargado esta vacio. Revisa la URL y el repositorio."
    rm -f "$TEMP_FILE"
    exit 1
  fi

  # Si el archivo no existe se deja la ultima version de develop
  if [ ! -f "$file_to_update" ]; then
    echo "El archivo local no existe."
    echo "Descargando el archivo..."

    # Verificar si el directorio existe, si no, crearlo
    if [ ! -d "$(dirname "$file_to_update")" ]; then
      mkdir -p "$(dirname "$file_to_update")"
    fi

    mv "$TEMP_FILE" "$file_to_update"
    chmod +x "$file_to_update"
    echo "Archivo descargado y permisos aplicados."

  # Si el archivo local es igual a la ultima version de develop
  elif cmp -s "$file_to_update" "$TEMP_FILE"; then
    echo "El archivo local ya está actualizado."

  # Si el archivo local existe y no es igual a la ultima version de develop, se reemplaza
  else
    echo "Hay una actualización disponible."
    echo "Descargando el archivo actualizado..."
    mv "$TEMP_FILE" "$file_to_update"
    chmod +x "$file_to_update"
    echo "Archivo actualizado descargado y permisos aplicados."
  fi
 
  # Limpiar el archivo temporal si todavía existe
  [ -f "$TEMP_FILE" ] && rm -f "$TEMP_FILE"
}

# Función para decidir qué archivo .sh ejecutar
script() {
  local script1="./downloaders/download_nes_spa.sh"
  local script2="./downloaders/download_psx_spa.sh"
  clear
  echo "Seleccione archivo a ejecutar:"
  echo "------------------------------"
  echo "1. NES"
  echo "2. PSX"
  echo ""
  local option=""
  while [ "$option" != "1" ] && [ "$option" != "2" ]; do
    read -p "Ingrese una opcion valida (1 o 2): " option
  done
  if [ "$option" = "1" ]; then
    check_for_updates "$LOCAL_FILE_NES" "$GITHUB_RAW_URL_NES"
    echo "Ejecutando $script1..."
    chmod +x "$script1"
    "$script1"
  elif [ "$option" = "2" ]; then
    check_for_updates "$LOCAL_FILE_PSX" "$GITHUB_RAW_URL_PSX"
    echo "Ejecutando $script2..."
    chmod +x "$script2"
    "$script2"
  fi
}

# Llamar a la función para decidir qué archivo .sh ejecutar
script