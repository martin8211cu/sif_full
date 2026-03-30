<cfcomponent>
	<cffunction name="siguienteMesPeriodo" output="true" access="private" returntype="struct">
		<cfargument name="periodo"	type="numeric" required="yes">
		<cfargument name="mes" 		type="numeric" required="yes">

		<cfset s_PeriodoMes = structnew() >
		<cfset s_PeriodoMes.mes 	= arguments.mes >
		<cfset s_PeriodoMes.periodo = arguments.periodo >				

		<cfif arguments.mes eq 12 >
			<cfset s_PeriodoMes.mes 	= 1 >
			<cfset s_PeriodoMes.periodo = arguments.periodo+1 >
		<cfelse>
			<cfset s_PeriodoMes.mes = arguments.mes+1 >
		</cfif>
		<cfreturn s_PeriodoMes >
	</cffunction>

	<cffunction name="cierreMes" output="true" access="public">
		<cfargument name="periodo" 		type="numeric" required="yes">
		<cfargument name="mes" 			type="numeric" required="yes">
		<cfargument name="BMUsucodigo" 	type="string" required="no" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" 		type="string" required="no" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"  required="no" default="#session.DSN#">		
	
		<!--- 	1. 	Calcula los intereses del mes. 
					Hace el calculo tomando el saldo inicial del mes (tabla ACAportesSaldos, campo ACAAsaldoInicial) y aplicandole el 
					porcentaje definido segun el tipo de aporte (tabla ACAportesTipo, campo ACATtasa).
					Es un proceso masivo.
		--->
		<cfquery datasource="#arguments.DSN#">
			update ACAportesSaldos
			set ACAAaporteMesInt = round(coalesce(ACAAsaldoInicial, 0)*((coalesce(( select distinct c.ACATtasa
																					from ACAportesAsociado a
																					inner join ACAportesSaldos b
																						  on b.ACAAid = a.ACAAid
																					inner join ACAportesTipo c
																						  on c.ACATid = a.ACATid 
																					where a.ACAAid = ACAportesSaldos.ACAAid
																					  and b.ACASperiodo =  ACAportesSaldos.ACASperiodo
																					  and b.ACASmes = ACAportesSaldos.ACASmes
																					  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
																			), 0)) / 100.0),2)
			where ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
		</cfquery>
		
		<!---	2.	Abre el nuevo mes: inserta un registro en ACAportesSaldos para el mes/periodo siguientes a
					los pasados en los argumentos. El saldo inicial debe ser al suma del saldo inicial mas aportes 
					del mes, par ael mes de cierre. Aplica lo mismo para los intereses, el saldo inicial de interes
					es igual al saldo inicial de interes mas los aportes de intereses del mes, para el mes y perio 
					de cierre.
		--->
		<!--- 2.1 	calcula el periodo y mes siguiente al actual --->
		<cfset s_periodo = siguienteMesPeriodo(arguments.periodo, arguments.mes) >
		
		<!--- 2.2 	Abre el nuevo mes --->
		<cfquery datasource="#arguments.DSN#">
			insert into ACAportesSaldos( ACAAid, ACASperiodo, ACASmes, ACAAsaldoInicial, ACAAaporteMes, ACAAsaldoInicialInt, ACAAaporteMesInt, 
										DEid,Did,DClinea,ACAStipo,BMUsucodigo, BMfecha )
			select aa.ACAAid,
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#s_periodo.periodo#">,
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#s_periodo.mes#">,
				   s.ACAAsaldoInicial + s.ACAAaporteMes as saldoInicial,
				   0 as aportesMes, 
				   s.ACAAsaldoInicialInt + s.ACAAaporteMesInt as saldoInicial_interes, 
				   0  as aportesMes_interes,
				   a.DEid,t.TDid,t.DClinea,'N',
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">,
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			
			from ACAportesSaldos s, ACAportesAsociado aa, ACAportesTipo t, ACAsociados a
			where s.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			  and s.ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
			  and t.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and aa.ACAAid=s.ACAAid
			  and t.ACATid=aa.ACATid
			  and a.ACAid=aa.ACAid
			  and s.ACAStipo <> 'L'
		</cfquery>
		

		<!---	3.	mueve los parametros de mes(20) y periodo(10) de asociacion al mes y periodo siguientes--->	
		<!--- 	3.1. mes --->
		<cfquery datasource="#arguments.DSN#">
			update ACParametros
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#s_periodo.mes#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and Pcodigo = 20
		</cfquery>
		<!--- 	3.1. periodo --->
		<cfquery datasource="#arguments.DSN#">
			update ACParametros
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#s_periodo.periodo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
			  and Pcodigo = 10
		</cfquery>
	</cffunction>
 </cfcomponent>