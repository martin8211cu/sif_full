
<!--- 	RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LA SINCRONIZACION
DEL CATALOGO DE SOCIOS DE NEGOCIOS CON CLIENTES Y PROVEEDORES DE LDCOM ------------------>

<cfsetting  requesttimeout="3600">

<!--- Encolamiento de Proceso de Compras --->
<!--- <cfinvoke component="LD_interfaz_Socios" method="Ejecuta" SIScodigo="LD"/> --->


<!--- Ejecuta WS --->

<cfinvoke component="WSClienteProveedor" method="EjecutaWS" SIScodigo="LD"/>