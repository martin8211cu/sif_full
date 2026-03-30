<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select rtrim(ltrim(RHPcodigo)) as RHPcodigo, 
			coalesce(rtrim(ltrim(RHPcodigoext)),rtrim(ltrim(RHPcodigo))) as RHPcodigoext,
			RHPdescpuesto 
		from RHPuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
		and upper(coalesce(rtrim(ltrim(RHPcodigoext)),rtrim(LTrim(RHPcodigo)))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>
	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHPcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.nameExt#</cfoutput>.value="<cfoutput>#rs.RHPcodigoext#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHPdescpuesto#</cfoutput>";
		<!--- Esto es utilizado para limpiar el tag de plazas en el formulario de acciones de personal --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
