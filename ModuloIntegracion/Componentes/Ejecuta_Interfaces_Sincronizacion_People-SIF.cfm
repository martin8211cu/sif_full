<!--- RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LOS PROCESOS DE TRANSFORMACIÓN. ------------->
<!---   Autor :  Maria de los Angeles Blanco López      26/07/2011                         --->

<cfsetting  requesttimeout="36000">
		
<!--- Ejecucion de Interfaz de Cuentas por Pagar (Compras) --->
<cfinvoke component="Importar_Empleados_People-SIF" method="Ejecuta">

