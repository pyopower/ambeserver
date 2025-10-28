# Usa una imagen base ligera que tenga las herramientas necesarias para compilar (build-essential, git, cmake)
# Utilizamos Debian Bullseye, una base estable con soporte ARM64.
FROM debian:bullseye-slim

# Instala dependencias de compilación y runtime (SoX para potencial conversión de audio)
RUN apt update && \
    apt install -y \
    build-essential \
    git \
    cmake \
    libtool \
    sox \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Directorio de trabajo
WORKDIR /usr/src/dmrbeacon

# === 1. Compilar y instalar mbelib ===
RUN git clone https://github.com/n7tae/mbelib.git mbelib_source && \
    cd mbelib_source && \
    cmake . && \
    make && \
    make install && \
    cd .. && \
    rm -rf mbelib_source

# === 2. Compilar e instalar DMRBeacon ===
RUN git clone https://github.com/n7tae/DMRBeacon.git dmrbeacon_source && \
    cd dmrbeacon_source && \
    cmake . && \
    make && \
    make install && \
    cd .. && \
    rm -rf dmrbeacon_source

# Limpieza final para reducir el tamaño de la imagen
RUN apt remove -y build-essential git cmake libtool && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Expone el puerto local (definido como 54005 en hblink.cfg)
EXPOSE 54005

# Define un punto de entrada para que el contenedor ejecute el binario
# El comando de ejecución completo (con todos los parámetros) se definirá en Docker Compose
ENTRYPOINT ["/usr/local/bin/dmrbeacon"]