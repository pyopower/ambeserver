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
    El repositorio incluye un archivo de configuración de ejemplo llamado `hblink.cfg.example`. Cópialo para crear tu propio archivo de configuración.
    ```sh
    cp hblink.cfg.example hblink.cfg
    ```

3.  **Edita tu configuración:**
    Abre el archivo `hblink.cfg` con tu editor de texto preferido y ajusta los parámetros (como `CALLSIGN`, `ID`, `IP`, etc.) según tus necesidades.

### Iniciar el Servicio

Una vez que hayas configurado tu archivo `hblink.cfg`, puedes construir la imagen y ejecutar el contenedor con un solo comando:

```sh
sudo docker-compose up -d --build
```

Desglose del comando:
*   `sudo docker-compose up`: Construye la imagen (si no existe), crea e inicia el contenedor.
*   `-d`: Ejecuta el contenedor en modo "detached" (en segundo plano).
*   `--build`: Fuerza la reconstrucción de la imagen de Docker. Es útil si has hecho cambios en el `Dockerfile`.

El servicio se iniciará y se reiniciará automáticamente a menos que lo detengas explícitamente.

### Gestión del Servicio

*   **Verificar los Logs:**
    Para ver la salida y los logs del contenedor en tiempo real:
    ```sh
    sudo docker-compose logs -f
    ```

*   **Detener el Servicio:**
    Para detener y eliminar el contenedor:
    ```sh
    sudo docker-compose down
    ```
