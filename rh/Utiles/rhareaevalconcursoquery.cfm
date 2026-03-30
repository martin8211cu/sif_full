<!--- Recibe conexion, form, name, desc, ecodigo, dato por URL  --->


<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select RHEAid, rtrim(ltrim(RHEAcodigo)) as RHEAcodigo, RHEAdescripcion, RHEApeso
		from RHEAreasEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
		and rtrim(ltrim(upper(RHEAcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.RHEAid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHEAcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHEAdescripcion#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.peso#</cfoutput>.value="<cfoutput>#rs.RHEApeso#</cfoutput>";
		
		<!--- Esto es utilizado para limpiar el tag de areaeavaconcurso en Reclutamieto y Selección --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
