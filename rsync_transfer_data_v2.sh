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
mkdir -p /home/$USER/Desktop
mkdir -p /home/$USER/Desktop/myfiles
mkdir -p /home/$USER/Desktop/myfiles/Tecnologia
mkdir -p /home/$USER/Desktop/myfiles/Tecnologia/Ubuntu
mkdir -p /home/$USER/Desktop/myfiles/Tecnologia/Ubuntu/My_Bash_scripts
mkdir -p /home/$USER/Desktop/myfiles/Tecnologia/Ubuntu/My_Bash_scripts/rsync/
mkdir -p /home/$USER/Desktop/myfiles/Tecnologia/Ubuntu/My_Bash_scripts/rsync/scripts_conexiones_exclusion_datos
mkdir -p /home/$USER/Desktop/myfiles/Tecnologia/Ubuntu/My_Bash_scripts/rsync/custom_scripts_logs
cp rsync_transfer_data_v2.sh /home/$USER/Desktop/myfiles/Tecnologia/Ubuntu/My_Bash_scripts/rsync/ &>/dev/null
path_programa="/home/$USER/Desktop/myfiles/Tecnologia/Ubuntu/My_Bash_scripts/rsync/"
cd $path_programa
while true; 
do
echo "######################################################"
echo "   * Programa de consulta y transferencia de datos *  "
echo " "
echo "   Menu principal - Seleccione una opcion para operar "
echo "######################################################"
echo " "
opciones=("- Ver tamaño de montajes en host local" "- Ver tamaño de montajes en host remoto" "- Ver scripts" "- Ver archivos de exclusion de datos" "- Editar scripts" "- Editar archivos de exclusion de datos" "- Eliminar scripts" "- Eliminar archivos de exclusion de datos" "- Ejecutar scripts" "+ Crear nuevo script de transferencia hacia Servidor Remoto" "+ Crear nuevo script local de transferencia hacia directorio/disco " "- Verificar variables seteadas y errores" "- Nombre/ip de servidor" "- Puerto de conexion del servidor" "- Usuario" "- Contraseña" "- Path de origen" "- Path de destino" "- Excluir carpeta/s y/o archivos" "- Regenerar archivo carpetas.log" "- Ejecutar programa excluyendo carpetas y archivos" "- Iniciar programa sin excluir una carpeta ni archivo" "- Ver log de transferencias rsync_log" "- Ver log de eventos syslog.log" "- Ver logs de scripts ejecutados" "- Eliminar logs de scripts ejecutados")
select opcion in "${opciones[@]}"
do
  case $opcion in
  "- Ver tamaño de montajes en host local")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Consulta de montajes.." | tee -a syslog.log
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando tamaño de montajes en Server: $(hostname)" | tee -a server-local.log
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
	   if [ -z ${puerto+x} ]; then
     echo "$(date) ERROR-PUERTO - ATENCION: La variable puerto aun no fue proveida, ingrese al menu puerto y el puerto de conexion del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
     break
     else
     echo "$(date) OK-PUERTO-SETEADO - variable puerto seteada - Si desea cambiarlo ingrese al menu puerto de conexion" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 fi
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No se han encontrado errores" | tee -a syslog.log
     echo " "
     read -p "Presione enter para mostrar puntos de montaje en servidor $servidor" enter
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando tamaño en montajes en $servidor: " | tee -a server-remoto.log
     echo " "
     sshpass -p "$clave" ssh $usuario@$servidor -p$puerto df -h | grep /dev/ | tee -a server-remoto.log
     echo " "
     echo "$(date) Mostrando direccion Ip:" | tee -a server-remoto.log
     sshpass -p "$clave" ssh $usuario@$servidor -p$puerto ifconfig | grep cast | tee -a server-remoto.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Mostrando Distribucion Linux: " | tee -a server-remoto.log
     sshpass -p "$clave" ssh $usuario@$servidor -p$puerto cat /etc/os-release | tee -a server-remoto.log
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
     Dir="scripts_conexiones_exclusion_datos"
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
	 else
     echo "$(date) NOTIFICACION - MENSAJE: No hay archivos de transferencia creados en la carpeta $Dir" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Regrese al menu principal, y luego al modo '+ Crear un nuevo script de transferencia' para crear uno" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 read -p "Copie y pegue un script para ver parametros y datos del mismo: " datos_script
	 echo " "
	 if ls ${Dir}/ | grep ${datos_script} &>/dev/null
	 then
	 echo "MOSTRANDO DATOS DEL SCRIPT: $datos_script"
	 echo " "
	 cat $Dir/$datos_script | grep servidor=
	 echo " "
	 cat $Dir/$datos_script | grep usuario=
	 echo " "
	 echo "Path del servidor local, ruta a partir de donde se transfieren los datos:"
	 echo " "
	 cat $Dir/$datos_script | grep pathorigen=
	 echo " "
	 echo "Path del servidor remoto, ruta hacia donde se transfieren los datos:"
	 echo " "
	 cat $Dir/$datos_script | grep pathdestino=
	 echo " "
	 cat $Dir/$datos_script | grep "# Este script excluira los datos descritos en el archivo de texto:"
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo visualizacion" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 else
	 echo "$(date) ERROR: No hay scripts con esa descripcion en la carpeta scripts_conexiones_exclusion_datos" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo visualizacion" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     fi
	 ;;
  "- Editar scripts")
     mypwd=${PWD}/
     Dir="scripts_conexiones_exclusion_datos"
     archivossh=".sh"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de ejecucion de edicion de scripts..." | tee -a syslog.log
	 echo " "
	 echo "MOSTRANDO SCRIPTS DE TRANSFERENCIA DE DATOS: "
     echo " "
     ls $Dir/ | grep $archivossh
     echo " "
	 read -p "Copie y pegue, o typee el script que desea editar, y presione enter para acceder al editor..." script_edicion
	 if [[ $script_edicion == "" ]];
	 then
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado nada" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ls ${Dir}/ | grep ${script_edicion} &>/dev/null
	 then 
	 nano $mypwd$Dir/$script_edicion
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo edicion" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ! ls ${Dir}/ | grep ${script_edicion} &>/dev/null
	 then
	 echo " "
	 echo "(date) NOTIFICACION - MENSAJE: No existe un script con el dato proporcionado." | tee -a syslog.log
	 echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 ;;
  "- Editar archivos de exclusion de datos")
     mypwd=${PWD}/
     Dir="scripts_conexiones_exclusion_datos"
     archivostxt="_exclusion_datos_local.txt"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de edicion de archivos de exclusion de datos..." | tee -a syslog.log
	 echo " "
	 echo "MOSTRANDO ARCHIVOS DE EXCLUSION DE DATOS: "
     echo " "
     ls $Dir/ | grep $archivostxt
     echo " "
	 read -p "Copie y pegue, o typee el archivo de exclusion de datos que desea editar, y presione enter para acceder al editor..." exclusion_edicion
	 if [[ $exclusion_eliminacion == "" ]];
	 then
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado nada" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ls ${Dir}/ | grep ${exclusion_edicion} &>/dev/null
	 then 
	 nano $mypwd$Dir/$exclusion_edicion
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo edicion de archivos de exclusion de datos" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ! ls ${Dir}/ | grep ${exclusion_edicion} &>/dev/null
	 then
	 echo " "
	 echo "(date) NOTIFICACION - MENSAJE: No existe un archivo de exclusion de datos con el dato: $exclusion_edicion" | tee -a syslog.log
	 echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
     ;;
  "- Eliminar scripts")
     mypwd=${PWD}/
     Dir="scripts_conexiones_exclusion_datos"
     archivossh=".sh"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de eliminacion de scripts..." | tee -a syslog.log
	 echo " "
	 echo "MOSTRANDO SCRIPTS DE TRANSFERENCIA DE DATOS: "
     echo " "
     ls $Dir/ | grep $archivossh
     echo " "
	 read -p "Copie y pegue, o typee el script que desea eliminar, y presione enter. Para eliminar multiples scripts, copielos separados por espacios: " script_eliminacion
	 
	 if ! ls $mypwd${Dir}/ | grep $archivossh &>/dev/null
	 then
	 echo "$(date) NOTIFICACION - MENSAJE: No hay scripts para eliminar en la carpeta $Dir" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo eliminacion de scripts" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ls $mypwd${Dir}/ | grep $archivossh &>/dev/null
	 then
	 if [[ $script_eliminacion == "" ]];
	 then
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado nada" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 for script in $script_eliminacion;
	 do
	 if ls $mypwd${Dir}/$script &>/dev/null
	 then
	 rm $mypwd$Dir/$script
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se elimino el script: $script" | tee -a syslog.log
     echo " "
	 else
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: No existe un script con nombre: $script." | tee -a syslog.log
     echo " "
	 fi
	 done
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo eliminacion de scripts" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
     ;;
  "- Eliminar archivos de exclusion de datos")
     mypwd=${PWD}/
     Dir="scripts_conexiones_exclusion_datos"
     archivostxt="_exclusion_datos_local.txt"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de eliminacion de scripts..." | tee -a syslog.log
	 echo " "
	 echo "MOSTRANDO ARCHIVOS DE EXCLUSION DE DATOS: "
     echo " "
     ls $Dir/ | grep $archivostxt
     echo " "
	 read -p "Copie y pegue, o typee el script que desea eliminar, y presione enter. Para eliminar multiples scripts, copielos separados por espacios: " exclusion_eliminacion
	 
	 if ! ls $mypwd${Dir}/ | grep $archivostxt &>/dev/null
	 then
	 echo "$(date) NOTIFICACION - MENSAJE: No hay archivos de exclusion de datos para eliminar en la carpeta $Dir" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo eliminacion de archivos de exclsuion de datos" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ls $mypwd${Dir}/ | grep $archivostxt &>/dev/null
	 then
	 if [[ $exclusion_eliminacion == "" ]];
	 then
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado nada" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 for exclusion in $exclusion_eliminacion;
	 do
	 if ls $mypwd${Dir}/$exclsuion &>/dev/null
	 then
	 rm $mypwd$Dir/$exclusion
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se elimino el archivo de exclusion de datos: $exclusion" | tee -a syslog.log
     echo " "
	 else
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: No existe un archivo de exclusion de datos con el nombre: $exclusion." | tee -a syslog.log
     echo " "
	 fi
	 done
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo eliminacion de archivos de exclusion de datos" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
     ;;
  "- Ejecutar scripts")
     custom_scripts_logs="custom_scripts_logs"
     mkdir -p $custom_scripts_logs
     Dir="scripts_conexiones_exclusion_datos"
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
	 if [[ $ejecutar_script == " " ]]; then
	 echo "$(date) NOTIFICACION - MENSAJE: No ha ingresado una opcion valida" | tee -a syslog.log
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
     if [[ $ejecutar_script == "s" ]]; then 
     echo " "
     listdir="ls $Dir | grep  "
     read -p "Copie y pege un script de la lista que desea ejecutar, o typee el nombre del mismo, y presione enter..." ejecucion_script
     echo " "
	 fi
	 if [[ $ejecutar_script == "n" ]]; then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ha decidido no ejecutar un script" | tee -a syslog.log
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
     fi
	 if ls ${Dir}/ | grep ${ejecucion_script} &>/dev/null
	 then
	 echo "----------------------------------------------------------------------"
	 echo " "
	 echo "MOSTRANDO DATOS DEL SCRIPT: $datos_script"
	 echo " "
	 cat $Dir/$ejecucion_script | grep servidor=
	 echo " "
	 cat $Dir/$ejecucion_script | grep usuario=
	 echo " "
	 echo "Path del servidor local, ruta a partir de donde se transfieren los datos:"
	 echo " "
	 cat $Dir/$ejecucion_script | grep pathorigen=
	 echo " "
	 echo "Path del servidor remoto, ruta hacia donde se transfieren los datos:"
	 echo " "
	 cat $Dir/$ejecucion_script | grep pathdestino=
	 echo " "
	 cat $Dir/$ejecucion_script | grep "# Este script excluira los datos descritos en el archivo de texto:"
	 echo " "
	 echo "---------------------------------------------------------------------"
	 echo " "
	 read -p "Presione enter para comenzar a ejecutar el script ahora..."
	 echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ejecutando script $ejecucion_script..." | tee -a syslog.log
	 echo "---------------------------------------------------------------------" >> rsync_log.log
     echo " " >> rsync_log.log
	 echo "Inicio de ejecucion de script: " >> rsync_log.log
	 echo " " >> rsync_log.log
	 date >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo "Iniciando transferencia de datos..." | tee -a rsync_log.log
	 echo " " >> rsync_log.log
	 cat $Dir/$ejecucion_script | grep servidor= >> rsync_log.log
	 echo " " >> rsync_log.log
     bash $Dir/$ejecucion_script | tee -a rsync_log.log
	 echo " " >> rsync_log.log
	 echo "Fin de ejecucion de script: " >> rsync_log.log
	 echo " " >> rsync_log.log
	 date >> rsync_log.log
     echo " "
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo visualizacion" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ! ls ${Dir}/ | grep ${ejecucion_script} &>/dev/null
	 then
	 echo "$(date) ERROR: No es posible continuar el programa con el input proporcionado. Siga las instrucciones del programa, y proporcione un script valido de la lista cuando se le solicite." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Fin modo ejecucion" | tee -a syslog.log
     echo "----------------------------------------------------------------------"
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
  "- Ver archivos de exclusion de datos")
     Dir="scripts_conexiones_exclusion_datos/"
     archivostxt=".txt"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de visualizacion de archivos de exclusion de datos..." | tee -a syslog.log
     echo " "
	 if ls ${Dir}/ | grep ${archivostxt} &>/dev/null
	 then
     echo "----------------------------------------------------------------------"
     echo " "
     echo "MOSTRANDO ARCHIVOS DE EXCLUCION DE DATOS: "
     echo " "
     ls $Dir/ | grep $archivostxt
     echo " "
     echo "----------------------------------------------------------------------"
     echo " "
	 read -p "Copie y pegue un archivo para ver que archivos y/o carpetas son excluidos: " datos_archivo_exclusion
	 echo " "
	 fi
	 if ! ls ${Dir}/ | grep ${archivostxt} &>/dev/null
	 then
	 echo " "
	 echo "No hay archivos de exclusion de datos en este directorio"
	 echo " "
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ls ${Dir}/ | grep ${datos_archivo_exclusion} &>/dev/null
	 then
	 echo "Mostrando contenido del archivo: $datos_archivo_exclusion "
	 echo " "
	 cat ${Dir}/$datos_archivo_exclusion
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se Mostraron datos de $datos_archivo_exclusion" | tee -a syslog.log
	 echo " "
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
	 if ! ls ${Dir}/ | grep ${datos_archivo_exclusion} &>/dev/null
	 then
     echo " "
	 echo "NOTIFICACION - MENSAJE: No se encontro el archivo $datos_archivo_exclusion en la carpeta $Dir" | tee -a syslog.log
     echo "---------------------------------------------------------------------"
     echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
     echo " "
     read -p "Presione enter para desplegar el menu... " enter
     break
	 fi
     ;;
  "+ Crear nuevo script de transferencia hacia Servidor Remoto")
     mypwd=${PWD}/
     custom_scripts_logs="custom_scripts_logs"
     mkdir -p $custom_scripts_logs
     mkdir -p $scripts_conexiones_exclusion_datos
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
     echo "Verificando acceso y respuesta del servidor: $servidor... "
     echo " "
     if ! sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uptime 2>&1; then
     echo " "
     echo "No se ha podido establecer el acceso al servidor $servidor con los parametros obtenidos. Verifique la conexion y el acceso al mismo, y reingrese al menu para crear el script." | tee -a syslog.log
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     else
     read -p "El servidor $servidor esta operativo y es accesible. Presione enter para ver los datos obtenidos del servidor $servidor... " enter
     echo " "
     echo "Datos obtenidos del servidor:"
     echo " "
     echo "Nombre: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} hostname
     echo " "
     echo "Uptime: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uptime
     echo " "
     echo "Direccion IP: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} hostname -i
     echo " "
     echo "Sistema operativo y distribucion: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} cat /etc/os-release
     echo " "
     echo "Kernel: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uname -a
     echo " "
     echo "Puntos de montaje en /dev/sd: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} df -h | grep /dev/sd
     echo " "
     echo "Memoria utilizada y disponible: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} free -h
     echo " "
     fi
     echo " "
     echo "------------------------------------------------------------------------------------"
     read -p "Por favor proporcione el Path origen (host local) desde donde desea transferir los archivos: " pathorigen 
     echo " "
     fi
     #
     if [[ -d $pathorigen ]]; then
	 echo " "
	 echo "El path de origen: $pathorigen es valido. Prosiguiendo hacia solicitud de path de destino..." 
	 fi
	 if [[ ! -d $pathorigen ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: El path de origen proporcionado es invalido, o inexistente. Verifique que el mismo exista, y reingrese en el menu para proveerlo" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 echo " "
     read -p "Path destino (host remoto): " pathdestino
     echo " "
	 echo "Verificando la existencia de la ruta $pathdestino en el servidor $servidor..."
	 if ! sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} ls $pathdestino >/dev/null 2>&1; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: El path de destino proporcionado es invalido, o inexistente. Verifique que el mismo exista, y reingrese en el menu para proveerlo" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     else
     echo " "
     echo "El path de destino: $pathdestino existe en el servidor remoto. Continuando la creacion del script $archivo..."
     echo " "
     read -p "Desea realizar la transferencia excluyendo carpetas y/o archivos? s/n: " script_exclusion_o_no
     fi
     if [[ $script_exclusion_o_no == "s" ]]; then
     archivo_exclusion_datos="_archivo_exclusion_datos.sh"
	 txt_exclusion="_archivo_carpetas_exclusion.txt"
     exclusion_de_datos_log="_exclusion_de_datos.log"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Generando script de transferencia de datos con exclusion de carpetas/archivos..." | tee -a syslog.log
     echo " " > scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "$(date) NOTIFICACION - MENSAJE: Se creara el archivo $archivo$archivo_exclusion_datos" | tee -a syslog.log
     echo "# SCRIPT DE TRANSFERENCIA DE DATOS CON EXCLUSION DE ARCHIVOS" > scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
	 echo "# Este script excluira los datos descritos en el archivo de texto: $archivo$txt_exclusion" >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
	 echo "# DATOS DE CONEXION PARA TRANSFERENCIA DE ARCHIVOS A SERVIDOR: "$servidor >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "quote="$comilla$quote$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo 'comilla='$quote$comilla$quote >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
	 echo "mypwd="$comilla$mypwd/$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "servidor="$comilla$servidor$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "usuario="$comilla$usuario$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "clave="$comilla$clave$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "pathorigen="$comilla$pathorigen$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "pathdestino="$comilla$pathdestino$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "exclusion_de_datos_log="$comilla$comilla
     echo " " >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " "
	 archivo_carpetas_exclusion=_archivo_datos_a_exluir.txt
	 echo " "
	 read -p "Ingrese la/s carpeta/s y/o archivo/s que seran excluido/s, poniendo un espacio entre cada dato. Al terminar presione enter: " carpetasexc
     echo " "
     echo "Mostrando los datos agregados al archivo $archivo_carpetas_exclusion: "
     echo " "
     archivo_carpetas_exclusion="_archivo_carpetas_exclusion.txt"
     for carpeta in $carpetasexc; do
     echo $carpeta
     echo $carpeta >> scripts_conexiones_exclusion_datos/$archivo$archivo_carpetas_exclusion 
     done
     signopeso="$"
     echo "datos_excluidos_conexiones="$comilla$datos_excluidos_conexiones$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "signopeso="$comilla$signopeso$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "archivo="$comilla$archivo$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "archivo_carpetas_exclusion="$comilla$archivo_carpetas_exclusion$comilla >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "# Instancia de conexion de script "$archivo$archivo_exclusion_datos >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " " >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ha sido creado el archivo: $archivo$archivo_carpetas_exclusion" | tee -a syslog.log
	 echo " "
     echo "Las carpetas y/o archivos excluidos se encuentran guardadas en la carpeta: $archivo$archivo_carpetas_exclusion"
     echo " "
     echo 'sshpass -p "$clave" rsync -auv  --ignore-missing-args --stats --update --progress --out-format="%t %f" $pathorigen --exclude-from=$mypwd$scripts_conexiones_exclusion_datos$archivo$archivo_carpetas_exclusion ssh $usuario@$servidor -p$puerto:$pathdestino | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log' >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     
	 echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Detalle de datos pasados al path de destino $pathdestino en el servidor $servidor...' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "date | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Listando carpetas en el servidor $servidor para la ruta $pathdestino: ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     listar_path_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto ls -lha $pathdedestino | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"
     echo $listar_path_destino  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     total_carpetas_path_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto du -h -c --time $pathdedestino | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"
     echo $total_carpetas_path_destino  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'El informe visto arriba, muestra el tamaño total de carpetas, fecha ultima modificacion, y ruta de cada carpeta' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "date | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos

     total_de_carpetas_origen="ls -lha $pathorigen | wc -l | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"
     total_de_carpetas_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto ls -lha $pathdestino | wc -l | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"
     size_total_origen="du -sh $pathorigen | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"
     size_total_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto du -sh $pathdestino | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Tamaño total de la carpeta del path de Origen: $pathorigen' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo $size_total_origen  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Tamaño total de la carpeta del path Sincronizado de destino: $pathdestino' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo $size_total_destino  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Listando cantidad de archivos y carpetas en el path de origen: $pathorigen' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo $total_de_carpetas_origen  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Listando cantidad de carpetas y archivos sincronizados en el path de destino: $pathdestino' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo $total_de_carpetas_destino  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo 'Fecha de ultima actualizacion: ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "date | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$archivo$exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo "read -p 'Fin del script: Presione enter para terminar la sesion... ' enter"  >> scripts_conexiones_exclusion_datos/$archivo$archivo_exclusion_datos
     echo " "
	 
	 echo "$(date) NOTIFICACION - MENSAJE: El script se ha generado dentro de la carpeta: scripts_conexiones_exclusion_datos" | tee -a syslog.log
     echo " "
     ls -lha scripts_conexiones_exclusion_datos/ | grep $archivo$archivo_exclusion_datos
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break     
     fi
     if [[ $script_exclusion_o_no == "n" ]]; then
     sin_exclusion_de_datos_log="_sin_exclusion_de_datos.log"
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Generando script de transferencia de datos sin exclusion..." | tee -a syslog.log
     echo " " > scripts_conexiones_exclusion_datos/$archivo.sh
     echo "SCRIPT DE TRANSFERENCIA DE DATOS SIN EXCLUSION DE ARCHIVOS" > scripts_conexiones_exclusion_datos/$archivo.sh
     echo " " >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "DATOS DE CONEXION PARA TRANSFERENCIA DE ARCHIVOS A SERVIDOR: "$servidor >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo " " >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "servidor="$comilla$servidor$comilla >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "usuario="$comilla$usuario$comilla >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "clave="$comilla$clave$comilla >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "pathorigen="$comilla$pathorigen$comilla >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "pathdestino="$comilla$pathdestino$comilla >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo " " >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo "# Instancia de conexion de script "$archivo.sh >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo " " >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo 'sshpass -p "$clave" rsync -auv  --stats --update --progress --out-format="%t %f" $pathorigen  ssh $usuario@$servidor -p$puerto:$pathdestino | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log' >> scripts_conexiones_exclusion_datos/$archivo.sh
     echo " "
	 
	 echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Detalle de datos pasados al path de destino $pathdestino en el servidor $servidor...' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "date | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Listando carpetas en el servidor $servidor para la ruta $pathdestino: ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 listar_path_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto ls -lha $pathdedestino | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"
	 echo $listar_path_destino  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 total_carpetas_path_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto du -h -c --time $pathdedestino | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"
	 echo $total_carpetas_path_destino  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'El informe visto arriba, muestra el tamaño total de carpetas, fecha ultima modificacion, y ruta de cada carpeta' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "date | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh

	 total_de_carpetas_origen="ls -lha $pathorigen | wc -l | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"
	 total_de_carpetas_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto ls -lha $pathdestino | wc -l | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"
	 size_total_origen="du -sh $pathorigen | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"
	 size_total_destino="sshpass -p '$clave' ssh $usuario@$servidor -p$puerto du -sh $pathdestino | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Tamaño total de la carpeta del path de Origen: $pathorigen' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo $size_total_origen  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Tamaño total de la carpeta del path Sincronizado de destino: $pathdestino' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo $size_total_destino  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Listando cantidad de archivos y carpetas en el path de origen: $pathorigen' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo $total_de_carpetas_origen  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Listando cantidad de carpetas y archivos sincronizados en el path de destino: $pathdestino' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo $total_de_carpetas_destino  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo 'Fecha de ultima actualizacion: ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "date | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$archivo$sin_exclusion_de_datos_log"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo "read -p 'Fin del script: Presione enter para terminar la sesion... ' enter"  >> scripts_conexiones_exclusion_datos/$archivo.sh
	 echo " "

     echo "$(date) NOTIFICACION - MENSAJE: El script se ha generado dentro de la carpeta: scripts_conexiones_exclusion_datos" | tee -a syslog.log
     echo " "
     ls -lha scripts_conexiones_exclusion_datos/ | grep $archivo.sh
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
  "+ Crear nuevo script local de transferencia hacia directorio/disco ")
     custom_scripts_logs="custom_scripts_logs"
     mkdir -p $custom_scripts_logs
     mypwd={PWD}/
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de creacion de script local hacia directorio/disco..." | tee -a syslog.log
	 echo " "
	 read -p "Ingrese un nombre para crear el script. Sugerencia: Typee un nombre descriptivo, para poder identificarlo mejor: " nombre_script
	 echo " "
	 read -p "Por favor provea el path local existente, a partir del cual se transferiran los datos: " path_de_origen
	 if [[ -d $path_de_origen ]]; then
	 echo " "
	 echo "El path de origen: $path_de_origen es valido. Prosiguiendo hacia solicitud de path de destino..." 
	 fi
	 if [[ ! -d $path_de_origen ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: El path de origen proporcionado es invalido, o inexistente. Verifique que el mismo exista, y reingrese en el menu para proveerlo" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 echo " "
	 read -p "Ahora provea un path de destino existente. En el path que proporcione, arribaran y se sincronizaran los datos en el destino: " path_de_destino
	 if [[ -d $path_de_destino ]]; then
	 echo " "
	 echo "El path de destino: $path_de_destino es valido. Continuando la creacion del script $nombre_script"
	 echo " "
	 read -p "Desea realizar la transferencia excluyendo carpetas y/o archivos? s/n: " script_local_exclusion_o_no
     fi
	 if [[ ! -d $path_de_destino ]]; then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: El path de destino proporcionado es invalido, o inexistente. Verifique que el mismo exista, y reingrese en el menu para proveerlo" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
     if [[ $script_local_exclusion_o_no == "s" ]]; then
	 echo " "
	 read -p "Proporcione las carpetas y o archivos dentro del path $path_de_origen , que desea excluir. Ingrese los datos separados por un espacio, y presione enter: " exclusion_datos_local
	 echo " "
	 mypwd=${PWD}/
	 Dir="scripts_conexiones_exclusion_datos"
     custom_scripts_logs="custom_scripts_logs/"
     mkdir -p $custom_scripts_logs
	 mkdir -p $mypwd$Dir
	 archivo_exclusion_datos_local="_exclusion_datos_local.txt"
	 script_exclusion_datos_local="_script_exclusion_datos_local.sh"
     script_exclusion_datos_log="_exclusion_datos.log"
     script_sin_exclusion_datos_log="_sin_exclusion_datos.log"
	 touch $mypwd$Dir/$nombre_script$archivo_exclusion_datos_local
	 for dato in $exclusion_datos_local; do
	 if ls ${path_de_origen}/$dato &>/dev/null
	 then
	 echo " "
	 ls -lha ${path_de_origen}/$dato
	 echo $dato >> $mypwd$Dir/$nombre_script$archivo_exclusion_datos_local
	 fi
	 if ! ls ${path_de_origen}/$dato &>/dev/null
	 then
	 echo "ERROR. El dato: $dato es inexistente en $path_de_origen - "
	 echo " "
	 fi
	 done
	 echo " "
	 read -p "$(date) NOTIFICACION - MENSAJE: Presione enter, para finalizar con el proceso de creacion del script de transferencia, y el archivo de exclusion de datos... " enter
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se ha creado el archivo de exclusion de datos: $nombre_script$archivo_exclusion_datos_local"
	 echo " "
	 ls -lha $mypwd$Dir/$nombre_script$archivo_exclusion_datos_local
	 echo " "
	 Dir="scripts_conexiones_exclusion_datos"
	 comilla="'"
	 echo " " > $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "# SCRIPT DE TRANSFERENCIA DE DATOS CON EXCLUSION: $nombre_script$script_exclusion_datos_local" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "# Las carpetas y archivos (datos) a excluir en este script se encuentran en el archivo: $nombre_script$archivo_exclusion_datos_local" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "mypwd="$mypwd >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "Dir="$Dir >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "pathorigen="$comilla$path_de_origen$comilla >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "pathdestino="$comilla$path_de_destino$comilla >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "rsync -auvi  --stats --update --progress --out-format='%t %f' $path_de_origen --exclude-from=$mypwd$Dir/$nombre_script$archivo_exclusion_datos_local $path_de_destino | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " "
  
     echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo 'Detalle de datos pasados a Disco externo...' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "date | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo 'Listando carpetas en disco externo para la ruta $path_de_destino: ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 listar_path_destino="ls -lha $path_de_destino | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log"
	 echo $listar_path_destino >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 total_carpetas_path_destino="du -h -c --time $path_de_destino | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log"
	 echo $total_carpetas_path_destino >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo 'El informe visto arriba, muestra el tamaño total de carpetas, fecha ultima modificacion, y ruta de cada carpeta' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "date | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 
	 total_de_carpetas_origen="ls -lha $path_de_origen | wc -l | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log"
     total_de_carpetas_destino="ls -lha $path_de_destino | wc -l | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log"
	 size_total_origen="du -sh $path_de_origen | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log"
	 size_total_destino="du -sh $path_de_destino | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log"
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo 'Tamaño total de la carpeta del path de Origen: $path_de_origen' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo $size_total_origen >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo 'Tamaño total de la carpeta del path Sincronizado de destino: $path_de_origen' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo $size_total_destino >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo 'Listando cantidad de archivos y carpetas en el path de origen: $path_de_origen' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo $total_de_carpetas_origen >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo 'Listando cantidad de carpetas y archivos sincronizados en el path de destino: $path_de_destino' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo $total_de_carpetas_destino >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo 'Fecha de ultima actualizacion: '" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "date | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs$nombre_script$script_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo "read -p 'Fin del script: Presione enter para terminar la sesion... ' enter" >> $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se ha creado el script de exclusion de datos: $nombre_script$script_exclusion_datos_local"
	 echo " "
	 ls -lha $mypwd$Dir/$nombre_script$script_exclusion_datos_local
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Finalizo la creacion del script $nombre_script$script_exclusion_datos_local y el archivo de exclusion de datos $nombre_script$archivo_exclusion_datos_local" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[ $script_local_exclusion_o_no == "n" ]]; then
	 mypwd=${PWD}/
     script_sin_exclusion_datos_log="_script_sin_exclusion_datos.log"
	 Dir="scripts_conexiones_exclusion_datos"
	 mkdir -p $mypwd$Dir
	 else
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: No ha ingresado una opcion valida" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 echo " "
	 echo "Ha decidido no excluir ninguna carpeta ni archivo dentro del path: $path_de_origen"
	 echo " "
	 echo "Todos los datos dentro del path proporcionado $path_de_origen, seran transferidos y sincronizados con el path de destino: $path_de_destino"
     script_sin_exclusion_datos_local="_script_sin_exclusion_datos_local.sh"
     echo " "
	 echo " " > $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "# SCRIPT DE TRANSFERENCIA DE DATOS SIN EXCLUSION: $nombre_script$script_sin_exclusion_datos_local" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "# Este script transferira, y sincronizara todos los datos a partir de la ruta: $path_de_origen , en el directorio $path_de_destino" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "mypwd="$mypwd >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "Dir="$Dir >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "pathorigen="$comilla$path_de_origen$comilla >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "pathdestino="$comilla$path_de_destino$comilla >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo " " >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "rsync -auvi  --stats --update --progress --out-format='%t %f' $path_de_origen $path_de_destino | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo " "
     size_total_origen="du -sh $path_de_origen | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log"
	 size_total_destino="du -sh $path_de_destino | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log"
     echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'Detalle de datos pasados a Disco externo...' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "date | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'Listando carpetas en disco externo para la ruta $path_de_destino: ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 listar_path_destino="ls -lha $path_de_destino | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log"
     echo $listar_path_destino >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 total_carpetas_path_destino="du -h -c --time $path_de_destino | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log"
     echo $total_carpetas_path_destino >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'El informe visto arriba, muestra el tamaño total de carpetas, fecha ultima modificacion, y ruta de cada carpeta' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     
	 total_de_carpetas_origen="ls -lha $path_de_origen | wc -l | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log"
	 total_de_carpetas_destino="ls -lha $path_de_destino | wc -l | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log"
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'Tamaño total de la carpeta del path de Origen: $path_de_origen' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo $size_total_origen >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'Tamaño total de la carpeta del path Sincronizado de destino: $path_de_origen' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo $size_total_destino >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'Listando cantidad de archivos y carpetas en el path de origen: $path_de_origen' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo $total_de_carpetas_origen >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo 'Listando cantidad de carpetas y archivos sincronizados en el path de destino: $path_de_destino' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo $total_de_carpetas_destino >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local

	 echo "echo 'Fecha de ultima actualizacion: ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "date | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo " " >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo '----------------------------------------------------------------------------------------' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
     echo "echo ' ' | tee -a $mypwd$custom_scripts_logs/$nombre_script$script_sin_exclusion_datos_log" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "read -p 'Fin del script: Presione enter para terminar la sesion... ' enter" >> $mypwd$Dir/$nombre_script$script_sin_exclusion_datos_local
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
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
	  if [ -z ${puerto+x} ]; then
     echo "$(date) ERROR-Puerto - ATENCION: La variable puerto del servidor aun no fue proveida, ingrese al menu Puerto del servidor para poder operar" | tee -a syslog.log
     echo "----------------------------------------------------------------------------------"
	 else
     echo "$(date) OK-05 - variable puerto del servidor seteada - El puerto seteado es: $puerto. Si desea cambiarlo ingrese al menu Puerto del servidor" | tee -a syslog.log
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

  "- Puerto de conexion del servidor")
   echo  " "
 	 echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo servidor..." | tee -a syslog.log
	 if [ -z "$puerto" ]; then
 	 echo "$(date) NOTIFICACION - MENSAJE: La variable puerto de conexion del servidor no esta seteada" | tee -a syslog.log
	 echo " "
	 else
	 echo "$(date) NOTIFICACION - MENSAJE: La variable puerto de conexion del servidor ya esta seteada como: $puerto" | tee -a syslog.log
	 fi
	 echo " "
	 read -p "Desea configurar la variable puerto de conexion del servidor ahora?: s/n... " si_o_no
	 if [[  $si_o_no == "s" ]] ;then
 	 echo " "
	 read -p "Ingrese el numero de puerto del servidor remoto para conexion ... " puerto
 	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Se ingreso un nuevo registro para la variable puerto del servidor" | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: La variable puerto del servidor esta seteada como: $puerto" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
	 fi
	 if [[  $si_o_no == "n" ]] ;then
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: No se ha seteado la variable puerto del servidor" | tee -a syslog.log
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
     echo "Verificando acceso y respuesta del servidor: $servidor... "
     echo " "
     if ! sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto}  uptime 2>&1; then
     echo " "
     echo "No se ha podido establecer el acceso al servidor $servidor con los parametros obtenidos. Verifique la conexion y el acceso al mismo, y reingrese al menu para crear el script." | tee -a syslog.log
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     else
     read -p "El servidor $servidor esta operativo y es accesible. Presione enter para ver los datos obtenidos del servidor $servidor... " enter
     echo " "
     echo "Datos obtenidos del servidor:"
     echo " "
     echo "Nombre: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} hostname
     echo " "
     echo "Uptime: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uptime
     echo " "
     echo "Direccion IP: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} hostname -i
     echo " "
     echo "Sistema operativo y distribucion: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} cat /etc/os-release
     echo " "
     echo "Kernel: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uname -a
     echo " "
     echo "Puntos de montaje en /dev/sd: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} df -h | grep /dev/sd
     echo " "
     echo "Memoria utilizada y disponible: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} free -h
     echo " "
     fi
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
	 sshpass -p "$clave" rsync -auv --ignore-missing-args --stats --update --progress --out-format="%t %f" $pathorigen --exclude-from='carpetas.log' ssh $usuario@$servidor -p$puerto:$pathdestino
	 echo " " >> rsync_log.log
	 echo "Listando contenido de carpeta $pathdestino..." >> rsync_log.log
	 echo " " >> rsync_log.log
	 sshpass -p "$clave" ssh $usuario@$servidor -p$puerto ls -lha $pathdestino >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo "Cantidad de archivos en $pathdestino @$servidor: " >> rsync_log.log
	 echo " " >> rsync_log.log
	 sshpass -p "$clave" ssh $usuario@$servidor -p$puerto ls -lha $pathdestino | wc -l >> rsync_log.log
	 echo " " >> rsync_log.log
	 echo "Tamaño de las 10 ccarpetas mas grandes en $pathdestino @$servidor: " >> rsync_log.log
	 sshpass -p "$clave" ssh $usuario@$servidor -p$puerto du -h $pathdestino | sort -hr | tail -n +1 | head -$1 >> rsync_log.log
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
     echo "Verificando acceso y respuesta del servidor: $servidor... "
     echo " "
     if ! sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uptime 2>&1; then
     echo " "
     echo "No se ha podido establecer el acceso al servidor $servidor con los parametros obtenidos. Verifique la conexion y el acceso al mismo, y reingrese al menu para crear el script." | tee -a syslog.log
     echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal" | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     else
     read -p "El servidor $servidor esta operativo y es accesible. Presione enter para ver los datos obtenidos del servidor $servidor... " enter
     echo " "
     echo "Datos obtenidos del servidor:"
     echo " "
     echo "Nombre: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} hostname
     echo " "
     echo "Uptime: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uptime
     echo " "
     echo "Direccion IP: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} hostname -i
     echo " "
     echo "Sistema operativo y distribucion: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} cat /etc/os-release
     echo " "
     echo "Kernel: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} uname -a
     echo " "
     echo "Puntos de montaje en /dev/sd: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} df -h | grep /dev/sd
     echo " "
     echo "Memoria utilizada y disponible: "
     echo " "
     sshpass -p ${clave} ssh ${usuario}@${servidor} -p ${puerto} free -h
     echo " "
     fi
	 echo "Proceder con el programa y transferir los datos a $servidor?"
     read -p "s/n?" proceder_o_salir
	 if [[ $proceder_o_salir == "s" ]]; then
	 echo " "
     echo "Iniciando transferencia de datos hacia $servidor..." >> rsync_log.log
     echo " " >> rsync_log.log
     sshpass -p "$clave" rsync -auv --ignore-missing-args --stats --update --progress --out-format="%t %f" $pathorigen  ssh $usuario@$servidor -p$puerto:$pathdestino
     echo " " >> rsync_log.log
     echo "Listando contenido de carpeta $pathdestino..." >> rsync_log.log
     echo " " >> rsync_log.log
     sshpass -p "$clave" ssh $usuario@$servidor -p$puerto ls -lha $pathdestino >> rsync_log.log
     echo " " >> rsync_log.log
     echo "Cantidad de archivos en $pathdestino @$servidor: " >> rsync_log.log
     echo " " >> rsync_log.log
     sshpass -p "$clave" ssh $usuario@$servidor -p$puerto ls -lha $pathdestino | wc -l >> rsync_log.log
     echo " " >> rsync_log.log
     echo "Tamaño de las 10 ccarpetas mas grandes en $pathdestino @$servidor: " >> rsync_log.log
     sshpass -p "$clave" ssh $usuario@$servidor -p$puerto du -h $pathdestino | sort -hr | tail -n +1 | head -$1 >> rsync_log.log
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
    "- Ver logs de scripts ejecutados")
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de visualizacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
     custom_scripts_logs="custom_scripts_logs/"
     if ! ls -lha $custom_scripts_logs | grep .log &>/dev/null; then
     echo " "
     echo "No hay archivos con la extension log en el directorio. Es posible que no se hayan corrido scripts, se hayan movido, o eliminado." | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de visualizacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     else
     echo "MOSTRANDO ARCHIVOS DE LOG DE SCRIPT EJECUTADOS: "
     echo " "
     ls -lha $custom_scripts_logs | grep .log
     echo " "
     read -p "Copie y pegue el archivo .log que desea ver, y presione enter: " archivo_log_a_ver
     fi
     if ! ls -lha $custom_scripts_logs$archivo_log_a_ver &>/dev/null; then
     echo " "
     echo "No hay un archivo con el dato: $archivo_log_a_ver. Reingrese a este modo y proporcione un archivo .log existente para visualizar." | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de visualizacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     fi
     if [[ $archivo_log_a_ver == "" ]]; then 
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado nada. Reingrese a este modo, y proporcione un log de la lista para poder verlo. " | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de visualizacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     else
     echo " "
     echo "Mostrando contenido del archivo $archivo_log_a_ver: "
     echo " "
     cat $custom_scripts_logs$archivo_log_a_ver
     echo " "
     read -p "Presione enter cuando haya finalizado de ver el archivo... " enter
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de visualizacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     fi
     ;;
    "- Eliminar logs de scripts ejecutados")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo de eliminacion de logs de scripts..." | tee -a syslog.log
	 echo " "
     if ! ls -lha $custom_scripts_logs | grep .log &>/dev/null; then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No hay archivos con la extension log en el directorio para eliminar. Es posible que no se hayan corrido scripts, se hayan movido, o eliminado." | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de eliminacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     else
     echo "MOSTRANDO ARCHIVOS DE LOG DE SCRIPT EJECUTADOS: "
     echo " "
     ls -lha $custom_scripts_logs | grep .log
     echo " "
     read -p "ATENCION: Copie y pegue el archivo .log que desea eliminar y presione enter. Si el archivo que proporcione existe en la carpeta $$custom_scripts_logs, sera directamente eliminado. Aguardando input... " archivo_log_a_ver
     fi
     if ! ls -lha $custom_scripts_logs$archivo_log_a_ver &>/dev/null; then
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: El archivo $archivo_log_a_ver no se encuentra en el directorio $$custom_scripts_logs. Reingrese en el menu, y proporcione un archivo valido" | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de eliminacion de logs de scripts..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     fi
     if [[ $archivo_log_a_ver == "" ]]; then 
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: No se ha ingresado nada. Reingrese a este modo, y proporcione un log de la lista para ser eliminado. " | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de eliminacion de logs de scripts ejecutados..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     else
     rm $custom_scripts_logs$archivo_log_a_ver
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Se ha eliminado el archivo $archivo_log_a_ver. " | tee -a syslog.log
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Salida de modo de eliminacion de logs de scripts..." | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal..." | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para regresar al menu principal..." enter
	 break
     fi
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
