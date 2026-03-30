<!--- Recibe conexion, form, name, desc, ecodigo, dato por URL  --->

<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select BTid, BTcodigo, BTdescripcion, case when BTtipo ='C' then 'Crédito' else 'Débito' end as BTtipo
		from BTransacciones 
		where 
		Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and BTtce = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTtce#">
		and rtrim(ltrim(upper(BTcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.BTid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.BTcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.BTdescripcion#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.tipo#</cfoutput>.value="<cfoutput>#rs.BTtipo#</cfoutput>";
		
		<!--- Esto es utilizado para limpiar el tag de MBTransaccionesLibros --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
