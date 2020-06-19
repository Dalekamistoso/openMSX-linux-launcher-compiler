#!/bin/bash 

# Bloqueo el uso de CTRL+C para interrumpir la ejecución inesperadamente

trap '' 2


# RUTINA DESACTIVADA PARA USOS FUTUROS (VERIFICA SI ESTAS EJECUTANDO COMO ROOT)
# ES BASICAMENTE UNA ALTERNATIVA PARA VAGOS Y NO ESPECIFICAR NADA DENTRO DEL SCRIPT
# SI NO ES EJECUTADO EN MODO ROOT SE NIEGA A ARRANCAR
#
# if [[ "$(id -u)" -ne 0 ]]; then
#     echo "Este Script requiere permisos de root (sudo). O sea 'sudo $0'"
#     exit 1
# fi

#############################################################
# INICIO DE BLOQUE DE PROTECCION PARA PODER INICIAR EL MENU #
#############################################################

# Aqui verifico que tengas pv y dialog instalados como no los tengas los instala
# Si no se instalan, el menú fallará porque se basa en ambos paquetes para funcionar
# La variable "paquetes" indica que librerias se necesitan

paquetes='dialog pv unzip'
if ! rpm -q $paquetes >/dev/null 2>&1; 
then
clear
echo ""
echo ""
echo ""
echo -e "\e[91mFALTAN UNO O VARIOS PAQUETES IMPRESCINDIBLES - VAMOS A INSTALARLOS"
echo ""
echo -e "\e[92mSON TOTALMENTE SEGUROS NO TE PREOCUPES (SON 'DIALOG' 'PV' 'UNZIP')"
echo ""
echo ""
sleep 2
sudo dnf install -y $paquetes
clear
echo ""
echo ""
echo ""
echo -e "\e[93mSI HAS INSTALADO CORRECTAMENTE LOS FICHEROS EL MENU FUNCIONARA"
echo ""
echo -e "\e[93mSI HAS ABORTADO O FALLADO LA INSTALACION EL MENU FALLARA......."
echo ""
echo -e "\e[91mSI NO ESTAS SEGURO RECOMIENDO SALIR E INICIAR"
echo ""
echo ""
echo ""
echo ""

# Pregunto si quieren salir (pulsando 'N' se sale y con 'S' u otra tecla sigue)

while true; do
    read -p "¿Desea arrancar el menú S/n?" op
    case $op in
      [Ss]* ) echo -e "\e[93mContinuamos la Ejecución. !"; break;;
      [Nn]* ) echo -e "\e[92mFinalizamos la Ejecución. !"; exit;;
          * ) echo -e "\e[92mContinuamos la Ejecución. !"; break;;
    esac
done
         

fi # final del if de las dependencias iniciales

#############################################################
#  FIN DEL BLOQUE DE PROTECCION PARA PODER INICIAR EL MENU  #
#############################################################



#############################################################
#            INICIO DE BLOQUE DEL MENU PRINCIPAL            #
#############################################################


# Sí, se que está repetido pero es por modularidad para uso en otros scripts

while true
do

# Aqui defino los tamaños y propiedades del menú inicial (LO QUE SE VE)

HEIGHT=19
WIDTH=70
CHOICE_HEIGHT=15
BACKTITLE="openMSX & TSX Advanced Linux Mod por DrWh0 & imulilla"
TITLE="openMSX & TSX Advanced Linux Mod (Menú Fedora)" 
MENU="Seleccione la opción deseada y pulsa <ENTER> para confirmar:"

OPTIONS=(1 "Instalar dependencias locales actualizadas (Fedora 30)"
         2 "Instalar dependencias desde repositorios (Fedora 31)"
         3 "Descargar openMSX TSX Advanced e instalar"
         4 "Ejecutar openMSX TSX Advanced"
         5 "Instalar mod de traducción sobre openMSX TSXADVanced"
         6 "Borrar openMSX TSX ADV, parches y GIT oficial de openMSX"
         7 "Instalar bios de sistema (si están presentes)"
         8 "Reparar librerias dañadas o faltantes (avanzado)"
         9 "Instalar dependencias, GIT y compilar e instalar openMSX"
         10 "Ejecutar binario OFICIAL de openMSX (compilado/instalado)"
         11 "Lanzar menú de openMSX para Raspberry PI (y Mint/Ubuntu)"
         12 "Consultar fichero de ayuda"
         13 "Salir"
)

# Defino los atributos de la variable choice para simplificar los procesos del case
# Limpio pantalla y procedo con los case que definen las acciones a ejecutar


CHOICE=$(dialog --clear \
                --nocancel \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

case $CHOICE in
        1)
            # Se instalarán en local TODOS los .RPM de la carpeta "dependencias"
            clear
            echo ""
            echo ""
            echo ""
            echo "Vamos a instalar los paquetes .rpm para ello necesito tu pass de root"
            echo "Si quieres cancelar el proceso pulsa CTRL+C para volver al menú......"
            echo ""
            echo ""
            echo ""
            sudo dnf localinstall ./dependencias-fedora/*.rpm
            dialog --infobox "Saliendo del instalador de paquetes local" 3 45 ; sleep 2
            ;;
        2)
		    # Ejecuto en plan compadre el sudo para el dnf desde repositorios
            clear
            echo ""
            echo ""
            echo ""
            echo "Vamos a instalar los paquetes desde tus repositorios de red...."
            echo "Si quieres cancelar el proceso pulsa CTRL+C para volver al menú"
            echo ""
            echo ""
            echo ""
            sudo dnf install libGLEW tcl SDL2 SDL2_ttf
            dialog --infobox "Saliendo del instalador de repositorio" 3 42 ; sleep 2
            ;;
        3)              
		    # Declaro las variables 'URL' y 'URL2' con los links de descarga
            # 'URL2' es el ultimo compilado del git y los parches de traducción 
			# Se descargan con wget sobreescribiendo y con reanudación de fichero cortado
			# Se establece un timeout de 20 sg 
			
            URL="https://github.com/imulilla/openMSX_TSXadv/releases/latest/download/openMSX_TSXadv_linux_latest.tar.gz"
            URL2="https://www.dropbox.com/s/fv2lbz0k5wppnbk/script-tsxadv.tar.gz?dl=0"
			
            # Ejecuto el wget y renombro el fichero a 'openMSX.tar.gz'
			# También genero una barra de progreso con la orden parseada por 'pv'
          
            wget -t 20 -cO openMSX.tar.gz "$URL" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando OpenMSX TSX Advanced" 5 100 

            # Ahora muestro el dialogo de fin de descarga y a los 2 sg continuo
            
            dialog \--infobox "Descarga de archivos terminada" 3 34 ; sleep 2

            # Procedo a descomprimir con una barra de progreso con la libreria "pv"

            (pv -n openMSX.tar.gz | tar xzf - -C ~/) 2>&1 | dialog --gauge "Descomprimiendo..." 6 50
            
            # Tras descomprimir, muestro otro mensaje de informacion durante 2 sg

            dialog --infobox "Descompresión finalizada.." 3 30 ; sleep 2

            # Tras bajar e instalar el emulador doy la opción de hacer lo mismo con el parche de traducción	
		
			dialog --title "Descarga de parche de traducción" \
            --backtitle "Parche adicional de traducción y mejoras de DrWh0" \
            --yesno '¿Deseas descargar el parche de la traducción a español?' 7 60

            # Aqui verifico el resultado del codigo de estado de yesno
            # 0 indica que pinchaste en [si].
            # 1 indica que pinchaste en [no].
            # 255 indica que pinchaste en [Esc].
            # Esta rutina la empleo más adelante para confirmar el borrado de lo instalado
			# Lo hago modularmente en vez de crear una función para permitir su uso externamente
			# a modo educativo
			
############################################################################
# COMIENZO MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR DESCARGA ADICIONAL #
############################################################################
			
            response=$?
            case $response in
            0) URL2="https://www.dropbox.com/s/fv2lbz0k5wppnbk/script-tsxadv.tar.gz?dl=0"
               wget -t 20 -cO script-tsxadv.tar.gz "$URL2" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando parches de traducción" 5 100
              (pv -n script-tsxadv.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Descomprimiendo personalizaciones..." 6 50
               dialog --infobox "Ajustando C-BIOS y scripts" 3 30 ; sleep 2
               dialog --infobox "Personalización finalizada" 3 30 ; sleep 2
               ;;
            1) ;;
            255) ;;
            esac
            ;;
			
############################################################################
# FINAL DE MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR DESCARGA ADICIONAL #
############################################################################
        4)
		    # Limpio pantalla y ejecuto el openmsx en la ruta predeterminada
            
			clear
            chmod +x ~/openMSX/openmsx
            ~/openMSX/openmsx
            ;;
        5)  
            # Rutina para aplicar el parche de traducción sobre el openMSX TSX Advanced
			# en el caso de que no hubiera instalado la misma (es decir, dejandolo en inglés)
			URL2="https://github.com/imulilla/openMSX_TSXadv/releases/latest/download/script-tsxadv.tar.gz"
			dialog --title "Descarga de parche de traducción" --backtitle "Parche adicional de traducción y mejoras de DrWh0" \

wget -t 20 -cO script-tsxadv.tar.gz "$URL2" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando parches de traducción" 5 100
      (pv -n script-tsxadv.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Descomprimiendo personalizaciones..." 6 50
      dialog --infobox "Personalización finalizada" 3 30 ; sleep 2
            ;;
        6)  
            # Confirmo el borrado del emulador y los parches
			# Se borran las carpetas 'openMSX' (emulador) y '.openMSX' (configuraciones, roms y scripts)
			# Como puedes comprobar vuelvo a usar un minibloque de case
			
			dialog --title "Confirmar borrado de archivos" \
            --backtitle "Eliminación de openMSX TSX Advanced Linux Mod" \
            --yesno '¿Borrar los archivos GIT openMSX de perfil?' 7 50
            response=$?
            case $response in
            0) sudo rm -Rf ~/openMSX | rm -Rf ~/.openMSX | rm -Rf ./fuentes-openMSX
            ;;
            1) ;;
            255) ;;
            esac
            ;;
        7)  
            # Verifico que esté el fichero con las roms "systemroms.tar.gz"
			# Si no está el archivo avisa con 2 mensajes y vuelve
            # Si está presente descomprime de forma gráfica con mensajes antes y despues de descomprimir y vuelve
            URL3="http://www.msxarchive.nl/pub/msx/emulator/openMSX/systemroms.zip"
			if [ -f "systemroms.tar.gz" ];
            then
            dialog --infobox "Archivo de roms de sistema encontrado......"  3 47 ; sleep 2 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }'
              (pv -n systemroms.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Descomprimiendo roms de sistema....." 6 50
            dialog --infobox "Instalación de roms de sistema finalizada" 3 45 ; sleep 3
			else
            dialog --infobox "No encuentro el fichero systemroms.tar.gz - Buscando online" 3 63 ; sleep 2
            dialog --infobox "Descargando openMSX roms de internet..." 3 43 ; sleep 2
            wget -t 20 -cO systemroms.zip "$URL3" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando bios del sistema" 5 100
            unzip systemroms.zip -d ~/.openMSX/share/systemroms 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descomprimiendo roms de MSX" 5 100
            dialog --infobox "Roms descomprimidas e instaladas (con suerte XD)" 3 52 ; sleep 2
			fi
            ;;           
            8)  
            # Intento reparar librerias o repositorios dañados
            dialog --infobox "Voy a limpiar la cache y verificar paquetes" 3 47 ;      sleep 2
                        clear
                        echo "Voy a limpiar la cache y verificar tus paquetes"
                        echo ""
                        echo ""
                        sudo dnf clean all
                        sudo dnf check
                        sleep 3
            dialog --infobox "Voy a intentar actualizar todos los paquetes" 3 48 ;      sleep 2
                        clear
                        echo "Voy a intentar reactualizar los paquetes dañados de tu sistema"
                        echo ""
                        echo ""						
                        sudo dnf update
                        echo ""
                        echo ""
                        echo "Si ha fallado algo emplea las opciones de reparación de nuevo"
                        sleep 3
            dialog --infobox "Volviendo al menu principal............" 3 43 ;      sleep 2
            ;;
            9)  
            # Instalo git compiladores por si acaso y clono el repositorio oficial
            dialog --infobox "Voy a instalar GIT y las dependencias. Si se te pregunta si sobreescribir librerias mas modernas preinstaladas di siempre que no (pulsa <ENTER>). PUES PUEDES ROMPER TU SISTEMA OPERATIVO........" 6 52 ; sleep 3
                        clear
                        echo ""
                        echo ""                      
                        echo -e "\e[93mVoy a instalar los paquetes del sistema git, compilador y las dependencias"
                        echo -e "\e[93mSI SE TE PREGUNTA SI QUIERES SOBREESCRIBIR PAQUETES MAS MODERNOS YA INSTALADOS"
                        echo -e "\e[93m¡¡ DI SIEMPRE 'NO' A MENOS QUE SEPAS LO QUE HACES !!"
                        echo ""
                        echo -e "\e[92mSi quieres cancelar el proceso pulsa CTRL+C para volver al menú"
                        echo ""
                        echo ""                      
                        echo -e "\e[93mInstalando paquetes..........."
                        echo ""
                        echo ""              
                        sudo dnf install git gcc make g++ freetype-devel glew-devel libao-devel libogg-devel libpng-devel liboggz-devel libtheora-devel libxml2-devel libvorbis-devel tcl-devel SDL2-devel SDL2_ttf-devel SDL2_gfx-devel alsa-lib-devel
                        echo ""
                        echo ""
                        echo -e "\e[93mSi ha fallado algo emplea las opciones de reparación"
                        echo "" 
                        echo ""
                        sleep 3
                        clear

            # Aqui me pongo a realizar un git clone del repositorio (va a tardar un buen rato)"
            # la orden original del manual de compilado es git clone https://github.com/openMSX/openMSX.git openMSX

                        git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
                        sleep 3
                        clear
                        echo ""
                        cd "fuentes-openMSX"
                        dialog --infobox "GIT clonado - Verificación iniciada.." 3 43 ; sleep 2
                        clear 
                        echo -e "\e[93mVerificando dependencias......."
                        echo ""
                        ./configure >result-check.txt

            # Muestro el contenido del resultado de verificar dependencias

                        dialog  --textbox result-check.txt 20 80
                        clear

            # Tras bajar e instalar git doy la opcion si compilar o no
		    
            clear
			dialog --title "Compile downloaded source code? " \
            --backtitle "Compilation and installation menu" \
            --yesno 'Compile downloaded source code from GIT repository? ' 7 60

            # Aqui verifico el resultado del codigo de estado de yesno
            # 0 indica que pinchaste en [si].
            # 1 indica que pinchaste en [no].
            # 255 indica que pinchaste en [Esc].
            # Esta rutina la empleo más adelante para confirmar el borrado de lo instalado
			# Lo hago modularmente en vez de crear una función para permitir su uso externamente
			# a modo educativo
			
############################################################################
#     COMIENZO MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR COMPILACION    #
############################################################################
			
            response2=$?
            case $response2 in
            0)         
                 cd "fuentes-openMSX"						
                 clear
                 dialog --infobox "Proceeding to source code compilation in 2 seconds.." 3 43 ; sleep 2
                 clear
                 echo -e "\e[93mCompilating (it will take a long time, be patient)"
                 echo ""
                 sudo make install > resultado.txt
                 dialog --textbox resultado.txt 20 80
                 dialog --infobox "Returning to main menu.............." 3 43 ; sleep 2
                 cd ..
                 ;;
            1)   
                 dialog --infobox "Returning to main menu.............." 3 43 ; sleep 2
                 cd ..
                 ;;
            255) 
                 dialog --infobox "Returning to main menu.............." 3 43 ; sleep 2
                 cd ..
                 ;;
            esac
            ;;

############################################################################
#    FINAL DE MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR COMPILACION     #
############################################################################			     

        10)  
            # Ejecuto el programa compilado para ver que todo este OK
            openmsx
			;;


        11)  
            # Llamo al script de raspberry pi

            ./lanzador-mint-spanish.sh
            ;;
        12)  
            # Lista el fichero de ayuda
            
			dialog  --textbox README-SPANISH 20 80
            ;;  
	   13)  
            # Rehabilito el uso de CTRL+C y salgo del programa tras mostrar una pantalla de agradecimiento

            trap 2 
            dialog --infobox "Saliendo - Gracias por usar mi programa" 3 43 ;      sleep 2
            clear
            exit
            ;;
esac
done


#############################################################
#             FINAL DE BLOQUE DEL MENU PRINCIPAL            #
#############################################################


############################################################################
#              CODIGO DE PRUEBAS PARA FUTURAS FUNCIONALIDADES              #
############################################################################

# Aquí abajo especifico algunas ideas para mejorar la funcionalidad:

############################################################################
#   CREACION DE ACCESOS DIRECTOS AL SCRIPT DESDE GNOME/CINNAMON/KDE/XFCE   #
############################################################################

# Mas codigo viejo (accesos directos)
# Basicamente es copiar un .desktop hecho para la ocasión y un infodialog
# sudo cp *.desktop /usr/share/applications/ <---Pendiente de ruta y archivo
# dialog --infobox "Acceso directo creado" 3 25 ; sleep 2

############################################################################
#              CAPTURA DE ERRORES EN LA DESCARGA DE LOS ARCHIVOS           #
############################################################################

# Tengo pendiente de implementar captura de excepciones para wget
# Tengo pensado o interceptar el HTTP Response Code (404/200) algo como:
# wget --server-response -q -o wgetOut $URL y pillar el _wgetHttpCode
#
# O bien hacer guarrerias al estilo de:
# if wget -q "$URL" > /dev/null; then loquesea
# 
# Si veo que este script tiene aceptación tengo pensado ampliar mucho sus 
# funcionalidades y portar más adelante a un frontend "potito" en GTK
# Pero si al final solo lo bajan 4 gatos pues no tiene mucho sentido


