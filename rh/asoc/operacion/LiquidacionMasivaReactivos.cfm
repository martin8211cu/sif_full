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
				where a.ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAid#">
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
		
		<cfquery name="rsAsociados1" datasource="#Arguments.DSN#">
			insert into #CreditosLiq# (DEid,ACCAid,Capital)
			select a.DEid, ACCAid,sum(ACCTcapital) as Capital
			from DatosEmpleado a
			inner join ACAsociados b
				on b.DEid = a.DEid
			inner join ACCreditosAsociado c
				  on c.ACAid = b.ACAid
				 and c.ACCTfechaInicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and (c.ACCTcapital - c.ACCTamortizado) >= 0
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
								  and ACPPestado = 'N'
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							  and b.ACCAid = #CreditosLiq#.ACCAid
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
								  and ACPPestado = 'N'
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
							  and b.ACCAid = #CreditosLiq#.ACCAid
							),0.00)
		</cfquery>
		<cfquery name="rs" datasource="#Arguments.DSN#">
			select *
			from #CreditosLiq#
			where SaldoCap > 0
		</cfquery>
		<cfreturn rs>
	</cffunction>

	<!--- FUNCION QUE BUSCA LAS CUOTAS PENDIENTES DE UN CREDITO --->	
	<cffunction name="LiqCreditos" output="true" access="public" returntype="string">
		<cfargument name="ACCAid" 	type="numeric" required="yes">
		<cfargument name="FechaLiq" type="date" required="yes">
		<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		
	<cftransaction>
		<!--- ACTUALIZA LO AMORTIZADO CON EL MONTO DEL CAPITAL --->
		<cfquery datasource="#arguments.DSN#">
			update ACCreditosAsociado
			set ACCTamortizado =  ACCTcapital,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">				
		</cfquery>		
		<!--- ACUTALIZA LAS CUOTAS PENDIENTES INDICANDO QUE SE LIQUIDAN --->
		<cfquery datasource="#arguments.DSN#">
			update ACPlanPagos
			set ACPPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(FechaLiq, 'dd/mm/yyyy')#">,
			    ACPPestado = <cfqueryparam cfsqltype="cf_sql_char" value="S">,
			    ACPPtipo = <cfqueryparam cfsqltype="cf_sql_char" value="L">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
			  and ACPPestado = 'N'
		</cfquery>
		<!--- BUSCA LAS DEDUCCIONES RELACIONADAS CON EL CRETIDO --->
		<cfquery name="rsDeduccion" datasource="#arguments.DSN#">
			select distinct coalesce(Did,0) as Did
			from ACPlanPagos
			where ACCAid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACCAid#">
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
		</cftransaction>
		<cfreturn 'ok' >
	</cffunction>	

<cffunction name="LiqAportes" output="true" access="public" returntype="string">
	<cfargument name="ACAid" 	type="numeric" required="yes">
	<cfargument name="ACAAid" 	type="numeric" required="yes">
	<cfargument name="DEid" 	type="numeric" required="yes">
	<cfargument name="FechaLiq" type="date" required="yes">
	<cfargument name="Periodo" 	type="numeric" required="yes">
	<cfargument name="Mes"	 	type="numeric" required="yes">
	<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">		
	<cfset Lvar_Periodo 	= arguments.Periodo>
	<cfset Lvar_Mes 		= arguments.Mes>
	<cftransaction>
	<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
	<cfset Lvar_PeriodoA 	= Parametros.Get("10",	"Periodo")>
	<cfset Lvar_MesA 		= Parametros.Get("20",	"Mes")>
	 <!--- LIQUIDACION DE APORTES --->
		<cfset Lvar_M = Lvar_Mes>
		<cfset Lvar_MontoMes = 0>
		<cfset Lvar_MontoIntMes = 0>
		<cfloop index="i" from="#Lvar_Periodo#" to="#Lvar_PeriodoA#">
			<cfloop index="j" from="#Lvar_M+1#" to="#Lvar_MesA#">
				<cfquery name="rsAportesAdicionales" datasource="#session.DSN#">
					select coalesce(ACAAAPORTEMES,0) as ACAAAPORTEMES,coalesce(ACAAAPORTEMESINT,0) as ACAAAPORTEMESINT
					from ACAportesSaldos
					where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAportes.ACAAid#">
					  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
					  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#j#">
				</cfquery>
				<cfif rsAportesAdicionales.REcordCount>
				<cfset Lvar_MontoMes = Lvar_MontoMes+rsAportesAdicionales.ACAAAPORTEMES>
				<cfset Lvar_MontoIntMes = Lvar_MontoIntMes+rsAportesAdicionales.ACAAAPORTEMESINT>
				</cfif>
			</cfloop>
			<cfset Lvar_M = 0>
		</cfloop>
		<!--- SE ELIMINA LO GENERADO EN LOS MESES DESPUES DEL REINGRESO --->
		<!--- SE GENERA EL REGISTRO NEGATIVO PARA LA LIQUIDACION DE INTERESES --->
		<cfquery name="rsLiquidacion" datasource="#session.DSN#">
			insert into ACAportesSaldos( ACAAid, ACASperiodo, ACASmes, ACAAsaldoInicial, ACAAaporteMes, ACAAsaldoInicialInt, ACAAaporteMesInt, 
										DEid,Did,DClinea,ACAStipo,BMUsucodigo, BMfecha)
			select a.ACAAid,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
					0,(sum(ACAAaporteMes)-#Lvar_MontoMes#)*-1,
					0,(sum(ACAAaporteMesInt)-#Lvar_MontoIntMes#)*-1,
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
			 group by a.ACAAid,c.DEid,d.TDid,d.DClinea
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
	</cftransaction>
	<cfreturn 'OK'>
</cffunction>

<!--- CORRIGE LOS MONTOS DE LOS MESES DE LOS APORTES. --->
<cffunction name="CorrigeAportes" output="true" access="public" returntype="string">
	<cfargument name="ACAid" 	type="numeric" required="yes">
	<cfargument name="ACAAid" 	type="numeric" required="yes">
	<cfargument name="DEid" 	type="numeric" required="yes">
	<cfargument name="FechaIngreso" type="date" required="yes">
	<cfargument name="DSN" 	  	type="string"  required="no" default="#session.DSN#">	

	<cfset Lvar_Periodo = DatePart('yyyy',FechaIngreso)>
	<cfset Lvar_Mes = DatePart('m',FechaIngreso)>
	<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
	<cfset Lvar_PeriodoA 	= Parametros.Get("10",	"Periodo")>
	<cfset Lvar_MesA 		= Parametros.Get("20",	"Mes")>
	<cfquery name="rsAportesAdicionales" datasource="#session.DSN#">
		update ACAportesSaldos
		set ACAAsaldoInicial = 0,
			ACAASALDOINICIALINT = 0
		where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAAid#">
		  and ACASperiodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
		  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
	</cfquery>
	<cfloop index="i" from="#Lvar_Periodo#" to="#Lvar_PeriodoA+1#">
		<cfif Lvar_Periodo EQ Lvar_PeriodoA><cfset Lvar_M = Lvar_MesA><cfelse> <cfset Lvar_M = 12></cfif>
		<cfloop index="j" from="#Lvar_Mes+1#" to="#Lvar_M#">
			<!--- VERIFICAR EL SALDO INICIAL DEL MES ANTERIOR Y SUMARLO AL SALDO INICIAL--->
			<cfset Lvar_MesAnt = j -1>
			<cfset Lvar_PeriodoAnt = i>
			<cfif Lvar_MesAnt EQ 0>
				<cfset Lvar_MesAnt = 12>
				<cfset Lvar_PeriodoAnt = i-1>
			</cfif>
			<cfquery name="rsAportesAdicionales" datasource="#session.DSN#">
				update ACAportesSaldos
				set ACAAsaldoInicial = (select ACAAsaldoInicial + ACAAaporteMes
										from ACAportesSaldos a
										where a.ACAAid = ACAportesSaldos.ACAAid 
										  and a.ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_MesAnt#">
										  and a.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">
										  and a.ACASTipo = 'N'),
					ACAASALDOINICIALINT = (select ACAASALDOINICIALINT + ACAAaporteMesInt
										from ACAportesSaldos a
										where a.ACAAid = ACAportesSaldos.ACAAid 
										  and a.ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_MesAnt#">
										  and a.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">
										  and a.ACASTipo = 'N')
				where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAAid#">
				  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#j#">
			</cfquery>
		</cfloop>
		<cfset Lvar_Mes = 0>
	</cfloop>
	<cfset Lvar_Periodo = DatePart('yyyy',FechaIngreso)>
	<cfset Lvar_Mes = DatePart('m',FechaIngreso)>
	<cfquery datasource="#arguments.DSN#">
		update ACAportesSaldos
		set ACAAaporteMesInt = round(coalesce(ACAAsaldoInicial, 0)*((coalesce(( 	select ACATtasa
																			from ACAportesTipo t, ACAportesAsociado aa, ACAportesSaldos s
																			 where aa.ACATid=t.ACATid
																				and s.ACAAid=aa.ACAAid
																				and aa.ACAAid=ACAportesSaldos.ACAAid
																				and s.ACASperiodo = ACAportesSaldos.ACASperiodo
																				and s.ACASmes = ACAportesSaldos.ACASmes
																				and t.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		), 0)) / 100.0),2)
		where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAAid#">
		  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
		  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
	</cfquery>
	<cfloop index="i" from="#Lvar_Periodo#" to="#Lvar_PeriodoA+1#">
		<cfif Lvar_Periodo EQ Lvar_PeriodoA><cfset Lvar_M = Lvar_MesA><cfelse> <cfset Lvar_M = 12></cfif>
		<cfloop index="j" from="#Lvar_Mes+1#" to="#Lvar_M#">
			<!--- VERIFICAR EL SALDO INICIAL DEL MES ANTERIOR Y SUMARLO AL SALDO INICIAL--->
			<cfset Lvar_MesAnt = j -1>
			<cfset Lvar_PeriodoAnt = i>
			<cfif Lvar_MesAnt EQ 0>
				<cfset Lvar_MesAnt = 12>
				<cfset Lvar_PeriodoAnt = i-1>
			</cfif>
			<cfif not (Lvar_MesA EQ j and Lvar_PeriodoA EQ i)>
			<!--- GENERAR LOS INTERESES PARA LOS MESES ANTERIORES AL ACTUAL---> 
				<cfquery datasource="#arguments.DSN#">
					update ACAportesSaldos
					set ACAAaporteMesInt = round(coalesce(ACAAsaldoInicial, 0)*((coalesce(( 	select ACATtasa
																						from ACAportesTipo t, ACAportesAsociado aa, ACAportesSaldos s
																						 where aa.ACATid=t.ACATid
																							and s.ACAAid=aa.ACAAid
																							and aa.ACAAid=ACAportesSaldos.ACAAid
																							and s.ACASperiodo = ACAportesSaldos.ACASperiodo
																							and s.ACASmes = ACAportesSaldos.ACASmes
																							and t.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																					), 0)) / 100.0),2)
					where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAAid#">
					  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
					  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#j#">
				</cfquery>
			</cfif>
			<cfquery name="rsAportesAdicionales" datasource="#session.DSN#">
				update ACAportesSaldos
				set ACAASALDOINICIALINT = (select ACAASALDOINICIALINT + ACAAaporteMesInt
										from ACAportesSaldos a
										where a.ACAAid = ACAportesSaldos.ACAAid 
										  and a.ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_MesAnt#">
										  and a.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">
										  and a.ACASTipo = 'N')
				where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ACAAid#">
				  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#j#">
			</cfquery>

		</cfloop>
		<cfset Lvar_Mes = 0>
	</cfloop>

</cffunction>
<!--- ASOCIADOS QUE HAN SIDO ACTIVADOS DE NUEVO --->
<cfquery name="rsAsociados" datasource="#session.DSN#">
	select a.ACAid,a.DEid,min(ACLTAFHASTA) as FechaEgreso,a.ACAFECHAINGRESO,a.ACAFechaEgreso
	from ACAsociados a
	inner join ACLineaTiempoAsociado b
		  on b.ACAid = a.ACAid
	where coalesce(ACAfechaegreso,to_date('01/01/6100','dd/mm/yyyy')) > sysdate
	  and DEid in(select b.DEid
					from ACLineaTiempoAsociado a
					inner join ACAsociados b
						  on b.ACAid = a.ACAid
					inner join DatosEmpleado c
						  on c.DEid = b.DEid
					group by a.ACAid,b.DEid,c.DEidentificacion
					having count(*) >= 2)
	group by a.ACAid,a.DEid,a.ACAFECHAINGRESO,a.ACAFechaEgreso
</cfquery>

<cfoutput>Asociados = #rsAsociados.RecordCount#</cfoutput><br>
<cftransaction>
<cfloop query="rsAsociados">
	<!--- LIMPIAR LOS MESES DONDE ESTUVO INACTIVA LA PERSONA Y SE GENERARON INTERESES --->
	<cfset Lvar_FechaIngreso = rsAsociados.ACAFECHAINGRESO>
	<cfset Lvar_MesA 		= datePart('m',rsAsociados.ACAFECHAINGRESO)-1>
	<cfset Lvar_PeriodoA 	= datePart('yyyy',rsAsociados.ACAFECHAINGRESO)><!--- FECHA DE PRIMER EGRESO - UN MES --->
	<cfif Lvar_MesA EQ 0>
		<cfset Lvar_MesA = 12>
		<cfset Lvar_PeriodoA = Lvar_PeriodoA - 1>
	</cfif>
	<cfset Lvar_ACAid = rsAsociados.ACAid>
	<cfset Lvar_DEid = rsAsociados.DEid>
	<cfset Lvar_FechaEgreso = rsAsociados.fechaEgreso>
	<cfset Lvar_Periodo = DatePart('yyyy',Lvar_FechaEgreso)>
	<cfset Lvar_Mes = DatePart('m',Lvar_FechaEgreso)>
	<!--- LIQUIDACION DE APORTES --->
	<cfquery name="rsAportes" datasource="#session.DSN#">
		select ACAAid 
		from ACAportesAsociado
		where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ACAid#">
	</cfquery>
	<cfoutput>Asociado #Lvar_ACAid#&nbsp;&nbsp;&nbsp;Fecha de Egreso #LSDateFormat(Lvar_FechaEgreso,'dd/mm/yyyy')# Aportes<br></cfoutput>
	<cfoutput query="rsAportes">
		<cfset Lvar_M = Lvar_Mes>
		<cfloop index="i" from="#Lvar_Periodo#" to="#Lvar_PeriodoA#">
			<cfloop index="j" from="#Lvar_M+1#" to="#Lvar_MesA#">
				Periodo&nbsp;&nbsp;#i#&nbsp;&nbsp;Mes&nbsp;&nbsp;#j# Aporte #rsAportes.ACAAid#<br />
				<cfquery name="rsResetPostMeses" datasource="#session.DSN#">
					update ACAportesSaldos
					set ACAASALDOINICIAL = 0,
						ACAAAPORTEMES = 0,
						ACAASALDOINICIALINT = 0,
						ACAAAPORTEMESINT = 0
					where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAportes.ACAAid#">
					  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
					  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#j#">
				</cfquery>
			</cfloop>
			<cfset Lvar_M = 0>
		</cfloop>
		<!--- <cfoutput>Aporte #rsAportes.ACAAid#<br></cfoutput> --->
	</cfoutput>
	
	<!--- CREA UN REGISTRO DE LIQUIDACION --->
		<cftransaction>
			<!--- INSERTA EL REGISTRO DE LA LIQUIDACIÓN --->
			<cfquery name="insertLiq" datasource="#session.DSN#">
				insert into ACLiquidacion(ACAid, ACLfecha, ACLmontoAhorros, ACLmontoCreditos, BMUsucodigo, BMfecha)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAsociados.ACAid#">,
					   <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">,
					   0,
					   0,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			  <cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertLiq">
			<cfset ACLid = insertLiq.identity>
			<!--- BUSCA LOS APORTES QUE TIENE EL ASOCIADO --->
			<cfset rsAportes = CalculaAportes(rsAsociados.ACAid,rsAsociados.DEid)>
			<cfif rsAportes.RecordCount>
				<cfquery name="rsTotalAhorros" dbtype="query">
					select sum(Aporte) as Total
					from rsAportes
				</cfquery>

				<!--- SI HAY APORTES, INGRESA EL TOTAL DE APORTES --->
				<cfquery name="InsertAhorros" datasource="#session.DSN#">
					update ACLiquidacion
					set ACLmontoAhorros = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalAhorros.Total#"> 
					where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">
				</cfquery>
				<!--- INSERTA EL DETALLE DE LOS APORTES --->
				<cfoutput query="rsAportes">
					<cfquery name="InsertAportes" datasource="#session.DSN#">
						insert into ACDLiquidacion (ACLid, ACAAid, ACDLmonto, BMUsucodigo, BMfecha)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAportes.ACAAid#">,
							   <cfqueryparam cfsqltype="cf_sql_money" value="#rsAportes.Aporte#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					   		   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				</cfoutput>
				
			</cfif>
			<cfset rsCreditos = CalculaCreditos(rsAsociados.ACAid,rsAsociados.DEid)>
			<cfif rsCreditos.RecordCount>
				<cfquery name="rsTotalCreditos" dbtype="query">
					select sum(SaldoCap + SAldoInt) as Total
					from rsCreditos
				</cfquery>
				<!--- SI HAY CRETIDOS, INGRESA EL TOTAL DE CREDITOS--->
				<cfquery name="InsertAhorros" datasource="#session.DSN#">
					update ACLiquidacion
					set ACLmontoCreditos = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalCreditos.Total#"> 
					where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">
				</cfquery>
				<!--- INSERTA EL DETALLE DE LOS CREDITOS --->
				<cfoutput query="rsCreditos">
					<cfquery name="InsertCreditos" datasource="#session.DSN#">
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
	
	<!--- APLICA LA LIQUIDACION --->
	<cfquery name="UpdateLiquidacion" datasource="#session.DSN#">
		update ACLiquidacion
		set ACLestado = 1
		where ACLid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACLid#">
	</cfquery>
	<!--- LIQUIDACION DE APORTES --->
	<cfquery name="rsAportes" datasource="#session.DSN#">
		select ACAAid 
		from ACAportesAsociado
		where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ACAid#">
	</cfquery>
	<cfoutput query="rsAportes">
	<cfset Lvar_Periodo = DatePart('yyyy',Lvar_FechaEgreso)>
	<cfset Lvar_Mes = DatePart('m',Lvar_FechaEgreso)>
	<cfset Aportes = LiqAportes(Lvar_ACAid,rsAportes.ACAAid,Lvar_DEid,Lvar_FechaEgreso,Lvar_Periodo,Lvar_mes,session.DSN)>
	<cfset AportesUpd = CorrigeAportes(Lvar_ACAid,rsAportes.ACAAid,Lvar_DEid,Lvar_FechaIngreso)>
	</cfoutput>
	 <!--- LIQUIDACION DE CREDITOS --->
	<cfquery name="rsCreditos" datasource="#session.DSN#">
		select ACCAid 
		from ACCreditosAsociado
		where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ACAid#">
		  and (ACCTcapital - ACCTamortizado) >= 0
		  and ACCTFECHAINICIO < <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaIngreso#">
	</cfquery>
	<cfoutput>Asociado #Lvar_DEid#&nbsp;&nbsp;&nbsp;Fecha de Egreso #Lvar_FechaEgreso# Creditos<br></cfoutput>
	<cfoutput query="rsCreditos">
		<!--- BUSCA LAS CUOTAS PENDIENTES DEL CREDITO --->
		Credito #rsCreditos.ACCAid#<br>
		<cfset Cuotas = LiqCreditos(rsCreditos.ACCAid,Lvar_FechaEgreso,session.DSN)>
	</cfoutput>
	<br>
	<br>
</cfloop>

