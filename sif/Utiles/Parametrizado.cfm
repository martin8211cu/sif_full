<cfquery name="rsParametrosGenDef" datasource="#Session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 5
</cfquery>
<cfif (rsParametrosGenDef.RecordCount EQ 0) or (rsParametrosGenDef.Pvalor EQ "N")>
	<cflocation url="/cfmx/sif/indexSif.cfm" addtoken="no">
</cfif>