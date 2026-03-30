<!---
 * Esta interfaz muestra los metodos disponibles para el manejo de Planes de Pago
 *
  Metodos:                        	Parámetros
			
	string obtenerParametro 		( Ecodigo, Pcodigo [, DSN] )
		Obtiene la informacion de un credito.

	numeric obtenerMoneda			( Ecodigo [, DSN])
		Recupera la moneda para una empresa.

	query obtenerCredito			( ACCAid [, DSN])
		Obtiene la informacion de un credito.

	numeric obtenerTipoPago			( Ecodigo, Tcodigo [, DSN, BMUsucodigo] ) 
		Obtiene el tipo de pago asociado al tipo de nomina.
		BD   Fn
		0  : 1 	Semanal
		1  : 2 	Bisemanal
		2  : 3 	Quincenal
		3  : 4 	Mensual
--->

<cfcomponent>
	<!--- Tipos de periodicidad de los pagos --->
	<cfset this.periodicidad = ArrayNew(1)>
	<cfset this.periodicidad[1] = 's' >
	<cfset this.periodicidad[2] = 'b' >
	<cfset this.periodicidad[3] = 'q' >
	<cfset this.periodicidad[4] = 'm' >

	<cfset this.parametro = ArrayNew(1)>
	<cfset this.parametro[1] = 90 >
	<cfset this.parametro[2] = 80 >
	<cfset this.parametro[3] = 70 >
	<cfset this.parametro[4] = 60 >

	<!---	RESULTADO:
			Devuelve referencia a este componente.
	--->
	<cffunction name="init">
		<cfreturn This>
	</cffunction>

	<!---	RESULTADO:
			Recupera el valor del parametro asociado a Pcodigo.
	--->
	<cffunction name="obtenerParametro" returntype="string" output="false" access="public">
		<cfargument name="Ecodigo" 		type="numeric" 	required="yes">
		<cfargument name="Pcodigo" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">

		<cfquery name="data_parametro" datasource="#arguments.DSN#">
			select Pvalor
			from ACParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Pcodigo#">
		</cfquery>

		<cfreturn data_parametro.Pvalor >
	</cffunction>

	<!---	RESULTADO:
			Recupera la moneda para una empresa.
	--->
	<cffunction name="obtenerMoneda" returntype="numeric" output="false" access="public">
		<cfargument name="Ecodigo" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">

		<cfquery name="data" datasource="#arguments.DSN#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<cfreturn data.Mcodigo >
	</cffunction>

	<!---	RESULTADO:
			Obtiene el id de empleado correspondiente a un asociado.
	--->
	<cffunction name="obtenerEmpleado" returntype="numeric" output="false" access="public">
		<cfargument name="ACAid"	type="numeric"	required="yes">
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">

		<cfquery name="rs_empleado" datasource="#arguments.DSN#">
			select DEid
			from ACAsociados
			where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
		</cfquery>
		<cfreturn rs_empleado.DEid >
	</cffunction>

	<!---	RESULTADO:
			Obtiene la informacion de un credito.
	--->
	<cffunction name="obtenerCredito" returntype="query" output="false" access="public">
		<cfargument name="ACCAid" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">

		<cfquery name="data_credito" datasource="#arguments.DSN#">
			select ACCAid, ACAid, ACCTid, Ecodigo, Tcodigo, ACCTcapital, ACCTamortizado, ACCTplazo, ACCTcuotas, ACCTtasa, ACPTtasaMora, ACCTfechaInicio, ACCAperiodicidad, ACCTcapital - ACCTamortizado as saldo
			from ACCreditosAsociado
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
		</cfquery>
		<cfreturn data_credito >
	</cffunction>

	<!---	RESULTADO:
			Obtiene la informacion del tipo de credito.
	--->
	<cffunction name="obtenerTipoCredito" returntype="query" output="false" access="public">
		<cfargument name="ACCTid" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">

		<cfquery name="rs_tipocredito" datasource="#arguments.DSN#">
			select ACCTid, TDid, ACCTcodigo, ACCTdescripcion, ACCTplazo, ACCTtasa, ACCTtasaMora, ACCTmodificable, ACCTobservaciones, ACCTdocumentoAsociado, ACCTtipo
			from ACCreditosTipo
			where ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCTid#">
		</cfquery>
		<cfreturn rs_tipocredito >
	</cffunction>

	<!---	RESULTADO:
			Obtiene el tipo de pago asociado al tipo de nomina.
	--->
	<cffunction name="obtenerTipoPago" returntype="numeric" output="false" access="public">
		<cfargument name="Ecodigo" 		type="numeric" 	required="yes">
		<cfargument name="Tcodigo" 		type="string" 	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">

		<cfquery name="data" datasource="#arguments.DSN#">
			select Ttipopago
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
		</cfquery>
		<cfreturn data.Ttipopago+1 >
	</cffunction>

	<!---	RESULTADO:
			Obtiene la fecha de pago de un calendario de pagos a partir de una fecha dada.
	--->
	<cffunction name="obtenerFechaCalendario" returntype="query" output="true" access="public">
		<cfargument name="Ecodigo" 		type="numeric" 	required="yes">
		<cfargument name="Tcodigo" 		type="string" 	required="yes" default="">
		<cfargument name="fecha" 		type="string"	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">
		
		<!---
		<cfquery name="data" datasource="#arguments.DSN#">
			select cp.CPhasta, cp.CPfpago 
			from CalendarioPagos cp
			where cp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and cp.CPfcalculo is null
			  and cp.CPtipo =0
			  and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between cp.CPdesde and cp.CPhasta		
		</cfquery>
		--->
		
		<cfquery name="data" datasource="#arguments.DSN#">
			select min(cp.CPhasta) as CPhasta
			from CalendarioPagos cp
			where cp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and cp.CPfcalculo is null
				and cp.CPtipo =0
				and cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Tcodigo#">
			 and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#"> <= cp.CPhasta
		</cfquery>
		<cfif data.recordcount eq 0 or len(trim(data.CPhasta)) eq 0 >
			<cfthrow detail="Error. No existen calendarios de pago para la nomina #arguments.Tcodigo#.">
		</cfif>

		<cfreturn data >
	</cffunction>

	<!---	RESULTADO:
			Calcula el interes por tipo de pago. 
			Asume que el interes es anual.
	--->
	<cffunction name="calcularInteres" returntype="numeric" output="false" access="public">
		<cfargument name="Ecodigo"		type="numeric" 	required="yes">
		<cfargument name="tipo" 		type="numeric" 	required="yes">
		<cfargument name="interes" 		type="numeric" 	required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">
		
		<!--- obtiene factor de dias del anno --->
		<cfset dias_anno = this.ObtenerParametro(arguments.Ecodigo, 30) >
		<!--- obtiene factor de dias segun tipo de nomina --->
		<cfset dias_nomina = this.ObtenerParametro(arguments.Ecodigo, this.parametro[arguments.tipo] ) >
		
		<cfif len(trim( dias_anno )) is 0 or dias_anno eq 0 >
			<cfthrow detail="Error. El factor de d&iacute;as del a&ntilde;o no ha sido definido &oacute; es cero.">
		</cfif>

		<cfif len(trim( dias_nomina )) is 0 >
			
			<cfthrow detail="Error. El factor de d&iacute;as por Tipo de Nomina no ha sido definido.">
		</cfif>

		<cfreturn ((interes/100)/dias_anno)*dias_nomina >	<!--- *** revisar esto *** --->
	</cffunction>

	<!---	RESULTADO:
			Inserta un registro en la tabla de Plan de Pago(ACPlanPagos)
	--->
	<cffunction name="insertarCredito" output="false" access="public" returntype="numeric">
		<cfargument name="ACAid" 			type="numeric" 	required="yes">
		<cfargument name="ACCTid" 			type="numeric" 	required="yes">
		<cfargument name="ACCTcapital"		type="numeric" 	required="yes">
		<cfargument name="ACCTplazo"		type="numeric" 	required="yes">		
		<cfargument name="ACCTtasa"			type="numeric" 	required="yes">		
		<cfargument name="ACPTtasamora"		type="numeric" 	required="yes">		
		<cfargument name="ACCTfechaInicio"	type="string" 	required="yes">		
		<cfargument name="ACCAperiodicidad"	type="numeric"	required="yes" >
		<cfargument name="ACCTamortizado"	type="numeric" 	required="no" default="0">		
		<cfargument name="Tcodigo" 			type="string" 	required="no">
		<cfargument name="ACCTcuotas"		type="numeric" 	required="no" default="0">
		<cfargument name="BMUsucodigo" 		type="numeric"  required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 			type="string" 	required="no" default="#session.Ecodigo#">
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">		

		<cfquery name="insert" datasource="#arguments.DSN#">
			insert into ACCreditosAsociado(	ACAid, 
											ACCTid, 
											Ecodigo, 
											Tcodigo, 
											ACCTcapital, 
											ACCTamortizado, 
											ACCTplazo, 
											ACCTtasa, 
											ACPTtasaMora, 
											ACCTfechaInicio,
											ACCAperiodicidad, 
											ACCTcuotas,
											BMUsucodigo, 
											BMfecha )
			values (	<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACAid#">,
						<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACCTid#">,
						<cfqueryparam  	cfsqltype="cf_sql_integer" 		value="#arguments.Ecodigo#">,
						<cfif isdefined("arguments.Tcodigo") and len(trim(arguments.Tcodigo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#"><cfelse>null</cfif>,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACCTcapital#">,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACCTamortizado#">,						
						<cfqueryparam 	cfsqltype="cf_sql_float" 		value="#arguments.ACCTplazo#">,						
						<cfqueryparam 	cfsqltype="cf_sql_float" 		value="#arguments.ACCTtasa#">,						
						<cfqueryparam 	cfsqltype="cf_sql_float" 		value="#arguments.ACPTtasamora#">,
						<cfqueryparam 	cfsqltype="cf_sql_date"			value="#LSParseDateTime(arguments.ACCTfechaInicio)#">,
						<cfqueryparam  	cfsqltype="cf_sql_integer" 		value="#arguments.ACCAperiodicidad#">,
						<cfqueryparam 	cfsqltype="cf_sql_integer" 		value="#arguments.ACCTcuotas#">,						
						<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.BMUsucodigo#">,
						<cfqueryparam 	cfsqltype="cf_sql_timestamp"	value="#now()#"> )
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="insert" verificar_transaccion="false">

		<cfreturn insert.identity >
	</cffunction>

	<!---	RESULTADO:
			Modifica un credito
	--->
	<cffunction name="modificarCredito" output="false" access="public" >
		<cfargument name="ACCAid" 			type="numeric" 	required="yes">
		<cfargument name="ACAid" 			type="numeric" 	required="yes">
		<cfargument name="ACCTid" 			type="numeric" 	required="yes">
		<cfargument name="ACCTcapital"		type="numeric" 	required="yes">
		<cfargument name="ACCTplazo"		type="numeric" 	required="yes">		
		<cfargument name="ACCTtasa"			type="numeric" 	required="yes">		
		<cfargument name="ACPTtasamora"		type="numeric" 	required="yes">		
		<cfargument name="ACCTfechaInicio"	type="string" 	required="yes">		
		<cfargument name="ACCAperiodicidad"	type="numeric"	required="yes" >
		<cfargument name="ACCTamortizado"	type="numeric" 	required="no" default="0">		
		<cfargument name="Tcodigo" 			type="string" 	required="no">
		<cfargument name="ACCTcuotas"		type="numeric" 	required="no" default="0">
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">		

		<cfquery datasource="#arguments.DSN#">
			update ACCreditosAsociado
			set ACAid 				= <cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACAid#">, 
				ACCTid 				= <cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACCTid#">, 
				Tcodigo 			= <cfif isdefined("arguments.Tcodigo") and len(trim(arguments.Tcodigo))><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#"><cfelse>null</cfif>,  
				ACCTcapital 		= <cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACCTcapital#">, 
				ACCTamortizado 		= <cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACCTamortizado#">, 
				ACCTplazo 			= <cfqueryparam 	cfsqltype="cf_sql_float" 		value="#arguments.ACCTplazo#">, 
				ACCTtasa 			= <cfqueryparam 	cfsqltype="cf_sql_float" 		value="#arguments.ACCTtasa#">, 
				ACPTtasaMora 		= <cfqueryparam 	cfsqltype="cf_sql_float" 		value="#arguments.ACPTtasamora#">, 
				ACCTfechaInicio 	= <cfqueryparam 	cfsqltype="cf_sql_date"			value="#LSParseDateTime(arguments.ACCTfechaInicio)#">,
				ACCAperiodicidad	= <cfqueryparam  	cfsqltype="cf_sql_integer" 		value="#arguments.ACCAperiodicidad#">,
				ACCTcuotas			= <cfqueryparam 	cfsqltype="cf_sql_integer" 		value="#arguments.ACCTcuotas#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where ACCAid = <cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACCAid#">				
		</cfquery>
	</cffunction>

	<!---	RESULTADO:
			Actualiza el monto de amortizacion para un credito.
	--->
	<cffunction name="actualizarAmortizacion" output="false" access="public" >
		<cfargument name="ACCAid" 	type="numeric" 	required="yes">
		<cfargument name="monto"	type="numeric" 	required="yes" >		
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">		

		<cfquery datasource="#arguments.DSN#">
			update ACCreditosAsociado
			set ACCTamortizado =  ACCTamortizado + <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.monto#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where ACCAid = <cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACCAid#">				
		</cfquery>
	</cffunction>

	<!---	RESULTADO:
			Inserta un registro en la tabla de Plan de Pago(ACPlanPagos)
	--->
	<cffunction name="insertarPlan" output="false" access="public">
		<cfargument name="ACCAid" 				type="numeric" 	required="yes">
		<cfargument name="ACPPprincipal"		type="numeric" 	required="yes">
		<cfargument name="ACPPfechaPlan"		type="string" 	required="yes">		
		<cfargument name="ACPPfecha"			type="string" 	required="yes">
		<cfargument name="ACPPsaldoAnterior"	type="numeric" 	required="yes">
		<cfargument name="ACPPinteres"			type="numeric" 	required="yes">
		<cfargument name="ACPPpagoInteres"		type="numeric" 	required="yes">
		<cfargument name="ACPPpagoPrincipal"	type="numeric" 	required="yes">		
		<cfargument name="ACPPpagoMora"			type="numeric" 	required="yes">
		<cfargument name="ACPPtasa"				type="numeric" 	required="yes">
		<cfargument name="ACPPtasaMora"			type="numeric" 	required="yes">
		<cfargument name="ACPPestado"			type="string" 	required="yes">
		<cfargument name="ACPPtipo"				type="string" 	required="yes">
		<cfargument name="Mcodigo"				type="numeric" 	required="yes">
		<cfargument name="ACDLid" 				type="string" 	required="no" default="" > 
		<cfargument name="Did" 					type="string" 	required="no" default="" >
		<cfargument name="ACPPperiodicidad"		type="string" 	required="no" default="" >
		<cfargument name="ACPPdocumento"		type="string" 	required="no" default="" >
		<cfargument name="ACPPfechadocumento"	type="string" 	required="no" default="" >
		<cfargument name="ACPPfechaPago"		type="string" 	required="no" default="" >								
		<cfargument name="IDcontable"			type="string" 	required="no" default="" >
		<cfargument name="DSN" 					type="string" 	required="no" default="#session.DSN#">
		<cfargument name="BMUsucodigo"			type="string" 	required="no" default="#session.Usucodigo#">		

		<cfquery datasource="#arguments.DSN#">
			insert into ACPlanPagos(	ACCAid, 
										ACDLid, 
										Did, 
										ACPPprincipal, 
										ACPPfechaPlan, 
										ACPPfecha, 
										ACPPfechaPago, 
										ACPPsaldoAnterior, 
										ACPPinteres, 
										ACPPpagoPrincipal, 
										ACPPpagoInteres, 
										ACPPpagoMora, 
										ACPPtasa, 
										ACPPtasaMora, 
										ACPPestado, 
										ACPPtipo, 
										Mcodigo, 
										ACPPdocumento, 
										ACPPfechaDocumento, 
										IDcontable,
										ACPPperiodicidad, 
										BMUsucodigo, 
										BMfecha )
			values (	<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.ACCAid#">,
						<cfif isdefined("arguments.ACDLid") and len(trim(arguments.ACDLid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACDLid#"><cfelse>null</cfif>, <!---<cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#arguments.ACDLid#" null="#len(trim(arguments.ACDLid)) is 0#">,--->
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#arguments.Did#" null="#len(trim(arguments.Did)) is 0#">,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACPPprincipal#">,
						<cfqueryparam 	cfsqltype="cf_sql_date"			value="#LSParseDateTime(arguments.ACPPfechaPlan)#">,
						<cfqueryparam 	cfsqltype="cf_sql_date"			value="#LSParseDateTime(arguments.ACPPfecha)#">,
						<cfif isdefined("arguments.ACPPfechaPago") and len(trim(arguments.ACPPfechaPago))><cfqueryparam cfsqltype="cf_sql_date"	value="#LSParseDateTime(arguments.ACPPfechaPago)#"><cfelse>null</cfif>,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACPPsaldoAnterior#">,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACPPinteres#">,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACPPpagoPrincipal#">,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACPPpagoInteres#">,
						<cfqueryparam 	cfsqltype="cf_sql_money" 		value="#arguments.ACPPpagoMora#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#arguments.ACPPtasa#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#arguments.ACPPtasaMora#">,
						<cfqueryparam 	cfsqltype="cf_sql_char" 		value="#arguments.ACPPestado#">,
						<cfqueryparam 	cfsqltype="cf_sql_char" 		value="#arguments.ACPPtipo#">,
						<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.Mcodigo#">,
						<cfqueryparam 	cfsqltype="cf_sql_varchar" 		value="#arguments.ACPPdocumento#" null="#len(trim(arguments.ACPPdocumento)) is 0#">,
						<cfif isdefined("arguments.ACPPfechaDocumento") and len(trim(arguments.ACPPfechaDocumento))><cfqueryparam cfsqltype="cf_sql_date"	value="#LSParseDateTime(arguments.ACPPfechaDocumento)#"><cfelse>null</cfif>,
						<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.IDcontable#" null="#len(trim(arguments.IDcontable)) is 0#">,
						<cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#arguments.ACPPperiodicidad#" null="#len(trim(arguments.ACPPperiodicidad)) is 0#">,						
						<cfqueryparam  	cfsqltype="cf_sql_numeric" 		value="#arguments.BMUsucodigo#">,
						<cfqueryparam 	cfsqltype="cf_sql_timestamp"	value="#now()#"> )
		</cfquery> 
	</cffunction>
	
	<!---	RESULTADO:
			Crea un plan de pagos para una operacion de credito.
			Toma en cuenta el tipo de nomina, plazo, interes, monto etc.
	--->
	<cffunction name="crearPlan" output="true" access="public">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="regenerar" 	type="boolean" required="no" default="false">
		<cfargument name="BMUsucodigo" 	type="numeric" required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 		type="string"  required="no" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"  required="no" default="#session.DSN#">
		<cfargument name="fecha_accion"	type="string"  required="no" default="">

		<!--- 0. Obtiene instancias de componentes --->
		<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="deduccion">
		<cfinvoke component="rh.asoc.Componentes.ACParametros" method="init" returnvariable="parametro">		

		<!--- 1. Recupera informacion del credito --->
		<cfset data_credito = this.obtenerCredito(arguments.ACCAid) >

		<!--- 1.1 si el saldo es cero no tiene que hacer recalculos del plan, 
				  solo debe borrar los pagos pendientes y deshabilitar la deduccion --->
		<cfif data_credito.saldo lte 0 >
			<!--- inactiva la deducciones pendientes --->
			<cfset deduccion_id = obtenerDeduccion(arguments.ACCAid, arguments.DSN) >
			<cfif len(trim(deduccion_id))>
				<cfset deduccion.Inactivar(deduccion_id) >
			</cfif>
			<!--- borra los registros pendientes del plan de pagos --->
			<cfquery datasource="#arguments.dsn#">
				delete from ACPlanPagos
				where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
				  and ACPPestado = 'N'
				  and ACPPtipo = 'N'
			</cfquery>
			<!--- se sale --->
			<cfreturn>
		</cfif> 

		<cfif len(trim(data_credito.Tcodigo)) >
			<cfset tipo_id 	   = this.obtenerTipoPago(arguments.Ecodigo, data_credito.Tcodigo) >		
			<cfset tipo    	   = this.periodicidad[tipo_id] >
			<cfset tipo_pago   = 'N' >
		<cfelse>
			<cfset tipo_id 	   = data_credito.ACCAperiodicidad+1 >
			<cfset tipo    	   = this.periodicidad[tipo_id] >
			<cfset tipo_pago   = 'M' >
		</cfif>	

		<!--- 2. Variables para efectuar calculos --->
		<cfif not regenerar>
			<cfset saldo = data_credito.ACCTcapital >	
			<cfset plazo = obtenerCantidadCuotas( data_credito.ACCTplazo, tipo_id, arguments.Ecodigo, arguments.DSN) >
			<!--- ajuste: a veces lo que dice el campo de cuotas y la cantidad de cuotas generadas difiere en uno o dos cuotas,
				  por eso se hace este ajuste para que quede igual a como se digito en el campo de pantalla --->
			<cfif plazo neq data_credito.ACCTcuotas and data_credito.ACCTcuotas gt 0>
				<cfset plazo = data_credito.ACCTcuotas >
			</cfif>
			<cfset primerfecha = data_credito.ACCTfechaInicio >
		<cfelse>
			<!--- 2.1 Cantidad de cuotas que ya han sido pagadas por nomina o manuales--->
			<cfset cuotas_pagadas = this.existenPagos( arguments.ACCAid, arguments.DSN, 'P' ) >
			<!--- 2.2 Variables para efectuar calculos --->
			<cfif len(trim(arguments.fecha_accion)) >
				<cfset meses_nopagados = data_credito.ACCTplazo - (this.obtenerMesesPagados(arguments.ACCAid, Ecodigo, DSN, arguments.fecha_accion)) >
				<cfset primerfecha = arguments.fecha_accion >
				<cfset saldo   	   = data_credito.ACCTcapital - data_credito.ACCTamortizado - (this.obtenerMontoPendiente(arguments.ACCAid, arguments.fecha_accion, session.DSN) )  >
				<cfset fecha_acc = arguments.fecha_accion >
			<cfelse>
				<cfset meses_nopagados = data_credito.ACCTplazo - (this.obtenerMesesPagados(arguments.ACCAid, Ecodigo, DSN)) >
				<cfset primerfecha = obtenerFechaInicio(arguments.ACCAid, arguments.DSN) >
				<cfset saldo   	   = data_credito.ACCTcapital- data_credito.ACCTamortizado>					
				<cfset fecha_acc = '' >
			</cfif>
			<cfset plazo = obtenerCantidadCuotas( meses_nopagados, tipo_id, arguments.Ecodigo, arguments.DSN) >

			<cfset this.modificarCredito( arguments.ACCAid, 
										  data_credito.ACAid,
										  data_credito.ACCTid,
										  data_credito.ACCTcapital,
										  data_credito.ACCTplazo,
										  data_credito.ACCTtasa,
										  data_credito.ACPTtasaMora,
										  LSDateFormat(data_credito.ACCTfechaInicio, 'dd/mm/yyyy'),
										  data_credito.ACCAperiodicidad,
										  data_credito.ACCTamortizado,
										  data_credito.Tcodigo,
										  plazo+obtenerCantidadCuotasPagadas(arguments.ACCAid, fecha_acc, arguments.DSN)) >

			<!--- 2.3 Obtiene la deduccion pendiente de aplicar y la inactiva --->
			<cfset deduccion_id = obtenerDeduccion(arguments.ACCAid, arguments.DSN) >
			<cfif len(trim(deduccion_id))>
				<!--- si es un cambio de tipo de nomina restringe la fecha de vida de la deduccion
					  Esto es por si la fecha de la accion es a futuro, y para que los pagos que deben hacerse
					  de hoy a esa fecha se sigan rebajando con la nomina actual. 	
				--->
				<cfif len(trim(arguments.fecha_accion)) >
					<cfset deduccion.cambiarFecha(deduccion_id, arguments.fecha_accion, -1 ) >
				<cfelse>
					<cfset deduccion.Inactivar(deduccion_id) >
				</cfif>	
			</cfif>
	
			<!--- 2.4 si se ha cambiado la nomina del asociado y la nueva nomina es para fechas futuras,
					  osea de hoy a esa fecha existen pagos del plan, estos no deben eliminarse, se siguen pagando
					  con la nomina actual del empleado, por eso marcamos esos registros con un estado especial, para 
					  que no sea eliminados en el punto 2.5
			 --->
			<cfif len(trim(arguments.fecha_accion)) >
				<cfset this.modificarEstadoPlan(arguments.ACCAid, 'T', '', 'N', arguments.fecha_accion, session.Ecodigo, session.DSN) >
			</cfif>
			<!--- 2.5 elimina las cuotas que no han sido pagadas --->
			<cfset this.eliminarCuotas(arguments.ACCAid, arguments.DSN) >

			<!--- 2.6 las cuotas marcadas como temporales en 2.4, se vuelven a poner com no pagadas. --->
			<cfif len(trim(arguments.fecha_accion)) >
				<cfset this.modificarEstadoPlan(arguments.ACCAid, 'N', '', 'T', arguments.fecha_accion, session.Ecodigo, session.DSN) >
			</cfif>
		</cfif>
		<cfset interes = data_credito.ACCTtasa >		
		<cfset fecha   = primerfecha >

		<cfset monto_financiado = 0 >
		
		<!--- 3. Calculo de intereses segun tipo de pago (s,b,q,m) --->
		<cfset interes_div = this.calcularInteres(arguments.Ecodigo, tipo_id, data_credito.ACCTtasa, arguments.DSN ) >

		<!--- 4. Calculo de la cuota --->
		<cfif plazo le 0>
			<cfset cuota = saldo>
			<cfset plazo = 1>
			<cfset interes_div = 0>
		<cfelseif interes_div is 0>
			<cfset cuota = saldo / plazo >
		<cfelse>
			<!--- revisar contra ejemplos esta formula parece estar bien. --->
			<!--- <cfset cuota = saldo / ((1 - (  (1+interes_div) ^  -plazo    ))/interes_div)> ---> <!--- --->
			<cfset cuota = saldo  * ( (interes_div * ((1+interes_div)^plazo)) / (((1+interes_div)^plazo)-1)  ) >
		</cfif>
		<cfset cuota = Round(cuota*100)/100>

		<!--- 5. Si el asociado es empleado y esta en nomina, le genera un deduccion por el monto de la cuota --->
		<cfset vDid = '' >
		<cfif len(trim(data_credito.Tcodigo)) >
			<cfset vDEid  = this.obtenerEmpleado( data_credito.ACAid, arguments.DSN ) >
			<cfset vSocio = parametro.get(100) >
			<cfset rs_TDeduc  = this.obtenerTipoCredito(data_credito.ACCTid, arguments.DSN) >
			
			<cfif not len(trim(vSocio)) ><cfthrow detail="Error. No ha sido definido el Socio de Negocios para generar deducciones."></cfif>
			<cfif not len(trim(rs_TDeduc.TDid)) ><cfthrow detail="Error. No ha sido definido el Tipo de Deducci&oacute;n para la generaci&oacute;n de deducciones."></cfif>
			<cfset vDid = deduccion.Alta( vDEid, vSocio, rs_TDeduc.TDid, 'Pago de Credito #arguments.ACCAid#.', '1', cuota, LSDateFormat(fecha, 'dd/mm/yyyy'), 'Pago de Credito.', 1, false, data_credito.saldo ) >
		</cfif>

		<!--- 6. Generacion del calendario de pagos  --->
		<cfloop from="1" to="#plazo#" index="i">
			<cfif saldo lte 0><cfbreak></cfif>
			
			<!--- 6.1 calcula interes sobre saldos --->
			<cfset interes = Round((saldo * interes_div) * 100)/100>
			<!--- 6.2 si cuota es diferente a saldo + interes, modifica al cuota a este ultimo valor--->
			<cfif i is plazo and cuota neq saldo + interes>
				<cfset cuota = saldo + interes>
			</cfif>
			
			<!--- 6.3 Obtiene fecha de pago de la cuota 
				  Si el asociado esta en planilla, esta fecha debe ser la fecha de pago del calendario de pagos respectivo.
			--->
			<!--- Caso 1: Asociado es empleado y esta en planilla de sistema RH --->
			<cfif len(trim(data_credito.Tcodigo)) >
				<cfset fechas 	  	 = this.obtenerFechaCalendario(arguments.Ecodigo, data_credito.Tcodigo, lsdateformat(fecha, 'dd/mm/yyyy'), arguments.DSN )>
				<cfset fecha_pago 	 = fechas.CPhasta >		<!--- fecha del pago --->
				<cfset fecha_calculo = fechas.CPhasta >		<!--- fecha para hacer la proxima consulta de la fecha de pago --->
				<cfset fecha = dateadd('d', 1, fecha_calculo) >	<!--- Toma la fecha y la mueve al inicio del siguiente calendario de pagos --->

			<!--- Caso 2: Asociado es empleado y no esta en planilla de sistema RH --->
			<cfelse>
				<cfset fecha_pago = fecha >
				<cfif i neq 1>
					<cfset sumar_dias = this.obtenerParametro(arguments.Ecodigo, this.parametro[tipo_id], arguments.DSN )>
					<cfset fecha_pago = dateadd('d', sumar_dias, fecha_pago) >
				</cfif>	
				<cfset fecha = fecha_pago >
			</cfif>
			
			<!--- 6.4 inserta plan de pagos --->
			<cfset this.insertarPlan ( 	arguments.ACCAid,
										data_credito.ACCTcapital,
										LSDateFormat(now(), 'dd/mm/yyyy'),
										LSDateFormat(fecha_pago, 'dd/mm/yyyy'),
										saldo,
										data_credito.ACCTtasa,
										interes,
										cuota-interes,
										0,
										data_credito.ACCTtasa,
										0,
										'N',
										tipo_pago,
										this.obtenerMoneda(arguments.Ecodigo),
										'',
										vDid,
										tipo_id-1 ) > <!--- Para BD el tipo debe estar en [0,1,2,3] --->
			
			<!--- 6.5 calcula el nuevo saldo --->
			<cfset saldo = saldo + interes - cuota>
			<cfset monto_financiado = monto_financiado + cuota >
		</cfloop>

		<!--- 7. modificar el saldo de la deduccion, pues debe incluir los intereses --->
		<cfif isdefined('vDid') and vDid GT 0>
			<cfquery datasource="#session.DSN#">
				update DeduccionesEmpleado
				set Dsaldo = <cfqueryparam cfsqltype="cf_sql_money" value="#monto_financiado#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDid#">
			</cfquery>
		</cfif>
	</cffunction>
	
	<!---	RESULTADO:
			Consulta si a un credito tiene registrado pagos.
	--->
	<cffunction name="existenPagos" output="true" access="public" returntype="numeric">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">
		<cfargument name="tipo" 		type="string" 	required="no" default="">
		<cfargument name="estado" 		type="string" 	required="no" default="S">								
		
		<cfquery name="data_plan" datasource="#arguments.DSN#">
			select count(1) as registros
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			and ACPPestado = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.estado#">
			<cfif len(trim(arguments.tipo))>
				<cfif arguments.tipo eq 'P'>
					and ACPPtipo in ('N', 'M')
				<cfelse>
					and ACPPtipo =  <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.tipo#">
				</cfif>
			</cfif>
		</cfquery>
		<cfreturn data_plan.registros >
	</cffunction>	

	<!---	RESULTADO:
			Elimina masivamente las cuotas que no han sido pagadas en un plan de pagos.
	--->
	<cffunction name="eliminarCuotas" output="true" access="public">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">		
		
		<cfquery datasource="#arguments.DSN#">
			delete from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			  and ACPPestado = 'N'
		</cfquery>
	</cffunction>	

	<!---	RESULTADO:
			Obtiene la fecha de inicio para un plan de pagos con pagos registrados, ya sea
			pagos por nomina, extraordinarios o manuales.
	--->
	<cffunction name="obtenerFechaInicio" output="true" access="public" returntype="string">
		<cfargument name="ACCAid" type="numeric" required="yes">
		<cfargument name="DSN" 	  type="string"	 required="no" default="#session.DSN#">
		
		<cfquery name="data_fecha" datasource="#arguments.DSN#">
			select min(ACPPfecha) as fecha
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			  and ACPPestado = 'N'
		</cfquery>
		<cfif len(trim(data_fecha.fecha))>
			<cfreturn LSDateFormat(data_fecha.fecha, 'dd/mm/yyyy')>
		</cfif>
		<cfreturn '' >
	</cffunction>	

	<!---	RESULTADO:
			Obtiene la deduccion pendiente de un plan de pagos.
	--->
	<cffunction name="obtenerDeduccion" output="true" access="public" returntype="string">
		<cfargument name="ACCAid" type="numeric" required="yes">
		<cfargument name="DSN" 	  type="string"	 required="no" default="#session.DSN#">		
		
		<cfquery name="data_deduccion" datasource="#arguments.DSN#">
			select min(Did) as Did 
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			  and ACPPestado = 'N'
		</cfquery>

		<cfreturn data_deduccion.Did >
	</cffunction>	

	<!---	RESULTADO:
			Elimina masivamente un plan de pagos para una operacion de credito.
			Solo puede eliminar planes de pago sin pagos registrados.
	--->
	<cffunction name="eliminarPlan" output="true" access="public">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">		
		
		<cfif this.existenPagos(arguments.ACCAid, arguments.DSN ) eq 0 >
			<!--- elimina deducciones asociadas al plan de pagos --->
			<cfset vDid = this.obtenerDeduccion(arguments.ACCAid, arguments.DSN) >
			<cfif len(trim(vDid)) >
				<cfquery datasource="#arguments.DSN#">
					update ACPlanPagos
					set Did = null,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						BMfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#"> 
				</cfquery>
				<cfquery datasource="#arguments.DSN#">
					delete from DeduccionesEmpleado
					where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDid#">
				</cfquery>
			</cfif>

			<!--- elimina el plan de pagos --->
			<cfquery datasource="#arguments.DSN#">
				delete from ACPlanPagos
				where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			</cfquery>
		</cfif>
	</cffunction>	
	
	<!---	RESULTADO:
			Elimina credito.
			Solo puede eliminar creditos sin pagos registrados.
	--->
	<cffunction name="eliminarCredito" output="true" access="public">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">		
		
		<cfif this.existenPagos(arguments.ACCAid, arguments.DSN ) eq 0 >
			<cfquery datasource="#arguments.DSN#">
				delete from ACCreditosAsociado
				where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			</cfquery>
		</cfif>
	</cffunction>	
	
	<!---	RESULTADO:
			Obtiene informacion del plan de pagos.
	--->
	<cffunction name="obtenerPlanPagos" output="true" access="public" returntype="query">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">		
		
		<cfquery name="plan_pagos" datasource="#arguments.DSN#">
			select ACPPfecha, ACPPfechaPago, ACPPsaldoAnterior, ACPPpagoInteres, ACPPpagoPrincipal, ACPPpagoInteres+ACPPpagoPrincipal as ACPPcuota, ACPPestado, ACPPtipo, ACPPperiodicidad
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			order by ACPPsaldoAnterior desc
		</cfquery>
		
		<cfreturn plan_pagos >
	</cffunction>	

	<!---	RESULTADO:
			Obtiene el monto de las cuotas que no se han sido pagadas.
	--->
	<cffunction name="obtenerCuota" output="true" access="public" returntype="string">
		<cfargument name="ACCAid" 		type="numeric" required="yes">
		<cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">		
		
		<cfquery name="data_cuota" datasource="#arguments.DSN#">
			select min(ACPPpagoInteres+ACPPpagoPrincipal) as ACPPcuota
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			and ACPPestado = 'N'
		</cfquery>
		<cfreturn data_cuota.ACPPcuota >
	</cffunction>	

	<!---	RESULTADO:
			Obtiene los datos las cuotas van a ser pagadas por adelantado.
	--->
	<cffunction name="obtenerCuotasAdelanto" output="true" access="public" returntype="query">
		<cfargument name="ACCAid" 	type="numeric" required="yes">
		<cfargument name="cantidad" type="numeric" required="yes">
		<cfargument name="orden"  	type="string"  required="no" default="1">
		<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		
		
		<cfquery name="data_cuota" datasource="#arguments.DSN#" maxrows="#arguments.cantidad#">
			select ACPPid, ACPPpagoPrincipal + ACPPpagoInteres as cuota, ACPPpagoPrincipal as amortizacion, Did 
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			and ACPPestado = 'N'
			order by ACPPfecha <cfif orden eq 1 >asc<cfelse>desc</cfif>
		</cfquery>
		<cfreturn data_cuota >
	</cffunction>	

	<!---	RESULTADO:
			Modifica los datos de una cuota.
			Revisar si son necesarios otros datos
	--->
	<cffunction name="modificarPlan" output="true" access="public" >
		<cfargument name="ACCAid" 	type="numeric" required="yes">
		<cfargument name="ACPPid" 	type="numeric" required="yes">
		<cfargument name="fecha" 	type="string"  required="yes">
		<cfargument name="estado"  	type="string"  required="yes">
		<cfargument name="tipo"  	type="string"  required="yes">
		<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		

		<cfquery datasource="#arguments.DSN#">
			update ACPlanPagos
			set ACPPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">,
			    ACPPestado = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.estado#">,
			    ACPPtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.tipo#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where ACPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACPPid#">
			and ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
		</cfquery>
	</cffunction>	

	<!---	RESULTADO:
			Calcula la cantidad de cuotas que se deben pagar para un plan de pagos.
			Tener en cuenta que el plazo viene en meses, por eso hay que calcular
			ese numero de cuotas.
	--->
	<cffunction name="obtenerCantidadCuotas" output="true" access="public" returntype="numeric" >
		<cfargument name="plazo" 		type="string"  required="yes">
		<cfargument name="periodicidad" type="string"  required="yes">
		<cfargument name="Ecodigo" 		type="string"  required="no" default="#session.DSN#">		
		<cfargument name="DSN" 	  		type="string"  required="no" default="#session.DSN#">		

		<cfset dias_anno    = obtenerParametro(arguments.Ecodigo, 30, arguments.DSN) >
		<cfset dias_periodo = obtenerParametro(arguments.Ecodigo, this.parametro[arguments.periodicidad], arguments.DSN) >
		
		<cfset cantidad_cuotas = ((arguments.plazo*dias_anno)/(12*dias_periodo)) >

		<cfreturn round(cantidad_cuotas) >
	</cffunction>	

	<!---	RESULTADO:
			Devuelve la cantidad de cuotas que ya se pagaron mas las que se tienen que pagar por cambio de tipo de nomina.
			Esto es calcular cuales cuotas estan antes de la fecha rige de la accion y no han sido pagadas, porque van a ser pagadas
			por el tipo de nomina anterior al nuevo.
	--->
	<cffunction name="obtenerCantidadCuotasPagadas" output="true" access="public" returntype="numeric" >
		<cfargument name="ACCAid" 		type="string"  required="yes">
		<cfargument name="fecha_accion" type="string"  required="no">
		<cfargument name="DSN" 	  		type="string"  required="no" default="#session.DSN#">		
		
		<cfquery name="rs_cantcuotaspagadas" datasource="#arguments.DSN#">
			select count(1) as pagadas
			from ACPlanPagos
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			and ( (ACPPestado = 'S' and ACPPtipo in ('N', 'M') )
				
					<cfif isdefined("arguments.fecha_accion") and len(trim(arguments.fecha_accion))>
						or ( ACPPfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha_accion)#">
						     and ACPPestado = 'N' )
					</cfif>
				)
		</cfquery>
		<cfreturn rs_cantcuotaspagadas.pagadas >
	</cffunction>	

	<!---	RESULTADO:
			Calcula la cantidad de meses que han sido pagados.
			Debe tomar en cuenta la periodicidad con que se registro el pago.
	--->
	<cffunction name="obtenerMesesPagados" output="true" access="public" returntype="numeric" >
		<cfargument name="ACCAid" 		type="string"  required="yes">
		<cfargument name="Ecodigo" 		type="string"  required="no" default="#session.DSN#">		
		<cfargument name="DSN" 	  		type="string"  required="no" default="#session.DSN#">
		<cfargument name="fecha" 	  	type="string"  required="no" default="">		

		<cfset meses_pagados = 0 >	
		<cfquery name="rs_cuotaspagadas" datasource="#arguments.DSN#">
			select ACPPperiodicidad+1 as periodicidad, count(1) as pagos
			from ACPlanPagos
			where ACCAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			and ACPPestado = 'S'
			and ACPPtipo in ('N','M')
			group by ACPPperiodicidad
		
			<cfif len(trim(arguments.fecha)) >
				union 
				select ACPPperiodicidad+1 as periodicidad, count(1) as pagos
				from ACPlanPagos
				where ACCAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
				and ACPPestado = 'N'
				and ACPPfecha <  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
				group by ACPPperiodicidad
			</cfif>
		</cfquery>
		<cfif rs_cuotaspagadas.recordcount gt 0>
			<cfloop query="rs_cuotaspagadas">
				<cfif len(trim(rs_cuotaspagadas.periodicidad)) and len(trim(rs_cuotaspagadas.pagos))>
					<cfset dias_periodo  = this.obtenerParametro(Ecodigo, this.parametro[rs_cuotaspagadas.periodicidad], DSN) >
					<cfset dias_mes      = this.obtenerParametro(Ecodigo, 60, DSN) >
					
					<cfset lista_periodos = 'semanal,bisemanal,quincenal,mensual' >
					<cfif len(trim(dias_periodo)) eq 0><cfthrow detail="Error. No ha definido el factor de d&iacute;as de n&oacute;mina #listgetat(lista_periodos, rs_cuotaspagadas.periodicidad)# "></cfif>
					<cfif len(trim(dias_mes)) eq 0><cfthrow detail="Error. No ha definido el factor de d&iacute;as de n&oacute;mina mensual "></cfif>
					<cfif dias_mes eq 0><cfthrow detail="Error. El factor de d&iacute;as de n&oacute;mina mensual no puede ser cero"></cfif>
					
					<cfset meses_pagados = meses_pagados +  ((rs_cuotaspagadas.pagos*dias_periodo)/dias_mes) >
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn meses_pagados >
	</cffunction>	

	<!---	RESULTADO:
			Modificacion masiva del estado del plan de pagos.
	--->
	<cffunction name="modificarEstadoPlan" output="true" access="public" >
		<cfargument name="ACCAid" 		 type="string"  required="yes">
		<cfargument name="estado_nuevo"	 type="string"  required="yes">
		<cfargument name="ACPPid" 		 type="string"  required="no" default="">
		<cfargument name="estado_filtro" type="string"  required="no" default="">
		<cfargument name="fecha" 		 type="string"  required="no" default="">
		<cfargument name="Ecodigo" 		 type="string"  required="no" default="#session.DSN#">		
		<cfargument name="DSN" 	  		 type="string"  required="no" default="#session.DSN#">		

		<cfquery datasource="#arguments.DSN#">
			update ACPlanPagos 
			set ACPPestado=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.estado_nuevo#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where ACCAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			<cfif len(trim(arguments.fecha))>
				and ACPPfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			</cfif>
			<cfif len(trim(arguments.estado_filtro))>
				and ACPPestado = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.estado_filtro#">
			</cfif>	
			<cfif len(trim(arguments.ACPPid))>
				and ACPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACPPid#">
			</cfif>	
		</cfquery>
	</cffunction>	
	
	<!---	RESULTADO:
			Se usa para calculo de informacion del credito cuando se regenera el plan de pagos desde una accion de personal.
			Si antes de la fecha rige de la accion de cambio de tipo de nomina, hay pagos pendientes por hacer, estso deben 
			realizarse con la nomina del empleado en ese moneto, osea el plan de pagos debe manener esos registros intactos.
			Esta funcion devuelve el monto por pagar de esos pagos pendientes antes del cambio de tipo de nomina.
	--->
	<cffunction name="obtenerMontoPendiente" output="true" access="public" >
		<cfargument name="ACCAid" type="string"  required="yes">
		<cfargument name="fecha"  type="string"  required="yes">
		<cfargument name="DSN"    type="string"  required="yes">
	
		<cfquery name="rs_monto" datasource="#arguments.DSN#">
			select coalesce(sum(ACPPpagoPrincipal), 0) as monto
			from ACPlanPagos
			where ACPPestado ='N'
			and ACPPfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			and ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
		</cfquery>	
		<cfreturn rs_monto.monto >	
	</cffunction>

	<!---	RESULTADO:
			Regenera el plan de pagos cuando se cambia el tipo de nomina de un asociado.
	--->
	<cffunction name="regenerarPlan" output="true" access="public" >
		<cfargument name="ACCAid" 	type="numeric"  required="yes">
		<cfargument name="Tcodigo"  type="string"  required="yes">
		<cfargument name="fecha"  	type="string"  required="yes">	<!--- fecha rige de la accion --->
		<cfargument name="Ecodigo" 	type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="DSN"    	type="string"  required="no" default="#session.DSN#">
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		
		<!--- 1. modifica datos del credito --->	
		<cfquery datasource="#arguments.DSN#">
			update ACCreditosAsociado
			set Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">,
				ACCAperiodicidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.obtenerTipoPago(arguments.Ecodigo, arguments.Tcodigo)-1#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
		</cfquery>
		
		<!--- 2. regenera el plan de pagos  --->
		<cfset this.crearPlan( 	arguments.ACCAid,
								true,
								arguments.BMUsucodigo,
								arguments.Ecodigo,
								arguments.DSN,
								arguments.fecha )>
	</cffunction>

</cfcomponent>