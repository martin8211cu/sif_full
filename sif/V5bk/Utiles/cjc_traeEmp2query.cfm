<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		SELECT EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE
		FROM PLM001
		where  EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.Fondos.dsn#">
		SELECT CJM014.TS1COD,CJM014.TR01NUT
		FROM CJM014,CATR01,PLM001 
		WHERE   CJM014.TS1COD = CATR01.TS1COD 
		AND 	CJM014.TR01NUT = CATR01.TR01NUT
		AND 	CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo#">
		AND		CATR01.EMPCOD=PLM001.EMPCOD
		AND 	PLM001.EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>	
<script language="JavaScript">
		<cfif rs.recordcount gt 0>
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.EMPCOD#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.EMPCED)#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.NOMBRE)#</cfoutput>";
			<cfif rs2.recordcount gt 0>
				<cfif rs2.recordcount gt 1>
					var dato 		= "<cfoutput>#url.dato#</cfoutput>";
					var formato   	=  "left=400,top=250,scrollbars=yes,resizable=yes,width=350,height=200"
					var direccion 	= "/cfmx/sif/V5/Utiles/cjc_tarjetas.cfm?dato="+dato
					window.parent.open(direccion,"",formato);
				<cfelse>	
					window.parent.document.<cfoutput>#url.form#.#url.desc2#</cfoutput>.value="<cfoutput>#trim(rs2.TR01NUT)#</cfoutput>";
				</cfif>
			<cfelse>			
				window.parent.document.<cfoutput>#url.form#.#url.desc2#</cfoutput>.value="";
			</cfif>	
		<cfelse>	
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.form#.#url.desc2#</cfoutput>.value="";

			alert("El empleado no existe")
		</cfif>
	</script>
</cfif>
