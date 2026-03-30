<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select BTid, BTcodigo, BTdescripcion
		from BTransacciones
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and BTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
		
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and BTid not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.BTid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.BTcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.BTdescripcion)#</cfoutput>";
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			var params ="";		
			
			params = "<cfoutput>&id=#url.id#&desc=#url.desc#</cfoutput>";
			<cfif isdefined("url.excluir") and len(trim(url.excluir))>
				params = params + "&excluir=<cfoutput>#url.excluir#</cfoutput>";
			</cfif>				
			
			<!--- preguntar si deseo agregar la impresora o no--->
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			
				
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	</cfif>
</cfif>

