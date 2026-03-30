<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select GECVid, GECVcodigo, GECVdescripcion, GECVnivel
		from GEClasificacionViaticos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(GECVcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.GECVid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="<cfoutput>#rs.GECVcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.GECVdescripcion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.nivel#</cfoutput>.value="<cfoutput>#rs.GECVnivel#</cfoutput>";
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