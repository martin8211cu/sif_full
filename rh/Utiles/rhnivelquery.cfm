<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#url.conexion#">
		select rtrim(ltrim(NPcodigo)) as NPcodigo, NPdescripcion
		from NProfesional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
		and rtrim(ltrim(upper(NPcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>
	<script language="JavaScript">
		var descAnt = parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.NPcodigo#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.NPdescripcion#</cfoutput>";
	</script>
</cfif>
