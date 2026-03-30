<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select RHPPid, RHPPcodigo, RHPPdescripcion
		from RHPlazaPresupuestaria
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.RHPPid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.RHPPcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHPPdescripcion#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>