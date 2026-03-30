<cfcomponent>

	<!--- variables globales --->
	<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="this.plan">
	<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="this.deduccion">
    <cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
        

	<!---	RESULTADO:
			Devuelve referencia a este componente.
	--->
	<cffunction name="init">
		<cfreturn This>
	</cffunction>

	<cffunction name="interfazAhorros" access="public">
        <cfargument name="RCNid" 	type="numeric" required="yes">
		<cfargument name="DSN" 	 	type="string"  required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 	type="string"  required="no" default="#session.Ecodigo#">
        <cfset var Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
        <cfset var Lvar_Mes 		= Parametros.Get("20",	"Mes")>

        <cfquery datasource="#arguments.dsn#">
        	INSERT INTO 
            	ACAportesTransacciones 
				(ACAAid, ACATperiodo, ACATmes, ACATfecha, ACATtipo, ACATafecta, ACATmonto, BMUsucodigo, BMfecha)
            SELECT 	
            	a.ACAAid, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">, 
                c.CPfpago, 
                'N', 
                'C', 
                b.DCvalor, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
            FROM HDeduccionesCalculo b
				inner join ACAportesAsociado a
					on b.Did = a.Did<!--- Implcitamente Incluye el Empleado --->
				inner join CalendarioPagos c
					on c.CPid = b.RCNid
            WHERE b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
        	INSERT INTO 
            	ACAportesTransacciones 
				(ACAAid, ACATperiodo, ACATmes, ACATfecha, ACATtipo, ACATafecta, ACATmonto, BMUsucodigo, BMfecha)
            SELECT 	
            	a.ACAAid, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">, 
                c.CPfpago, 
                'N', 
                'C', 
                case when ax.ACATorigen  = 'O' then b.CCvaloremp when ax.ACATorigen = 'P' then b.CCvalorpat else 0.00 end, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
            FROM HCargasCalculo b
				inner join CalendarioPagos c
					on c.CPid = b.RCNid
				inner join ACAportesTipo ax
					on ax.DClinea = b.DClinea
				inner join ACAsociados ac
					on ac.DEid = b.DEid
				inner join ACAportesAsociado a
					on a.ACAid = ac.ACAid
					and a.ACATid = ax.ACATid
					and a.DClinea = b.DClinea
            WHERE b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and a.Did is null
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
        	UPDATE 
            	ACAportesSaldos 
				SET ACAAaporteMes = ACAAaporteMes +
                (
                    SELECT 	sum(b.DCvalor)
                    FROM ACAportesAsociado a, HDeduccionesCalculo b, CalendarioPagos c
                    WHERE b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                      and b.Did = a.Did<!--- Implcitamente Incluye el Empleado --->
                      and c.CPid = b.RCNid
                      and a.ACAAid = ACAportesSaldos.ACAAid
                )
        	WHERE ACASperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">
              AND ACASmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">
              AND EXISTS (
              	SELECT 	1
                FROM ACAportesAsociado a, HDeduccionesCalculo b, CalendarioPagos c
                 WHERE b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                   and b.Did = a.Did<!--- Implcitamente Incluye el Empleado --->
                   and c.CPid = b.RCNid
                   and a.ACAAid = ACAportesSaldos.ACAAid
              )
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
        	UPDATE 
            	ACAportesSaldos 
				SET ACAAaporteMes = ACAAaporteMes +
                coalesce((
					SELECT 	
						sum(case ax.ACATorigen when 'O' then b.CCvaloremp when 'P' then b.CCvalorpat else 0.00 end)
					FROM ACAportesAsociado a
						inner join ACAsociados ac
						on ac.ACAid = a.ACAid

						inner join ACAportesTipo ax
						on ax.ACATid = a.ACATid

						inner join HCargasCalculo b
						on b.DClinea = ax.DClinea
						and b.DEid = ac.DEid

						inner join CalendarioPagos c
						on c.CPid = b.RCNid

					where a.ACAAid = ACAportesSaldos. ACAAid
					  and a.Did is null
					  and ax.DClinea is not null
					  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">

                ),0)
        	WHERE ACASperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">
              AND ACASmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">
              AND EXISTS (
              	SELECT 	1
					FROM ACAportesAsociado a
						inner join ACAsociados ac
						on ac.ACAid = a.ACAid

						inner join ACAportesTipo ax
						on ax.ACATid = a.ACATid

						inner join HCargasCalculo b
						on b.DClinea = ax.DClinea
						and b.DEid = ac.DEid

						inner join CalendarioPagos c
						on c.CPid = b.RCNid

					where a.ACAAid = ACAportesSaldos. ACAAid
					  and a.Did is null
					  and ax.DClinea is not null
					  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              )
        </cfquery>
	</cffunction>

	<!--- 	RESULTADO	
			Registra como pagada la cuota respectiva a un credito de asociacion. 
	--->
	<cffunction name="interfazCreditos" access="public">
		<cfargument name="RCNid" 	type="numeric" required="yes">
		<cfargument name="DSN" 	 	type="string"  required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 	type="string"  required="no" default="#session.Ecodigo#">
		
		<!--- tabla necesaria para ordenar las fechas que al final de este proceso quedan desordenadas --->
		<cf_dbtemp name="plan_fechas" returnvariable="plan_fechas" datasource="#session.DSN#">
			<cf_dbtempcol name="fecha" 	type="datetime"	mandatory="yes">
		</cf_dbtemp>

		<!--- 1. Recupera fechas de la Relacion de Calculo --->	
		<cfquery name="rs_datos_relacion" datasource="#arguments.DSN#">
			select Tcodigo, RCdesde as desde, RChasta as hasta
			from RCalculoNomina
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>

		<!--- 2. Recupera las deducciones que deben ser pagadas en esta quincena y que pertenecen a un Plan de Pagos vigente --->
		<cfquery name="rs_deducciones" datasource="#arguments.DSN#">
			select distinct c.DEid, b.Did, b.ACCAid, b.ACPPid
			from ACPlanPagos b, DeduccionesEmpleado c
			where c.Dactivo=1
				and b.ACPPestado='N'
				and b.Did = c.Did
				and c.DEid in ( select DEid from SalarioEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> )
				and b.ACPPfecha between c.Dfechaini and c.Dfechafin
				and b.ACPPfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#rs_datos_relacion.desde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rs_datos_relacion.hasta#">
		</cfquery>
		<cfoutput query="rs_deducciones">
			<cfquery datasource="#arguments.DSN#">
				delete from #plan_fechas#
			</cfquery>
		
			<!--- 3. Verifica que las deducciones devueltas en 2 hayan sido pagadas en esta nomina --->
			<cfquery name="rs_deducciones_pagadas" datasource="#arguments.DSN#">
				select distinct a.DEid, b.Did, b.ACCAid, coalesce(b.ACPPpagoPrincipal, 0) as cuota
				from DeduccionesCalculo a, ACPlanPagos b, DeduccionesEmpleado c
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.DEid#">
					and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.Did#">
					and b.ACPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.ACPPid#">
					and c.Dactivo=1
					and a.Did = b.Did
					and a.Did = c.Did
					and b.Did = c.Did
					and a.DCvalor > 0
			</cfquery>
			<!--- 2. Si la deduccion se pago en esta nomina registra el pago en el plan de pagos --->
			<cfif rs_deducciones_pagadas.recordcount gt 0 >
				<!--- 3. recupera el id y el monto de las cuotas a cancelar --->
				<cfset data_cuotas = this.plan.obtenerCuotasAdelanto( rs_deducciones.ACCAid, 1, 1, arguments.DSN ) >
	
				<!--- 4. actualiza el acumulado de amortizacion para el credito  --->
				<cfset this.plan.actualizarAmortizacion(rs_deducciones.ACCAid, rs_deducciones_pagadas.cuota, arguments.DSN) >
				
				<!--- 5. modifca el plan de pagos para registrar el pago de las cuotas --->
				<cfset this.plan.modificarPlan(rs_deducciones.ACCAid, data_cuotas.ACPPid, LSDateFormat(now(), 'dd/mm/yyyy'), 'S', 'N', arguments.DSN ) >
				
			<!--- 6. Si en esta nomina no se hizo el pago de una cuota, el plan de pagos debe actualizarze para 
					 agregar esta cuota al final y siga pendiente de pago --->
			<cfelse>
				<!--- 6.1 	Determinar cual fue la cuota del plan que no se pago  --->
				<cfquery name="rs_cuota_pendiente" datasource="#arguments.DSN#">
					select ACPPid, ACPPperiodicidad as periodicidad
					from ACPlanPagos
					where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.ACCAid#">
					  and ACPPestado = 'N'
					  and ACPPfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#rs_datos_relacion.desde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rs_datos_relacion.hasta#">
				</cfquery>
				
				<!---- if para caso de henkel en un calendario especial no hubo match de fechas 
					   y revento en linea 250 porque query rs_cuota_pendiente no devolvio registros --->
				<cfif len(trim(rs_cuota_pendiente.ACPPid))>
					<!--- 6.2 	Determina la nueva fecha de pago de la cuota --->
					<!--- 6.2.1	Determina la fecha del ultimo pago por realizar --->
					<cfquery name="rs_ultimo_pago" datasource="#arguments.DSN#">
						select max(ACPPfecha) as fecha
						from ACPlanPagos
						where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.ACCAid#">
					</cfquery>
	
					<!--- 6.2.2 Recupera la nueva fecha de pago de la cuota --->
					<cftry>
						<cfset fecha = dateadd('d', 1, rs_ultimo_pago.fecha)>	<!--- la fecha de pago corresponde a la fecha hasta del calendario de pagos, por eso le sumamos un dia mas para caer en el siguiente calendario --->
						<cfset fecha_pago = this.plan.obtenerFechaCalendario(arguments.Ecodigo, rs_datos_relacion.Tcodigo, lsdateformat(fecha, 'dd/mm/yyyy'), arguments.DSN ).CPhasta >
					<cfcatch type="any">
						<!--- No se encontro un calendario de pagos para la fecha calculada. --->
						<!--- El pago de la nomina no puede ser detenido por este error entonces se hace un calculo 
							  de la fecha de pago sin tomar en cuenta el calendario, sino los dias del periodo  --->
	
						<!--- 6.2.3 determina la periodicidad de la relacion de calculo del empleado --->	
						<cfset fecha_pago = rs_ultimo_pago.fecha >
						<cfset sumar_dias = this.plan.obtenerParametro(arguments.Ecodigo, this.plan.parametro[rs_cuota_pendiente.periodicidad+1], arguments.DSN )>
						<cfset fecha_pago = dateadd('d', sumar_dias, fecha_pago) >
					</cfcatch>
					</cftry>
					
					<!--- 6.2.4 modifica la fecha de pago para la cuota --->
					<cfquery datasource="#arguments.DSN#">
						update ACPlanPagos
						set ACPPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_pago#">
						where ACPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_cuota_pendiente.ACPPid#">
					</cfquery>
	
					<!--- pruebas --->
					<cfquery datasource="#arguments.DSN#">
						insert into #plan_fechas# (fecha)
						select ACPPfecha
						from ACPlanPagos
						where ACCAid = #rs_deducciones.ACCAid#
						  and ACPPestado='N'
						  order by ACPPfecha
					</cfquery>
	
					<cfquery name="rs_plan_codigos" datasource="#arguments.DSN#">
						select ACPPid
						from ACPlanPagos
						where ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.ACCAid#">
						  and ACPPestado='N'
						  order by ACPPsaldoAnterior desc
					</cfquery>
					
					<cfloop query="rs_plan_codigos">
						<cfquery datasource="#arguments.DSN#">
							update ACPlanPagos
							set ACPPfecha = ( select min(fecha) from #plan_fechas#  )
							where ACPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_plan_codigos.ACPPid#">
							  and ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_deducciones.ACCAid#">
						</cfquery>
						
						<cfquery datasource="#arguments.DSN#">
							delete from #plan_fechas#
							where fecha = ( select min(fecha) from #plan_fechas#  ) 
						</cfquery>
						
					</cfloop>

				</cfif>
			</cfif>
		</cfoutput>
	</cffunction>
</cfcomponent>