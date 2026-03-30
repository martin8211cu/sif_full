<cfif isdefined("url.Tcodigo") and Len(Trim(url.Tcodigo)) NEQ 0>
	<cfquery name="rsTipoNomina" datasource="#Session.DSN#">
		select a.Tdescripcion, rtrim(a.Tcodigo) as Tcodigo
		from TiposNomina a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and upper(a.Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(UCase(url.Tcodigo))#">
		order by a.Tcodigo, a.Tdescripcion
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		window.parent.document.<cfoutput>#url.f#.#url.p3#</cfoutput>.value = "<cfoutput>#rsTipoNomina.Tdescripcion#</cfoutput>";
		window.parent.document.<cfoutput>#url.f#.#url.p2#</cfoutput>.value = "<cfoutput>#rsTipoNomina.Tcodigo#</cfoutput>";
	</script>
</cfif>
