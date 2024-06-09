#!/bin/sh

# GitHub API variables
declare -A GITHUB_RAW_URLS
GITHUB_RAW_URLS=(
  ["NES"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_nes_spa.sh"
  ["PSX"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_psx_spa.sh"
  ["GB"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_gb_spa.sh"
  ["GBA"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_gba_spa.sh"
  ["GBC"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_gbc_spa.sh"
  ["SNES"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_snes_spa.sh"
  ["MAIN"]="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/main.sh"
)

declare -A LOCAL_FILES
LOCAL_FILES=(
  ["NES"]="downloaders/download_nes_spa.sh"
  ["PSX"]="downloaders/download_psx_spa.sh"
  ["GB"]="downloaders/download_gb_spa.sh"
  ["GBA"]="downloaders/download_gba_spa.sh"
  ["GBC"]="downloaders/download_gbc_spa.sh"
  ["SNES"]="downloaders/download_snes_spa.sh"
  ["MAIN"]="main.sh"
)

TOKEN="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"

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

# Se actualiza el archivo Main
check_for_updates "$LOCAL_FILE_MAIN" "${GITHUB_RAW_URLS["MAIN"]}"

# Función para decidir qué archivo .sh ejecutar
script() {
  clear
  echo "Seleccione archivo a ejecutar:"
  echo "------------------------------"
  echo ""
  echo -e "\e[32m1. NES  (Nintendo Entertainment System)\e[0m"
  echo -e "\e[32m2. PSX  (Plastation 1)\e[0m"
  echo -e "\e[32m3. GB   (Gameboy)\e[0m"
  echo -e "\e[32m4. GBA  (Gameboy Advance)\e[0m"
  echo -e "\e[32m5. GBC  (Gameboy Color)\e[0m"
  echo -e "\e[32m6. SNES (Super Nintendo)\e[0m"
  echo ""
  echo "------------------------------"
  echo ""
  local option=""
  while [ "$option" != "1" ] && [ "$option" != "2" ] && [ "$option" != "3" ] && [ "$option" != "4" ] && [ "$option" != "5" ] && [ "$option" != "6" ]; do
    read -p "Ingrese una opcion valida (1-6): " option
  done
  if [ "$option" = "1" ]; then
    check_for_updates "${LOCAL_FILES["NES"]}" "${GITHUB_RAW_URLS["NES"]}"
    script="${LOCAL_FILES["NES"]}"
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  elif [ "$option" = "2" ]; then
    check_for_updates "${LOCAL_FILES["PSX"]}" "${GITHUB_RAW_URLS["PSX"]}"
    script="${LOCAL_FILES["PSX"]}"
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  elif [ "$option" = "3" ]; then
    check_for_updates "${LOCAL_FILES["GB"]}" "${GITHUB_RAW_URLS["GB"]}"
    script="${LOCAL_FILES["GB"]}"
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  elif [ "$option" = "4" ]; then
    check_for_updates "${LOCAL_FILES["GBA"]}" "${GITHUB_RAW_URLS["GBA"]}"
    script="${LOCAL_FILES["GBA"]}"
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  elif [ "$option" = "5" ]; then
    check_for_updates "${LOCAL_FILES["GBC"]}" "${GITHUB_RAW_URLS["GBC"]}"
    script="${LOCAL_FILES["GBC"]}"
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  elif [ "$option" = "6" ]; then
    check_for_updates "${LOCAL_FILES["SNES"]}" "${GITHUB_RAW_URLS["SNES"]}"
    script="${LOCAL_FILES["SNES"]}"
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  fi
}

# Llamar a la función para decidir qué archivo .sh ejecutar
script