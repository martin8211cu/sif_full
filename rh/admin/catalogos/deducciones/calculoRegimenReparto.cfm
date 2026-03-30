<!---Calculo del Régimen de Repargo-Desarrollo ITCR--->
	
<cf_dbtemp name="calculaReparto1" returnvariable="calculoReparto">
		<cf_dbtempcol name="RCNid"  		type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="DEid"   		type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="Mes"   	    	type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="Periodo"  		type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="SalarioMes"  	type="money" 	mandatory="yes">
		<cf_dbtempcol name="IncidenciasMes" type="money" 	mandatory="no">
		<cf_dbtempcol name="HSalarios"  	type="money" 	mandatory="no">
		<cf_dbtempcol name="HIncidencias"  	type="money" 	mandatory="no">
		<cf_dbtempcol name="NominaMes"  	type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="NominaPendiente"type="numeric" 	mandatory="yes">
		<cf_dbtempcol name="NominaCalc"		type="numeric" 	mandatory="yes">	
		<cf_dbtempcol name="MontoProy"  	type="money" 	mandatory="no">
		<cf_dbtempcol name="TotalRep"	  	type="money" 	mandatory="no">
		<cf_dbtempcol name="TotalRet"	  	type="money" 	mandatory="no">
		<cf_dbtempcol name="TotalRepCalen"  type="money" 	mandatory="no">
		<cf_dbtempcol name="FechaIni"       type="date" 	mandatory="no">
		<cf_dbtempcol name="FechaFin"       type="date" 	mandatory="no">
</cf_dbtemp>


<cfif isdefined ('url.RCNid') and len(trim(url.RCNid)) gt 0 and (not isdefined ('form.RCNid') or len (trim(form.RCNid)) eq 0)>
	<cfset form.RCNid=#url.RCNid#>
</cfif>

<cfquery name="rsnomina" datasource="#session.dsn#">
	select CPmes, CPperiodo ,CPdesde,CPhasta
	from CalendarioPagos where 
	CPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
</cfquery>

<!---==========================================
   Cantidad de Nóminas al Mes                  
===========================================--->
		<cfquery name="rs_nominasM" datasource="#session.DSN#">
			select count(CPcodigo) as Cantidad
			from CalendarioPagos a
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and exists (Select 1
						from CalendarioPagos b
						Where a.CPmes=b.CPmes
						and a.CPperiodo=b.CPperiodo
						and a.Tcodigo=b.Tcodigo
						and a.Ecodigo=b.Ecodigo
						and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">)                			 
			and CPtipo = 0
		</cfquery>	
		<cfset cant_nominas	= rs_nominasM.Cantidad>

<!---==========================================
   Cantidad de Nóminas Pendientes              
===========================================--->
		<cfquery name="rs_nominaP" datasource="#session.DSN#">
			select count(1) as Cantidad
			from CalendarioPagos a
			where exists (Select 1 from
						  CalendarioPagos b
						  Where a.CPmes=b.CPmes
						  and a.CPperiodo=b.CPperiodo
						  and a.Tcodigo=b.Tcodigo
						  and a.Ecodigo=b.Ecodigo
						  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">)
			and CPtipo = 0
			and not exists (Select 1 
							from HRCalculoNomina c
							Where a.CPid = c.RCNid
							and c.RCNid not in (Select RCNid from RCalculoNomina))
		</cfquery>
		<cfset nom_pendientes	= rs_nominaP.Cantidad>

<!---==========================================
   Cantidad de Nóminas Calculadas              
===========================================--->
		<cfquery name="rs_nominaC" datasource="#session.DSN#">
			select count(1)+ 1 as Cantidad
			from CalendarioPagos a
			where exists (Select 1 from
						  CalendarioPagos b
						  Where a.CPmes=b.CPmes
						  and a.CPperiodo=b.CPperiodo
						  and a.Tcodigo=b.Tcodigo
						  and a.Ecodigo=b.Ecodigo
						  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">)
			and CPtipo = 0
			and exists (Select 1 
							from HRCalculoNomina c
							Where a.CPid = c.RCNid)
		</cfquery>
		<cfset nom_calculadas = rs_nominaC.Cantidad >


	<!---Realizo la insercion a la tabla temporal/ Esta toma en cuenta los cortes por mes y identifica si existen retroactivos--->
		<cfquery name="rsCalen" datasource="#session.dsn#">		
			insert into #calculoReparto# (RCNid, DEid, Mes, Periodo, SalarioMes,  
			                                                          IncidenciasMes, 
																	  HSalarios,  HIncidencias,
																	  NominaMes,  NominaPendiente,	 
																	  NominaCalc, MontoProy, 
																	  TotalRep, TotalRet, TotalRepCalen)
																	  
			select pe.RCNid, pe.DEid, 
					<cf_dbfunction name="date_part"	args="MM,pe.PEdesde"> as mes,
					<cf_dbfunction name="date_part"	args="YYYY,pe.PEdesde"> as periodo,
					coalesce(sum(pe.PEmontores),0),
					0 as IncidenciasMes,
					0 as HSalarios,
					0 as HIncidencias,
					1 as NominaMes, 
					1 as NominaPendientes,	 
					1 as NominaCalc,
					0 as NominaProy, 
					0 as TotalRep, 
					0 as TotalRet, 
					0 as TotalCalen
			from PagosEmpleado pe 
			where RCNid=#form.RCNid#
			and DEid in (select distinct (d.DEid) from DeduccionesCalculo d
							inner join DeduccionesEmpleado e
							on e.DEid=d.DEid
							and e.Did=d.Did
							and TDid=#DeduccionesEspeciales.TDid#
						where d.RCNid=#form.RCNid#
						<cfif isdefined ('arguments.PDEid') and len(trim(arguments.PDEid)) gt 0>
							and d.DEid=#arguments.PDEid#
						</cfif>)
			group by pe.DEid,
					 pe.RCNid,
					 <cf_dbfunction name="date_part" args="MM,pe.PEdesde"> , 
			         <cf_dbfunction name="date_part" args="YYYY,pe.PEdesde">
							
		</cfquery>
		<!---Realizo la insercion a la tabla temporal de las incidencias calculo en caso de que estas se paguen en un mes diferente al actual.--->
		<cfquery name="rsCalen" datasource="#session.dsn#">		
			insert into #calculoReparto# (RCNid, DEid, Mes, Periodo, SalarioMes,  
			                                                          IncidenciasMes, 
																	  HSalarios, HIncidencias,
																	  NominaMes, NominaPendiente,NominaCalc,
																	  MontoProy, TotalRep, 
																	  TotalRet, TotalRepCalen)
																	  
			select ic.RCNid, ic.DEid, 
					<cf_dbfunction name="date_part"	args="MM,ic.ICfecha"> as mes,
					<cf_dbfunction name="date_part"	args="YYYY,ic.ICfecha"> as periodo,
					0 as SalarioMes,
					0 as IncidenciasMes,
					0 as HSalarios,
					0 as HIncidencias,
					1 as NominaMes, 
					1 as NominaPendientes,	 
					1 as NominaCalc,
					0 as NominaProy, 
					0 as TotalRep, 
					0 as TotalRet, 
					0 as TotalCalen 
			from IncidenciasCalculo ic 
			inner join CIncidentes ci
				on ci.CIid=ic.CIid
				and CInocargasley=0
			where RCNid=#form.RCNid#
			and DEid in (select distinct (d.DEid) from DeduccionesCalculo d
							inner join DeduccionesEmpleado e
							on e.DEid=d.DEid
							and e.Did=d.Did
							and TDid=#DeduccionesEspeciales.TDid#
						where d.RCNid=#form.RCNid#
						<cfif isdefined ('arguments.PDEid') and len(trim(arguments.PDEid)) gt 0>
							and d.DEid=#arguments.PDEid#
						</cfif>)
			and not exists (Select 1 
							from #calculoReparto# cr
							where cr.DEid=ic.DEid
							and cr.RCNid=ic.RCNid
							and cr.Mes = <cf_dbfunction name="date_part" args="MM,ic.ICfecha">
							and cr.Periodo=<cf_dbfunction name="date_part" args="YYYY,ic.ICfecha">)
			group by ic.DEid,
					 ic.RCNid,
					 <cf_dbfunction name="date_part" args="MM,ic.ICfecha"> , 
			         <cf_dbfunction name="date_part" args="YYYY,ic.ICfecha">					 		
		</cfquery>
	
		<!---Actualizo los montos de las incidencias por mes--->
		<cfquery name="rsInc" datasource="#session.dsn#">
			update #calculoReparto# 
			set IncidenciasMes =(	select coalesce(sum(ic.ICmontores),0)
									from IncidenciasCalculo ic
										inner join CIncidentes ci
										on ci.CIid=ic.CIid
										and CInocargasley=0
									where #calculoReparto#.DEid = ic.DEid
										and   #calculoReparto#.RCNid = ic.RCNid
										and <cf_dbfunction name="date_part"	args="MM,ICfecha"> = #calculoReparto#.Mes
										and	<cf_dbfunction name="date_part"	args="YYYY,ICfecha">= #calculoReparto#.Periodo)
		</cfquery>
		

	<!---==========================================
	    Actualizo los valores de los historicos    
	===========================================--->
		<cfquery name="upHist" datasource="#session.dsn#">
			update #calculoReparto# 
			set HSalarios=  (select coalesce(sum(hp.PEmontores ), 0.00 )
									from HPagosEmpleado hp, 
										 CalendarioPagos c
									where hp.RCNid=c.CPid
									and #calculoReparto#.Mes=c.CPmes
									and #calculoReparto#.Periodo=c.CPperiodo
									and #calculoReparto#.DEid=hp.DEid) ,
		   HIncidencias = (select  coalesce(sum(hic.ICmontores), 0.00 )
										from HIncidenciasCalculo hic,
											 CalendarioPagos c,
											 CIncidentes ci
										where hic.RCNid = c.CPid
										  and ci.CIid=hic.CIid
										  and  ci.CInocargasley=0
										  and #calculoReparto#.DEid=hic.DEid
										  and c.CPid=hic.RCNid
										  and #calculoReparto#.Mes=c.CPmes
										  and #calculoReparto#.Periodo=c.CPperiodo)
		</cfquery>

	<!---==================================================================
	    Sumatoria de las Retenciones Ordinarias de Reparto hechas en Nómina
	===================================================================--->
		<cfquery name="rsRet" datasource="#session.dsn#">
			update #calculoReparto# 									
			set TotalRet= (select coalesce(sum(DCvalor),0) 
						from HDeduccionesCalculo hd
								inner join DeduccionesEmpleado de
									on de.DEid=hd.DEid
									and de.Did=hd.Did
									and de.DidPadre is null <!--- Deducciones Ordinarias --->
										inner join TDeduccion td
										on td.TDid=de.TDid
										and td.TDid=#DeduccionesEspeciales.TDid#		
									inner join CalendarioPagos cp
										on cp.CPid = hd.RCNid
										and #calculoReparto#.Mes=cp.CPmes
										and #calculoReparto#.Periodo=cp.CPperiodo
						Where #calculoReparto#.DEid=hd.DEid)
		</cfquery>								

	
	<!---==================================================================
	    Sumatoria de las Retenciones Ordinarias de Reparto hechas en Nómina
	===================================================================--->
		<cfquery name="rsRet" datasource="#session.dsn#">
			update #calculoReparto# 									
			set TotalRet= TotalRet+ (select coalesce(sum(DCvalor),0) 
						from HDeduccionesCalculo hd
								inner join DeduccionesEmpleado de
									on de.DEid=hd.DEid
									and de.Did=hd.Did
									and de.DidPadre is not null <!--- Deducciones Extraordinarias --->
									and <cf_dbfunction name="date_part"	args="MM,de.Dfechaini"> = #calculoReparto#.Mes
									and	<cf_dbfunction name="date_part"	args="YYYY,de.Dfechaini">= #calculoReparto#.Periodo
										inner join TDeduccion td
										on td.TDid=de.TDid
										and td.TDid=#DeduccionesEspeciales.TDid#		
						Where #calculoReparto#.DEid=hd.DEid)
		</cfquery>	
	
	
			
	<!---==========================================
	    Verifico si existen nominas para proyectar 
	===========================================--->
		<cfif nom_pendientes NEQ 1 >		
			<cfset nom_proyectar = cant_nominas>
		<cfelse >		
			<cfset nom_proyectar = 1>
			<cfset nom_calculadas = 1>
		</cfif>

		<cfquery datasource="#session.dsn#">
			update #calculoReparto#  
				set NominaMes=#cant_nominas#,
				NominaPendiente=#nom_pendientes#,
				NominaCalc=#nom_calculadas#
			where #calculoReparto#.Mes=#rsnomina.CPmes#
			and #calculoReparto#.Periodo=#rsnomina.CPperiodo#
		</cfquery>	
	

		<!---Definir el monto proyectado de Reparto por Nómina Ordinaria--->
		<cfquery name="upSal" datasource="#session.dsn#">
			update #calculoReparto# 
				set MontoProy= (HIncidencias+HSalarios+IncidenciasMes+SalarioMes)/NominaCalc* NominaPendiente
			where #calculoReparto#.Mes=#rsnomina.CPmes#
			and #calculoReparto#.Periodo=#rsnomina.CPperiodo#
		</cfquery>	
	
		<!---Definir el monto proyectado Para periodos Anterioresm, que no se proyectan--->
				<cfquery name="upSal" datasource="#session.dsn#">
			update #calculoReparto# 
				set MontoProy= (HIncidencias+HSalarios+IncidenciasMes+SalarioMes)
			where #calculoReparto#.Mes<>#rsnomina.CPmes#
			and #calculoReparto#.Periodo<>#rsnomina.CPperiodo#
		</cfquery>	
		
			<cfquery datasource="#session.dsn#">
				update #calculoReparto# 
				set  TotalRep = (select coalesce((
										(#calculoReparto#.MontoProy-d.DRRinf)*
										(d.DRRporcentaje/100)+
										DRRmontofijo) ,0)
								 from 	ERegimenReparto e, DRegimenReparto d
								where  <cfqueryparam cfsqltype="cf_sql_date" value="#rsnomina.CPdesde#"> between e.ERRdesde and e.ERRhasta
								and d.ERRid=e.ERRid
								and round(#calculoReparto#.MontoProy,2) >= round(d.DRRinf,2)
								and round(#calculoReparto#.MontoProy,2) <= round(d.DRRsup,2)
								and e.Ecodigo=#session.Ecodigo#)
			</cfquery>

		<cfquery datasource="#session.dsn#">
			delete
				from DeduccionesCalculo 
				where Did in (select e.Did 
							  from DeduccionesEmpleado e
								where DEid in (select DEid from #calculoReparto#)
								and TDid=#DeduccionesEspeciales.TDid#
								and DidPadre in (Select Did 
												 from DeduccionesEmpleado de
												 Where DidPadre is null
												 and TDid= #DeduccionesEspeciales.TDid#												 
												 )
								)
			    and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		</cfquery>
		

		<cfquery datasource="#session.dsn#">
			delete		
				from DeduccionesEmpleado 
					where Did in (select e.Did 
							  from DeduccionesEmpleado e
								where DEid in (select DEid from #calculoReparto#)
								and TDid=#DeduccionesEspeciales.TDid#
								and DidPadre in (Select Did 
												 from DeduccionesEmpleado de
												 Where DidPadre is null
												 and TDid= #DeduccionesEspeciales.TDid#												 
												 )
								)
			   
		</cfquery>
		<!---and DidPadre in (select Did 
									 from DeduccionesEmpleado
									 where DEid in (select DEid from #calculoReparto#)
									 and TDid=#DeduccionesEspeciales.TDid#
									 and DidPadre is null
									 and Did in (Select Did 
												 from DeduccionesCalculo
												 Where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">)
									 )--->
		<!---<cfif session.Usulogin eq 'soinrh'>
			<cfquery datasource="#session.dsn#">
				delete from DeduccionesCalculo where 
				Did in ( select Did from DeduccionesEmpleado where TDid=#DeduccionesEspeciales.TDid#
					and Ddescripcion like 'Retroactivo%')
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete		
					from DeduccionesEmpleado 
						where DEid in (select DEid from #calculoReparto#)
						and TDid= #DeduccionesEspeciales.TDid#
						and Dfechaini =<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#">
			</cfquery>
		</cfif>--->

		<cfquery datasource="#session.dsn#">	
			update #calculoReparto#
			set FechaIni= <cf_dbfunction name="to_char" args="Periodo*10000+Mes*100+1">
		</cfquery>
		
		<cfquery datasource="#session.dsn#">	
			update #calculoReparto#
			set FechaFin=<cf_dbfunction name="dateadd" args="1,FechaIni,MM ">
		</cfquery>
			

		<cfquery datasource="#session.dsn#">
			update #calculoReparto# 
				set TotalRepCalen = (TotalRep-TotalRet) / NominaPendiente
			where #calculoReparto#.Mes=#rsnomina.CPmes#
			and #calculoReparto#.Periodo=#rsnomina.CPperiodo#
		</cfquery>	
		
		<cfquery datasource="#session.dsn#">
			update #calculoReparto# 
				set TotalRepCalen = (TotalRep-TotalRet)
			where #calculoReparto#.Mes<>#rsnomina.CPmes#
			and #calculoReparto#.Periodo<>#rsnomina.CPperiodo#
		</cfquery>	
		
		
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
			 <cfquery name="inDE" datasource="#session.dsn#">
				insert into DeduccionesEmpleado 
							(DEid, Ecodigo,TDid,
							SNcodigo, Ddescripcion, Dmetodo, 
							Dvalor, Dfechadoc, Dfechaini, Dfechafin, 
							Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, 
							Usucodigo, Ulocalizacion, Dcontrolsaldo, 
							Dactivo, Dreferencia, BMUsucodigo, 
							Dobservacion, IRcodigo, Mcodigo, 
							DidPadre)
				(select de.DEid, #session.Ecodigo#,de.TDid,
					de.SNcodigo,
						'Retroactivo ' #LvarCNCT# 
						de.Ddescripcion #LvarCNCT# 
						'  ' #LvarCNCT# 
						<cf_dbfunction name="to_char" args="cr.Periodo"> #LvarCNCT# 
						'-' #LvarCNCT# 
						<cf_dbfunction name="to_char" args="cr.Mes">,
					de.Dmetodo, 
					coalesce(cr.TotalRepCalen,0), de.Dfechadoc,
					(select max(PEdesde) from PagosEmpleado where PEtiporeg in (0,1) and RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
					and DEid=de.DEid) ,
						<cf_dbfunction name="dateadd" args="-1, cr.FechaFin,DD "> as fechafin, 
					
					de.Dmonto, de.Dtasa,0, de.Dmontoint, 0, 
					de.Usucodigo, de.Ulocalizacion, 0, 
					0, de.Dreferencia, de.BMUsucodigo, 
					de.Dobservacion, de.IRcodigo, de.Mcodigo, 
					de.Did
					from #calculoReparto# cr
					inner join DeduccionesEmpleado de
						on cr.DEid=de.DEid					
					and de.TDid=#DeduccionesEspeciales.TDid#
					and ((cr.Periodo*100)+cr.Mes)!=((#rsnomina.CPperiodo#*100)+#rsnomina.CPMes#))	
			</cfquery> 
	


		<cfquery name="inDC" datasource="#session.dsn#">
				insert into DeduccionesCalculo 
				(RCNid, DEid, Did, DCvalor, 
				DCinteres, DCbatch, DCmontoant)
			(select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">, de.DEid,de.Did,Dvalor,
				0,0,0
				from DeduccionesEmpleado de,
					 #calculoReparto# cr
				Where de.DidPadre is not null
				and cr.DEid=de.DEid	
				and <cf_dbfunction name="date_part"	args="MM,de.Dfechaini">  = cr.Mes
				and <cf_dbfunction name="date_part"	args="YYYY,de.Dfechaini">  = cr.Periodo			
			and de.DidPadre in (Select Did 
									from DeduccionesCalculo
									Where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">)
				and de.TDid=#DeduccionesEspeciales.TDid#
				and Did not in (Select Did 
								from DeduccionesCalculo	
								Where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">) 
			)
		</cfquery>


		
		<cfquery name="upDed" datasource="#session.dsn#">
			update DeduccionesCalculo 
			set DCvalor = (select coalesce(sum(TotalRepCalen),0) 
						  from #calculoReparto# cr
 						  where ((cr.Periodo*100)+cr.Mes)=((#rsnomina.CPperiodo#*100)+#rsnomina.CPMes#)
						  and DeduccionesCalculo.DEid=cr.DEid	)
	<!---		where exists (select 1 
						  from #calculoReparto# cr
 						  where ((cr.Periodo*100)+cr.Mes)=((#rsnomina.CPperiodo#*100)+#rsnomina.CPMes#)
						  and DeduccionesCalculo.DEid=cr.DEid	)--->
			where DEid in (select DEid from #calculoReparto#)
			and Did in (Select Did 
						from DeduccionesEmpleado de
						Where DidPadre is null
						and TDid=#DeduccionesEspeciales.TDid#)
		</cfquery>		
		

		<cfquery name="upDed" datasource="#session.dsn#">
			update DeduccionesEmpleado 
			set Dvalor = (select coalesce(sum(TotalRepCalen),0) 
						  from #calculoReparto# cr
 						  where ((cr.Periodo*100)+cr.Mes)=((#rsnomina.CPperiodo#*100)+#rsnomina.CPMes#)
						  and DeduccionesEmpleado.DEid=cr.DEid	)
		<!---			where exists (select 1 
						  from #calculoReparto# cr
 						  where ((cr.Periodo*100)+cr.Mes)=((#rsnomina.CPperiodo#*100)+#rsnomina.CPMes#)
						  and DeduccionesEmpleado.DEid=cr.DEid	)--->
			where DEid in (select DEid from #calculoReparto#)
			and Did in (Select Did 
						from DeduccionesEmpleado de
						Where DidPadre is null
						and TDid=#DeduccionesEspeciales.TDid#)
		</cfquery>	

	

