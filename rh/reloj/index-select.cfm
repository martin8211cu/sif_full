<cfquery datasource="#session.dsn#" name="busca">
	select RHRid, RHRdescripcion, RHRcodigo
	from RHRelojMarcador
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and RHRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo#">
	  and RHRpasswd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(form.passwd)#">
</cfquery>
<cfif busca.RecordCount>
	<cfset session.RHRid = busca.RHRid>
	<cfset session.RHRcodigo = busca.RHRcodigo>
	<cflocation url="reloj.cfm" addtoken="no">
<cfelse>
	<cfset session.RHRid = 0>
	<cflocation url="index.cfm" addtoken="no">
</cfif>