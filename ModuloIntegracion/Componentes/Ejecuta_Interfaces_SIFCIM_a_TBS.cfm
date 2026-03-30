<!--- RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LOS PROCESOS DE TRANSFORMACIÓN. ------------->
<!---   Autor :  Maria de los Angeles Blanco López      26/07/2011                         --->

<cfsetting  requesttimeout="3600">
		
<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="PMI_Ordenes_Pago" method="Ejecuta"/> 

<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="PMI_Tesoreria_CHK" method="Ejecuta"/> 
