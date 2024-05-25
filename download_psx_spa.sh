#!/bin/sh

# URL base
BASE_URL="https://archive.org/download/chd_psx_eur/CHD-PSX-EUR/"
BASE_URL2="https://archive.org/download/psx-compilacion-de-traducciones-en-espanol_202305/"
BASE_URL3="https://archive.org/download/compilacion-traducciones-en-castellano-psx/"
 
# Función para filtrar archivos por idioma español (opcional)
filter_spanish() {
    grep -i "Es%2C" file_list.txt > file_list_filtered.txt
    mv file_list_filtered.txt file_list.txt
}

# Descargar la lista de archivos para BASE_URL
wget -q -O - "$BASE_URL" | grep -o 'href="[^\"]*\.chd"' | sed 's/ /%20/g' | sed 's/href="//' | sed 's/"//' > file_list.txt

filter_spanish

# Descargar la lista de archivos para BASE_URL2
wget -q -O - "$BASE_URL2" | grep -o 'href="[^\"]*\.7z"' | sed 's/ /%20/g' | sed 's/href="//' | sed 's/"//' > file_list_2.txt

# Descargar la lista de archivos para BASE_URL3
wget -q -O - "$BASE_URL3" | grep -o 'href="[^\"]*\.7z"' | sed 's/ /%20/g' | sed 's/href="//' | sed 's/"//' > file_list_3.txt

# Agregar archivos de BASE_URL2 y BASE_URL3 a file_list.txt
cat file_list_2.txt >> file_list.txt
cat file_list_3.txt >> file_list.txt

# Reordenar los nombres alfabéticamente y eliminar duplicados
sort -u file_list.txt -o file_list.txt
sort -u file_list_2.txt -o file_list_2.txt
sort -u file_list_3.txt -o file_list_3.txt

# Función para descomprimir archivos .7z
extract_7z() {
    local file="$1"
    7z x "$file" -o"../Roms/PS"
    rm "$file"
}

# Función para realizar la sustitución
perform_substitution() {
    echo "$1" | sed -e 's/%20/ /g' -e 's/%28/(/g' -e 's/%29/)/g' -e 's/%2C/,/g' -e 's/%26/\&/g' -e 's/%27/'"'"'/g' -e 's/%21/!/g' -e 's/%25/%/g' -e 's/%5B/[/g' -e 's/%5D/]/g' -e 's/%2B/+/g' -e 's/%C3%AD/í/g' -e 's/%C3%B3/ó/g'
}

# Función para mostrar una página de archivos
show_page() {
    clear
    local page="$1"
    local start=$((page * 10))
    local end=$((start + 10))
    local i=0
    local line
    local total_files=$(wc -l < file_list.txt)
    echo "Page $((page + 1)):"
    echo "Total files: $total_files"
    echo "------"
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
    done < file_list.txt
    echo ""
    echo "------------------"
    echo "n. Next page"
    echo "p. Previous page"
    echo "q. Quit"
}

# Función para descargar el archivo seleccionado (corregida)
download_file() {
    local index="$1"
    local i=0
    local line
    local file_name

    while IFS= read -r line && [ $i -le $index ]; do
        if [ $i -eq $index ]; then
            # Verificar la extensión del archivo
            if echo "$line" | grep -q '\.chd$'; then
                wget -P "../Roms/PS/" "$BASE_URL$line"
            else
                # Determinar la URL base correcta para archivos .7z
                if grep -q "$line" file_list_2.txt; then
                    wget -P "../Roms/PS/" "$BASE_URL2$line"
                elif grep -q "$line" file_list_3.txt; then
                    wget -P "../Roms/PS/" "$BASE_URL3$line"
                fi
            fi
            file_name=$(perform_substitution "$line")
            mv "../Roms/PS/$line" "../Roms/PS/$file_name"
            if echo "$line" | grep -q '\.7z$'; then
                extract_7z "../Roms/PS/$file_name"
            fi
            echo "Download complete: ../Roms/PS/$file_name"
            break
        fi
        i=$((i + 1))
    done < file_list.txt
}

# Inicializar variables
page=0
while true; do
    show_page "$page"
    echo -n "Select a file to download (number), navigate (n/p), or quit (q): "
    read -r choice

    if echo "$choice" | grep -q '^[0-9]\+$'; then
        index=$((choice - 1))
        echo "Downloading..."
        download_file "$index"
    elif [ "$choice" = "n" ]; then
        page=$((page + 1))
        if ! tail -n +$((page * 10 + 1)) file_list.txt | head -n 1 >/dev/null 2>&1; then
            page=$((page - 1))
            echo "No more pages."
        fi
    elif [ "$choice" = "p" ]; then
        if [ "$page" -gt 0 ]; then
            page=$((page - 1))
        else
            echo "Already at the first page."
        fi
    elif [ "$choice" = "q" ]; then
        break
    else
        echo "Invalid choice."
    fi
done

# Cleanup
rm file_list.txt
rm file_list_2.txt
rm file_list_3.txt