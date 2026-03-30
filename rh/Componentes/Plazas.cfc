<cfcomponent>
	<cffunction name="GetPlaza" access="public" returntype="query">
		<cfargument name="conexion"   type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Ecodigo"    type="numeric" 	required="no" hint="Codigo de la empresa del Portal">
        <cfargument name="CFid"   	  type="numeric" 	required="no" hint="Codigo del Centro Funcional">
        <cfargument name="RHPpuesto"  type="string" 	required="no" hint="Codigo del Puesto">
         
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
        <cfquery name="ABC_RHPlazas" datasource="#Arguments.conexion#">
          select RHPid,		Ecodigo,	RHPpuesto,		Dcodigo,		Ocodigo
                ,CFid,		RHCPlinea,	RHPPid,			RHPdescripcion,	RHPcodigo,
                CFidconta,	RHPactiva,	BMUsucodigo,	ts_rversion,	IDInterfaz,	RHPporcentaje
            from RHPlazas
          where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
         <cfif isdefined('Arguments.CFid')>
         	and CFid = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.CFid#">
         </cfif>
          <cfif isdefined('Arguments.RHPpuesto')>
         	and RHPpuesto = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHPpuesto#">
         </cfif>
        </cfquery>
		<cfreturn ABC_RHPlazas>
	</cffunction>
 <!---===================================================================================--->
    <cffunction name="AltaPlaza" access="public" returntype="numeric">
		<cfargument name="conexion"   		type="string"  	required="no"  hint="Nombre del DataSource">
        <cfargument name="Ecodigo"    		type="numeric" 	required="no"  hint="Codigo de la empresa del Portal">
        <cfargument name="RHPpuesto"    	type="string" 	required="yes" hint="">
        <cfargument name="CFid"    			type="numeric" 	required="yes" hint="">
        <cfargument name="RHPdescripcion"  	type="string" 	required="no" hint="">
        <cfargument name="RHPcodigo"    	type="string" 	required="no" hint="">
        <cfargument name="Usucodigo"    	type="numeric" 	required="no" hint="Usuario que realiza la transaccion">
        <cfargument name="LTfecha"    		type="date" 	required="no" hint="Fecha Desde"> 
         
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.RHPcodigo')>
        	<cfset Arguments.RHPcodigo = Arguments.CFid&'-'&Arguments.RHPpuesto>
        </cfif>
        <cfif not isdefined('Arguments.RHPdescripcion')>
        	<cfset Arguments.RHPdescripcion = Arguments.RHPcodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <!---►►►►►►Obtienen la moneda de la empresa◄◄◄◄◄◄◄◄--->
        <cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="obtenerMoneda" returnvariable="vMcodigo">
			<cfinvokeargument name="DSN" 	 value="#Arguments.conexion#">
			<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#">
		</cfinvoke>
        <cftransaction>
			<!---►►►►►►Crea la plaza Presupuestaria◄◄◄◄◄◄◄◄--->
            <cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="insertarPlaza" returnvariable="vRHPPid">
                <cfinvokeargument name="DSN" 				value="#Arguments.conexion#">
                <cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
                <cfinvokeargument name="RHPPcodigo" 		value="#Arguments.RHPcodigo#">
                <cfinvokeargument name="RHPPdescripcion"	value="#Arguments.RHPdescripcion#">
                <cfinvokeargument name="BMUsucodigo"		value="#session.Usucodigo#">
            </cfinvoke>
            <!---►►►►►►Crea la plaza◄◄◄◄◄◄◄◄--->
            <cfquery name="ABC_RHPlazas" datasource="#Arguments.conexion#">
                insert into RHPlazas(Ecodigo,RHPpuesto,CFid,RHPdescripcion,RHPcodigo,RHPPid)values(
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHPpuesto#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.CFid#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHPdescripcion#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
                )
                <cf_dbidentity1 datasource="#Arguments.conexion#">
            </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="ABC_RHPlazas">
            <!---►►►►►►Crea un registro de la linea del Tiempo para la plaza presupuestaria◄◄◄◄◄◄◄◄--->
            <cfset fechamax = CreateDate(6100, 01, 01)>
            <cfquery datasource="#session.DSN#">
                insert into RHLineaTiempoPlaza( Ecodigo,RHPPid,RHCid,RHMPPid,RHTTid,RHMPid,RHPid,CFidautorizado,
                                                RHLTPfdesde,RHLTPfhasta,CFcentrocostoaut,RHMPestadoplaza,
                                                RHMPnegociado,RHLTPmonto,Mcodigo,BMfecha,BMUsucodigo )
                values( <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">,
                        null,null,null,null,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_RHPlazas.identity#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#" >,
                        <cfif isdefined("form.LTfecha") and len(trim(form.LTfecha))>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.LTfecha#">
                        <cfelse>
                            <cf_dbfunction name="now">
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechamax#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.CFid#">,
                        'A','T',0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMcodigo#">,
                        <cf_dbfunction name="now">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#"> )
            </cfquery>	
       	<cftransaction>			
        <cfreturn ABC_RHPlazas.identity>
   </cffunction>
</cfcomponent>