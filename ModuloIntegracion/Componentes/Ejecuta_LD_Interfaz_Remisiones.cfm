
<!--- 	RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LA 
INTERFAZ DE REMISIONES EMITIDAS DE  PROVEEDORES DE LDCOM ------------------>

<cfsetting  requesttimeout="3600">

<!--- Encolamiento de Proceso de Compras --->
<cfinvoke component="LD_interfaz_Remisiones" method="Ejecuta" SIScodigo="LD"/> 
