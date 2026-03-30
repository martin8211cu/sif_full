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

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from RecProdTranPMI
	where mensajeerror is not null 
	and sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<cf_templateheader title="Procesa Recepcion de Producto en Transito">
	  <cf_web_portlet_start titulo="Recepcion de Producto en Transito #etiquetaT#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLRecProdTranR2.cfm?Regresa=ProcRecepProdTran.cfm&CodICTS=#form.CodICTS#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from RecProdTranPMI where sessionid = #session.monitoreo.sessionid#
					or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/RecepProdTran/RecepProdTranParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaRecepProdTran.cfm">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/RecepProdTran/RecepProdTranParam.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btn#BErrores#">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLRecProdTranErroresR2.cfm?Regresa=ProcRecepProdTran.cfm&CodICTS=#form.CodICTS#">
			</cfif>
		</cfif>
		<cfif isdefined("Form.generar")>
			<cfinclude template="RecepProdTranA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="RecepProdTranA-lista.cfm">
		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
