<cfparam name="url.id_persona" type="numeric">
<cfparam name="url.pariente" type="numeric">

<cfquery datasource="#session.dsn#" name="sujeto">
	delete sa_pariente
	where sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	  and pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pariente#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cflocation url="familiares.cfm?id_persona=#URLEncodedFormat(url.id_persona)#">