<!--- Definicion de Parámetros --->
<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden)) and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden>
</cfif>

<cfset currentPage = GetFileFromPath(GetTemplatePath())>

<!--- Consultas --->
<cfquery name="rsTipoOrden" datasource="#Session.DSN#">
	select a.EOnumero, a.CMTOcodigo, a.CMCid, rtrim(b.FMT01COD) as formato
	from EOrdenCM a 
		 inner join CMTipoOrden b
			on a.Ecodigo = b.Ecodigo
			and a.CMTOcodigo = b.CMTOcodigo 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>

<cfif rsTipoOrden.recordcount gt 0 and len(trim(rsTipoOrden.formato)) >
	<cfquery name="rsFormato" datasource="#session.DSN#">
		select FMT01tipfmt, FMT01cfccfm
		from FMT001
		where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoOrden.formato)#">
	</cfquery>
	<cfset form.EOnumero = rsTipoOrden.EOnumero >
	<cfset form.conImpresion = "N" >
	
	<cfif rsFormato.FMT01tipfmt eq 1 >
		<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
		<cfinclude template="../../Utiles/validaUri.cfm">
		<cfset LvarOk = validarUrl( trim(rsFormato.FMT01cfccfm) ) >
		<cfif not LvarOK >
			<cf_errorCode	code = "50274"
							msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
							errorDat_1="#LvarSPhomeuri#"
			>
		</cfif>
	</cfif> 
</cfif>

<cfif isdefined("LvarArchivo") > 	
    <cfinclude template="#LvarArchivo#">
	<cfset bandImpresion = true>
<cfelse>
	<cfif rsTipoOrden.RecordCount GT 0>
		<cfinclude template= "/sif/reportes/#session.Ecodigo#_#rsTipoOrden.Formato#.cfm">
	<cfelse>
		<script>alert('No hay Formato de Impresión para esta Solicitud.');</script>
	</cfif>
	<cfset bandImpresion = true>		
</cfif>



