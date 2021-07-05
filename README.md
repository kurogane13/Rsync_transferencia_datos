Rsync_transferencia_datos

PROGRAMA CREADO POR GUSTAVO WYDLER AZUAGA - 28/04/2021

---------------------------------------------------------------------------------------------------------------------------------------

Programa interactivo para transferir datos entre servidores linux, escrito en bash.

Proposito del programa: Poder transferir grandes volumenes de datos hacia servidores remotos, sin la complejidad de la sintaxis, tan solo a travez de un menu interactivo.

Funcionalidad del programa:

- Consulta de datos y puntos de montaje
- Transferencia de datos con exclusion de carpetas/archivos.
- Transferencia total de directorios sin ninguna exclusion.
- Mientras que el menu interactivo este activo (programa corriendo), pueden re-configurarse variables o parametros en caso de equivocaciones o correcciones necesarias, antes de iniciar transferencia de datos.
- Logs completos de eventos (Transferencias via rsync)
- Logs de sistema (aplicacion propia). Variables no seteadas, errores. 


Herramientas necesarias para uso del programa:

- Endpoint alcanzable a nivel de red (hostname debe resolver DNS/ o ip alcanzable)
- opensshserver debe estar instalado en ambos endpoints (local y remoto)
- sshpass debe estar instalado en el servidor local
- Hostkey agregada y con acceso previo via ssh manual. Se debe haber tenido acceso via ssh al endpoint anteriormente con usuario y contraseña.

Ejecucion del programa:

- Crear una carpeta para el programa y colocar el shellscript (rsync_transfer_data.sh) dentro de ella. 
- Abrir una terminal en linux y correr: bash /carpeta_programa/rsync_transfer_data.sh
- NOTA: el programa creara archivos de logs, y carpetas.log ( este ultimo contendra datos que el usuario agrege, que seran excluidos de correrse el modo transferencia con exclusion de datos)

Modo de uso del programa: 

- Variables mandatorias para poder transferir archivos:
- Nombre de Host (debe resolver DNS), o ip de acceso a servidor, o endpoint remoto.
- Nombre de Usuario del servidor remoto.
- Contraseña del servidor remoto.
- Parent Path de origen o source (a partir de que carpeta parent se transferiran datos). Formato valido de ejemplo: /home/$USER/carpeta/
- Path de destino (del servidor remoto) donde arrivaran los datos del source path
- Para transferencia de datos con exclusion de carpetas, deberan especificarse las carpetas, en un archivo que crea el programa llamado "carpetas.log"
