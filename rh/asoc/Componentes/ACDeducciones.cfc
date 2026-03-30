<cfcomponent>
    <cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>

	<cffunction name="getDeduccionesEmpleado" access="public" returntype="query">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="TDid" type="string" required="yes">
		<cfargument name="Todas" type="boolean" required="no">
        <cfquery name="rsDeducciones" datasource="#session.DSN#">
        	select Did, DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, 
                Dmetodo, Dvalor, Dfechadoc, Dfechaini, Dfechafin, 
                Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, 
                Dcontrolsaldo, Dactivo
            from DeduccionesEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TDid#">
            <cfif (isdefined('Arguments.Todas') and not Arguments.Todas) or not isdefined('Arguments.Todas')>
            and Dactivo = 1
			</cfif>
        </cfquery>
        <cfreturn rsDeducciones>
    </cffunction>

	<cffunction name="getDeduccionesEmpleadoByDid" access="public" returntype="query">
    	<cfargument name="Did" type="string" required="yes">
		<cfargument name="Todas" type="boolean" required="no">
        <cfquery name="rsDeducciones" datasource="#session.DSN#">
        	select Did, DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, 
                Dmetodo, Dvalor, Dfechadoc, Dfechaini, Dfechafin, 
                Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, 
                Dcontrolsaldo, Dactivo
            from DeduccionesEmpleado
            where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
			<cfif (isdefined('Arguments.Todas') and not Arguments.Todas) or not isdefined('Arguments.Todas')>
            and Dactivo = 1
			</cfif>
        </cfquery>
        <cfreturn rsDeducciones>
    </cffunction>

	<cffunction name="vExiste" access="public" returntype="string">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="TDid" type="string" required="yes">
        <cfargument name="Dfecha" type="string" required="yes">
        <cfquery name="vinsertDed" datasource="#session.DSN#">
        	select 1 from DeduccionesEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TDid#">
            and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Dfecha)#">
            	between Dfechaini and Dfechafin
        </cfquery>
        <cfreturn vinsertDed.recordcount GT 0>
    </cffunction>
    
    <cffunction name="vNuevo" access="public" returntype="string">
    	<cfargument name="Did" type="string" required="yes">
        <cfquery name="vmovimientos" datasource="#session.DSN#">
        	select 1 from DeduccionesCalculo
            where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
        </cfquery>
        <cfreturn vmovimientos.recordcount eq 0>
    </cffunction>
    
    <cffunction name="Alta" access="public" returntype="string">
		<cfargument name="DEid" type="string" required="yes">
        <cfargument name="SNcodigo" type="string" required="yes">
        <cfargument name="TDid" type="string" required="yes">
        <cfargument name="Ddescripcion" type="string" required="yes">
        <cfargument name="Dmetodo" type="string" required="yes">
        <cfargument name="Dvalor" type="string" required="yes">	<!--- 0: porcentaje, 1: monto--->
        <cfargument name="Dfecha" type="string" required="yes">
        <cfargument name="Dreferencia" type="string" required="yes">
        <cfargument name="Dcontrolsaldo" type="numeric" required="no" default="0" >		
        <cfargument name="transaccion_abierta" type="boolean" required="no" default="false" >
        <cfargument name="Dsaldo" type="numeric" required="no" default="0" >		
        
        <cfquery name="rsinsertDed" datasource="#session.DSN#">
                INSERT INTO DeduccionesEmpleado( DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, 
                                            Dmetodo, Dvalor, Dfechadoc, Dfechaini, Dfechafin, 
                                            Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, 
                                            Dcontrolsaldo, Dactivo, Dreferencia, 
                                            Usucodigo, BMUsucodigo)
                                            
                VALUES( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TDid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Dmetodo#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Dvalor#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Dfecha)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Dfecha)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Dvalor#">,
						0.00,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Dsaldo#">,
						0.00,
						1,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Dcontrolsaldo#">,
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Dreferencia#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)										
				<cf_dbidentity1  verificar_transaccion="false">
		</cfquery>
        <cf_dbidentity2 name="rsinsertDed"  verificar_transaccion="false">
        
        <cfreturn rsinsertDed.identity>
	</cffunction>
    
    <cffunction name="Cambio" access="public" returntype="string">
		<cfargument name="Did" type="string" required="yes">
        <cfargument name="SNcodigo" type="string" required="no" default="">
        <cfargument name="Ddescripcion" type="string" required="no" default=""> 
        <cfargument name="Dmetodo" type="string" required="no" default="">
        <cfargument name="Dvalor" type="string" required="no" default="">
        <cfargument name="Dfecha" type="string" required="no" default="">
        <cfargument name="Dreferencia" type="string" required="no" default="">
        <cfargument name="Dfechafin" type="string" required="no" default="">

        <cfif not vNuevo(Arguments.Did)>
        	<cfthrow message="Error en Componente ACDeducciones. M&eacute;todo Cambio. La Deducci&oacute;n tiene movimientos, ya no puede ser modificada. Proceso Cancelado!">
        </cfif>

        <cfquery name="rsupdateDed" datasource="#session.DSN#">
                UPDATE DeduccionesEmpleado
                SET <cfif len(trim(Arguments.SNcodigo)) GT 0>SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">,</cfif>
                	<cfif len(trim(Arguments.Ddescripcion)) GT 0>Ddescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddescripcion#">,</cfif>
                    <cfif len(trim(Arguments.Dmetodo)) GT 0>Dmetodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Dmetodo#">, </cfif>
                    <cfif len(trim(Arguments.Dvalor)) GT 0>Dvalor=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Dvalor#">, </cfif>
                    <cfif len(trim(Arguments.Dfecha)) GT 0>Dfechadoc=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Dfecha)#">, </cfif>
                    <cfif len(trim(Arguments.Dfecha)) GT 0>Dfechaini=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Dfecha)#">, </cfif>
					<cfif len(trim(Arguments.Dfechafin)) GT 0>Dfechafin=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Dfechafin)#">, </cfif>					
					<cfif len(trim(Arguments.Dvalor)) GT 0>Dmonto=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Dvalor#">,</cfif>
                    <cfif len(trim(Arguments.Dreferencia)) GT 0>Dreferencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Dreferencia#">, </cfif>
                    BMUsucodigo = BMUsucodigo
                WHERE Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
		</cfquery>
		<cfreturn Arguments.Did>
	</cffunction>
    
    <cffunction name="Baja" access="public" returntype="string">
		<cfargument name="Did" type="string" required="yes">

        <cfif not vNuevo(Arguments.Did)>
        	<cfthrow message="Error en Componente ACDeducciones. M&eacute;todo Baja. La Deducci&oacute;n tiene movimientos, ya no puede ser eliminada. Proceso Cancelado!">
        </cfif>

        <cfquery name="rsupdateDed" datasource="#session.DSN#">
                DELETE from DeduccionesEmpleado
                WHERE Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
		</cfquery>
		<cfreturn Arguments.Did>
	</cffunction>
	
    <cffunction name="Inactivar" access="public" returntype="string">
		<cfargument name="Did" type="string" required="yes">
        <cfquery name="rsupdateDed" datasource="#session.DSN#">
        	update DeduccionesEmpleado
			set Dactivo = 0
            where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
		</cfquery>
		<cfreturn Arguments.Did>
	</cffunction>
	
	<!--- RESULTADO
		  Rebaja del saldo la cantidad especificada por monto
	--->
    <cffunction name="modificarSaldo" access="public">
		<cfargument name="Did" type="string" required="yes">
		<cfargument name="monto" type="numeric" required="yes">

        <cfquery name="rsupdateDed" datasource="#session.DSN#">
			update DeduccionesEmpleado
            set Dsaldo = Dsaldo - <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.monto#"> 
            where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
		</cfquery>
	</cffunction>
	
	<!--- 	RESULTADO 
			Cambia la fecha de finalizacion de la deduccion
	--->
    <cffunction name="cambiarFecha" access="public" returntype="string">
		<cfargument name="Did" type="string" required="yes">
        <cfargument name="Dfechafin" type="date" required="yes">
        <cfargument name="sumardias" type="numeric" required="no" default="0">
		
		<cfset fecha_final = dateadd('d', arguments.sumardias, LSParseDateTime(arguments.Dfechafin )) >

        <cfquery datasource="#session.DSN#">
			update DeduccionesEmpleado
            set Dfechafin = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_final#">
			where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#">
		</cfquery>
	</cffunction>
	
</cfcomponent>