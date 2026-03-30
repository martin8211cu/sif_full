<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select CSNid, CSNcodigo, CSNdescripcion, CSNpath as path
		from CategoriaSNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(CSNcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
	</cfquery>
	<cfif isdefined("rs") and rs.RecordCount GT 0>
		<cfset nivel= #ListLen(rs.path,'/')#>
	</cfif>	
	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.CSNid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="<cfoutput>#rs.CSNcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.CSNdescripcion#</cfoutput>";
			<cfoutput>
				if (window.parent.func#url.name#) { window.parent.func#url.name#();}			
			</cfoutput>

		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>