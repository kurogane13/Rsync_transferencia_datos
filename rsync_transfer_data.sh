echo "#################################################################################" | tee -a syslog.log
echo "$(date) INICIA PROGRAMA DE CONSULTA Y TRANSFERENCIA DE DATOS - MENU DISPONIBLE PARA OPERAR" | tee -a syslog.log
echo "---------------------------------------------------------------------------------"  | tee -a syslog.log
echo "$(date) Inicio de logeo de notificaciones y errores..." | tee -a syslog.log
echo " "
while true; 
do
echo "######################################################"
echo "   * Programa de consulta y transferencia de datos *  "
echo " "
echo "   Menu principal - Seleccione una opcion para operar "
echo "######################################################"
echo " "

opciones=("- Ver tamaño de montajes en host local" "- Verificar variables seteadas y errores" "- Nombre/ip de servidor" "- Usuario" "- Contraseña" "- Path de origen" "- Path de destino" "- Excluir carpeta/s y/o archivos" "- Regenerar archivo carpetas.log" "- Ejecutar programa excluyendo carpetas y archivos" "- Iniciar programa sin excluir una carpeta ni archivo" "- Ver log de transferencias rsync_log" "- Ver log de eventos syslog.log" )
select opcion in "${opciones[@]}"
do
  case $opcion in
  "- Ver tamaño de montajes en host local")
     echo " "
     echo "$(date) NOTIFICACION - MENSAJE: Ingresando a modo Consulta de montajes.." | tee -a syslog.log
     echo "$(date) Mostrando tamaño en montajes en: "
     echo "$(date) Server: " $(hostname)
     echo "$(date) Ip: " 
     ifconfig | grep broadcast
     echo " "
     cat /etc/os-release
     echo " "
     df -h | grep dev/s
     echo "$(date)$(date) NOTIFICACION - MENSAJE: Se realizo conulta de tamaño de puntos de montaje en server: " $(hostname) | tee -a syslog.log
	 echo " "
	 echo "$(date) NOTIFICACION - MENSAJE: Volviendo a menu principal"  | tee -a syslog.log
	 echo " "
	 read -p "Presione enter para desplegar el menu... " enter
	 break
     ;;
  "- Verificar variables seteadas y errores")
     echo " "
     echo "$(date)$(date) NOTIFICACION - MENSAJE: Ingresando a modo Variables y errores..." | tee -a syslog.log
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
	 less rsync_log.log
	 echo "$(date) NOTIFICACION - MENSAJE:  Salida de modo de visualizacion de log de transferencias..." | tee -a syslog.log
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
	 less syslog.log
	 echo "$(date) NOTIFICACION - MENSAJE:  Salida de modo de visualizacion de log de transferencias..." | tee -a syslog.log
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
