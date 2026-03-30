<!---ljimenez sacamos los pagos incidentes que forman parte del salario pero que se reflejan en las incidencias--->
<cfquery datasource="#Arguments.datasource#" >
	insert into #PagosIncidentes# (DEid, PImonto)
	select b.DEid, (ld.DLTmonto * b.PEcantdias / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#"> * case when b.PEtiporeg = 2 then -1 else 1 end)
		from #PagosEmpleado# b, LineaTiempo lt, DLineaTiempo ld, 
		ComponentesSalariales a, RHPlazas p, CIncidentes ci
	where b.PEtiporeg < 2  
	  and lt.DEid = b.DEid
	  and b.PEdesde between lt.LTdesde and lt.LThasta
	  and ld.LTid = lt.LTid
	  and ld.CIid is not null
	  and a.CIid = ci.CIid
	 <!--- and ci.CInoanticipo = 1--->
	  and ci.CIafectaSBC = 1
	  and a.CSid = ld.CSid
	  and p.RHPid = lt.RHPid
</cfquery>


<cfquery datasource="#Arguments.datasource#">
	update #PagosEmpleado# set PEsalarioCS = PEsalario
</cfquery>

<cfquery datasource="#Arguments.datasource#">
	update #PagosEmpleado# set PEsalarioCS = PEsalarioCS + coalesce((select coalesce(sum(PImonto),0)
															from #PagosIncidentes# pi
															where #PagosEmpleado#.DEid = pi.DEid
															group by DEid
														),0) 
		where #PagosEmpleado#.PEsalario > 0
</cfquery>



<!---
<cfquery datasource="#Arguments.datasource#" name="z">

select rv.DRVdiasgratifica
		from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
		 where a.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">	
			and  87193 = a.DEid
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and c.DEid =  87193
			
			and c.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> between c.LTdesde and c.LThasta
			and rv.RVid = c.RVid
		
			and rv.DRVcant = ( select max(DRVcant) 
								from DRegimenVacaciones rv2 
								where rv2.RVid = c.RVid 
								and rv2.DRVcant <= datediff(yy, a.EVfantig, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
							)


</cfquery>

<cfdump var="#z#">

<cfquery datasource="#Arguments.datasource#" name="y">				 
select rv.DRVdiasprima
		from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
		 where a.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">	
			and 87193 = a.DEid
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and c.DEid = 87193
			
			and c.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> between c.LTdesde and c.LThasta
			and rv.RVid = c.RVid
		
			and rv.DRVcant = ( select max(DRVcant) 
								from DRegimenVacaciones rv2 
								where rv2.RVid = c.RVid 
								and rv2.DRVcant <= datediff(yy, a.EVfantig, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
							 )
							 

</cfquery>							 

<cf_dump var="#y#">
--->



<!---ljimenez calculo de SBC para mexico parte fija--->
<cfquery datasource="#Arguments.datasource#"> 
	update #PagosEmpleado# set PEsalariobc = (PEsalarioCS/ #FactorDiasMensual#)* ((365 + 
	 coalesce((select rv.DRVdiasgratifica
		from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
		 where a.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">	
			and #PagosEmpleado#.DEid = a.DEid
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and c.DEid = #PagosEmpleado#.DEid
			
			and c.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> between c.LTdesde and c.LThasta
			and rv.RVid = c.RVid
		
			and rv.DRVcant = ( select max(DRVcant) 
								from DRegimenVacaciones rv2 
								where rv2.RVid = c.RVid 
								and rv2.DRVcant <= datediff(yy, a.EVfantig, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
							 )),0)
							
		+					 
		coalesce((select rv.DRVdiasprima
		from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
		 where a.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">	
			and #PagosEmpleado#.DEid = a.DEid
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and c.DEid = #PagosEmpleado#.DEid
			
			and c.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> between c.LTdesde and c.LThasta
			and rv.RVid = c.RVid
		
			and rv.DRVcant = ( select max(DRVcant) 
								from DRegimenVacaciones rv2 
								where rv2.RVid = c.RVid 
								and rv2.DRVcant <= datediff(yy, a.EVfantig, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
							 )),0)
			)/365)
</cfquery>

<!---ljimenez calculo de SBC para mexico parte variable el calculo se basa en las incidencias de los 2 meses calendario anterioses  --->
<cfquery datasource="#Arguments.datasource#" name="rsMP">
	select distinct <cf_dbfunction name="date_part" args="mm, cp.CPhasta"> as vMes ,<cf_dbfunction name="date_part" args="yyyy, cp.CPhasta"> as vPeriodo
		from  #PagosEmpleado#, CalendarioPagos cp
		where #PagosEmpleado#.RCNid = cp.CPid
</cfquery>

<cfset vMes 	= rsMP.vMes>
<cfset vPeriodo = rsMP.vPeriodo>

<cfif (#vMes# EQ 1 or #vMes# EQ 2)>
	<cfquery datasource="#Arguments.datasource#" > 
		update #PagosEmpleado# set PEsalariobc = PEsalariobc + (coalesce((
			select sum(ic.ICmontores)
				from HIncidenciasCalculo ic, CalendarioPagos cp
				where ic.CIid not in  (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
														on  ci.CIid = cs.CIid
													where  ci.CIafectaSBC = 1)	<!---(select cs.CIid from  ComponentesSalariales cs where cs.CIid is not null)--->
					and	cp.CPperiodo = #vPeriodo-1#
					and cp.CPmes in (11,12)
				and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and ic.RCNid = cp.CPid
				and  #PagosEmpleado#.DEid = ic.DEid
		),0) 
		/
		coalesce((select sum(pe.PEcantdias)
				from HPagosEmpleado pe, CalendarioPagos cp
				where cp.CPperiodo = #vPeriodo-1#
					and cp.CPmes in (11,12)
				and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and PEmontores > 0
				and pe.RCNid = cp.CPid
				and  #PagosEmpleado#.DEid = pe.DEid
		),1)
		)
	</cfquery>
<cfelse>
	<cfif (#vMes# EQ 3 or #vMes# EQ 4)>
		<cfquery datasource="#Arguments.datasource#" > 
			update #PagosEmpleado# set PEsalariobc = PEsalariobc + (coalesce((
						select sum(ic.ICmontores)
							from HIncidenciasCalculo ic, CalendarioPagos cp
							where ic.CIid not in (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
														on  ci.CIid = cs.CIid
													where  ci.CIafectaSBC = 1)
								and cp.CPperiodo = #vPeriodo#
								and cp.CPmes in (1,2)
							and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							and ic.RCNid = cp.CPid
							and  #PagosEmpleado#.DEid = ic.DEid
					),0) 
					/ 
					coalesce((select sum(pe.PEcantdias)
					from HPagosEmpleado pe, CalendarioPagos cp
					where cp.CPperiodo = #vPeriodo#
						and cp.CPmes in (1,2)
					and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and PEmontores > 0
					and pe.RCNid = cp.CPid
					and  #PagosEmpleado#.DEid = pe.DEid
			),1)
		</cfquery>
		<cfelse>
			<cfif (#vMes# EQ 5 or #vMes# EQ 6)>
				<cfquery datasource="#Arguments.datasource#" > 
					update #PagosEmpleado# set PEsalariobc = PEsalariobc + (coalesce((
						select sum(ic.ICmontores)
							from HIncidenciasCalculo ic, CalendarioPagos cp
							where ic.CIid not in (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
														on  ci.CIid = cs.CIid
													where  ci.CIafectaSBC = 1)
								and cp.CPperiodo = #vPeriodo#
								and cp.CPmes in (3,4)
							and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							and ic.RCNid = cp.CPid
							and  #PagosEmpleado#.DEid = ic.DEid
					),0) 
					/
					coalesce((
						select sum(pe.PEcantdias)
							from HPagosEmpleado pe, CalendarioPagos cp
							where cp.CPperiodo = #vPeriodo#
								and cp.CPmes in (3,4)
							and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							and PEmontores > 0
							and pe.RCNid = cp.CPid
							and  #PagosEmpleado#.DEid = pe.DEid
					),1)
				</cfquery>
				<cfelse>
					<cfif (#vMes# EQ 7 or #vMes# EQ 8)>
						<cfquery datasource="#Arguments.datasource#" > 
							update #PagosEmpleado# set PEsalariobc = PEsalariobc + (coalesce((
								select sum(ic.ICmontores)
									from HIncidenciasCalculo ic, CalendarioPagos cp
									where ic.CIid not in (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
														on  ci.CIid = cs.CIid
													where  ci.CIafectaSBC = 1)
										and cp.CPperiodo = #vPeriodo#
										and cp.CPmes in (5,6)
									and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
									and ic.RCNid = cp.CPid
									and  #PagosEmpleado#.DEid = ic.DEid
							),0) 
							/
							coalesce((
								select sum(pe.PEcantdias)
									from HPagosEmpleado pe, CalendarioPagos cp
									where cp.CPperiodo = #vPeriodo#
										and cp.CPmes in (5,6)
									and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
									and PEmontores > 0
									and pe.RCNid = cp.CPid
									and  #PagosEmpleado#.DEid = pe.DEid
							),1)
						</cfquery>
							<cfelse>
							<cfif (#vMes# EQ 9 or #vMes# EQ 10)>
								<cfquery datasource="#Arguments.datasource#" > 
									update #PagosEmpleado# set PEsalariobc = PEsalariobc + (coalesce((
										select sum(ic.ICmontores)
											from HIncidenciasCalculo ic, CalendarioPagos cp
											where ic.CIid not in (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
														on  ci.CIid = cs.CIid
													where  ci.CIafectaSBC = 1)
												and cp.CPperiodo = #vPeriodo#
												and cp.CPmes in (7,8)
											and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
											and ic.RCNid = cp.CPid
											and  #PagosEmpleado#.DEid = ic.DEid
									),0) 
									/
									coalesce((
										select sum(pe.PEcantdias)
											from HPagosEmpleado pe, CalendarioPagos cp
											where cp.CPperiodo = #vPeriodo#
												and cp.CPmes in (7,8)
											and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
											and PEmontores > 0
											and pe.RCNid = cp.CPid
											and  #PagosEmpleado#.DEid = pe.DEid
									),1)
								</cfquery>
								<cfelse>
									<cfif (#vMes# EQ 11 or #vMes# EQ 12)>
										<cfquery datasource="#Arguments.datasource#" > 
											update #PagosEmpleado# set PEsalariobc = PEsalariobc + (coalesce((
												select sum(ic.ICmontores)
													from HIncidenciasCalculo ic, CalendarioPagos cp
													where ic.CIid not in (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
														on  ci.CIid = cs.CIid
													where  ci.CIafectaSBC = 1)
														and cp.CPperiodo = #vPeriodo#
														and cp.CPmes in (9,10)
													and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
													and ic.RCNid = cp.CPid
													and  #PagosEmpleado#.DEid = ic.DEid
											),0) 
											/
											coalesce((
												select sum(pe.PEcantdias)
													from HPagosEmpleado pe, CalendarioPagos cp
													where cp.CPperiodo = #vPeriodo#
														and cp.CPmes in (9,10)
													and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
													and PEmontores > 0
													and pe.RCNid = cp.CPid
													and  #PagosEmpleado#.DEid = pe.DEid
											),1)
										</cfquery>
									</cfif> 
							</cfif> 		
					</cfif> 
			</cfif> 
	</cfif> 
</cfif>

<cfquery datasource="#Arguments.datasource#">
	update #PagosEmpleado# set PEsalariobc = (select max(PEsalariobc) from #PagosEmpleado# a where a.DEid = #PagosEmpleado#.DEid)
	where PEsalariobc = 0
</cfquery>
