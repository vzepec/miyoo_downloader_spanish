
# Descargador de Roms

Esto es un proyecto de uso personal en `sh` que permite descargar archivos roms en español de distintas plataformas desde Internet Archive. Aunque originalmente está pensado para correr en la consola Miyoo Mini Plus, tambien puede ejecutarse en algunos sistemas Linux.

El proyecto contiene un archivo `main.sh` que se usa para descargar y actualizar los scripts descargadores de roms desde la rama develop. 

Los scripts descargadores muestan una lista paginada de roms disponibles, te permite descargar los que elijas y almacenarlos en `../Roms/[Plataforma]`.

# Requerimientos 

* Miyoo con conexión Wi-Fi (Miyoo Mini Plus).
* OnionOS instalado en la Miyoo.
* Terminal app instalada en OnionOS.

# Instalación y Ejecución 

* Descarga el archivo [download_psx.sh](https://github.com/vzepec/miyoo_downloader_psx/blob/main/download_psx.sh).
* Conecta la micro SD de tu Miyoo a tu PC.
* Crea una carpeta en la micro SD llamada `scripts` y deja el archivo `download_psx.sh` dentro.
* Conecta la tarjeta micro SD a la Miyoo y abre la aplicación Terminal .
* Navega a la carpeta `scripts` con el siguiente comando :
```bash
  cd scripts
```
* Asigna permisos de ejecución con el siguiente comando (Solo la primera vez): 
```bash
  chmod 755 download_psx.sh
```

* Ejecuta el archivo `download_psx.sh` con el siguiente comando:
```bash
  ./download_psx.sh
```
# Uso y Actualización

Cuando corras el archivo `main.sh` verás un selector de plataforma, debes escribir la letra correspondiente.
Se verificá si existen cambios en comparación a la ultima version de la rama develop y en caso de existir, se descargará esa versión del script. Finalmente se ejecutará el script actualizado.
Actualmente soporta las siguientes plataformas:

- NES
- PSX

Una vez se ejecute el script de la plataforma seleccionada , aparecerá un menu con las roms paginadas donde puedes hacer lo siguiente:

- Navegar entre páginas escribiendo la letra `n` (página siguiente) o regresar a una página anterior escribiendo `p` .

- Descargar un archivo de juego escribiendo su número correspondiente. 

- Buscar alguna coincidencia por palabra escribiendo `s`.
 
- Cerrar el script escribiendo la letra `q` (Salir).
 
**Importante** Después de descargar un archivo, recuerda actualizar la lista de ROMs yendo a la sección Juegos y presionando el botón `Select` . 

## Mejoras futuras  🔥

* Correcion de bugs cuando se busca por nombre. 
* Compatibilidad con más plataformas.

## Demo
![Run the script](20240523_234008.gif)

![Choose and download ](20240523_234039.gif)




## 🚀 Autor

- [@vzepec](https://github.com/vzepec)
