<!---
	** NO TODAS LAS TIENDAS ESTAN EN LA MISMA BASE DE DATOS, BUSCAR EL LOGO EN LA CENTRAL ** 
<cfquery datasource="#session.dsn#" name="rs">
	set rowcount 1
	select img_logo as logo
	from ArteTienda
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	set rowcount 0
</cfquery>
<cfif rs.RecordCount EQ 0 or Len(rs.logo) EQ 0>
--->
<cfparam name="url.fid" default="0">
<cfquery datasource="#session.dsn#" name="rs">
	set rowcount 1
	select ia.IAimagen
	from Articulos e
		join ImagenArt ia
			on ia.Aid = e.Aid
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tid#">
	  and e.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  <cfif url.fid>
	  and ia.ILinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fid#">
	  </cfif>
	  and datalength (ia.IAimagen) > 1
	set rowcount 0
</cfquery>

<!--- </cfif> --->
<cfif rs.RecordCount EQ 0>
	<cflocation url="images/not_avail.gif">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.IAimagen#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
