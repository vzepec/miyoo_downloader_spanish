#!/bin/sh

# Version del script
version="v1.0.2"

COOKIES_FILE="cookies.txt"

# Obtiene la ultima version
latest_version=$(wget -qO- https://api.github.com/repos/vzepec/miyoo_downloader_spanish/releases/latest | jq -r '.tag_name')

# URLs de las releases en GitHub
GITHUB_RELEASE_URLS_NES="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/download_nes_spa.sh"
GITHUB_RELEASE_URLS_PSX="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/download_psx_spa.sh"
GITHUB_RELEASE_URLS_GB="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/download_gb_spa.sh"
GITHUB_RELEASE_URLS_GBA="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/download_gba_spa.sh"
GITHUB_RELEASE_URLS_GBC="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/download_gbc_spa.sh"
GITHUB_RELEASE_URLS_SNES="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/download_snes_spa.sh"
GITHUB_RELEASE_URLS_MAIN="https://github.com/vzepec/miyoo_downloader_spanish/releases/download/$latest_version/main.sh"

LOCAL_FILES_NES="downloaders/download_nes_spa.sh"
LOCAL_FILES_PSX="downloaders/download_psx_spa.sh"
LOCAL_FILES_GB="downloaders/download_gb_spa.sh"
LOCAL_FILES_GBA="downloaders/download_gba_spa.sh"
LOCAL_FILES_GBC="downloaders/download_gbc_spa.sh"
LOCAL_FILES_SNES="downloaders/download_snes_spa.sh"
LOCAL_FILES_MAIN="main.sh"



# Funcion para verificar si hay cambios en el archivo
check_for_updates() {
  local file_to_update="$1"
  local GITHUB_RELEASE_URL="$2"
  echo "Buscando actualizaciones para $file_to_update ..."

  # Crear un archivo temporal
  TEMP_FILE=$(mktemp)
  if [ ! -f "$TEMP_FILE" ]; then
    echo "No se pudo crear un archivo temporal."
    exit 1
  fi
  wget -q --timeout=10 -O "$TEMP_FILE" "$GITHUB_RELEASE_URL" || {
    echo "Error al descargar el archivo. Verifica la conexion y la URL."
    rm -f "$TEMP_FILE"
    exit 1
  }

  if [ ! -s "$TEMP_FILE" ]; then
    echo "El archivo descargado esta vacio. Revisa la URL y el repositorio."
    rm -f "$TEMP_FILE"
    exit 1
  fi

  if [ ! -f "$file_to_update" ]; then
    echo "El archivo local no existe. Descargando el archivo..."
    [ ! -d "$(dirname "$file_to_update")" ] && mkdir -p "$(dirname "$file_to_update")"
    mv "$TEMP_FILE" "$file_to_update"
    chmod +x "$file_to_update"
    dos2unix "$file_to_update"
    echo "Archivo descargado y permisos aplicados."
  else
    mv "$TEMP_FILE" "$file_to_update"
    chmod +x "$file_to_update"
    dos2unix "$file_to_update"
    echo "Archivo actualizado"
  fi
  rm -f "$TEMP_FILE"
}

# Funcion para actualizar y reiniciar el script principal
update_and_restart_main() {
  local GITHUB_RELEASE_URL="$1"
  echo "Buscando actualizaciones para $LOCAL_FILES_MAIN ..."

  # Crear un archivo temporal
  TEMP_FILE=$(mktemp)
  if [ ! -f "$TEMP_FILE" ];then
    echo "No se pudo crear un archivo temporal."
    exit 1
  fi
  wget -q --timeout=10 -O "$TEMP_FILE" "$GITHUB_RELEASE_URL" || {
    echo "Error al descargar el archivo. Verifica la conexion y la URL."
    rm -f "$TEMP_FILE"
    exit 1
  }

  if [ ! -s "$TEMP_FILE" ];then
    echo "El archivo descargado esta vacio. Revisa la URL y el repositorio."
    exit 1
  else
    mv "$TEMP_FILE" "$LOCAL_FILES_MAIN"
    chmod +x "$LOCAL_FILES_MAIN"
    dos2unix "$LOCAL_FILES_MAIN"
    echo "Archivo actualizado"
    echo "Reiniciando script..."
    exec "$(pwd)/$LOCAL_FILES_MAIN"
  fi
  rm -f "$TEMP_FILE"
}

# Funcion para decidir qué archivo .sh ejecutar
script() {
  clear
  echo ""
  echo "___ _______________________________ ________ "
  echo "|  \|___[__ |   |__||__/| __|__||  \|  ||__/ "
  echo "|__/|______]|___|  ||  \|__]|  ||__/|__||  \ "
  echo "                                             $version"
  echo "Seleccione Plataforma:"
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
    read -p "Opcion > " option
  done
  case "$option" in
    1)
      clear
      [ ! -f "$LOCAL_FILES_NES" ] && check_for_updates "$LOCAL_FILES_NES" "$GITHUB_RELEASE_URLS_NES"
      script="$LOCAL_FILES_NES"
      ;;
    2)
      clear
      [ ! -f "$LOCAL_FILES_PSX" ] && check_for_updates "$LOCAL_FILES_PSX" "$GITHUB_RELEASE_URLS_PSX"
      script="$LOCAL_FILES_PSX"
      ;;
    3)
      clear
      [ ! -f "$LOCAL_FILES_GB" ] && check_for_updates "$LOCAL_FILES_GB" "$GITHUB_RELEASE_URLS_GB"
      script="$LOCAL_FILES_GB"
      ;;
    4)
      clear
      [ ! -f "$LOCAL_FILES_GBA" ] && check_for_updates "$LOCAL_FILES_GBA" "$GITHUB_RELEASE_URLS_GBA"
      script="$LOCAL_FILES_GBA"
      ;;
    5)
      clear
      [ ! -f "$LOCAL_FILES_GBC" ] && check_for_updates "$LOCAL_FILES_GBC" "$GITHUB_RELEASE_URLS_GBC"
      script="$LOCAL_FILES_GBC"
      ;;
    6)
      clear
      [ ! -f "$LOCAL_FILES_SNES" ] && check_for_updates "$LOCAL_FILES_SNES" "$GITHUB_RELEASE_URLS_SNES"
      script="$LOCAL_FILES_SNES"
      ;;
    u)
      clear
      check_for_updates "$LOCAL_FILES_SNES" "$GITHUB_RELEASE_URLS_SNES"
      check_for_updates "$LOCAL_FILES_GBC" "$GITHUB_RELEASE_URLS_GBC"
      check_for_updates "$LOCAL_FILES_GBA" "$GITHUB_RELEASE_URLS_GBA"
      check_for_updates "$LOCAL_FILES_GB" "$GITHUB_RELEASE_URLS_GB"
      check_for_updates "$LOCAL_FILES_PSX" "$GITHUB_RELEASE_URLS_PSX"
      check_for_updates "$LOCAL_FILES_NES" "$GITHUB_RELEASE_URLS_NES"
      update_and_restart_main "$GITHUB_RELEASE_URLS_MAIN"
      ;;
    q)
      clear
      exit 0
      ;;
  esac
  if [ "$option" != "u" ]; then
    echo "Ejecutando $script..."
    chmod +x "$script"
    COOKIES_FILE="$COOKIES_FILE" "$script"
  else
    script
  fi
  return
}

# Llamar a la funcion para decidir qué archivo .sh ejecutar
script
