<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		SELECT EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE
		FROM PLM001
		where  EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	<cfquery name="departamento" datasource="#session.Fondos.dsn#">
		SELECT PLM001.DEPCOD,PLX002.DEPDES,PLM001.EMPCOD
		FROM PLX002,PLM001 
		where PLX002.DEPCOD  = PLM001.DEPCOD
		 AND EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>		
	
	<script language="JavaScript">
	function AsignarDep(llave){
		<cfoutput>
		    window.parent.document.#url.form#.#url.name2#.value="";
		    window.parent.document.#url.form#.#url.desc2#.value="";
		</cfoutput>
	
		<cfoutput query="departamento">
			if (#Trim(departamento.EMPCOD)#==llave) {
				window.parent.document.#url.form#.#url.name2#.value="#trim(departamento.DEPCOD)#";
				window.parent.document.#url.form#.#url.desc2#.value="#trim(departamento.DEPDES)#";
				
			}			
		</cfoutput>
	}
	<cfif rs.recordcount gt 0>
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.EMPCOD#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.EMPCED)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.NOMBRE)#</cfoutput>";
		AsignarDep(<cfoutput>#rs.EMPCOD#</cfoutput>)
	<cfelse>	
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.name2#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desc2#</cfoutput>.value="";
		alert("El empleado no existe")
	</cfif>
	</script>
</cfif>
