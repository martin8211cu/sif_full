<cfcomponent>
	
	<cffunction name="AltaDetCatalogoProyectoObra"  access="public">
		<cfargument name="Conexion"				type="string"	required="no" 	default="#Session.Dsn#">
		<cfargument name="Ecodigo" 				type="numeric"  required="no" 	default="#Session.Ecodigo#">
		<cfargument name="BMUsucodigo"  		type="numeric"  required="no"	default="#Session.Usucodigo#">
		<!---argument insert catalogo--->		
		<cfargument name="PCEcatid"				type="numeric"  required="yes">
		<cfargument name="PCEcatidref" 			type="numeric"  required="yes">
		<cfargument name="PCDactivo"  			type="string"  	required="yes">
		<cfargument name="PCDvalor"  			type="string"  	required="yes">
		<cfargument name="PCDdescripcion"  		type="string"  	required="yes">
		<cfargument name="Ulocalizacion"  		type="string"  	required="no" 	default="00">
		
		<!---argument insert proyecto--->
		<cfargument name="OBPcodigo"    		type="string" 	required="yes">
		<cfargument name="OBPdescripcion" 		type="string"   required="yes">
		<cfargument name="OBTPid"  	        	type="numeric" 	required="yes">
		<cfargument name="PCEcatidObr"  		type="numeric" 	required="yes">
		<cfargument name="CFformatoPry"  		type="string"  	required="yes">
		
		<!---argument insert obras--->
		<cfargument name="OBOcodigo"    		type="string"  	required="no">		
		<cfargument name="OBOdescripcion" 		type="string"  	required="no">
		<cfargument name="OBOestado"  	    	type="string"  	required="yes">
		<!---<cfargument name="OBOfechaInicio"  		type="date"  	required="no" 	default="now()">
		<cfargument name="OBOfechaFinal"  		type="date"  	required="no"	default="now()">--->		
		<cfargument name="OBOresponsable"   	type="string"  	required="no"	default="#Session.Usucodigo#">		
		<cfargument name="CFformatoObr"			type="string"  	required="yes">
		<!---<cfargument name="OBOfechaInclusion" 	type="date"  	required="no"	default="now()">--->
		<cfargument name="OBOnumLiquidacion"  	type="numeric"  required="yes">
		<cfargument name="OBOtipoValorLiq"  	type="string"  	required="yes">
		<cfargument name="OBOmontoLiq"  		type="numeric"  required="yes">
		
		<!---insert detalle catalogo--->
				
		<cfquery name="A_Catalogos" datasource="#Arguments.Conexion#">
			insert into PCDCatalogo(PCEcatid,PCEcatidref,Ecodigo,PCDactivo,PCDvalor,PCDdescripcion,Usucodigo,
			Ulocalizacion)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.PCEcatid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.PCEcatidref#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">,
					 <!---<cfif (isDefined("Arguments.PCDactivo"))>1<cfelse>0</cfif>--->1,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.PCDvalor#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.PCDdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#">
					)
			<cf_dbidentity1 name="A_Catalogos" datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="A_Catalogos" datasource="#Session.DSN#" returnVariable="LvarPCDcatid">
		
		
		
		<!---insert proyecto--->		
		<cfquery name="proyectoNuevo" datasource="#Arguments.Conexion#">
			insert into OBproyecto(Ecodigo,OBPcodigo,PCDcatidPry,OBPdescripcion,OBTPid,PCEcatidObr,CFformatoPry)
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.OBPcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" 	value="#LvarPCDcatid#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.OBPdescripcion#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.OBTPid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.PCEcatidObr#">,
						 <cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.CFformatoPry#">
						)
				<cf_dbidentity1 name="proyectoNuevo" datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="proyectoNuevo" datasource="#Session.DSN#" returnVariable="LvarOBPid">
		<!---<cfreturn #LvarOBPid#>--->
		
		<!---Valores del Catálogo para la Obra--->
		<cfquery name="obrasXProyecto" datasource="#Arguments.Conexion#">
			select PCDcatid, PCDvalor, PCDdescripcion,a.PCEcatid 
			from PCDCatalogo a 
				inner join PCECatalogo b on a.PCEcatid = b.PCEcatid and b.PCEcatid = #Arguments.PCEcatidObr# 
					and	b.CEcodigo = #Session.CEcodigo#
			where not exists(select 1 from OBobra where OBPid = #LvarOBPid# AND PCDcatidObr = a.PCDcatid)
		</cfquery>		
		<cfloop query="obrasXProyecto">
				<!---inserta obra--->
			<cfset formatoObra = #Arguments.CFformatoObr#>
			<cfset formatoObra &= '-' & #obrasXProyecto.PCDvalor#>
			<!---<cfset Arguments.CFformatoObr &= '-' & #obrasXProyecto.PCDvalor#>---> 
			<cfquery name="obraNueva" datasource="#session.dsn#">
				insert into OBobra(Ecodigo,OBPid,OBOcodigo,PCDcatidObr,OBOdescripcion,OBOestado,
				OBOfechaInicio,OBOfechaFinal,OBOresponsable,CFformatoObr,OBOfechaInclusion,OBOnumLiquidacion,
				OBOtipoValorLiq,OBOmontoLiq,PCEcatidOG)
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOBPid#">,		 					 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#obrasXProyecto.PCDvalor#">,		 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#obrasXProyecto.PCDcatid#">,		 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#obrasXProyecto.PCDdescripcion#">,		 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOestado#">,				 
						 <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,				 
						 <!---<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OBOfechaInicio#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OBOfechaFinal#">,--->			 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOresponsable#">,
						 <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFformatoObr#">,--->	 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#formatoObra#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,				  
						 <!---<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OBOfechaInclusion#">,--->	 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOnumLiquidacion#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOtipoValorLiq#">, 
						 <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OBOmontoLiq#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#obrasXProyecto.PCEcatid#">)
				<cf_dbidentity1 name="obraNueva" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 name="obraNueva" datasource="#session.dsn#" returnVariable="LvarOBOid">	
		</cfloop>	
					
		<!---<cfreturn #LvarOBOid#>--->						
	</cffunction>
	
	<!---<cffunction name="AltaProyecto"  access="public" returntype="numeric">
		<cfargument name="Conexion"			type="string"   required="no" default="#Session.Dsn#">
		<cfargument name="Ecodigo" 			type="numeric"  required="no" default="#Session.Ecodigo#">
		<cfargument name="OBPcodigo"    		type="numeric"  required="no">		
		<cfargument name="PCDcatidPry"			type="numeric"   required="yes">
		<cfargument name="OBPdescripcion" 		type="numeric"  required="yes">
		<cfargument name="OBTPid"  	        	type="string"  required="yes">
		<cfargument name="PCEcatidObr"  		type="string"  required="yes">
		<cfargument name="CFformatoPry"  		type="string"  required="yes">
		
		<cfquery name="proyectoNuevo" datasource="#Arguments.Conexion#">
			insert into OBproyecto
				(Ecodigo,OBPcodigo,PCDcatidPry,OBPdescripcion,OBTPid,PCEcatidObr,CFformatoPry)
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBPcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPCDcatid#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBPdescripcion#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBTPid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCEcatidObr#">, 
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CFformatoPry#">
						)
			<cf_dbidentity1 name="proyectoNuevo" datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="proyectoNuevo" datasource="#Session.DSN#">
		<cfreturn #proyectoNuevo.identity#> 						
	</cffunction>
	
	<cffunction name="AltaObra"  access="public" returntype="numeric">
		<cfargument name="OBOcodigo"    		type="numeric"  required="no">		
		<cfargument name="PCDcatidObr"			type="numeric"   required="yes">
		<cfargument name="OBOdescripcion" 		type="numeric"  required="yes">
		<cfargument name="OBOestado"  	    	type="string"  required="yes">
		<cfargument name="OBOfechaInicio"  		type="string"  required="yes">
		<cfargument name="OBOfechaFinal"  		type="string"  required="yes">		
		<cfargument name="OBOresponsable"   	type="numeric"  required="no">		
		<cfargument name="CFformatoObr"			type="numeric"   required="yes">
		<cfargument name="OBOfechaInclusion" 	type="numeric"  required="yes">
		<cfargument name="OBOnumLiquidacion"  	type="string"  required="yes">
		<cfargument name="OBOtipoValorLiq"  	type="string"  required="yes">
		<cfargument name="OBOmontoLiq"  		type="string"  required="yes">
		
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into OBobra(Ecodigo,OBPid,OBOcodigo,PCDcatidObr,OBOdescripcion,OBOestado,
			OBOfechaInicio,OBOfechaFinal,OBOresponsable,CFformatoObr,OBOfechaInclusion,OBOnumLiquidacion, OBOtipoValorLiq,OBOmontoLiq)
			values (				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOBPid#">,
					 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCDcatidObr#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OBOdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOestado#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OBOfechaInicio#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOfechaFinal#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOresponsable#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFformatoObr#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OBOfechaInclusion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOnumLiquidacion#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OBOtipoValorLiq#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OBOmontoLiq#">)
			<cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnVariable="LvarOBOid">
		<cfreturn #proyectoNuevo.identity#> 						
	</cffunction>--->
	
</cfcomponent>