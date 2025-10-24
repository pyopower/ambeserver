# Servidor Emulador AMBE (ambeserver)

Este proyecto te permite ejecutar el emulador `md380-emu` de una manera muy sencilla, utilizando Docker. Esto significa que no tienes que preocuparte por instalar dependencias o compilar programas manualmente en tu servidor. Todo está empaquetado y listo para usar.

### Compatibilidad Multi-Arquitectura

Esta configuración de Docker está diseñada para funcionar en las arquitecturas de procesador más comunes:
- **x86_64** (Intel/AMD, la más habitual en servidores y ordenadores de sobremesa)
- **aarch64** (ARM de 64 bits, común en Raspberry Pi 4, servidores Oracle Cloud, AWS Graviton, etc.)

No necesitas hacer nada especial; el `Dockerfile` se encargará de compilar la versión correcta para que funcione en tu sistema.

## ¿Qué necesitas antes de empezar?

Solo necesitas tener instaladas tres herramientas en tu sistema. Si no las tienes, no te preocupes, aquí tienes las guías oficiales para instalarlas:

1.  **Git:** Para descargar el código de este repositorio.
    *   [Guía oficial para instalar Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2.  **Docker:** La plataforma que ejecuta el servidor en un contenedor.
    *   [Guía oficial para instalar Docker](https://docs.docker.com/engine/install/)
3.  **Docker Compose:** Una herramienta que simplifica el manejo de Docker.
    *   [Guía oficial para instalar Docker Compose](https://docs.docker.com/compose/install/)

## Cómo poner en marcha el servidor (paso a paso)

Sigue estos sencillos pasos para tener tu servidor funcionando en pocos minutos.

### Paso 1: Descarga el código

Abre una terminal y ejecuta el siguiente comando para descargar (clonar) este repositorio en tu máquina:
```bash
git clone https://github.com/pyopower/ambeserver.git
```
Luego, entra en el directorio que se acaba de crear:
```bash
cd ambeserver
```

### Paso 2: Configura tu servidor

El repositorio incluye un archivo de configuración de ejemplo llamado `.env.example`. Solo tienes que hacer una copia de él.

Ejecuta el siguiente comando en la terminal:
```bash
cp .env.example .env
```
Esto crea tu archivo de configuración personal `.env` con los valores por defecto. Si quieres, puedes editar este archivo para cambiar el puerto o el número de conexiones.

### Paso 3: ¡Arranca el servidor!

Ahora que ya estás en el directorio del proyecto y tienes tu archivo `.env` creado, solo tienes que ejecutar este comando:

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
