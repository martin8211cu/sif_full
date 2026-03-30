<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		SELECT I92COD,I92DES FROM I92ARC
		where I92COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.I92COD)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.I92DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("El Impuesto no existe")
		</cfif>
	</script>
</cfif>

