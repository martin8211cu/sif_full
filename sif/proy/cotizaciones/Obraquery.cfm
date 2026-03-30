<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.DSN#">
		select a.PRJPOid, a.PRJPOcodigo, a.PRJPOdescripcion 
		from PRJPobra a
		where upper(a.PRJPOcodigo)=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Ucase(url.dato))#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	
	<cfif rs.recordCount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value="<cfoutput>#rs.PRJPOid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.PRJPOcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.PRJPOdescripcion)#</cfoutput>";
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>
