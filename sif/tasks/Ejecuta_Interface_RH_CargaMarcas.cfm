<!--- RUTINA QUE EFECTUA EL LLAMADO A COMPONENTES PARA LA EJECUCION DE LA CARGA DE MARCAS. ------------->
<!---   Autor :  E. Raúl Bravo Gómez      20/12/2011                          --->
<cfsetting  requesttimeout="3600">
<!--- Ejecucion de Interfaz de Carga de Marcas (RH) --->
<cfinvoke component="ModuloIntegracion.Componentes.RH_CargaMarcas" method="Ejecuta">
 	<!--- <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">  --->
<!--- 	<cfinvokeargument name="CEcodigo" value="#session.CEcodigo#"> --->
</cfinvoke>
