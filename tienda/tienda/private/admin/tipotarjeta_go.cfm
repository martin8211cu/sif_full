<cfsetting enablecfoutputonly="yes">
<cfparam name="Form.Pagina" default="1" type="numeric">
<cfif IsDefined("form.cambio")>
	<cfquery datasource="#session.DSN#" >
		update TipoTarjeta
		set nombre_tipo_tarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipo_tarjeta#">
		, mascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">
		where tc_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tc_tipo#">
	</cfquery>
	<cfset tc_tipo = form.tc_tipo>
<cfelseif IsDefined("form.alta")>
	<cfquery datasource="#session.DSN#" name="id_categoria" >
		insert TipoTarjeta (tc_tipo, nombre_tipo_tarjeta, mascara)
		values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tc_tipo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipo_tarjeta#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">)
	</cfquery>
	<cfset tc_tipo = form.tc_tipo>
<cfelseif IsDefined("form.baja")>
	<cfquery datasource="#session.DSN#" >
		delete TipoTarjeta
		where tc_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tc_tipo#">
	</cfquery>
</cfif>

<cfif isdefined("form.cambio")>
	<cflocation url="tipotarjeta.cfm?Pagina=#Form.Pagina#&tc_tipo=#URLEncodedFormat(form.tc_tipo)#">
<cfelse>
	<cflocation url="tipotarjeta.cfm?Pagina=#Form.Pagina#">
</cfif>
