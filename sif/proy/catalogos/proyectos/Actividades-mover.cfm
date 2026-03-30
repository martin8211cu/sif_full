<cfparam name="url.PRJid" type="numeric">
<cfparam name="url.from" type="numeric">
<cfparam name="url.to" type="numeric">

<cfquery datasource="#session.dsn#" name="from">
	select PRJAidPadre, PRJAid, PRJAorden, PRJApath
	from PRJActividad
	where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
	  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.from#">
</cfquery>

<cfif url.to is 0>
	<cfquery datasource="#session.dsn#">
		update PRJActividad
		set PRJAorden = 0, PRJAidPadre = null
		where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.from#">
	</cfquery>
<cfelse>
	<cfquery datasource="#session.dsn#" name="to">
		select PRJAidPadre, PRJAid, PRJAorden, PRJApath
		from PRJActividad
		where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.to#">
	</cfquery>
	
	<!--- asegurarse de que 'from' no sea hijo del 'to', sino no se hace nada --->
	<cfif Find(from.PRJApath, to.PRJApath) neq 1>
		<cfquery datasource="#session.dsn#">
			update PRJActividad
			set PRJAorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#to.PRJAorden + 1#">,
				PRJAidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#to.PRJAidPadre#" null="#Len(to.PRJAidPadre) is 0#">
			where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
			  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.from#">
		</cfquery>
	<cfelse>
		<cfoutput>WARNING: 'from' es hijo de 'to'<br>from.path:#from.PRJApath#<br>to.path:#to.PRJApath#</cfoutput>
	</cfif>
</cfif>


<cfinclude template="Actividades-reordenar.cfm">

<cflocation url="Actividades.cfm?PRJid=#URLEncodedFormat(url.PRJid)#&PRJAid=#URLEncodedFormat(url.from)#" addtoken="no">
<cfoutput>
<a href="Actividades.cfm?PRJid=#URLEncodedFormat(url.PRJid)#&PRJAid=#URLEncodedFormat(url.from)#">seguir</a>
</cfoutput>