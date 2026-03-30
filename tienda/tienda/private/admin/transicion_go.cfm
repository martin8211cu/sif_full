<cfsetting enablecfoutputonly="yes">
<cfparam name="Form.Pagina" default="1" type="numeric">
<cfif IsDefined("form.cambio")>
	<!---
	<cfquery datasource="#session.DSN#" >
		update Transiciones
		set nombre_tipo_tarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipo_tarjeta#">
		, mascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">
		where desde = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.desde#">
		  and hacia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hacia#">
	</cfquery>
	--->
<cfelseif IsDefined("form.alta")>
	<cfquery datasource="#session.DSN#" name="id_categoria" >
		insert Transiciones (desde, hacia)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.desde#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hacia#">)
	</cfquery>
<cfelseif IsDefined("form.baja")>
	<cfquery datasource="#session.DSN#" >
		delete Transiciones
		where desde = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.desde#">
		  and hacia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hacia#">
	</cfquery>
</cfif>

<cfif isdefined("form.cambio")>
	<cflocation url="transicion.cfm?Pagina=#Form.Pagina#&desde=#URLEncodedFormat(form.desde)#&hacia=#URLEncodedFormat(form.hacia)#">
<cfelse>
	<cflocation url="transicion.cfm?Pagina=#Form.Pagina#">
</cfif>
