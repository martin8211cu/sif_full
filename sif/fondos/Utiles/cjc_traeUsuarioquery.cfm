<!--- Recibe conexion, form, name, desc, dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">

	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		select CGE20NOL, CGE20NOC 
		from CGE020
		where CGE20NOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>

	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CGE20NOL)#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CGE20NOC)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.focus();
			alert("El Usuario no existe")
		</cfif>
	</script>
	
</cfif>

