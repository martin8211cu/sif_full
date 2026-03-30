<cfcomponent>

	<cfset rsFPCCconcepto = QueryNew("ID","VarChar")>
	<cfset QueryAddRow(rsFPCCconcepto, 10)>
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "1", 1)> <!---Otros--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "2", 2)> <!---Concepto Salarial--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "3", 3)> <!---Amortización de prestamos--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "4", 4)> <!---Financiamiento--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "5", 5)> <!---Patrimonio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "6", 6)> <!---Ventas--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "F", 7)> <!---Activos--->
	<cfset ListFPCCconcepto = left(ValueList(rsFPCCconcepto.ID), LEN(ValueList(rsFPCCconcepto.ID))-3)> 
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "S", 8)> <!---Servicio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "A", 9)> <!---Articulos de Inventario--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "P", 10)><!---Obras en Proceso--->
	<cfset ListFPCCconceptoALL = ValueList(rsFPCCconcepto.ID)> 
	<cfset ExigeAuxiliar = "F,A,S,P">
	
	<!---=======Agrega una nueva Clasificacion de Concepto de Gasto o Ingreso=======--->
	<cffunction name="AltaClasificacionConcepto"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPCCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCCdescripcion"  type="string"  required="yes">
		<cfargument name="FPCCtipo" 	    type="string"  required="no">
		<cfargument name="FPCCconcepto"     type="string"  required="no">
		<cfargument name="FPCCcomplementoC" type="string"  required="no" default="">
		<cfargument name="FPCCcomplementoP" type="string"  required="no" default="">
		<cfargument name="FPCCidPadre" 		type="numeric" required="yes" default="-1">
		<cfargument name="FPCCTablaC"       type="numeric" required="no">
		<cfargument name="FPCCExigeFecha"   type="numeric" required="no" default="0">
		<cfargument name="FormatoCuenta"       type="string" required="no">
		<cfargument name="EspecificaCuenta"   type="numeric" required="no" default="0">
		<cfargument name="CFcuenta"   		type="numeric" required="no">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		
		
		<cfif Arguments.FPCCidPadre EQ -1>
			<cfset Arguments.FPCCidPadre = "null">
		</cfif>
		<!---==Valida la Clasificación de Conceptos de Servicio==--->
		<cfif isdefined('Arguments.FPCCconcepto') and ListFind('S,P', Arguments.FPCCconcepto) and isdefined('Arguments.FPCCTablaC')>
			<cfquery datasource="#Arguments.Conexion#" name="CConceptos">
				select count(1) cantidad 
					from CConceptos 
				where CCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPCCTablaC#">
			</cfquery>
			<cfif CConceptos.cantidad EQ 0>
				<cfthrow message="El codigo de la Clasificación de Conceptos de Servicio es incorrecto (CCid = #Arguments.FPCCTablaC#)">
			</cfif>
		</cfif>
		<!---==Valida la Categoria del Activo Fijo===============--->
		<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'F' and isdefined('Arguments.FPCCTablaC')>
			<cfquery datasource="#Arguments.Conexion#" name="ACategoria">
				select count(1) cantidad 
					from AClasificacion 
				where AClaId = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPCCTablaC#">
			</cfquery>
			<cfif ACategoria.cantidad EQ 0>
				<cfthrow message="El codigo de la Categoria es incorrecto (ACatId = #Arguments.FPCCTablaC#)">
			</cfif>
		</cfif>
		<!---==Valida las Clasificacion de Articulos de Inventario====--->
		<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'A' and isdefined('Arguments.FPCCTablaC')>
			<cfquery datasource="#Arguments.Conexion#" name="Clasificaciones">
				select count(1) cantidad 
					from Clasificaciones 
				where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Ecodigo#">
				  and Ccodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPCCTablaC#">
			</cfquery>
			<cfif Clasificaciones.cantidad EQ 0>
				<cfthrow message="El codigo de la Clasificación de Servicio es incorrecto (Ccodigo = #Arguments.FPCCTablaC#)">
			</cfif>
		</cfif>
		
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#" name="rsAltaConcepto">
				insert into FPCatConcepto
				(Ecodigo,FPCCcodigo,FPCCdescripcion,FPCCtipo,FPCCconcepto,FPCCcomplementoC,FPCCcomplementoP,FPCCidPadre,BMUsucodigo,FPCCExigeFecha,
				 FormatoCuenta, EspecificaCuenta,CFcuenta 
				 <cfif isdefined('Arguments.FPCCTablaC')>
				 ,FPCCTablaC
				 </cfif>)
				values
				(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCcodigo)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCdescripcion)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCtipo)#" 			null="#LEN(TRIM(Arguments.FPCCtipo)) EQ 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCconcepto)#" 		null="#LEN(TRIM(Arguments.FPCCconcepto)) EQ 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCcomplementoC)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoC)) EQ 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCCcomplementoP)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoP)) EQ 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Trim(Arguments.FPCCidPadre)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCCExigeFecha#">
				<cfif isdefined('Arguments.FormatoCuenta')>
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.FormatoCuenta#">
				<cfelse>
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
				</cfif>
				,<cf_jdbcquery_param cfsqltype="cf_sql_bit" 		  value="#Arguments.EspecificaCuenta#">
			  <cfif isdefined('Arguments.CFcuenta')>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.CFcuenta#">
				<cfelse>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
			  </cfif>				
			  <cfif isdefined('Arguments.FPCCTablaC')>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.FPCCTablaC#">
			  </cfif>
				)
			<cf_dbidentity1>
			</cfquery>
				  <cf_dbidentity2 name="rsAltaConcepto">
			<!---Actualiza el concepto Financiero en la Clasificación de Conceptos de Servicio --->
			<cfif isdefined('Arguments.FPCCconcepto') and ListFind('S,P', Arguments.FPCCconcepto) and isdefined('Arguments.FPCCTablaC') and (LEN(TRIM(Arguments.FPCCcomplementoC)) or LEN(TRIM(Arguments.FPCCcomplementoP)))>
			 	<cfinvoke component="sif.Componentes.AD_CConceptos" method="CambioCFcomplemento">
					<cfinvokeargument name="CCid" 	 value="#Arguments.FPCCTablaC#">
					<cfinvokeargument name="cuentac" value="#Trim(Arguments.FPCCcomplementoC)##Trim(Arguments.FPCCcomplementoP)#">	
				</cfinvoke>
			 </cfif>
			 <!---Actualiza el concepto Financiero en la Categoria del Activo Fijo--->
			<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'F' and isdefined('Arguments.FPCCTablaC') and (LEN(TRIM(Arguments.FPCCcomplementoC)) or LEN(TRIM(Arguments.FPCCcomplementoP)))>
			 	<cfinvoke component="sif.Componentes.AF_CategoriaClase" method="CambioCFcomplemento">
					<cfinvokeargument name="ACatId"  value="#Arguments.FPCCTablaC#">
					<cfinvokeargument name="cuentac" value="#Trim(Arguments.FPCCcomplementoC)##Trim(Arguments.FPCCcomplementoP)#">	
				</cfinvoke>
		   </cfif>
		    <!---Actualiza la Clasificacion de Articulos de Inventario--->
			<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'A' and isdefined('Arguments.FPCCTablaC') and (LEN(TRIM(Arguments.FPCCcomplementoC)) or LEN(TRIM(Arguments.FPCCcomplementoP)))>
			 	<cfinvoke component="sif.Componentes.IV_Clasificaciones" method="CambioCFcomplemento">
					<cfinvokeargument name="Ccodigo"  value="#Arguments.FPCCTablaC#">
					<cfinvokeargument name="cuentac"  value="#Trim(Arguments.FPCCcomplementoC)##Trim(Arguments.FPCCcomplementoP)#">	
				</cfinvoke>
		   </cfif>
		   <cfset updatePath(Arguments.Conexion,Arguments.Ecodigo,rsAltaConcepto.identity)>
		</cftransaction>
		 
			  <cfreturn #rsAltaConcepto.identity#>
	</cffunction>
	<!---=======Agrega un nuevo Concepto de Gasto o Ingreso=======--->
	<cffunction name="AltaConcepto"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 		    type="numeric" required="no">
		<cfargument name="FPCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCdescripcion"  	type="string"  required="yes">
		<cfargument name="FPCCid" 			type="numeric" required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>	
		<cfif not fnValidaCodigo(Trim(Arguments.FPCcodigo))>
			<cfthrow message="Código ya existe.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaConcepto">
			insert into FPConcepto
			(Ecodigo,FPCCid,FPCcodigo,FPCdescripcion,BMUsucodigo)
			values
			(
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCCid#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCcodigo)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPCdescripcion)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			)
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaConcepto">
			  <cfreturn #rsAltaConcepto.identity#>
	</cffunction>
	
	<!---=======Modifica Clasificacion de Concepto de gasto o Ingreso===============--->
	<cffunction name="CambioClasificacionConcepto" access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		<cfargument name="FPCCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCCdescripcion"  type="string"  required="yes">
		<cfargument name="FPCCtipo" 	    type="string"  required="no">
		<cfargument name="FPCCconcepto"     type="string"  required="no">
		<cfargument name="FPCCcomplementoC" type="string"  required="no" default="">
		<cfargument name="FPCCcomplementoP" type="string"  required="no" default="">
		<cfargument name="FPCCidPadre" 		type="numeric" required="yes" default="-1">
		<cfargument name="FPCCTablaC"       type="numeric" required="no">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="ts_rversion"      type="any" 		required="yes">
		
		
		<cfargument name="FormatoCuenta"    type="string" required="no">
		<cfargument name="EspecificaCuenta" type="numeric" required="no" default="0">
		<cfargument name="CFcuenta"   		type="numeric" required="no">
		
		
		<cfargument name="FPCCExigeFecha"   type="numeric" required="no" default="0">
		<cfif Arguments.FPCCidPadre EQ -1>
			<cfset Arguments.FPCCidPadre = "null">
		</cfif>
		<!---==Valida la Clasificación de Conceptos de Servicio==--->
		<cfif isdefined('Arguments.FPCCconcepto') and ListFind('S,P', Arguments.FPCCconcepto) and isdefined('Arguments.FPCCTablaC')>
			<cfquery datasource="#Arguments.Conexion#" name="Concepto">
				select count(1) cantidad 
					from CConceptos 
				where CCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPCCTablaC#">
			</cfquery>
			<cfif concepto.cantidad EQ 0>
				<cfthrow message="El codigo de la Clasificación de Conceptos de Servicio es incorrecto (CCid = #Arguments.FPCCTablaC#)">
			</cfif>
		</cfif>
		<!---==Valida la Categoria del Activo Fijo===============--->
		<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'F' and isdefined('Arguments.FPCCTablaC')>
			<cfquery datasource="#Arguments.Conexion#" name="Concepto">
				select count(1) cantidad 
					from AClasificacion 
				where AClaId = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPCCTablaC#">
			</cfquery>
			<cfif concepto.cantidad EQ 0>
				<cfthrow message="El codigo de la Categoria es incorrecto (ACatId = #Arguments.FPCCTablaC#)">
			</cfif>
		</cfif>
		<!---==Valida las Clasificacion de Articulos de Inventario====--->
		<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'A' and isdefined('Arguments.FPCCTablaC')>
			<cfquery datasource="#Arguments.Conexion#" name="Clasificaciones">
				select count(1) cantidad 
					from Clasificaciones 
				where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Ecodigo#">
				  and Ccodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPCCTablaC#">
			</cfquery>
			<cfif Clasificaciones.cantidad EQ 0>
				<cfthrow message="El codigo de la Clasificación de Servicio es incorrecto (Ccodigo = #Arguments.FPCCTablaC#)">
			</cfif>
		</cfif>
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPCatConcepto"redirect="ClasificacionConcepto.cfm?FPCCid=#Arguments.FPCCid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPCCid" 
			type1="numeric"
			value1="#Arguments.FPCCid#">
		<cfif fnTienenPlantillas(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede modificar, ya que posee Plantillas asociadas">
		</cfif>
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
				Update FPCatConcepto set 	 
				 FPCCcodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCcodigo)#">,
				 FPCCdescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCdescripcion)#">,
				 FPCCtipo 			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCtipo)#" 			null="#LEN(TRIM(Arguments.FPCCtipo)) EQ 0#">,
				 FPCCconcepto 		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPCCconcepto)#" 		null="#LEN(TRIM(Arguments.FPCCconcepto)) EQ 0#">,
				 FPCCcomplementoC 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCcomplementoC)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoC)) EQ 0#">,
				 FPCCcomplementoP 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCCcomplementoP)#" 	null="#LEN(TRIM(Arguments.FPCCcomplementoP)) EQ 0#">,
				 FPCCidPadre 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Trim(Arguments.FPCCidPadre)#">,
				 BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">,
				 FPCCExigeFecha		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCExigeFecha#">,

				<cfif #Arguments.EspecificaCuenta# eq 1>
					 FormatoCuenta 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FormatoCuenta)#">,
				<cfelse>
					 FormatoCuenta 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
				</cfif>
				 
				 EspecificaCuenta	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.EspecificaCuenta#">,
				 
				<cfif #Arguments.EspecificaCuenta# eq 1>
					 CFcuenta 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFcuenta#">
				<cfelse>
					 CFcuenta 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
				</cfif>
				,FPCCTablaC			= 
					<cfif isdefined('Arguments.FPCCTablaC')>
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCTablaC#">
					<cfelse>
						null
					</cfif>
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
			</cfquery>
			
			<cfset hijos = fnCambioHijos(Arguments.FPCCid,Arguments.FPCCtipo,Arguments.FPCCconcepto,Arguments.FPCCExigeFecha,Arguments.BMUsucodigo,Arguments.Conexion)>
			<!---Actualiza el concepto Financiero en la Clasificación de Conceptos de Servicio --->
			<cfif isdefined('Arguments.FPCCconcepto') and ListFind('S,P', Arguments.FPCCconcepto) and isdefined('Arguments.FPCCTablaC') and (LEN(TRIM(Arguments.FPCCcomplementoC)) or LEN(TRIM(Arguments.FPCCcomplementoP)))>
			 	<cfinvoke component="sif.Componentes.AD_CConceptos" method="CambioCFcomplemento">
					<cfinvokeargument name="CCid" 	 value="#Arguments.FPCCTablaC#">
					<cfinvokeargument name="cuentac" value="#Trim(Arguments.FPCCcomplementoC)##Trim(Arguments.FPCCcomplementoP)#">	
				</cfinvoke>
			 </cfif>
			 <!---Actualiza el concepto Financiero en la Categoria del Activo Fijo--->
			<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'F' and isdefined('Arguments.FPCCTablaC') and (LEN(TRIM(Arguments.FPCCcomplementoC)) or LEN(TRIM(Arguments.FPCCcomplementoP)))>
			 	<cfinvoke component="sif.Componentes.AF_CategoriaClase" method="CambioCFcomplemento">
					<cfinvokeargument name="ACatId"  value="#Arguments.FPCCTablaC#">
					<cfinvokeargument name="cuentac" value="#Trim(Arguments.FPCCcomplementoC)##Trim(Arguments.FPCCcomplementoP)#">	
				</cfinvoke>
		   </cfif>
		    <!---Actualiza la Clasificacion de Articulos de Inventario--->
			<cfif isdefined('Arguments.FPCCconcepto') and Arguments.FPCCconcepto EQ 'A' and isdefined('Arguments.FPCCTablaC') and (LEN(TRIM(Arguments.FPCCcomplementoC)) or LEN(TRIM(Arguments.FPCCcomplementoP)))>
			 	<cfinvoke component="sif.Componentes.IV_Clasificaciones" method="CambioCFcomplemento">
					<cfinvokeargument name="Ccodigo"  value="#Arguments.FPCCTablaC#">
					<cfinvokeargument name="cuentac"  value="#Trim(Arguments.FPCCcomplementoC)##Trim(Arguments.FPCCcomplementoP)#">	
				</cfinvoke>
		   </cfif>
		   <cfset updatePath(Arguments.Conexion,Arguments.Ecodigo,Arguments.FPCCid)>
		</cftransaction>
	</cffunction>
	<!---=======Modifica un Concepto de gasto o Ingreso===============--->
	<cffunction name="CambioConcepto" access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPCid" 	    	type="numeric" required="yes">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		<cfargument name="FPCcodigo" 	    type="string"  required="yes">
		<cfargument name="FPCdescripcion"   type="string"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
	
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPConcepto" redirect="ConceptoGI.cfm?FPCid=#Arguments.FPCid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPCid" 
			type1="numeric"
			value1="#Arguments.FPCid#">
		<cfif not fnValidaCodigo(Trim(Arguments.FPCcodigo),FPCid)>
			<cfthrow message="Código ya existe.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			Update FPConcepto set 
			 FPCCid			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">,
			 FPCcodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCcodigo)#">,
			 FPCdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPCdescripcion)#">,
			 BMUsucodigo 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
		    where FPCid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCid#">
		</cfquery>
	</cffunction>
	<!---=======Elimina Clasificacion de Concepto de gasto o Ingreso================--->
	<cffunction name="BajaClasificacionConcepto"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
		<cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPCatConcepto"redirect="ClasificacionConcepto.cfm" timestamp="#Arguments.ts_rversion#"				
			field1="FPCCid" 
			type1="numeric"
			value1="#Arguments.FPCCid#">
		
		<cfif fnEsPadre(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede eliminar, ya que posee Categorías Hijas">
		</cfif>
		<cfif fnTienenConceptos(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede eliminar, ya que posee Conceptos asociados">
		</cfif>
		<cfif fnTienenPlantillas(Arguments.Conexion,Arguments.FPCCid)>
			<cfthrow message="La Clasificación no se puede eliminar, ya que posee Plantillas asociadas">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			delete from FPCatConcepto
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
	</cffunction>
	<!---=======Elimina el Concepto de gasto o Ingreso================--->
	<cffunction name="BajaConcepto"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCid" 	    	type="numeric" required="yes">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPConcepto" redirect="ConceptoGI.cfm" timestamp="#Arguments.ts_rversion#"				
			field1="FPCid" 
			type1="numeric"
			value1="#Arguments.FPCid#">
			
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			delete from FPConcepto
				where FPCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCid#">
		</cfquery>
	</cffunction>
	<!---=======Valida si la Categoria es Padre================--->
	<cffunction name="fnEsPadre"  access="public" returntype="boolean">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsHijos">
			select count(1) cantidad from FPCatConcepto
				where FPCCidPadre = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsHijos.cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
	<!---=======Valida si la Categoria es tienen ya conceptos Asociados================--->
	<cffunction name="fnTienenConceptos"  access="public" returntype="boolean">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsHijos">
			select count(1) cantidad from FPConcepto
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsHijos.cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
	<!---=======Valida si la Categoria tienen ya Plantillas Asociados================--->
	<cffunction name="fnTienenPlantillas"  access="public" returntype="boolean">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPCCid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsPlantillas">
			select count(1) cantidad from FPDPlantilla
				where FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsPlantillas.cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
	
	<cffunction name="fnCambioHijos" returntype="query" access="private">
		<cfargument name='idPadre'			type='numeric' 	required='true'>
		<cfargument name='tipo'				type='string' 	required='true'>
		<cfargument name='concepto'			type='string' 	required='true'>
		<cfargument name="FPCCExigeFecha"   type="numeric" 	required="no" default="0">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
	   <cfquery datasource="#Arguments.Conexion#" name="rsSQL">
			select 	FPCCid,
			(select count(1) from FPCatConcepto as hijos where hijos.FPCCidPadre = padre.FPCCid) as hijos
			from FPCatConcepto padre
			where padre.FPCCidPadre = #arguments.idPadre#
			order by padre.FPCCcodigo, padre.FPCCdescripcion
		</cfquery>
		<cfloop query="rsSQL">
			<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
				Update FPCatConcepto set 	 
					FPCCtipo 			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.tipo)#" 			null="#LEN(TRIM(Arguments.tipo)) EQ 0#">,
					FPCCconcepto		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.concepto)#" 		null="#LEN(TRIM(Arguments.tipo)) EQ 0#">,
					FPCCExigeFecha		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCExigeFecha#">,
					BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
				where FPCCid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#FPCCid#">
			</cfquery>
			<cfif hijos>
				<cfset hijos = fnCambioHijos(FPCCid,Arguments.tipo,Arguments.concepto,Arguments.FPCCExigeFecha,Arguments.BMUsucodigo,Arguments.Conexion)>
			</cfif>
		</cfloop>
		<cfreturn rsSQL>
	</cffunction>
	
<cffunction name="fnGetHijos" returntype="query" access="public">
  	<cfargument name='idPadre'			type='numeric' 	required='true'>
	<cfargument name='path'				type='string' 	required='no'>
  	<cfquery datasource="#session.dsn#" name="rsSQL">
		select 	FPCCid,FPCCtipo, FPCCcodigo, FPCCidPadre, FPCCconcepto, FPCCTablaC,FPCCdescripcion,FPCCExigeFecha,FPCCcomplementoP,FPCCpath,
		(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as hijos
		from FPCatConcepto
		where Ecodigo = #session.Ecodigo# and FPCCidPadre = #arguments.idPadre#
		<cfif isdefined('Arguments.path') and len(trim(Arguments.path))>
			and FPCCpath in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.path#" list="yes">)
		</cfif>
		order by FPCCcodigo, FPCCdescripcion
	</cfquery>
	<cfreturn rsSQL>
</cffunction>

<cffunction name="fnListaClasificaciones" returntype="string" access="public">
  	<cfargument name='FPCCcodigo'	type="string" 	required='true'>
		<cfparam name="lista" default="">
		
		<cfquery datasource="#session.dsn#" name="rslista">
			select Distinct CatF.FPCCid 
				from FPCatConcepto CatF 
				where 
			(CatF.FPCCpath like '#Arguments.FPCCcodigo#'     or  <!---Unico------>
			 CatF.FPCCpath like '#Arguments.FPCCcodigo#/%'   or  <!---inicio----->
			 CatF.FPCCpath like '%/#Arguments.FPCCcodigo#'   or  <!---Final------>
			 CatF.FPCCpath like '%/#Arguments.FPCCcodigo#/%'     <!---En medio--->
			 )
			 and (select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = CatF.Ecodigo and hijos.FPCCidPadre = CatF.FPCCid) = 0
		</cfquery>
		<cfif rslista.Recordcount EQ 0>
			<cfreturn '-1'>
		</cfif>
		<cfreturn valuelist(rslista.FPCCid)>
</cffunction>

<cffunction name="fnValidaCodigo" returntype="boolean" access="public">
	<cfargument name="FPCcodigo" 		type="string"  required="yes">
	<cfargument name="FPCid" 			type="numeric"  required="no"><!---Si viene definida es un update--->
	<cfargument name="Ecodigo" 			type="numeric"  required="no">
	<cfargument name="Conexion" 		type="string"  	required="no">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.dsn>
	</cfif>
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>	
	<cfquery datasource="#Arguments.Conexion#" name="rsFPConcepto">
		select 	FPCcodigo
		from FPConcepto
		where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
		  and FPCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FPCcodigo#"> 
		<cfif isdefined('Arguments.FPCid') and len(trim(Arguments.FPCid)) gt 0><!---Es un update--->
			and FPCid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCid#">
		</cfif>
	</cfquery>
	<cfif rsFPConcepto.recordcount gt 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="fnTienenConceptosConDetalles"  access="public" returntype="boolean">
	<cfargument name="Conexion" 	    type="string"  	required="no" 	default="#session.dsn#">
	<cfargument name="FPCCid" 	    	type="numeric" 	required="yes">
	<cfargument name="FPEPid" 			type="numeric"  required="yes">
	<cfargument name="FPEEid" 			type="numeric"  required="yes">
	<cfargument name="tieneHijos" 		type="boolean" 	required="yes" 	default="false">
	<cfargument name='filtro'			type='string' 	required='no' 	default="">
	
	<cfset Arguments.CantHijos=fnGetHijos(Arguments.FPCCid)>
	<cfquery datasource="#Arguments.Conexion#" name="rsEPlantilla">
		select FPCCconcepto 
		   from FPEPlantilla 
		 where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
	</cfquery>

	<cfloop query="Arguments.CantHijos">
		<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
			<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
				select count(1) as cantidad 
				from FPDEstimacion a
					inner join FPConcepto b
						on b.FPCid = a.FPCid
				where b.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CantHijos.FPCCid#">
				  and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
				  and a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				#preservesinglequotes(Arguments.filtro)#
			</cfquery>
			
		<cfelseif ListFind('A',rsEPlantilla.FPCCconcepto)>
			<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
				select count(1) as cantidad
				from FPCatConcepto d
					inner join Clasificaciones b
						on a.FPCCTablaC = b.Ccodigo
					inner join Articulos c
						on c.Ecodigo = b.Ecodigo and c.Ccodigo = b.Ccodigo
					inner join FPDEstimacion a
						on a.Aid = c.Aid
				where d.Ecodigo = #session.Ecodigo#
				  and d.FPCCconcepto = 'A'
				  and d.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CantHijos.FPCCid#">
				  and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				  and a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				  #preservesinglequotes(Arguments.filtro)#
			</cfquery>
		<cfelseif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
			<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
				select count(1) as cantidad
				from FPDEstimacion a
					inner join Conceptos b 
						on a.Cid = b.Cid
					inner join CConceptos c 
						on c.CCid = b.CCid
					inner join FPCatConcepto d 
						on d.FPCCTablaC = c.CCid 
					where d.Ecodigo = #session.Ecodigo#
				      and d.FPCCconcepto = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsEPlantilla.FPCCconcepto#"> 
				  	  and d.FPCCid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CantHijos.FPCCid#">
				  	  and a.FPEPid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#">
				  	  and a.FPEEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
				  #preservesinglequotes(Arguments.filtro)#
			</cfquery>
		</cfif>
		<cfset Arguments.tieneHijos = Arguments.tieneHijos or (fnTienenConceptos(Arguments.Conexion,Arguments.CantHijos.FPCCid) and rsDetalles.cantidad gt 0) or not ListFind(ExigeAuxiliar,rsEPlantilla.FPCCconcepto)>
		<cfif hijos NEQ 0>
			<cfset Arguments.tieneHijos = fnTienenConceptosConDetalles(Arguments.Conexion,Arguments.CantHijos.FPCCid,Arguments.FPEPid,Arguments.FPEEid,Arguments.tieneHijos,Arguments.filtro)>
		</cfif>
	</cfloop>
	<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select count(1) as cantidad 
			from FPConcepto b
				inner join FPDEstimacion a
					on a.FPCid = b.FPCid
			where b.FPCCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
				and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
				and a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
		</cfquery>
	<cfelseif ListFind('A',rsEPlantilla.FPCCconcepto)>
		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select count(1) as cantidad
			from FPCatConcepto d
				inner join Clasificaciones b
					on a.FPCCTablaC = b.Ccodigo
				inner join Articulos c
					on c.Ecodigo = b.Ecodigo and c.Ccodigo = b.Ccodigo
				inner join FPDEstimacion a
					on a.Aid = c.Aid
			where d.Ecodigo = #session.Ecodigo#
			  and d.FPCCconcepto = 'A'
			  and d.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#">
			  and a.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
			  and a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEEid#">
			  #preservesinglequotes(Arguments.filtro)#
		</cfquery>
	<cfelseif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select count(1) as cantidad
			from FPDEstimacion a
				inner join Conceptos b 
					on a.Cid = b.Cid
				inner join CConceptos c 
					on c.CCid = b.CCid
				inner join FPCatConcepto d 
					on d.FPCCTablaC = c.CCid 
				where d.Ecodigo = #session.Ecodigo#
			      and d.FPCCconcepto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEPlantilla.FPCCconcepto#">
			  	  and d.FPCCid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CantHijos.FPCCid#">
			  	  and a.FPEPid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
			  	  and a.FPEEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
			  #preservesinglequotes(Arguments.filtro)#
		</cfquery>
	</cfif>
	<cfset Arguments.tieneHijos = Arguments.tieneHijos or (fnTienenConceptos(Arguments.Conexion,Arguments.FPCCid) and rsDetalles.cantidad gt 0) or not ListFind(ExigeAuxiliar,rsEPlantilla.FPCCconcepto)>
	<cfreturn Arguments.tieneHijos> 
</cffunction>
<cffunction name="updatePath"  access="public">
	<cfargument name="Conexion" 	    type="string"  	required="no">
	<cfargument name="Ecodigo" 	    	type="numeric"  required="no">
	<cfargument name="FPCCid" 	    	type="numeric"  required="yes">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.dsn>
	</cfif>
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>
	<cf_dbfunction name="OP_concat"	datasource="#Arguments.Conexion#" returnvariable="_Cat">
	<!---Se obtiene Información del la Clasificacion Actual y la de Su padre--->
	<cfquery datasource="#Arguments.Conexion#" name="Arguments.Actual">
		select Act.FPCCid, Act.FPCCidPadre, fath.FPCCpath 
			from FPCatConcepto Act
				left outer join FPCatConcepto fath
					on fath.FPCCid = Act.FPCCidPadre
		where Act.FPCCid = #Arguments.FPCCid#
	</cfquery>
	<cfif Arguments.Actual.recordcount EQ 0>
		<cfthrow message="Error en Actualizacion del Path:Clasificación de Conceptos de Financiamiento y Egresos no existe!">
	</cfif> 
	
	<cfquery datasource="#Arguments.Conexion#">
		update FPCatConcepto 
			set FPCCpath = <cfif LEN(TRIM(Arguments.Actual.FPCCpath))> <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Actual.FPCCpath#/"> #_Cat#</cfif> FPCCcodigo
		where FPCCid = #Arguments.FPCCid#
	</cfquery>
	<cfquery datasource="#Arguments.Conexion#" name="Arguments.sons">
		select FPCCid from FPCatConcepto where FPCCidPadre = #Arguments.Actual.FPCCid#
	</cfquery>
	<cfloop query="Arguments.sons">
		<cfset updatePath(Arguments.Conexion,Arguments.Ecodigo,Arguments.sons.FPCCid)>
	</cfloop>
</cffunction>


<cffunction name="getPlantillaAsociada" access="public" returntype="query">
	<cfargument name="FPCCid" 	    	type="numeric"  required="yes">
	<cfargument name="CFid" 	    	type="numeric"  required="yes">
	<cfargument name="Conexion" 	    type="string"  	required="no">
	<cfargument name="Ecodigo" 	    	type="numeric"  required="no">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.dsn>
	</cfif>
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>
	<cfquery datasource="#Arguments.Conexion#" name="rsFPCatConcepto">
		select FPCCid, FPCCpath 
			from FPCatConcepto
		where FPCCid = #Arguments.FPCCid#
	</cfquery>
	<cfquery datasource="#Arguments.Conexion#" name="rsAsociada">
		select #Arguments.FPCCid# FPCCid, c.FPEPid, FPEPdescripcion Descripcion, case c.FPCCconcepto
						when 'F' then 'Activo Fijo' 
						when 'S' then 'Gastos o Servicio' 
						when 'P' then 'Obras en Proceso' 
						when 'A' then 'Artículos Inventario'
						when '2' then 'Concepto Salarial'
						when '3' then 'Amortización de Prestamos'
						when '1' then 'Otros'
						when '4' then 'Financiamiento'
						when '5' then 'Patrimonio'
						when '6' then 'Ventas'
						else 'SIN ASOCIAR'
						end Indicador
		from FPCatConcepto a
			inner join FPDPlantilla b
				on b.FPCCid = a.FPCCid
			inner join FPEPlantilla c
				on c.FPEPid = b.FPEPid
			inner join FPDCentrosF d
				on d.FPEPid = c.FPEPid
		where a.FPCCcodigo in(<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#valuelist(rsFPCatConcepto.FPCCpath)#" separator ="/">)
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
	</cfquery>
	<cfif rsAsociada.recordcount eq 0>
		<cfset QueryAddRow(rsAsociada, 1)>
		<cfset QuerySetCell(rsAsociada, "FPCCid", Arguments.FPCCid, 1)>
		<cfset QuerySetCell(rsAsociada, "Descripcion", "SIN ASOCIAR", 1)>
		<cfset QuerySetCell(rsAsociada, "Indicador", "SIN ASOCIAR", 1)>
	</cfif>
	
	<cfreturn rsAsociada>
</cffunction>

</cfcomponent>