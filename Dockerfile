# Dockerfile para ambeserver (Versión Funcional)

# Usar Ubuntu 22.04 como imagen base.
# Para aarch64, es posible que desee utilizar arm64v8/ubuntu:22.04
FROM ubuntu:22.04

# Establecer DEBIAN_FRONTEND como no interactivo para evitar avisos durante la instalación de apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Definir variables para la versión de Python y los directorios
ENV PYTHON2_VERSION="2.7.18"
ENV PYTHON2_INSTALL_DIR="/opt/python2"
ENV EMU_DIR="/opt/md380-emu"

# Instalar todas las dependencias de sistema y de compilación requeridas en una sola capa
# Esto incluye las dependencias para el emulador y para compilar Python 2 desde el código fuente
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Dependencias del emulador
    gcc \
    make \
    git \
    gcc-arm-linux-gnueabihf \
    qemu-user \
    qemu-user-static \
    binfmt-support \
    wget \
    tar \
    # Dependencias de compilación de Python 2
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libbz2-dev \
    liblzma-dev \
    tk-dev \
    uuid-dev && \
    # Limpiar la caché de apt para reducir el tamaño de la imagen
    rm -rf /var/lib/apt/lists/*

# Descargar, compilar e instalar Python 2.7.18 desde el código fuente
RUN cd /tmp && \
    wget "https://www.python.org/ftp/python/$PYTHON2_VERSION/Python-$PYTHON2_VERSION.tgz" && \
    tar xzf "Python-$PYTHON2_VERSION.tgz" && \
    cd "Python-$PYTHON2_VERSION" && \
    ./configure --prefix="$PYTHON2_INSTALL_DIR" && \
    make -j"$(nproc)" && \
    make install && \
    ln -s "$PYTHON2_INSTALL_DIR/bin/python2.7" /usr/local/bin/python2 && \
    # Limpiar los archivos descargados y extraídos
    rm -rf /tmp/*

# Clonar el repositorio md380tools, compilar el emulador y limpiar
RUN git clone https://gitlab.com/hp3icc/md380tools.git "$EMU_DIR" && \
    cd "$EMU_DIR/emulator" && \
    make

# Puerto y conexiones por defecto. Se pueden anular en docker-compose.yml
ENV EMU_PORT 2460
ENV EMU_MAX_CONNECTIONS 5

# Establecer el directorio de trabajo para el emulador
WORKDIR ${EMU_DIR}/emulator

# Exponer el puerto
EXPOSE ${EMU_PORT}

# El comando para ejecutar el emulador.
# Utiliza variables de entorno para el puerto y las conexiones, permitiendo una configuración fácil.
CMD ["/usr/bin/qemu-arm", "./md380-emu", "-d", "-e", "-s", "${EMU_PORT}", "-m", "${EMU_MAX_CONNECTIONS}"]
