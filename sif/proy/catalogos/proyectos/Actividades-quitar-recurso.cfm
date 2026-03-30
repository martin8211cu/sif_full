<cfparam name="url.PRJid" type="numeric">
<cfparam name="url.PRJAid" type="numeric">
<cfparam name="url.PRJRAid" type="numeric">

<cfquery datasource="#session.dsn#">
	delete PRJActividadRecurso
	where PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#">
	  and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
	  and PRJRAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJRAid#">
	  and exists (select 1 from PRJproyecto
	  where PRJproyecto.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
	    and PRJproyecto.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<cflocation url="Actividades.cfm?PRJid=#URLEncodedFormat(url.PRJid)#&PRJAid=#URLEncodedFormat(url.PRJAid)#" addtoken="no">
