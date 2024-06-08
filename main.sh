#!/bin/sh

# GitHub API variables
GITHUB_API_URL_NES="https://api.github.com/repos/vzepec/miyoo_downloader_spanish/contents/download_nes_spa.sh?ref=develop"
GITHUB_RAW_URL_NES="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/download_nes_spa.sh"
GITHUB_API_URL_PSX="https://api.github.com/repos/vzepec/miyoo_downloader_spanish/contents/download_psx_spa.sh?ref=develop"
GITHUB_RAW_URL_PSX="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/download_psx_spa.sh"
TOKEN="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"
LOCAL_FILE_NES="download_nes_spa.sh"
LOCAL_FILE_PSX="download_psx_spa.sh"

# Función para verificar si hay cambios en el archivo
check_for_updates() {
  local remote_sha
  local local_sha
  local file_to_update="$1"
  local GITHUB_API_URL="$2"
  local GITHUB_RAW_URL="$3"
  clear
  echo "Buscando actualizaciones... para $file_to_update"
  remote_sha=$(curl -s -H "Authorization: token $TOKEN" "$GITHUB_API_URL" | jq -r '.sha')
  local_sha=$(git hash-object "$file_to_update")

  if [ "$remote_sha" != "$local_sha" ]; then
    echo "Hay una actualización disponible. Descargando el archivo actualizado..."
    curl -s -H "Authorization: token $TOKEN" -O "$GITHUB_RAW_URL"
    chmod +x "$file_to_update"
    echo "Archivo actualizado descargado y permisos aplicados."
  else
    echo "El archivo local está actualizado."
  fi
}

# Verificar actualizaciones antes de ejecutar el script de tareas

#check_for_updates

# Ejecutar el script de tareas
#./download_nes_spa.sh

# Función para decidir qué archivo .sh ejecutar
script() {
    local script1="./download_nes_spa.sh"
    local script2="./download_psx_spa.sh"
    echo "Seleccione archivo a ejecutar: 1 for NES, 2 for PSX: "
    read option
    if [ "$option" = "1" ]; then
        check_for_updates "$LOCAL_FILE_NES" "$GITHUB_API_URL_NES" "$GITHUB_RAW_URL_NES"
        echo "Ejecutando $script1..."
        chmod +x "$script1"
        "$script1"
    elif [ "$option" = "2" ]; then
        check_for_updates "$LOCAL_FILE_PSX" "$GITHUB_API_URL_PSX" "$GITHUB_RAW_URL_PSX"
        echo "Ejecutando $script2..."
        chmod +x "$script2"
        "$script2"
    else
        echo "Opcion Invalida"
    fi
}

# Llamar a la función para decidir qué archivo .sh ejecutar
script
