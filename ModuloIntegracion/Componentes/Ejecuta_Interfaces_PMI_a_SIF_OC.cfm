<!--- RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LOS PROCESOS DE TRANSFORMACIÓN. ------------->
<!---   Autor :  Maria de los Angeles Blanco López      29/12/2009                          --->

<cfsetting  requesttimeout="3600">
		
<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="PMI_OCompra" method="Ejecuta"/> 

<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="PMI_Tesoreria" method="Ejecuta"/> 
