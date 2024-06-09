#!/bin/sh

# GitHub API variables
GITHUB_RAW_URLS_NES="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_nes_spa.sh"
GITHUB_RAW_URLS_PSX="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_psx_spa.sh"
GITHUB_RAW_URLS_GB="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_gb_spa.sh"
GITHUB_RAW_URLS_GBA="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_gba_spa.sh"
GITHUB_RAW_URLS_GBC="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_gbc_spa.sh"
GITHUB_RAW_URLS_SNES="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/downloaders/download_snes_spa.sh"
GITHUB_RAW_URLS_MAIN="https://raw.githubusercontent.com/vzepec/miyoo_downloader_spanish/develop/main.sh"

LOCAL_FILES_NES="downloaders/download_nes_spa.sh"
LOCAL_FILES_PSX="downloaders/download_psx_spa.sh"
LOCAL_FILES_GB="downloaders/download_gb_spa.sh"
LOCAL_FILES_GBA="downloaders/download_gba_spa.sh"
LOCAL_FILES_GBC="downloaders/download_gbc_spa.sh"
LOCAL_FILES_SNES="downloaders/download_snes_spa.sh"
LOCAL_FILES_MAIN="main.sh"

TOKEN="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"

# Función para verificar si hay cambios en el archivo
check_for_updates() {
  local file_to_update="$1"
  local GITHUB_RAW_URL="$2"
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
    echo "El archivo local ya esta actualizado."

  # Si el archivo local existe y no es igual a la ultima version de develop, se reemplaza
  else
    echo "Hay una actualizacion disponible."
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
  echo -e "\e[32mu. Actualizar Scripts\e[0m"
  echo -e "\e[32mq. Salir\e[0m"
  echo ""
  echo "------------------------------"
  echo ""
  local option=""
  while [ "$option" != "1" ] && [ "$option" != "2" ] && [ "$option" != "3" ] && [ "$option" != "4" ] && [ "$option" != "5" ] && [ "$option" != "6" ] && [ "$option" != "u" ] && [ "$option" != "q" ]; do
    read -p "Ingrese una opcion valida (1-6, u, q): " option
  done
  case "$option" in
    1)
      clear
      script="$LOCAL_FILES_NES"
      ;;
    2)
      clear
      script="$LOCAL_FILES_PSX"
      ;;
    3)
      clear
      script="$LOCAL_FILES_GB"
      ;;
    4)
      clear
      script="$LOCAL_FILES_GBA"
      ;;
    5)
      clear
      script="$LOCAL_FILES_GBC"
      ;;
    6)
      clear
      script="$LOCAL_FILES_SNES"
      ;;
    u)
      clear
      check_for_updates "$LOCAL_FILES_MAIN" "$GITHUB_RAW_URLS_MAIN"
      check_for_updates "$LOCAL_FILES_SNES" "$GITHUB_RAW_URLS_SNES"
      check_for_updates "$LOCAL_FILES_GBC" "$GITHUB_RAW_URLS_GBC"
      check_for_updates "$LOCAL_FILES_GBA" "$GITHUB_RAW_URLS_GBA"
      check_for_updates "$LOCAL_FILES_GB" "$GITHUB_RAW_URLS_GB"
      check_for_updates "$LOCAL_FILES_PSX" "$GITHUB_RAW_URLS_PSX"
      check_for_updates "$LOCAL_FILES_NES" "$GITHUB_RAW_URLS_NES"
      check_for_updates "$LOCAL_FILES_SNES" "$GITHUB_RAW_URLS_SNES"
      ;;
    q)
      clear
      exit 0
      ;;
  esac
  if [ "$option" != "u" ]; then
    echo "Ejecutando $script..."
    chmod +x "$script"
    "$script"
  else
    script
  fi
  return
}

# Llamar a la función para decidir qué archivo .sh ejecutar
script
