<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select Ocodigo, FAM01CODD, FAM01DES, FAM01COD
		from FAM001
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(FAM01CODD) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.valor))#">
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and Ocodigo not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.Ocodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.FAM01CODD)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.FAM01DES)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.FAM01COD#</cfoutput>.value="<cfoutput>#trim(rs.FAM01COD)#</cfoutput>";
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.FAM01COD#</cfoutput>.value="";
			<cfoutput>if (window.parent.func#url.codigo#) {window.parent.func#url.codigo#()}</cfoutput>
		</script>
	</cfif>
</cfif>