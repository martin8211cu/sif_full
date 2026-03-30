<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#url.conexion#">
		select Mcodigo, Mnombre 
		from Materia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
		and rtrim(ltrim(upper(Mcodificacion))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>
	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.Mcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Mnombre#</cfoutput>";	
	</script>
</cfif>