<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfset LvarValor = Trim(url.valor)>
	<cfloop condition="Len(LvarValor) LT 4">
		<cfset LvarValor = "0" & LvarValor>
	</cfloop>
	<cfquery name="rs" datasource="#session.DSN#">
		select Cmayor, Cdescripcion, PCEMid
		from CtasMayor
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarValor#">
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and Cmayor not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.Cmayor)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.Cdescripcion)#</cfoutput>";
			<cfif isdefined("Url.cargar_mascara")>
				window.parent.document.<cfoutput>#url.formulario#.#url.cargar_mascara#</cfoutput>.value="<cfoutput>#trim(rs.PCEMid)#</cfoutput>";
			</cfif>	
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			<cfif isdefined("Url.cargar_mascara")>
				window.parent.document.<cfoutput>#url.formulario#.#url.cargar_mascara#</cfoutput>.value="";
			</cfif>
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	</cfif>
</cfif>


