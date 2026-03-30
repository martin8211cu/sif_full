<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   LD_Extraccion_Compras.cfc
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Hint:		   This Process is heavy on the memory, if you get the java overhead limit exceeded error,
				   avoid calling the GC directly and instead increase the java heap size in the coldfusion administrator
--->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_Base" output="yes">
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfsetting requestTimeout="3600" />
	<!--- Asigna variables de Fechas --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
	<cfelse>
		<cfset fechaini = createdate(YEAR(NOW() -1), MONTH(NOW() -1), DAY(NOW() -1))>
		<cfset fechafin = createdatetime(YEAR(NOW()), MONTH(NOW()), DAY(NOW()),23,59,59)>
	</cfif>
	<!--- Obtiene operaciones no procesadas a realizar --->
	<cfset Suc_Id = -1>
	<cfif isdefined("form.cbo_Sucursal_Ext")>
		<cfset Suc_Id = #form.cbo_Sucursal_Ext#>
	</cfif>

	<cfset lVarProceso = "VENTASCONTADO">

	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones"
		method 			= "getOperacionesLD"
		returnVariable  = "rsOperacionID"
		DataSource 		= "ldcom"
		Estado 			= "CERR"
		FechaIni 		= "#fechaini#"
		FechaFin		= "#fechafin#"
		Proceso 		= "#lVarProceso#"
		Sucursal        = "#Suc_Id#"
	>

	<cfif isdefined("rsOperacionID") AND rsOperacionID.RecordCount GT 0>
		<cfset Equiv = ConversionEquivalencia ('LD', 'CADENA', rsOperacionID.Cadena_Id, rsOperacionID.Cadena_Id, 'Cadena')>
		<cfset varEcodigo = Equiv.EQUidSIF>

		<cfif isdefined("varEcodigo") AND TRIM(varEcodigo) EQ "">
			<cflog file="LOG_Ejecuta_Extraccion_VentasContado" application="no" text="No está configurada la equivalencia para la Cadena: #rsOperacionID.Cadena_Id#, #now()#">
		</cfif>

		<cfquery name="rsGetParam02" datasource="sifinterfaces">
			SELECT Pvalor
			FROM SIFLD_ParametrosAdicionales
			WHERE Pcodigo = '00002'
			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
		</cfquery>

		<cfset varSoloCorteZ = false>
		<cfif rsGetParam02.RecordCount GT 0 AND rsGetParam02.Pvalor EQ 1>
			<cfset varSoloCorteZ = true>
		</cfif>




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

		<cfif varSoloCorteZ EQ false>
			<!--- PROCESO NORMAL POR DETALLE --->
			<cfinvoke component = "ModuloIntegracion.Componentes.Extraccion.LD_Extraccion_Ventas"
					  method = "getVentas"
					  DataSource = "ldcom"
					  rsOperacionID	= "#rsOperacionID#"
					  Excluir = "2,4" >
		<cfelse>
			<!--- PROCESO SOLO POR CORTE Z --->
			<cfinvoke component = "ModuloIntegracion.Componentes.Extraccion.LD_Extraccion_Ventas_Contado_CorteZ"
				      method	= "getVentasContadoCorteZ"
	      	          DataSource = "ldcom"
			          rsOperacionID = "#rsOperacionID#">

		</cfif>
	<cfelse>
		<cflog file="LOG_Ejecuta_Extraccion_VentasContado" application="no" text="Sin operaciones, #now()#">
	</cfif>

</cffunction>
</cfcomponent>

