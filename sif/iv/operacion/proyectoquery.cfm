<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<!--- <cfdump var="#url#"> --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.DSN#">
		select a.PRJid, a.PRJcodigo, a.PRJdescripcion 
		from PRJproyecto a
		where upper(a.PRJcodigo)=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Ucase(url.dato))#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>

	<cfif rs.recordCount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value="<cfoutput>#rs.PRJid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.PRJcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.PRJdescripcion)#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.PRJAid.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.PRJAcodigo.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.PRJAdescripcion.value="";
		</script>
	</cfif>
</cfif>
