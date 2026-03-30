<cffunction name="detalle">
	<cfargument name="RHQuerySalarios" 	type="string" 	required="yes">
	<cfargument name="QuerySalariosDet" type="string" 	required="yes">
	<cfargument name="periodo" 			type="numeric" 	required="yes">
	<cfargument name="mes" 				type="numeric" 	required="yes">	
	<cfargument name="PatEmp" 			type="numeric" 	required="yes">	
	<cfargument name="GrupoPlanilla" 	type="string" 	required="no">	
	<cfargument name="masivo" 			type="numeric" 	required="yes">	
	<cfargument name="NUMPAT" 			type="string" 	required="yes">	

	<!--- Variables --->
	<cfset mesA = '' >
	<cfset PatAct = '' >
	<cfset PatAnt = '' >
	<cfset GenAct = '' >
	<cfset GenAnt = '' >
	<cfset fecini = '' >
	<cfset fecfin = '' >
	<cfset TotCamb = '' >
	<cfset periodoA = '' >
	<cfset TotSCamb = '' >
	
	<!--- Validación de Variables --->
	<cfif arguments.mes EQ 1>
		<cfset mesA = 12 >
		<cfset periodoA = arguments.periodo - 1 >
	<cfelse>
		<cfset mesA = (arguments.mes - 1) >
		<cfset periodoA = arguments.periodo >
	</cfif>
	
	<cfif len(trim(arguments.NUMPAT)) EQ 0>
		<cfset arguments.NUMPAT = '0' >
	</cfif>
	
	<cfset fecini = CreateDate(arguments.periodo, arguments.mes, 1) >
	<cfset fecfin = dateadd('d', -1, fecini) >
	
	<cfif arguments.PatEmp EQ 0 >
		<cfset arguments.NUMPAT = '0' >
	</cfif>
	
	<!--- Inserto al personal con pagos en el periodo --->
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into #arguments.QuerySalariosDet# (DEid, NUMPAT, Ocodigo, Ecodigo, FECHDE, FECHAS, Salario)
			select 	DEid, coalesce(o.Onumpatronal, '0'), pe.Ocodigo, cp.Ecodigo, <cfqueryparam cfsqltype="cf_sql_date" value="#fecini#">, <cfqueryparam cfsqltype="cf_sql_date" value="#fecfin#">, sum(PEmontores) as PEmontores
			from CalendarioPagos cp
				inner join HPagosEmpleado pe
					on cp.CPid = pe.RCNid 
					and cp.Tcodigo =  pe.Tcodigo 
				inner join Oficinas o
					on pe.Ocodigo = o.Ocodigo
					and cp.Ecodigo = o.Ecodigo
					and coalesce(o.Onumpatronal, '0') = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NUMPAT#"> 
					
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
				and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">    
				and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
			group by DEid, coalesce(o.Onumpatronal, '0'), pe.Ocodigo, cp.Ecodigo
	</cfquery>

	<!--- Actualiza las Incidencias --->
	<cfquery name="rsUpdateIncidencias" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet# 
		set Incidencias = coalesce((select sum(ICmontores) 
									from CalendarioPagos cp
										inner join HIncidenciasCalculo ic
											on cp.CPid = ic.RCNid
											and #arguments.QuerySalariosDet#.DEid = ic.DEid
										inner join CIncidentes ci
											and ic.CIid = ci.CIid 
											and ci.CInocargasley = 0
									where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
										and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">							  						
									group by DEid ), 0)
	</cfquery>
	
	<!--- Actualiza los Pagos Recibidos el Periodo Anterior --->
	<cfquery name="rsUpdateSalarioa" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet# 
		set Salarioa = coalesce((select sum(PEmontores)
								 from CalendarioPagos cp
									inner join  HPagosEmpleado pe
										on cp.CPid = pe.RCNid   
										and cp.Tcodigo = pe.Tcodigo  
										and #arguments.QuerySalariosDet#.DEid = pe.DEid
								 where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoA#">  
									and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesA#">
								 group by DEid	), 0)
	</cfquery>
	
	<!--- Actualiza las Incidencias Recibidas del Periodo Anterior --->
	<cfquery name="rsUpdateIncidenciasa" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet#
		set Incidenciasa = coalesce((select sum(ICmontores)
									 from CalendarioPagos cp 
										inner join HIncidenciasCalculo ic
											on cp.CPid = ic.RCNid
											and #arguments.QuerySalariosDet#.DEid = ic.DEid
										inner join CIncidentes ci
											on ic.CIid = ci.CIid 
											and ci.CInocargasley = 0							
									 where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoA#">  
										and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesA#">
									 group by DEid),0)
	</cfquery>
	
	<cfquery name="rsUpdateFechamax" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet#
		set Fechamax = (select max(PEdesde)
						from CalendarioPagos cp
							inner join HPagosEmpleado pe
								on cp.CPid = pe.RCNid  
								and cp.Tcodigo = pe.Tcodigo   
								and #arguments.QuerySalariosDet#.DEid = pe.DEid
								and pe.PEtiporeg = 0					
						where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">  
							and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#"> )
	</cfquery>
	
	<cfquery name="rsUpdateRHPcodigo" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet# 
		set RHPcodigo = (select RHPcodigo
						 from CalendarioPagos cp
							inner join HPagosEmpleado pe
								on cp.CPid = pe.RCNid  
								and cp.Tcodigo =  pe.Tcodigo   
								and #arguments.QuerySalariosDet#.DEid = pe.DEid
								and #arguments.QuerySalariosDet#.Fechamax = pe.PEdesde
								and pe.PEtiporeg = 0					
						 where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">  
							and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#"> )
	</cfquery>

	<cfquery name="rsUpdateMonto" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet# 
		set MONTO = Salario + Incidencias, 
			MONTOa = Salarioa + Incidenciasa, 
			Mensaje = 'SIN CAMBIO'
	</cfquery>
	
	<cfquery name="rsUpdateMensaje" datasource="#session.DSN#">
		update #arguments.QuerySalariosDet# 
		set Mensaje = 'CON CAMBIO REPORTADO'
		where MONTO != MONTOa
	</cfquery>
	
	<cfif arguments.masivo EQ 1>
		<cfquery name="rsMontos1" datasource="#session.DSN#">
			select coalesce(sum(MONTO),0) as MONTO, coalesce(sum(MONTOa),0) as MONTOa 
			from #arguments.QuerySalariosDet#
		</cfquery>
		<cfset PatAct = rsMontos1.MONTO >
		<cfset PatAnt = rsMontos1.MONTOa >
		
		<cfquery name="rsMontos2" datasource="#session.DSN#">
			select coalesce(sum(MONTO),0) as MONTO, coalesce(sum(MONTOa),0) as MONTOa
			from #arguments.QuerySalariosDet#
		</cfquery>
		<cfset GenAct = rsMontos2.MONTO >
		<cfset GenAnt = rsMontos2.MONTOa >
	
		<cfquery name="rsTotCamb" datasource="#session.DSN#">
			Select coalesce(sum(MONTO),0) as MONTO
			from #arguments.QuerySalariosDet# 
			where Mensaje != 'SIN CAMBIO'
		</cfquery>
		<cfset TotCamb = rsTotCamb.MONTO >
		
		<cfquery name="rsTotSCamb" datasource="#session.DSN#">
			Select coalesce(sum(MONTO),0) as MONTO
			from #arguments.QuerySalariosDet# 
			where Mensaje = 'SIN CAMBIO'
		</cfquery>
		<cfset TotSCamb = rsTotSCamb.MONTO >
		
		<cfquery name="rsInsert_RHQuerySalarios" datasource="#session.DSN#">
			insert into #arguments.RHQuerySalarios# (Patron, PatAct, PatAnt, GenAct, GenAnt, TotCamb, TotSCamb)
			values ('#arguments.NUMPAT#', #PatAct#, #PatAnt#, #GenAct#, #GenAnt#, #TotCamb#, #TotSCamb#)
		</cfquery>
	</cfif>
	
</cffunction>