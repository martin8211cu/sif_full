
<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		Select CDCExentoImp,CDCporcdesc
		from ClientesDetallistasCorp
		where CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.porcDesc#</cfoutput>.value="<cfoutput>#rs.CDCporcdesc#</cfoutput>";
			<cfif rs.CDCExentoImp EQ 1>
				window.parent.document.<cfoutput>#url.formulario#.#url.exen#</cfoutput>.checked=true;			
			<cfelse>
				window.parent.document.<cfoutput>#url.formulario#.#url.exen#</cfoutput>.checked=false;
			</cfif>
		</script>
	<cfelse>
		<script language="JavaScript">
				window.parent.document.<cfoutput>#url.formulario#.#url.porcDesc#</cfoutput>.value="0.00";
				window.parent.document.<cfoutput>#url.formulario#.#url.exen#</cfoutput>.checked=false;
		</script>
	</cfif>
</cfif>