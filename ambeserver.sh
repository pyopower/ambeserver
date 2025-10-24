#!/bin/bash

# Este script instala el emulador md380tools en Ubuntu Server 22.04+ (aarch64)
# y proporciona un menu interactivo para su configuracion y control.

# --- Variables y configuracion ---

REQUIRED_PKGS=(
    "gcc"
    "make"
    "git"
    "gcc-arm-linux-gnueabihf"
    "qemu-user"
    "qemu-user-static"
    "binfmt-support"
    "wget"
    "tar"
)

# Dependencias para compilar Python 2
PYTHON2_DEPS=(
    "build-essential"
    "libssl-dev"
    "zlib1g-dev"
    "libncurses5-dev"
    "libncursesw5-dev"
    "libreadline-dev"
    "libsqlite3-dev"
    "libgdbm-dev"
    "libbz2-dev"
    "liblzma-dev"
    "tk-dev"
    "uuid-dev"
)

EMU_DIR="/opt/md380-emu"
SERVICE_FILE="/lib/systemd/system/emu-ambe.service"
PYTHON2_VERSION="2.7.18"
PYTHON2_INSTALL_DIR="/opt/python2"

# Valores por defecto del servicio
DEFAULT_PORT=2460
DEFAULT_CONNECTIONS=5

# --- Funciones ---

function log_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

function log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

function check_pkg_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

function install_dependencies() {
    log_info "Verificando e instalando dependencias del sistema..."
    for pkg in "${REQUIRED_PKGS[@]}"; do
        if ! check_pkg_installed "$pkg"; then
            log_info "Instalando $pkg..."
            sudo apt update
            sudo apt install -y "$pkg" || {
                log_error "Falló la instalacion de $pkg. Abortando."
                exit 1
            }
        fi
    done
}

function install_python2() {
    log_info "Verificando e instalando Python 2.7.18 desde el codigo fuente..."
    if ! command -v python2 &> /dev/null; then
        log_info "Python2 no esta disponible. Procediendo con la instalacion..."

        log_info "Instalando dependencias de compilacion de Python..."
        for pkg in "${PYTHON2_DEPS[@]}"; do
            if ! check_pkg_installed "$pkg"; then
                sudo apt install -y "$pkg" || {
                    log_error "Falló la instalacion de las dependencias de Python 2. Abortando."
                    exit 1
                }
            fi
        done

        cd /tmp || exit 1
        sudo wget "https://www.python.org/ftp/python/$PYTHON2_VERSION/Python-$PYTHON2_VERSION.tgz" || {
            log_error "Falló la descarga de Python 2. Abortando."
            exit 1
        }
        sudo tar xzf "Python-$PYTHON2_VERSION.tgz" || {
            log_error "Falló la descompresion del archivo de Python 2. Abortando."
            exit 1
        }
        cd "Python-$PYTHON2_VERSION" || exit 1
        sudo ./configure --prefix="$PYTHON2_INSTALL_DIR" || {
            log_error "Falló la configuracion de Python 2. Abortando."
            exit 1
        }
        sudo make -j"$(nproc)" || {
            log_error "Falló la compilacion de Python 2. Abortando."
            exit 1
        }
        sudo make install || {
            log_error "Falló la instalacion de Python 2. Abortando."
            exit 1
        }

        sudo ln -s "$PYTHON2_INSTALL_DIR/bin/python2.7" /usr/local/bin/python2
        log_info "Python 2.7.18 instalado y disponible como 'python2'."
    else
        log_info "Python 2 ya esta instalado."
    fi
}

function compile_and_setup() {
    log_info "Configurando el directorio del emulador..."
    if [ -d "$EMU_DIR" ]; then
        log_info "Directorio $EMU_DIR ya existe. Deteniendo el servicio y limpiando..."
        (systemctl is-active emu-ambe.service --quiet || systemctl is-enabled emu-ambe.service --quiet) && sudo systemctl stop emu-ambe.service
        sudo rm -r "$EMU_DIR"
    fi

    log_info "Clonando el repositorio de md380tools..."
    sudo git clone https://gitlab.com/hp3icc/md380tools.git "$EMU_DIR" || {
        log_error "Falló la clonacion del repositorio. Verifica la conexion a Internet."
        return 1
    }

    log_info "Compilando el emulador..."
    cd "$EMU_DIR/emulator" || {
        log_error "No se pudo cambiar al directorio del emulador."
        return 1
    }

    make || {
        log_error "Falló la compilacion del emulador. Revisa el log de errores."
        return 1
    }
    log_info "Compilacion exitosa."

    create_systemd_service $DEFAULT_PORT $DEFAULT_CONNECTIONS
    log_info "La instalacion ha finalizado."
    return 0
}

function create_systemd_service() {
    PORT=$1
    CONNECTIONS=$2
    cat > "$SERVICE_FILE" <<- EOF
[Unit]
Description=Emulator AMBE3000
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=3
StandardOutput=null
WorkingDirectory=/opt/md380-emu/emulator
ExecStart=/usr/bin/qemu-arm /opt/md380-emu/emulator/md380-emu -d -e -s $PORT -m $CONNECTIONS

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
}

function show_main_menu() {
    while true; do
        clear
        log_info "--- Menu de gestion del emulador AMBE3000 ---"
        echo ""
        echo "1) Iniciar el servicio"
        echo "2) Detener el servicio"
        echo "3) Ver el estado del servicio"
        echo "4) Configurar puerto y numero de conexiones"
        echo "5) Habilitar/Deshabilitar el inicio automatico"
        echo "6) Salir"
        echo ""
        read -p "Elige una opcion: " option

        case $option in
            1)
                sudo systemctl start emu-ambe.service
                log_info "Comando de inicio del servicio enviado."
                read -p "Presiona Enter para continuar..."
                ;;
            2)
                sudo systemctl stop emu-ambe.service
                log_info "Comando de parada del servicio enviado."
                read -p "Presiona Enter para continuar..."
                ;;
            3)
                log_info "Mostrando el estado del servicio..."
                sudo systemctl status emu-ambe.service --no-pager
                read -p "Presiona Enter para continuar..."
                ;;
            4)
                log_info "Configurando puerto y conexiones."
                read -p "Introduce el nuevo puerto (ej. 2460): " new_port
                read -p "Introduce el maximo de conexiones (ej. 5): " new_connections
                if [[ $new_port =~ ^[0-9]+$ ]] && [[ $new_connections =~ ^[0-9]+$ ]]; then
                    create_systemd_service $new_port $new_connections
                    log_info "Configuracion actualizada. Reiniciando el servicio..."
                    sudo systemctl restart emu-ambe.service
                else
                    log_error "Valores invalidos. Por favor, introduce solo numeros."
                fi
                read -p "Presiona Enter para continuar..."
                ;;
            5)
                log_info "Habilitando/Deshabilitando inicio automatico."
                read -p "Deseas que el servicio se inicie automaticamente al arrancar el servidor? (s/n): " auto_start
                if [[ "$auto_start" =~ ^[sS]$ ]]; then
                    sudo systemctl enable emu-ambe.service
                    log_info "Inicio automatico habilitado."
                else
                    sudo systemctl disable emu-ambe.service
                    log_info "Inicio automatico deshabilitado."
                fi
                read -p "Presiona Enter para continuar..."
                ;;
            6)
                log_info "Saliendo del menu."
                break
                ;;
            *)
                log_error "Opcion invalida. Por favor, elige una opcion valida."
                read -p "Presiona Enter para continuar..."
                ;;
        esac
    done
}

# --- Flujo principal del script ---

install_dependencies
install_python2

# Verificamos si el emulador ya esta compilado
if [ ! -f "$EMU_DIR/emulator/md380-emu" ]; then
    compile_and_setup
    if [ $? -ne 0 ]; then
        log_error "La instalacion falló. Revisa los errores."
        exit 1
    fi
else
    log_info "El emulador ya está instalado. Iniciando el menu de gestion..."
fi

show_main_menu
