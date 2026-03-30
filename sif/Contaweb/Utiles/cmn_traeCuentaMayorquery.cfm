<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Conta.dsn#">
		select CGM1IM,CTADES
		from CGM001
		where CGM1IM = <cfqueryparam cfsqltype="cf_sql_char" value="#url.dato#">
		and CGM1CD  is null 
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CGM1IM)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CTADES)#</cfoutput>";
		<cfelse>
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			alert("La cuenta mayor no existe")
		</cfif>
	</script>
</cfif>
