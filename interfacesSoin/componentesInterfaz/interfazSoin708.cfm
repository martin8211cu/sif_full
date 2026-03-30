<!---
	Recibe datos relacionados con el tipo de cambio y lo actualiza en la base de datos:
	Verifica la existencia del tipo de cambio enviado, si no existe lo crea, de existir lo actualiza, 
	debe tomar en cuenta que la fecha que se pasa es de inicio de vigencia del tipo de cambio y realizar
	las actualizaciones necesarias según la lógica del programa que da mantenimiento al tipo de cambio.
--->
<!---DATOS RECIBIDOS TIPO DE CAMBIO--->
<cfset LvarXML 	 = GvarXML_IE>
<!--- Componente del Tipo de Cambio --->
<cfinvoke component="interfacesSoin.Componentes.CM_TiposCambio" method="ActualizaTiposCambio" returnvariable="">
		<cfinvokeargument name="xmlString"	value="#LvarXML#">
</cfinvoke>
