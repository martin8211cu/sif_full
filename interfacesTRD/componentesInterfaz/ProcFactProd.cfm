<!---ABG: Se realiza Cambio a Interfaz para que muestra pantalla intermedia de resultados Ene/2008 --->
<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and len(url.CodICTS) and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset ETQCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset ETQCodICTS = form.CodICTS>
<cfelse>
	<cfset ETQCodICTS = "">
</cfif>	

<cfif isdefined("ETQCodICTS") and len(ETQCodICTS)>
	<cfquery name="rsNombre" datasource="preicts">
		select min(acct_full_name) as acct_full_name
		from account
		where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#ETQCodICTS#">
	</cfquery>
</cfif>

<cfif isdefined("rsNombre") AND rsNombre.recordcount GT 0>
	<cfset etiquetaT = " #rsNombre.acct_full_name#">
<cfelse>
	<cfset etiquetaT = "">
</cfif>

<cfquery name="Errores" datasource="sifinterfaces">
	select count(mensajeerror) as TotalErrores
		from facturasProdPMI a1
		where mensajeerror is not null
		and sessionid=#session.monitoreo.sessionid#
</cfquery>
<cfif Errores.TotalErrores NEQ "">
	<cfset varErrores = Errores.TotalErrores>
<cfelse>
	<cfset varErrores = 0>
</cfif>

<!--- Variable de Boton presionado --->
<cfif IsDefined('url.botonsel') and Len(url.botonsel) NEQ 0>
	<cfset Form.botonsel = url.botonsel>
</cfif>

<cf_templateheader title="Procesa Facturas Compra de Producto">
	  <cf_web_portlet_start titulo="Procesa Facturas Compra de Producto #etiquetaT#">

		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLFacturasProductosR2.cfm?CodICTS=#form.CodICTS#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from #session.Dsource#facturasProdPMI where sessionid = #session.monitoreo.sessionid#
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/FacturasProductosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaProductos.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores(#varErrores#)">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLFacturasProductosErroresR2.cfm?CodICTS=#form.CodICTS#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnTerminado">
				<!--- terminado.cfm
				Muestra una leyenda que indica el estado del proceso (Terminado)--->
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/terminado.cfm?Regresa=ProcFactProd.cfm">
			</cfif>
		</cfif>
		
		<cfif isdefined("Form.generar")>
			<cfinclude template="FacturasProductosA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="FacturasProductosA-lista.cfm"> 

		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
