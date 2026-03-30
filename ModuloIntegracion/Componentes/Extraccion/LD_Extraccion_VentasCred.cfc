<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   LD_Extraccion_Compras.cfc
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Hint:		   This Process is heavy on the memory, if you get the java overhead limit exceeded error,
				   avoid calling the GC directly and instead increase the java heap size in the coldfusion administrator
--->
<cfcomponent output="yes">
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfsetting requestTimeout="3600" />
	<!--- Asigna variables de Fechas --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
	<cfelse>
		<cfset fechaini = 0>
		<cfset fechafin = 0>
	</cfif>
	<!--- Obtiene operaciones no procesadas a realizar --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones"
		method 			= "getOperacionesLD"
		returnVariable  = "rsOperacionID"
		DataSource 		= "ldcom"
		Estado 			= "CERR"
		FechaIni 		= "#fechaini#"
		FechaFin		= "#fechafin#"
		Proceso 		= "VENTASCREDITO"
	>
	<!---
		Tipos de Documento
			1	Factura Contado
			2	Apartado
			3	Devolucion
			4	Factura Credito
			5	Devolucion Cedi
			8   Servicios
	--->
	<!--- Proceso --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Extraccion.LD_Extraccion_Ventas"
		method 			= "getVentas"
		DataSource 		= "ldcom"
		rsOperacionID	= "#rsOperacionID#"
		Excluir 		= "1,2,3,5,8"
		ParVentasCxC	= "true"
	>
</cffunction>
</cfcomponent>