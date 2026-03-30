<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>

	<cfquery name="rs" datasource="#session.DSN#">
		select Ucodigo, Udescripcion		
		from Unidades			 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Upper(Ucodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(Trim(url.dato))#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">			
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.Ucodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="<cfoutput>#Ucase(rs.Ucodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.Udescripcion)#</cfoutput>";
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
			alert("El codigo de unidad no existe")
		</script>			
	</cfif>
</cfif>