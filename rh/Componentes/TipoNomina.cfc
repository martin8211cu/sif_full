<cfcomponent>
	<cffunction name="GetTipoNomina" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  	type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="Tcodigo"    	type="string"  required="no" hint="Tipo de Nomina">
        <cfargument name="ConEmpleado"	type="boolean" required="no" default="false" hint="Obtener tipos de nominas que poseean empleados">
        
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsTipoNomina" datasource="#Arguments.conexion#">
         	select tn.Ecodigo, tn.Tcodigo, tn.Mcodigo, tn.Tdescripcion, tn.Ttipopago, tn.FactorDiasSalario
            	from TiposNomina tn
            where tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.Tcodigo')>
              and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
            </cfif>
            <cfif Arguments.ConEmpleado>
              <cf_dbfunction name="today" returnvariable="LvarHoy">
           	  and(
              	  (select Count(1)
                   from DatosEmpleado de
                   	inner join LineaTiempo lt
                   		on lt.DEid = de.DEid and #LvarHoy# between lt.LTdesde and lt.LThasta
                   where de.Ecodigo = tn.Ecodigo and lt.Tcodigo = tn.Tcodigo)
                 + 
                 (select count(1)
                  from DatosEmpleado de
                  	inner join LineaTiempo lt
                    	on lt.DEid = de.DEid and lt.LThasta = (select Max(slt.LThasta) from LineaTiempo slt where slt.DEid = de.DEid) 
                  where (select count(1) 
                    	 from LineaTiempo slt
                    	 where slt.DEid = de.DEid and #LvarHoy# between slt.LTdesde and slt.LThasta) = 0 and de.Ecodigo  = tn.Ecodigo and lt.Tcodigo =  tn.Tcodigo)
			  ) >= 1
            </cfif>
         </cfquery>
		<cfreturn rsTipoNomina>
	</cffunction>
    <cffunction name="AltaTipoNomina" access="public" returntype="string">
    	<cfargument name="Tcodigo"   			type="string"  	required="yes" 	hint="Codigo de la Oficina">
        <cfargument name="Tdescripcion" 		type="string" 	required="yes" 	hint="Descripción del Tipo de Nomina">
        <cfargument name="Ttipopago" 	  		type="numeric"  required="no" 	hint="Codigo del Tipo Pago" default="0">
        <cfargument name="FactorDiasSalario" 	type="string" 	required="no" 	hint="Codigo del Tipo Pago">
        <cfargument name="Mcodigo" 				type="numeric" 	required="no" 	hint="Moneda">
        <cfargument name="Ecodigo" 	  			type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   			type="string"  	required="no" 	hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Mcodigo')>
            <cfquery name="Empresa" datasource="#Arguments.conexion#">
                select Mcodigo
                    from Empresas 
                 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
            <cfset Arguments.Mcodigo = Empresa.Mcodigo>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.FactorDiasSalario')>
        	<cfswitch expression="#Arguments.Ttipopago#">
            	<cfcase value="0">
                	<cfset Arguments.FactorDiasSalario = 26>
                </cfcase>
                <cfcase value="1">
                	<cfset Arguments.FactorDiasSalario = 30>
                </cfcase>
                <cfcase value="2">
                	<cfset Arguments.FactorDiasSalario = 30>
                </cfcase>
                <cfcase value="3">
                	<cfset Arguments.FactorDiasSalario = 30.333>
                </cfcase>
                <cfdefaultcase>
                	<cfset Arguments.FactorDiasSalario = 30>
                </cfdefaultcase>
            </cfswitch>
        </cfif>
        <cfquery name="AltaTiposNomina" datasource="#Arguments.conexion#">
        	insert into TiposNomina (Ecodigo,Tcodigo,Mcodigo,Tdescripcion,Ttipopago,FactorDiasSalario)
            values
            (
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
            	<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Tcodigo#">,  
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Mcodigo#">,                
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Tdescripcion#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ttipopago#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.FactorDiasSalario#">
            )
			</cfquery>
		<cfreturn Arguments.Tcodigo>
    </cffunction>   
    
    <cffunction name="fnCambioTipoNomina" access="public" returntype="string">
    	<cfargument name="Tcodigo"   			type="string"  	required="yes" 	hint="Codigo de la Oficina">
        <cfargument name="Tdescripcion" 		type="string" 	required="yes" 	hint="Descripción del Tipo de Nomina">
        <cfargument name="Ttipopago" 	  		type="numeric"  required="no" 	hint="Codigo del Tipo Pago" default="0">
        <cfargument name="FactorDiasSalario" 	type="string" 	required="no" 	hint="Codigo del Tipo Pago">
        <cfargument name="Mcodigo" 				type="numeric" 	required="no" 	hint="Moneda">
        <cfargument name="Ecodigo" 	  			type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   			type="string"  	required="no" 	hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Mcodigo')>
            <cfquery name="Empresa" datasource="#Arguments.conexion#">
                select Mcodigo
                    from Empresas 
                 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
            <cfset Arguments.Mcodigo = Empresa.Mcodigo>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.FactorDiasSalario')>
        	<cfswitch expression="#Arguments.Ttipopago#">
            	<cfcase value="0">
                	<cfset Arguments.FactorDiasSalario = 26>
                </cfcase>
                <cfcase value="1">
                	<cfset Arguments.FactorDiasSalario = 30>
                </cfcase>
                <cfcase value="2">
                	<cfset Arguments.FactorDiasSalario = 30>
                </cfcase>
                <cfcase value="3">
                	<cfset Arguments.FactorDiasSalario = 30.333>
                </cfcase>
                <cfdefaultcase>
                	<cfset Arguments.FactorDiasSalario = 30>
                </cfdefaultcase>
            </cfswitch>
        </cfif>
        <cfquery name="AltaTiposNomina" datasource="#Arguments.conexion#">
        	update TiposNomina set
                Mcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Mcodigo#">,
                Tdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Tdescripcion#">,
                Ttipopago = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ttipopago#">,
                FactorDiasSalario = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.FactorDiasSalario#">
            where Tcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Tcodigo#">
              and Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
			</cfquery>
		<cfreturn Arguments.Tcodigo>
    </cffunction>
</cfcomponent>