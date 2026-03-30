<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Conta.dsn#">
		select CG5CON, CG5DES 
		from CGM005
		where CG5CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.dato#">
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CG5CON)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CG5DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("El asiento no existe")
		</cfif>
	</script>
</cfif>
