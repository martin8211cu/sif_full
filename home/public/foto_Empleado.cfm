<cfset tempfile=''>
<cfparam name="url.ts" default="0">
<cfparam name="url.Usucodigo" default="0">

<cfif not isdefined("url.DEid") or ( isdefined("url.DEid")  and not len(trim(url.DEid)))>
	<cfset url.DEid=-1>
	<cfquery datasource="#session.dsn#" name="rsInfoFotoEmpleado">
		select coalesce(max(ue.llave),-1) as llave
		from UsuarioReferencia ue
		where ue.STabla = 'DatosEmpleado'
		 and ue.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Usucodigo#">
	</cfquery>
	<cfif rsInfoFotoEmpleado.recordcount>
		<cfset url.DEid = rsInfoFotoEmpleado.llave>
	</cfif>
</cfif>

<cfif !fileExists(tempfile)>
	<cfquery datasource="#session.dsn#" name="rs" maxrows="1">
		select e.foto
		from RHImagenEmpleado e
		where e.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
	<cfif Len(rs.foto)>
		<cffile action="write" file="#tempfile#" output="#rs.foto#" >
	<cfelse>
		<cflocation url="/cfmx/sif/imagenes/UserIcon.png" addtoken="no">
	</cfif>
</cfif>
<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfcontent type="image/gif" file="#tempfile#">