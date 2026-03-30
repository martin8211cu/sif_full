<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		select EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE
		from PLM001
		where EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	
	<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.EMPCOD#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.EMPCED)#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.NOMBRE)#</cfoutput>";
		<cfelse>	
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.focus();
			alert("El empleado no existe")
		</cfif>
	</script>
	
</cfif>


