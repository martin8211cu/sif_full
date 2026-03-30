<!--- Recibe conexion, form, name, desc, ecodigo, dato por URL  --->


<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select GSNid, rtrim(ltrim(GSNcodigo)) as GSNcodigo, GSNdescripcion
		from GrupoSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
		and rtrim(ltrim(upper(GSNcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.GSNid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.GSNcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.GSNdescripcion#</cfoutput>";
		
		<!--- Esto es utilizado para limpiar el tag de GrupoSN en CxC --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
