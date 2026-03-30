
<cfcomponent>
    <cffunction name="FechaIngreso" access="public" returntype="date">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#Session.Ecodigo#">
        <cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
        <cfargument name="DEid" 		type="numeric" 	required="yes">
        
        <cfquery name="rsFechaIngreso" datasource="#Arguments.conexion#">
            select EVfantig
            from EVacacionesEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        <cfif isdefined('rsFechaIngreso') and rsFechaIngreso.RecordCount NEQ 0>
            <cfreturn rsFechaIngreso.EVfantig>	
        <cfelse>
            <cfreturn createdate('6100','01','01')>
        </cfif>
    </cffunction>

	<cffunction name="AddPreLiquidacion" access="public">
		<cfargument name="Ecodigo" 	type="numeric" 	required="no" default="#session.Ecodigo#">
        <cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">
        <cfargument name="Deid" 	type="numeric" 	required="yes">
        <cfargument name="RHTid" 	type="numeric" 	required="yes">
        <cfargument name="Fhasta" 	type="date"		required="yes">
       
        
        <cfinvoke component="rh.Componentes.RH_PreLiquidacion" method="FechaIngreso" returnvariable="FIngreso">
            <cfinvokeargument name="DEid" 	value="#Arguments.DEid#"/>
        </cfinvoke>
        
        <cfquery name="rsDatosLT" datasource="#Arguments.conexion#">
        	select *
            from LineaTiempo
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Deid#">
            and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fhasta)#"> between LTdesde and LThasta
        </cfquery>
        
        <cfif isdefined('rsDatosLT') and rsDatosLT.RecordCount EQ 0>
        	<cfthrow message="El empleado ya fue cesado..." >
            <cfabort>
        <cfelse>
        	<cfset lvarTcodigo = #rsDatosLT.Tcodigo#> 
        </cfif>
		
        <cfquery name="rsAddPreLiquidacion" datasource="#Arguments.conexion#">
        	insert into RHPreLiquidacionPersonal (Ecodigo,DEid,RHPLPfechaalta, RHPLPfingreso, RHPLPfsalida,RHTid,BMUsucodigo,RHPLPestado,Tcodigo) values
            	(<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                ,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Deid#">
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(FIngreso)#">
                ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fhasta)#">
                ,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RHTid#">
                ,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">
                ,0
                ,<cfqueryparam cfsqltype="cf_sql_char" 		value="#lvarTcodigo#">
                )
                <cf_dbidentity1 datasource="#Session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#Session.DSN#" name="rsAddPreLiquidacion">

        <cfinvoke component="rh.Componentes.RH_PreLiquidacion" method="AddPreLiquidacionConceptos">
            <cfinvokeargument name="RHTid" 	value="#Arguments.RHTid#"/>
            <cfinvokeargument name="Fdesde"	value="#FIngreso#"/>
            <cfinvokeargument name="Fhasta"	value="#Arguments.Fhasta#"/>
            <cfinvokeargument name="DEid"	value="#Arguments.DEid#"/>
            <cfinvokeargument name="RHPLPid"value="#rsAddPreLiquidacion.identity#"/>
        </cfinvoke>
        
		<cfreturn>
	</cffunction>
    
    
    <cffunction name="AddPreLiquidacionConceptos" access="public">
    	<cfargument name="Ecodigo" 	type="numeric" 	required="no" default="#session.Ecodigo#">
        <cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">
        <cfargument name="RHTid" 	type="numeric" 	required="yes">
        <cfargument name="Fdesde" 	type="date"		required="yes">
        <cfargument name="Fhasta" 	type="date"		required="yes">
        <cfargument name="DEid" 	type="numeric" 	required="yes">
        <cfargument name="RHPLPid" 	type="numeric" 	required="yes">
		
        <cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>        

    	<!--- Procesamiento de los Conceptos de Pago --->
        <cfquery name="rsConceptos" datasource="#Arguments.conexion#">
            select <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fdesde)#">  as Finicio
                   ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fhasta)#"> as Ffinal
                   ,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Deid#"> as DEid
                   ,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#"> as Ecodigo
                   ,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RHTid#"> as RHTid
                   ,c.CIid
                   ,c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
                   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
            from RHTipoAccion a, ConceptosTipoAccion b, CIncidentesD c
            where a.RHTid = b.RHTid
	            and b.CIid = c.CIid
    	        and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTid#">
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>

        <cfloop query="rsConceptos">	
        	<cfset FVigencia 	= LSDateFormat(rsConceptos.Finicio, 'DD/MM/YYYY')>
            <cfset FFin 		= LSDateFormat(rsConceptos.Ffinal, 'DD/MM/YYYY')>				
			

            <cfset current_formulas = rsConceptos.CIcalculo>
            <cfset presets_text = RH_Calculadora.get_presets(
					CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
					CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
					rsConceptos.CIcantidad,
					rsConceptos.CIrango,
					rsConceptos.CItipo,
					rsConceptos.DEid,
					0,	<!---RHJid--->
					rsConceptos.Ecodigo,
					0,	<!---RHTid--->
					0,	<!---RHAlinea--->
					rsConceptos.CIdia,
					rsConceptos.CImes,
					"",	<!---Tcodigo--->
					FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mas pesado--->
					'false',	<!---masivo--->
					'',	<!---tablaTemporal--->
					FindNoCase('DiasRealesCalculoNomina', current_formulas), <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
					0, 	<!---cantidad--->
					"", 	<!---origen--->
					rsConceptos.CIsprango,		<!---CIsprango--->
					rsConceptos.CIspcantidad, 	<!---CIspcantidad--->
					rsConceptos.CImescompleto, 	<!---CImescompleto--->
					0							<!---MontoIncidencia--->
					)>
										  
			<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
            <cfset calc_error = RH_Calculadora.getCalc_error()>
            <cfif Not IsDefined("values")>
                <cfif isdefined("presets_text")>
                    <cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
                <cfelse>
                    <cf_throw message="#calc_error#" >
                </cfif>
            </cfif>
            
            <br>Importe><cfdump var="#values.get('importe').toString()#"></br>
            <br>Resultado<cfdump var="#values.get('resultado').toString()#"></br>
            <br>Cantidad<cfdump var="#values.get('cantidad').toString()#"></br>
            
            <cfquery name="updConceptos" datasource="#Session.DSN#">
                insert into RHConceptosAccionPreLiq(RHPLPid, CIid, RHCAiPLmporte, RHCAPLres, RHCAPLcant, CIcalculo,BMUsucodigo,BMfecha)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.RHPLPid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#rsConceptos.CIid#">,
                    <cfqueryparam cfsqltype="cf_sql_money" 			value="#values.get('importe').toString()#">,
                    <cfqueryparam cfsqltype="cf_sql_money" 			value="#values.get('resultado').toString()#">,
                    <cfqueryparam cfsqltype="cf_sql_float" 			value="#values.get('cantidad').toString()#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#presets_text & ';' & current_formulas#">
                    ,<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Session.Usucodigo#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#now()#">
                )
            </cfquery>
        </cfloop>

		<!--- Inserción de Ingresos por Liquidación en forma automática --->
        <cfquery name="rsInsertLiqIngresosPrev" datasource="#Arguments.conexion#">
            insert into RHLiqIngresosPrev (RHPLPid, DEid, CIid, Ecodigo, RHLPdescripcion, importe, fechaalta, RHLPautomatico, BMUsucodigo) 
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPLPid#">,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
                   a.CIid,
                   <cfqueryparam  cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                   b.CIdescripcion,
                   a.RHCAPLres, 
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                   1,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
            from RHConceptosAccionPreLiq a, CIncidentes b
            where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPLPid#">
            and a.CIid = b.CIid
            and b.CItipo in (2,3) <!--- Solo sugiere los conceptos de tipo importe y los de tipo cálculo --->
        </cfquery>
        
        <!--- Inserción de Deducciones por Liquidación en forma automática --->
        <cfquery name="rsInsertLiqDeduccionPrev" datasource="#Arguments.conexion#">
            insert into RHLiqDeduccionPrev (RHPLPid, DEid, Did, RHLDdescripcion, RHLDreferencia, SNcodigo, importe, fechaalta, RHLDautomatico, BMUsucodigo)
            select a.RHPLPid, 
                   a.DEid, 
                   b.Did,
                   b.Ddescripcion, 
                   b.Dreferencia,
                   b.SNcodigo, 
                   b.Dsaldo,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                   1,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
            from RHPreLiquidacionPersonal a, DeduccionesEmpleado b
            where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPLPid#">
            and a.Ecodigo = b.Ecodigo
            and a.DEid = b.DEid
            and b.Dsaldo > 0
            and b.Dcontrolsaldo = 1
        </cfquery>
        <cfreturn>
    </cffunction>
    
    <cffunction name="DelPreLiquidacion" access="public">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
        <cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
        <cfargument name="RHPLPids" 	type="numeric" 	required="yes">
        
        <cfquery name="rsRHConceptosAccionPreLiq" datasource="#conexion#">
            delete
            from RHConceptosAccionPreLiq
                where RHPLPid in (#Arguments.RHPLPids#)
        </cfquery>
        
         <cfquery name="rsRHLiqIngresosPrev" datasource="#conexion#">
            delete
            from RHLiqIngresosPrev
                where RHPLPid in (#Arguments.RHPLPids#)
        </cfquery>
        
        <cfquery name="rsRHLiqFLPrev" datasource="#conexion#">
            delete
            from RHLiqFLPrev
                where RHPLPid in (#Arguments.RHPLPids#)
        </cfquery>
        
        <cfquery name="rsRHLiqCargasPrev" datasource="#conexion#">
            delete
            from RHLiqCargasPrev
                where RHPLPid in (#Arguments.RHPLPids#)
        </cfquery>
        
        <cfquery name="rsRHLiqDeduccionPrev" datasource="#conexion#">
            delete
            from RHLiqDeduccionPrev
                where RHPLPid in (#Arguments.RHPLPids#)
        </cfquery>
        
        <cfquery name="rsRHPreLiquidacionPersonal" datasource="#conexion#">
            delete
            from RHPreLiquidacionPersonal
                where RHPLPid in (#Arguments.RHPLPids#)
        </cfquery>
        
        <cfreturn>
    </cffunction>
    
</cfcomponent>

