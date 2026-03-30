<cfcomponent>
	<!--- FUNCION PARA CALCULO DE LOS APORTES DEL ASOCIADO --->
	<cffunction name="CalculaAportes" access="public" returntype="query">
		<cfargument name="ACAid" 	type="numeric" required="yes">
		<cfargument name="DEid" 	type="numeric" 	required="yes">
		<cfargument name="fechafin" type="date" 	required="no" default="01/01/6100">
		<cfargument name="DSN" 		type="string" 	required="no" default="#session.DSN#">		
			<cfset Lvar_FechaFin = arguments.fechafin>
			<!--- BUSCA LOS APORTES QUE HA TENIDO EL ASOCIADO --->
			<cfquery name="rsAportes" datasource="#Arguments.DSN#">
				select a.ACAid, b.ACAAid, sum(ACAAaporteMes) + sum(ACAAaporteMesInt) as Aporte
				from ACAsociados a
				inner join ACAportesAsociado b
					on b.ACAid = a.ACAid
				inner join ACAportesSaldos e
					on e.ACAAid = b.ACAAid
				inner join DeduccionesEmpleado c
					  on c.Did = b.Did
					  and c.Dactivo = 1
				inner join ACLineaTiempoAsociado d
					  on d.ACAid = a.ACAid
				where a.ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
				  and b.DClinea is null
				  and b.ACAestado = 0
				  and coalesce(c.Dfechaini,<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">) between d.ACLTAfdesde and d.ACLTAfhasta 
				group by  a.ACAid, b.ACAAid 
				
				union

				select a.ACAid, b.ACAAid, sum(ACAAaporteMes) + sum(ACAAaporteMesInt) as Aporte
				from ACAsociados a
				inner join ACAportesAsociado b
				on b.ACAid = a.ACAid
				inner join ACAportesSaldos e
				on e.ACAAid = b.ACAAid
				inner join CargasEmpleado c
				  on c.DEid = a.DEid
				  and c.DClinea = b.DClinea
				inner join ACLineaTiempoAsociado d
				  on d.ACAid = a.ACAid
				where a.ACAid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
				and b.Did is null
				and b.ACAestado = 0
				and coalesce(c.CEhasta,<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">) between d.ACLTAfdesde and d.ACLTAfhasta 
				group by  a.ACAid, b.ACAAid 
			</cfquery>
			<cfreturn rsAportes>
	</cffunction>
	
	<!--- FUNCION PARA EL CALCULO DE LOS CREDITOS DEL ASOCIADO --->
	<cffunction name="CalculaCreditos" access="public" returntype="query">
		<cfargument name="ACAid" type="string" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="DSN" 	type="string" 	required="no" default="#session.DSN#">		

		 <cf_dbtemp name="salidaCretidos" returnvariable="CreditosLiq">
		 	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="ACCAid"   		type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Capital"   		type="money"     	mandatory="yes">
			<cf_dbtempcol name="Intereses"		type="money"		mandatory="no">
			<cf_dbtempcol name="SaldoCap"		type="money"		mandatory="no">
			<cf_dbtempcol name="SaldoInt"		type="money"		mandatory="no">
			<cf_dbtempkey cols="DEid,ACCAid">
		</cf_dbtemp>
		
		<cfquery name="rsAsociados" datasource="#Arguments.DSN#">
			insert into #CreditosLiq# (DEid,ACCAid,Capital)
			select a.DEid, ACCAid,sum(ACCTcapital) as Capital
			from DatosEmpleado a
			inner join ACAsociados b
				on b.DEid = a.DEid
			inner join ACCreditosAsociado c
				  on c.ACAid = b.ACAid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  and c.ACCTfechaInicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			  and (c.ACCTcapital - c.ACCTamortizado) >= 0
			  and c.ACCestado = 0
			group by a.DEid,ACCAid
		</cfquery>
		<!--- ACTUALIZA LOS INTERESES DE LOS CREDITOS PARA CADA ASOCIADO --->
		<cfquery name="rsIntereses" datasource="#Arguments.DSN#">
			update #CreditosLiq#
			set Intereses = coalesce((select sum(ACPPpagoInteres)
							from ACAsociados a
							inner join ACCreditosAsociado b
								  on b.ACAid = a.ACAid
								  and (b.ACCTcapital - b.ACCTamortizado) > 0
							inner join ACPlanPagos c
								  on c.ACCAid = b.ACCAid
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							  and b.ACCAid = #CreditosLiq#.ACCAid
							  and b.ACCestado = 0
							),0.00)
			
		</cfquery>
		<!--- ACTUALIZA EL SALDO DE LOS CREDITOS PARA CADA ASOCIADO --->
		<cfquery name="rsSaldoCap" datasource="#Arguments.DSN#">
			update #CreditosLiq#
			set SaldoCap = coalesce((select sum(ACPPpagoPrincipal)
							from ACAsociados a
							inner join ACCreditosAsociado b
								  on b.ACAid = a.ACAid
								  and (b.ACCTcapital - b.ACCTamortizado) > 0
							inner join ACPlanPagos c
								  on c.ACCAid = b.ACCAid
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							  and ACPPestado = 'N'
							  and b.ACCAid = #CreditosLiq#.ACCAid
							  and b.ACCestado = 0
							),0.00)
		</cfquery>
		<!--- ACTUALIZA EL SALDO DE LOS INTERESES DE LOS CREDITOS PARA CADA ASOCIADO --->
		<cfquery name="rsSaldoInt" datasource="#Arguments.DSN#">
			update #CreditosLiq#
			set SaldoInt = coalesce((select sum(ACPPpagoInteres)
							from ACAsociados a
							inner join ACCreditosAsociado b
								  on b.ACAid = a.ACAid
								  and (b.ACCTcapital - b.ACCTamortizado) > 0
							inner join ACPlanPagos c
								  on c.ACCAid = b.ACCAid
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							  and b.ACCAid = #CreditosLiq#.ACCAid
							  and ACPPestado = 'N'
							  and b.ACCestado = 0
							),0.00)
		</cfquery>
		<cfquery name="rs" datasource="#Arguments.DSN#">
			select *
			from #CreditosLiq#
			where SaldoCap > 0
		</cfquery>
		<cfreturn rs>
	</cffunction>
	<!--- GENERAR LOS REGISTROS DE LA LIQUIDACIÓN --->
	<cffunction name="GeneraLiquidacion" access="public" returntype="numeric">
		<cfargument name="ACAid" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="fechafin" type="date" required="no" default="01/01/6100">
		<cfargument name="DSN" 	type="string" 	required="no" default="#session.DSN#">		
		<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
		<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
        <cfset Lvar_Mes 		= Parametros.Get("20",	"Mes")>
		<cftransaction>
			<!--- INSERTA EL REGISTRO DE LA LIQUIDACIÓN --->
			<cfquery name="insertLiq" datasource="#Arguments.DSN#">
				insert into ACLiquidacion(ACAid, ACLfecha, ACLmontoAhorros, ACLmontoCreditos, BMUsucodigo, BMfecha)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">,
					   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					   0,
					   0,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			  <cf_dbidentity1 datasource="#Arguments.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.DSN#" name="insertLiq">
			<cfset ACLid = insertLiq.identity>
			<!--- BUSCA LOS APORTES QUE TIENE EL ASOCIADO --->
			<cfset rsAportes = CalculaAportes(Arguments.ACAid,Arguments.DEid)>
			<cfif rsAportes.RecordCount>
				<cfquery name="rsTotalAhorros" dbtype="query">
					select sum(Aporte) as Total
					from rsAportes
				</cfquery>

				<!--- SI HAY APORTES, INGRESA EL TOTAL DE APORTES --->
				<cfquery name="InsertAhorros" datasource="#Arguments.DSN#">
					update ACLiquidacion
					set ACLmontoAhorros = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalAhorros.Total#"> 
					where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">
				</cfquery>
				<!--- INSERTA EL DETALLE DE LOS APORTES --->
				<cfoutput query="rsAportes">
					<cfquery name="InsertAportes" datasource="#Arguments.DSN#">
						insert into ACDLiquidacion (ACLid, ACAAid, ACDLmonto, BMUsucodigo, BMfecha)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAportes.ACAAid#">,
							   <cfqueryparam cfsqltype="cf_sql_money" value="#rsAportes.Aporte#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   		   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				</cfoutput>
				
			</cfif>
			<cfset rsCreditos = CalculaCreditos(Arguments.ACAid,Arguments.DEid)>
			<cfif rsCreditos.RecordCount>
				<cfquery name="rsTotalCreditos" dbtype="query">
					select sum(SaldoCap + SAldoInt) as Total
					from rsCreditos
				</cfquery>
				<!--- SI HAY CRETIDOS, INGRESA EL TOTAL DE CREDITOS--->
				<cfquery name="InsertAhorros" datasource="#Arguments.DSN#">
					update ACLiquidacion
					set ACLmontoCreditos = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalCreditos.Total#"> 
					where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">
				</cfquery>
				<!--- INSERTA EL DETALLE DE LOS CREDITOS --->
				<cfoutput query="rsCreditos">
					<cfquery name="InsertCreditos" datasource="#Arguments.DSN#">
						insert into ACDLiquidacion (ACLid, ACCAid, ACDLmonto, BMUsucodigo, BMfecha)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCreditos.ACCAid#">,
							   <cfqueryparam cfsqltype="cf_sql_money" value="#rsCreditos.SaldoCap+rsCreditos.SaldoInt#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   		   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				</cfoutput>
			</cfif>
		</cftransaction>
		<cfreturn ACLid>
	</cffunction>
	<!--- RECALCULA  LOS MONTOS DE LA LIQUIDACIÓN--->
	<cffunction name="RecalcularLiquidacion" access="public" returntype="numeric">
		<cfargument name="ACLid" type="numeric" required="yes">
		<cfargument name="ACAid" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="FechaLiq" type="date" required="yes">
		<cfargument name="DSN" 	type="string" 	required="no" default="#session.DSN#">		
		<cftransaction>
			<!--- SE ELIMINAN LOS REGISTROS DE DETALLE EN CASO QUE HAYA UN NUEVO REGISTRO DE APORTE O CREDITO --->
			<cfquery name="DeleteAportes" datasource="#Arguments.DSN#">
				delete from ACDLiquidacion
				where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACLid#">
			</cfquery>

			<!--- BUSCA LOS APORTES QUE TIENE EL ASOCIADO --->
			<cfset rsAportes = CalculaAportes(Arguments.ACAid,Arguments.DEid)>
			<cfif rsAportes.RecordCount>
				<cfquery name="rsTotalAhorros" dbtype="query">
					select sum(Aporte) as Total
					from rsAportes
				</cfquery>
				<!--- SI HAY APORTES, INGRESA EL TOTAL DE APORTES --->
				<cfquery name="InsertAhorros" datasource="#Arguments.DSN#">
					update ACLiquidacion
					set ACLmontoAhorros = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalAhorros.Total#"> ,
						ACLfecha= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaLiq#">
					where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACLid#">
				</cfquery>
				<!--- INSERTA EL DETALLE DE LOS APORTES --->
				<cfoutput query="rsAportes">
					<cfquery name="InsertAportes" datasource="#Arguments.DSN#">
						insert into ACDLiquidacion (ACLid, ACAAid, ACDLmonto, BMUsucodigo, BMfecha)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACLid#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAportes.ACAAid#">,
							   <cfqueryparam cfsqltype="cf_sql_money" value="#rsAportes.Aporte#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   		   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				</cfoutput>
				
			</cfif>
			<cfset rsCreditos = CalculaCreditos(Arguments.ACAid,Arguments.DEid)>
			<cfif rsCreditos.RecordCount>
				<cfquery name="rsTotalCreditos" dbtype="query">
					select sum(SaldoCap + SAldoInt) as Total
					from rsCreditos
				</cfquery>
				<!--- SI HAY CRETIDOS, INGRESA EL TOTAL DE CREDITOS--->
				<cfquery name="InsertAhorros" datasource="#Arguments.DSN#">
					update ACLiquidacion
					set ACLmontoCreditos = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalCreditos.Total#"> 
					where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACLid#">
				</cfquery>
				<!--- INSERTA EL DETALLE DE LOS CREDITOS --->
				<cfoutput query="rsCreditos">
					<cfquery name="InsertCreditos" datasource="#Arguments.DSN#">
						insert into ACDLiquidacion (ACLid, ACCAid, ACDLmonto, BMUsucodigo, BMfecha)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACLid#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCreditos.ACCAid#">,
							   <cfqueryparam cfsqltype="cf_sql_money" value="#rsCreditos.SaldoCap+rsCreditos.SaldoInt#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   		   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				</cfoutput>
			</cfif>
		</cftransaction>
		<cfreturn ACLid>
	</cffunction>
	<!--- APLICA LA LIQUIDACIÓN --->
	<cffunction name="AplicarLiquidacion" access="public" returntype="string">
		<cfargument name="ACAid" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="ACLid" type="numeric" required="yes">
		<cfargument name="FechaLiq" type="date" required="yes">
		<cfargument name="DSN" 	type="string" 	required="no" default="#session.DSN#">		
		<!--- PROCESO DE LIQUIDACIÓN
			A.CREDITOS
				1. BUSCAR LAS CUOTAS QUE SE TIENEN PENDIENTES PARA CADA UNO DE LOS CREDITOS DEL ASOCIADO
				2. ACTUALIZAR ESTAS CUOTAS INDICANDO QUE SE LIQUIDAN ACPPtipo = 'L'
				3. ACTUALIZAR EL CRÉDITO PARA QUE QUEDE  EN CERO
				4. ACTUALIZAR LA DEDUCCIÓN DEL CREDITO E INACTIVAR LA DEDUCCION
			B.APORTES
				1. BUSCAR LOS APORTES DEL ASOCIADO
				2. GENERAR REGISTRO DE LIQUIDACION, SALDOS ACTUALES NEGATIVOS PARA EL PERIODO/MES ACTUAL
				3. DESACTIVAR DEDUCCIONES Y CARGAS RELACIONADAS
			C.ASOCIADO
				1. INACTIVAR EL ASOCIADO
				2. CAMBIAR LA LINEA DEL TIEMPO DEL ASOCIADO
		 --->
			<cfquery name="UpdateLiquidacion" datasource="#session.DSN#">
				update ACLiquidacion
				set ACLfecha= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaLiq#">
				where ACLid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
			</cfquery>
			 <!--- LIQUIDACION DE CREDITOS --->
			<cfquery name="rsCreditos" datasource="#arguments.DSN#">
				select ACCAid 
				from ACDLiquidacion
				where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
				  and ACCAid is not null
			</cfquery>
			<cfoutput query="rsCreditos">
				<!--- BUSCA LAS CUOTAS PENDIENTES DEL CREDITO --->
				<cfset Cuotas = LiqCreditos(rsCreditos.ACCAid,arguments.DSN)>
			</cfoutput>
			<!--- LIQUIDACION DE APORTES --->
			<cfquery name="rsAportes" datasource="#arguments.DSN#">
				select ACAAid 
				from ACDLiquidacion
				where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
				  and ACAAid is not null
			</cfquery>
		 	<cfquery name="rsDAtosLiquidacion" datasource="#arguments.DSN#">
				select ACLfecha as FechaLiq
				from ACLiquidacion
				where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
			</cfquery>
			<cfoutput query="rsAportes">
			<cfset Aportes = LiqAportes(Arguments.ACLid,Arguments.ACAid,rsAportes.ACAAid,Arguments.DEid,rsDatosLiquidacion.FechaLiq,arguments.DSN)>
			</cfoutput>
			<!--- INACTIVAR USUARIO --->
		 <cftransaction>
			<cfquery name="UpdateLiquidacion" datasource="#session.DSN#">
				update ACLiquidacion
				set ACLfecha= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaLiq#">
				where ACLid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
			</cfquery>
		 
		 	<cfquery name="rsDAtosLiquidacion" datasource="#arguments.DSN#">
				select ACLfecha as FechaLiq
				from ACLiquidacion
				where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
			</cfquery>
			<cfset Inactiva = InactivarAsociado(Arguments.ACAid,Arguments.DSN,rsDatosLiquidacion.FechaLiq)>
			<cfquery name="UpdateLiquidacion" datasource="#session.DSN#">
				update ACLiquidacion
				set ACLestado = 1
				where ACLid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACLid#">
			</cfquery>
		</cftransaction>
		<cfreturn 'ok'>
	</cffunction>	
	
	<!--- FUNCION QUE BUSCA LAS CUOTAS PENDIENTES DE UN CREDITO --->	
	<cffunction name="LiqCreditos" output="true" access="public" returntype="string">
		<cfargument name="ACCAid" 	type="numeric" required="yes">
		<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		
		<cftransaction>
			<!--- ACUTALIZA LAS CUOTAS PENDIENTES INDICANDO QUE SE LIQUIDAN --->
			<cfquery datasource="#arguments.DSN#">
				update ACPlanPagos
				set ACPPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now(), 'dd/mm/yyyy')#">,
					ACPPestado = <cfqueryparam cfsqltype="cf_sql_char" value="S">,
					ACPPtipo = <cfqueryparam cfsqltype="cf_sql_char" value="L">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfecha 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
				  and ACPPestado = 'N'
			</cfquery>
			<!--- BUSCA LAS DEDUCCIONES RELACIONADAS CON EL CRETIDO --->
			<cfquery name="rsDeduccion" datasource="#arguments.DSN#">
				select distinct coalesce(a.Did,0) as Did
				from ACPlanPagos a
				inner join DeduccionesEmpleado b
					  on b.Did = a.Did
				where ACCAid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
				  and Dactivo = 1
			</cfquery>
			<cfset Lvar_Did = ValueList(rsDeduccion.Did)>
			<cfif LEN(TRIM(Lvar_Did))>
				<!--- ACTUALIZA EL ESTADO DE LA DEDUCCIÓN PARA INACTIVARLA Y PONERLA EN CERO --->
				<cfquery name="rsupdateDed" datasource="#session.DSN#">
					update DeduccionesEmpleado
					set Dsaldo = <cfqueryparam cfsqltype="cf_sql_money" value="0">,
						Dactivo = 0,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where Did in (#Lvar_Did#)
				</cfquery>
			</cfif>
			<!--- ACTUALIZA LO AMORTIZADO CON EL MONTO DEL CAPITAL Y EL ESTADO DEL CREDITO COMO INACTIVO --->
			<cfquery datasource="#arguments.DSN#">
				update ACCreditosAsociado
				set ACCTamortizado =  ACCTcapital,
					ACCestado = 1,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfecha 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">				
			</cfquery>		
		</cftransaction>
		<cfreturn 'ok' >
	</cffunction>	

	<cffunction name="LiqAportes" output="true" access="public" returntype="string">
		<cfargument name="ACLid" 	type="numeric" required="yes">
		<cfargument name="ACAid" 	type="numeric" required="yes">
		<cfargument name="ACAAid" 	type="numeric" required="yes">
		<cfargument name="DEid" 	type="numeric" required="yes">
		<cfargument name="FechaLiq" type="date" required="yes">
		<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		
		<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
		<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
        <cfset Lvar_Mes 		= Parametros.Get("20",	"Mes")>
		<cftransaction>
			 <!--- LIQUIDACION DE APORTES --->
			<!--- SE GENERA EL REGISTRO NEGATIVO PARA LA LIQUIDACION DE INTERESES --->
			<cfquery name="rsLiquidacion" datasource="#session.DSN#">
				insert into ACAportesSaldos( ACAAid, ACASperiodo, ACASmes, ACAAsaldoInicial, ACAAaporteMes, ACAAsaldoInicialInt, ACAAaporteMesInt, 
											DEid,Did,DClinea,ACAStipo,BMUsucodigo, BMfecha)
				select a.ACAAid,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
						0,sum(ACAAaporteMes)*-1,
						0,sum(ACAAaporteMesInt)*-1,
						c.DEid,d.TDid,d.DClinea,
						'L',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				from ACAportesAsociado a
				inner join ACAportesSaldos b
					  on b.ACAAid = a.ACAAid
				inner join ACAsociados c
					  on c.ACAid = a.ACAid 	  
				inner join ACAportesTipo d
					  on d.ACATid = a.ACATid				 
				where c.ACAid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
				  and a.ACAAid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAAid#">
				   and b.ACAStipo <> 'L'
				group by c.DEid,a.ACAAid,d.TDid,d.DClinea
				   <cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.DSN#" name="rsLiquidacion">
			<!--- REGISTRO DEL MOVIMIENTOS EN LOS SALOS DEL APORTE --->
			<cfset Lvar_ACSid = rsLiquidacion.identity>
			<cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
				INSERT INTO ACAportesTransacciones 
					  (ACAAid, ACATperiodo, ACATmes, ACATfecha, ACATtipo, ACATafecta, ACATmonto, ACATreferencia, BMUsucodigo, BMfecha)
				select ACAAid, ACASperiodo, ACASmes, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					'L','C',ACAAsaldoInicial+ACAAaporteMes+ACAAsaldoInicialInt+ACAAaporteMesInt, ACASid, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				from ACAportesSaldos
					where ACASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ACSid#">
			</cfquery>
			<!--- MODIFICA LAS CARGAS O DEDUCCIONES RELACIONADAS CON LOS APORTES PARA INACTIVARLAS. --->
			<cfquery name="rsDeducciones" datasource="#session.DSN#">
				select Did
				from ACAportesAsociado
				where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
				  and Did is not null
				  and DClinea is null
			</cfquery>
			<cfquery name="rsCargas" datasource="#session.DSN#">
				select DClinea
				from ACAportesAsociado
				where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
				  and Did is null
				  and DClinea is not null
			</cfquery>
			<cfloop query="rsDeducciones">
				<cfquery name="updateDeduccion" datasource="#session.DSN#">
					update DeduccionesEmpleado
					set Dfechafin = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaLiq#">,
						Dactivo = 0,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.Did#">
				</cfquery>
			</cfloop>
			<cfloop query="rsCargas">
				<cfquery name="updateCargas" datasource="#session.DSN#">
					update CargasEmpleado
					set CEhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaLiq#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">	
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.DClinea#">
				</cfquery>
			</cfloop>
			<!--- MODIFICA EL APORTE PARA INACTIVARLO CUANDO SE HA LIQUIDADO --->
			<cfquery name="InctivaAporte" datasource="#session.DsN#">
				update ACAportesAsociado
				set ACAestado = 1,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfecha =  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
				where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
			</cfquery>
		</cftransaction>
		<cfreturn 'OK'>
	</cffunction>
	
	<cffunction name="InactivarAsociado" output="true" access="public" returntype="string">
		<cfargument name="ACAid" 	type="numeric" required="yes">
		<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		
		<cfargument name="FechaLiq" type="date" required="yes">

		<!--- REVISA LOS DATOS DEL ASOCIADO EN LA LINEA DEL TIEMPO --->
		<cfquery name="rs_vigente" datasource="#arguments.DSN#">
			select ACLTAid as id
			from ACLineaTiempoAsociado
			where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAid#">
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"> between ACLTAfdesde and ACLTAfhasta
		</cfquery>
		<!--- corta la linea de tiempo del asociado a la fecha digitada--->
		<cfquery datasource="#arguments.DSN#">
			update ACLineaTiempoAsociado
			set ACLTAfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.FechaLiq,'dd/mm/yyyy')#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where ACLTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_vigente.id#" >
		</cfquery>
		<!--- modifica las fechas de ingreso/egreso del asociado para mantener actualizado con el corte vigente --->
		<cfquery datasource="#arguments.DSN#">
			update ACAsociados
			set ACAfechaEgreso = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.FechaLiq,'dd/mm/yyyy')#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
		</cfquery>
		<cfset Lvar_Observaciones = 'SE DA DE BAJA POR LIQUIDACION'>
		<cfquery name="rsUpdateACAsociados" datasource="#Session.DSN#">
			update ACAsociados
			set ACAestado = 0,
				ACAobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Observaciones#">
			where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAid#">
		</cfquery>
		<cfreturn 'ok'>
	</cffunction>
</cfcomponent>