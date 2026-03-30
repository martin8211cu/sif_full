<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<!--- <cfdump var="#url#"> --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.DSN#">
		select a.PRJAid, a.PRJAcodigo, a.PRJAdescripcion 
		from PRJActividad a, PRJproyecto b
		where upper(a.PRJAcodigo)=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Ucase(url.dato))#">
		and a.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.proyecto#">
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.PRJid=b.PRJid
	</cfquery>
<!--- <cfdump var="#rs#"> --->
	<cfif rs.recordCount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value="<cfoutput>#rs.PRJAid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.PRJAcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.PRJAdescripcion)#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>
