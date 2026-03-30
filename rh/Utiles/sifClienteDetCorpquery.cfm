<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select CDCcodigo, CDCidentificacion, CDCnombre,CDCtipo
		from ClientesDetallistasCorp
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
		and CDCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#url.valor#">
		
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and CDCcodigo not in (#url.Excluir#)
		</cfif>
	</cfquery>
	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.CDCcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.CDCidentificacion)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CDCnombre)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.tipo#</cfoutput>.value="<cfoutput>#trim(rs.CDCtipo)#</cfoutput>";			
			if (window.parent.func<cfoutput>#url.codigo#</cfoutput>) {window.parent.func<cfoutput>#url.codigo#</cfoutput>()}
		</script>
	<cfelse>
		<script language="JavaScript">
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
				if (window.parent.func<cfoutput>#url.codigo#</cfoutput>) {window.parent.func<cfoutput>#url.codigo#</cfoutput>()}
		</script>
	</cfif>
</cfif>
