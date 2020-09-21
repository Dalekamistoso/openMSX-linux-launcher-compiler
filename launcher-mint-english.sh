#!/bin/bash 

#############################################################
#                                                           #
#                                                           #
#  OPENMSX & OPENMSX TSXADVANCED LAUNCHER+COMPILER          #
# =================================================         #
#                                                           #
# FEATURES INCLUDED:                                        #
#                                                           #
#  1.- COMPILES & INSTALLS EXECUTABLE FROM MOST RECENT GIT  #
#                                                           #
#  2.- REPAIRS PACKAGE MANAGER SYSTEM IF NECESSARY          #
#                                                           #
#  3.- STARTS EXECUTABLE WITHIN MENU                        #
#                                                           #
#  4.- AUTO INSTALLS SYSTEMROMS FROM A LOCAL ARCHIVE        #
#                                                           #
#  5.- DOWNLOADS/INSTALL FULL ROMSET FROM INTERNET          #
#                                                           #
#  6.- CLEANS AND UNINSTALLS OPENMSX AND REPOSITORIES       #
#                                                           #
#  7.- SUPPORTS BOTH OPENMSX & OPENMSX TSX ADVANCED EDITION #
#                                                           #
#  8.- INSTALLS DRWH0 SPANISH TRANSLATION MOD               #
#                                                           #
#  9.- INSTALA LIBRERIAS LOCALES MODERNAS (LINUX LTS VIEJOS)# 
#                                                           #
#  0.- SUPPORTS MINT/UBUNTU/DEBIAN x64 & ARMxx (20.04 LTS)  #
#                                                           #
#                                                           #
# AUTHORS:                                                  #
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
# CONTACT:                                                  #
# ========                                                  #
#                                                           #
# TWITTER: # https://twitter.com/Dalekamistoso              #
#                                                           #
#                                                           #
#############################################################


# Blocks CTRL+C usage in order to avoid unexpected interruption of script

trap '' 2

# Variable "paquetes" contains the packages needed for launching frontend

paquetes='dialog pv unzip'

# Required packages verification using if command

if ! dpkg -s $paquetes >/dev/null 2>&1; 
then
clear
echo ""
echo ""
echo ""
echo -e "\e[91mOne or more ESSENTIALS packages are missing - Let´s install it!"
echo ""
echo -e "\e[92mAre absolutely safe, don´t worry those are ('DIALOG' 'PV' 'UNZIP')"
echo ""
echo -e "\e[93mBUT IN FIRST PLACE WE WILL CHECK AND REPAIR YOUR PACKAGES FOR SAFETY"
echo ""
sleep 2
sudo apt install --fix-broken 
sudo apt update --fix-missing
sleep 2
clear
echo ""
echo -e "\e[93mProcess finished, starting install process...."
echo ""
sudo apt install -y $paquetes
clear
fi 

# START OF MAIN MENU BLOCK

while true
do
clear

# Here we define sizes, background and properties of main menu 

HEIGHT=19
WIDTH=75
CHOICE_HEIGHT=14
BACKTITLE="openMSX & TSX Advanced Linux Mod por DrWh0 & imulilla"
TITLE="openMSX & TSX Advanced Linux Mod (Mint/Ubuntu LTS/PI Menu)" 
MENU="Select your desired option and press <ENTER> to confirm:"

OPTIONS=(1 "Install needed dependencies for compilation and execution"
         2 "Download & install openMSX TSX Advanced binary files"
         3 "Compile & install most recent build of openMSX TSXADV from GIT"
         4 "Execute openMSX TSXADV binary (only for option 2 not 3)"
         5 "Install DrWh0's Mod Spanish tranlation (current user only)"
         6 "Delete installed openMSX and all patches"
         7 "Install and/or download systemroms (if exists)"
         8 "Repair damaged or missing libraries (advanced users)"
         9 "Install packages, compiles & install official openMSX"
         10 "Execute installed openMSX compiled from GIT"
         11 "Official fast compilation for PC (Use this in PI/ARM)"
         12 "openMSX TSXADV fast compilation for PC (Use this in PI/ARM)"
         13 "Read help file"
         14 "Exit from this program"
)

# Defines choice variable attributes in order to simplify the usage of case
# Cleans the screen and starts the case command that defines desired actions

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
            # INSTALL NEEDED DEPENDENCIES FOR COMPILATION AND EXECUTION
            
            # "paquetes2" variable points which packages are needed to compile and execute all openMSX versions

            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.1 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
			
			# The installer command will install the packages defined in the previous stated variable with a description of the process to take place
			
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[93mWe are going to install the packages from your repositories...."
            echo -e "\e[93mIf you want to cancel press CTRL+C to return"
            echo ""
            echo ""
            sleep 2
			sudo apt install $paquetes2
			echo ""
            echo ""
            echo -e "\e[93mProcess finished if something went wrong use repair opetion (8)"
            echo -e "\e[93mand restart the whole process until problem is solved"
            echo ""
            sleep 3
			clear
            dialog --infobox "Exiting from package manager......" 3 45 ; sleep 2
            ;;
        2)
            # DOWNLOAD & INSTALL OPENMSX TSX ADVANCED BINARY FILES

		    # I declare 'URL1' & 'URL2' variables with download links
            # 'URL1' is the last compiled version of TSXAdvanced
			# 'URL2' is the last version of my spanish translation+mod for TSXAdvanced
			
            URL1="https://github.com/imulilla/openMSX_TSXadv/releases/latest/download/openMSX_TSXadv_linux_latest.tar.gz"
            URL2="https://github.com/Dalekamistoso/openMSX-Spanish-TSXAdvanced/blob/master/script-tsxadv.tar.gz"

			# We download using wget overwriting with resume transfer option and a timeout of 20 seconds  
            # After wget action we rename the downloaded file to 'openMSX.tar.gz'
			# Also I generate a progress bar parsed with command 'pv'
          
            wget -t 20 -cO openMSX.tar.gz "$URL1" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Descargando OpenMSX TSX Advanced" 5 100 

            # Proceed to decompress with progress bar (using package "pv")

            (pv -n openMSX.tar.gz | tar xzf - -C ~/) 2>&1 | dialog --gauge "Descomprimiendo..." 6 50
			
			# I enable execution attribute for the downloaded binary file and a returning message
			
            chmod +x ~/openMSX/openmsx

			dialog --infobox "Process finished - Returning ro main menu" 3 45 ; sleep 2
            ;;
        3)   
            # COMPILE & INSTALL MOST RECENT BUILD OF OPENMSX TSXADV FROM GIT
            		
            # COMPILATION OF TSX ADVANCED VERSION 
            # I install git package, the needed compilers and clone the official repository deleting previously stored one
            # I show information of the process giving the option to cancel with CTRL+C after 3 seconds I delete the old files

            # "paquetes2" variable points which packages are needed to compile and execute all openMSX versions
			# Option 1 already install all but it checks that user used that option if not it will proceed to execute it

            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.1 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
			
            if ! dpkg -s $paquetes2 >/dev/null 2>&1; 
            then
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[91mSOME ESSENTIALS PACKAGES ARE MISSING (YOU DIDN´T USED OPTION 1 BEFORE)"
            echo ""			
            echo "We are goning to install anyway.."			
            echo ""			
            echo -e "\e[93mBUT FIRST WE ARE GOING TO VERIFY YOUR INSTALLED PACKAGES FOR SAFETY"
            echo ""
            sleep 2
            sudo apt update
            sudo apt install --fix-broken 
            sudo apt update --fix-missing
            echo ""
            echo "\e[92m IF SOMETHING FAILS REPAIR PACKAGES AND REINSTALL (OPTION 1)"
            echo ""
            sleep 2
            clear
            echo ""
            echo -e "\e[93mProcess finisehd, lets install!..............."
            echo ""
            echo ""
            echo ""
            sudo apt install -y $paquetes
            echo ""
            echo "\e[92m IF SOMETHING FAILS REPAIR PACKAGES AND REINSTALL (OPTION 1)"
            echo ""
            sleep 3
            clear
            fi 

            # Starting compilation and installation process

            clear
            dialog --infobox "We are going to delete old existing sources and we will clone the GIT..
			
			If already installed packages are more recent is adviced to select <N> & <ENTER>.
			
			If you don´t do it your system *would* break, not start or works badly..............." 10 52 ; sleep 3
            rm -Rf ./fuentes-openMSX			   

            # Here we start the git clone from TSXADVANCED GIT after deleting old sources if already exists
            # Afterwards I show the results of dependency check in file "result-check.txt"
			
            git clone https://github.com/imulilla/openMSX_TSXadv/ fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "GIT cloned - Starting verification..." 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerifying dependencies........."
            echo ""
            ./configure >result-check.txt
            
            dialog  --textbox result-check.txt 20 80
            clear

            # After git download I ask for starting to compile or not
            # 0 means [Yes] and starts compiling.
            # 1 means [No] and return to menu because you saw that something is not working properly.
            # 255 means [Esc] same effect as [no].
            
            clear
            dialog --title "Compile downloaded source code?....." \
            --backtitle "Compilation and installation menu" \
            --yesno 'Compile downloaded source code from GIT? ' 7 60

            # STARTS MINIBLOCK WITH SECUNDARY CASE TO CONFIRM COMPILATION PROCESS
			
            response2=$?
            case $response2 in
            0)
                cd "fuentes-openMSX"						
                clear
                dialog --infobox "Proceeding to compilation process in 2 seconds......" 3 43 ; sleep 2
                clear
                echo -e "\e[93mCompiling (it will tak a lot of time, be patient)"
                echo ""
                sudo make install > resultado.txt
                dialog  --textbox resultado.txt 20 80
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            1)  
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            255) 
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            esac
            ;;
        4)  
		    # EXECUTE OPENMSX TSXADV BINARY (ONLY FOR OPTION 2 NOT 3)
			
            # Clear screen and executes openmsx in default installed path inside user profile
            
            clear
            ~/openMSX/openmsx
            ;;
        5)
            # INSTALL DRWH0'S MOD SPANISH TRANLATION (CURRENT USER ONLY)
			
            # CASE Miniblock for question about which version you want to translate

			# Only works with an already installed/compiled openMSX

			dialog --title "Spanish translation package + mod (ESC to cancel)" \
			--backtitle "Spanish additional translation and patches by DrWh0" \
            --yesno 'Are you installing over a openMSX TSX Advanced???' 5 60

            # Here I check the results of "yesno" text dialog
            # 0 means you selected [yes] and install the translation for openMSX TSXAdvanced.
            # 1 means you selected [no] and install the translation for official openMSX.
            # 255 means you pressed [ESC] and cancel the installation and return to main menu.
            # I reuse this routine in the program to confirm deletion of installed files
			# I do this in modules instead function in order to use it externally for education reasons
            # Additonally I delete the preexistent TCL scripts in user folder in order to avoid conflicts

            response=$?
            case $response in
            0) 
               rm -Rf ~/.openMSX/share/scripts/*.*
               (pv -n script-tsxadv.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Uncompressing custom modifications.." 6 50
               dialog --infobox "Customization finished...." 3 30 ; sleep 2
               ;;
            1) 
               rm -Rf ~/.openMSX/share/scripts/*.*
               (pv -n script-normal.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Uncompressing custom modifications.." 6 50
               dialog --infobox "Customization finished...." 3 30 ; sleep 2
               ;;
            255) 
               dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
               cd ..
               ;;
            esac
            ;;
        6)  
            # DELETE INSTALLED OPENMSX AND ALL PATCHES            
			
            # Confirms the deletion of the emulator and patches

            # 'openMSX' (emulator) & '.openMSX' (configurations, roms & scripts) folders are deleted
            # If you say <Yes> it deletes files in your profile
            # If you say <No> openMSX package will be removed and after that it will be deleted manually all installed foldes
			
            dialog --title "File deletion (Press <ESC> to cancel..........." \
            --backtitle "Delete only files in your home directory?????" \
            --yesno '<Yes> to delete only your files in your user´s folder...
			<No> Uninstall packages and deletes in whole system.....' 6 60
            response=$?
            case $response in
            0) 
               #old sudo rm -Rf ~/openMSX | rm -Rf ~/.openMSX | rm -Rf ./fuentes-openMSX
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
            # INSTALL AND/OR DOWNLOAD SYSTEMROMS (IF EXISTS)
			
            # I define 'URL5' variable in case that there is no "systemroms.tar.gz" file containing system roms so it can download from internet
            # It checks that exists de zipped file and uncompress it, if not present will be downloaded from internet using the URL providede in 'URL5'
			# I repeat the declaration of the variable twice for debugging reasons.
			
			URL5="http://www.msxarchive.nl/pub/msx/emulator/openMSX/systemroms.zip"
			
			if [ -f "systemroms.tar.gz" ];
            then
			URL5="http://www.msxarchive.nl/pub/msx/emulator/openMSX/systemroms.zip"
            dialog --infobox "File with systemroms found!!..............."  3 47 ; sleep 2 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }'
              (pv -n systemroms.tar.gz | tar xzf - -C ~/.openMSX) 2>&1 | dialog --gauge "Uncompressing systemroms file......." 6 50
            dialog --infobox "Systemroms installation completed!!!!!!!!" 3 45 ; sleep 3
			else
            dialog --infobox "I cannot find file systemroms.tar.gz - Searching online" 3 63 ; sleep 2
            dialog --infobox "Downloading openMSX roms from internet." 3 43 ; sleep 2
            wget -t 20 -cO systemroms.zip "$URL5" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Downloading system bios....." 5 100
            unzip systemroms.zip -d ~/.openMSX/share/systemroms 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | dialog --gauge "Uncompressing MSX roms....." 5 100
            dialog --infobox "Roms uncompressed and installed (with luck)....." 3 52 ; sleep 2
			fi
            ;;           
        8)  
            # REPAIR DAMAGED OR MISSING LIBRARIES (ADVANCED USERS)
			
            dialog --infobox "Trying to repair updates first........." 3 43 ; sleep 2
            clear
            echo -e "\e[93mTrying to repair possibly failed updates..............."
            echo ""
            echo ""
            sleep 3
			sudo apt update
			sudo apt update --fix-missing
            sleep 3
            dialog --infobox "Trying to repair apt package files....." 3 43 ; sleep 2
            clear
            echo -e "\e[93mTrying to repari damaged packaged on your system........."                     
            sudo apt install --fix-broken
			sudo apt update
            echo ""
            echo ""
            echo -e "\e[93mIf something went brong use repair options from menu again..."
            sleep 3
            dialog --infobox "Returning to main menu................." 3 43 ; sleep 2
            ;;
        9)  
            # INSTALL PACKAGES, COMPILES & INSTALL OFFICIAL OPENMSX

            # "paquetes2" variable contains the name of packages needed to compile and execute all openMSX variants
			# Those are already installed with option 1 but if the user didn´t then is verified and installed again is needed.

            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.1 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
			
            if ! dpkg -s $paquetes2 >/dev/null 2>&1; 
            then
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[91mESSENTIAL PACKAGES ARE NOT PRESENT - YOU DID NOT CHOOSE OPTION 1!"
            echo ""			
            echo -e "\e[93mAnyway we are going to install..."		
            echo ""			
            echo -e "\e[93mBUT FIRST WE ARE GOING TO VERIFY AND REPAIR YOUR PACKAGES FOR SAFETY"
            echo ""
            sleep 2
            sudo apt update
            sudo apt install --fix-broken 
            sudo apt update --fix-missing
            echo ""
            echo "\e[92m IF SOMETHING WENT WRONG REPAIR AND REINSTALL PACKAGES (OPTION 1)"
            echo ""
            sleep 2
            clear
            echo ""
            echo -e "\e[93mProcess finished starting installation........"
            echo ""
            echo ""
            echo ""
            sudo apt install -y $paquetes2
            echo ""
            echo "\e[92m IF SOMETHING WENT WRONG REPAIR AND REINSTALL PACKAGES (OPTION 1)"
            echo ""
            sleep 3
            clear
            fi 
            sleep 3
            clear
            dialog --infobox "All existing sources will be deleted and updated GIT will be cloned....
			
		   If existing packages are more recent is recommended to choose <N> and <ENTER>.....
			
		   If you choose <YES> your system *may* be damaged, and may not start or work correctly" 10 52 ; sleep 3
            
            # Here I start with a git clone from official openMSX repository after erasing the old sources folder if existed
            # After clone will show a textbox with the contents of the verification of dependencies in "result-check.txt"
			
			clear
            rm -Rf ./fuentes-openMSX			   
			git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Cloning finished - Starting to verify" 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerifying dependencies........."
            echo ""
            ./configure >result-check.txt
            
            dialog  --textbox result-check.txt 20 80
            clear

            # Afte GIT installation and downloading the sources I ask for starting or not the compilation
            # 0 indicates you selected [yes] and start the compilation.
            # 1 indicates you selected [no] and cancel the proceess because something went wrong or simply was a mistake
            # 255 indicates [Esc] same effect as 1.
            
            clear
            dialog --title "Compile downloaded source code?....." \
            --backtitle "Compilation & Installation menu.." \
            --yesno 'Compile downloaded source code from the GIT?' 7 60

            # Starts secundary case miniblock to confirm compilation
			
            response2=$?
            case $response2 in
            0)
                cd "fuentes-openMSX"						
                clear
                dialog --infobox "Proceeding to compilation process in 2 seconds......" 3 43 ; sleep 2
                clear
                echo -e "\e[93mCompiling.. (this will take a lot of time , be patient)"
                echo ""
                sudo make install > resultado.txt
                dialog  --textbox resultado.txt 20 80
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            1)  
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            255) 
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            esac
            ;;
        10)
            # EXECUTE INSTALLED OPENMSX COMPILED FROM GIT
			
            openmsx
            ;;
        11)  
            # OFFICIAL FAST COMPILATION FOR PC (USE THIS IN PI/ARM)
			
            # Execute Raspberry PI functions
            # Installks git and compilers packages firs to clone the official GIT

            dialog --infobox "Installing GIT & dependencies. If you are asked to overwrite a more recent preinstalled package say always NO (press <ENTER>).   YOU CAN BREAK YOUR OPERATING SYSTEM............" 6 52 ; sleep 3
            clear
            echo ""
            echo ""                      
            echo -e "\e[93mI am start to install packages GIT system, compiler & dependenciess"
            echo -e "\e[93mIF ASKED TO OVERWRITE A NEWER PACKAGE"
            echo -e "\e[93m SAY ALWAYS NO (FOR SAFERTY) UNLES YOU KNOW WHAT ARE YOU DOING!!"
            echo ""
            echo -e "\e[92mPress CTRL+C to cancel and return to main menu.."
            echo ""
            echo ""                      
            echo -e "\e[93mInstalling packages..........."
            echo ""
            echo ""                      
            sudo apt install dialog pv unzip libfreetype6 libfreetype6-dev libglew2.1 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev
            echo ""
            echo ""
            echo -e "\e[93mIf something went wrong use repair options at main menu"
            echo ""
            echo ""
            sleep 3
            clear
            
            # Start git clone of the repository (it will take a long time)
			# We delete old sources if present
            # Proceeding to git the official git using official compilation rules
			# After that it shows a textbox with the results of dependencies checking tests
            
			rm -Rf ./fuentes-openMSX			   
            git clone https://github.com/openMSX/openMSX.git fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Clonned finished - Verifying.." 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerifying dependencies...."
            echo ""
            ./configure >result-check.txt
            dialog  --textbox result-check.txt 20 80
            clear
            
            # Tras instalar el git y clonar el repositorio paso a confirmar la compilación
            
            clear
            dialog --title "Compile downloaded source code????? " \
            --backtitle "Installation & Compilation menu.." \
            --yesno 'Compile source code downloaded from the GIT?' 7 60
            
            # Once more I verify the results of yesno status code
            # 0 means [yes] and ask if compile.
            # 1 means [no] and returns to main menu.
            # 255 means [Esc] and abort the process.
            # Made modular for external use
            
            # START OF SECUNDARY CASE MINIBLOCK
			
            response2=$?
            case $response2 in
            0)         
                 cd "fuentes-openMSX"						
                 clear
                 dialog --infobox "Proceeding to compilation process in 2 seconds......" 3 43 ; sleep 2
                 clear
                 echo -e "\e[93mCompiling (this take a lot of time upto 5 hours in PI, be patient)"
                 echo ""
                 sudo make install
                 dialog --infobox "Process finished returning.........." 3 43 ; sleep 2
                 cd ..
                 ;;
            1)  
                 dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                 cd ..
                 ;;
            255) 
                 dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                 cd ..
                 ;;
            esac
            ;;
        12)  
            # OPENMSX TSXADV FAST COMPILATION FOR PC (USE THIS IN PI/ARM)
            		
            # Instalo el paquete git, los compiladores necesarios y clono el repositorio oficial borrando antes el presente
            # Muestro información de lo que hago y doy la opción de cancelar con CTRL+C espero 3 segundos y borro fuentes viejas
            
            # La variable "paquetes2" indica que librerias se necesitan para compilar y ejecutar todas las versiones de openMSX
            # Se instala antes desde la opción 1 pero en caso de que usuario no lo haya hecho se verifica e instala de nuevo
            
            paquetes2='dialog pv unzip libfreetype6 libfreetype6-dev libglew2.1 libglew-dev tcl8.6 tcl8.6-dev libsdl2-ttf-dev libsdl2-dev pv unzip git gcc make g++ libao-dev libogg-dev libpng-dev liboggz2 libtheora-dev libxml2-dev libvorbis-dev libsdl2-dev libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev'
            
            if ! dpkg -s $paquetes2 >/dev/null 2>&1; 
            then
            clear
            echo ""
            echo ""
            echo ""
            echo -e "\e[91mESSENTIAL PACKAGES ARE NOT PRESENT - YOU DID NOT CHOOSE OPTION 1!"
            echo ""			
            echo "Vamos a instalarlos.............."			
            echo ""			
            echo -e "\e[93mBUT FIRST WE ARE GOING TO VERIFY AND REPAIR YOUR PACKAGES FOR SAFETY"
            echo ""
            sleep 2
            sudo apt update
            sudo apt install --fix-broken 
            sudo apt update --fix-missing
            echo ""
            echo "\e[92m IF SOMETHING WENT WRONG REPAIR AND REINSTALL PACKAGES (OPTION 1)"
            echo ""
            sleep 2
            clear
            echo ""
            echo -e "\e[93mAnyway we are going to install..."
            echo ""
            echo ""
            echo ""
            sudo apt install -y $paquetes2
            echo ""
            echo "\e[92m IF SOMETHING WENT WRONG REPAIR AND REINSTALL PACKAGES (OPTION 1)"
            echo ""
            sleep 3
            clear
            fi 
            
            # We proceed with installation/compilation
            
            clear
            dialog --infobox "Old existing source codes will be deleted & updated GIT will be cloned.
            
            If existing packages are newer is highly recommended to press key <N> and <ENTER>.
            
            Otherwise you *could* damage your OS and render it completely unusable or not boot!!." 10 52 ; sleep 3
            rm -Rf ./fuentes-openMSX			   
            
            # Starting un git clone of TSXADVANCED repository after deleting the folder with old sources
            # On completion the final results of verification will be displayed from the file "result-check.txt"
            
            git clone https://github.com/imulilla/openMSX_TSXadv/ fuentes-openMSX 
            sleep 3
            clear
            echo ""
            cd "fuentes-openMSX"
            dialog --infobox "Clonning finished - Starting verify.." 3 43 ; sleep 2
            clear 
            echo -e "\e[93mVerifying dependencies......."
            echo ""
            ./configure >result-check.txt
            
            dialog  --textbox result-check.txt 20 80
            clear
            
            # Once more I verify the results of yesno status code
            # 0 means [yes] and ask if compile.
            # 1 means [no] and returns to main menu.
            # 255 means [Esc] and abort the process.
            # Made modular for external use
            
            clear
            dialog --title "Compile downloaded source code????? " \
            --backtitle "Compilation & installation menu.." \
            --yesno 'Compile source code downloaded from the GIT?' 7 60
            
            # START ANOTHER SECUNDARY CASE MINIBLOCK TO CONFIRM COMPILATION
            
            response2=$?
            case $response2 in
            0)
                cd "fuentes-openMSX"						
                clear
                dialog --infobox "Procediento al proceso de compilación en 2 segundos." 3 43 ; sleep 2
                clear
                echo -e "\e[93mCompilando (esto va a tardar bastante, se paciente)"
                echo ""
                sudo make install
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            1)  
                dialog --infobox "Returning to main menu............" 3 43 ; sleep 2
                cd ..
                ;;
            255) 
                dialog --infobox "Returning to main menu.............." 3 43 ; sleep 2
                cd ..
                ;;
            esac
            ;;
        13) 
            # READ HELP FILE		
		    
            # Opens a textbox with help contained in the file README-XXXXX

            dialog  --textbox README-SPANISH 20 80
            ;;
        14)
            # EXIT FROM THIS PROGRAM
			
            # Reenable CTRL+C  function and exits from program after showing a text screen

            trap 2 # If we add "| kill -9 $PPID" we close the entire session
            dialog --infobox "Exiting - Thanks for using my program!!" 3 43 ;      sleep 2
            clear
            exit
			;;
esac
done


#############################################################
#                                                           #
#             END OF MAIN MENU BLOCK............            #
#                                                           #
#  FEATURES TO ADD IN THE FUTURE:                           #
#                                                           #
#  1.- DESKTOP ICONS FOR EN GNOME/CINNAMON/KDE/XFCE         #
#                                                           #
# Create a text file ".desktop" and copy using the command: #
#                                                           #
# sudo cp *.desktop "/usr/share/applications/" (path)       #
#                                                           #
# Create a couple of dialog boxes for new functions         #
#                                                           #
# dialog --infobox "Shorcut created" 3 25 ; sleep 2         #
#                                                           #
#  2.- ERROR CODE EXCEPTION CAPTURE DOWNLOADING FILES...    #
#                                                           #
# Pending to implement an exception capture for wget        #
# Like catiching HTTP Response Code (404/200):              #
# wget --server-response -q -o wgetOut $URL                 # 
# y capture the result of _wgetHttpCode                     #
#                                                           #
#  3.- GTK+/GLADE FRONTEND                                  #
#                                                           #
# Pending to port the code to full graphic mode....         #
#                                                           #
#############################################################
