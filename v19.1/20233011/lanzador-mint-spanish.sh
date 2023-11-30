#!/bin/bash 

#############################################################
#                                                           #
#                                                           #
# LANZADOR LINUX PARA OPENMSX Y OPENMSX TSXADVANCED         #
# =================================================         #
#                                                           #
# FUNCIONES INCLUIDAS:                                      #
#                                                           #
#  1.- COMPILA E INSTALA EJECUTABLE DESDE EL GIT ACTUAL     #
#                                                           #
#  2.- REPARA SISTEMA DE PAQUETES EN CASO DE SER NECESARIO  #
#                                                           #
#  3.- INICIA EL EJECUTABLE DE OPENMSX DESDE EL MENU        #
#                                                           #
#  4.- INSTALA ROMS DESDE UN ARCHIVO LOCAL AUTOMATICAMENTE  #
#                                                           #
#  5.- DESCARGA/INSTALA EL ROMSET COMPLETO DESDE INTERNET   #
#                                                           #
#  6.- DESINSTALA Y LIMPIA OPENMSX Y SUS REPOS DEL SISTEMA  #
#                                                           #
#  7.- SOPORTE DE OPENMSX Y OPENMSX TSX ADVANCED EDITION    #
#                                                           #
#  8.- SOPORTA FEDORA Y MINT/UBUNTU/DEBIAN LTS x64 y ARM    #
#                                                           #
#                                                           #
# AUTORES:                                                  #
# ========                                                  #
#                                                           #
# SCRIPT: Carlos Romero (DrWh0/Dalekamistoso)               #
#                                                           #
# OPENMSX: OPENMSX TEAM                                     #
#                                                           #
# OPENMSX TSX: NATALIAPC & TSX TEAM                         #
#                                                           #
# OPENMSX TSX ADVANCED: Israel Mula (imulilla)              #
#                                                           #
#                                                           #
# CONTACTO:                                                 #
# =========                                                 #
#                                                           #
# TWITTER: # https://twitter.com/Dalekamistoso              #
#                                                           #
#                                                           #
#############################################################


# Bloqueo el uso de CTRL+C para interrumpir la ejecución inesperadamente

trap '' 2

# La variable "paquetes" indica que librerias se necesitan para iniciar el menú

paquetes='dialog pv unzip'

# Verificación de los paquetes requeridos por el menú mediante if

if ! dpkg -s $paquetes >/dev/null 2>&1; 
then
clear
echo ""
echo ""
echo ""
echo -e "\e[91mFaltan uno o varios paquetes IMPRESCINDIBLES - Vamos a instalarlos"
echo ""
echo -e "\e[92mSon totalmente seguros no te preocupes ('DIALOG' 'PV' 'UNZIP')"
echo ""
echo -e "\e[93mPERO ANTES VAMOS A VERIFICAR Y REPARAR TU PAQUETERIA POR SEGURIDAD"
echo ""
sleep 2
sudo apt install --fix-broken 
sudo apt update --fix-missing
sleep 2
clear
echo ""
echo -e "\e[93mProceso terminado ahora vamos a instalar......"
echo ""
sudo apt install -y $paquetes
clear
else
clear
echo ""
echo -e "\e[93mTodo parece estar bien iniciando......"
echo ""
fi 

# INICIO DE BLOQUE DEL MENU PRINCIPAL            

while true
do
clear

# Aqui defino los tamaños, fondo y propiedades del menú inicial

HEIGHT=19
WIDTH=75
CHOICE_HEIGHT=14
BACKTITLE="openMSX & TSX Advanced Linux Mod por DrWh0 & imulilla"
TITLE="openMSX & TSX Advanced Linux Mod (Menú Mint/Ubuntu LTS/PI)" 
MENU="Seleccione la opción deseada y pulsa <ENTER> para confirmar:"

OPTIONS=(1 "Instalar las dependencias necesarias para compilar y ejecutar"
         2 "Descargar e instalar binario de openMSX TSX Advanced"
         3 "Compilar e instalar última build de openMSX TSXADV desde GIT"
         4 "Ejecutar binario openMSX TSXADV (sólo con opción 2 no 3)"
         5 "Instalar mejoras y/o traducción para TSXAdv (usuario actual)"
         6 "Borrar emulador openMSX instalado y todos los parches"
         7 "Instalar y/o descargar roms de sistema (si existen)"
         8 "Reparar librerias dañadas o faltantes (avanzado)"
         9 "Instala dependencias/GIT compila e instala openMSX oficial"
         10 "Ejecutar binario compilado e instalado de openMSX"
         11 "Compilado rápido versión oficial para PC (Usar en PI/ARM)"
         12 "Compilado rápido versión TSXADV para PC (Usar en PI/ARM)"
         13 "Consultar fichero de ayuda"
         14 "Salir del programa"
)

# Defino atributos de la variable choice para simplificar procesos de case
# Limpio la pantalla y procedo con el case que define las acciones

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
            # INSTALAR LAS DEPENDENCIAS NECESARIAS PARA COMPILAR Y EJECUTAR
            
            # La variable "paquetes2" indica que librerias se necesitan para compilar y ejecutar todas las versiones de openMSX

            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.2 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
			
			# El comando instalador que instalará los paquetes definidos en la variable anterior con una descripción del proceso
			
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[93mVamos a instalar los paquetes desde tus repositorios de red...."
            echo -e "\e[93mSi quieres cancelar el proceso pulsa CTRL+C para volver al menú"
            echo ""
            echo ""
            sleep 2
			sudo apt install $paquetes2
			echo ""
            echo ""
            echo -e "\e[93mProceso terminado si algo salió mal usa la opción de reparación"
            echo -e "\e[93my vuelve a repetir el proceso hasta que se solucione el problema"
            echo ""
            sleep 3
			clear
            dialog --infobox "Saliendo del instalador de paquetes......" 3 45 ; sleep 2
            ;;
        2)
            # DESCARGAR E INSTALAR BINARIO DE OPENMSX TSX ADVANCED

		    # Declaro las variables 'URL1' y 'URL2' con los links de descarga
            # 'URL1' es la última versión compilada de TSXAdvanced
			# 'URL2' es el última versión de mi traducción de TSXAdvanced
			
            URL1="https://github.com/imulilla/openMSX_TSXadv/releases/latest/download/openMSX_TSXadv_linux_latest.tar.gz"
            URL2="https://github.com/Dalekamistoso/openMSX-Spanish-TSXAdvanced/blob/master/script-tsxadv.tar.gz"

			# Se descargan con wget sobreescribiendo y con reanudación de fichero interrumpido con 20sg de timeout
            # Tras ejecutar la acción de wget renombro el fichero a 'openMSX.tar.gz'
			# También genero una barra de progreso con la orden parseada por 'pv'
          
            wget -t 20 -cO openMSX.tar.gz "$URL1" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando OpenMSX TSX Advanced" 5 100 

            # Procedo a descomprimir con una barra de progreso con la libreria "pv"

            (pv -n openMSX.tar.gz | tar xzf - -C ~/) 2>&1 | dialog --gauge "Descomprimiendo..." 6 50
			
			# Procedo a activar el atributo de ejecución del binario descargado y un mensaje de retorno
			
            chmod +x ~/openMSX/openmsx

			dialog --infobox "Proceso finalizado - Volviendo al menú..." 3 45 ; sleep 2
            ;;
        3)   
            # COMPILAR E INSTALAR ÚLTIMA BUILD DE OPENMSX TSXADV DESDE GIT
            		
            # COMPILACION DE LA VERSION TSX ADVANCED
            # Instalo el paquete git, los compiladores necesarios y clono el repositorio oficial borrando antes el presente
            # Muestro información de lo que hago y doy la opción de cancelar con CTRL+C espero 3 segundos y borro fuentes viejas

            # La variable "paquetes2" indica que librerias se necesitan para compilar y ejecutar todas las versiones de openMSX
			# Se instala antes desde la opción 1 pero en caso de que usuario no lo haya hecho se verifica e instala de nuevo

            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.2 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
			
            if ! dpkg -s $paquetes2 >/dev/null 2>&1; 
            then
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[91mFALTAN PAQUETES IMPRESCINDIBLES PORQUE NO USASTE LA OPCION 1"
            echo ""			
            echo "Vamos a instalarlos.............."			
            echo ""			
            echo -e "\e[93mPERO ANTES VAMOS A VERIFICAR Y REPARAR TU PAQUETERIA POR SEGURIDAD"
            echo ""
            sleep 2
            sudo apt update
            sudo apt install --fix-broken 
            sudo apt update --fix-missing
            echo ""
            echo "\e[92m SI ALGO FALLASE REPARA LOS PAQUETES Y REINSTALALOS (OPCION 1)"
            echo ""
            sleep 2
            clear
            echo ""
            echo -e "\e[93mProceso terminado ahora vamos a instalar......"
            echo ""
            echo ""
            echo ""
            sudo apt install -y $paquetes
            echo ""
            echo "\e[92m SI ALGO FALLASE REPARA LOS PAQUETES Y REINSTALALOS (OPCION 1)"
            echo ""
            sleep 3
            clear
            fi 

            # Ahora procedemos a efectuar la acción del compilado/instalado

            clear
            dialog --infobox "Se van a borrar las fuentes existentes y se clonará el GIT actualizado.
			
			Si los paquetes preexistentes son más modernos se recomienda pulsar <N> y <ENTER>.
			
			En caso contrario *podría* dañarse tu sistema operativo, no arrancar o funcionar mal." 10 52 ; sleep 3
            rm -Rf ./fuentes-openMSX			   

            # Aqui me pongo a realizar un git clone del repositorio TSXADVANCED después de borrar el directorio de fuentes si existe
            # Posteriormente muestro el contenido del resultado de verificar dependencias en "result-check.txt"
			
            git clone https://github.com/imulilla/openMSX_TSXadv/ fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Clonado terminado - Vamos a verificar" 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerificando dependencias......."
            echo ""
            ./configure >result-check.txt
            
            dialog  --textbox result-check.txt 20 80
            clear

            # Tras bajar e instalar git pregunto si compilar o no 
            # 0 indica que pinchaste en [si] y procedo a compilar.
            # 1 indica que pinchaste en [no] porque había algo que no está bien y vuelvo al menú.
            # 255 indica que pinchaste en [Esc] que hace el mismo efecto que [no].
            
            clear
            dialog --title "¿Compilar código fuente descargado? " \
            --backtitle "Menu de compilación e instalación" \
            --yesno '¿Compilar código fuente descargado del GIT? ' 7 60

            # COMIENZO MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR COMPILACION
			
            response2=$?
            case $response2 in
            0)
                cd "fuentes-openMSX"						
                clear
                dialog --infobox "Procediento al proceso de compilación en 2 segundos." 3 43 ; sleep 2
                clear
                echo -e "\e[93mCompilando (esto va a tardar bastante, se paciente)"
                echo ""
                sudo make install > resultado.txt
                dialog  --textbox resultado.txt 20 80
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            1)  
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            255) 
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            esac
            ;;
        4)  
		    # EJECUTAR BINARIO OPENMSX TSXADV (SÓLO CON OPCIÓN 2 NO 3)
			
            # Limpio pantalla y ejecuto el openmsx en la ruta predeterminada
            
            clear
            ~/openMSX/openmsx
            ;;
        5)
            # INSTALAR MEJORAS DE DRWH0 (TRADUCCION SOLO PARA TSXADV)
			
            # Minibloque case para preguntar que version traducir

			# Con el openmsx ya instalado/compilado instala una traducción a español

			dialog --title "Paquete de traducción/majora (ESC para cancelar)" \
			--backtitle "Parche adicional de mejoras de DrWh0" \
            --yesno '¿Instalas sobre una versión openMSX TSX Advanced?' 5 50

            # Aqui verifico el resultado del cuadro de diálogo "yesno"
            # 0 indica que pinchaste en [si] e instala la traducción para TSXAdvanced.
            # 1 indica que pinchaste en [no] e instala la traducción para la oficial.
            # 255 indica que pinchaste en [Esc] y vuelves al menú inicial.
            # Esta rutina la empleo más adelante para confirmar el borrado de lo instalado
			# Lo hago modularmente en lugar de una función para permitir su uso externamente a modo educativo
            # Adicionalmente borro los ficheros de scripts preexistentes para tenerlos actualizados

            response=$?
            case $response in
            0) 
               rm -Rf ~/.openMSX/share/scripts/*.*
               (pv -n script-tsxadv.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Descomprimiendo personalizaciones..." 6 50
               dialog --infobox "Personalización finalizada" 3 30 ; sleep 2
               ;;
            1) 
               rm -Rf ~/.openMSX/share/scripts/*.*
               (pv -n script-normal-new.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Descomprimiendo personalizaciones..." 6 50
               dialog --infobox "Personalización finalizada" 3 30 ; sleep 2
               ;;
            255) 
               dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
               cd ..
               ;;
            esac
            ;;
        6)  
            # BORRAR EMULADOR OPENMSX INSTALADO Y TODOS LOS PARCHES            
			
            # Confirmo el borrado del emulador y los parches

            # Se borran las carpetas 'openMSX' (emulador) y '.openMSX' (configuraciones, roms y scripts)
            # Si respondes <Sí> se borra de tu directorio de usuario 
            # Si respondes <No> se desinstala primero ordenadamente el paquete y luego se borra a lo bestia
			
            dialog --title "Borrado de archivos (Pulsa <ESC> para cancelar)" \
            --backtitle "¿Borrar solamente del directorio del usuario?" \
            --yesno '<Sí> para borrar solamente de tu directorio de usuario.
			<No> Desinstala el paquete y borra del sistema completo.' 6 60
            response=$?
            case $response in
            0) 
               #viejo sudo rm -Rf ~/openMSX | rm -Rf ~/.openMSX | rm -Rf ./fuentes-openMSX
               rm -Rf ~/openMSX ~/.openMSX ./fuentes-openMSX
               ;;
            1) 
               sudo apt remove openmsx*
               sudo rm -Rf /usr/bin/openmsx /usr/share/openmsx /bin/openmsx /root/openmsx ~/openMSX ~/.openMSX /root/.openMSX ./fuentes-openMSX 
               ;;
            255) ;;
            esac
            ;;
        7)  
            # INSTALAR Y/O DESCARGAR ROMS DE SISTEMA (SI EXISTEN)
			
            # Defino 'URL5' para que en caso de que no haya un "systemroms.tar.gz" presente se descargue las roms de internet
            # Se verifica que exista el zip y lo descomprime en caso contrario baja desde URL5 y descomprime/instala
			# He repetido dos veces la declaración por fines de depuración
			
			URL5="http://www.msxarchive.nl/pub/msx/emulator/openMSX/systemroms.zip"
			
			if [ -f "systemroms.tar.gz" ];
            then
			URL5="http://www.msxarchive.nl/pub/msx/emulator/openMSX/systemroms.zip"
            dialog --infobox "Archivo de roms de sistema encontrado......"  3 47 ; sleep 2 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }'
              (pv -n systemroms.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Descomprimiendo roms de sistema....." 6 50
            dialog --infobox "Instalación de roms de sistema finalizada" 3 45 ; sleep 3
			else
            dialog --infobox "No encuentro el fichero systemroms.tar.gz - Buscando online" 3 63 ; sleep 2
            dialog --infobox "Descargando openMSX roms de internet..." 3 43 ; sleep 2
            wget -t 20 -cO systemroms.zip "$URL5" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando bios del sistema" 5 100
            unzip systemroms.zip -d ~/.openMSX/share 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descomprimiendo roms de MSX" 5 100
            dialog --infobox "Roms descomprimidas e instaladas (con suerte XD)" 3 52 ; sleep 2
			fi
            ;;           
        8)  
            # REPARAR LIBRERIAS DAÑADAS O FALTANTES (AVANZADO)
			
            dialog --infobox "Voy a intentar primero reparar updates." 3 43 ; sleep 2
            clear
            echo -e "\e[93mVoy a intentar primero reparar los updates fallidos...."
            echo ""
            echo ""
            sleep 3
			sudo apt update
			sudo apt update --fix-missing
            sleep 3
            dialog --infobox "Voy a intentar raparar los paquetes apt" 3 43 ; sleep 2
            clear
            echo -e "\e[93mVoy a intentar reparar los paquetes dañados de tu sistema"                     
            sudo apt install --fix-broken
			sudo apt update
            echo ""
            echo ""
            echo -e "\e[93mSi ha fallado algo emplea las opciones de reparación de nuevo"
            sleep 3
            dialog --infobox "Volviendo al menu principal............" 3 43 ; sleep 2
            ;;
        9)  
            # INSTALA DEPENDENCIAS/GIT COMPILA E INSTALA OPENMSX OFICIAL

            # La variable "paquetes2" indica que librerias se necesitan para compilar y ejecutar todas las versiones de openMSX
			# Se instala antes desde la opción 1 pero en caso de que usuario no lo haya hecho se verifica e instala de nuevo

            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.2 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
			
            if ! dpkg -s $paquetes2 >/dev/null 2>&1; 
            then
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[91mFALTAN PAQUETES IMPRESCINDIBLES PORQUE NO USASTE LA OPCION 1"
            echo ""			
            echo "Vamos a instalarlos.............."			
            echo ""			
            echo -e "\e[93mPERO ANTES VAMOS A VERIFICAR Y REPARAR TU PAQUETERIA POR SEGURIDAD"
            echo ""
            sleep 2
            sudo apt update
            sudo apt install --fix-broken 
            sudo apt update --fix-missing
            echo ""
            echo "\e[92m SI ALGO FALLASE REPARA LOS PAQUETES Y REINSTALALOS (OPCION 1)"
            echo ""
            sleep 2
            clear
            echo ""
            echo -e "\e[93mProceso terminado ahora vamos a instalar......"
            echo ""
            echo ""
            echo ""
            sudo apt install -y $paquetes2
            echo ""
            echo "\e[92m SI ALGO FALLASE REPARA LOS PAQUETES Y REINSTALALOS (OPCION 1)"
            echo ""
            sleep 3
            clear
            fi 
            sleep 3
            clear
            dialog --infobox "Se van a borrar las fuentes existentes y se clonará el GIT actualizado.
			
		   Si los paquetes preexistentes son más modernos se recomienda pulsar <N> y <ENTER>.
			
		   En caso contrario *podría* dañarse tu sistema operativo, no arrancar o funcionar mal." 10 52 ; sleep 3
            
            # Aqui me pongo a realizar un git clone del repositorio oficial después de borrar el directorio de fuentes si existe
            # Posteriormente muestro el contenido del resultado de verificar dependencias en "result-check.txt"
			
			clear
            rm -Rf ./fuentes-openMSX			   
			git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Clonado terminado - Vamos a verificar" 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerificando dependencias......."
            echo ""
            ./configure >result-check.txt
            
            dialog  --textbox result-check.txt 20 80
            clear

            # Tras bajar e instalar git pregunto si compilar o no 
            # 0 indica que pinchaste en [si] y procedo a compilar.
            # 1 indica que pinchaste en [no] porque había algo que no está bien y vuelvo al menú.
            # 255 indica que pinchaste en [Esc] que hace el mismo efecto que [no].
            
            clear
            dialog --title "¿Compilar código fuente descargado? " \
            --backtitle "Menu de compilación e instalación" \
            --yesno '¿Compilar código fuente descargado del GIT? ' 7 60

            # Comienzo minibloque de case secundario para confirmar compilacion
			
            response2=$?
            case $response2 in
            0)
                cd "fuentes-openMSX"						
                clear
                dialog --infobox "Procediento al proceso de compilación en 2 segundos." 3 43 ; sleep 2
                clear
                echo -e "\e[93mCompilando (esto va a tardar bastante, se paciente)"
                echo ""
                sudo make install > resultado.txt
                dialog  --textbox resultado.txt 20 80
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            1)  
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            255) 
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            esac
            ;;
        10)
            # EJECUTAR BINARIO COMPILADO E INSTALADO DE OPENMSX
			
            openmsx
            ;;
        11)  
            # COMPILADO RÁPIDO VERSIÓN OFICIAL PARA PC (USAR EN PI/ARM)
			
            # Ejecuto funciones de raspberry PI
            # Instalo primero los paquetes de git y compiladores para clonar el repositorio oficial

            dialog --infobox "Instalando GIT y dependencias. Si se pregunta sobreescribir librerias mas modernas preinstaladas di siempre NO (pulsa <ENTER>).   PUES PUEDES ROMPER TU SISTEMA OPERATIVO........" 6 52 ; sleep 3
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
            sudo apt install dialog pv unzip libfreetype6 libfreetype6-dev libglew2.2 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev
            echo ""
            echo ""
            echo -e "\e[93mSi ha fallado algo emplea las opciones de reparación del menu principal"
            echo ""
            echo ""
            sleep 3
            clear
            
            # Aqui me pongo a realizar un git clone del repositorio (va a tardar un buen rato)
			# Borro primero el directorio de fuentes antiguas (en caso de existir)
            # Procedo a clonar el git oficial mediantes las reglas de compilación oficiales
			# Posteriormente saco un textbox con el contenido de la verificación de requisitos
            
			rm -Rf ./fuentes-openMSX			   
            git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Clonado terminado - Vamos a verificar" 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerificando dependencias......."
            echo ""
            ./configure >result-check.txt
            dialog  --textbox result-check.txt 20 80
            clear
            
            # Tras instalar el git y clonar el repositorio paso a confirmar la compilación
            
            clear
            dialog --title "¿Compilar código fuente descargado? " \
            --backtitle "Menu de compilación e instalación" \
            --yesno '¿Compilar código fuente descargado del GIT? ' 7 60
            
            # Aqui verifico el resultado del codigo de estado de yesno
            # 0 indica que pinchaste en [si] y pregunta después si proceder a compilar.
            # 1 indica que pinchaste en [no] y vuelve al menú principal.
            # 255 indica que pinchaste en [Esc] y vuelve al menú principal.
            # Lo hago modularmente en vez de crear una función para permitir su uso externamente
            
            #     COMIENZO MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR COMPILACION
			
            response2=$?
            case $response2 in
            0)         
                 cd "fuentes-openMSX"						
                 clear
                 dialog --infobox "Procediendo al proceso de compilación en 2 segundos." 3 43 ; sleep 2
                 clear
                 echo -e "\e[93mCompilando (esto va a tardar bastante, hasta 5h en PI, se paciente)"
                 echo ""
                 sudo make install
                 dialog --infobox "Proceso terminado volviendo........." 3 43 ; sleep 2
                 cd ..
                 ;;
            1)  
                 dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                 cd ..
                 ;;
            255) 
                 dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                 cd ..
                 ;;
            esac
            ;;
        12)  
            # COMPILAR E INSTALAR ÚLTIMA BUILD DE OPENMSX TSXADV DESDE GIT
            		
            # Instalo el paquete git, los compiladores necesarios y clono el repositorio oficial borrando antes el presente
            # Muestro información de lo que hago y doy la opción de cancelar con CTRL+C espero 3 segundos y borro fuentes viejas
            
            # La variable "paquetes2" indica que librerias se necesitan para compilar y ejecutar todas las versiones de openMSX
            # Se instala antes desde la opción 1 pero en caso de que usuario no lo haya hecho se verifica e instala de nuevo
            
            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.2 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
            
            if ! dpkg -s $paquetes2 >/dev/null 2>&1; 
            then
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[91mFALTAN PAQUETES IMPRESCINDIBLES PORQUE NO USASTE LA OPCION 1"
            echo ""			
            echo "Vamos a instalarlos.............."			
            echo ""			
            echo -e "\e[93mPERO ANTES VAMOS A VERIFICAR Y REPARAR TU PAQUETERIA POR SEGURIDAD"
            echo ""
            sleep 2
            sudo apt update
            sudo apt install --fix-broken 
            sudo apt update --fix-missing
            echo ""
            echo "\e[92m SI ALGO FALLASE REPARA LOS PAQUETES Y REINSTALALOS (OPCION 1)"
            echo ""
            sleep 2
            clear
            echo ""
            echo -e "\e[93mProceso terminado ahora vamos a instalar......"
            echo ""
            echo ""
            echo ""
            sudo apt install -y $paquetes2
            echo ""
            echo "\e[92m SI ALGO FALLASE REPARA LOS PAQUETES Y REINSTALALOS (OPCION 1)"
            echo ""
            sleep 3
            clear
            fi 
            
            # Ahora procedemos a efectuar la acción del compilado/instalado
            
            clear
            dialog --infobox "Se van a borrar las fuentes existentes y se clonará el GIT actualizado.
            
            Si los paquetes preexistentes son más modernos se recomienda pulsar <N> y <ENTER>.
            
            En caso contrario *podría* dañarse tu sistema operativo, no arrancar o funcionar mal." 10 52 ; sleep 3
            rm -Rf ./fuentes-openMSX			   
            
            # Aqui me pongo a realizar un git clone del repositorio TSXADVANCED después de borrar el directorio de fuentes si existe
            # Posteriormente muestro el contenido del resultado de verificar dependencias en "result-check.txt"
            
            git clone https://github.com/imulilla/openMSX_TSXadv/ fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Clonado terminado - Vamos a verificar" 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerificando dependencias......."
            echo ""
            ./configure >result-check.txt
            
            dialog  --textbox result-check.txt 20 80
            clear
            
            # Tras bajar e instalar git pregunto si compilar o no 
            # 0 indica que pinchaste en [si] y procedo a compilar.
            # 1 indica que pinchaste en [no] porque había algo que no está bien y vuelvo al menú.
            # 255 indica que pinchaste en [Esc] que hace el mismo efecto que [no].
            
            clear
            dialog --title "¿Compilar código fuente descargado? " \
            --backtitle "Menu de compilación e instalación" \
            --yesno '¿Compilar código fuente descargado del GIT? ' 7 60
            
            # COMIENZO MINIBLOQUE DE CASE SECUNDARIO PARA CONFIRMAR COMPILACION
            
            response2=$?
            case $response2 in
            0)
                cd "fuentes-openMSX"						
                clear
                dialog --infobox "Procediendo al proceso de compilación en 2 segundos." 3 43 ; sleep 2
                clear
                echo -e "\e[93mCompilando (esto va a tardar bastante, se paciente)"
                echo ""
                sudo make install
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            1)  
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            255) 
                dialog --infobox "Volviendo al menú principal........." 3 43 ; sleep 2
                cd ..
                ;;
            esac
            ;;
        13) 
            # CONSULTAR FICHERO DE AYUDA		
		    
            # Abre un textbox con el fichero de ayuda contenido en el fichero README-XXXXX

            dialog  --textbox README-SPANISH 20 80
            ;;
        14)
            # SALIR DEL PROGRAMA
			
            # Rehabilito el uso de CTRL+C y salgo del programa tras mostrar una pantalla de agradecimiento

            trap 2 # Si añadieramos "| kill -9 $PPID" cerrariamos además la sesión
            dialog --infobox "Saliendo - Gracias por usar mi programa" 3 43 ;      sleep 2
            clear
            exit
			;;
esac
done


#############################################################
#             FINAL DE BLOQUE DEL MENU PRINCIPAL            #
#                                                           #
#  COSAS PENDIENTES DE IMPLEMENTAR:                         #
#                                                           #
#  1.- CREAR ACCESOS DIRECTOS EN GNOME/CINNAMON/KDE/XFCE    #
#                                                           #
# Crear un fichero de texto ".desktop" y copiarlo mediante: #
#                                                           #
# sudo cp *.desktop "/usr/share/applications/" (ruta)       #
#                                                           #
# Crear cuadro de diálogo para informar y poco más          #
# dialog --infobox "Acceso directo creado" 3 25 ; sleep 2   #
#                                                           #
#                                                           #
#                                                           #
#  2.- CAPTURA DE ERRORES EN LA DESCARGA DE LOS ARCHIVOS    #
#                                                           #
# Pendiente implementar captura de excepciones para wget    #
# Algo como interceptar el HTTP Response Code (404/200):    #
# wget --server-response -q -o wgetOut $URL                 # 
# y capturar el resultado del _wgetHttpCode                 #
#                                                           #
#                                                           #
#                                                           #
#  3.- FRONTEND HECHO EN GTK+/GLADE                         #
#                                                           #
#                                                           #
# Pendiente portar el código a modo gráfico puro            #
#############################################################
