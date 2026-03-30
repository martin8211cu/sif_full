<cfparam name="url.PRJid" type="numeric">
<cfparam name="url.PRJAid" type="numeric">
<cfparam name="url.i" type="numeric" default="1">
<cfparam name="url.previo" type="numeric" default="0">

<!--- <cfdump var="#url#"> --->

<cftransaction>
<cfif url.i is 1>
	<cfquery datasource="#session.dsn#">
		update PRJActividad
		set PRJAidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.previo#">
		where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#">
	</cfquery>
<cfelseif url.i is -1>
	<cfquery datasource="#session.dsn#" name="padre">
		select padre.PRJAidPadre as padre
		from PRJActividad actual
			left outer join PRJActividad padre
				on padre.PRJAid = actual.PRJAidPadre
			   and padre.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		where actual.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		  and actual.PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#">
		  
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update PRJActividad
		set PRJAidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#padre.padre#" null="#Len(padre.padre) is 0#">
		where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#">
	</cfquery>
</cfif>


<!--- actualizar la estructura del arbol: PRJApath y PRJAnivel --->

	<cfinclude template="Actividades-reordenar.cfm">
</cftransaction>

<cflocation url="Actividades.cfm?PRJid=#URLEncodedFormat(url.PRJid)#&PRJAid=#URLEncodedFormat(url.PRJAid)#" addtoken="no">
<cfoutput>
<a href="Actividades.cfm?PRJid=#URLEncodedFormat(url.PRJid)#&PRJAid=#URLEncodedFormat(url.PRJAid)#">seguir</a>
</cfoutput>