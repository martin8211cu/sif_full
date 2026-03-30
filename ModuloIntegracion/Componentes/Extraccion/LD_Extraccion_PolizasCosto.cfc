<!--- Eduardo Gonzalez Sarabia (APH)
	  Extraccion de polizas de costo.
	  04/12/2018 --->

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
	<cfinvoke component = "ModuloIntegracion.Componentes.Extraccion.LD_Extraccion_Ventas_Credito"
		method 			= "getVentas"
		DataSource 		= "ldcom"
		rsOperacionID	= "#rsOperacionID#"
		Excluir 		= "1,2,3,5,8"
		ParVentasCxC	= "true"
	>
</cffunction>
</cfcomponent>