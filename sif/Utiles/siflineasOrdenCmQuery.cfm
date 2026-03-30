<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select Cid, Ccodigo, Cdescripcion
		from Conceptos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(Ccodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
			and upper(Ctipo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(url.tipo))#">
		</cfif>
		<cfif isdefined("url.filtroextra") and len(trim(url.filtroextra))>
			#url.filtroextra#
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.Cid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="<cfoutput>#rs.Ccodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Cdescripcion#</cfoutput>";
			
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