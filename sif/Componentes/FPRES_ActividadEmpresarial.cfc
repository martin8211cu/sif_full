<cfcomponent>
	<!---=======Agrega una nueva Actividad Empresarial para la Formulacion de presupuesto=======--->
	<cffunction name="AltaActividadEmpresarial"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="FPAECodigo" 	    type="string"  required="yes">
		<cfargument name="FPAEDescripcion"  type="string"  required="yes">
		<cfargument name="FPAETipo" 	    type="string"  required="yes">		
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaActividad">
			insert into FPActividadE
			(Ecodigo,FPAECodigo,FPAEDescripcion, FPAETipo,BMUsucodigo)
			values
			(
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPAECodigo)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPAEDescripcion)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPAETipo)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			)
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsAltaActividad">
			  <cfreturn #rsAltaActividad.identity#>
	</cffunction>
	<!---=======Agrega un nuevo nivel a una Actividad Empresarial para la Formulacion de presupuesto=======--->
	<cffunction name="AltaActividadNivel"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    	type="string"  	required="no" default="#session.dsn#">
		<cfargument name="FPAEid" 		    	type="numeric"  required="yes">
		<cfargument name="PCEcatid" 	    	type="numeric"  required="no">
		<cfargument name="FPADDescripcion"  	type="string"  	required="yes">
		<cfargument name="FPADDepende" 	    	type="string"  	required="yes">	
		<cfargument name="FPADIndetificador"	type="string"  	required="yes">		
		<cfargument name="FPADEquilibrio"      	type="numeric" 	required="no" default="0">
		<cfargument name="BMUsucodigo"      	type="numeric" 	required="no" default="#Session.Usucodigo#">

		<cfquery datasource="#Arguments.Conexion#" name="NuevoNivel">
			select Coalesce(max(FPADNivel),0)+1 as FPADNivel
			   from FPActividadD 
			where FPAEid= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#" name="logintudes">
			select Coalesce(sum(FPADLogitud),0) sumaLogintudes
				from FPActividadD 
			where FPAEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
			  and FPADNivel < #NuevoNivel.FPADNivel#
		</cfquery>
		<cfset FPADPosicion = logintudes.sumaLogintudes + NuevoNivel.FPADNivel>
		
		<cfif Arguments.FPADDepende EQ 'C'>
			<cfif not isdefined('Arguments.PCEcatid')>
				<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="No se envio PCEcatid">
			 <cfelse>
				 <cfquery datasource="#Arguments.Conexion#" name="CatalogoPlanCuentas">
					select PCElongitud from PCECatalogo where PCEcatid = #Arguments.PCEcatid#
				</cfquery>
				<cfif CatalogoPlanCuentas.recordcount EQ 0>
					<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="El PCEcatid enviado es incorrecto">
				<cfelse>
					<cfset FPADLogitud = CatalogoPlanCuentas.PCElongitud>
				</cfif>
			</cfif>	
		<cfelseif Arguments.FPADDepende EQ 'N'>
			<cfset Arguments.PCEcatid = "null">
			<cfset Arguments.FPADEquilibrio = 0>
			
			<cfquery datasource="#Arguments.Conexion#" name="nivelPadre">
				select PCEcatid, FPADNivel
					from FPActividadD 
				where FPADNivel = (select max(FPADNivel) 
								   		from FPActividadD 
									where FPAEid = #Arguments.FPAEid#
									  and FPADNivel < #NuevoNivel.FPADNivel#
									  and FPADDepende = 'C')
				and FPAEid = #Arguments.FPAEid#
			</cfquery>

			<cfloop index="i" from="#nivelPadre.FPADNivel#" to="#NuevoNivel.FPADNivel-1#">
				<cfquery datasource="#Arguments.Conexion#" name="CatalogosReferenciados">
					select PCEcatidref 
						from PCDCatalogo 
					where PCEcatid = #nivelPadre.PCEcatid#
				</cfquery>
				<cfif NOT LEN(TRIM(CatalogosReferenciados.PCEcatidref))>
					<cfthrow message="Se esta intentando referencia el catalogo nivel #i#, pero el catalogo al plan de cuentas  no posee catalogo de referencia.">
				<cfelse>
					<cfset nivelPadre.PCEcatid = CatalogosReferenciados.PCEcatidref>
				</cfif>
			</cfloop>
			<cfquery datasource="#Arguments.Conexion#" name="CatalogoPlanCuentas">
				select PCElongitud from PCECatalogo where PCEcatid = #nivelPadre.PCEcatid#
			</cfquery>
				<cfset FPADLogitud = CatalogoPlanCuentas.PCElongitud>
		<cfelse>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="Dependencia '#Arguments.FPADDepende#' no implementada">	
		</cfif>
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#">
				insert into FPActividadD
				(FPAEid,FPADNivel,PCEcatid,FPADDescripcion,FPADDepende,FPADIndetificador,FPADEquilibrio,FPADPosicion,FPADLogitud,BMUsucodigo)
				values
				(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPAEid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#NuevoNivel.FPADNivel#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCEcatid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPADDescripcion)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPADDepende)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPADIndetificador)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPADEquilibrio#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#FPADPosicion#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#FPADLogitud#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
				)
			</cfquery>
			<cfif Arguments.FPADEquilibrio EQ 1>
				<cfquery datasource="#Arguments.Conexion#">
					update FPActividadD set FPADEquilibrio = 0 
					 where FPAEid 	  = #Arguments.FPAEid# 
					   and FPADNivel <> #NuevoNivel.FPADNivel#
				</cfquery>
			</cfif>
		</cftransaction>
			<cfreturn NuevoNivel.FPADNivel> 
	</cffunction>
	<!---=======Modifica una Actividad Empresarial para la Formulacion de presupuesto===============--->
	<cffunction name="CambioActividadEmpresarial" access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPAEid"	        type="numeric" required="yes">
		<cfargument name="FPAECodigo" 	    type="string"  required="yes">
		<cfargument name="FPAEDescripcion"  type="string"  required="yes">
		<cfargument name="FPAETipo" 	    type="string"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric" required="no" default="#Session.Usucodigo#">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
		
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPActividadE" redirect="ActividadesEmpresa.cfm?FPAEid=#Arguments.FPAEid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPAEid" 
			type1="numeric"
			value1="#Arguments.FPAEid#">
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			Update FPActividadE set 	 
			 FPAECodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPAECodigo)#">,
			 FPAEDescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPAEDescripcion)#">,
			 FPAETipo 			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPAETipo)#">,
			 BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
		    where FPAEid        = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
		</cfquery>
	</cffunction>
	<!---=======Modificar un nivel a una Actividad Empresarial para la Formulacion de presupuesto=======--->
	<cffunction name="CambioActividadNivel"  access="public">
		<cfargument name="Conexion" 	    	type="string"  	required="no" default="#session.dsn#">
		<cfargument name="FPAEid" 		    	type="numeric"  required="yes">
		<cfargument name="FPADNivel" 		    type="numeric"  required="yes">
		<cfargument name="PCEcatid" 	    	type="numeric"  required="no">
		<cfargument name="FPADDescripcion"  	type="string"  	required="yes">
		<cfargument name="FPADDepende" 	    	type="string"  	required="yes">	
		<cfargument name="FPADIndetificador"	type="string"  	required="yes">	
		<cfargument name="FPADEquilibrio"   	type="numeric"  required="no" default="0">			
		<cfargument name="BMUsucodigo"      	type="numeric" 	required="no" default="#Session.Usucodigo#">
		<cfif Arguments.FPADDepende EQ 'C'>
			<cfif not isdefined('Arguments.PCEcatid')>
				<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="No se envio PCEcatid">
			</cfif>	
		<cfelseif Arguments.FPADDepende EQ 'N'>
			<cfset Arguments.PCEcatid = "null">
			<cfset Arguments.FPADEquilibrio = 0>
		<cfelse>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="Dependencia '#Arguments.FPADDepende#' no implementada">	
		</cfif>
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#">
				update FPActividadD set
					PCEcatid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.PCEcatid#">,
					FPADDescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Trim(Arguments.FPADDescripcion)#"> ,
					FPADDepende 		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPADDepende)#">,
					FPADIndetificador 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Trim(Arguments.FPADIndetificador)#">,
					FPADEquilibrio		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPADEquilibrio#">,
					BMUsucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
					where FPAEid    	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
					  and FPADNivel 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPADNivel#">
			</cfquery>
			<cfset UpdateLongPos(Arguments.Conexion,Arguments.FPAEid,Arguments.FPADNivel)>
			<cfif Arguments.FPADEquilibrio EQ 1>
				<cfquery datasource="#Arguments.Conexion#">
					update FPActividadD set FPADEquilibrio = 0 
					 where FPAEid 	  = #Arguments.FPAEid# 
					   and FPADNivel <> #Arguments.FPADNivel#
				</cfquery>
			</cfif>
		</cftransaction>
	</cffunction>
	<!---=======Elimina un Nivel de la Actividad Empresarial para la Formulacion de presupuesto================--->
	<cffunction name="BajaActividadNivel"  access="public">
		<cfargument name="Conexion" 	    type="string"   required="no" default="#session.dsn#">
		<cfargument name="FPAEid" 	    	type="numeric"  required="yes">
		<cfargument name="FPADNivel" 		type="numeric"  required="yes">
		<cfargument name="ts_rversion"      type="any" 	    required="no">
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#">
				delete from FPActividadD
					where FPAEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
					  and FPADNivel = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPADNivel#">
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#" name="porActualizar">
				select FPAEid,FPADNivel
				 from FPActividadD
				 where FPAEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
				  and FPADNivel  > <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPADNivel#">
			</cfquery>
			<cfloop query="porActualizar">
				<cfquery datasource="#Arguments.Conexion#">
					update FPActividadD
					set FPADNivel = #porActualizar.FPADNivel#-1
					where FPAEid    = #porActualizar.FPAEid#
					  and FPADNivel = #porActualizar.FPADNivel#
				</cfquery>
			</cfloop>
			
			<cfset UpdateLongPos(Arguments.Conexion,Arguments.FPAEid,Arguments.FPADNivel)>
			
		</cftransaction>
	</cffunction>
	<!---=======Elimina una Actividad Empresarial para la Formulacion de presupuesto================--->
	<cffunction name="BajaActividadEmpresarial"  access="public">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPAEid" 	    	type="numeric" required="yes">
		<cfargument name="ts_rversion"      type="any" 	   required="yes">
		
		 <cf_dbtimestamp datasource="#Arguments.Conexion#" table="FPActividadE" redirect="ActividadesEmpresa.cfm?FPAEid=#Arguments.FPAEid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPAEid" 
			type1="numeric"
			value1="#Arguments.FPAEid#">
		
		<cfif GetNivel(Arguments.Conexion,Arguments.FPAEid).recordcount>
			<cfthrow message="La Actividad Empresarial no se puede eliminar, ya que posee niveles configurados">
		</cfif>
		<cfquery datasource="#session.dsn#" name="tieneEstimaciones">
			select count(1) as cantidad
			from FPDEstimacion a
			where FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPAEid#">
		</cfquery>
		<cfquery datasource="#session.dsn#" name="tienePlan">
			select count(1) as cantidad
			from PCGDplanCompras
			where FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPAEid#">
		</cfquery>
		<cfif tieneEstimaciones.cantidad gt 0>
			<cfthrow message="La Actividad Empresarial no se puede eliminar, ya que posee detalles de estimaciones ligadas.">
		</cfif>
		<cfif tienePlan.cantidad gt 0>
			<cfthrow message="La Actividad Empresarial no se puede eliminar, ya que posee detalles al plan de compras ligadas.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsCambioConcepto">
			delete from FPActividadE
				where FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
		</cfquery>
	</cffunction>
	<!---=======Devuelve la informacion de cada uno de los Niveles asignados a la Actividad================--->
	<cffunction name="GetNivel"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPAEid" 	    	type="numeric" required="yes">
		<cfargument name="FPADNivel" 	    type="numeric" required="no">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsNiveles">
			select a.FPAEid,a.FPADNivel,a.PCEcatid,a.FPADDescripcion,a.FPADDepende,a.FPADIndetificador,a.ts_rversion ,b.PCEcatid,b.PCEcodigo,b.PCEdescripcion,a.FPADEquilibrio, FPADLogitud, PCElongitud
				from FPActividadD a
					left outer join PCECatalogo b
						on b.PCEcatid = a.PCEcatid
			 where a.FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPAEid#">
			 <cfif isdefined('Arguments.FPADNivel')>
			 and a.FPADNivel = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPADNivel#">
			 </cfif>
			 order by FPADNivel
		</cfquery>
		<cfif rsNiveles.FPADIndetificador EQ 'C' and not len(trim(rsNiveles.PCEcatid))>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.GetNivel" detail="Inconsistencia de Datos, el Nivel depende de un Catalogo, pero el PCEcatid es nulo">
		</cfif>
		<cfreturn rsNiveles>
	</cffunction>
	<!---==========Devuelve la informacion referente a cada una de las Actividades============--->
	<cffunction name="GetActividad"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="FPAEid" 	    	type="numeric" required="yes">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsActividad">
			select FPAEid,Ecodigo,FPAECodigo,FPAEDescripcion, FPAETipo,BMUsucodigo, ts_rversion
			  from FPActividadE
			where FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPAEid#">
		</cfquery>
		<cfreturn rsActividad>
	</cffunction>
	<!---==========Devuelve la informacion referente a la Actividad apartir de su codigo============--->
	<cffunction name="GetActividadxCodigo"  access="public" returntype="query">
		<cfargument name="Codigo" 	    type="string" required="yes">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 	    	type="numeric" required="no" default="#session.Ecodigo#">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsActividad">
			select FPAEid,Ecodigo,FPAECodigo,FPAEDescripcion, FPAETipo,BMUsucodigo, ts_rversion
			  from FPActividadE
			where FPAECodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Codigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			order by FPAECodigo, FPAEDescripcion
		</cfquery>
		<cfreturn rsActividad>
	</cffunction>
	<!---=======Devuelve el catalogo al plan de cuentas asignado a cada nivel================--->
	<cffunction name="GetConceptos"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 	    	type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="ActivarEcodigo" 	type="boolean" required="yes">
		<cfargument name="FPAEid" 	    	type="numeric" required="yes">
		<cfargument name="FPADNivel" 	    type="numeric" required="yes">
		<cfargument name="PCEcatid" 		type="numeric" required="no">
		<cfargument name="SoloActivos" 	    type="boolean" required="no" default="true">
		<cfargument name="filtro" 	   		type="string"  required="no" default="">
		<cfargument name="MostrarError" 	type="boolean" required="no" default="false">
		<cfset nivel = GetNivel(Arguments.Conexion,Arguments.FPAEid,Arguments.FPADNivel,"")>
		<cfif Nivel.FPADDepende EQ 'C'>
			<cfreturn fnGetConceptos(Arguments.Conexion,Nivel.PCEcatid,Arguments.FPADNivel,Arguments.SoloActivos,"",Arguments.ActivarEcodigo,Arguments.Ecodigo,Arguments.filtro,Arguments.MostrarError)>
		<cfelseif Nivel.FPADDepende EQ 'N'>
			<cfif isdefined('Arguments.PCEcatid') and len(trim(Arguments.PCEcatid))>
				<cfreturn fnGetConceptos(Arguments.Conexion,Arguments.PCEcatid,Arguments.FPADNivel,Arguments.SoloActivos,"",Arguments.ActivarEcodigo,Arguments.Ecodigo,Arguments.filtro,Arguments.MostrarError)>
			<cfelseif Arguments.MostrarError>
				<cfthrow message="Error en FPRES_ActividadEmpresarial.GetConceptos" detail="Tipo de Dependencia '#Nivel.FPADDepende#' no se ha espicificado el catálogo">
			</cfif>
		<cfelseif Arguments.MostrarError>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.GetConceptos" detail="Tipo de Dependencia '#Nivel.FPADDepende#' no implementada">
		</cfif>
	</cffunction>
	<cffunction name="fnGetConceptos"  access="private" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no" default="#session.dsn#">
		<cfargument name="PCEcatid" 	    type="numeric" required="yes">
		<cfargument name="FPADNivel" 	    type="numeric" required="yes">
		<cfargument name="SoloActivos" 	    type="boolean" required="no" default="true">
		<cfargument name="PCDvalor" 	    type="string"  required="no" default="">
		<cfargument name="ActivarEcodigo" 	type="boolean" required="yes">
		<cfargument name="Ecodigo" 	    	type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="filtro" 	   		type="string"  required="no" default="">
		<cfargument name="MostrarError" 	type="boolean" required="no" default="false">
		
		<cfquery datasource="#Arguments.Conexion#" name="Nivel">
			select PCDcatid,PCEcatid,PCDvalor,PCDdescripcion,PCEcatidref, #Arguments.FPADNivel# as nivel
				from PCDCatalogo 
			where <cfif Arguments.ActivarEcodigo>
			 	Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and
			 </cfif>
			  PCEcatid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCEcatid#">
			<cfif Arguments.SoloActivos>
			and PCDactivo = 1
			</cfif>
			<cfif len(trim(Arguments.PCDvalor))>
			and PCDvalor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.PCDvalor#"> 
			</cfif>
			<cfif isdefined('Arguments.filtro') and len(trim(Arguments.filtro))>
			#preservesinglequotes(filtro)#
			</cfif>
			order by PCDvalor, PCDdescripcion
		</cfquery>
		<cfif Nivel.recordCount EQ 0 and Arguments.MostrarError>
			<cfthrow message="Error en FPRES_ActividadEmpresarial.GetConceptos" detail="No se puedo encontrar los conceptos para el PCEcatid = #Arguments.PCEcatid# PCDvalor=#Arguments.PCDvalor#">
		</cfif>
		<cfreturn Nivel>
	</cffunction>
	<cffunction name="getParametroActividad"  access="public" returntype="boolean">
		<cfargument name="Conexion" type="string"  required="no" default="#session.dsn#">
		<cfargument name="Ecodigo" 	type="numeric" required="no" default="#session.Ecodigo#">
		
		<cfquery datasource="#Arguments.Conexion#" name="Parametro">
			select Pvalor
				from Parametros 
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 2200
		</cfquery>
		<cfif Parametro.recordCount GT 0 and Parametro.Pvalor EQ 'S'>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	<!---Actualiza todos las longitudes y posiciones, para los niveles superiores--->
	<cffunction name="UpdateLongPos" access="private">
		<cfargument name="Conexion"  type="string"  required="no">
		<cfargument name="FPAEid" 	 type="string"  required="yes">
		<cfargument name="FPADNivel" type="string"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn> 
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="porActualizar">
			select FPADDepende, PCEcatid , FPADNivel
				from FPActividadD 
			where FPAEid	 = #Arguments.FPAEid#
			  and FPADNivel >= #Arguments.FPADNivel# 
		</cfquery>
		<cfloop query="porActualizar">
			<cfif porActualizar.FPADDepende EQ 'C'>
				<cfif NOT LEN(TRIM(porActualizar.PCEcatid))>
					<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="No se encontro PCEcatid, en el nivel #porActualizar.FPADNivel#">
			 	<cfelse>
					 <cfquery datasource="#Arguments.Conexion#" name="CatalogoPlanCuentas">
						select PCElongitud from PCECatalogo where PCEcatid = #porActualizar.PCEcatid#
					</cfquery>
					<cfif CatalogoPlanCuentas.recordcount EQ 0>
						<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="El PCEcatid Encontrado es incorrecto, en el nivel #porActualizar.FPADNivel#">
					<cfelse>
						<cfset FPADLogitud = CatalogoPlanCuentas.PCElongitud>
					</cfif>
				</cfif>
			<cfelseif porActualizar.FPADDepende EQ 'N'>
				<cfquery datasource="#Arguments.Conexion#" name="nivelPadre">
					select PCEcatid, FPADNivel
						from FPActividadD 
					where FPADNivel = (select max(FPADNivel) 
											from FPActividadD 
										where FPAEid = #Arguments.FPAEid#
										  and FPADNivel < #porActualizar.FPADNivel#
										  and FPADDepende = 'C')
					and FPAEid = #Arguments.FPAEid#
				</cfquery>
				<cfif nivelPadre.recordcount EQ 0>
					<cfthrow message="La operación a  efectuar no es permitida, ya que no existe un nivel inferior dependiente de un catalogo.">
				</cfif>
				<cfloop index="i" from="#nivelPadre.FPADNivel#" to="#porActualizar.FPADNivel-1#">
					<cfquery datasource="#Arguments.Conexion#" name="CatalogosReferenciados">
						select PCEcatidref 
							from PCDCatalogo 
						where PCEcatid = #nivelPadre.PCEcatid#
					</cfquery>
					<cfif NOT LEN(TRIM(CatalogosReferenciados.PCEcatidref))>
						<cfthrow message="Se esta intentando referencia el catalogo nivel #i#, pero el catalogo al plan de cuentas  no posee catalogo de referencia.">
					<cfelse>
						<cfset nivelPadre.PCEcatid = CatalogosReferenciados.PCEcatidref>
					</cfif>
				</cfloop>
				<cfquery datasource="#Arguments.Conexion#" name="CatalogoPlanCuentas">
					select PCElongitud from PCECatalogo where PCEcatid = #nivelPadre.PCEcatid#
				</cfquery>
				<cfset FPADLogitud = CatalogoPlanCuentas.PCElongitud>
			<cfelse>
				<cfthrow message="Error en FPRES_ActividadEmpresarial.AltaActividadNivel" detail="Dependencia '#porActualizar.FPADDepende#' no implementada">	
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
				update FPActividadD set 
					FPADLogitud  = #FPADLogitud#
				where FPAEid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
			      and FPADNivel  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#porActualizar.FPADNivel#">
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#" name="logintudes">
				select Coalesce(sum(FPADLogitud),0) sumaLogintudes
					from FPActividadD 
				where FPAEid    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
				  and FPADNivel < #porActualizar.FPADNivel#
			</cfquery>
			<cfset FPADPosicion = logintudes.sumaLogintudes + porActualizar.FPADNivel>
			
			<cfquery datasource="#Arguments.Conexion#">
				update FPActividadD set 
					FPADPosicion  = #FPADPosicion#
				where FPAEid    	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#">
				  and FPADNivel 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#porActualizar.FPADNivel#">
			</cfquery>
		</cfloop>
		
	</cffunction>
</cfcomponent>