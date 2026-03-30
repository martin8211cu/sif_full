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
<cfquery datasource="asp" name="rs">
	set rowcount 1
	select e.Elogo
	from Empresa e
	where Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  and datalength (e.Elogo) > 1
	set rowcount 0
</cfquery>

<!--- </cfif> --->
<cfif rs.RecordCount EQ 0>
	<cflocation url="images/not_avail.gif">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.Elogo#" >
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
