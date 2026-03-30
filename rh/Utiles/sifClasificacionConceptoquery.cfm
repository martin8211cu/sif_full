<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select CCid, CCcodigo, CCdescripcion, CCnivel
		from CConceptos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(CCcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.CCid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="<cfoutput>#rs.CCcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.CCdescripcion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.nivel#</cfoutput>.value="<cfoutput>#rs.CCnivel#</cfoutput>";
			<cfoutput>
				if (window.parent.func#url.name#) { window.parent.func#url.name#();}			
			</cfoutput>

		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.nivel#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>