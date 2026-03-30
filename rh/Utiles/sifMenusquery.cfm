<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="asp">
		select id_menu, id_root, nombre_menu, orden_menu, case when ocultar_menu=1 then 'X' else ' ' end as ocultar_x
		from SMenu
		where 1=1
		and id_root = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
		
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and id_menu not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.id_menu#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.id_root)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.nombre_menu)#</cfoutput>";
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


