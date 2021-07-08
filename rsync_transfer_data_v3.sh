echo "#################################################################################" | tee -a syslog.log
echo "$(date) INICIA PROGRAMA DE CONSULTA Y TRANSFERENCIA DE DATOS - MENU DISPONIBLE PARA OPERAR" | tee -a syslog.log
echo "---------------------------------------------------------------------------------"  | tee -a syslog.log
echo "$(date) Inicio de logeo de notificaciones y errores..." | tee -a syslog.log
echo " "
if which sshpass > /dev/null; then
echo " "
else
echo " "
echo "$(date) ATENCION: sshpass no esta instalado" | tee -a syslog.log
echo " "
read -p "Para poder transferir datos es necesario que este instalado. Presione enter para poder instalarlo ahora..." enter
echo " "
echo "Debera ingresar contraseña root para proceder..."
echo " "
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get"
osInfo[/etc/alpine-release]="apk"
osInfo[/etc/centos-release]="yum"
osInfo[/etc/fedora-release]="dnf"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
    package_manager=${osInfo[$f]}
    sudo $package_manager install sshpass
    fi
done
fi
while true; 
do
echo "######################################################"
echo "   * Programa de consulta y transferencia de datos *  "
echo " "
echo "   Menu principal - Seleccione una opcion para operar "
echo "######################################################"
echo " "
opciones=("- Ver tamaño de montajes en host local" "- Ver tamaño de montajes en host remoto" "- Ver scripts" "- Ejecutar scripts" "+ Crear nuevo archivo de transferencia" "- Verificar variables seteadas y errores" "- Nombre/ip de servidor" "- Usuario" "- Contraseña" "- Path de origen" "- Path de destino" "- Excluir carpeta/s y/o archivos" "- Regenerar archivo carpetas.log" "- Ejecutar programa excluyendo carpetas y archivos" "- Iniciar programa sin excluir una carpeta ni archivo" "- Ver log de transferencias rsync_log" "- Ver log de eventos syslog.log" )
select opcion in "${opciones[@]}"
do
  case $opcion in
  "- Ver tamaño de montajes en host local")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Consulta de montajes.." | tee -a syslog.log
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando tamaño en montajes en Server: $(hostname)" | tee -a server-local.log
     echo " " | tee -a server-local.log
     df -h | grep dev/s | tee -a server-local.log
     echo " " | tee -a server-local.log
     echo "$(date) NOTIFICACION - MENSAJE: Ip: " | tee -a server-local.log
     ifconfig | grep broadcast | tee -a server-local.log
     echo " " | tee -a server-local.log
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando Distribucion Linux: "
     cat /etc/os-release | tee -a server-local.log
     echo " "| tee -a server-local.log
     echo "----------------------------------------------------------------------------------" | tee -a server-local.log
     echo "$(date) NOTIFICACION - MENSAJE: Se realizo conulta de tamaño de puntos de montaje en server: " $(hostname) | tee -a syslog.log server-local.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     ;;
  "- Ver tamaño de montajes en host remoto")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Consulta de montajes en host remoto.." | tee -a syslog.log
     echo " "
     echo "Consulta de puntos de montaje en servdior remoto: $servidor"
     echo " "
     echo "ATENCION - PARA REALIZAR ESTA CONSULTA DEBEN ESTAR CONFIGURADAS ESTAS VARIABLES: "
     echo " "
	 echo "- Nombre/ip de servidor"
	 echo "- Usuario"
     echo "- Contraseña"
     echo " "
     echo "El programa verificara de forma secuencial, si hay errores para hacer la consulta. Para ver todos los errores, puede ingresar al menu: Verificar variables seteadas y errores"
     echo " "
     read -p "Presione enter para continuar..." enter
     echo " "
     if [ -z ${servidor+x} ]; then
     echo "$(date) ERROR01 - ATENCION: La variable servidor aun no fue proveida, provea el nombre del host/ip para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
     break
     else
     echo "$(date) OK-01 - variable servidor seteada - El host/ip definido es: '$servidor'. Si desea cambiarlo ingrese al menu Nombre/ip de servidor" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     if [ -z ${usuario+x} ]; then
     echo "$(date) ERROR02 - ATENCION: La variable usuario aun no fue proveida, ingrese al menu Usuario y provea el nombre de usuario del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
     break
     else
     echo "$(date) OK-02 - variable usuario seteada - El usuario definido para la conexion es: '$usuario'. Si desea cambiarlo ingrese al menu Usuario" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     if [ -z ${clave+x} ]; then
     echo "$(date) ERROR03 - ATENCION: La variable password aun no fue proveida, ingrese al menu Contraseña y provea la password del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
     break     
     else
     echo "$(date) OK-03 - variable password seteada - La password ya fue definida. Si desea cambiarla ingrese al menu Contraseña" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No se han encontrado errores" | tee -a syslog.log
     echo " "
     read -p "Presione enter para mostrar puntos de montaje en servidor $servidor" enter
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando tamaño en montajes en $servidor: " | tee -a server-remoto.log
     echo " "
     sshpass -p "$clave" ssh $usuario@$servidor df -h | grep /dev/ | tee -a server-remoto.log
     echo " "
     echo "$(date) Mostrando direccion Ip:" | tee -a server-remoto.log
     sshpass -p "$clave" ssh $usuario@$servidor ifconfig | grep cast | tee -a server-remoto.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando Distribucion Linux: " | tee -a server-remoto.log
     sshpass -p "$clave" ssh $usuario@$servidor cat /etc/os-release | tee -a server-remoto.log
     echo "----------------------------------------------------------------------------------" >> server-remoto.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Se realizo conulta de tamaño de puntos de montaje en server: $servidor" | tee -a syslog.log server-remoto.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     ;;
  "- Ver scripts")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de conexiones creadas..." | tee -a syslog.log
	 echo " "
     Dir="scripts_conexiones"
     archivossh=".sh"
     if [[ -d $Dir ]]; then
     echo "$(date) NOTIFICACION - MENSAJE: La carpeta $Dir ya esta creada" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Verificando existencia de archivos de transferencia en $Dir..." | tee -a syslog.log
     echo " "
     fi
     if ls ${Dir}/ | grep ${archivossh} &>/dev/null
	 then
     echo "$(date) NOTIFICACION - MENSAJE: Hay archivos creados en $Dir " | tee -a syslog.log
     echo "----------------------------------------------------------------------"
     echo " "
     echo "MOSTRANDO SCRIPTS DE TRANSFERENCIA DE DATOS: "
     echo " "
     ls $Dir/ | grep $archivossh
     echo " "
     echo "----------------------------------------------------------------------"
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     break
     else
     echo "$(date) NOTIFICACION - MENSAJE: No hay archivos de transferencia creados en la carpeta $Dir" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Regrese al menu principal, y luego al modo '+ Crear nuevo archivo de transferencia' para crear uno" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     fi
	 ;;
  "- Ejecutar scripts")
     Dir="scripts_conexiones"
	 archivossh=".sh"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de ejecucion de scripts..." | tee -a syslog.log
	 echo " "
     echo "----------------------------------------------------------------------"
     echo " "
     echo "MOSTRANDO SCRIPTS DE TRANSFERENCIA DE DATOS: "
     echo " "
     ls $Dir | grep $archivossh
     echo " "
	 echo "----------------------------------------------------------------------"
	 echo " "
     read -p "Desea ejecutar un script de transferencia de datos? s/n: " ejecutar_script
     if [[ $ejecutar_script == "s" ]]; then 
     echo " "
     echo " "
     listdir="ls $Dir | grep  "
     read -p "Copie y pege el script que desea ejecutar, y presione enter..." ejecucion_script
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ejecutando script $ejecucion_script..." | tee -a syslog.log
     echo " "
     bash $Dir/$ejecucion_script
     echo " "
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     fi
     if [[ $ejecutar_script == "n" ]]; then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ha decidido no ejecutar un script" | tee -a syslog.log
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     else
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ha ingresado una opcion invalida" | tee -a syslog.log
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     fi
     ;;
  "+ Crear nuevo archivo de transferencia")
     mkdir -p scripts_conexiones
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo nuevo archivo de transferencia..." | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Este modo creara un script, para transferir datos a un servidor especifico. Una vez creado, sera guardado con los datos proporcionados."
     echo " "
     read -p "Crear el script ahora? s/n: " script_si_no
     if [[ $script_si_no == "s" ]]; then
     echo " "
     echo "Creacion de script de transferencia de datos"
     echo " "
     echo "ATENCION. DATOS MANDATORIOS PARA CORRER ESTE PROGRAMA: "
	 echo " "
     echo "- Nombre de archivo"
	 echo "- Nombre/ip de servidor"
	 echo "- Usuario"
     echo "- Contraseña"
     echo "- Path de origen"
     echo "- Path de destino"
     echo " "
     echo "OPCIONAL - Transferencia de datos con o sin excludion de carpetas"
     echo " "
     read -p "Presione enter para comenzar el asistente para la creacion del script..." enter
     quote="'"
     comilla='"'
     echo " "
     read -p "Nombre del archivo: " archivo 
     echo " "
     read -p "Nombre/ip del Servidor Remoto: " servidor
     echo " "
     read -p "Usuario del servidor remoto: " usuario
     echo " "
     echo "Contraseña de acceso a servidor remoto: " 
     read -s clave
     echo " "
     read -p "Path origen (host local): " pathorigen 
     echo " "
     read -p "Path destino (host remoto): " pathdestino
     echo " "
     read -p "Desea realizar la transferencia excluyendo carpetas y/o archivos? s/n: " script_exclusion_o_no
     fi
     if [[ $script_exclusion_o_no == "s" ]]; then
     archivo_exclusion_datos="_archivo_exclusion_datos.sh"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Generando script de transferencia de datos con exclusion de carpetas/archivos..." | tee -a syslog.log
     echo " " > scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "$(date) NOTIFICACION - MENSAJE: Se creara el archivo $archivo$archivo_exclusion_datos" | tee -a syslog.log
     echo "# SCRIPT DE TRANSFERENCIA DE DATOS CON EXCLUSION DE ARCHIVOS" > scripts_conexiones/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "# DATOS DE CONEXION PARA TRANSFERENCIA DE ARCHIVOS A SERVIDOR: "$servidor >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "quote="$comilla$quote$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo 'comilla='$quote$comilla$quote >> scripts_conexiones/$archivo$archivo_exclusion_datos
	 echo "scripts_conexiones=scripts_conexiones/" >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "servidor="$comilla$servidor$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "usuario="$comilla$usuario$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "clave="$comilla$clave$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "pathorigen="$comilla$pathorigen$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "pathdestino="$comilla$pathdestino$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo " "
	 archivo_carpetas_exclusion=_archivo_datos_a_exluir.txt
	 echo " "
	 read -p "Ingrese la/s carpeta/s y/o archivo/s que seran excluido/s: " carpetasexc
     echo " "
     echo "Mostrando los datos agregados al archivo $archivo_carpetas_exclusion: "
     echo " "
     archivo_carpetas_exclusion="_archivo_carpetas_exclusion.txt"
     for carpeta in $carpetasexc; do
     echo $carpeta
     echo $carpeta >> scripts_conexiones/$archivo$archivo_carpetas_exclusion 
     done
     signopeso="$"
     echo "datos_excluidos_conexiones="$comilla$datos_excluidos_conexiones$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "signopeso="$comilla$signopeso$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "archivo="$comilla$archivo$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "archivo_carpetas_exclusion="$comilla$archivo_carpetas_exclusion$comilla >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "# Instancia de conexion de script "$archivo$archivo_exclusion_datos >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ha sido creado el archivo: $archivo$archivo_carpetas_exclusion" | tee -a syslog.log
	 echo " "
     echo "Las carpetas y/o archivos excluidos se encuentran guardadas en la carpeta: $archivo$archivo_carpetas_exclusion"
     echo " "
     echo 'sshpass -p "$clave" rsync -av --ignore-existing --stats --update --progress --out-format="%t %f" $pathorigen --exclude-from=$scripts_conexiones$archivo$archivo_carpetas_exclusion ssh $usuario@$servidor:$pathdestino' >> scripts_conexiones/$archivo$archivo_exclusion_datos
     echo "$(date) NOTIFICACION - MENSAJE: El script se ha generado dentro de la carpeta: scripts_conexiones" | tee -a syslog.log
     echo " "
     ls -lha scripts_conexiones/ | grep $archivo$archivo_exclusion_datos
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break     
     fi
     if [[ $script_exclusion_o_no == "n" ]]; then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Generando script de transferencia de datos sin exclusion..." | tee -a syslog.log
     echo " " > scripts_conexiones/$archivo.sh
     echo "SCRIPT DE TRANSFERENCIA DE DATOS SIN EXCLUSION DE ARCHIVOS" > scripts_conexiones/$archivo.sh
     echo " " >> scripts_conexiones/$archivo.sh
     echo "DATOS DE CONEXION PARA TRANSFERENCIA DE ARCHIVOS A SERVIDOR: "$servidor >> scripts_conexiones/$archivo.sh
     echo " " >> scripts_conexiones/$archivo.sh
     echo "servidor="$comilla$servidor$comilla >> scripts_conexiones/$archivo.sh
     echo "usuario="$comilla$usuario$comilla >> scripts_conexiones/$archivo.sh
     echo "clave="$comilla$clave$comilla >> scripts_conexiones/$archivo.sh
     echo "pathorigen="$comilla$pathorigen$comilla >> scripts_conexiones/$archivo.sh
     echo "pathdestino="$comilla$pathdestino$comilla >> scripts_conexiones/$archivo.sh
     echo " " >> scripts_conexiones/$archivo.sh
     echo "# Instancia de conexion de script "$archivo.sh >> scripts_conexiones/$archivo.sh
     echo " " >> scripts_conexiones/$archivo.sh
     echo 'sshpass -p "$clave" rsync -av --ignore-existing --stats --update --progress --out-format="%t %f" $pathorigen  ssh $usuario@$servidor:$pathdestino' >> scripts_conexiones/$archivo.sh
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: El script se ha generado dentro de la carpeta: scripts_conexiones" | tee -a syslog.log
     echo " "
     ls -lha scripts_conexiones/ | grep $archivo.sh
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     fi
     if [[ $script_si_no == "n" ]]; then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ha decidido no crear el script de transferencia de datos"  | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..."  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     else
     echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado una opcion valida " | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     fi
     ;;
  "- Verificar variables seteadas y errores")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Variables y errores..." | tee -a syslog.log
	 echo " "
	 echo " "
     if [ -z ${servidor+x} ]; then
     #	 
     echo "$(date) ERROR01 - ATENCION: La variable servidor aun no fue proveida, ingrese al menu Nombre/ip de servidor y provea el nombre del host/ip para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 else
     echo "$(date) OK-01 - variable servidor seteada - El host/ip definido es: '$servidor'. Si desea cambiarlo ingrese al menu Nombre/ip de servidor" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     if [ -z ${usuario+x} ]; then
     echo "$(date) ERROR02 - ATENCION: La variable usuario aun no fue proveida, ingrese al menu Usuario y provea el nombre de usuario del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 else
     echo "$(date) OK-02 - variable usuario seteada - El usuario definido para la conexion es: '$usuario'. Si desea cambiarlo ingrese al menu Usuario" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     if [ -z ${clave+x} ]; then
     echo "$(date) ERROR03 - ATENCION: La variable password aun no fue proveida, ingrese al menu Contraseña y provea la password del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 else
     echo "$(date) OK-03 - variable password seteada - La password ya fue definida. Si desea cambiarla ingrese al menu Contraseña" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     if [ -z ${pathorigen+x} ]; then
     echo "$(date) ERROR04 - ATENCION: La variable pathorigen aun no fue proveida, ingrese al menu path de origen y provea la ruta de origen del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 else
     echo "$(date) OK-04 - variable pathorigen seteada - La ruta de origen es: $pathorigen. Si desea cambiarla ingrese al menu path de origen" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     if [ -z ${pathdestino+x} ]; then
     echo "$(date) ERROR05 - ATENCION: La variable pathdestino aun no fue proveida, ingrese al menu path de destino y provea la ruta de destino del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 else
     echo "$(date) OK-05 - variable pathdestino seteada - La ruta de destino es: $pathdestino. Si desea cambiarla ingrese al menu path de destino" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi 
     if [ -f "carpetas.log" ]; then
     echo "$(date) OK-06 - El archivo carpetas.log  ya esta creado"  | tee -a syslog.log
	 echo " "
	 echo "$(date)$(date) NOTIFICACION - MENSAJE: Se realizo consulta de variables seteadas y errores " | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     echo "----------------------------------------------------------------------------------"
	 else
     echo "ATENCION: El archivo carpetas.log no ha sido creado aun. Para ejecutar el programa de transferencia de datos excluyendo carpetas, debe ser generado. Ingrese al menu Excluir carpeta/s y/o archivos" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 echo "$(date)$(date) NOTIFICACION - MENSAJE: Se realizo consulta de variables seteadas y errores" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
     ;;
  "- Nombre/ip de servidor")
	 echo  " "
 	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo servidor..." | tee -a syslog.log
	 if [ -z "$servidor" ]; then
 	 echo "$(date) NOTIFICACION - MENSAJE: La variable servidor no esta seteada" | tee -a syslog.log
	 echo " "
	 else
	 echo "$(date) NOTIFICACION - MENSAJE: La variable servidor ya esta seteada como: $servidor" | tee -a syslog.log
	 fi
	 echo " "
	 read -p "Desea configurar la variable servidor ahora?: s/n... " si_o_no
	 if [[  $si_o_no == "s" ]] ;then
 	 echo " "
	 read -p "Ingrese el nombre (debe resolver DNS) o ip  del servidor remoto... " servidor
 	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se ingreso un nuevo registro para la variable servidor" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: La variable servidor esta seteada como: $servidor" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[  $si_o_no == "n" ]] ;then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha seteado la variable servidor" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 else
	 echo " "
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
     ;;
  "- Usuario")
    echo  " "
	echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Usuario..." | tee -a syslog.log
	if [ -z "$usuario" ]; then
	echo "$(date) NOTIFICACION - MENSAJE: La variable Usuario no esta seteada" | tee -a syslog.log
	echo " "
	else
	echo "$(date) NOTIFICACION - MENSAJE: La variable Usuario ya esta seteada como: $usuario" | tee -a syslog.log
	fi
	echo " "
	read -p "Desea configurar la variable Usuario ahora?: s/n... " si_o_no
	if [[  $si_o_no == "s" ]] ;then
	echo " "
	read -p "Ingrese el nombre de Usuario del server remoto... " usuario
	echo " "
	echo "$(date) NOTIFICACION - MENSAJE: Se ingreso un nuevo registro para la variable usuario" | tee -a syslog.log
	echo " "
	echo "$(date) NOTIFICACION - MENSAJE: La variable Usuario esta seteada como: $usuario" | tee -a syslog.log
	echo " "
	read -p "Presione enter para desplegar el menu... " enter
	break
	fi
	if [[  $si_o_no == "n" ]] ;then
	echo " "
	echo "$(date) NOTIFICACION - MENSAJE: No se ha seteado la variable Usuario" | tee -a syslog.log
	read -p "Presione enter para desplegar el menu... " enter
	break
	else
	echo " "
	echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	echo " "
	echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	echo " "
	read -p "Presione enter para desplegar el menu... " enter
	break
	fi
	 ;;
  "- Contraseña")
     echo  " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Contraseña..." | tee -a syslog.log
     if [ -z "$clave" ]; then
     echo "$(date) NOTIFICACION - MENSAJE: La variable Contraseña no esta seteada" | tee -a syslog.log
     echo " "
     else
     echo "$(date) NOTIFICACION - MENSAJE: La variable Contraseña ya esta seteada" | tee -a syslog.log
     fi
	 echo " "
     read -p "Desea configurar la variable Contraseña ahora?: s/n... " si_o_no
     if [[  $si_o_no == "s" ]] ;then
     echo " "
     echo "Ingrese la Contraseña del server remoto... "
	 read -s clave
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Se ingreso un nuevo registro para la variable Contraseña" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: La variable Contraseña quedo seteada. Por razones de seguridad, no puede ser mostrada." | tee -a syslog.log
     echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     fi
     if [[  $si_o_no == "n" ]] ;then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No se ha seteado la variable Contraseña" | tee -a syslog.log
     break
     else
     echo " "
     echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 read -p "Presione enter para desplegar el menu... " enter
     break
     fi 
	 ;;
  "- Path de origen")
	 echo  " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo pathorigen..." | tee -a syslog.log
     if [ -z "$pathorigen" ]; then
     echo "$(date) NOTIFICACION - MENSAJE: La variable pathorigen no esta seteada" | tee -a syslog.log
     echo " "
     else
     echo "$(date) NOTIFICACION - MENSAJE: La variable pathorigen ya esta seteada como: $pathorigen" | tee -a syslog.log
     fi
     read -p "Desea configurar la variable pathorigen ahora?: s/n... " si_o_no
     if [[  $si_o_no == "s" ]] ;then
     echo " "
     read -p "Ingrese path de origen para pasar datos al server remoto... " pathorigen
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Se ingreso un nuevo registro para la variable pathorigen" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: La variable pathorigen esta seteada como: $pathorigen" | tee -a syslog.log
	 echo " "
     read -p "Presione enter para desplegar el menu... " enter
	 break
     fi
     if [[  $si_o_no == "n" ]] ;then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No se ha seteado la variable pathorigen" | tee -a syslog.log
	 echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 read -p "Presione enter para desplegar el menu... " enter
     break
     else
     echo " "
     echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
     break
     fi
     ;;

  "- Path de destino")
	 echo  " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo pathdestino..." | tee -a syslog.log
	 if [ -z "$pathdestino" ]; then
	 echo "$(date) NOTIFICACION - MENSAJE: La variable pathdestino no esta seteada" | tee -a syslog.log
	 echo " "
	 else
	 echo "$(date) NOTIFICACION - MENSAJE: La variable pathdestino ya esta seteada como: $pathdestino" | tee -a syslog.log
	 fi
	 read -p "Desea configurar la variable pathdestino ahora?: s/n... " si_o_no
	 if [[  $si_o_no == "s" ]] ;then
 	 echo " "
	 read -p "Ingrese path de destino para pasar datos al server remoto... " pathdestino
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se ingreso un nuevo registro para la variable pathdestino" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: La variable pathdestino esta seteada como: $pathdestino" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[  $si_o_no == "n" ]] ;then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha seteado la variable pathdestino" | tee -a syslog.log
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 read -p "Presione enter para desplegar el menu... " enter
     break
	 else
	 echo " "
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	;;
  "- Excluir carpeta/s y/o archivos")
     archivo_carpetas="carpetas.log"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo  exclusion de carpeta/s..." | tee -a syslog.log
	 echo " "
     if [ -f "$archivo_carpetas" ]; then
     echo " "   
     echo "$(date) NOTIFICACION - MENSAJE: El archivo $archivo_carpetas ya esta creado" | tee -a syslog.log
     echo " "
	 echo "- v - Ver el archivo"
	 echo "- e - Editar el archivo"
	 echo "- n - No editar el archivo y salir"
	 echo " "
	 read -p "Ingrese una opcion del menu y presione enter: " administrar_archivo
	 fi
	 if [[ $administrar_archivo == "v" ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: ingresa a modo visualizacion del archivo carpetas.log"  | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Mostrando contenido del archivo carpetas.log" | tee -a syslog.log
	 echo " "
	 cat $archivo_carpetas
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ $administrar_archivo == "e" ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: ingresa a modo edicion de archivo carpetas.log"  | tee -a syslog.log
 	 echo " "
	 echo "Ingrese el nombre de las carpetas a exlcuir una debajo de la otra, y guarde los cambios con CTRL+X al terminar."
	 echo " "
	 read -p "Presione enter para editar el archivo con el editor nano cuando este listo..." enter
	 nano carpetas.log
	 echo "$(date) NOTIFICACION - MENSAJE: salida de modo edicion de archivo carpetas.log" | tee -a syslog.log
	 echo " "
	 for carpeta in $carpetasexc; do
	 echo $carpeta
	 echo $carpeta >> carpetas.log
	 done
	 echo "$(date) NOTIFICACION - MENSAJE: Las carpetas y/o archivos excluidos se encuentran guardadas en la carpeta carpetas.log"  | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ $administrar_archivo == "n" ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ha decidido no editar el archivo" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[  $administrar_archivo == " " ]] ;then
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ ! -f "$archivo_carpetas" ]]; then
	 echo "$(date) NOTIFICACION - MENSAJE: No esta creado el archivo carpetas.log." | tee -a syslog.log
	 echo " "
	 read -p "Desea crearlo ahora? s/n... " crear_o_no
	 fi
	 if [[ $crear_o_no == " " ]]; then
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ $crear_o_no == "s" ]]; then
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se creara el archivo carpetas.log" | tee -a syslog.log
	 touch $archivo_carpetas
	 echo " "
	 read -p "Ingrese la/s carpeta/s y/o archivo/s que seran excluido/s: " carpetasexc
     echo " "
     echo "Mostrando los datos agregados al archivo $archivo_carpetas: "
     echo " "
     for carpeta in $carpetasexc; do
     echo $carpeta
     echo $carpeta >> carpetas.log
     done
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ha sido creado el archivo carpetas.log" | tee -a syslog.log
	 echo " "
     echo "Las carpetas y/o archivos excluidos se encuentran guardadas en la carpeta: carpetas.log"
	 echo " "
     ls -lha carpetas.log
	 echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     fi
	 if [[ $crear_o_no == "n" ]]; then
	 echo "$(date) NOTIFICACION - MENSAJE: El archivo carpetas.log no fue creado" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 else
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 ;; 
  "- Regenerar archivo carpetas.log")
     echo " "
	 echo "$(date) ATENCION: Ingresando a modo de regeneracion de archivo carpetas.log..." | tee -a syslog.log
	 if [[ ! -f "carpetas.log" ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: El archivo carpetas.log no puede ser regenerado porque no existe. Ingrese al menu 'Excluir carpeta/s y/o archivos' para crearlo." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ -f "carpetas.log" ]]; then
	 echo " "
	 echo "$(date) ATENCION: Esta a punto de regenerar el archivo carpetas.log. El archivo se eliminira, junto con todo su contenido, y sera regeneado." | tee -a syslog.log
	 echo " "
	 read -p "Desea regenerarlo ahora? s/n... " eliminar_o_no
	 fi
	 if [[  $eliminar_o_no == "s" ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Regenerando el archivo carpetas.log..." | tee -a syslog.log
	 rm carpetas.log
	 echo "$(date) NOTIFICACION - MENSAJE: El archivo carpetas.log ha sido regenerado" | tee -a syslog.log
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 touch carpetas.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ $eliminar_o_no == "n" ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: El archivo carpetas.log ha no sido regenerado" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 else
	 echo " "
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 ;;
  "- Ejecutar programa excluyendo carpetas y archivos")
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de transferencia con exclusion de datos..." | tee -a syslog.log
 	 echo " "
	 echo "ATENCION. DATOS MANDATORIOS PARA CORRER ESTE PROGRAMA: "
	 echo " "
	 echo "- Nombre/ip de servidor"
	 echo "- Usuario"
     echo "- Contraseña"
     echo "- Path de origen"
     echo "- Path de destino"
     echo "- Archivo carpetas.log creado con datos a exlcuir"
     echo " "
	 echo "Todos los errores y variables configuradas pueden verse en el menu: Verificar variables seteadas o errores."
	 echo "A continuacion, el programa verificara los errores en forma secuencial, y de encontrar algun dato faltante, le solicitara completarlo."
	 echo " "
	 read -p "Presione enter para continuar ahora... " enter
	 echo "$(date) Verificando si faltan datos o hay errores para ejecutar el programa..." | tee -a syslog.log
	 if [ -z ${servidor+x} ]; then

	 echo "$(date) ERROR01 - ATENCION: La variable servidor aun no fue proveida, ingrese al menu Nombre/ip de servidor y provea el nombre del host/ip para poder operar" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para volver al menu principal..." enter
	 break
	 else 

	 echo " "
	 echo "$(date) OK-01 - variable servidor seteada - El host/ip definido es: '$servidor'. Si desea cambiarlo ingrese al menu Nombre/ip de servidor" | tee -a syslog.log 
	 fi
	 if [ -z ${usuario+x} ]; then 

	 echo "$(date) ERROR02 - ATENCION: La variable usuario aun no fue proveida, ingrese al menu Usuario y provea el nombre de usuario del servidor para poder operar" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para volver al menu principal..." enter
	 break
	 else 
	 echo " "

	 echo "$(date) OK-02 - variable usuario seteada - El usuario definido para la conexion es: '$usuario'. Si desea cambiarlo ingrese al menu Usuario" | tee -a syslog.log
	 fi
	 if [ -z ${clave+x} ]; then 

	 echo " "
	 echo "$(date) ERROR03 - ATENCION: La variable password aun no fue proveida, ingrese al menu Contraseña y provea la password del servidor para poder operar" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para volver al menu principal..." enter
	 break
	 else 
	 echo " "

	 echo "$(date) OK-03 - variable password seteada - La password ya fue definida. Si desea cambiarla ingrese al menu Contraseña" | tee -a syslog.log
	 fi
	 if [ -z ${pathorigen+x} ]; then

	 echo " "
	 echo "$(date) ERROR04 - ATENCION: La variable pathorigen aun no fue proveida, ingrese al menu path de origen y provea la ruta de origen del servidor para poder operar" | tee -a syslog.log
 	 echo " "
	 read -p "Presione enter para volver al menu principal..." enter
	 break
	 else 
	 echo " "

	 echo "$(date) OK-04 - variable pathorigen seteada - La ruta de origen es: $pathorigen. Si desea cambiarla ingrese al menu path de origen" | tee -a syslog.log
	 fi
	 if [ -z ${pathdestino+x} ]; then 

	 echo " "
	 echo "$(date) ERROR05 - ATENCION: La variable pathdestino aun no fue proveida, ingrese al menu path de destino y provea la ruta de destino del servidor para poder operar" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para volver al menu principal..." enter
	 break
	 else 
	 echo " "

	 echo " "
	 echo "$(date) OK-05 - variable pathdestino seteada - La ruta de destino es: $pathdestino. Si desea cambiarla ingrese al menu path de destino" | tee -a syslog.log
	 fi
	 archivo_carpetas=carpetas.log
	 if [ ! -f "$archivo_carpetas" ]; then
     echo " "
	 echo "$(date) ERROR06 - ATENCION: El archivo carpetas.log no ha sido creado aun. Por favor ingrese al menu 'Excluir carpeta/s y/o archivos' y provea las carpetas que desee excluir." | tee -a syslog.log
	 read -p "Presione enter para volver al menu principal..." enter
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 break
	 else
	 echo "$(date) OK-06 - El archivo $archivo_carpetas existe:" | tee -a syslog.log
	 ls -lha carpetas.log
	 echo " "
	 echo "$(date) Listando contenido de archivo $archivo_carpetas:" | tee -a syslog.log
	 echo " " | tee -a syslog.log
	 cat carpetas.log
	 echo " " | tee -a syslog.log 
	 
	 echo "$(date) NOTIFICACION - MENSAJE: No se han encontrado errores. Todos los datos fueron proporcionados" | tee -a syslog.log
	 echo " "
	 echo "Se utilizara el archivo con los contenidos para ejecutar la transferencia de datos"
	 echo " "
	 echo " " >> rsync_log.log
	 date >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo " "
	 echo "Proceder con el programa y transferir los datos a $servidor?"
	 read -p "s/n?" proceder_o_salir
	 fi
	 if [[ $proceder_o_salir == "s" ]]; then
	 echo "Iniciando transferencia de datos hacia $servidor..." >> rsync_log.log
	 echo " " >> rsync_log.log
	 sshpass -p "$clave" rsync -av --ignore-existing --stats --update --progress --out-format="%t %f" $pathorigen --exclude-from='carpetas.log' ssh $usuario@$servidor:$pathdestino
	 echo " " >> rsync_log.log
	 echo "Listando contenido de carpeta $pathdestino..." >> rsync_log.log
	 echo " " >> rsync_log.log
	 sshpass -p "$clave" ssh $usuario@$servidor ls -lha $pathdestino >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo "Cantidad de archivos en $pathdestino @$servidor: " >> rsync_log.log
	 echo " " >> rsync_log.log
	 sshpass -p "$clave" ssh $usuario@$servidor ls -lha $pathdestino | wc -l >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo "Tamaño de las 10 ccarpetas mas grandes en $pathdestino @$servidor: " >> rsync_log.log
	 sshpass -p "$clave" ssh $usuario@$servidor du -h $pathdestino | sort -hr | tail -n +1 | head -$1 >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo "------------------------------------------------" >> rsync_log.log
 	 echo " " >> rsync_log.log
 	 echo "Finalizacion del script en fecha y hora: " >> rsync_log.log
	 echo " " >> rsync_log.log
	 date >> rsync_log.log
	 echo "Programa finalizado, presione enter para salir de este modo..."
	 read enter
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 break
	 fi
	 if [[ $proceder_o_salir == "n" ]]; then
	 echo "$(date) NOTIFICACION - MENSAJE: Ha decidido no ejecutar el programa " | tee -a syslog.log 
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..."
	 break
	 else
	 echo "$(date) ERROR - No ha seleccionado una opcion valida" | tee -a syslog.log
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." >>  syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
     ;;
   "- Iniciar programa sin excluir una carpeta ni archivo")
     echo "Ha decidido no exluir carpetas"
	 echo " "
	 echo "ATENCION. DATOS MANDATORIOS PARA CORRER ESTE PROGRAMA: "
	 echo " "
	 echo "- Nombre/ip de servidor"
	 echo "- Usuario"
     echo "- Contraseña"
     echo "- Path de origen"
     echo "- Path de destino"
     echo " "
	 echo "Todos los errores y variables configuradas pueden verse en el menu: Verificar variables seteadas o errores."
	 echo "A continuacion, el programa verificara los errores en forma secuencial, y de encontrar algun dato faltante, le solicitara completarlo."
	 echo " "
	 read -p "Presione enter para continuar ahora... " enter
	 echo "$(date) Verificando si faltan datos o hay errores para ejecutar el programa..." | tee -a syslog.log
     if [ -z ${servidor+x} ]; then   
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de transferencia sin exclusion de datos..." | tee -a syslog.log
     echo " " 
     echo "$(date) ERROR01 - ATENCION: La variable servidor aun no fue proveida, ingrese al menu Nombre/ip de servidor y provea el nombre del host/ip para poder operar" | tee -a syslog.log
     echo " "
     read -p "Presione enter para volver al menu principal..." enter
     break
     else 
     echo " "   
     echo "$(date) OK-01 - variable servidor seteada - El host/ip definido es: '$servidor'. Si desea cambiarlo ingrese al menu Nombre/ip de servidor" | tee -a syslog.log
     fi
     if [ -z ${usuario+x} ]; then     
     echo " "
     echo "$(date) ERROR02 - ATENCION: La variable usuario aun no fue proveida, ingrese al menu Usuario y provea el nombre de usuario del servidor para poder operar" | tee -a syslog.log
     echo " "
     read -p "Presione enter para volver al menu principal..." enter
     break
     else 
     echo " "
     echo "$(date) OK-02 - variable servidor seteada - El usuario definido para la conexion es: '$usuario'. Si desea cambiarlo ingrese al menu Usuario" | tee -a syslog.log
     fi
     if [ -z ${clave+x} ]; then    
     echo "$(date) ERROR03 - ATENCION: La variable password aun no fue proveida, ingrese al menu Contraseña y provea la password del servidor para poder operar" | tee -a syslog.log
     echo " "
     read -p "Presione enter para volver al menu principal..." enter
     break
     else 
     echo " "
     echo "$(date) OK-03 - variable password seteada - La password ya fue definida. Si desea cambiarla ingrese al menu Contraseña" | tee -a syslog.log
     fi
     if [ -z ${pathorigen+x} ]; then
     echo " " 
     echo "$(date) ERROR04 - ATENCION: La variable pathorigen aun no fue proveida, ingrese al menu path de origen y provea la ruta de origen del servidor para poder operar" | tee -a syslog.log
     echo " "
     read -p "Presione enter para volver al menu principal..." enter
     break
     else 
     echo " "
     echo "$(date) OK-04 - variable pathorigen seteada - La ruta de origen es: $pathorigen. Si desea cambiarla ingrese al menu path de origen" | tee -a syslog.log
     fi
     if [ -z ${pathdestino+x} ]; then 
     echo " "
     echo "$(date) ERROR05 - ATENCION: La variable pathdestino aun no fue proveida, ingrese al menu path de destino y provea la ruta de destino del servidor para poder operar" | tee -a syslog.log
     echo " "
     read -p "Presione enter para volver al menu principal..." enter
     break
     else 
     echo " "
     echo "$(date) OK-05 - variable pathdestino seteada - La ruta de destino es: $pathdestino. Si desea cambiarla ingrese al menu path de destino" | tee -a syslog.log
     fi
	 echo 
     echo "$(date) NOTIFICACION - MENSAJE: No se han encontrado errores. Todos los datos fueron proporcionados" | tee -a syslog.log
	 echo " "
     echo " " >> rsync_log.log
     date >> rsync_log.log
     echo " " >> rsync_log.log
     echo " "
	 echo "Proceder con el programa y transferir los datos a $servidor?"
     read -p "s/n?" proceder_o_salir
	 if [[ $proceder_o_salir == "s" ]]; then
	 echo " "
     echo "Iniciando transferencia de datos hacia $servidor..." >> rsync_log.log
     echo " " >> rsync_log.log
     sshpass -p "$clave" rsync -av --ignore-existing --stats --update --progress --out-format="%t %f" $pathorigen  ssh $usuario@$servidor:$pathdestino
     echo " " >> rsync_log.log
     echo "Listando contenido de carpeta $pathdestino..." >> rsync_log.log
     echo " " >> rsync_log.log
     sshpass -p "$clave" ssh $usuario@$servidor ls -lha $pathdestino >> rsync_log.log
     echo " " >> rsync_log.log
     echo "Cantidad de archivos en $pathdestino @$servidor: " >> rsync_log.log
     echo " " >> rsync_log.log
     sshpass -p "$clave" ssh $usuario@$servidor ls -lha $pathdestino | wc -l >> rsync_log.log
     echo " " >> rsync_log.log
     echo "Tamaño de las 10 ccarpetas mas grandes en $pathdestino @$servidor: " >> rsync_log.log
     sshpass -p "$clave" ssh $usuario@$servidor du -h $pathdestino | sort -hr | tail -n +1 | head -$1 >> rsync_log.log
     echo " " >> rsync_log.log
     echo "------------------------------------------------" >> rsync_log.log
     echo " " >> rsync_log.log
     echo "Finalizacion del script en fecha y hora: " >> rsync_log.log
     echo " " >> rsync_log.log
     date >> rsync_log.log
     echo " "
     echo "Programa finalizado, presione enter para salir de este modo..."
     read enter
	 fi
	 if [[ $proceder_o_salir == "n" ]]; then
	 echo "$(date) NOTIFICACION - MENSAJE: Ha decidido no ejecutar el programa" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
	 fi
     ;;
	"- Ver log de transferencias rsync_log")
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de visualizacion de log de transferencias..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Presione enter para ver el contenido del archivo ahora..."
	 cat rsync_log.log
	 echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de visualizacion de log de transferencias..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
	 ;;
    "- Ver log de eventos syslog.log")
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de visualizacion de log de eventos de sistema..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Presione enter para ver el contenido del archivo ahora..."
	 cat syslog.log
	 echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de visualizacion de log de transferencias..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
	 ;;
	*)
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado una opcion valida." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log 
	 break
	 ;;
  esac
done
done