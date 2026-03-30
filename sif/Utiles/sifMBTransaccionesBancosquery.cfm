<!--- Recibe conexion, form, name, desc, ecodigo, dato por URL  --->

<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#url.conexion#">
		select Bid, BTEcodigo, BTEdescripcion, case when BTEtipo ='C' then 'Crédito' else 'Débito' end as BTEtipo
		from TransaccionesBanco 
		where 
		Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Banco#">
		and BTEtce = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTEtce#">
		and rtrim(ltrim(upper(BTEcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
	</cfquery>

	<script language="JavaScript">
		var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.Bid#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.BTEcodigo#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.BTEdescripcion#</cfoutput>";
		parent.document.<cfoutput>#url.form#.#url.tipo#</cfoutput>.value="<cfoutput>#rs.BTEtipo#</cfoutput>";
		
		<!--- Esto es utilizado para limpiar el tag de MBTransaccionesBancos --->
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
			parent.ClearPlaza();
		}
	</script>
</cfif>
