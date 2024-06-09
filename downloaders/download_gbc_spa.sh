#!/bin/sh

# URL base
BASE_URL="https://archive.org/download/tomb-raider-gbc-roms-nintendo-en-espanol/"
BASE_URL2="https://archive.org/download/gbc-compilacion-de-traducciones-en-espanol_202404/"
BASE_URL3="https://archive.org/download/compilacion-traducciones-castellano-gbc/"
 


# Crear la carpeta temp_files si no existe
mkdir -p temp_files

# Descargar la lista de archivos para BASE_URL
wget -q -O - "$BASE_URL" | grep -o 'href="[^\"]*\.\(gbc\|GBC\)"'  | sed 's/ /%20/g' | sed 's/href="//' | sed 's/"//' > temp_files/file_list_gbc.txt

# Descargar la lista de archivos para BASE_URL2
wget -q -O - "$BASE_URL2" | grep -o 'href="[^\"]*\.zip"' | sed 's/ /%20/g' | sed 's/href="//' | sed 's/"//' > temp_files/file_list_gbc_2.txt

# Descargar la lista de archivos para BASE_URL3
wget -q -O - "$BASE_URL3" | grep -o 'href="[^\"]*\.zip"' | sed 's/ /%20/g' | sed 's/href="//' | sed 's/"//' > temp_files/file_list_gbc_3.txt

# Agregar archivos de BASE_URL2 y BASE_URL3 a temp_files/file_list_gbc.txt
cat temp_files/file_list_gbc_2.txt >> temp_files/file_list_gbc.txt
cat temp_files/file_list_gbc_3.txt >> temp_files/file_list_gbc.txt

# Reordenar los nombres alfabéticamente y eliminar duplicados
sort -u temp_files/file_list_gbc.txt -o temp_files/file_list_gbc.txt
sort -u temp_files/file_list_gbc_2.txt -o temp_files/file_list_gbc_2.txt
sort -u temp_files/file_list_gbc_3.txt -o temp_files/file_list_gbc_3.txt

# Función para descomprimir archivos .zip
extract_zip() {
  local file="$1"
  unzip "$file" -d "../Roms/GBC"
  # Validar si hay archivos o directorios sin la extension .gbc
  local invalid_files=$(find "../Roms/GBC" ! -name "*.gbc")
  if [ -n "$invalid_files" ]; then
    find "../Roms/GBC" ! -name "*.gbc" ! -name "*.GBC" -type f -delete
    find "../Roms/GBC" ! -name "*.gbc" ! -name "*.GBC" -type d -delete
  fi
}

# Función para realizar la sustitución
perform_substitution() {
  echo "$1" | sed -e 's/%20/ /g' -e 's/%28/(/g' -e 's/%29/)/g' -e 's/%2C/,/g' -e 's/%26/\&/g' -e 's/%27/'"'"'/g' -e 's/%21/!/g' -e 's/%25/%/g' -e 's/%5B/[/g' -e 's/%5D/]/g' -e 's/%2B/+/g' -e 's/%C3%AD/í/g' -e 's/%C3%B3/ó/g' -e 's/%C3%A9/e/g'
}

# Función para mostrar una página de archivos
show_page() {
  clear
  local page="$1"
  local start=$((page * 10))
  local end=$((start + 10))
  local i=0
  local line
  local total_files=$(wc -l < temp_files/file_list_gbc.txt)
  echo "Pagina $((page + 1)):"
  echo "Total de juegos: $total_files"
  echo "----------------"
  echo ""
  while IFS= read -r line && [ $i -lt $end ]; do
    i=$((i + 1))
    if [ $i -gt $start ]; then
      file_name=$(perform_substitution "$line")
      if [ ${#file_name} -gt 45 ]; then
        file_name="${file_name:0:45}..."
      fi
      echo -e "\e[32m$i. $file_name\e[0m"
    fi
  done < temp_files/file_list_gbc.txt
  echo ""
  echo "------------------"
  echo "n. Pagina siguiente"
  echo "p. Pagina anterior"
  echo "s. Buscar por nombre"
  echo "m. Regresar al menu de plataformas"
  echo "q. Salir"
  echo ""
}

search_file() {
  echo -n "Escribe el juego a buscar > "
  read -r search_name
  # Convertir la cadena de búsqueda en una expresión regular
  local search_regex=$(echo "$search_name" | sed 's/ /.* /g')
  grep -i -E "$search_regex" temp_files/file_list_gbc.txt > temp_files/search_results.txt
  local total_results=$(wc -l < temp_files/search_results.txt)
  if [ $total_results -eq 0 ]; then
    echo "No hay resultados para '$search_name'."
  else
    paginate_search_results 0
  fi
}

paginate_search_results() {
  local page="$1"
  local start=$((page * 10))
  local end=$((start + 10))
  local i=0
  local line
  local total_results=$(wc -l < temp_files/search_results.txt)
  clear
  echo "Resultados de la busqueda - Pagina $((page + 1)):"
  echo "Total de resultados: $total_results"
  echo "-------------------"
  echo ""
  while IFS= read -r line && [ $i -lt $end ]; do
    i=$((i + 1))
    if [ $i -gt $start ]; then
      file_name=$(perform_substitution "$line")
      if [ ${#file_name} -gt 45 ]; then
        file_name="${file_name:0:45}..."
      fi
      echo -e "\e[32m$i. $file_name\e[0m"
    fi
  done < temp_files/search_results.txt
  echo ""
  echo "------------------"
  echo "n. Pagina siguiente"
  echo "p. Pagina anterior"
  echo "m. Menu"
  echo ""
  read -p "Opcion > " choice
  if echo "$choice" | grep -q '^[0-9]\+$'; then
    index=$((choice - 1))
    file_to_download=$(sed -n "$((index + 1))p" temp_files/search_results.txt)  # Ajuste para obtener la línea correcta
    echo "Descargando $file_to_download..."
    download_filtered_file "$file_to_download"
  elif [ "$choice" = "n" ]; then
    page=$((page + 1))
    if ! tail -n +$((page * 10 + 1)) temp_files/search_results.txt | head -n 1 >/dev/null 2>&1; then
      page=$((page - 1))
      echo "No hay mas paginas."
    fi
    paginate_search_results "$page"
  elif [ "$choice" = "p" ]; then
    if [ "$page" -gt 0 ]; then
      page=$((page - 1))
    else
      echo "Ya estas en la primera pagina"
    fi
    paginate_search_results "$page"
  elif [ "$choice" = "m" ]; then
    return
  else
    echo "Opcion invalida."
    paginate_search_results "$page"
  fi
}

# Función para descargar el archivo filtrado seleccionado
download_filtered_file() {
  local line="$1"
  local file_name

  if echo "$line" | grep -q -E '\.gbc$|\.GBC$'; then
    wget -P "../Roms/GBC/" "$BASE_URL$line"
  else
    if grep -q "$line" temp_files/file_list_gbc_2.txt; then
      wget -P "../Roms/GBC/" "$BASE_URL2$line"
    elif grep -q "$line" temp_files/file_list_gbc_3.txt; then
      wget -P "../Roms/GBC/" "$BASE_URL3$line"
    fi
  fi
  file_name=$(perform_substitution "$line")
  mv "../Roms/GBC/$line" "../Roms/GBC/$file_name"
  if echo "$line" | grep -q '\.zip$'; then
    extract_zip "../Roms/GBC/$file_name"
  fi
  echo "Descarga completa: ../Roms/GBC/$file_name"
}

# Función para descargar el archivo seleccionado (corregida)
download_file() {
  local index="$1"
  local i=0
  local line
  local file_name

  while IFS= read -r line && [ $i -le $index ]; do
    if [ $i -eq $index ]; then
      if echo "$line" | grep -q -E '\.gbc$|\.GBC$'; then
        wget -P "../Roms/GBC/" "$BASE_URL$line"
      else
        if grep -q "$line" temp_files/file_list_gbc_2.txt; then
          wget -P "../Roms/GBC/" "$BASE_URL2$line"
        elif grep -q "$line" temp_files/file_list_gbc_3.txt; then
          wget -P "../Roms/GBC/" "$BASE_URL3$line"
        fi
      fi
      file_name=$(perform_substitution "$line")
      mv "../Roms/GBC/$line" "../Roms/GBC/$file_name"
      if echo "$line" | grep -q '\.zip$'; then
        extract_zip "../Roms/GBC/$file_name"
      fi
      echo "Descarga completa: ../Roms/GBC/$file_name"
      break
    fi
    i=$((i + 1))
  done < temp_files/file_list_gbc.txt
}

# Inicializar variables
page=0
while true; do
  show_page "$page"
  read -p "Opcion > " choice
  case "$choice" in
    s)
      clear
      search_file
      ;;
    [0-9])
      index=$((choice - 1))
      echo "Descargando..."
      download_file "$index"
      ;;
    n)
      page=$((page + 1))
      if ! tail -n +$((page * 10 + 1)) temp_files/file_list_gbc.txt | head -n 1 >/dev/null 2>&1; then
        page=$((page - 1))
        echo "No hay mas paginas."
      fi
      ;;
    p)
      if [ "$page" -gt 0 ]; then
        page=$((page - 1))
      else
        echo "Ya estas en la primera pagina"
      fi
      ;;
    q)
      clear
      break
      ;;
    m)
      echo "Regresando al menú principal..."
      rm -rf temp_files
      ./main.sh
      break
      ;;
    *)
      echo "Opcion invalida."
      ;;
  esac
done

# Cleanup
rm -rf temp_files