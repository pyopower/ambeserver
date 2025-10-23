# Servidor Emulador AMBE (ambeserver)

Este proyecto te permite ejecutar el emulador `md380-emu` de una manera muy sencilla, utilizando Docker. Esto significa que no tienes que preocuparte por instalar dependencias o compilar programas manualmente en tu servidor. Todo está empaquetado y listo para usar.

### Compatibilidad Multi-Arquitectura

Esta configuración de Docker está diseñada para funcionar en las arquitecturas de procesador más comunes:
- **x86_64** (Intel/AMD, la más habitual en servidores y ordenadores de sobremesa)
- **aarch64** (ARM de 64 bits, común en Raspberry Pi 4, servidores Oracle Cloud, AWS Graviton, etc.)

No necesitas hacer nada especial; el `Dockerfile` se encargará de compilar la versión correcta para que funcione en tu sistema.

## ¿Qué necesitas antes de empezar?

Solo necesitas tener instaladas dos herramientas en tu sistema. Si no las tienes, no te preocupes, aquí tienes las guías oficiales para instalarlas:

1.  **Docker:** Es la plataforma que nos permite ejecutar aplicaciones en contenedores aislados.
    *   [Guía oficial para instalar Docker](https://docs.docker.com/engine/install/)

2.  **Docker Compose:** Es una herramienta que simplifica la gestión de aplicaciones Docker, como la nuestra.
    *   [Guía oficial para instalar Docker Compose](https://docs.docker.com/compose/install/)

## Cómo poner en marcha el servidor (paso a paso)

Sigue estos sencillos pasos para tener tu servidor funcionando en pocos minutos.

### Paso 1: Crea el archivo de configuración

Dentro del mismo directorio donde tienes los archivos de este proyecto (`Dockerfile`, `docker-compose.yml`, etc.), necesitas crear un archivo nuevo.

1.  Crea un archivo de texto vacío.
2.  Nómbralo **`.env`** (es muy importante que el nombre empiece con un punto).

Dentro de este archivo `.env`, pega el siguiente contenido:

```
# --- Configuración del Servidor Emulador ---

# El puerto que usará el emulador para aceptar conexiones.
# Puedes cambiarlo si el puerto 2460 ya está en uso en tu sistema.
EMU_PORT=2460

# El número máximo de conexiones simultáneas que permites.
EMU_MAX_CONNECTIONS=5
```

Puedes modificar los valores de `EMU_PORT` y `EMU_MAX_CONNECTIONS` según tus necesidades.

### Paso 2: ¡Arranca el servidor!

Abre una terminal o línea de comandos en el directorio del proyecto y ejecuta el siguiente comando:

```bash
docker-compose up -d --build
```

**¿Qué hace este comando?**
*   `--build`: La primera vez que lo ejecutes, construirá la "imagen" de tu servidor. Este proceso puede tardar varios minutos, ya que tiene que descargar el código fuente y compilarlo todo. ¡Solo lo hará una vez!
*   `up`: Arranca el servidor.
*   `-d`: Lo ejecuta en segundo plano, para que puedas cerrar la terminal y el servidor siga funcionando.

¡Y ya está! Tu servidor emulador está en marcha.

## Comandos útiles para gestionar el servidor

Aquí tienes algunos comandos que te serán útiles. Recuerda ejecutarlos siempre desde el directorio del proyecto.

*   **Para ver si el servidor está funcionando:**
    ```bash
    docker-compose ps
    ```
    (Deberías ver un servicio llamado `ambeserver` con el estado `running`).

*   **Para ver los logs (la salida del programa en tiempo real):**
    Esto es muy útil para ver si todo va bien o si hay algún error.
    ```bash
    docker-compose logs -f
    ```
    (Para salir, presiona `Ctrl + C`).

*   **Para detener el servidor:**
    ```bash
    docker-compose down
    ```

*   **Para volver a arrancar el servidor (una vez que ya está creado):**
    ```bash
    docker-compose up -d
    ```
