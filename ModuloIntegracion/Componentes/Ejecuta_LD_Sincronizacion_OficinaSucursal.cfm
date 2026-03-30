
<!--- 	RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LA SINCRONIZACION
DEL CATALOGO DE OFICINAS DE SIF CON SUCURSALES  DE LDCOM ------------------>

<cfsetting  requesttimeout="3600">

<!--- Encolamiento de Proceso de Compras --->
<cfinvoke component="LD_interfaz_oficinas" method="Ejecuta" SIScodigo="LD"/> 