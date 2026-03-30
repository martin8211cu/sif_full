<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.tramites.dsn#">
		select id_requisito, codigo_requisito, nombre_requisito,costo_requisito,moneda
		from TPRequisito
		where upper(codigo_requisito) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and id_requisito not in (#url.excluir#)
		</cfif>
	</cfquery>
	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.id_requisito#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.codigo_requisito)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.nombre_requisito#</cfoutput>";
			<cfif isdefined("url.otrosdatos") and len(trim(url.otrosdatos)) and url.otrosdatos eq 'SI'> 
				window.parent.document.<cfoutput>#url.formulario#</cfoutput>.MontoR.value = "<cfoutput>#rs.moneda#</cfoutput> <cfoutput>#rs.costo_requisito#</cfoutput>"
				//window.parent.document.<cfoutput>#url.formulario#</cfoutput>.moneda.value = "<cfoutput>#rs.moneda#</cfoutput>";
				//window.parent.document.<cfoutput>#url.formulario#</cfoutput>.costo_requisito.value = "<cfoutput>#rs.costo_requisito#</cfoutput>";
			</cfif>			
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfif isdefined("url.otrosdatos") and len(trim(url.otrosdatos)) and url.otrosdatos eq 'SI'> 
				window.parent.document.<cfoutput>#url.formulario#</cfoutput>.MontoR.value = "";
			</cfif>					
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	</cfif>
</cfif>