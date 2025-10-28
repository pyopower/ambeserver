# AMBEServer Dockerizado

Este repositorio contiene la configuración para construir y ejecutar la aplicación `DMRBeacon` usando Docker y Docker Compose, lo que permite una fácil implementación y un entorno de ejecución consistente.

## Cómo Empezar

Estas instrucciones te guiarán para poner en marcha el servicio `DMRBeacon` en tu máquina local usando Docker Compose.

### Prerrequisitos

Asegúrate de tener instalado tanto **Docker** como **Docker Compose** en tu sistema.
*   [Instrucciones de instalación de Docker](https://docs.docker.com/get-docker/)
*   [Instrucciones de instalación de Docker Compose](https://docs.docker.com/compose/install/)

### Configuración

1.  **Clona el repositorio:**
    ```sh
    git clone https://github.com/tu-usuario/ambeserver.git
    cd ambeserver
    ```

2.  **Crea tu archivo de configuración:**
    Copia el archivo de configuración de ejemplo para crear tu propia configuración.
    ```sh
    cp hblink.cfg.example hblink.cfg
    ```

3.  **Edita tu configuración:**
    Abre `hblink.cfg` con tu editor de texto y ajusta los parámetros (como `CALLSIGN`, `ID`, `IP`, etc.) según tus necesidades.

### Uso de Balizas de Audio (Opcional)

Puedes configurar el servicio para transmitir un archivo de audio como baliza en lugar del tono predeterminado.

1.  **Prepara tu archivo de audio:**
    El archivo de audio debe cumplir con los siguientes requisitos:
    *   **Formato:** WAV
    *   **Frecuencia de Muestreo:** 8000 Hz (8 kHz)
    *   **Profundidad de Bits:** 16 bits
    *   **Canales:** 1 (Mono)

    Si tienes un archivo de audio en otro formato (ej. MP3, o un WAV con diferentes especificaciones), puedes convertirlo usando la herramienta [SoX](https://sox.sourceforge.net/). Por ejemplo:
    ```sh
    sox tu-archivo.mp3 -r 8000 -b 16 -c 1 beacon.wav
    ```

2.  **Coloca el archivo de audio:**
    Mueve tu archivo `.wav` final al directorio `audio` que se encuentra en la raíz de este repositorio.

3.  **Habilita la baliza de audio:**
    En tu archivo `hblink.cfg`, edita la sección `[AUDIO]`:
    *   Cambia `ENABLE` a `1`.
    *   Asegúrate de que `FILENAME` coincida con el nombre de tu archivo de audio (ej. `beacon.wav`).

### Iniciar el Servicio

Una vez que hayas completado la configuración, puedes construir la imagen y ejecutar el contenedor con un solo comando:
```sh
sudo docker-compose up -d --build
```

El servicio se iniciará y se reiniciará automáticamente a menos que lo detengas explícitamente.

### Gestión del Servicio

*   **Verificar los Logs:**
    ```sh
    sudo docker-compose logs -f
    ```

*   **Detener el Servicio:**
    ```sh
    sudo docker-compose down
    ```
