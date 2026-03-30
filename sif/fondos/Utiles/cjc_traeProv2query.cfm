<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		SELECT PROCED,PROCOD,PRONOM FROM CPM002  
		where   PROCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.PROCOD#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.PROCED)#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.PRONOM)#</cfoutput>";
			window.parent.CambiarLink('<cfoutput>#rs.PROCOD#</cfoutput>');
		<cfelse>	
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			window.parent.CambiarLink('');
			alert("El proveedor no existe")
		</cfif>
	</script>
</cfif>

