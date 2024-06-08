#!/bin/sh

# GitHub API variables
GITHUB_RAW_URL_NES="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/download_nes_spa.sh"
GITHUB_RAW_URL_PSX="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/download_psx_spa.sh"
TOKEN="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"
LOCAL_FILE_NES="download_nes_spa.sh"
LOCAL_FILE_PSX="download_psx_spa.sh"

# Función para verificar si hay cambios en el archivo
check_for_updates() {
  local file_to_update="$1"
  local GITHUB_RAW_URL="$2"
  clear
  echo "Buscando actualizaciones... para $file_to_update"

  # Crear un archivo temporal
  TEMP_FILE=$(mktemp)
  if [ ! -f "$TEMP_FILE" ]; then
    echo "No se pudo crear un archivo temporal."
    exit 1
  fi
  curl -s -k -H "Authorization: token $TOKEN" --connect-timeout 10 -f -o "$TEMP_FILE" "$GITHUB_RAW_URL" || {
    echo "Error al descargar el archivo. Verifica la conexión y el token."
    rm -f "$TEMP_FILE"
    exit 1
  }

  if [ ! -s "$TEMP_FILE" ]; then
    echo "El archivo descargado está vacío. Revisa la URL y el repositorio."
    rm -f "$TEMP_FILE"
    exit 1
  fi

  # Comparar el archivo local con el archivo remoto
  if cmp -s "$file_to_update" "$TEMP_FILE"; then
    echo "El archivo local está actualizado."
  else
    echo "Hay una actualización disponible. Descargando el archivo actualizado..."
    mv "$TEMP_FILE" "$file_to_update"
    chmod +x "$file_to_update"
    echo "Archivo actualizado descargado y permisos aplicados."
  fi

  # Limpiar el archivo temporal si todavía existe
  [ -f "$TEMP_FILE" ] && rm -f "$TEMP_FILE"
}

# Función para decidir qué archivo .sh ejecutar
script() {
    local script1="./download_nes_spa.sh"
    local script2="./download_psx_spa.sh"
    echo "Seleccione archivo a ejecutar: 1 for NES, 2 for PSX: "
    read option
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
    else
        echo "Opción inválida"
    fi
}

# Llamar a la función para decidir qué archivo .sh ejecutar
script
