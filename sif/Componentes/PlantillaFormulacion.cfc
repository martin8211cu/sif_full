<cfcomponent>
	<!---=======Agrega una nueva Plantilla de la Formulacion de Presupuesto=======--->
	<cffunction name="AltaPlantilla"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    	type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    	type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPEPdescripcion" 		type="string"  required="yes">
		<cfargument name="FPCCtipo"  			type="string"  required="yes">
		<cfargument name="FPCCconcepto"  		type="string"  required="yes">
		<cfargument name="FPEPnotas" 	    	type="string"  required="no">
		<cfargument name="BMUsucodigo"      	type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="PCGDxCantidad"  		type="numeric" required="no" default="0">
		<cfargument name="PCGDxPlanCompras"  	type="numeric" required="no" default="0">
		<cfargument name="PCGDmultiperiodo"    	type="numeric" required="no" default="0">
		<cfargument name="CFid"	 			 	type="numeric" required="no">
		<cfargument name="FPEPmultiperiodo"	 	type="numeric" required="no" default="0">
		<cfargument name="FPAEid"	 			type="numeric" required="no" default="-1">
		<cfargument name="CFComplemento"	 	type="string"  required="no" default="">
		<cfargument name="FPEPnomodifica"	 	type="boolean" required="no" default="0">
		<cfif not isdefined('Arguments.CFid') or Arguments.CFid eq -1>
			<cfset Arguments.CFid = 'null'>
		<cfelse>
			<cfquery name="rsFPDCentrosF" datasource="#Arguments.Conexion#">
				select 1
				from FPDCentrosF a inner join FPEPlantilla b on b.FPEPid = a.FPEPid
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
			</cfquery>
			<cfif rsFPDCentrosF.recordcount eq 0>
				<cfthrow message="No se puede actulizar la plantilla, el centro funcional que compra debe de estar incluido en la plantilla, Proceso cancelado">
			</cfif>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaPlantilla">
			insert into FPEPlantilla
			(Ecodigo,FPEPdescripcion,FPCCtipo,FPEPnotas,BMUsucodigo,FPCCconcepto, PCGDxCantidad,PCGDxPlanCompras,CFid,FPEPmultiperiodo,FPAEid,CFComplemento,FPEPnomodifica)
			values
			(
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPEPdescripcion)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCtipo)#" null="#LEN(TRIM(Arguments.FPCCtipo)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPEPnotas)#" len="256">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCconcepto)#" null="#LEN(TRIM(Arguments.FPCCconcepto)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDxCantidad#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDxPlanCompras#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFid#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEPmultiperiodo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPAEid#" null="#Arguments.FPAEid eq -1#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.CFComplemento#" null="#LEN(TRIM(Arguments.CFComplemento)) EQ 0#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEPnomodifica#">
			)
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaPlantilla">
			  <cfreturn #rsAltaPlantilla.identity#>
	</cffunction>
	<!---=======Agrega una nueva Clasificacion de concepto a una Plantilla de la Formulacion de Presupuesto=======--->
	<cffunction name="AltaPlantillaConcep"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  	required="no" default="#session.dsn#">
		<cfargument name="FPEPid" 			type="numeric"  required="yes">
		<cfargument name="FPCCid"  			type="numeric"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" 	required="no" default="#Session.Usucodigo#">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaPlantillaConcep">
			insert into FPDPlantilla
			(FPEPid,FPCCid,BMUsucodigo)
			values
			(
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEPid#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCCid#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			)
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaPlantillaConcep">
			  <cfreturn #rsAltaPlantillaConcep.identity#>
	</cffunction>
	
	<!---=======Elimina una Clasificacion de concepto a una Plantilla de la Formulacion de Presupuesto=======--->
	<cffunction name="BajaPlantillaConcep"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  	required="no" default="#session.dsn#">
		<cfargument name="FPDPid" 			type="numeric"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		
		
		<cfquery name="rsFPDPlantilla" datasource="#session.dsn#">
			select FPEPid, FPCCid
			from FPDPlantilla
			where FPDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPDPid#">
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsFPDEstimacion">
			select count(1) cantidad
			from FPDEstimacion ed 
				inner join FPEEstimacion ee on ee.FPEEid = ed.FPEEid 
			where ed.FPCCid = #rsFPDPlantilla.FPCCid# and ed.FPEPid = #rsFPDPlantilla.FPEPid# and ee.FPEEestado <> 7
		</cfquery>
		<cfif rsFPDEstimacion.cantidad gt 0>
			<cfthrow message="No se puede eliminar el concepto, este posee dependencia con detalles de estimaciones, Proceso cancelado">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from FPDPlantilla
			where
			FPDPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPDPid#">
		</cfquery>
		<cfreturn #Arguments.FPDPid#>
	</cffunction>
	
	<!---=======Agrega un Centro Funcional a una Plantilla de la Formulacion de Presupuesto=======--->
	<cffunction name="AltaPlantillaCentro"  access="public">
		<cfargument name="Conexion" 	    type="string"  	required="no" default="#session.dsn#">
		<cfargument name="FPEPid" 			type="numeric"  required="yes">
		<cfargument name="CFid"  			type="numeric"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="includeAll"       type="boolean" required="no" default="false">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsCFuncional">
			select CFcodigo from CFuncional where CFid = #Arguments.CFid#
		</cfquery>
		<cfif rsCFuncional.RecordCount EQ 0>
			<cfthrow message="El centro funcional enviado no existe.">
		</cfif>
			
		<cfif NOT Arguments.includeAll>
			<cfquery datasource="#Arguments.Conexion#" name="rsAltaPlantillaCentro">
				insert into FPDCentrosF
				(FPEPid,CFid,BMUsucodigo)
				values
				(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEPid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
				)
			</cfquery>
		<cfelse>
			<cfinvoke component="sif.Componentes.FP_SeguridadUsuario" method="fnGetHijosCF" returnvariable="LSCFuncional">
				<cfinvokeargument name="query" value="#rsCFuncional#">
			</cfinvoke>
			<cfif LSCFuncional NEQ -1>
				<cfloop list="#LSCFuncional#" index="ElementCFid">
					<cfquery datasource="#Arguments.Conexion#" name="rsCFexist">
						select count(1) cantidad
							from FPDCentrosF 
						where FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
						  and CFid   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#ElementCFid#">
					</cfquery>
					<cfif rsCFexist.cantidad EQ 0>
						<cfquery datasource="#Arguments.Conexion#" name="rsAltaPlantillaCentro">
							insert into FPDCentrosF
							(FPEPid,CFid,BMUsucodigo)
							values
							(
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEPid#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#ElementCFid#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
							)
						</cfquery>
					</cfif>
				</cfloop>
			<cfelse>
				<cfthrow message="No se pudieron Recuperar los Centro Funcional Asociados. Puede que los Path estén Dañados.">
			</cfif>
		</cfif>
	</cffunction>
	
	<!---=======Elimina un Centro Funcional a una Plantilla de la Formulacion de Presupuesto=======--->
	<cffunction name="BajaPlantillaCentro"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  	required="no" default="#session.dsn#">
		<cfargument name="FPDCFid" 			type="numeric"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" 	required="no" default="#Session.Usucodigo#">
		
		<cfquery name="rsFPDCentrosF" datasource="#session.dsn#">
			select FPEPid, CFid
			from FPDCentrosF
			where FPDCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPDCFid#">
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsFPDEstimacion">
			select count(1) cantidad
			from FPDEstimacion ed 
				inner join FPEEstimacion ee on ee.FPEEid = ed.FPEEid 
			where ee.CFid = #rsFPDCentrosF.CFid# and ed.FPEPid = #rsFPDCentrosF.FPEPid# and ee.FPEEestado <> 7
		</cfquery>
		<cfif rsFPDEstimacion.cantidad gt 0>
			<cfthrow message="No se puede eliminar el centro funcional, este posee dependencia con detalles de estimaciones, Proceso cancelado">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from FPDCentrosF
			where
			FPDCFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPDCFid#">
		</cfquery>
		<cfreturn #Arguments.FPDCFid#>
	</cffunction>
	
	<!---=======Modifica una Plantilla de la Formulacion de Presupuesto===============--->
	<cffunction name="CambioPlantilla" access="public">
		<cfargument name="Conexion" 	    	type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    	type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPEPid" 	    		type="numeric" required="yes">
		<cfargument name="FPEPdescripcion" 		type="string"  required="yes">
		<cfargument name="FPCCtipo"  			type="string"  required="yes">
		<cfargument name="FPCCconcepto"  		type="string"  required="yes">
		<cfargument name="FPEPnotas" 	    	type="string"  required="no">
		<cfargument name="BMUsucodigo"      	type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="ts_rversion"      	type="any" 	   required="yes">
		<cfargument name="PCGDxCantidad"  		type="numeric" required="no" default="0">
		<cfargument name="PCGDxPlanCompras"  	type="numeric" required="no" default="0">
		<cfargument name="PCGDmultiperiodo"    	type="numeric" required="no" default="0">
		<cfargument name="CFid"	 			 	type="numeric" required="no">
		<cfargument name="FPEPmultiperiodo"	 	type="numeric" required="no" default="0">
		<cfargument name="FPAEid"	 			type="numeric" required="no" default="-1">
		<cfargument name="CFComplemento"	 	type="string"  required="no" default="">
		<cfargument name="FPEPnomodifica"	 	type="boolean" required="no" default="0">
		
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPEPlantilla"redirect="Plantillas.cfm?FPEPid=#Arguments.FPEPid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPEPid" 
			type1="numeric"
			value1="#Arguments.FPEPid#">
			
		<cfif not isdefined('Arguments.CFid') or Arguments.CFid eq -1>
			<cfset Arguments.CFid = 'null'>
		<cfelse>
			<cfquery name="rsFPDCentrosF" datasource="#Arguments.Conexion#">
				select 1
				from FPDCentrosF a inner join FPEPlantilla b on b.FPEPid = a.FPEPid
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
			</cfquery>
			<cfif rsFPDCentrosF.recordcount eq 0>
				<cfthrow message="No se puede actulizar la plantilla, el centro funcional que compra debe de estar incluido en la plantilla, Proceso cancelado">
			</cfif>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			Update FPEPlantilla set 	 
			 FPEPdescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPEPdescripcion)#">,
			 FPCCtipo 			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCtipo)#" 			null="#LEN(TRIM(Arguments.FPCCtipo)) EQ 0#">,
			 FPCCconcepto		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCconcepto)#" 		null="#LEN(TRIM(Arguments.FPCCconcepto)) EQ 0#">,
			 FPEPnotas 			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPEPnotas)#" 		len="256">,
			 BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">,
			 PCGDxCantidad		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.PCGDxCantidad#">,
			 PCGDxPlanCompras	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.PCGDxPlanCompras#">,
			 CFid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#">,
			 FPEPmultiperiodo	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPmultiperiodo#">,
			 FPAEid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#" 					null="#Arguments.FPAEid eq -1#">,
			 CFComplemento		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CFComplemento#" 			null="#LEN(TRIM(Arguments.CFComplemento)) EQ 0#">,
			 FPEPnomodifica		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPnomodifica#">
		    where FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
		</cfquery>
	</cffunction>
	
	<!---=======Elimina Plantilla de la Formulacion de Presupuesto================--->
	<cffunction name="BajaPlantilla"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPEPid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsFPDEstimacion">
			select count(1) cantidad
			from FPDEstimacion ed 
				inner join FPEEstimacion ee on ee.FPEEid = ed.FPEEid 
			where ed.FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				and ee.FPEEestado <> 7
		</cfquery>
		<cfif rsFPDEstimacion.cantidad gt 0>
			<cfthrow message="No se puede eliminar la plantilla, esta posee dependencia con detalles de estimaciones, Proceso cancelado">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsPCGDplanCompras">
			select count(1) cantidad 
			from PCGDplanCompras pc 
			where pc.FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
		</cfquery>
		<cfif rsPCGDplanCompras.cantidad gt 0>
			<cfthrow message="No se puede eliminar la plantilla, esta posee dependencia con detalles al plan de compras, Proceso cancelado">
		</cfif>
		
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
				delete from FPDCentrosF
					where FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
				delete from FPDPlantilla
					where FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
				delete from FPEPlantilla
					where FPEPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
		</cfquery>
		</cftransaction>
	</cffunction>
	<!---Obtiene el todas las plantillas a las que tienen acceso una centro Funcional --->
	<cffunction name="GetPlantillasCF"  access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no" default="#session.dsn#">
		<cfargument name="CFid" 	type="numeric" required="yes">
		
		<cfquery name="Detalles" datasource="#Arguments.Conexion#">
			select EP.FPEPid,EP.FPEPdescripcion,EP.FPCCconcepto, EP.PCGDxCantidad, EP.FPEPmultiperiodo, EP.FPCCtipo, EP.FPAEid, EP.CFComplemento, EP.FPEPnomodifica, EP.CFid, EP.PCGDxPlanCompras,EP.FPEPnotas
				from FPEPlantilla EP
					inner join FPDCentrosF CFP
						on CFP.FPEPid = EP.FPEPid
			 where CFP.CFid = #Arguments.CFid#
			 order by EP.FPEPdescripcion
		</cfquery>
		<cfreturn Detalles>
	</cffunction>
</cfcomponent>