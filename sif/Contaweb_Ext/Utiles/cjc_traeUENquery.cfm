<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.dato") and url.dato NEQ "">

	<cfquery name="rs" datasource="#session.dsn#">
		SELECT Ocodigo, Oficodigo as CGE5COD, Odescripcion as CGE5DES
		FROM Oficinas
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
		<!---  
		SELECT CGE005.CGE5COD,CGE5DES FROM CGE005,CGE000  
		WHERE CGE005.CGE1COD = CGE000.CGE1COD
		and CGE005.CGE5COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
		--->
	</cfquery>

	<script language="JavaScript">
		
		<cfif rs.recordcount gt 0>	
		
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#trim(rs.Ocodigo)#</cfoutput>";
			
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.CGE5COD)#</cfoutput>";

			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.CGE5DES)#</cfoutput>";

			window.parent.document.<cfoutput>#Url.form#</cfoutput>.CGM1IM.disabled = false;
		<cfelse>

			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";

			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";

			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			
			window.parent.document.<cfoutput>#Url.form#</cfoutput>.CGM1IM.disabled = false;

			alert("La UEN no existe")

		</cfif>

	</script>

</cfif>


