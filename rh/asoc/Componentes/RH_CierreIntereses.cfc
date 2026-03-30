<!--- 
	PROCESO DE CIERRE DE PERIODO
	CUANDO SE HACE CIERRE DE MES ACTUAL, SE HACE CALCULO DE INTERESES Y SE CREA EL NUEVO REGISTRO PARA EL SIGUIENTE MES
	EL SIGUIENTE MES LLEVA EN EL ACUMULADO DEL MES LA SUMA DEL ACUMULADO Y EL APORTE DEL MES DEL MES QU, INCLUYENDO LOS INTERESES
	EL PROCESO DE CIERRE DE INTERESES DE PERIODO,LO QUE HACE ES CREAR UN REGISTRO NEGATIVO EN LOS SALDOS DE LOS APORTES, 
	POR EL MONTO DEL ACUMULADO DEL MES ACTUAL Y LUEGO ACTUALIZA EL MES ACTUAL, PONIENDO EN EL ACUMULADO CERO.
	AL FINAL SE ACTUALIZAN LOS PARAMETROS DE PERIODO Y MES DE LOS INTERESES. ESTOS LLEVAN EL PERIODO MES QUE SE ESTA ACTUALIZANDO EN CERO.
 --->

<cfcomponent>
	<cffunction name="CierreIntereses" access="public" returntype="string">
		<cfargument name="periodo"		type="numeric" required="yes">
		<cfargument name="mes" 			type="numeric" required="yes">
		<cfargument name="BMUsucodigo" 	type="string" required="no" default="#session.Usucodigo#">
		<cfif Arguments.mes EQ 1>
			<cfset Lvar_MesInt = 12>
			<cfset Lvar_PeriodoInt = Arguments.periodo -1>
		<cfelse>
			<cfset Lvar_MesInt = Arguments.mes - 1>
			<cfset Lvar_PeriodoInt = Arguments.periodo>
		</cfif>
		<cftransaction>
			<!--- SE GENERA EL REGISTRO NEGATIVO PARA LA LIQUIDACION DE INTERESES --->
			<cfquery name="rsLiquidacion" datasource="#session.DSN#">
				insert into ACAportesSaldos( ACAAid, ACASperiodo, ACASmes, ACAAsaldoInicial, ACAAaporteMes, ACAAsaldoInicialInt, ACAAaporteMesInt, 
											DEid,Did,DClinea,ACAStipo,BMUsucodigo, BMfecha)
				select a.ACAAid,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoInt#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_MesInt#">,
						0,0,0,ACAAsaldoInicialInt*-1 as AporteMesInt,c.DEid,d.TDid,d.DClinea,
						'L',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				from ACAportesAsociado a
				inner join ACAportesSaldos b
					  on b.ACAAid = a.ACAAid
				inner join ACAsociados c
					  on c.ACAid = a.ACAid 	  
				inner join ACAportesTipo d
					  on d.ACATid = a.ACATid				 
				where ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
				  and ACASmes 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
				   <cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.DSN#" name="rsLiquidacion">
			<!--- REGISTRO DEL MOVIMIENTOS EN LOS SALOS DEL APORTE --->
			<cfset Lvar_ACSid = rsLiquidacion.identity>
			<cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
				INSERT INTO ACAportesTransacciones 
					  (ACAAid, ACATperiodo, ACATmes, ACATfecha, ACATtipo, ACATafecta, ACATmonto, ACATreferencia, BMUsucodigo, BMfecha)
				select ACAAid, ACASperiodo, ACASmes, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					'L','C',ACAAsaldoInicial+ACAAaporteMes+ACAAsaldoInicialInt+ACAAaporteMesInt, ACSid, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				from ACAportesSaldos
				where ACSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ACSid#">
			</cfquery>
			
			<!--- ACTUALIZA LOS ACUMULADOS PARA EL PERIODO/MES ACTUAL --->
			<cfquery name="UpdateAcum" datasource="#session.DSN#">
				update ACAportesSaldos
				set ACAAsaldoInicialInt = 0
				where ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
				  and ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#"> 
			</cfquery>
			<!--- ACTUALIZA LOS PARAMETROS DE PERIODO/MES DE LIQUIDACION DE INTERESES --->
			<!--- PERIODO --->
			<cfquery name="UpdateParam" datasource="#session.DSN#">
				update ACParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = 150
			</cfquery>
			<!--- MES --->
			<cfquery name="UpdateParam" datasource="#session.DSN#">
				update ACParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = 160
			</cfquery>
		</cftransaction>
	</cffunction>
</cfcomponent>