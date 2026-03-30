<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		select CJM00COD,CJM00DES 
		from CJM000
		where CJM00EST='A' 
		and CJM00COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CJM00COD)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CJM00DES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("El fondo no existe")
		</cfif>
	</script>
</cfif>
