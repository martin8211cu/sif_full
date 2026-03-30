<!--- Recibe conexion, form, name, desc y dato --->
<cfquery name="rs" datasource="#url.conexion#">
	select RHPEid, rtrim(RHPEcodigo) as RHPEcodigo, RHPEdescripcion 
	from RHPuestosExternos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and upper(rtrim(RHPEcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
</cfquery>
<script language="JavaScript">
	window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.RHPEid#</cfoutput>";
	window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHPEcodigo#</cfoutput>";
	window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHPEdescripcion#</cfoutput>";
</script>
