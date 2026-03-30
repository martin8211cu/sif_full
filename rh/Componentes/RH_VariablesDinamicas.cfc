<cfcomponent>
	<cffunction name="fnGetEVariablesDinamicas" returntype="query">
		<cfargument name="RHEVDid"  type="numeric">
		<cfargument name="Ecodigo"  type="numeric">
		<cfargument name="Conexion" type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsEVariablesDinamicas" datasource="#Arguments.Conexion#">
			select RHEVDid, RHEVDcodigo, RHEVDdescripcion, RHEVDtipo, Ecodigo, BMUsucodigo, ts_rversion,
				case RHEVDtipo when 1 then 'Finiquito' when 2 then 'Liquidación' when 3 then 'PTU' else 'No definido' end as RHEVDtipoDescripcion
			from RHEVariablesDinamicas
			where 1=1
				<cfif isdefined('Arguments.RHEVDid')>
					and RHEVDid = #Arguments.RHEVDid#
				</cfif>
				<cfif isdefined('Arguments.Ecodigo')>
					and Ecodigo = #Arguments.Ecodigo#
				</cfif>
		</cfquery>
		
		<cfreturn rsEVariablesDinamicas>
	</cffunction>
	
	<cffunction name="fnAltaEVariablesDinamicas" returntype="numeric">
		<cfargument name="RHEVDcodigo"  		type="string" 	required="yes">
		<cfargument name="RHEVDdescripcion"  	type="string" 	required="yes">
		<cfargument name="RHEVDtipo"  			type="numeric"	required="yes">
		<cfargument name="Usuario"  			type="numeric">
		<cfargument name="Ecodigo"  			type="numeric">
		<cfargument name="Conexion" 			type="string">
		

		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
				
		<cfquery name="rsExiste" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHEVariablesDinamicas
			where RHEVDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHEVDcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif rsExiste.cantidad gt 0>
			<cfthrow message="El código ingresado ya existe. Proceso cancelado!!!">
		</cfif>
		
		<cfquery name="rsAltaEVariablesDinamicas" datasource="#Arguments.Conexion#">
			insert into RHEVariablesDinamicas(RHEVDcodigo, RHEVDdescripcion, RHEVDtipo, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHEVDcodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVDdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDtipo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsAltaEVariablesDinamicas">
		<cfreturn #rsAltaEVariablesDinamicas.identity#>
	</cffunction>
	
	<cffunction name="fnCambioEVariablesDinamicas" returntype="numeric">
		<cfargument name="RHEVDid"  			type="numeric" 	required="yes">
		<cfargument name="RHEVDcodigo"  		type="string" 	required="yes">
		<cfargument name="RHEVDdescripcion"  	type="string" 	required="yes">
		<cfargument name="RHEVDtipo"  			type="numeric"	required="yes">
		<cfargument name="Usuario"  			type="numeric">
		<cfargument name="Ecodigo"  			type="numeric">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
		
		<cfquery name="rsExiste" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHEVariablesDinamicas
			where RHEVDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHEVDcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and RHEVDid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">
		</cfquery>
		<cfif rsExiste.cantidad gt 0>
			<cfthrow message="El código ingresado ya existe. Proceso cancelado!!!">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			update RHEVariablesDinamicas set
			RHEVDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHEVDcodigo)#">,
			RHEVDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVDdescripcion#">,
			RHEVDtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDtipo#">,
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, 
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			where RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">
		</cfquery>
		<cfreturn #Arguments.RHEVDid#>
	</cffunction>

	<cffunction name="fnBajaEVariablesDinamicas">
		<cfargument name="RHEVDid"  			type="numeric" 	required="yes">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery name="rsExisteDependencia" datasource="#Arguments.Conexion#">
			select count(1) cantidad
			from RHDVariablesDinamicas 
			where RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">
		</cfquery>
		<cfif rsExisteDependencia.cantidad gt 0>
			<cfthrow message="Existe dependencia con detalles, no se puede eliminar. Proceso Cancelado!!!">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHEVariablesDinamicas where RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">
		</cfquery>
	</cffunction>
	
	<cffunction name="fnGetSiguienteNivel" returntype="numeric">
		<cfargument name="RHEVDid"  			type="numeric" 	required="yes">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsUNivel" datasource="#Arguments.Conexion#">
			select count(1) as sNivel
			from RHDVariablesDinamicas 
			where RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">
		</cfquery>
		<cfreturn rsUNivel.sNivel>
	</cffunction>
	
	<cffunction name="fnGetDVariablesDinamicas" returntype="query">
		<cfargument name="RHEVDid"  type="numeric">
		<cfargument name="RHDVDid"  type="numeric">
		<cfargument name="Ecodigo"  type="numeric">
		<cfargument name="Conexion" type="string">
		<cfargument name="OrderBy" 	type="string">
		

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsDVariablesDinamicas" datasource="#Arguments.Conexion#">
			select RHDVDid, RHEVDid, RHDVDcodigo, RHDVDdescripcion, RHDVDnivel, RHDVDconceptoA, RHDVDconceptoB, RHDVDoperacion,
			  	RHDVDconstante, RHDVDtipo, Ecodigo, BMUsucodigo, ts_rversion,
				case RHDVDtipo when 1 then 'Variable' when 2 then 'Fórmula' when 3 then 'Constante' else 'No definido' end as RHDVDtipoDescripcion
			from RHDVariablesDinamicas
			where 1=1
				<cfif isdefined('Arguments.RHEVDid')>
					and RHEVDid = #Arguments.RHEVDid#
				</cfif>
				<cfif isdefined('Arguments.RHDVDid')>
					and RHDVDid = #Arguments.RHDVDid#
				</cfif>
				<cfif isdefined('Arguments.Ecodigo')>
					and Ecodigo = #Arguments.Ecodigo#
				</cfif>
				<cfif isdefined('Arguments.OrderBy')>
					Order By #Arguments.OrderBy#
				</cfif>
		</cfquery>
		
		<cfreturn rsDVariablesDinamicas>
	</cffunction>
	
	<cffunction name="fnAltaDVariablesDinamicas" returntype="numeric">
		<cfargument name="RHEVDid"  			type="string" 	required="yes">
		<cfargument name="RHDVDcodigo"  		type="string" 	required="yes">
		<cfargument name="RHDVDdescripcion"  	type="string" 	required="yes">
		<cfargument name="RHDVDtipo"  			type="numeric"	required="yes">
		<cfargument name="RHDVDnivel"  			type="numeric"	required="yes">
		<cfargument name="RHDVDconceptoA"  		type="numeric">
		<cfargument name="RHDVDconceptoB"  		type="numeric">
		<cfargument name="RHDVDoperacion"  		type="string">
		<cfargument name="RHDVDconstante"  		type="numeric">
		<cfargument name="Usuario"  			type="numeric">
		<cfargument name="Ecodigo"  			type="numeric">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
				
		<cfquery name="rsExiste" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHDVariablesDinamicas
			where RHDVDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHDVDcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif rsExiste.cantidad gt 0>
			<cfthrow message="El código ingresado ya existe. Proceso cancelado!!!">
		</cfif>
		
		<cfif not isdefined('Arguments.RHDVDconceptoA')> 
			<cfset Arguments.RHDVDconceptoA = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHDVDconceptoB')> 
			<cfset Arguments.RHDVDconceptoB = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHDVDoperacion')> 
			<cfset Arguments.RHDVDoperacion = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHDVDconstante')> 
			<cfset Arguments.RHDVDconstante = "null">
		</cfif>
		
		<cfquery name="rsAltaDVariablesDinamicas" datasource="#Arguments.Conexion#">
			insert into RHDVariablesDinamicas(RHEVDid, RHDVDcodigo, RHDVDdescripcion, RHDVDnivel, RHDVDconceptoA,
				RHDVDconceptoB, RHDVDoperacion, RHDVDconstante, RHDVDtipo, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHDVDcodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDVDdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDnivel#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDconceptoA#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDconceptoB#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHDVDoperacion#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDconstante#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDtipo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsAltaDVariablesDinamicas">
		<cfreturn #rsAltaDVariablesDinamicas.identity#>
	</cffunction>

	<cffunction name="fnCambioDVariablesDinamicas" returntype="numeric">
		<cfargument name="RHDVDid"  			type="string" 	required="yes">
		<cfargument name="RHEVDid"  			type="string" 	required="yes">
		<cfargument name="RHDVDcodigo"  		type="string" 	required="yes">
		<cfargument name="RHDVDdescripcion"  	type="string" 	required="yes">
		<cfargument name="RHDVDtipo"  			type="numeric"	required="yes">
		<cfargument name="RHDVDnivel"  			type="numeric"	required="yes">
		<cfargument name="RHDVDconceptoA"  		type="numeric">
		<cfargument name="RHDVDconceptoB"  		type="numeric">
		<cfargument name="RHDVDoperacion"  		type="string">
		<cfargument name="RHDVDconstante"  		type="numeric">
		<cfargument name="Usuario"  			type="numeric">
		<cfargument name="Ecodigo"  			type="numeric">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
				
		<cfquery name="rsExiste" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHDVariablesDinamicas
			where RHDVDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHDVDcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">
			  and RHDVDid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfif rsExiste.cantidad gt 0>
			<cfthrow message="El código ingresado ya existe. Proceso cancelado!!!">
		</cfif>
		
		<cfif not isdefined('Arguments.RHDVDconceptoA')> 
			<cfset Arguments.RHDVDconceptoA = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHDVDconceptoB')> 
			<cfset Arguments.RHDVDconceptoB = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHDVDoperacion')> 
			<cfset Arguments.RHDVDoperacion = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHDVDconstante')> 
			<cfset Arguments.RHDVDconstante = "null">
		</cfif>
		
		<cfquery name="rsAltaDVariablesDinamicas" datasource="#Arguments.Conexion#">
			update RHDVariablesDinamicas set 
				RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEVDid#">,
				RHDVDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHDVDcodigo)#">,
				RHDVDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDVDdescripcion#">,
				RHDVDnivel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDnivel#">,
				RHDVDconceptoA = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDconceptoA#">,
				RHDVDconceptoB = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDconceptoB#">,
				RHDVDoperacion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHDVDoperacion#">,
				RHDVDconstante = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDconstante#">,
				RHDVDtipo	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDtipo#">,
				Ecodigo		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				BMUsucodigo	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfreturn #Arguments.RHDVDid#>
	</cffunction>
	
	<cffunction name="fnBajaDVariablesDinamicas">
		<cfargument name="RHDVDid"  			type="numeric" 	required="yes">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsExisteDependencia" datasource="#Arguments.Conexion#">
			select count(1) cantidad
			from RHDVariablesDinamicas 
			where
				RHDVDconceptoA = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
			  or
				RHDVDconceptoB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfif rsExisteDependencia.cantidad gt 0>
			<cfthrow message="Existe dependencia con niveles superiores, no se puede eliminar. Proceso Cancelado!!!">
		</cfif>
		<cfquery name="rsRHEVDid" datasource="#Arguments.Conexion#">
			select RHEVDid
			from RHDVariablesDinamicas
				where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHFVariablesDinamicas where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHDVariablesDinamicas where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfquery name="rsDVD" datasource="#Arguments.Conexion#">
			select RHDVDid
			from RHDVariablesDinamicas
				where RHEVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHEVDid.RHEVDid#">
			order by RHDVDnivel
		</cfquery>
		<cfloop query="rsDVD">
			<cfquery datasource="#Arguments.Conexion#">
				update RHDVariablesDinamicas set
					RHDVDnivel = #rsDVD.currentrow - 1#
				where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDVD.RHDVDid#">
			</cfquery>
		</cfloop>
	</cffunction>
	
	<cffunction name="fnGetFVariablesDinamicas" returntype="query">
		<cfargument name="RHDVDid"  type="numeric">
		<cfargument name="Ecodigo"  type="numeric">
		<cfargument name="Conexion" type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsFVariablesDinamicas" datasource="#Arguments.Conexion#">
			select RHDVDid, RHFVDcantidad, RHFVDspcantidad, RHFVDtipo, RHFVDcalculo, RHFVDdia, RHFVDmes, RHFVDmescompleto, RHFVDrango,
				RHFVDsprango, Ecodigo, BMUsucodigo, ts_rversion
			from RHFVariablesDinamicas
			where 1=1
				<cfif isdefined('Arguments.RHDVDid')>
					and RHDVDid = #Arguments.RHDVDid#
				</cfif>
				<cfif isdefined('Arguments.Ecodigo')>
					and Ecodigo = #Arguments.Ecodigo#
				</cfif>
		</cfquery>
		
		<cfreturn rsFVariablesDinamicas>
	</cffunction>
	
	<cffunction name="fnAltaFVariablesDinamicas" returntype="numeric">
		<cfargument name="RHDVDid"  			type="numeric" 	required="yes">
		<cfargument name="RHFVDcantidad"  		type="numeric" 	default="-1">
		<cfargument name="RHFVDspcantidad"  	type="numeric">
		<cfargument name="RHFVDtipo"  			type="string" 	required="yes">
		<cfargument name="RHFVDcalculo"  		type="string">
		<cfargument name="RHFVDdia"  			type="numeric">
		<cfargument name="RHFVDmes"  			type="numeric">
		<cfargument name="RHFVDmescompleto"  	type="numeric" default="0">
		<cfargument name="RHFVDrango"  			type="numeric">
		<cfargument name="RHFVDsprango"  		type="numeric">
		<cfargument name="Usuario"  			type="numeric">
		<cfargument name="Ecodigo"  			type="numeric">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
		
		<cfif not isdefined('Arguments.RHFVDspcantidad')> 
			<cfset Arguments.RHFVDspcantidad = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDrango')> 
			<cfset Arguments.RHFVDrango = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDdia')> 
			<cfset Arguments.RHFVDdia = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDmes')> 
			<cfset Arguments.RHFVDmes = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDrango')> 
			<cfset Arguments.RHFVDrango = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDsprango')> 
			<cfset Arguments.RHFVDsprango = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDcalculo')> 
			<cfset Arguments.RHFVDcalculo = "null">
		</cfif>

		<cfquery name="rsAltaFVariablesDinamicas" datasource="#Arguments.Conexion#">
			insert into RHFVariablesDinamicas(RHDVDid, RHFVDcantidad, RHFVDspcantidad, RHFVDtipo, RHFVDcalculo, RHFVDdia, RHFVDmes,
				RHFVDmescompleto, RHFVDrango, RHFVDsprango, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Arguments.RHFVDcantidad)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDspcantidad#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RHFVDtipo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#Arguments.RHFVDcalculo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDdia#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDmes#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDmescompleto#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDrango#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDsprango#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			)
		</cfquery>
		<cfreturn #Arguments.RHDVDid#>
	</cffunction>
	
	<cffunction name="fnCambioFVariablesDinamicas" returntype="numeric">
		<cfargument name="RHDVDid"  			type="numeric" 	required="yes">
		<cfargument name="RHFVDcantidad"  		type="numeric" 	default="-1">
		<cfargument name="RHFVDspcantidad"  	type="numeric">
		<cfargument name="RHFVDtipo"  			type="string" 	required="yes">
		<cfargument name="RHFVDcalculo"  		type="string">
		<cfargument name="RHFVDdia"  			type="numeric">
		<cfargument name="RHFVDmes"  			type="numeric">
		<cfargument name="RHFVDmescompleto"  	type="numeric" default="0">
		<cfargument name="RHFVDrango"  			type="numeric">
		<cfargument name="RHFVDsprango"  		type="numeric">
		<cfargument name="Usuario"  			type="numeric">
		<cfargument name="Ecodigo"  			type="numeric">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
		
		<cfif not isdefined('Arguments.RHFVDspcantidad')> 
			<cfset Arguments.RHFVDspcantidad = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDrango')> 
			<cfset Arguments.RHFVDrango = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDdia')> 
			<cfset Arguments.RHFVDdia = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDmes')> 
			<cfset Arguments.RHFVDmes = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDrango')> 
			<cfset Arguments.RHFVDrango = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDsprango')> 
			<cfset Arguments.RHFVDsprango = "null">
		</cfif>
		<cfif not isdefined('Arguments.RHFVDcalculo')> 
			<cfset Arguments.RHFVDcalculo = "null">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			update RHFVariablesDinamicas set 
				RHFVDcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Arguments.RHFVDcantidad)#">,
				RHFVDspcantidad = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDspcantidad#">,
				RHFVDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RHFVDtipo#">,
				RHFVDcalculo = <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#Arguments.RHFVDcalculo#">,
				RHFVDdia = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDdia#">,
				RHFVDmes = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDmes#">,
				RHFVDmescompleto = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDmescompleto#">,
				RHFVDrango = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDrango#">,
				RHFVDsprango = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFVDsprango#">,
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfreturn #Arguments.RHDVDid#>
	</cffunction>
	
	<cffunction name="fnValidaConfigVariablesDinamicas">
		<cfargument name="RHEVDtipo"  	type="string" required="yes">
		<cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsValidarVariablesDinamicas" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from RHFVariablesDinamicas
			where RHFVDtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEVDtipo#">
				and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsValidarVariablesDinamicas.cantidad gt 0>
			<cfthrow message="La configuración ingresada ya existe. Proceso Cancelado!!!">
		</cfif>
	</cffunction>
	
</cfcomponent>