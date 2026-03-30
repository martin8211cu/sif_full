<cfcomponent>
	<cffunction name="CalculoNominaQ250" access="public" output="true" >
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
			 Q250 = MONTO COMPONENTE Q250 / FACTOR DIAS * CADA DIA LABORADO
			 **************************************************************--->
		<!--- 1. ELIMINAR INCIDENCIA GENERADA POR COMPONENTE Q250 --->
		<cfinvoke component="RHParametros" method="get" datasource="#arguments.conexion#"
			ecodigo="#arguments.ecodigo#" pvalor="740" default="-1" returnvariable="Lvar_CSid">
		<cfquery name="rsComponentesSalariales" datasource="#arguments.conexion#">
			select cs.CIid 
			from ComponentesSalariales cs
			where cs.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#">
		</cfquery>
		<cfif rsComponentesSalariales.recordcount EQ 0>
			<cfthrow message="Error en Cálculo de Bonificación Especial. El Componente Salarial para Boinificación no está definido. Proceso Cancelado!">
		</cfif>
		<cfquery datasource="#arguments.conexion#">
			delete from IncidenciasCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
			</cfif>
				and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesSalariales.CIid#">
				and exists (select 1
							from RHJornadas j
							where j.RHJid = IncidenciasCalculo.RHJid
							and j.RHJpagaq250 = 1
							)
				and not exists (select 1
					   		from RHPlanificador rhpj
							where rhpj.DEid = IncidenciasCalculo.DEid
							  and <cf_dbfunction name="to_datechar" args="rhpj.RHPJfinicio"> = <cf_dbfunction name="to_datechar" args="IncidenciasCalculo.ICfecha"> 
							)
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from IncidenciasCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
			</cfif>
				and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesSalariales.CIid#">
				and exists (select 1
					   		from RHPlanificador rhpj, RHJornadas j
							where rhpj.DEid = IncidenciasCalculo.DEid
							  and <cf_dbfunction name="to_datechar" args="rhpj.RHPJfinicio"> = <cf_dbfunction name="to_datechar" args="IncidenciasCalculo.ICfecha"> 
							  and j.RHJid = rhpj.RHJid
							  and j.RHJpagaq250 = 1
							)
		</cfquery>
		<!--- 2. INSERTAR UNA INCIDENCIA Q250 POR CADA DIA LABORADO DE LUNES A SÁBADO --->
		<cfquery datasource="#arguments.conexion#">
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
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesSalariales.CIid#">,
				rhcmd.RHCMDfecha, 
				(
					coalesce(round((select DLTmonto 
					from LineaTiempo x, DLineaTiempo y
					where x.DEid = a.DEid
						  and y.LTid = x.LTid
						  and y.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#">
						  and (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#"> between x.LTdesde and x.LThasta
						  or <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#"> between x.LTdesde and x.LThasta)
						  and x.LTid = (select max(LTid) 
										from LineaTiempo lt 
										where lt.DEid = x.DEid 
										  and (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#"> between lt.LTdesde and lt.LThasta
											  or <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#"> between lt.LTdesde and lt.LThasta))
						  
						  ) / 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CantDiasMensual#">
					,2),0.00)
				),
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now())#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">,
				0, null, 0.00,
				(
					coalesce(round((select DLTmonto 
					from LineaTiempo x, DLineaTiempo y
					where x.DEid = a.DEid
						  and y.LTid = x.LTid
						  and y.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#">
						  and (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#"> between x.LTdesde and x.LThasta
						  or <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#"> between x.LTdesde and x.LThasta)
						  and x.LTid = (select max(LTid) 
										from LineaTiempo lt 
										where lt.DEid = x.DEid 
										  and (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#"> between lt.LTdesde and lt.LThasta
											  or <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#"> between lt.LTdesde and lt.LThasta))
					
					) / 



					<cfqueryparam cfsqltype="cf_sql_integer" value="#CantDiasMensual#">
					,2),0.00)
				),
				(select max(case when p.CFidconta is null then p.CFid else p.CFidconta end)
					from PagosEmpleado pe, RHPlazas p 
					where pe.RCNid = a.RCNid
					  and pe.DEid = a.DEid 
					  and pe.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = pe.RCNid and b.DEid = pe.DEid)
					  and p.RHPid = pe.RHPid
				)
			from SalarioEmpleado a, RHCMControlSemanal rhcmcs, RHCMDia rhcmd, RHJornadas j
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
			</cfif>
			and rhcmcs.DEid = a.DEid
			and rhcmcs.RHCMCSpagoseptimo = 0
			and rhcmd.RHCMCSid = rhcmcs.RHCMCSid
			and rhcmd.RHCMDfecha 
				between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#">
			and j.RHJid = rhcmd.RHJid
			and j.RHJpagaq250 = 1
		</cfquery>
		<cfquery name="rs_dia_inicio" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 780
		</cfquery>
		<cfset Lvar_DatePartFDP = rs_dia_inicio.pvalor >
		<cfif len(trim(Lvar_DatePartFDP)) EQ 0>
			<cfset Lvar_DatePartFDP = 1>
		</cfif>

		<!--- Por cada septimo generado se genera un Q250 --->
		<cfquery datasource="#arguments.conexion#">
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
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesSalariales.CIid#">,
				<cf_dbfunction name="dateadd" args="#7-Lvar_DatePartFDP#,rhcmcs.RHCMCSfecha">, 
				(
					coalesce(round(((select DLTmonto 
					from LineaTiempo x, DLineaTiempo y
					where x.DEid = a.DEid
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#">
						  between x.LTdesde and x.LThasta
						  and y.LTid = x.LTid
						  and y.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#">) 
							) / 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CantDiasMensual#">
					,2),0.00)
				),
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now())#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">,
				0, null, 0.00,
				(
					coalesce(round(((select DLTmonto 
					from LineaTiempo x, DLineaTiempo y
					where x.DEid = a.DEid
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#">
						  between x.LTdesde and x.LThasta
						  and y.LTid = x.LTid
						  and y.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid#">) 
						  ) / 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#CantDiasMensual#">
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
			and rhcmcs.RHCMCSfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
			and (select count(1)
				from RHCMDia rhcmd, RHJornadas j
				where rhcmd.RHCMCSid = rhcmcs.RHCMCSid
				and j.RHJid = rhcmd.RHJid
				and j.RHJpagaseptimo = 1) >= 6

			and not exists (  select 1 
							  from IncidenciasCalculo ic
							  where ic.RCNid = a.RCNid
							    and ic.DEid = a.DEid
								and ic.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentesSalariales.CIid#">
								and ic.ICfecha = <cf_dbfunction name="dateadd" args="#7-Lvar_DatePartFDP#,rhcmcs.RHCMCSfecha"> )	
		</cfquery>
		<cfreturn>	
	</cffunction>
</cfcomponent>
