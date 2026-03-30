<!--- Recibe conexion, form, name, desc, dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">

	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		select CP7SUB, CP7DES
		from CPM007
		where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.dato#">
	</cfquery>

	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CP7SUB)#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CP7DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.focus();
			alert("El Objeto de Gasto no existe")
		</cfif>
	</script>
	
</cfif>

