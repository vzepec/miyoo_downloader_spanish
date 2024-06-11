
# Descargador de Roms

Esto es un proyecto de scripts `sh` que permiten descargar archivos roms en español de distintas plataformas desde Internet Archive. Aunque principalmente está pensado para ser ejecutado en la consola Miyoo Mini Plus, tambien puede ejecutarse en algunos sistemas Linux.

El proyecto contiene un archivo principal `main.sh` que se usa para descargar y actualizar los scripts a la ultima version release disponible. 

Los scripts descargadores muestan una lista paginada de roms disponibles, te permite descargar los que elijas y almacenarlos en `../Roms/[Plataforma]`.

# Requerimientos 

* Miyoo con conexión Wi-Fi (Miyoo Mini Plus).
* OnionOS instalado en la Miyoo.
* Terminal app instalada en OnionOS.

# Instalación y Ejecución 

* Descarga el archivo [main.sh](https://github.com/vzepec/miyoo_downloader_spanish/releases/download/v1.0.0/main.sh).
* Conecta la micro SD de tu Miyoo a tu PC.
* Crea una carpeta en la micro SD llamada `scripts` y deja el archivo `main.sh` dentro.
* Conecta la tarjeta micro SD a la Miyoo y abre la aplicación Terminal .
* Navega a la carpeta `scripts` con el siguiente comando :
```bash
  cd scripts
```
* Asigna permisos de ejecución con el siguiente comando (Solo la primera vez): 
```bash
  chmod 755 main.sh
```

* Ejecuta el archivo `main.sh` con el siguiente comando:
```bash
  ./main.sh
```
# Uso y Actualización

Cuando corras el archivo `main.sh` verás un selector de plataformas, debes escribir el numero correspondiente y se ejecutará el script descargador de la plataforma seleccionada.
Actualmente soporta las siguientes plataformas:

- NES
- PSX
- GB
- GBA
- GBC
- SNES

Ademas, el archivo main.sh, dispone de una opcion para buscar actualizaciones de los scripts, si encuentra alguna actualizacion se descargara automaticamente.

Una vez se ejecute el script de la plataforma seleccionada , aparecerá un menu con las roms paginadas donde puedes hacer lo siguiente:

- Navegar entre páginas escribiendo la letra `n` (página siguiente) o regresar a una página anterior escribiendo `p` .

- Descargar un archivo de juego escribiendo su número correspondiente. 

- Buscar alguna coincidencia por palabra escribiendo `s`.
  
- Voler al selector de plataformas escribiendo `m`.
 
- Cerrar el script escribiendo la letra `q` (Salir).
 
**Importante** Después de descargar un archivo, recuerda actualizar la lista de ROMs yendo a la sección Juegos y presionando el botón `Select` . 

## Mejoras futuras  🔥

* Correccion de bugs.
* Mas fuentes.

## Demo

<div align="center">
  <img src="/Gifs/GIF_1.gif" alt="Run the script">
</div>

<div align="center">
  <img src="/Gifs/GIF_2.gif" alt="Choose and download">
</div>


## 🚀 Autor

- [@vzepec](https://github.com/vzepec)
