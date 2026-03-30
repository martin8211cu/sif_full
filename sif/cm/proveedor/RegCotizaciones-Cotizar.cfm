<cfquery name="rsCotizaciones" datasource="sifpublica">
	select count(1) as cant
	from CotizacionesProveedor a
	where PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
	and UsucodigoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and CPestado = 0
</cfquery>

<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
	<cfset modo = "CAMBIO">
<cfelseif isdefined("Form.btnNuevo")>
	<cfset modo = "ALTA">
<cfelseif rsCotizaciones.cant EQ 0>
	<cfset modo = "ALTA">
<cfelse>
	<cfset modo = "LISTA">
</cfif>

<cfif modo EQ "LISTA">
	<cfinclude template="RegCotizaciones-listaCotizaciones.cfm">
<cfelse>
	<cfinclude template="RegCotizaciones-formCotizacion.cfm">
</cfif>
