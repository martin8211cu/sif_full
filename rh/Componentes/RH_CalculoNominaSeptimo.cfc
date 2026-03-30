<cfcomponent>
	<cfinvoke component="RHParametros" method="init" returnvariable="parametros">
	<cffunction name="CalculoNominaSeptimo" access="public" output="true" >
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RCNid"   type="numeric" required="yes">
		<cfargument name="Tcodigo" type="string" 	required="yes">
		<cfargument name="RCdesde" type="string" required="yes">
		<cfargument name="RChasta" type="string" required="yes">		
		<cfargument name="IRcodigo" type="string" 	required="yes">
		<cfargument name="CantDiasMensual" type="numeric" 	required="yes">
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="Ulocalizacion" type="string" required="no" default="00">
		<cfargument name="pDEid" type="numeric" required="no" default="false">		
		<cfargument name="debug" type="boolean" required="no" default="false">
		
		<!---************************CALCULO DE Q250***********************
			 SEPTIMO  = ((Monto de Incidencias por Horas Normales + Monto de 
			 Incidencias por Horas Extra A + Monto de Incideencias por Horas
			 Extra B, durante los días laborados de Lunes a Viernes)/6)
			 **************************************************************--->
		<cfinvoke component="RHParametros" method="get" datasource="#arguments.conexion#"
			ecodigo="#arguments.ecodigo#" pvalor="740" default="-1" returnvariable="Lvar_CSid">
		<cfquery name="rsComponentesSalariales" datasource="#arguments.conexion#">
			select cs.CIid 
			from ComponentesSalariales cs
			where cs.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#">
		</cfquery>
		<cfif rsComponentesSalariales.recordcount EQ 0>
			<cfthrow message="Error en Cálculo de Séptimo. El Componente Salarial para Boinificación no está definido. Proceso Cancelado!">
		</cfif>
		<cfinvoke component="RHParametros" method="get" datasource="#arguments.conexion#"
			ecodigo="#arguments.ecodigo#" pvalor="750" default="-1" returnvariable="Lvar_CIid">
		<cfquery name="rsCIncidentes" datasource="#arguments.conexion#">
			select ci.CIid 
			from CIncidentes ci
			where ci.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#">
		</cfquery>
		<cfif rsCIncidentes.recordcount EQ 0>
			<cfthrow message="Error en Cálculo de Séptimo. El Concepto Incidente para Séptimo no está definido. Proceso Cancelado!">
		</cfif>
		<cfset Lvar_DatePartFDP = parametros.get(session.dsn,session.ecodigo,780)>
		<cfif len(trim(Lvar_DatePartFDP)) EQ 0>
			<cfset Lvar_DatePartFDP = 1>
		</cfif>

		<!--- =============================================================== --->
		<!---  LIZANDRADA - INICIO --->
		<!--- =============================================================== --->
		<!--- 1. datos de la nomina --->
		<cfquery name="rs_nomina" datasource="#session.DSN#">
			select RCdesde as desde, RChasta as hasta
			from RCalculoNomina
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
		
		<!--- 2. empleados de esta nomina que tienen vacaciones en el periodo de la nomina --->
		<cfquery datasource="#arguments.conexion#" name="rs_datos">
			select a.RHSPEid, 
				   a.DEid,
				   case when a.RHSPEfdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.desde#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.desde#"> else a.RHSPEfdesde end as desde, 
				   case when a.RHSPEfhasta > <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.hasta#"> then <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.hasta#"> else a.RHSPEfhasta end as hasta,
					( 	select coalesce(min(RHJid), 0)
						from LineaTiempo lt
						where lt.DEid=a.DEid
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta ) as RHJid,
					case when a.RHSPEsubDiario > a.RHSPEsaldoSub then a.RHSPEsaldoSub else a.RHSPEsubDiario end as vacaciones_sumar,
					case when abs(a.RHSPEsalDiario) > abs(a.RHSPEsaldo) then abs(a.RHSPEsaldo) else abs(a.RHSPEsalDiario) end as vacaciones_restar,
					a.RHSPEmontoSub as total,
					a.RHSPEmontoReb as total_rebajar
				   
			from RHSaldoPagosExceso a, RHTipoAccion b 
			where a.RHSPEanulado = 0
			  and b.RHTcomportam = 3
			  and b.RHTid = a.RHTid
			  and a.RHSPEfdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.hasta#">
			  and a.RHSPEfhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.desde#">
			  <cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
			  	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
			  </cfif>
			  and exists ( select 1
						   from LineaTiempo lt
						   where lt.DEid=a.DEid
						   and lt.Tcodigo=(select Tcodigo from RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> ) 
						   and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta  )		
		</cfquery>
		
		<!--- reinicia la situacion de las vacaciones antes de recalcularlas --->
		<cfquery datasource="#session.DSN#">
			update RHCMDia
			set RHCMDvacaciones = 0, 
				RHCMDvacacionesReb = 0
			where exists( select 1
						  from RHCMControlSemanal
						  where RHCMCSid = RHCMDia.RHCMCSid
						  and RHCMCSpagoseptimo = 0
			  			  <cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
			  	  		      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
			  			  </cfif>
					   )
		</cfquery>

		<!--- 3. verfica si existe un registro en control semanal que caiga en esta nomina--->
		<cfquery name="rs_control_semanal" datasource="#session.DSN#">
			select RHCMCSid, RHCMCSfecha desde, dateadd('dd', 6, RHCMCSfecha) as hasta
			from RHCMControlSemanal
			where RHCMCSfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.hasta#"> 
			and dateadd('dd', 7, RHCMCSfecha) > <cfqueryparam cfsqltype="cf_sql_date" value="#rs_nomina.desde#">
		</cfquery>
		
		<!--- 4. parametro de dia de inicio de jornada --->
		<cfquery name="rs_dia_inicio" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 780
		</cfquery>
		<cfset dia_inicio = rs_dia_inicio.pvalor >
		<!--- por defecto es 3 (miercoles) segun guatemala --->
		<cfif not len(trim(dia_inicio))><cfset dia_inicio = 3></cfif>
		<!--- se lleva el valor de dia_inicio a equivalencia con bd (1:dom, 2:lun, 3:mar....) (el parametro es 1:lun, 2:mar, 3:mier......)--->
		<!--- dia inicio es domingo --->
		<cfif dia_inicio eq 7 >
			<cfset dia_inicio = 1 >
		<!--- dia inicio es otro dia de la semana --->
		<cfelse>
			<cfset dia_inicio = dia_inicio + 1 >
		</cfif>

		<!--- 4. proceso de la informacion --->
		<cfloop query="rs_datos">
			<cfset fecha_desde = rs_datos.desde >
			<cfset fecha_hasta = rs_datos.hasta >
			<cfset fecha_referencia = '' >		<!--- fecha que me indica el dia de inicio de una semana segun parametro 780 (dia en que empiezan las jornadas para henkel) --->
			<cfset saldo = rs_datos.total >
			<cfset saldo_rebajar = rs_datos.total_rebajar >
			
			<!--- 4.0 cantidad de dias de vacaciones por considerar para este rango de fechas --->
			<cfset dias_vacaciones = abs(datediff('d', fecha_desde, fecha_hasta))+1 >

			<!--- 4.1 para cada uno de los dias del rango calcula fecha de referencia --->
			<cfset fecha_actual = fecha_desde >
			<cfloop from="1" to="#dias_vacaciones#" index="i" >

				<!--- 4.1.1 busca el dia de inicio de la semana donde cae esta fecha (semana inicia el dia indicado por el parametro 780) --->
				<cfset dia_semana = dayofweek(fecha_actual) >
				<cfif dia_semana eq dia_inicio>
					<cfset fecha_referencia = fecha_actual >
				<cfelse>
					<cfset sumar_dias = 0 >
					<cfif dayofweek(fecha_actual) gt dia_inicio>
						<cfset sumar_dias = abs(dia_inicio - dia_semana) * -1 >
						<!--- -1*(abs(#dia_inicio# - datepart(dw, <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_desde#">))) --->
					<cfelse>
						<cfset sumar_dias = ((7-dia_inicio) + dia_semana) * -1 >
					</cfif>
					<cfset fecha_referencia = dateadd('d', sumar_dias, fecha_actual) >
				</cfif>

				<!--- 4.1.2 hay control semanal para la fecha de referencia--->
				<cfquery name="rs_hay_control" datasource="#session.DSN#">
					select RHCMCSid as id
					from RHCMControlSemanal
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.DEid#">
					and RHCMCSfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_referencia#">
				</cfquery>
				<cfset control_id = rs_hay_control.id >

				<!--- 4.1.3 si no hay control semanal lo inserta  --->
				<cfif not len(trim(control_id))>
					<cfquery name="rs_hay_control" datasource="#session.DSN#">
						insert into RHCMControlSemanal( DEid, RHCMCSfecha, RHCMCSpagoseptimo, RHCMCSmontoseptimo, BMfecha, BMUsucodigo )
						values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_referencia#">,
								0,
								0,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.DEid#"> )
						<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="rs_hay_control" verificar_transaccion="false">
					<cfset control_id = rs_hay_control.identity >
				</cfif>
				
				<!--- 4.1.3.1 limpia los campos de RHCMDvacaciones, RHCMDvacacionesReb, pues son recalculados  --->
				<!---
				<cfquery datasource="#session.DSN#">
					update RHCMDia
					set RHCMDvacaciones = 0, 
						RHCMDvacacionesReb = 0
					where RHCMCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#control_id#">
				</cfquery>
				--->

				<!--- 4.1.4 consulta la existencia del dia en proceso en la tabla RHCMDia par ael control semanal recuperado --->
				<cfquery name="rs_hay_dia" datasource="#session.DSN#">
					select RHCMDid as id
					from RHCMDia
					where RHCMCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#control_id#">
					  and RHCMDdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dia_semana-1#">
					  and RHCMDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_actual#">
				</cfquery>

				<cfset dia_id = rs_hay_dia.id >
				
				<cfif saldo gt rs_datos.vacaciones_sumar >
					<cfset sumar = rs_datos.vacaciones_sumar >
					<cfset saldo = saldo - sumar >
				<cfelse>
					<cfset sumar = saldo >
					<cfset saldo = 0 >
				</cfif>

				<cfif saldo_rebajar gt rs_datos.vacaciones_restar >
					<cfset restar = rs_datos.vacaciones_restar >
					<cfset saldo_rebajar = saldo_rebajar - restar >
				<cfelse>
					<cfset restar = saldo_rebajar >
					<cfset saldo_rebajar = 0 >					
				</cfif>
				
				<cfif not len(trim(dia_id))>
					<!--- 4.1.5 inserta el registro para el dia que se esta procesando --->
					<cfquery datasource="#session.DSN#">
						insert into RHCMDia( RHCMCSid, 
											 RHCMDdia, 
											 RHCMDfecha, 
											 RHJid, 
											 RHCMDhn, 
											 RHCMDhea, 
											 RHCMDheb, 
											 RHCMDhniid, 
											 RHCMDheaiid, 
											 RHCMDhebiid, 
											 RHCMDferiid,
											 RHCMDvacaciones,
											 RHCMDvacacionesReb,
											 BMfecha, 
											 BMUsucodigo )
						values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#control_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#dia_semana-1#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#fecha_actual#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_datos.RHJid#">,
								0, 
								0,
								0,
								0,
								0,
								0,
								0,
								<cfqueryparam cfsqltype="cf_sql_money" value="#sumar#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#restar*-1#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.DSN#">
						update RHCMDia
						set RHCMDvacaciones=<cfqueryparam cfsqltype="cf_sql_money" value="#sumar#">,
							RHCMDvacacionesReb=<cfqueryparam cfsqltype="cf_sql_money" value="#restar*-1#">
						where RHCMDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dia_id#">
					</cfquery>
				</cfif>
				
				<!--- borra las lineas que estan en cero --->	
				<cfquery datasource="#session.DSN#">
					delete from RHCMDia
					where RHCMCSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#control_id#">
					  and RHCMDhniid = 0
					  and RHCMDheaiid = 0
					  and RHCMDhebiid = 0
					  and RHCMDferiid = 0
					  and coalesce(RHCMDvacaciones , 0) = 0
					  and coalesce(RHCMDvacacionesReb, 0) = 0
				</cfquery>
				
				<!--- se mueve un dia segun el rango de fechas que se esta procesando --->
				<cfset fecha_actual = dateadd('d', 1, fecha_actual) >
			</cfloop>
		</cfloop>

		<!--- =============================================================== --->
		<!---  LIZANDRADA - FIN --->
		<!--- =============================================================== --->
		
		<!--- LISTA DE CONCEPTOS DE PAGO A TOMAR ENCUENTA APARTE DE LOS DEFINIDOS EN LA JORNADA --->
		<cfinvoke component="RHParametros" method="get" datasource="#arguments.conexion#"
			ecodigo="#arguments.ecodigo#" pvalor="1050" default="-1" returnvariable="Lvar_Conceptos">

		<cfquery datasource="#arguments.conexion#" name="x">
			insert into IncidenciasCalculo (RCNid, 
											DEid, 
											CIid, 
											ICfecha, 
											ICvalor, 
											ICfechasis, 
											Usucodigo, 
											Ulocalizacion, 
											ICcalculo, ICbatch, ICmontoant, 
											ICmontores, CFid)
			select a.RCNid,
				a.DEid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#">,
				<cf_dbfunction name="dateadd" args="#7-Lvar_DatePartFDP#,rhcmcs.RHCMCSfecha">, 

				<!--- ICvalor --->
				(
					coalesce(round((
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDhniid = ic.Iid
						)),0.00)+
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDheaiid = ic.Iid
						)),0.00)+
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDhebiid = ic.Iid
						)),0.00)+
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDferiid = ic.Iid
						)),0.00)
						+ 
						coalesce((select sum(ICmontores)
								from IncidenciasCalculo ic
								where ic.RCNid = a.RCNid 
								  and ic.DEid = a.DEid
								  and ic.CIid in (#Lvar_Conceptos#)
								  and ic.ICfecha between rhcmcs.RHCMCSFECHA  and rhcmcs.RHCMCSFECHA + 6
								  )
								,0.00)
						+ 
						coalesce( ( select sum(RHCMDvacaciones+RHCMDvacacionesReb)
									from RHCMDia
									where RHCMCSid = rhcmcs.RHCMCSid), 0.00)
					) / 6
					<!--- (	select count(1)
						from RHCMDia rhcmd, RHJornadas j
						where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
						and j.RHJid = rhcmd.RHJid
						and j.RHJpagaseptimo = 1 ) --->
					
					,2),0.00)
				),

				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">,
				0, null, 0.00,

				<!--- ICmontores --->
				(
					coalesce(round((
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDhniid = ic.Iid
						)),0.00)+
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDheaiid = ic.Iid
						)),0.00)+
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDhebiid = ic.Iid
						)),0.00)+
						coalesce((select sum(ICmontores)	
						from IncidenciasCalculo ic
						where ic.RCNid = a.RCNid
						and ic.DEid = a.DEid
						and ic.CIid not in (#Lvar_Conceptos#)
						and exists(
							select 1
							from RHCMDia rhcmd
							where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
							and rhcmd.RHCMDferiid = ic.Iid
						)),0.00)
						+						
						coalesce((select sum(ICmontores)
								from IncidenciasCalculo ic
								where ic.RCNid = a.RCNid 
								  and ic.DEid = a.DEid
								  and ic.CIid in (#Lvar_Conceptos#)
								  and ic.ICfecha between rhcmcs.RHCMCSFECHA  and rhcmcs.RHCMCSFECHA + 6
								  )
								,0.00)						
						+ 
						coalesce( ( select sum(RHCMDvacaciones+RHCMDvacacionesReb)
									from RHCMDia
									where RHCMCSid = rhcmcs.RHCMCSid), 0.00)
					) / 
					6
					,2),0.00)
				),
				(select max(case when p.CFidconta is null then p.CFid else p.CFidconta end)
					from PagosEmpleado pe, RHPlazas p 
					where pe.RCNid = a.RCNid
					  and pe.DEid = a.DEid 
					  and pe.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = pe.RCNid and b.DEid = pe.DEid)
					  and p.RHPid = pe.RHPid
				)
			from SalarioEmpleado a, RHCMControlSemanal rhcmcs
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
			</cfif>
			and rhcmcs.DEid = a.DEid
			and rhcmcs.RHCMCSpagoseptimo = 0
			and rhcmcs.RHCMCSfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.RChasta#">
			and (select count(1)
				from RHCMDia rhcmd, RHJornadas j
				where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
				and j.RHJid = rhcmd.RHJid
				and j.RHJpagaseptimo = 1) >= 6
		</cfquery>

		<cfreturn>	
	</cffunction>
</cfcomponent>