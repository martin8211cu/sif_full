<cfcomponent>
	
	<!--- Calcula el excento y grabado de un concepto--->
	<cffunction name="fnCalculaEG" access="public" >
		<cfargument name="RHLPPid" 	type="numeric" required="true">
		<cfargument name="Ecodigo" 	type="numeric" >	
		<cfargument name="Conexion" type="string">	
		

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfset Exento = 0>
		<cfset rsLiqIngresos = getLiqIngresos(Arguments.RHLPPid,Arguments.Ecodigo,Arguments.Conexion)>
		<cfset rsConcepto = getConcepto(rsLiqIngresos.CIid,Arguments.Ecodigo,Arguments.Conexion)>
       
		<cfif rsConcepto.CIlimitaconcepto eq 1>
			<cfif rsConcepto.CItipometodo eq 4>
				<cfset rsSMGA  = fnGetSalarioMinimo(true,Arguments.Ecodigo,Arguments.Conexion)><!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
				<cfset lvarMontoLimite = rsConcepto.CImontolimite * rsSMGA>
			<cfelseif rsConcepto.CItipometodo eq 2>
				<cfset lvarMontoLimite = rsConcepto.CImontolimite>
			<cfelseif rsConcepto.CItipometodo eq 5>
				<cfset lvarMontoLimite = rsConcepto.CImontolimite>                
			</cfif>
		
			<cfif lvarMontoLimite gte rsLiqIngresos.importe>
				<cfset Exento = rsLiqIngresos.importe>
			<cfelse>
				<cfset Exento = lvarMontoLimite>
			</cfif>
		</cfif>
		<cfquery name="rsLiqIng" datasource="#Arguments.Conexion#">
			update RHLiqIngresosPrev set
				RHLIexento = <cf_dbfunction name="to_float" args="#Exento#" dec="4">,
				RHLIgrabado = <cf_dbfunction name="to_float" args="importe - #Exento#" dec="4">
			where RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLPPid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>	
	</cffunction>
	
	<!---  --->
	<cffunction name="getLiqIngresos" returntype="query">
		<cfargument name="RHLPPid" 		 type="numeric" required="true">
		<cfargument name="Ecodigo" 		 type="numeric">	
		<cfargument name="Conexion" 	 type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsLiqIng" datasource="#Arguments.Conexion#">
			select RHLPPid, RHPLPid, DEid, CIid, Ecodigo, RHLPdescripcion, importe, fechaalta, RHLPautomatico, Mcodigo, tipocambio,
			  Montoori, BMUsucodigo, ts_rversion, cesantia, motivoliq, RHLIexento, RHLIgrabado, RHLIFiniquito
			from RHLiqIngresosPrev
			where RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLPPid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>		
		<cfreturn #rsLiqIng#>
	</cffunction>
	
	<!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
	<cffunction name="getConcepto" returntype="query">
		<cfargument name="CIid" 	type="numeric" required="true">
		<cfargument name="Ecodigo" 	type="numeric" >	
		<cfargument name="Conexion" type="string">	

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsConcepto" datasource="#Arguments.Conexion#">
			select CItipo, CIlimitaconcepto, CImontolimite, CItipometodo
			from CIncidentes cie
			where cie.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
			  and cie.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>		
		<cfreturn #rsConcepto#>
	</cffunction>
	
	<!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
	<cffunction name="fnGetDato" access="private" returntype="query">
		<cfargument name="Pcodigo" 	type="numeric" required="true">
		<cfargument name="Ecodigo" 	type="numeric" >	
		<cfargument name="Conexion" type="string">	

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsParam" datasource="#Arguments.Conexion#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">  
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfreturn #rsParam#>
	</cffunction>
	
	<!--- Indica si se ha modificado el excento o grabado de un concepto--->
	<cffunction name="fnIndicaModEG" access="public" returntype="boolean">
		<cfargument name="RHLPPid" 	type="numeric" required="true">
		<cfargument name="Ecodigo" 	type="numeric" >	
		<cfargument name="Conexion" type="string">	
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfset rsLiqIngresos = getLiqIngresos(Arguments.RHLPPid,Arguments.Ecodigo,Arguments.Conexion)>
		<cfset rsConcepto = getConcepto(rsLiqIngresos.CIid,Arguments.Ecodigo,Arguments.Conexion)>
		
		<cfif rsConcepto.CIlimitaconcepto eq 1>
			<cfif rsConcepto.CItipometodo eq 4>
				<cfset SMGA  = fnGetSalarioMinimo(true,Arguments.Ecodigo,Arguments.Conexion)><!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
				<cfset lvarMontoLimite = rsConcepto.CImontolimite * SMGA>
			<cfelseif rsConcepto.CItipometodo eq 2>
				<cfset lvarMontoLimite = rsConcepto.CImontolimite>
            <cfelseif rsConcepto.CItipometodo eq 5>
				<cfset lvarMontoLimite = rsConcepto.CImontolimite>    
			</cfif>
			<cfset Exento = 0>
            
           
            
            <!---<cfif not isdefined('lvarMontoLimite')>
            	<cf_dump var="#rsConcepto#">
            </cfif>--->
			<cfif lvarMontoLimite gte rsLiqIngresos.importe>
				<cfset Exento = rsLiqIngresos.importe>
			<cfelse>
				<cfset Exento = lvarMontoLimite>
			</cfif>
			<cfif NumberFormat(rsLiqIngresos.RHLIexento,'.9999') neq NumberFormat(Exento,'.9999') or NumberFormat(rsLiqIngresos.RHLIgrabado,'.9999') neq NumberFormat(rsLiqIngresos.importe - Exento,'.9999')>
				<cfreturn true>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<!--- Calcula y devuelve el ISPT en base al monto ingresado--->
	<cffunction name="fnCalculaISPT" access="public" returntype="numeric">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="IRcodigo" 			type="string">
        <cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">
        
        
		
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        

		<cfset IRcodigoN1 = #Arguments.IRcodigo#> <!--- Impuesto Renta --->

		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaImpuestoMarginal" returnvariable="ImpMarginal">
			<cfinvokeargument name="Monto" 			value="#Arguments.Monto#">
			<cfinvokeargument name="Fecha" 			value="#Arguments.Fecha#">
			<cfinvokeargument name="IRcodigo" 		value="#IRcodigoN1#">
			<cfinvokeargument name="SumarCuotaFija" value="true">
			<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">
		</cfinvoke>
	
		<!---Para saber si tenemos una tabla hija esto es para el calculo de renta en mexico--->
		<cfquery name="rsIRcodigoN2" datasource="#Session.DSN#">
			select IRcodigo
				from ImpuestoRenta 
				where IRcodigoPadre = '#IRcodigoN1#'
		</cfquery>
		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaSubsidio" returnvariable="Subsidio">
			<cfinvokeargument name="Monto" 		value="#Arguments.Monto#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
        <!---ljimenez se cambia el resultado de revolucion para cuando el impuesto marginal - el subsidio es menor a cero se cobra solo la renta marginal--->
        <cfif (ImpMarginal - Subsidio) LT 0>
        	<cfreturn (ImpMarginal)>	
        <cfelse>
	        <cfreturn (ImpMarginal - Subsidio)>	
        </cfif>
		<!---<cfreturn (ImpMarginal - Subsidio)>	--->
	</cffunction>
	
	<!--- Obtiene el monto exento y grabable de los conceptos segun el tipo --->
	<cffunction name="fnGetMontoEG" access="public" returntype="query">
		<cfargument name="RHPLPid" 			type="numeric" 	required="yes">
		<cfargument name="Tipo" 			type="string" default="F">
		<cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">
		
		<cfif not ListFind('F,L',Arguments.Tipo)>
			<cfthrow message="Tipo suministrado no válido, valores permitidos F o L.">
		</cfif>
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif fnEsPrimeraVez(Arguments.RHPLPid,Arguments.Conexion)>
			<cfquery name="rsMontos" datasource="#Arguments.Conexion#">
				select coalesce(sum(coalesce(RHLIgrabado,0)),0) as Grabado, coalesce(sum(coalesce(RHLIexento,0)),0) as Exento
				from RHLiqIngresosPrev a
					inner join CIncidentes b
						on b.CIid = a.CIid
				where RHPLPid = #Arguments.RHPLPid#
					and CIlimitaconcepto = <cfif Arguments.Tipo eq 'F'> 1 <cfelseif Arguments.Tipo eq 'L'> 0 </cfif>
			</cfquery>
		<cfelse>
			<cfquery name="rsMontos" datasource="#Arguments.Conexion#">
				select	coalesce(sum(coalesce(RHLIgrabado,0)),0) as Grabado, coalesce(sum(coalesce(RHLIexento,0)),0) as Exento
				from RHLiqIngresosPrev a
					inner join CIncidentes b
						on b.CIid = a.CIid
				where RHPLPid = #Arguments.RHPLPid#
					and RHLIFiniquito = <cfif Arguments.Tipo eq 'F'> 1 <cfelseif Arguments.Tipo eq 'L'> 0 </cfif>
			</cfquery>
		</cfif>
		<cfreturn rsMontos>	
	</cffunction>
	
	<!--- Obtiene el monto exento y grabable de los conceptos de finiquito --->
	<cffunction name="fnEsPrimeraVez" access="public" returntype="boolean">
		<cfargument name="DLlinea" 			type="numeric" 	required="yes">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsPrimeraVez" datasource="#Arguments.Conexion#">
			select count(RHLIFiniquito) as cantidad
			from RHLiqIngresos
			where DLlinea = #Arguments.DLlinea#
		</cfquery>
		
		<cfreturn rsPrimeraVez.cantidad eq 0>
	</cffunction>
	
	<!--- Obtiene el monto exento y grabable de los conceptos de finiquito --->
	<cffunction name="fnEsFiniquito" access="public" returntype="boolean">
		<cfargument name="RHLPid" 			type="numeric" 	required="yes">
		<cfargument name="Conexion" 		type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsEsFiniquito" datasource="#Arguments.Conexion#">
			select coalesce(RHLIFiniquito,0) as RHLIFiniquito
			from RHLiqIngresos
			where RHLPid = #Arguments.RHLPid#
		</cfquery>
		<cfif len(trim(rsEsFiniquito.RHLIFiniquito))>
			<cfreturn rsEsFiniquito.RHLIFiniquito eq 1>
		<cfelse>
			<cfquery name="rsConLimite" datasource="#Arguments.Conexion#">
				select CIlimitaconcepto
				from RHLiqIngresos a
					inner join CIncidentes b
						on b.CIid = a.CIid
				where RHLPid = #Arguments.RHLPid#
					and CIlimitaconcepto = 1
			</cfquery>
			<cfreturn rsConLimite.CIlimitaconcepto eq 1>
		</cfif>
	</cffunction>
	
	<!--- Obtiene el monto exento y grabable de los conceptos de finiquito --->
	<cffunction name="fnCalculaInfonavit" access="public" returntype="numeric">
		<cfargument name="DEid" 			type="numeric" 	required="yes">
		<cfargument name="Fecha" 			type="date">
		<cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">
		
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfset TDidInfonavit = fnGetDato(2110,Arguments.Ecodigo)>
		<cfquery name="rsFuente" datasource="#Arguments.Conexion#">
			select a.TDid, c.Dvalor, b.FDcfm, b.FDformula
			from TDeduccion a
				inner join FDeduccion b
					on b.TDid = a.TDid
				inner join DeduccionesEmpleado c
					on c.TDid = a.TDid and c.DEid = #Arguments.DEid#
			where a.Ecodigo = #Arguments.Ecodigo#
			and a.TDid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#TDidInfonavit.Pvalor#" list="yes" null="#len(trim(TDidInfonavit.Pvalor)) eq 0#">)
			and c.Dactivo = 1
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#"> between c.Dfechaini and c.Dfechafin
			and ((c.Dcontrolsaldo = 1 and c.Dsaldo > 0) or c.Dcontrolsaldo = 0)
		</cfquery>
		<cfset EsLiquidacionMX = true>
		<cfset DeduccionValor = rsFuente.Dvalor>
		<cfset Infonavit = 0>
		<cfset Fecha = Arguments.Fecha>
		<cfif len(trim(rsFuente.FDcfm)) gt 0>
			<cfinclude template="#rsFuente.FDcfm#">
		</cfif>
		<cfreturn Infonavit>
	</cffunction>
	
	<!--- Obtiene sueldo mensual en el momento del cese --->
	<cffunction name="fnGetSalarioMensual" access="public" returntype="numeric">
		<cfargument name="DEid" 			type="numeric" 	required="yes">
		<cfargument name="Fecha" 			type="date">
		<cfargument name="Conexion" 		type="string">
		
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<!--- ljimenez se cambia para que tome solo el salario base del empleado y no la suma de todos los componentes salariales que guarda LTsalario--->
                
       <cfset lvarfecha = dateadd('d', -1, #Arguments.Fecha#)>
        
        
        <cfquery name="rsSalarioMensual" datasource="#Arguments.Conexion#">
            select a.DLTmonto as Salario
                from DLineaTiempo a
                    inner join LineaTiempo b
                        on a.LTid =  b.LTid
                            and DEid = #Arguments.DEid#
                            and <cfqueryparam cfsqltype="cf_sql_date" value="#lvarfecha#"> between b.LTdesde and b.LThasta 
                    inner join ComponentesSalariales c
                        on a.CSid = c.CSid
                        and  CSsalariobase = 1
		</cfquery>
        
        
		<cfif len(trim(rsSalarioMensual.Salario)) gt 0>
			<cfreturn rsSalarioMensual.Salario>
		</cfif>
		<cfreturn 0>
	</cffunction>
	
	<!--- Obtiene Salario minimo general zona A (SMGA) (mexico) --->
	<cffunction name="fnGetSalarioMinimo" access="public" returntype="numeric">
		<cfargument name="Validar" 			type="boolean" default="true">
		<cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfset rsSMGA  = fnGetDato(2024,Arguments.Ecodigo,Arguments.Conexion)><!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
		<cfif Arguments.Validar and (rsSMGA.recordcount eq 0 or len(trim(rsSMGA.Pvalor)) eq 0)>
			<cfthrow message="No se ha definido el parametro 2024, MEX - Salario minimo general zona A (SMGA) (mexico). Proceso Cancelado!!!">
		</cfif>
		<cfif not Arguments.Validar and (rsSMGA.recordcount eq 0 or len(trim(rsSMGA.Pvalor)) eq 0) >
			<cfreturn 0>
		</cfif>
		<cfreturn rsSMGA.Pvalor>
	</cffunction>
	
	<!--- Llamado a la calculadora --->
	<cffunction name="fnEjecutarCalc" access="public" returntype="struct">
		<cfargument name="DEid" 				type="numeric" 	required="yes">
		<cfargument name="DLlinea" 				type="numeric" 	required="yes">
		<cfargument name="RHDVDid" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric">
		<cfargument name="Conexion" 			type="string">
        
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfset Arguments.Fecha = LSDateFormat(Arguments.Fecha, 'DD/MM/YYYY')>
		<cfset Arguments.Fecha = CreateDate(ListGetAt(Arguments.Fecha,3,'/'), ListGetAt(Arguments.Fecha,2,'/'), ListGetAt(Arguments.Fecha,1,'/'))>
		<cfset Arguments.Fecha = DateAdd("d", -1, Arguments.Fecha )>
		
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>	
		
		<cfquery name="rsConcepto" datasource="#Arguments.Conexion#">
			select RHDVDid, RHFVDcantidad, coalesce(RHFVDspcantidad,0) as RHFVDspcantidad, RHFVDtipo, RHFVDcalculo, RHFVDdia,
				RHFVDmes, coalesce(RHFVDmescompleto,0) as RHFVDmescompleto, RHFVDrango, RHFVDsprango
			from RHFVariablesDinamicas
			where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
		</cfquery>
		<cfif rsConcepto.recordcount eq 0>
        	<cfquery name="rsVariable" datasource="#Arguments.Conexion#">
				select RHDVDdescripcion, RHEVDdescripcion
                from RHDVariablesDinamicas dvd
                	inner join RHEVariablesDinamicas evd 
                		on evd.RHEVDid = dvd.RHEVDid
                where dvd.RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDVDid#">
            </cfquery>
        	<cfthrow message="La variable dinamica '#rsVariable.RHDVDdescripcion#' del encabezado '#rsVariable.RHEVDdescripcion#' no ha sido formulada.">	
        </cfif>
		
        <cfquery name="rsAcciones" datasource="#Arguments.Conexion#">
			select RHTid, RHJid
            from LineaTiempo
            where DEid = #Arguments.DEid#
            and #Arguments.Fecha# between LTdesde and LThasta 
		</cfquery>
        
		<cfset current_formulas = rsConcepto.RHFVDcalculo>
		<cfset presets_text = RH_Calculadora.get_presets(Arguments.Fecha,
									   Arguments.Fecha,
									   rsConcepto.RHFVDcantidad,
									   rsConcepto.RHFVDrango,
									   rsConcepto.RHFVDtipo,
									   Arguments.DEid,
									   rsAcciones.RHJid,
									   Arguments.Ecodigo,
									   rsAcciones.RHTid,
									   Arguments.DLlinea,
									   rsConcepto.RHFVDdia,
									   rsConcepto.RHFVDmes,
									   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
									   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
									   'false',
									   '',
									   FindNoCase('DiasRealesCalculoNomina', current_formulas), <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
									   0,
									   'DLaboralesEmpleado',
									   rsConcepto.RHFVDsprango,
									   rsConcepto.RHFVDspcantidad,
									   rsConcepto.RHFVDmescompleto)>
		<cfset values = RH_Calculadora.calculate ( presets_text & ";" & current_formulas )>
        <cfset calc_error = RH_Calculadora.getCalc_error()>
		<cfif Not IsDefined("values")>
			<cfif isdefined("presets_text")>
				<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
			<cfelse>
				<cf_throw message="#calc_error#" >
			</cfif>
		</cfif>
		<cfset structCalc = StructNew()>
		<cfset structCalc.Resultado = values.get('resultado').toString()>
		<cfset structCalc.Operacion = current_formulas>
		<cfreturn structCalc>
	</cffunction>
	
	<!--- Ejecta Calculo Loco --->
	<cffunction name="fnEjecutarCalculoLoco" access="public" returntype="struct">
		<cfargument name="DEid" 			type="numeric" 	required="yes">
		<cfargument name="RHPLPid" 			type="numeric" 	required="yes">
		<cfargument name="Fecha" 			type="date" 	required="yes">
		<cfargument name="SalarioMinimo" 	type="numeric">
		<cfargument name="Ecodigo" 			type="numeric">
		<cfargument name="Conexion" 		type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.SalarioMinimo')>
			<cfset Arguments.SalarioMinimo = fnGetDato(2024,Arguments.Ecodigo,Arguments.Conexion).Pvalor><!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
		</cfif>
		<cfif len(trim(Arguments.SalarioMinimo)) eq 0>
			<cfthrow message="No se ha definido el parametro 2024, MEX - Salario minimo general zona A (SMGA) (mexico). Proceso Cancelado!!!">
		</cfif>
		
		<cfset rsNivelesCL = getConfigvariablesDinamicas(2,Arguments.Ecodigo,Arguments.Conexion)>
		
		<cfset structRNiveles = StructNew()>
		<cfset structRNiveles.ResultadoNivel   = StructNew()>
		<cfset structRNiveles.OperacionNivel   = StructNew()>
		<cfset structRNiveles.Nivel = StructNew()>
		<cfset resultado = 0>
		<cfloop query="rsNivelesCL">
			<cfswitch expression="#rsNivelesCL.RHDVDtipo#">
				<cfcase value="1">
					<cfset rCalculo = fnEjecutarCalc(Arguments.DEid,Arguments.RHPLPid,rsNivelesCL.RHDVDid,Arguments.Fecha,Arguments.Ecodigo,Arguments.Conexion)>
					<cfset resultado = rCalculo.Resultado>
					<cfset StructInsert(structRNiveles.OperacionNivel,"#rsNivelesCL.RHDVDid#",'#rCalculo.Resultado#')>
				</cfcase>
				<cfcase value="2">
					<cfswitch expression="#rsNivelesCL.RHDVDoperacion#">
						<cfcase value="+">
							<cfset resultado = StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoA) + StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoB)>
							<cfset operacion = "+">
						</cfcase>
						<cfcase value="-">
							<cfset resultado = StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoA) - StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoB)>
							<cfset operacion = "-">
						</cfcase>
						<cfcase value="*">
							<cfset resultado = StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoA) * StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoB)>
							<cfset operacion = "*">
						</cfcase>
						<cfcase value="/">
							<cfset resultado = StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoA) / StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoB)>
							<cfset operacion = "/">
						</cfcase>
					</cfswitch>
					<cfset StructInsert(structRNiveles.OperacionNivel, "#rsNivelesCL.RHDVDid#", '#fnFormatMoney(StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoA),2)# #operacion# #fnFormatMoney(StructFind(structRNiveles.ResultadoNivel,rsNivelesCL.RHDVDconceptoB),2)#')>
				</cfcase>
				<cfdefaultcase><!---3--->
					<cfset resultado = rsNivelesCL.RHDVDconstante>
					<cfset StructInsert(structRNiveles.OperacionNivel, "#rsNivelesCL.RHDVDid#",' CONST')>
				</cfdefaultcase>
			</cfswitch>
			<cfset StructInsert(structRNiveles.ResultadoNivel, "#rsNivelesCL.RHDVDid#", resultado)>
		</cfloop>
		<!--- Ultimo nivel de la operacion es el resultado del calculo--->
		<cfset structRNiveles.Resultado = resultado>
		<cfreturn structRNiveles>
	</cffunction>
	
	<!--- Obtiene todas las lineas --->
	<cffunction name="getLiqIngresosPorDLlinea" returntype="query">
		<cfargument name="RHPLPid" 		type="numeric" required="yes">
		<cfargument name="RHLIFiniquito" type="numeric">
		<cfargument name="Ecodigo" 		 type="numeric">	
		<cfargument name="Conexion" 	 type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsLiqIng" datasource="#Arguments.Conexion#">
			select RHLPPid, RHPLPid, DEid, CIid, Ecodigo, RHLPdescripcion, importe, fechaalta, RHLPautomatico, Mcodigo, tipocambio,
			  Montoori, BMUsucodigo, ts_rversion, cesantia, motivoliq, coalesce(RHLIexento,0) as RHLIexento, coalesce(RHLIgrabado,0) as RHLIgrabado, RHLIFiniquito
			from RHLiqIngresosPrev
			where RHPLPid = #Arguments.RHPLPid#
			  and Ecodigo = #Arguments.Ecodigo#
			<cfif Isdefined('Arguments.RHLIFiniquito') and Arguments.RHLIFiniquito neq -1>
				and RHLIFiniquito = #Arguments.RHLIFiniquito#
			</cfif>
		</cfquery>		
		<cfreturn #rsLiqIng#>
	</cffunction>
	
	<!--- Obtiene la configuracion de las variables dinamicas  --->
	<cffunction name="getConfigvariablesDinamicas" returntype="query" access="public">
		<cfargument name="RHEVDtipo" 	 type="numeric" required="yes">	
		<cfargument name="Ecodigo" 		 type="numeric">	
		<cfargument name="Conexion" 	 type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsNivelesCL" datasource="#Arguments.Conexion#">
			select RHDVDid, RHDVDconceptoA, RHDVDconceptoB, RHDVDoperacion, RHDVDconstante, RHDVDtipo, RHDVDnivel, RHDVDdescripcion 
			from RHEVariablesDinamicas evd
				inner join RHDVariablesDinamicas dvd
					on dvd.RHEVDid = evd.RHEVDid
			where evd.RHEVDtipo = #Arguments.RHEVDtipo# and evd.Ecodigo = #Arguments.Ecodigo#
			order by RHDVDnivel
		</cfquery>		
		<cfreturn rsNivelesCL>
	</cffunction>
	
	<!--- Verifica si existe el proceso de liquidacion-finiquito (Proceso para Mexico) --->
	<cffunction name="fnExisteLF" access="public" returntype="boolean">
		<cfargument name="RHPLPid" 	 type="numeric" required="yes">	
		<cfargument name="DEid" 	 type="numeric" required="yes">	
		<cfargument name="Conexion"  type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rsExiste" datasource="#Arguments.Conexion#">
			select RHLFLid
			from RHLiqFLPrev
			where RHPLPid = #Arguments.RHPLPid# and DEid = #Arguments.DEid#
		</cfquery>	
		<cfif len(trim('#rsExiste.RHLFLid#')) gt 0>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<!--- Cambia el proceso de liquidacion-finiquito (Proceso para Mexico) --->
	<cffunction name="fnCambioLF" access="public">
		<cfargument name="RHLFLid" 	 type="numeric">	
		<cfargument name="RHPLPid" 	 type="numeric">	
		<cfargument name="DEid" 	 type="numeric">
		<cfargument name="RHLFLtGrabadoF" 	 	type="numeric" default="0">
		<cfargument name="RHLFLtExentoF" 	 	type="numeric" default="0">
		<cfargument name="RHLFLisptF" 	 		type="numeric" default="0">
		<cfargument name="RHLFLinfonavit" 	 	type="numeric" default="0">
		<cfargument name="RHLFLtotalL" 	 		type="numeric" default="0">
		<cfargument name="RHLFLsalarioMensual" 	type="numeric" default="0">
		<cfargument name="RHLFLisptSalario" 	type="numeric" default="0">
		<cfargument name="RHLFLisptL" 	 		type="numeric" default="0">
		<cfargument name="RHLFLresultado" 	 	type="numeric" default="0">
		<cfargument name="Ecodigo"   type="numeric">
		<cfargument name="Usucodigo" type="numeric">
		<cfargument name="Conexion"  type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
        
        
		<cfif not isdefined('Arguments.RHLFLid') and ( not isdefined('Arguments.RHPLPid') or not isdefined('Arguments.DEid'))>
			<cfthrow message="Debe definir un campo, RHLFLid ó RHPLPid y DEid">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update RHLiqFLPrev set 
				RHLFLtGrabadoF 		= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLtGrabadoF#">,
				RHLFLtExentoF 		= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLtExentoF#">,
				RHLFLisptF 			= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLisptF#">,
				RHLFLinfonavit 		= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLinfonavit#">,
				RHLFLtotalL 		= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLtotalL#">,
				RHLFLsalarioMensual = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLsalarioMensual#">,
				RHLFLisptSalario 	= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLisptSalario#">,
				RHLFLisptL 			= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLisptL#">,
				RHLFLresultado 		= <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLresultado#">,
				Ecodigo  			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				BMUsucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where 
			<cfif isdefined('Arguments.RHLFLid')>
				RHLFLid = #Arguments.RHLFLid#
			<cfelse>
				RHPLPid = #Arguments.RHPLPid# and DEid = #Arguments.DEid#
			</cfif>
		</cfquery>
	</cffunction>
	
	<!--- Inserta el proceso de liquidacion-finiquito (Proceso para Mexico) --->
	<cffunction name="fnAltaLF" access="public" returntype="numeric">
		<cfargument name="RHLFLid" 	 type="numeric">	
		<cfargument name="RHPLPid" 	 type="numeric">	
		<cfargument name="DEid" 	 type="numeric">
		<cfargument name="RHLFLtGrabadoF" 	 	type="numeric" default="0">
		<cfargument name="RHLFLtExentoF" 	 	type="numeric" default="0">
		<cfargument name="RHLFLisptF" 	 		type="numeric" default="0">
		<cfargument name="RHLFLinfonavit" 	 	type="numeric" default="0">
		<cfargument name="RHLFLtotalL" 	 		type="numeric" default="0">
		<cfargument name="RHLFLsalarioMensual" 	type="numeric" default="0">
		<cfargument name="RHLFLisptSalario" 	type="numeric" default="0">
		<cfargument name="RHLFLisptL" 	 		type="numeric" default="0">
		<cfargument name="RHLFLresultado" 	 	type="numeric" default="0">
		<cfargument name="Ecodigo"   type="numeric">
		<cfargument name="Usucodigo" type="numeric">
		<cfargument name="Conexion"  type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = "#session.Usucodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
        
		<cfif not isdefined('Arguments.RHLFLid') and ( not isdefined('Arguments.RHPLPid') or not isdefined('Arguments.DEid'))>
			<cfthrow message="Debe definir un campo, RHLFLid ó RHPLPid y DEid">
		</cfif>
		
		<cfquery name="rsAltaFL" datasource="#Arguments.Conexion#">
			insert into RHLiqFLPrev (RHPLPid, DEid, RHLFLtGrabadoF, RHLFLtExentoF, RHLFLisptF, RHLFLinfonavit, RHLFLtotalL, RHLFLsalarioMensual,
				RHLFLisptSalario, RHLFLisptL, RHLFLresultado, Ecodigo, BMUsucodigo) 
				values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPLPid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLtGrabadoF#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLtExentoF#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLisptF#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLinfonavit#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLtotalL#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLsalarioMensual#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLisptSalario#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLisptL#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.RHLFLresultado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				)
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsAltaFL">
		<cfreturn #rsAltaFL.identity#>
	</cffunction>
	
	<!--- Selecciona proceso de liquidacion-finiquito (Proceso para Mexico) --->
	<cffunction name="fnGetLF" access="public" returntype="query">
		<cfargument name="RHLFLid" 	 type="numeric">	
		<cfargument name="RHPLPid" 	 type="numeric">	
		<cfargument name="DEid" 	 type="numeric">
		<cfargument name="Conexion"  type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfif not isdefined('Arguments.RHLFLid') and ( not isdefined('Arguments.RHPLPid') or not isdefined('Arguments.DEid'))>
			<cfthrow message="Debe definir un campo, RHLFLid ó RHPLPid y DEid">
		</cfif>
        
		<cfquery name="rsAltaFL" datasource="#Arguments.Conexion#">
			select a.RHLFLid, a.RHPLPid, a.DEid, a.RHLFLtGrabadoF, a.RHLFLtExentoF, a.RHLFLisptF, a.RHLFLinfonavit, a.RHLFLtotalL, a.RHLFLsalarioMensual,
				a.RHLFLisptSalario, a.RHLFLisptL, a.RHLFLresultado, a.Ecodigo, a.BMUsucodigo, b.RHPLPfsalida
			from RHLiqFLPrev a
            inner join RHPreLiquidacionPersonal b
				on a.RHPLPid = b.RHPLPid
			where 0 = 0 
			<cfif isdefined('Arguments.RHLFLid')>
				and a.RHLFLid = #Arguments.RHLFLid#
			<cfelse>
				and a.RHPLPid = #Arguments.RHPLPid# and a.DEid = #Arguments.DEid#
			</cfif>
		</cfquery>
		<cfreturn rsAltaFL>
	</cffunction>
	
	<cffunction name="fnValidaModificaciones" access="public" returntype="boolean">
		<cfargument name="RHPLPid" 	 type="numeric" required="yes">	
		<cfargument name="DEid" 	 type="numeric" required="yes">
		<cfargument name="Fecha" 	 type="date">
		<cfargument name="Ecodigo" 	 type="numeric">
		<cfargument name="Conexion"	 type="string">
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		
		<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnGetLF" returnvariable="rsLF">
			<cfinvokeargument name="RHPLPid" value="#Arguments.RHPLPid#">
			<cfinvokeargument name="DEid" value="#Arguments.DEid#">
		</cfinvoke>
		<cfset rsMontoEGF = fnGetMontoEG(Arguments.RHPLPid,"F", Arguments.Ecodigo, Arguments.Conexion)>

		<cfset IRcodigoN1 = fnGetDato(30,Arguments.Ecodigo, Arguments.Conexion).Pvalor>
        <cfif len(IRcodigoN1) EQ 0>
            <cfquery name="rsCodIRcodigo" datasource="#Session.DSN#">
                select IRcodigo
                    from TiposNomina a
                    inner join RHPreLiquidacionPersonal b
                    on a.Tcodigo = b.Tcodigo
                    and a.Ecodigo = b.Ecodigo
                    and b.RHPLPid = #form.RHPLPid#
            </cfquery>
            <cfset IRcodigoN1 = rsCodIRcodigo.IRcodigo>
        </cfif>
        
        <cfset ISPTF = fnCalculaISPT(rsMontoEGF.Grabado, Arguments.Fecha,"#IRcodigoN1#")>

		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR113F">
			<cfinvokeargument name="Monto" 		value="#rsMontoEGF.Grabado#">
			<cfinvokeargument name="IRcodigo" 	value="#IRcodigoN1#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
        
		<cfquery name="rsIRcodigoN2" datasource="#Arguments.Conexion#">
			select IRcodigo
				from ImpuestoRenta 
				where IRcodigoPadre = '#IRcodigoN1#'
		</cfquery>
		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR115F">
			<cfinvokeargument name="Monto" 		value="#rsMontoEGF.Grabado#">
			<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaSubsidio" returnvariable="SubsidioF">
			<cfinvokeargument name="Monto" 		value="#rsMontoEGF.Grabado#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
		<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnCalculaInfonavit" returnvariable="Infonavit">
			<cfinvokeargument name="DEid" 		value="#Arguments.DEid#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="Ecodigo" 	value="#Arguments.Ecodigo#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
		<cfset MontoGrabadoF = rsMontoEGF.Grabado>
		<cfset MontoExentoF = rsMontoEGF.Exento>
		<cfset TotalF = MontoGrabadoF + MontoExentoF>
		<cfset TotalGeneralF = TotalF - ISPTF>
		<cfset TotalRealF = TotalGeneralF - Infonavit>
		
		<cfset rsMontoEGL = fnGetMontoEG(Arguments.RHPLPid, "L", Arguments.Ecodigo, Arguments.Conexion)>
		<cfset SalarioMensual = fnGetSalarioMensual(Arguments.DEid, Arguments.Fecha, Arguments.Conexion)>
		<cfset ISPTSL = fnCalculaISPT(SalarioMensual, Arguments.Fecha,"#IRcodigoN1#")>
		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR113L">
			<cfinvokeargument name="Monto" 			value="#SalarioMensual#">
			<cfinvokeargument name="IRcodigo" 		value="#IRcodigoN1#">
		</cfinvoke>
		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR115L">
			<cfinvokeargument name="Monto" 		value="#SalarioMensual#">
			<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
		<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaSubsidio" returnvariable="SubsidioL">
			<cfinvokeargument name="Monto" 		value="#SalarioMensual#">
			<cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
			<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
		</cfinvoke>
		<cfset SalarioMinimo = fnGetDato(2024,Arguments.Ecodigo,Arguments.Conexion).Pvalor>
		<cfset CalculoLoco = fnEjecutarCalculoLoco(Arguments.DEid,Arguments.RHPLPid,Arguments.Fecha,SalarioMinimo,Arguments.Ecodigo,Arguments.Conexion)>
		<cfset MontoGrabadoL = rsMontoEGL.Grabado>
		<cfset MontoExentoL = rsMontoEGL.Exento>
		<cfset TotalL = MontoGrabadoL + MontoExentoL>
		<cfset TotalRealL = TotalL - ISPTSL - Infonavit>
		<cfset Factor = ISPTSL / SalarioMensual>
		<cfset BaseImp = MontoGrabadoL - CalculoLoco.Resultado>
		<cfset ISPTL = BaseImp * Factor>
<!---		<cfset Neto = TotalRealF - ISPTF + MontoGrabadoL - ISPTL>--->
		<cfset Neto = TotalF - ISPTF + MontoGrabadoL - ISPTL>
		<cfquery name="rsSumaAportesRealizados" datasource="#Session.DSN#">
			select sum(a.importe) as monto
			from RHLiqCargas a
			inner join DCargas   b
				on a.DClinea = b.DClinea
				and coalesce(DCSumarizarLiq,0) = 0
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		<cfif rsSumaAportesRealizados.recordcount gt 0 and len(trim(rsSumaAportesRealizados.monto))>
			<cfset Neto = Neto - rsSumaAportesRealizados.monto>
		</cfif>
		<cfset Modificado = false>
	
		<cfif rsLF.recordcount gt 0>
			<cfset fnValidaModificacion(rsLF.RHLFLtGrabadoF, MontoGrabadoF)>
			<!---<cfset fnValidaModificacion(rsLF.RHLFLtExentoF, MontoExentoF)>
			<cfset fnValidaModificacion(rsLF.RHLFLisptF, ISPTF)>
			<cfset fnValidaModificacion(rsLF.RHLFLinfonavit, Infonavit)>
			<cfset fnValidaModificacion(rsLF.RHLFLtotalL, TotalL)>
			<cfset fnValidaModificacion(rsLF.RHLFLsalarioMensual, SalarioMensual)>
			<cfset fnValidaModificacion(rsLF.RHLFLisptSalario, ISPTSL)>
			<cfset fnValidaModificacion(rsLF.RHLFLisptL, CalculoLoco.Resultado)>
			<cfset fnValidaModificacion(rsLF.RHLFLresultado, Neto)>--->
		</cfif>
		<cfreturn Modificado>
	</cffunction>
	
	<cffunction name="fnValidaModificacion" access="private">
		<cfargument name="Monto1" 	type="numeric" required="true">
		<cfargument name="Monto2" 	type="numeric" required="true">
		
		<cfif fnRedondear(Arguments.Monto1) neq fnRedondear(Arguments.Monto2)>
        	<cfthrow message="#fnRedondear(Arguments.Monto1)# #fnRedondear(Arguments.Monto2)# #Arguments.Monto1# #Arguments.Monto2#">
            
			<cfset Modificado = true>
		</cfif>
	</cffunction>
	
	<cffunction name="fnRedondear" access="private" returntype="string">
		<cfargument name="Monto" type="numeric">
		<cfargument name="Decimales" type="numeric" default="2">
		
		<cfreturn NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#")>
	</cffunction>
	
	<cffunction name="fnFormatMoney" access="private" returntype="string">
		<cfargument name="Monto" type="numeric">
		<cfargument name="Decimales" type="numeric" default="2">
		<cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".99"),'none')>
	</cffunction>
</cfcomponent>


