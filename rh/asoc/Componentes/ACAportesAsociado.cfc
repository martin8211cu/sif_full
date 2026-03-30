<cfcomponent>
    <cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>
	<cffunction name="Alta" access="public" returntype="numeric">
		<!--- Parámetros Recibidos --->
        <cfargument name="ACAid" type="numeric" required="yes">
		<cfargument name="ACATid" type="numeric" required="yes">
        <cfargument name="ACAAtipo" type="string" required="yes">
        <cfargument name="ACAAporcentaje" type="numeric" required="yes">
        <cfargument name="ACAAmonto" type="numeric" required="yes">
        <cfargument name="ACAAfechaInicio" type="string" required="yes">
        <cfargument name="Did" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        <!--- Variables Locales del Método --->
		<cfset var Lvar_Periodo 	= 0>
        <cfset var Lvar_Mes 		= 0>
        <cfset var Lvar_SocioAsoc 	= 0>
        <cfset var Lvar_Asociado 	= QueryNew("")>
        <cfset var Lvar_DEDEXISTS 	= FALSE>
        <cfset var Lvar_CAREXISTS 	= FALSE>
        <cfset var Lvar_Dmetodo		= 0>
        <cfset var Lvar_Dvalor 		= 0.00>
        <cfset var Lvar_DCvalorEmp 	= 0.00>
        <cfset var Lvar_DCvalorPat 	= 0.00>
        <cfset var Lvar_Fecha 		= CreateDate(1900,1,1)>
		<!--- Componentes Relacionados --->
        <cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
        <cfinvoke component="rh.asoc.Componentes.ACAsociados" 	method="init" returnvariable="Asociados">
        <cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
        <cfinvoke component="rh.asoc.Componentes.ACCargas" 		method="init" returnvariable="Cargas">
        <!--- Definiciones Iniciales --->
		<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
        <cfset Lvar_Mes 		= Parametros.Get("20",	"Mes")>
        <cfset Lvar_SocioAsoc 	= Parametros.Get("100",	"Socio de Negocios Asociaci&oacute;n")>
        <cfquery name="rsTipoAporte" datasource="#Session.dsn#">
        	select ACATid, DClinea, TDid, ACATcodigo, ACATdescripcion, ACATtasa, ACATtipo, ACATorigen
            from ACAportesTipo
            where ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACATid#">
        </cfquery>
        <cfset Lvar_Asociado 	= Asociados.Get(Arguments.ACAid)>
        <cfset Lvar_DEDEXISTS 	= Arguments.Did GT 0>
		<cfif len(trim(rsTipoAporte.DClinea)) GT 0><cfset Lvar_CAREXISTS 	= Cargas.vExiste(Lvar_Asociado.DEid, rsTipoAporte.DClinea)></cfif>
		<cfif Arguments.ACAAtipo EQ 'P'>
            <cfset Lvar_Dmetodo=0>
            <cfset Lvar_Dvalor = Arguments.ACAAporcentaje>
        <cfelse>
            <cfset Lvar_Dmetodo=1>
            <cfset Lvar_Dvalor = Arguments.ACAAmonto>
        </cfif>
		<cfif rsTipoAporte.ACATorigen EQ 'P'>
        	<cfset Lvar_DCvalorPat = Lvar_Dvalor>
        <cfelse>
        	<cfset Lvar_DCvalorEmp = Lvar_Dvalor>
        </cfif>
		<cfset Lvar_Fecha 		= CreateDate(Lvar_Periodo,Lvar_Mes,1)>
        <!--- Valida Fecha de Aporte Mayor a Fecha de Ingreso --->
        <cfif LsParseDateTime(Arguments.ACAAfechaInicio) LT Lvar_Asociado.ACAfechaIngreso>
        	<cfthrow message="Error en Componente ACAportesAsociado. M&eacute;todo Alta. La Fecha del Aporte debe ser mayor o igual a la fecha de Ingreso del Asociado. Proceso Cancelado!">
        </cfif>
        <cfif LsParseDateTime(Arguments.ACAAfechaInicio) LT Lvar_Fecha AND NOT Lvar_DEDEXISTS AND NOT Lvar_CAREXISTS>
        	<cfthrow message="Error en Componente ACAportesAsociado. M&eacute;todo Alta. La Fecha del Aporte debe ser mayor o igual al Periodo / Mes del M&oacute;dulo. Proceso Cancelado!">
        </cfif>
		<!--- Inicia el Proceso --->
        <cftransaction>
        	<!--- 1. CREA CUENTA DE APORTES --->
            <cfquery name="rsInsert" datasource="#Session.dsn#">
            	INSERT INTO ACAportesAsociado (ACAid, ACATid, ACAAtipo, ACAAporcentaje, ACAAmonto, 
                								DClinea,Did, ACAAfechaInicio, BMUsucodigo, BMfecha)
                VALUES(
                	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACATid#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ACAAtipo#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ACAAporcentaje#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ACAAmonto#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#" null="#Arguments.DClinea EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#" null="#Arguments.Did EQ 0#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.ACAAfechaInicio)#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                )
                <cf_dbidentity1>
            </cfquery>
            <cf_dbidentity2 name="rsInsert">
            <!--- 2. CREA LINEA DE SALDOS DESDE EL EL PERIODO/MES DE INGRESO EN LA ASOCIACION
			HASTA EL PERIODO MES DE PARAMETROS GENERALES DEL MODULO DE AHORRO Y CRÉDITO --->
            <cfquery name="rsSaldos" datasource="#session.dsn#">
                INSERT INTO ACAportesSaldos (ACAAid, ACASperiodo, ACASmes, ACAAsaldoInicial, ACAAaporteMes, 
                                            ACAAsaldoInicialInt, ACAAaporteMesInt, 
											DEid,Did,DClinea,ACAStipo,
											BMUsucodigo, BMfecha)
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">,
                    0.00,0.00,0.00,0.00,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Asociado.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Did#" null="#Arguments.Did EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#" null="#Arguments.DClinea EQ 0#">,
					'N',
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                )
                <cf_dbidentity1>
            </cfquery>
            <cf_dbidentity2 name="rsSaldos">
            <cfif Not Lvar_DEDEXISTS AND len(trim(rsTipoAporte.TDid)) GT 0 AND rsTipoAporte.TDid GT 0>
            	<cfinvoke component="ACDeducciones" method="Alta" returnvariable="ACDeduccionesDid"
		            deid="#Lvar_Asociado.DEid#" sncodigo="#Lvar_SocioAsoc#" tdid="#rsTipoAporte.TDid#"
        	        ddescripcion="#rsTipoAporte.ACATdescripcion#" dmetodo="#Lvar_Dmetodo#" dvalor="#Lvar_Dvalor#"
            	    dfecha="#Arguments.ACAAfechaInicio#" dreferencia="#Arguments.ACAid#">
                <cfquery name="rsUpdate" datasource="#Session.dsn#">
                    UPDATE ACAportesAsociado 
                        SET Did = #ACDeduccionesDid#
                    WHERE ACAAid = #rsInsert.identity#
                </cfquery>
				<cfquery name="rsUpdate" datasource="#Session.dsn#">
                    UPDATE ACAportesSaldos 
                        SET Did = #ACDeduccionesDid#
                    WHERE ACAAid = #rsInsert.identity#
                </cfquery>
            <cfelseif Not Lvar_CAREXISTS AND len(trim(rsTipoAporte.DClinea)) GT 0 AND rsTipoAporte.DClinea GT 0>
                <cfinvoke component="ACCargas" method="Alta"
				    deid="#Lvar_Asociado.DEid#" dclinea="#rsTipoAporte.DClinea#" cedesde="#Arguments.ACAAfechaInicio#" 
                    cevalorpat="#Lvar_DCvalorPat#" cevaloremp="#Lvar_DCvalorEmp#">
				<cfquery name="rsUpdate" datasource="#Session.dsn#">
                    UPDATE ACAportesAsociado 
                        SET DClinea = #rsTipoAporte.DClinea#
                    WHERE ACAAid = #rsInsert.identity#
                </cfquery>
			 <cfelseif Lvar_CAREXISTS>
			 	 <cfinvoke component="ACCargas" method="Cambio"
				    deid="#Lvar_Asociado.DEid#" dclinea="#rsTipoAporte.DClinea#" cedesde="#Arguments.ACAAfechaInicio#">
            </cfif>
        </cftransaction>
		<cfreturn rsInsert.Identity>
	</cffunction>
    
    <cffunction name="Cambio" access="public" returntype="numeric">
		<cfargument name="ACAAid" type="numeric" required="yes">
		<!--- Parámetros Recibidos --->
        <cfargument name="ACAid" type="numeric" required="yes">
		<cfargument name="ACATid" type="numeric" required="yes">
        <cfargument name="ACAAtipo" type="string" required="yes">
        <cfargument name="ACAAporcentaje" type="numeric" required="yes">
        <cfargument name="ACAAmonto" type="numeric" required="yes">
        <cfargument name="ACAAfechaInicio" type="string" required="yes">
        <cfargument name="Did" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        <!--- Variables Locales del Método --->
		<cfset var Lvar_Periodo 	= 0>
        <cfset var Lvar_Mes 		= 0>
        <cfset var Lvar_SocioAsoc 	= 0>
        <cfset var Lvar_Asociado 	= QueryNew("")>
        <cfset var Lvar_DEDEXISTS 	= FALSE>
        <cfset var Lvar_CAREXISTS 	= FALSE>
        <cfset var Lvar_DEDVNUEVO 	= FALSE>
        <cfset var Lvar_CARVNUEVO 	= FALSE>
        <cfset var Lvar_Dmetodo		= 0>
        <cfset var Lvar_Dvalor 		= 0.00>
        <cfset var Lvar_DCvalorEmp 	= 0.00>
        <cfset var Lvar_DCvalorPat 	= 0.00>
        <cfset var Lvar_Fecha 		= CreateDate(1900,1,1)>
        <!--- Componentes Relacionados --->
        <cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
        <cfinvoke component="rh.asoc.Componentes.ACAsociados" 	method="init" returnvariable="Asociados">
        <cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
        <cfinvoke component="rh.asoc.Componentes.ACCargas" 		method="init" returnvariable="Cargas">
        <!--- Definiciones Iniciales --->
		<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
        <cfset Lvar_Mes 		= Parametros.Get("20",	"Mes")>
        <cfset Lvar_SocioAsoc 	= Parametros.Get("100",	"Socio de Negocios Asociaci&oacute;n")>
		<cfquery name="rsTipoAporte" datasource="#Session.dsn#">
        	select ACATid, DClinea, TDid, ACATcodigo, ACATdescripcion, ACATtasa, ACATtipo, ACATorigen
            from ACAportesTipo
            where ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACATid#">
        </cfquery>
        <cfset Lvar_Asociado 	= Asociados.Get(Arguments.ACAid)>
        <cfset Lvar_DEDEXISTS 	= Arguments.Did GT 0>
        <cfset Lvar_CAREXISTS 	= Arguments.DClinea GT 0>
        <cfif Lvar_DEDEXISTS><cfset Lvar_DEDVNUEVO 	= Deducciones.vNuevo(Arguments.Did)></cfif>
        <cfif Lvar_CAREXISTS><cfset Lvar_CARVNUEVO 	= Cargas.vNuevo(Lvar_Asociado.DEid,Arguments.DClinea)></cfif>
        <cfif Arguments.ACAAtipo EQ 'P'>
            <cfset Lvar_Dmetodo=0>
            <cfset Lvar_Dvalor = Arguments.ACAAporcentaje>
        <cfelse>
            <cfset Lvar_Dmetodo=1>
            <cfset Lvar_Dvalor = Arguments.ACAAmonto>
        </cfif>
		<cfif rsTipoAporte.ACATorigen EQ 'P'>
        	<cfset Lvar_DCvalorPat = Lvar_Dvalor>
        <cfelse>
        	<cfset Lvar_DCvalorEmp = Lvar_Dvalor>
        </cfif>
        <cfset Lvar_Fecha 		= CreateDate(Lvar_Periodo,Lvar_Mes,1)>
        <!--- Valida Fecha de Aporte Mayor a Fecha de Ingreso --->
        <cfif LsParseDateTime(Arguments.ACAAfechaInicio) LT Lvar_Asociado.ACAfechaIngreso>
        	<cfthrow message="Error en Componente ACAportesAsociado. M&eacute;todo Alta. La Fecha del Aporte debe ser mayor o igual a la fecha de Ingreso del Asociado. Proceso Cancelado!">
        </cfif>
        <cfif LsParseDateTime(Arguments.ACAAfechaInicio) LT Lvar_Fecha AND (Lvar_DEDVNUEVO OR Lvar_CARVNUEVO)>
        	<cfthrow message="Error en Componente ACAportesAsociado. M&eacute;todo Alta. La Fecha del Aporte debe ser mayor o igual al Periodo / Mes del M&oacute;dulo. Proceso Cancelado!">
        </cfif>
        <!--- Inicia el Proceso --->
        <cftransaction>
        	<cfquery name="rsInsert" datasource="#Session.dsn#">
            	UPDATE ACAportesAsociado 
                SET ACAAtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ACAAtipo#">,
	                ACAAporcentaje = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ACAAporcentaje#">,
    	            ACAAmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ACAAmonto#">,
        	        ACAAfechaInicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.ACAAfechaInicio)#">
                WHERE ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAAid#">
            </cfquery>
            <cfif Lvar_DEDEXISTS>
            	<cfinvoke component="ACDeducciones" method="Cambio"
		            did="#Arguments.Did#"
                    dmetodo="#Lvar_Dmetodo#" 
                    dvalor="#Lvar_Dvalor#" 
                    dfecha="#Arguments.ACAAfechaInicio#">
            <cfelseif Lvar_CAREXISTS>
                <cfinvoke component="ACCargas" method="Cambio"
				    deid="#Lvar_Asociado.DEid#"
                    dclinea="#Arguments.DClinea#"
                    cedesde="#Arguments.ACAAfechaInicio#" 
                    cevalorpat="#Lvar_DCvalorPat#" 
                    cevaloremp="#Lvar_DCvalorEmp#">
            </cfif>
        </cftransaction>
		<cfreturn Arguments.ACAAid>
	</cffunction>
    
    <cffunction name="Baja" access="public">
    	<cfargument name="ACAAid" type="numeric" required="yes">
        <cfquery name="rsSaldos" datasource="#Session.dsn#">
        	select 1
            from ACAportesSaldos
            where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAAid#">
              and( ACAAsaldoInicial > 0.00 
              or ACAAaporteMes > 0.00
              or ACAAsaldoInicialInt > 0.00
              or ACAAaporteMesInt > 0.00)
        </cfquery>
        
		<cfif rsSaldos.recordcount GT 0>
        	<cfthrow message="Error en Componente ACAportesAsociado. M&eacute;todo Baja. El Aporte tiene movimientos, ya no puede ser eliminado. Proceso Cancelado!">
        </cfif>
         
        <cfquery name="rsData" datasource="#Session.dsn#">
        	select a.Did, b.DClinea, b.TDid, c.DEid
            from ACAportesAsociado a
            	inner join ACAportesTipo b
                on b.ACATid = a.ACATid
            	inner join ACAsociados c 
                on c.ACAid = a.ACAid
            where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAAid#">
        </cfquery>
        <cftransaction>
        <cfquery datasource="#Session.dsn#">
            DELETE from ACAportesSaldos
            WHERE ACAAid = #Arguments.ACAAid#
        </cfquery>
        <cfquery datasource="#Session.dsn#">
            DELETE from ACAportesAsociado
            WHERE ACAAid = #Arguments.ACAAid#
        </cfquery>
        <cfif len(trim(rsData.TDid)) GT 0 and rsData.recordcount and len(trim(rsData.Did)) GT 0 and rsData.Did GT 0>
            <cfinvoke component="ACDeducciones" method="Baja" did="#rsData.Did#">
        <cfelseif len(trim(rsData.DClinea)) GT 0  and rsData.recordcount and len(trim(rsData.DClinea)) GT 0 and rsData.DClinea GT 0>
            <cfinvoke component="ACCargas" method="Baja" deid="#rsData.DEid#" dclinea="#rsData.DClinea#">
        </cfif>
        </cftransaction>
	</cffunction>
	<!--- BUSCA SI EXISTE REGISTRADO UN APORTE DE UN TIPO EXPECÍFICO y ESTÉ ACTIVO--->
	<cffunction name="ExisteAporte" access="public" returntype="numeric">
		<cfargument name="ACid" type="numeric" required="yes">
    	<cfargument name="ACATid" type="numeric" required="yes">
		
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 
			from ACAportesAsociado
			where ACAid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
			  and ACATid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACATid#">
			  and ACAestado = 0
		</cfquery>
		<cfreturn rsExiste.RecordCount>
	</cffunction>
</cfcomponent>