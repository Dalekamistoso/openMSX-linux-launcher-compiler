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
# Justo y previamente se verificación
#

paquetes='dialog pv unzip'
if ! dpkg -s $paquetes >/dev/null 2>&1; 
then
clear
echo ""
echo ""
echo ""
echo -e "\e[91mONE OR MORE REQUIRED DEPENDENCIES ARE MISSING - LET'S INSTALL! "
echo ""
echo -e "\e[92mTHOSE ARE TOTALLY SAFE DON'T WORRY ('DIALOG' 'PV' 'UNZIP')"
echo ""
echo -e "\e[93mBUT WE ARE GOING TO VERIFY AND REPAIR YOUR PACKAGES FOR SAFETY"
echo ""
sleep 2
sudo apt install --fix-broken 
sudo apt update --fix-missing
sleep 2
clear
echo ""
echo -e "\e[93mProcess finished, installing........"
echo ""
sudo apt install -y $paquetes
clear
echo ""
echo ""
echo ""
echo -e "\e[93mIF YOU INSTALLED CORRECTLY THE PACKAGES THE MENU WILL WORK"
echo ""
echo -e "\e[93mIF INSTALLATION WAS ABORTED OR FAILED THE MENU WILL FAIL"
echo ""
echo -e "\e[91mIF YOU ARE NOT SURE I RECOMMEND YOU TO EXIT AND START AGAIN"
echo ""
echo ""
echo ""
echo ""

# Pregunto si quieren salir (pulsando 'N' se sale y con 'S' u otra tecla sigue)

while true; do
    read -p "Start menu Y/n?" op
    case $op in
      [Yy]* ) echo -e "\e[93mContinue program. !"; break;;
      [Nn]* ) echo -e "\e[92mEnd program. !"; exit;;
          * ) echo -e "\e[93mOk, we will continue then. !"; break;;
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
BACKTITLE="openMSX & TSX Advanced Linux Mod by DrWh0 & imulilla"
TITLE="openMSX TSX Advanced Linux Mod (Mint/Ubuntu LTS/PI)" 
MENU="Select desired option and press <ENTER> to confirma:"

OPTIONS=(1 "Install updated local dependencies (18.04 or equivalent)"
         2 "Install dependencies from repositories (optional)"
         3 "Download & install openMSX TSX Advanced"
         4 "Run openMSX TSX Advanced (only if installed)"
         5 "Install DrWh0's spanish translation onto installed TSXADV"
         6 "Delete installed emulator folder, GIT data and patches"
         7 "Install system bios (if available)"
         8 "Repair broken or missing packages (advanced)"
         9 "Install dependencies, clone GIT, compile & install openMSX"
         10 "Run OFFICIAL openMSX binary (only if installed)"
         11 "Fast compile for Raspberry PI (or PC without compile report)"
         12 "Read help file"
		 13 "Exit"
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
            # Se instalarán en local TODOS los .deb de la carpeta "dependencias"
            clear
            echo ""
            echo ""
            echo ""
            echo "We are going to insall the .deb packages so I need your root password"
            echo "If you want to cancel then press CTRL+C to return......"
            echo ""
            echo ""
            echo -e "\e[93mNote: But before I will verify and repair you local packages"
			echo "I will use dpkg if still fails use option 2 from main menu before retrying" 
			echo ""
			sudo dpkg --configure -a
			echo ""
			clear
			echo -e "\e[92mVerification finished if something went wrong use option 2 before this"
			echo ""
			sleep 2
            sudo dpkg -i ./dependencias/*.deb
            dialog --infobox "Exiting from local packages installer" 3 45 ; sleep 2
            ;;
        2)
		    # Ejecuto en plan compadre el sudo para el apt desde repositorios
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[93We will try to install packages from your repositories...."
            echo -e "\e[93If you want to cancel then press CTRL+C to return......"
            echo ""
            echo ""
            sudo apt install libglew2.0 tcl8.6 libsdl2-ttf-dev libsdl2-dev pv unzip
            dialog --infobox "Exiting from remote packages installer" 3 42 ; sleep 2
            ;;
        3)              
		    # Declaro las variables 'URL' y 'URL2' con los links de descarga
            # 'URL2' es el ultimo compilado del git y los parches de traducción 
			# Se descargan con wget sobreescribiendo y con reanudación de fichero cortado
			# Se establece un timeout de 20 sg 
			
            URL="https://github.com/imulilla/openMSX_TSXadv/releases/latest/download/openMSX_TSXadv_linux_latest.tar.gz"
            URL2="https://github.com/imulilla/openMSX_TSXadv/releases/latest/download/script-tsxadv.tar.gz"
			
            # Ejecuto el wget y renombro el fichero a 'openMSX.tar.gz'
			# También genero una barra de progreso con la orden parseada por 'pv'
          
            wget -t 20 -cO openMSX.tar.gz "$URL" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Downloading OpenMSX TSX Advanced" 5 100 

            # Ahora muestro el dialogo de fin de descarga y a los 2 sg continuo
            
            dialog \--infobox "Download process finished....." 3 34 ; sleep 2

            # Procedo a descomprimir con una barra de progreso con la libreria "pv"

            (pv -n openMSX.tar.gz | tar xzf - -C ~/) 2>&1 | dialog --gauge "Uncompressing....." 6 50
            
            # Tras descomprimir, muestro otro mensaje de informacion durante 2 sg

            dialog --infobox "Uncompression finished...." 3 30 ; sleep 2

            # Tras bajar e instalar el emulador doy la opción de hacer lo mismo con el parche de traducción	
		
			dialog --title "Download spanish translation?   " \
            --backtitle "Spanish Translation and improvements by DrWh0" \
            --yesno 'Download spanish translation & menu modifications?  ' 7 60

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
               wget -t 20 -cO script-tsxadv.tar.gz "$URL2" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Downloading translation patches.." 5 100
              (pv -n script-tsxadv.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Uncompressing customizations......." 6 50
               dialog --infobox "Adjusting C-BIOS & scripts" 3 30 ; sleep 2
               dialog --infobox "Customization finished...." 3 30 ; sleep 2
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
            dialog --title "Translation patch Download......" --backtitle "Additional spanish translation files by DrWh0" \

wget -t 20 -cO script-tsxadv.tar.gz "$URL2" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Downloading spanish translation.." 5 100
            (pv -n script-tsxadv.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Uncompressing customizations........" 6 50
      dialog --infobox "Customization finished...." 3 30 ; sleep 2
            ;;
        6)  
            # Confirmo el borrado del emulador y los parches
			# Se borran las carpetas 'openMSX' (emulador) y '.openMSX' (configuraciones, roms y scripts)
			# Como puedes comprobar vuelvo a usar un minibloque de case
			
			dialog --title "Confirm deletions of files   " \
            --backtitle "Deletion of openMSX TSX Advanced Linux Mod" \
            --yesno 'Delete openMSX binaries mods and GIT files?' 7 50
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
            dialog --infobox "System bios files found...................."  3 47 ; sleep 2 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }'
              (pv -n systemroms.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Uncompressing system bios files....." 6 50
            dialog --infobox "System bios files installation completed." 3 45 ; sleep 3
			else
            dialog --infobox "Can't find file systemroms.tar.gz - Searching online......." 3 63 ; sleep 2
            dialog --infobox "Downloading openMSX roms from internet." 3 43 ; sleep 2
            wget -t 20 -cO systemroms.zip "$URL3" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Downloading system bios.." 5 100
            unzip systemroms.zip -d ~/.openMSX/share/systemroms 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Uncompressing MSX rom files" 5 100
            dialog --infobox "Roms uncompressed and installed" 3 36; sleep 2
			fi
            ;;           
        8)  
            # Intento reparar librerias o repositorios dañados
            dialog --infobox "I am going to clean cache & verify packages" 3 47 ;      sleep 2
                        clear
                        echo -e "\e[93mTrying to repair failed updates..........................."
			            echo ""
			            echo ""
                        sudo apt update --fix-missing
                        sleep 3
            dialog --infobox "I am going to repair apt packages......" 3 43 ;      sleep 2
                        clear
                        echo -e "\e[93mTrying to repair damaged packages from your system"                    
                        sudo apt install --fix-broken
                        echo ""
                        echo ""
                        echo -e "\e[93mIf something failed try repair options again"
                        sleep 3
            dialog --infobox "Returning to main menu of the program.." 3 43 ;      sleep 2
            ;;
        9)  
            # Instalo git compiladores por si acaso y clono el repositorio oficial
                        dialog --infobox "Installing GIT & dependencies. If you are asked to overwrite MORE RECENT packages say NO (press <ENTER>). OTHERWISE YOU CAN POTENTIALLY BREAK YOUR OS........" 6 52 ; sleep 3
                        clear
                        echo ""
                        echo ""                      
                        echo -e "\e[93mWe are going to install GIT packages, compilers and needed dependencies"
                        echo -e "\e[93mIF YOU ARE ASKED TO OVERWRITE A MORE RECENT VERSION OF PREVIOUSLY INTALLED"
                        echo -e "\e[93m PACKAGE, CHOOSE ALWAYS 'NO' UNLESS THAT YOU KNOW WHAT YOU ARE DOING!"
                        echo ""
                        echo -e "\e[92mIf you want to cancel the process press CTRL+C right now!"
                        echo ""
                        echo ""                      
                        echo -e "\e[93mInstalling packages..........."
                        echo ""
                        echo ""                      
                        sudo apt install git gcc make g++ libfreetype6-dev libglew-dev libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev tcl-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev
                        echo ""
                        echo ""
                        echo -e "\e[93mIf something went wrong use repair options at main menu and repeat the process"
                        echo ""
                        echo ""
                        sleep 3
                        clear

            # Aqui me pongo a realizar un git clone del repositorio (va a tardar un buen rato)"
            # la orden original del manual de compilado es git clone https://github.com/openMSX/openMSX.git openMSX

                        git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
                        sleep 3
                        cd "fuentes-openMSX"
                        clear
                        dialog --infobox "GIT cloned - Checking process started" 3 43 ; sleep 2
                        clear 
                        echo -e "\e[93mVerifying dependencies......."
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
                 dialog  --textbox resultado.txt 20 80
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
            # Ejecuto funciones de raspberry pi
            # Instalo git compiladores por si acaso y clono el repositorio oficial

                        dialog --infobox "Installing GIT & dependencies. If you are asked to overwrite MORE RECENT packages say NO (press <ENTER>). OTHERWISE YOU CAN POTENTIALLY BREAK YOUR OS........" 6 52 ; sleep 3
                        clear
                        echo ""
                        echo ""                      
                        echo -e "\e[93mWe are going to install GIT packages, compilers and needed dependencies"
                        echo -e "\e[93mIF YOU ARE ASKED TO OVERWRITE A MORE RECENT VERSION OF PREVIOUSLY INTALLED"
                        echo -e "\e[93m PACKAGE, CHOOSE ALWAYS 'NO' UNLESS THAT YOU KNOW WHAT YOU ARE DOING!"
                        echo ""
                        echo -e "\e[92mIf you want to cancel the process press CTRL+C right now!"
                        echo ""
                        echo ""                      
                        echo -e "\e[93mInstalling packages..........."
                        echo ""
                        echo ""                      
                        sudo apt install git gcc make g++ libfreetype6-dev libglew-dev libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev tcl-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev
                        echo ""
                        echo ""
                        echo -e "\e[93mIf something went wrong use repair options at main menu and repeat the process"
                        echo ""
                        echo ""
                        sleep 3
                        clear

            # Aqui me pongo a realizar un git clone del repositorio (va a tardar un buen rato)"
            # la orden original del manual de compilado es git clone https://github.com/openMSX/openMSX.git openMSX

                        git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
                        sleep 3
                        cd "fuentes-openMSX"
                        clear
                        dialog --infobox "GIT cloned - Checking process started" 3 43 ; sleep 2
                        clear 
                        echo -e "\e[93mVerifying dependencies......."
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
                 sudo make install
                 dialog --infobox "Finished, returning to main menu...." 3 43 ; sleep 2
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
         12)  
            # Lista el fichero de ayuda
            
			dialog  --textbox README-ENGLISH 20 80
			clear
            ;;

        13) 
            # Rehabilito el uso de CTRL+C y salgo del programa tras mostrar una pantalla de agradecimiento

            trap 2 
            dialog --infobox "Exiting - Thanks for using my program" 3 42;      sleep 2
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







