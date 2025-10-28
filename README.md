# AMBEServer Dockerizado

Este repositorio contiene un `Dockerfile` para construir una imagen de Docker para la aplicación `DMRBeacon`, que a su vez depende de `mbelib`. Esto permite una fácil implementación y un entorno de ejecución consistente.

## Cómo Empezar

Estas instrucciones te guiarán para construir y ejecutar la imagen de Docker en tu máquina local.

### Prerrequisitos

Asegúrate de tener Docker instalado en tu sistema. Puedes encontrar las instrucciones de instalación para tu sistema operativo en el [sitio web oficial de Docker](https://docs.docker.com/get-docker/).

### Construcción de la Imagen

1.  **Clona el repositorio:**
    ```sh
    git clone https://github.com/tu-usuario/ambeserver.git
    cd ambeserver
    ```

2.  **Construye la imagen de Docker:**
    Desde el directorio raíz del repositorio, ejecuta el siguiente comando. Esto compilará el código fuente y creará una imagen de Docker llamada `dmrbeacon`.
    ```sh
    docker build -t dmrbeacon .
    ```

### Ejecución del Contenedor

Una vez que la imagen se haya construido correctamente, puedes ejecutar un contenedor a partir de ella.

```sh
docker run -d --rm --name dmrbeacon-container -p 54005:54005 dmrbeacon
```

Desglose de los comandos:
*   `docker run`: Comando para iniciar un nuevo contenedor.
*   `-d`: Ejecuta el contenedor en modo "detached" (en segundo plano).
*   `--rm`: Elimina automáticamente el contenedor cuando se detiene.
*   `--name dmrbeacon-container`: Asigna un nombre al contenedor para facilitar su gestión.
*   `-p 54005:54005`: Mapea el puerto `54005` del contenedor al puerto `54005` de tu máquina anfitriona. El `Dockerfile` expone este puerto, que es el utilizado por `DMRBeacon`.
*   `dmrbeacon`: El nombre de la imagen que creaste en el paso anterior.

### Verificar los Logs

Para ver la salida y los logs del contenedor en ejecución, puedes usar el siguiente comando:
```sh
docker logs -f dmrbeacon-container
```

### Detener el Contenedor

Para detener el contenedor, puedes usar el siguiente comando:
```sh
docker stop dmrbeacon-container
```
