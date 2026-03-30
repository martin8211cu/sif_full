<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.DSN#">
		select Ccodigo, Ccodigoclas, Cdescripcion
		from Clasificaciones
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Ccodigoclas=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	<script language="JavaScript">
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.Ccodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.Ccodigoclas#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Cdescripcion#</cfoutput>";
	</script>
</cfif>
