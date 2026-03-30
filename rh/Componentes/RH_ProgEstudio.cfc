<cfcomponent>
	
	<cffunction name="fnAltaBeca" access="public" returntype="numeric">
		<cfargument name="RHTBcodigo" 			type="string" 	required="true">
        <cfargument name="RHTBdescripcion" 		type="string" 	required="true">
        <cfargument name="RHTBesCorporativo" 	type="boolean" 	required="true" default="0">
        <cfargument name="RHTBfecha" 			type="date" 	required="true" default="#now()#">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
        <cfargument name="CEcodigo" 			type="numeric" >
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        <cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>

		<cfset fnExisteBeca(Arguments.RHTBcodigo, -1, Arguments.CEcodigo, Arguments.Ecodigo, Arguments.Conexion)>
        
		<cfif Arguments.RHTBesCorporativo eq 0>
        	<cfset Arguments.CEcodigo = "null">
        <cfelse>
        	<cfset Arguments.Ecodigo = "null">
        </cfif>
        
		<cfquery name="rsInsertB" datasource="#Arguments.Conexion#">
			insert into RHTipoBeca (RHTBcodigo, RHTBdescripcion, RHTBesCorporativo, RHTBfecha, CEcodigo, Ecodigo, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBesCorporativo#">,
                <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHTBfecha#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertB">
        <cfreturn #rsInsertB.identity#>
	</cffunction>
    
   <cffunction name="fnCambioBeca" access="public" returntype="numeric">
   		<cfargument name="RHTBid" 				type="numeric" 	required="true">
   		<cfargument name="RHTBcodigo" 			type="string" 	required="true">
        <cfargument name="RHTBdescripcion" 		type="string" 	required="true">
        <cfargument name="RHTBesCorporativo" 	type="boolean" 	required="true" default="0">
        <cfargument name="RHTBfecha" 			type="date" 	required="true" default="#now()#">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
        <cfargument name="CEcodigo" 			type="numeric" >
		<cfargument name="Conexion" 			type="string">	

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        <cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteBeca(Arguments.RHTBcodigo, Arguments.RHTBid, Arguments.CEcodigo, Arguments.Ecodigo, Arguments.Conexion)>
        
		<cfif Arguments.RHTBesCorporativo eq 0>
        	<cfset Arguments.CEcodigo = "null">
        <cfelse>
        	<cfset Arguments.Ecodigo = "null">
        </cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			update RHTipoBeca set
            	RHTBcodigo 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHTBcodigo)#">,
                RHTBdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBdescripcion#">,
                RHTBesCorporativo = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHTBesCorporativo#">,
                RHTBfecha 		 = <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHTBfecha#">,
                CEcodigo 		 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
                Ecodigo 		 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
		</cfquery>
        <cfreturn Arguments.RHTBid>
	</cffunction>
    
   	<cffunction name="fnBajaBeca" access="public">
   		<cfargument name="RHTBid" 			type="string" 	required="true">
		<cfargument name="Conexion" 		type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHTipoBeca
			where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="fnExisteBeca" access="private">
		<cfargument name="RHTBcodigo" 		type="string" required="true">
        <cfargument name="RHTBid" 			type="numeric">
		<cfargument name="CEcodigo" 		type="numeric">
        <cfargument name="Ecodigo" 			type="numeric" >
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsBeca" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHTipoBeca
            where
            	((
                	RHTBcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBcodigo#">
                	and Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">)
                or
                (
                	RHTBcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBcodigo#">
                	and CEcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
                ))
                <cfif isdefined('Arguments.RHTBid') and Arguments.RHTBid neq -1>
                	and RHTBid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
                </cfif>
		</cfquery>

        <cfif rsBeca.cantidad gt 0>
			<cfthrow message="El código ingresdo ya esta en uso a nivel empresarial o corporativo, Proceso Canceldo!!!">        
        </cfif>
	</cffunction>
    
    <cffunction name="fnGetBeca" access="public" returntype="query">
		<cfargument name="RHTBid" 			type="numeric">
		<cfargument name="CEcodigo" 		type="numeric">	
        <cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        <cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsSelectBeca" datasource="#Arguments.Conexion#">
			select  RHTBid, RHTBcodigo, RHTBdescripcion, RHTBesCorporativo, RHTBfecha, CEcodigo, Ecodigo, BMUsucodigo, ts_rversion
            from RHTipoBeca
			where ((RHTBesCorporativo = 0 and Ecodigo = #Arguments.Ecodigo#) or ( RHTBesCorporativo = 1 and CEcodigo = #Arguments.CEcodigo#))
            	<cfif isdefined('Arguments.RHTBid')>
                	and RHTBid = #Arguments.RHTBid#
                </cfif>
            order by RHTBcodigo, RHTBdescripcion
		</cfquery>
        <cfreturn rsSelectBeca>
	</cffunction>
    
    <cffunction name="fnAltaEC" access="public" returntype="numeric">
        <cfargument name="RHECBcodigo" 		type="string" 	 required="true">
        <cfargument name="RHECBdescripcion" type="string" 	 required="true">
        <cfargument name="RHECBfecha" 		type="date" 	 required="true" default="#now()#">
        <cfargument name="RHECBesMultiple" 	type="boolean" 	 required="true" default="0">
        <cfargument name="RHECBbeneficio" 	type="boolean" 	 required="true" default="0">
        <cfargument name="RHECBreporte" 	type="numeric">
        <cfargument name="Usucodigo"		type="numeric">
		<cfargument name="CEcodigo" 		type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        <cfif not isdefined('Arguments.RHECBreporte')>
			<cfset Arguments.RHECBreporte = "null">
		</cfif>
        
		<cfset fnExisteEC(Arguments.RHECBcodigo, -1, Arguments.CEcodigo, Arguments.Conexion)>
        <cfquery name="rsInsertEC" datasource="#Arguments.Conexion#">
            insert into RHEConceptosBeca (RHECBcodigo, RHECBdescripcion, RHECBfecha, RHECBesMultiple, CEcodigo, BMUsucodigo, RHECBbeneficio,RHECBreporte)
            values(
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHECBcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHECBdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHECBfecha#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHECBesMultiple#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHECBbeneficio#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHECBreporte#">
            )
            <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertEC">
        <cfreturn rsInsertEC.identity>
	</cffunction>
    
    <cffunction name="fnCambioEC" access="public" returntype="numeric">
    	<cfargument name="RHECBid" 			type="numeric" 	 required="true">
        <cfargument name="RHECBcodigo" 		type="string" 	 required="true">
        <cfargument name="RHECBdescripcion" type="string" 	 required="true">
        <cfargument name="RHECBfecha" 		type="date" 	 required="true" default="#now()#">
        <cfargument name="RHECBesMultiple" 	type="boolean" 	 required="true" default="0">
        <cfargument name="RHECBbeneficio" 	type="boolean" 	 required="true" default="0">
        <cfargument name="RHECBreporte" 	type="numeric">
        <cfargument name="Usucodigo"		type="numeric">
		<cfargument name="CEcodigo" 		type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
         <cfif not isdefined('Arguments.RHECBreporte')>
			<cfset Arguments.RHECBreporte = "null">
		</cfif>
        
		<cfset fnExisteEC(Arguments.RHECBcodigo, Arguments.RHECBid, Arguments.CEcodigo, Arguments.Conexion)>
        <cfquery datasource="#Arguments.Conexion#">
            update RHEConceptosBeca set
                RHECBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHECBcodigo#">,
                RHECBdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHECBdescripcion#">,
                RHECBfecha = <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHECBfecha#">,
                RHECBesMultiple = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHECBesMultiple#">,
                CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                RHECBbeneficio = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHECBbeneficio#">,
                RHECBreporte = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHECBreporte#">
			where RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
        </cfquery>
        <cfreturn Arguments.RHECBid>
	</cffunction>
    
   	<cffunction name="fnBajaEC" access="public">
   		<cfargument name="RHECBid" 		type="numeric" 	required="true">
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfquery datasource="#Arguments.Conexion#">
			delete from RHDConceptosBeca
            where RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
        </cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHEConceptosBeca
            where RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
        </cfquery>
	</cffunction>
    
    <cffunction name="fnGetEC" access="public" returntype="query">
		<cfargument name="RHECBid" 		type="numeric">
        <cfargument name="CEcodigo" 	type="numeric">	
		<cfargument name="Conexion" 	type="string">	
		

		<cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfquery name="rsSelectEC" datasource="#Arguments.Conexion#">
            select RHECBid, RHECBcodigo, RHECBdescripcion, RHECBfecha, RHECBesMultiple, CEcodigo, BMUsucodigo, ts_rversion, RHECBreporte, RHECBbeneficio
            from RHEConceptosBeca
            where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
				<cfif isdefined('Arguments.RHECBid')>
                	and RHECBid = #Arguments.RHECBid#
                </cfif>
        </cfquery>
        <cfreturn rsSelectEC>
	</cffunction>
    
   	<cffunction name="fnExisteEC" access="public">
		<cfargument name="RHECBcodigo" 		type="string" required="true">
        <cfargument name="RHECBid" 			type="numeric">
		<cfargument name="CEcodigo" 		type="numeric" >	
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsEC" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHEConceptosBeca
            where
            	CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
            	and RHECBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHECBcodigo#">
                <cfif isdefined('Arguments.RHECBid') and Arguments.RHECBid neq -1>
                	and RHECBid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
                </cfif>
		</cfquery>
        
        <cfif rsEC.cantidad gt 0>
			<cfthrow message="El código ingresado ya está en uso, Proceso Cancelado!!!">        
        </cfif>
	</cffunction>
    
    <cffunction name="fnAltaDC" access="public" returntype="numeric">
    	<cfargument name="RHECBid"			 type="numeric"  required="true">
        <cfargument name="RHDCBcodigo" 		 type="string" 	 required="true">
        <cfargument name="RHDCBdescripcion" type="string" 	 required="true">
        <cfargument name="RHDCBfecha" 		 type="date" 	 required="true" default="#now()#">
        <cfargument name="RHDCBtipo" 		 type="numeric"  default="0">
        <cfargument name="RHDCBnegativos" 	 type="boolean"  required="true" default="0">
        <cfargument name="Usucodigo"		 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteDC(Arguments.RHDCBcodigo, Arguments.RHECBid, -1, Arguments.Conexion)>
        <cfquery name="rsInsertDC" datasource="#Arguments.Conexion#">
            insert into RHDConceptosBeca (RHECBid, RHDCBcodigo, RHDCBdescripcion, RHDCBfecha, RHDCBtipo, RHDCBnegativos, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCBcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCBdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHDCBfecha#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHDCBtipo#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHDCBnegativos#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
            <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertDC">
        <cfreturn rsInsertDC.identity>
	</cffunction>
    
    <cffunction name="fnCambioDC" access="public" returntype="numeric">
    	<cfargument name="RHDCBid"			 type="numeric"  required="true">
    	<cfargument name="RHECBid"			 type="numeric"  required="true">
        <cfargument name="RHDCBcodigo" 		 type="string" 	 required="true">
        <cfargument name="RHDCBdescripcion" type="string" 	 required="true">
        <cfargument name="RHDCBfecha" 		 type="date" 	 required="true" default="#now()#">
        <cfargument name="RHDCBtipo" 		 type="numeric"  default="0">
        <cfargument name="RHDCBcompuesta" 	 type="boolean"  required="true" default="0">
        <cfargument name="RHDCBnegativos" 	 type="boolean"  required="true" default="0">
        <cfargument name="Usucodigo"		 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteDC(Arguments.RHDCBcodigo, Arguments.RHECBid, Arguments.RHDCBid, Arguments.Conexion)>
        <cfquery datasource="#Arguments.Conexion#">
            update RHDConceptosBeca set
            	RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">,
                RHDCBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCBcodigo#">,
                RHDCBdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCBdescripcion#">,
                RHDCBfecha = <cfqueryparam cfsqltype="cf_sql_date" 	 value="#Arguments.RHDCBfecha#">,
                RHDCBtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHDCBtipo#">,
                RHDCBnegativos = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHDCBnegativos#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where 
            	RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDCBid#">
        </cfquery>
        <cfreturn Arguments.RHDCBid>
	</cffunction>
    
    <cffunction name="fnBajaDC" access="public">
    	<cfargument name="RHDCBid"			 type="numeric">
        <cfargument name="RHECBid"			 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.RHDCBid') and not isdefined('Arguments.RHECBid')>
			<cfthrow message="Error al eliminar detalles de conceptos, alguno de estos campos es requerido: RHDCBid ó RHECBid.">
		</cfif>
       
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHDConceptosBeca where 
            <cfif isdefined('Arguments.RHECBid')>
            RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
            <cfelse>
            RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDCBid#">
            </cfif>
        </cfquery>
	</cffunction>
    
    <cffunction name="fnGetDC" access="public" returntype="query">
		<cfargument name="RHECBid" 		type="numeric" required="true">
        <cfargument name="RHDCBid" 		type="numeric">
        <cfargument name="CEcodigo" 	type="numeric">	
		<cfargument name="Conexion" 	type="string">	
		

		<cfif not isdefined('Arguments.CEcodigo')>
			<cfset Arguments.CEcodigo = "#session.CEcodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfquery name="rsSelectDC" datasource="#Arguments.Conexion#">
            select RHECBid, RHDCBid, RHDCBcodigo, RHDCBdescripcion, RHDCBfecha, RHDCBtipo, RHDCBnegativos, BMUsucodigo, ts_rversion
            from RHDConceptosBeca
            where RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
            	<cfif isdefined('Arguments.RHDCBid')>
                	and RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDCBid#">
                </cfif>
        </cfquery>
        <cfreturn rsSelectDC>
	</cffunction>
    
    <cffunction name="fnExisteDC" access="public">
		<cfargument name="RHDCBcodigo" 		type="string" required="true">
        <cfargument name="RHECBid" 			type="numeric" required="true">
		<cfargument name="RHDCBid" 			type="numeric">	
		<cfargument name="Conexion" 		type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsDC" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHDConceptosBeca
            where
            	RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
            	and RHDCBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCBcodigo#">
                <cfif isdefined('Arguments.RHDCBid') and Arguments.RHDCBid neq -1>
                	and RHDCBid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDCBid#">
                </cfif>
		</cfquery>
        
        <cfif rsDC.cantidad gt 0>
			<cfthrow message="El código ingresado ya esta en uso, Proceso Cancelado!!!">        
        </cfif>
	</cffunction>
    
    <cffunction name="fnAltaBC" access="public">
    	<cfargument name="RHTBid"			 type="numeric"  required="true">
        <cfargument name="RHECBid" 		 	 type="numeric" 	 required="true">
        <cfargument name="Usucodigo"		 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteBC(Arguments.RHTBid, Arguments.RHECBid, Arguments.Conexion)>
        <cfquery datasource="#Arguments.Conexion#">
            insert into RHTipoBecaConceptos (RHTBid, RHECBid, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
        </cfquery>
	</cffunction>
    
    <cffunction name="fnBajaBC" access="public">
    	<cfargument name="RHTBid"			 type="numeric" required="true">
        <cfargument name="RHECBid" 		 	 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfquery datasource="#Arguments.Conexion#">
            delete from RHTipoBecaConceptos
            where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
            	<cfif isdefined('Arguments.RHECBid')>
				and RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
              	</cfif>
        </cfquery>
	</cffunction>
    
    <cffunction name="fnExisteBC" access="public">
    	<cfargument name="RHTBid"			 type="numeric"  required="true">
        <cfargument name="RHECBid" 		 	 type="numeric"  required="true">
		<cfargument name="Conexion" 		 type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<cfquery name="rsBC" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHTipoBecaConceptos
            where
            	RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
            	and RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
		</cfquery>
        
        <cfif rsBC.cantidad gt 0>
			<cfthrow message="El concepto ya pertenece al tipo de beca, Proceso Cancelado!!!">        
        </cfif>
	</cffunction>

    <cffunction name="fnAltaBEF" access="public" returntype="numeric">
    	<cfargument name="RHTBid"			 type="numeric"  	required="true">
        <cfargument name="RHTBEFcodigo" 		 type="string" 	 	required="true">
        <cfargument name="RHTBEFdescripcion"  type="string" 	 	required="true">
        <cfargument name="RHTBEFfecha"  		 type="date" 	 	required="true" default="#now()#">
        <cfargument name="Usucodigo"		 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteBEF(Arguments.RHTBEFcodigo, Arguments.RHTBid, -1, Arguments.Conexion)>
        <cfquery name="rsInsertBEF" datasource="#Arguments.Conexion#">
            insert into RHTipoBecaEFormatos (RHTBid, RHTBEFcodigo, RHTBEFdescripcion, RHTBEFfecha, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBEFcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBEFdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.RHTBEFfecha#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
        <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertBEF">
        <cfreturn rsInsertBEF.identity>
	</cffunction>
    
    <cffunction name="fnCambioBEF" access="public" returntype="numeric">
    	<cfargument name="RHTBEFid"			 type="numeric"  	required="true">
    	<cfargument name="RHTBid"			 type="numeric"  	required="true">
        <cfargument name="RHTBEFcodigo"  	 type="string" 	 	required="true">
        <cfargument name="RHTBEFdescripcion" type="string" 	 	required="true">
        <cfargument name="RHTBEFfecha"  	 type="date" 	 	required="true" default="#now()#">
        <cfargument name="Usucodigo"		 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfset fnExisteBEF(Arguments.RHTBEFcodigo, Arguments.RHTBid, Arguments.RHTBEFid, Arguments.Conexion)>
        <cfquery datasource="#Arguments.Conexion#">
            update RHTipoBecaEFormatos set
            	RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">,
                RHTBEFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBEFcodigo#">,
                RHTBEFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBEFdescripcion#">,
                RHTBEFfecha = <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.RHTBEFfecha#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            where RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
        </cfquery>
        <cfreturn Arguments.RHTBEFid>
	</cffunction>
   
   	<cffunction name="fnBajaBEF" access="public">
    	<cfargument name="RHTBEFid"			 type="numeric">
        <cfargument name="RHTBid"			 type="numeric">
		<cfargument name="Conexion" 		 type="string">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        <cfif not isdefined('Arguments.RHTBid') and not isdefined('Arguments.RHTBEFid')>
			<cfthrow message="Error al eliminar Encabezado(s) de Formatos, se requiere alguno de los siguientes campos: RHTBid ó RHTBEFid.">
		</cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHTipoBecaEFormatos where
            	<cfif isdefined('Arguments.RHTBid')>
            		RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
                <cfelse>
                	RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
                </cfif>
        </cfquery>
	</cffunction>
    
    <cffunction name="fnExisteBEF" access="public">
		<cfargument name="RHTBEFcodigo" 	type="string" required="true">
        <cfargument name="RHTBid" 			type="numeric" required="true">
		<cfargument name="RHTBEFid" 		type="numeric">	
		<cfargument name="Conexion" 		type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsBEF" datasource="#Arguments.Conexion#">
			select count(1) cantidad
            from RHTipoBecaEFormatos
            where
            	RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
            	and RHTBEFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBEFcodigo#">
                <cfif isdefined('Arguments.RHTBEFid') and Arguments.RHTBEFid neq -1>
                	and RHTBEFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
                </cfif>
		</cfquery>
        
        <cfif rsBEF.cantidad gt 0>
			<cfthrow message="El código ingresado ya esta en uso, Proceso Cancelado!!!">        
        </cfif>
	</cffunction>
    
    <cffunction name="fnGetEFormato" access="public" returntype="query">
		<cfargument name="RHTBid" 		type="numeric" required="true">
        <cfargument name="RHTBEFid" 	type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfquery name="rsSelectBEF" datasource="#Arguments.Conexion#">
            select RHTBEFid, RHTBid, RHTBEFcodigo, RHTBEFdescripcion, RHTBEFfecha, BMUsucodigo, ts_rversion
            from RHTipoBecaEFormatos
            where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">
            	<cfif isdefined('Arguments.RHTBEFid')>
                	and RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
                </cfif>
        </cfquery>
        <cfreturn rsSelectBEF>
	</cffunction>
    
    <cffunction name="fnAltaBDF" access="public" returntype="numeric">
    	<cfargument name="RHTBEFid"			 type="numeric"  	required="true">
        <cfargument name="RHTBDForden"		 type="numeric"     required="false">
        <cfargument name="RHTBDFetiqueta" 	 type="string" 	 	required="true">
        <cfargument name="RHTBDFfuente" 	 type="string" 	 	required="true">
        <cfargument name="RHTBDFnegrita" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFitalica" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFsubrayado" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFnegativos" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFtamFuente" 	 type="numeric" 	required="true">
        <cfargument name="RHTBDFcolor" 	 	 type="string" 		required="true">
        <cfargument name="RHTBDFcapturaA"  	 type="numeric" 	required="true" default="1">
        <cfargument name="RHTBDFcapturaB"  	 type="numeric" 	required="false">
        <cfargument name="RHECBid" 	 	 	 type="string" 		required="true" default="null">
        <cfargument name="RHTBDFreporte" 	 type="numeric" 	required="false">
        <cfargument name="RHTBDFbeneficio" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFrequerido" 	 type="boolean" 	required="true" default="0">
        <cfargument name="Usucodigo"		 type="numeric"     required="false">
		<cfargument name="Conexion" 		 type="string"      required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
        <cfif not isdefined('Arguments.RHTBDForden')>
			<cfset Arguments.RHTBDForden = fnGetUltimoGradoBDF(Arguments.RHTBEFid, Arguments.Conexion)>
		</cfif>
        
        <cfif not isdefined('Arguments.RHTBDFcapturaB') or (isdefined('Arguments.RHTBDFcapturaB') and Arguments.RHTBDFcapturaB lt 1)>
			<cfset Arguments.RHTBDFcapturaB = "null">
		</cfif>
        
        <cfif not isdefined('Arguments.RHTBDFreporte')>
			<cfset Arguments.RHTBDFreporte = "null">
		</cfif>
        
		<!---<cfset fnExisteBEF(Arguments.RHTBEFcodigo, Arguments.RHTBid, -1, Arguments.Conexion)>--->
        <cfquery name="rsInsertBDF" datasource="#Arguments.Conexion#">
            insert into RHTipoBecaDFormatos (RHTBEFid, RHTBDForden, RHTBDFetiqueta, RHTBDFfuente, RHTBDFnegrita, RHTBDFitalica, RHTBDFsubrayado, RHTBDFnegativos, RHTBDFtamFuente, RHTBDFcolor, RHTBDFcapturaA, RHTBDFcapturaB, RHECBid, BMUsucodigo, RHTBDFreporte, RHTBDFbeneficio, RHTBDFrequerido)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHTBDForden#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBDFetiqueta#" maxlength="255">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBDFfuente#"  maxlength="50">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFnegrita#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFitalica#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFsubrayado#">,
                <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFnegativos#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHTBDFtamFuente#" maxlength="8">,
                <cfqueryparam cfsqltype="cf_sql_char" 	 value="#Arguments.RHTBDFcolor#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHTBDFcapturaA#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.RHTBDFcapturaB#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.RHECBid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFreporte#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHTBDFbeneficio#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHTBDFrequerido#">
                
            )
        <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertBDF">
        <cfreturn rsInsertBDF.identity>
	</cffunction>
    
    <cffunction name="fnCambioBDF" access="public" returntype="numeric">
    	<cfargument name="RHTBDFid"			 type="numeric"  	required="true">
    	<cfargument name="RHTBEFid"			 type="numeric"  	required="true">
        <cfargument name="RHTBDForden"		 type="numeric"     required="true">
        <cfargument name="RHTBDFetiqueta" 	 type="string" 	 	required="true">
        <cfargument name="RHTBDFfuente" 	 type="string" 	 	required="true">
        <cfargument name="RHTBDFnegrita" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFitalica" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFsubrayado" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFnegativos" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFtamFuente" 	 type="numeric" 	required="true">
        <cfargument name="RHTBDFcolor" 	 	 type="string" 		required="true">
        <cfargument name="RHTBDFcapturaA"  	 type="numeric" 	required="true" default="1">
        <cfargument name="RHTBDFcapturaB"  	 type="numeric" 	required="false">
        <cfargument name="RHECBid" 	 	 	 type="string" 		required="true" default="null"> 
        <cfargument name="RHTBDFreporte" 	 type="numeric" 	required="false">
        <cfargument name="RHTBDFbeneficio" 	 type="boolean" 	required="true" default="0">
        <cfargument name="RHTBDFrequerido" 	 type="boolean" 	required="true" default="0">
        <cfargument name="Usucodigo"		 type="numeric"     required="false">
		<cfargument name="Conexion" 		 type="string"      required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        <cfif not isdefined('Arguments.RHTBDFcapturaB') or (isdefined('Arguments.RHTBDFcapturaB') and Arguments.RHTBDFcapturaB lt 1)>
			<cfset Arguments.RHTBDFcapturaB = "null">
		</cfif>
        <cfif not isdefined('Arguments.RHTBDFreporte')>
			<cfset Arguments.RHTBDFreporte = "null">
		</cfif>
		<!---<cfset fnExisteBEF(Arguments.RHTBEFcodigo, Arguments.RHTBid, -1, Arguments.Conexion)>--->
        <cfquery datasource="#Arguments.Conexion#">
            update RHTipoBecaDFormatos set
            	RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">,
                RHTBDForden = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHTBDForden#">,
                RHTBDFetiqueta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBDFetiqueta#" maxlength="255">,
                RHTBDFfuente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHTBDFfuente#"  maxlength="50">,
                RHTBDFnegrita = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFnegrita#">,
                RHTBDFitalica = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFitalica#">,
                RHTBDFsubrayado = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFsubrayado#">,
                RHTBDFnegativos = <cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHTBDFnegativos#">,
                RHTBDFtamFuente = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHTBDFtamFuente#" maxlength="8">,
                RHTBDFcolor = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#Arguments.RHTBDFcolor#">,
                RHTBDFcapturaA = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHTBDFcapturaA#">,
                RHTBDFcapturaB = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.RHTBDFcapturaB#">,
                RHECBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.RHECBid#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                RHTBDFreporte = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFreporte#">,
                RHTBDFbeneficio = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHTBDFbeneficio#">,
                RHTBDFrequerido = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHTBDFrequerido#">
            where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
        </cfquery>
        <cfreturn Arguments.RHTBDFid>
	</cffunction>
    
	    <cffunction name="fnBajaBDF" access="public">
    	<cfargument name="RHTBDFid"			 type="numeric">
    	<cfargument name="RHTBEFid"			 type="numeric">
        <cfargument name="RHTBid"			 type="numeric">
		<cfargument name="Conexion" 		 type="string"      required="false">	
        <cfargument name="TransaccionActiva" type="boolean" required="false" default="false">
				
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        <cfif not isdefined('Arguments.RHTBEFid') and not isdefined('Arguments.RHTBDFid') and not isdefined('Arguments.RHTBid')>
			<cfthrow message="Error al eliminar los detalles del formato, se requiere alguno de los siguientes campos: RHTBEFid, RHTBDFid ó RHTBid.">
		</cfif>
        
        <cfquery name="rsSelectDetalles" datasource="#Arguments.Conexion#">
            select RHTBDFid, RHTBEFid, RHTBDForden
            from RHTipoBecaDFormatos
            where 
            <cfif isdefined('Arguments.RHTBid')>
           		0=1
            <cfelseif isdefined('Arguments.RHTBEFid')>
            	0=1
            <cfelse>
            RHTBEFid = (select RHTBEFid from RHTipoBecaDFormatos where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">)
            and
            RHTBDFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
            </cfif>
            order by RHTBDForden
        </cfquery>
	
		<cfif Arguments.TransaccionActiva>
			<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBDFPrivate">
				<cfif isdefined('Arguments.RHTBDFid')>
					<cfinvokeargument name="RHTBDFid" 		value="#Arguments.RHTBDFid#">
				</cfif>
				<cfif isdefined('Arguments.RHTBEFid')>
					<cfinvokeargument name="RHTBEFid" 		value="#Arguments.RHTBEFid#">
				</cfif>
				<cfif isdefined('Arguments.RHTBid')>
					<cfinvokeargument name="RHTBid" 		value="#Arguments.RHTBid#">
				</cfif>
				<cfinvokeargument name="Query" 				value="#rsSelectDetalles#">
				<cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#">
			</cfinvoke>
		<cfelse>
			<cftransaction>
				<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaBDFPrivate">
					<cfif isdefined('Arguments.RHTBDFid')>
						<cfinvokeargument name="RHTBDFid" 		value="#Arguments.RHTBDFid#">
					</cfif>
					<cfif isdefined('Arguments.RHTBEFid')>
						<cfinvokeargument name="RHTBEFid" 		value="#Arguments.RHTBEFid#">
					</cfif>
					<cfif isdefined('Arguments.RHTBid')>
						<cfinvokeargument name="RHTBid" 		value="#Arguments.RHTBid#">
					</cfif>
					<cfinvokeargument name="Query" 				value="#rsSelectDetalles#">
					<cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#">
				</cfinvoke>
			</cftransaction>
		</cfif>
        
	</cffunction>
	
    <cffunction name="fnBajaBDFPrivate" access="package">
    	<cfargument name="RHTBDFid"			 type="numeric">
    	<cfargument name="RHTBEFid"			 type="numeric">
        <cfargument name="RHTBid"			 type="numeric">
		<cfargument name="Query" 		 	 type="query">	
		<cfargument name="Conexion" 		 type="string">	
        
        <cfif not isdefined('Arguments.RHTBEFid') and not isdefined('Arguments.RHTBDFid') and not isdefined('Arguments.RHTBid')>
			<cfthrow message="Error al eliminar los detalles del formato, se requiere alguno de los siguientes campos: RHTBEFid, RHTBDFid ó RHTBid.">
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			delete from RHTipoBecaDFormatos where
				<cfif isdefined('Arguments.RHTBid')>
				RHTBEFid in (select RHTBEFid from RHTipoBecaEFormatos where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">)
				<cfelseif isdefined('Arguments.RHTBEFid')>
				RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
				<cfelse>
				RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
				</cfif>
		</cfquery>
		<cfloop query="Arguments.Query">
			<cfquery datasource="#Arguments.Conexion#">
				update RHTipoBecaDFormatos set
					RHTBDForden = #Arguments.query.currentrow#
				where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
			</cfquery>
		</cfloop>
        
	</cffunction>
    
    <cffunction name="fnCambioBDFGrado" access="public" returntype="numeric">
    	<cfargument name="RHTBDFid"			 type="numeric"  	required="true">
        <cfargument name="Posicion"			 type="numeric"     required="true">
        <cfargument name="TransaccionActiva" type="boolean"     required="true" default="false">
        <cfargument name="Usucodigo" 		 type="numeric"     required="false">
		<cfargument name="Conexion" 		 type="string"      required="false">	
     
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
     	<cfif Arguments.TransaccionActiva>
        	<cfreturn fnCambioBDFGradoT(Arguments.RHTBDFid, Arguments.Posicion, Arguments.Usucodigo, Arguments.Conexion)>
        <cfelse>
        	<cftransaction>
        		<cfreturn fnCambioBDFGradoT(Arguments.RHTBDFid, Arguments.Posicion, Arguments.Usucodigo, Arguments.Conexion)>
            </cftransaction>
        </cfif>
    </cffunction>
    
    <cffunction name="fnCambioBDFGradoT" access="private" returntype="numeric">
    	<cfargument name="RHTBDFid"			 type="numeric"  	required="true">
        <cfargument name="Posicion"			 type="numeric"     required="true">
        <cfargument name="Usucodigo" 		 type="numeric"     required="true">
		<cfargument name="Conexion" 		 type="string"      required="true">	

        <cfquery name="rsSelectActual" datasource="#Arguments.Conexion#">
            select RHTBDFid, RHTBEFid, RHTBDForden
            from RHTipoBecaDFormatos
            where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
        </cfquery>
        <cfquery name="rsSelectAcambiar" datasource="#Arguments.Conexion#">
            select RHTBDFid, RHTBEFid, RHTBDForden
            from RHTipoBecaDFormatos
            where RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectActual.RHTBEFid#">
            	and RHTBDForden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Posicion#">
        </cfquery>
        <cfquery datasource="#Arguments.Conexion#">
            update RHTipoBecaDFormatos set
            	RHTBDForden = -1
           	where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectAcambiar.RHTBDFid#">
        </cfquery>
        <cfquery datasource="#Arguments.Conexion#">
            update RHTipoBecaDFormatos set
            	RHTBDForden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Posicion#">
           	where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
        </cfquery>
        <cfquery datasource="#Arguments.Conexion#">
            update RHTipoBecaDFormatos set
            	RHTBDForden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectActual.RHTBDForden#">
           	where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectAcambiar.RHTBDFid#">
        </cfquery>
        <cfreturn Arguments.RHTBDFid>
	</cffunction>

    <cffunction name="fnGetDFormato" access="public" returntype="query">
		<cfargument name="RHTBEFid" 	type="numeric" required="true">
        <cfargument name="RHTBDFid" 	type="numeric">
		<cfargument name="Conexion" 	type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfquery name="rsSelectBDF" datasource="#Arguments.Conexion#">
            select RHTBDFid, RHTBEFid, RHTBDForden, RHTBDFetiqueta, RHTBDFfuente, RHTBDFnegrita, RHTBDFitalica, RHTBDFsubrayado, RHTBDFnegativos, RHTBDFtamFuente, RHTBDFcolor, RHTBDFcapturaA, RHTBDFcapturaB, RHECBid, BMUsucodigo, ts_rversion, RHTBDFreporte, RHTBDFbeneficio, RHTBDFrequerido
            from RHTipoBecaDFormatos
            where RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
            	<cfif isdefined('Arguments.RHTBEFid')>
                	and RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
                </cfif>
        </cfquery>
        <cfreturn rsSelectBDF>
	</cffunction>
    
    <cffunction name="fnGetUltimoGradoBDF" access="public" returntype="numeric">
    	<cfargument name="RHTBEFid"			 type="numeric"  	required="true">
		<cfargument name="Conexion" 		 type="string"      required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        <cfquery name="rsUltimoGrado" datasource="#Arguments.Conexion#">
            select coalesce(max(RHTBDForden),0) + 1 as grado
            from RHTipoBecaDFormatos
            where RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBEFid#">
		</cfquery>
        <cfreturn rsUltimoGrado.grado>
	</cffunction>
    
     <cffunction name="fnAltaEBE" access="public" returntype="numeric">
    	<cfargument name="RHTBid" 	 	type="numeric" 	required="true">
        <cfargument name="DEid"		 	type="numeric"  required="true">
        <cfargument name="RHEBEfecha" 	type="date" 	required="false" default="#now()#">
        <cfargument name="RHEBEestado" 	type="numeric" 	required="false" default="10">
        <cfargument name="Ecodigo" 	 	type="numeric" 	required="false">
        <cfargument name="Usucodigo"	type="numeric"  required="false">
		<cfargument name="Conexion"     type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
 
        <cfquery name="rsInsertEBE" datasource="#Arguments.Conexion#">
            insert into RHEBecasEmpleado (DEid, RHTBid, RHEBEfecha, RHEBEestado, Ecodigo, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">,
                <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.RHEBEfecha#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHEBEestado#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
        <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertEBE">
        <cfreturn rsInsertEBE.identity>
	</cffunction>
    
    <cffunction name="fnBajaEBE" access="public">
    	<cfargument name="RHEBEid" 	 	type="numeric" 	required="true">
		<cfargument name="Conexion"     type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHEBecasEmpleado where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">
        </cfquery>
	</cffunction>
    
    <cffunction name="fnCambioEstadoEBE" access="public" returntype="numeric">
    	<cfargument name="RHEBEid" 	 				type="numeric" 	required="true">
        <cfargument name="RHEBEestado" 				type="numeric"  required="true">
        <cfargument name="RHEBEjustificacionJef" 	type="string"   required="false">
        <cfargument name="RHEBEsesionJef" 			type="string"  	required="false">
        <cfargument name="RHEBEarticuloJef" 		type="string"  	required="false">
        <cfargument name="RHEBEfechaJef" 			type="date"  	required="false">
        <cfargument name="RHEBEjustificacionVic" 	type="string"  	required="false">
        <cfargument name="RHEBEjustificacionCom" 	type="string"   required="false">
        <cfargument name="RHEBEsesionCom" 			type="string"  	required="false">
        <cfargument name="RHEBEarticuloCom" 		type="string"  	required="false">
        <cfargument name="RHEBEfechaCom" 			type="date"  	required="false">
        <cfargument name="RHEBEusuarioAJef" 	 	type="numeric" 	required="false">
        <cfargument name="RHEBEusuarioRJef" 	 	type="numeric" 	required="false">
        <cfargument name="RHEBEusuarioAVic" 	 	type="numeric" 	required="false">
        <cfargument name="RHEBEusuarioRVic" 	 	type="numeric" 	required="false">
        <cfargument name="RHEBEusuarioACom" 	 	type="numeric" 	required="false">
        <cfargument name="RHEBEusuarioRCom" 	 	type="numeric" 	required="false">
        <cfargument name="RHEBEacuerdo" 	 		type="string" 	required="false">
        <cfargument name="Ecodigo" 	 				type="numeric" 	required="false">
        <cfargument name="Usucodigo"				type="numeric"  required="false">
		<cfargument name="Conexion"     			type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
 
        <cfquery datasource="#Arguments.Conexion#">
            update RHEBecasEmpleado set
            	 RHEBEestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHEBEestado#">,
                 Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                 BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
                 <cfif isdefined('Arguments.RHEBEjustificacionJef')>
                 	,RHEBEjustificacionJef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEjustificacionJef#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEsesionJef')>
                 	,RHEBEsesionJef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEsesionJef#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEarticuloJef')>
                 	,RHEBEarticuloJef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEarticuloJef#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEfechaJef')>
                 	,RHEBEfechaJef = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RHEBEfechaJef#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEjustificacionVic')>
                 	,RHEBEjustificacionVic = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEjustificacionVic#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEusuarioAJef')>
                 	,RHEBEusuarioAJef = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEusuarioAJef#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEusuarioRJef')>
                 	,RHEBEusuarioRJef = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEusuarioRJef#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEusuarioAVic')>
                 	,RHEBEusuarioAVic = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEusuarioAVic#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEusuarioRVic')>
                 	,RHEBEusuarioRVic = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEusuarioRVic#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEusuarioACom')>
                 	,RHEBEusuarioACom = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEusuarioACom#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEusuarioRCom')>
                 	,RHEBEusuarioRCom = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEusuarioRCom#">
                 </cfif>
                 
                  <cfif isdefined('Arguments.RHEBEjustificacionCom')>
                 	,RHEBEjustificacionCom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEjustificacionCom#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEsesionCom')>
                 	,RHEBEsesionCom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEsesionCom#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEarticuloCom')>
                 	,RHEBEarticuloCom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHEBEarticuloCom#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEfechaCom')>
                 	,RHEBEfechaCom = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RHEBEfechaCom#">
                 </cfif>
                 <cfif isdefined('Arguments.RHEBEacuerdo')>
                 	,RHEBEacuerdo = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.RHEBEacuerdo#">
                 </cfif>
            where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">
        </cfquery>
        <cfreturn Arguments.RHEBEid>
	</cffunction>
    
    <cffunction name="fnCrearCopiaEBE" access="public" returntype="numeric">
    	<cfargument name="RHEBEid" 	 				type="numeric" 	required="true">
        <cfargument name="Usucodigo"				type="numeric"  required="false">
		<cfargument name="Conexion"     			type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
		
        <cfquery datasource="#Arguments.Conexion#">
       		insert into RHDBecasEmpleado(RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor, Ecodigo, BMUsucodigo, RHDBEversion)
            select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor, Ecodigo, BMUsucodigo, 1
            from RHDBecasEmpleado
            where RHEBEid = #Arguments.RHEBEid# and RHDBEversion = 0
        </cfquery>
        
        <cfreturn Arguments.RHEBEid>
	</cffunction>
    
     <cffunction name="fnGetEBE" access="public" returntype="query">
     	<cfargument name="RHEBEid" 	 	type="numeric">
        <cfargument name="Ecodigo" 	 	type="numeric">
		<cfargument name="Conexion"     type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        
        <cfquery name="rsSelectEBE" datasource="#Arguments.Conexion#">
            select RHEBEid, DEid, RHTBid, RHEBEfecha, RHEBEestado, Ecodigo, BMUsucodigo, ts_rversion, RHEBErutaPlan, RHEBEarchivo, RHEBEsesionCom, RHEBEsesionJef, RHEBEarticuloCom, RHEBEarticuloJef, RHEBEfechaCom, RHEBEfechaJef, RHEBEjustificacionJef, RHEBEjustificacionVic, RHEBEjustificacionCom, RHEBEacuerdo
            from RHEBecasEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				<cfif isdefined('Arguments.RHEBEid')>
                	and RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">
                </cfif>
        </cfquery>
        <cfreturn rsSelectEBE>
	</cffunction>
    
    <cffunction name="fnAltaDBE" access="public">
    	<cfargument name="RHEBEid" 	 	type="numeric" 	required="true">
        <cfargument name="RHTBDFid"		type="numeric"  required="false">
        <cfargument name="RHDCBid" 		type="numeric" 	required="false">
        <cfargument name="RHDBEvalor" 	type="string" 	required="false">
        <cfargument name="RHDBEversion" type="numeric" 	required="false" default="0">
        <cfargument name="Ecodigo" 	 	type="numeric" 	required="false">
        <cfargument name="Usucodigo"	type="numeric"  required="false">
		<cfargument name="Conexion"     type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
         <cfif not isdefined('Arguments.RHTBDFid')>
			<cfset Arguments.RHTBDFid = "null">
		</cfif>
        <cfif not isdefined('Arguments.RHDCBid')>
			<cfset Arguments.RHDCBid = "null">
		</cfif>
        <cfif not isdefined('Arguments.RHDBEvalor')>
			<cfset Arguments.RHDBEvalor = "null">
		</cfif>

        <cfquery datasource="#Arguments.Conexion#">
            insert into RHDBecasEmpleado (RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor, Ecodigo, BMUsucodigo, RHDBEversion)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.RHTBDFid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Arguments.RHDCBid#">,
				  <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.RHDBEvalor#">,                
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.RHDBEversion#">
            )
        </cfquery>
        <cfreturn>
	</cffunction>
    
   	<cffunction name="fnGetDBE" access="public" returntype="query">
    	<cfargument name="RHEBEid" 	 	type="numeric" 	required="true">
        <cfargument name="RHDBEversion" type="numeric" 	required="true" default="0">
		<cfargument name="Conexion"     type="string"   required="false">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        <cfquery name="rsSelectDBE" datasource="#Arguments.Conexion#">
           	select a.RHEBEid, a.RHTBDFid, a.RHDCBid, <cf_dbfunction name="to_char"	args="a.RHDBEvalor"  len="32000"> as RHDBEvalor, a.Ecodigo, a.BMUsucodigo, a.ts_rversion, b.RHDCBtipo, b.RHDCBnegativos, a.RHDBEversion
           	from RHDBecasEmpleado a
            	left outer join RHDConceptosBeca b
                	on b.RHDCBid = a.RHDCBid
        	where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">
            	and RHDBEversion = #Arguments.RHDBEversion#
        </cfquery>
        <cfreturn rsSelectDBE>
	</cffunction>
    
   	<cffunction name="fnBajaDBE" access="public">
    	<cfargument name="RHEBEid" 	 	type="numeric" required="true">
		<cfargument name="Conexion"     type="string">	
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
 
        <cfquery datasource="#Arguments.Conexion#">
            delete from RHDBecasEmpleado where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">
        </cfquery>
        
	</cffunction>
    
    <cffunction name="fnAltaFiadores" access="public" returntype="numeric">
		<cfargument name="RHFcedula" 			type="string" 	required="true">
        <cfargument name="RHFnombre" 			type="string" 	required="true">
        <cfargument name="RHFapellido1" 		type="string" 	required="true">
        <cfargument name="RHFapellido2" 		type="string" 	required="true">
        <cfargument name="RHFestadoCivil" 		type="numeric" 	required="true">
       	<cfargument name="RHFprovincia" 		type="string" 	required="true">
       	<cfargument name="RHFcanton" 			type="string" 	required="true">
       	<cfargument name="RHFempresaLabora" 	type="string" 	required="true">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>

		<cfset fnExisteFiadores(Arguments.RHFcedula, -1, Arguments.Ecodigo, Arguments.Conexion)>
        
		<cfquery name="rsInsertF" datasource="#Arguments.Conexion#">
			insert into RHFiadores (RHFcedula, RHFnombre, RHFapellido1, RHFapellido2, RHFestadoCivil, RHFprovincia, RHFcanton, RHFempresaLabora, Ecodigo, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHFcedula)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFnombre#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFapellido1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFapellido2#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFestadoCivil#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFprovincia#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFcanton#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFempresaLabora#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertF">
        <cfreturn #rsInsertF.identity#>
	</cffunction>
    
   	<cffunction name="fnCambioFiadores" access="public" returntype="numeric">
    	<cfargument name="RHFid" 				type="numeric" 	required="true">
		<cfargument name="RHFcedula" 			type="string" 	required="true">
        <cfargument name="RHFnombre" 			type="string" 	required="true">
        <cfargument name="RHFapellido1" 		type="string" 	required="true">
        <cfargument name="RHFapellido2" 		type="string" 	required="true">
        <cfargument name="RHFestadoCivil" 		type="numeric" 	required="true">
       	<cfargument name="RHFprovincia" 		type="string" 	required="true">
       	<cfargument name="RHFcanton" 			type="string" 	required="true">
       	<cfargument name="RHFempresaLabora" 	type="string" 	required="true">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>

		<cfset fnExisteFiadores(Arguments.RHFcedula, Arguments.RHFid, Arguments.Ecodigo, Arguments.Conexion)>
        
		<cfquery datasource="#Arguments.Conexion#">
			update RHFiadores set
            	RHFcedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHFcedula)#">,
                RHFnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFnombre#">,
                RHFapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFapellido1#">,
                RHFapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFapellido2#">,
                RHFestadoCivil = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFestadoCivil#">,
                RHFprovincia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFprovincia#">,
                RHFcanton = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFcanton#">,
                RHFempresaLabora = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFempresaLabora#">,
                Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">
		</cfquery>
        <cfreturn #Arguments.RHFid#>
	</cffunction>
    
    <cffunction name="fnBajaFiadores" access="public">
    	<cfargument name="RHFid" 				type="numeric" 	required="true">
		<cfargument name="Conexion" 			type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHFiadores where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="fnGetFiadores" access="public" returntype="query">
		<cfargument name="RHFid" 			type="numeric">
		<cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>

		<cfquery name="rsInsertF" datasource="#Arguments.Conexion#">
			select RHFid, RHFcedula, RHFnombre, RHFapellido1, RHFapellido2, RHFestadoCivil, RHFprovincia, RHFcanton, RHFempresaLabora, Ecodigo, BMUsucodigo, ts_rversion
            from RHFiadores
             where 
             	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                <cfif isdefined('Arguments.RHFid')>
             		and RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">
                </cfif>
		</cfquery>
        <cfreturn rsInsertF>
	</cffunction>
	
	<cffunction name="fnExisteFiadores" access="public">
		<cfargument name="RHFcedula" 		type="string">
		<cfargument name="RHFid" 			type="numeric">
		<cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<cfquery name="rsExisteF" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
            from RHFiadores
             where 
             	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				and RHFcedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHFcedula#">
                <cfif isdefined('Arguments.RHFid')>
             		and RHFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">
                </cfif>
		</cfquery>
        <cfif rsExisteF.cantidad gt 0>
			<cfthrow message="La cédula ingresada para el fiador ya esta en uso, Proceso Cancelado!!!">        
        </cfif>
	</cffunction>
    
   	<cffunction name="fnAltaFBecas" access="public">
		<cfargument name="RHEBEid" 				type="numeric" 	required="true">
        <cfargument name="DEid" 				type="numeric">
        <cfargument name="RHFid" 				type="numeric">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
         <cfif not isdefined('Arguments.DEid')>
			<cfset Arguments.DEid = "null">
		</cfif>
         <cfif not isdefined('Arguments.RHFid')>
			<cfset Arguments.RHFid = "null">
		</cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			insert into RHFiadoresBecasEmpleado (RHEBEid, DEid, RHFid, Ecodigo, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEBEid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
		</cfquery>
	</cffunction>
    
   	<cffunction name="fnAltaEConfig" access="public" returntype="numeric">
		<cfargument name="RHTBid" 				type="numeric" 	required="true">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfquery name="rsInsertEC" datasource="#Arguments.Conexion#">
			insert into RHEConfigCertBecas (RHTBid, Ecodigo, BMUsucodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            )
		<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertEC">
        <cfreturn #rsInsertEC.identity#>
	</cffunction>
    
    <cffunction name="fnBajaEConfig" access="public">
		<cfargument name="RHECCBid" 			type="numeric" required="true">
		<cfargument name="Conexion" 			type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfquery datasource="#Arguments.Conexion#">
			delete from RHDConfigCertBecas where RHECCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECCBid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHEConfigCertBecas where RHECCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECCBid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="fnGetEConfig" access="public" returntype="query">
		<cfargument name="RHECCBid" 	type="numeric" 	required="true">
		<cfargument name="Conexion" 	type="string">	

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<cfquery name="rsCC" datasource="#Arguments.Conexion#">
			select RHECCBid, RHTBid, Ecodigo, BMUsucodigo, ts_rversion
            from RHEConfigCertBecas
			where RHECCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECCBid#">
		</cfquery>
        <cfreturn rsCC>
	</cffunction>
    
    <cffunction name="fnAltaDConfig" access="public">
		<cfargument name="RHECCBid" 			type="numeric" 	required="true">
        <cfargument name="RHTBDFid" 			type="numeric" 	required="true">
        <cfargument name="RHDCCBcodigo" 		type="string" 	required="true">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			insert into RHDConfigCertBecas (RHECCBid, RHTBDFid, Ecodigo, BMUsucodigo, RHDCCBcodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECCBid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCCBcodigo#">
            )
		</cfquery>
	</cffunction>
    
    <cffunction name="fnCambioDConfig" access="public">
		<cfargument name="RHECCBid" 			type="numeric" 	required="true">
        <cfargument name="RHTBDFid" 			type="numeric" 	required="true">
        <cfargument name="RHDCCBcodigo" 		type="string" 	required="true">
        <cfargument name="Usucodigo"			type="numeric">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			update RHDConfigCertBecas set 
                Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                RHDCCBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHDCCBcodigo#">
           	where RHECCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECCBid#">
                and RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="fnBajaDConfig" access="public">
		<cfargument name="RHECCBid" 			type="numeric" 	required="true">
        <cfargument name="RHTBDFid" 			type="numeric" 	required="true">
		<cfargument name="Conexion" 			type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHDConfigCertBecas
           	where RHECCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECCBid#">
                and RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="fnGetDConfig" access="public" returntype="query">
		<cfargument name="RHECCBid" 			type="numeric" 	required="true">
        <cfargument name="RHTBDFid" 			type="numeric" 	required="true">
		<cfargument name="Conexion" 			type="string">	
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
		<cfquery name="rsDCC" datasource="#Arguments.Conexion#">
			select RHECCBid, RHTBDFid, Ecodigo, BMUsucodigo, RHDCCBcodigo
            from RHDConfigCertBecas
            where RHECCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECCBid#">
                and RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTBDFid#">
		</cfquery>
        <cfreturn rsDCC>
	</cffunction>

	<!---<cffunction name="fnRedondear" access="private" returntype="string">
		<cfargument name="Monto" type="numeric">
		<cfargument name="Decimales" type="numeric" default="2">
		
		<cfreturn NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#")>
	</cffunction>
	 
	<cffunction name="fnFormatMoney" access="private" returntype="string">
		<cfargument name="Monto" type="numeric">
		<cfargument name="Decimales" type="numeric" default="2">
		<cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".99"),'none')>
	</cffunction>--->
    
</cfcomponent>


