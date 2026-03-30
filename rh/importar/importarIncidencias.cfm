<cfscript>
	bcheck1 = false;
	bcheck2 = false;
	bcheck3 = false;
	bcheck4 = false;
	bcheck5 = false;
</cfscript>

<!---Logica de ingreso de incidencias segun sea necesaria la aprobacion de las mismos--->
<cfinclude template="importarIncidenciasAprobacion.cfm">

<!--- 1. Valida que no exista una incidencia igual --->
<cfif session.Incidencias.impcalculo><!---Si es importacion de incidencias tipo calculo--->			
	<cfquery name="rsCheck4" datasource="#session.dsn#">
		select count(1) as check4
		from TMP_Incidentes a, DatosEmpleado b, CIncidentes c,  #table_name# d
		where a.CIid = c.CIid
			and a.DEid=b.DEid	<!---Mismo empleado---->			
			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and rtrim(ltrim(c.CIcodigo)) = rtrim(ltrim(d.CIcodigo))	<!---Misma incidencia---->
			and a.Ifecha=d.Ifecha	<!---Misma fecha---->
	</cfquery>	
</cfif>

<cfquery name="rsCheck1" datasource="#session.dsn#">
	select count(1) as check1
	from #table_name# a, 
				DatosEmpleado b, 
				CIncidentes c, 
				Incidencias d
	where a.DEidentificacion=b.DEidentificacion
				and rtrim(ltrim(a.CIcodigo))=rtrim(ltrim(c.CIcodigo))
				and b.DEid=d.DEid
				and c.CIid=d.CIid
				and a.Ifecha=d.Ifecha
				and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsCheck6" datasource="#session.dsn#">
	select count(1) as check6
	from #table_name# a
	group by a.DEidentificacion, a.Ifecha, a.CIcodigo
	having count(1) > 1
</cfquery>

<cfif rol EQ 1 and menu EQ 'AUTO'>				<!---si quien ingresa es jefe solo se permite subir incidencias de sus colaboradores--->
	<cfquery name="rsCheck7" datasource="#session.dsn#">
		select count(1) as check7
		from #table_name# a
		where upper(rtrim(ltrim(a.DEidentificacion))) not in (
								select distinct upper(rtrim(ltrim(x.DEidentificacion)))
								from DatosEmpleado x
								where x.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#valueList(rsSubalternos.DEid)#">)
								or x.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEidUser.DEid#">
								)
	</cfquery>
</cfif>

<cfif rol EQ 0 and menu EQ 'AUTO'>				
	<!---si quien ingresa es colaborador(usuario normal) solo se permite subir sus incidencias--->
	<cfquery name="rsCheck8" datasource="#session.dsn#">
		select count(1) as check8
		from #table_name# a
		where upper(rtrim(ltrim(a.DEidentificacion))) not in (
								select distinct DEidentificacion from DatosEmpleado where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEidUser.DEid#">
								)
	</cfquery>
	
	<!---valida que el usuario pertenesca al Centro funcional al que se desea contalizar la nomina ya que es el mismo quien las ingresa--->
	<cfquery name="rsCheck9" datasource="#session.dsn#">
		select count(1) as check9
		from #table_name# a
		where upper(rtrim(ltrim(a.CFcodigo))) not in (
								select distinct upper(rtrim(ltrim(x.CFcodigo)))
								from LineaTiempo a
									inner join RHPlazas y
									on y.RHPid = a.RHPid	
									inner join CFuncional x
									on y.CFid = x.CFid
								where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEidUser.DEid#">
								and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between a.LTdesde and a.LThasta
								)
	</cfquery>
		
</cfif>

<cfif menu EQ 'AUTO'>							<!---Valida que las incidencias sean las permitidas desde aunto gestion--->
	<cfquery name="rsCheck10" datasource="#session.dsn#">
		select count(1) as check10
		from CIncidentes c,  #table_name# d
		where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and rtrim(ltrim(c.CIcodigo)) = rtrim(ltrim(d.CIcodigo))	<!---Misma incidencia---->
			and CIautogestion = 0
	</cfquery>	
</cfif>

<cfset bcheck1 = rsCheck1.check1 LT 1>

<cfif isdefined("bcheck1")>
		<cfset rsCheck1 = rsCheck1.check1 LT 1>
<cfelse>
		<cfset bcheck1 = 1>
</cfif>

<cfif isdefined("rsCheck4")>
		<cfset bcheck4 = rsCheck4.check4 LT 1>
<cfelse>
		<cfset bcheck4 = 1>
</cfif>

<cfif isdefined("rsCheck6")>
		<cfset bcheck6 = rsCheck6.check6 LT 1>
<cfelse>
		<cfset bcheck6 = 1>
</cfif>

<cfif isdefined("rsCheck7")>
		<cfset bcheck7 = rsCheck7.check7 LT 1>
<cfelse>
		<cfset bcheck7 = 1>
</cfif>

<cfif isdefined("rsCheck8")>
		<cfset bcheck8 = rsCheck8.check8 LT 1>		
<cfelse>
		<cfset bcheck8 = 1>
</cfif>

<cfif isdefined("rsCheck9")>
		<cfset bcheck9 = rsCheck9.check9 LT 1>		
<cfelse>
		<cfset bcheck9 = 1>
</cfif>

<cfif isdefined("rsCheck10")>
		<cfset bcheck10 = rsCheck10.check10 LT 1>		
<cfelse>
		<cfset bcheck10 = 1>
</cfif>



<cfif bcheck1 and bcheck4 and bcheck6 and bcheck7 and bcheck8 and bcheck9 and bcheck10>
			<!--- 2. Valida existencia del empleado --->
			<cfquery name="rsCheckEmpl" datasource="#session.dsn#">
						select count(1) as checkEmpl
						from #table_name# 
						where DEidentificacion not in (	select DEidentificacion
															from DatosEmpleado 
															where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
			</cfquery>
			<cfset bcheckEmpl = rsCheckEmpl.checkEmpl eq 0 >
			
			
			
			<cfif bcheckEmpl >
						<!--- 3. Valida la existencia de la Jornada --->
						<cfquery name="rsCheckJornada" datasource="#session.dsn#">
							select count(1) as checkJornada
							from #table_name# 
							where Jornada is not null
							and Jornada not in (select rtrim(ltrim(RHJcodigo))
												from RHJornadas 
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
						</cfquery>
			
						<cfif rsCheckJornada.checkJornada eq 0  >
									<!--- 4. Valida la existencia del Centro Funcional --->
									<cfquery name="rsCheckCFuncional" datasource="#session.dsn#">
										select count(1) as checkFuncional
										from #table_name# 
										where CFcodigo is not null
										and CFcodigo not in (select rtrim(ltrim(CFcodigo))
															from CFuncional
															where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
									</cfquery>
									
									
									<cfif rsCheckCFuncional.checkFuncional eq 0 >		
											<!--- 5. Valida la existencia del Concepto Incidente --->
											<cfquery name="rsCheckConcepto" datasource="#session.dsn#">
												select count(1) as checkConcepto
												from #table_name# 
												where CIcodigo not in (	select rtrim(ltrim(CIcodigo))
																		from CIncidentes 
																		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">															
																		  and CIcarreracp = 0
																		)
											</cfquery>		
													
											<cfif rsCheckConcepto.checkConcepto eq 0  >
														<cfquery name="rsCheckConceptoTipo" datasource="#session.dsn#">
															select count(1) as checkConcepto
															from #table_name# 
															where CIcodigo not in (	select rtrim(ltrim(CIcodigo))
																					from CIncidentes 
																					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
																					<cfif session.Incidencias.impcalculo><!---Si es importacion de incidencias tipo calculo--->	
																						and CItipo = 3
																					<cfelse>
																						and CItipo != 3
																					</cfif>
																					  and CIcarreracp = 0
																					)
														</cfquery>
														<cfif rsCheckConceptoTipo.checkConcepto eq 0 >		
															<cfquery name="rsCheckIcpespecial" datasource="#session.dsn#">
																select count(1) as Icpespecial
																from #table_name# 
																where Icpespecial not in (0,1)
															</cfquery>
															
															<cfif rsCheckIcpespecial.Icpespecial eq 0 >							
																			<!--- *** I N I C I O *** --->
																			<cfif session.Incidencias.impcalculo><!---Si es importacion de incidencias tipo calculo--->											
																							<cfquery datasource="#session.DSN#">
																								insert into TMP_Incidentes (DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo, RHJid
																								,Iestado,Iobservacion,Iingresadopor,Iestadoaprobacion,usuCF)
																								select 	( select min(DEid) from DatosEmpleado where ltrim(rtrim(DEidentificacion))=ltrim(rtrim(a.DEidentificacion)) and Ecodigo=#session.Ecodigo# ) as DEid, 
																										( select min(CIid) from CIncidentes where ltrim(rtrim(CIcodigo))=ltrim(rtrim(a.CIcodigo)) and Ecodigo=#session.Ecodigo# and CIcarreracp = 0) as CIid, 
																										( select min(CFid) from CFuncional where ltrim(rtrim(CFcodigo)) = ltrim(rtrim(a.CFcodigo)) and Ecodigo=#session.Ecodigo# ) as CFid, 
																										a.Ifecha, 
																										a.Ivalor, 
																										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> as Ifechasys, 
																										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as Usucodigo, 
																										'00' as Ulocalizacion, 
																										--( select min(CPid) from CalendarioPagos where ltrim(rtrim(CPcodigo)) =  ltrim(rtrim(a.CPcodigo)) and Ecodigo=#session.Ecodigo# ),
																										null as RCNid,
																										a.Icpespecial, 
																										a.Ifecharebajo,
																										(select max(RHJid) from RHJornadas b
																										 where a.Jornada = b.RHJcodigo
																											and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) as RHJid
																										<!---estados de aprobacion--->
																										,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estado)#">
																										,Iobservacion
																										,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_ingresadopor)#">
																										,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estadoAprobacion)#">	
																										,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
																								from #table_name# a
																							</cfquery>
																							
																							<!---Actualiza el centro funcional de las incidencias que no tienen el cf definido--->
																							<cfquery name="rsUpcf" datasource="#session.DSN#">
																								select distinct cf.CFid,a.Id
																								from TMP_Incidentes a
																								inner join LineaTiempo lt
																								on lt.DEid = a.DEid
																								and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																								<!--- and <cf_dbfunction name="today">  between lt.LTdesde and  lt.LThasta--->
																								inner join RHPlazas pl
																								on lt.RHPid = pl.RHPid
																								inner join CFuncional cf
																								on pl.CFid =cf.CFid
																								where a.CFid is null
																							</cfquery>
																							<cfloop query="rsUpcf">
																								<cfset id = rsUpcf.Id>
																								<cfquery  datasource="#session.DSN#">
																									update TMP_Incidentes
																									set CFid = #rsUpcf.CFid#
																									where Id= #rsUpcf.Id#
																								</cfquery>
																							</cfloop>
																							
																							
																			<cfelse>		
																					
																					<cftransaction>
																							<!--- Inserta Incidencias --->
																							<cfquery name="rsIncidencias" datasource="#session.DSN#">
																								insert into Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo, RHJid, NAP
																								,Iestado,Iobservacion,Iingresadopor,usuCF,Iestadoaprobacion,BMUsucodigo)
																								select 	( select min(DEid) 
																													from DatosEmpleado 
																													where ltrim(rtrim(DEidentificacion))=ltrim(rtrim(a.DEidentificacion)) 
																													and Ecodigo=#session.Ecodigo# ) as DEid, 
																												( select min(CIid) 
																													from CIncidentes 
																													where ltrim(rtrim(CIcodigo))=ltrim(rtrim(a.CIcodigo)) 
																														and Ecodigo=#session.Ecodigo# 
																														and CIcarreracp = 0 ) as CIid, 
																												( select min(CFid) 
																														from CFuncional 
																														where ltrim(rtrim(CFcodigo)) = ltrim(rtrim(a.CFcodigo)) 
																														and Ecodigo=#session.Ecodigo# ) as CFid, 
																												a.Ifecha, 
																												a.Ivalor, 
																												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> as Ifechasys, 
																												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as Usucodigo, 
																												'00' as Ulocalizacion, 
																												--( select min(CPid) from CalendarioPagos where ltrim(rtrim(CPcodigo)) =  ltrim(rtrim(a.CPcodigo)) and Ecodigo=#session.Ecodigo# ),
																												null as RCNid,
																												a.Icpespecial, 
																												a.Ifecharebajo,
																												(select max(RHJid) from RHJornadas b
																												 where ltrim(rtrim(a.Jornada)) = ltrim(rtrim(b.RHJcodigo))
																													and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) as RHJid
																												,null
																												<!---estados de aprobacion--->
																												,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estado)#">
																												,Iobservacion
																												,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_ingresadopor)#">
																												
																												<!---si requiere aprobacion del jefe pone el estado en INGRESADO para la incidencias de la persona que las agrega siempre que no se a administrador.--->
																												<cfif esAdminRH or reqAprobacion EQ 0>
																													,null	
																													,null	<!---sin proceso de aprobacion--->	
																												<cfelseif rol EQ 2>
																													, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
																													, <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estadoAprobacion)#">
																												<cfelse>
																													, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
																													, case when (select min(DEid) from DatosEmpleado 
																																where ltrim(rtrim(DEidentificacion))=ltrim(rtrim(a.DEidentificacion)) 
																																and Ecodigo=#session.Ecodigo# ) = #UserDEid# then 0
																															else <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(I_estadoAprobacion)#"> end 
																												</cfif>
																												
																												,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">	
																												
																								from #table_name# a
																							</cfquery>
																							
																							<!---Nuevas incidencias agregadas--->
																							<cfquery name="rsIids" datasource="#session.DSN#">
																								select distinct a.Iid 
																								from Incidencias a 
																								inner join DatosEmpleado b
																									on b.DEid = a.DEid
																								inner join CIncidentes c
																									on c.CIid = a.CIid
																								left outer  join RHJornadas f
																									on f.RHJid = a.RHJid
																								inner join #table_name# e
																									on e.Ifecha = a.Ifecha  
																									and e.Icpespecial = a.Icpespecial
																									and e.Ivalor = a.Ivalor
																									and upper(ltrim(rtrim(e.DEidentificacion)))=upper(ltrim(rtrim(b.DEidentificacion))) 
																									and upper(ltrim(rtrim(e.CIcodigo)))=upper(ltrim(rtrim(c.CIcodigo)))
																							</cfquery>
																							
																							<!---proceso de aprobacion de incidencias automatico, si es administrador de RH o no requieren de aprobacion de incidencias, se auto aprueban--->
																							<cfif esAdminRH or reqAprobacion EQ 0>
																								
																								
																								<cfquery name="rsTemps" datasource="#session.DSN#">
																									select Ifecha,Icpespecial,Ivalor,DEidentificacion,CIcodigo
																									from  #table_name# 
																								</cfquery>
																								
																								<!---valida que la cantidad de Ids seleccionados sean igual al numero de incidencias agregadas--->
																								<cfif rsIids.recordCount EQ rsTemps.recordCount>
																								
																									<!---Genera el consecutivo--->
																									<cfset consecutivo = 1 >
																									<cfquery name="rs_consecutivo" datasource="#session.DSN#">
																										select Pvalor
																										from RHParametros
																										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																										  and Pcodigo = 1020
																									</cfquery>
																									<cfif len(trim(rs_consecutivo.Pvalor)) and isnumeric(rs_consecutivo.Pvalor) >
																										<cfset consecutivo = rs_consecutivo.Pvalor + 1 >
																									</cfif>
																									<!---Actualiza las nuevas incidencias con el num de documento ya que son auto aprobadas, para que sean tomadas en cuenta en la nomina--->
																									<cfloop query="rsIids">
																										<cfset vNAP = randrange(1, 100000) >
																										<cfquery datasource="#session.DSN#">
																											update Incidencias 
																											set	Iusuaprobacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
																												,Ifechaaprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
																												,Inumdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
																												,NAP = <cfqueryparam cfsqltype="cf_sql_integer" value="#vNAP#">
																											where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIids.Iid#">
																										 </cfquery>
																										 <cfset consecutivo = consecutivo + 1 >
																									</cfloop>
																									<!---Actualiza los parametros con el ultimo consecutivo--->
																									<cfquery datasource="#session.DSN#">
																										update RHParametros
																										set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#consecutivo#">
																										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																										  and Pcodigo = 1020
																									</cfquery>
																								<cfelse>
																									<cfquery name="ERR" datasource="#session.dsn#">
																										select distinct	'Las incidencias se deben auto-aprobar, pero no todas pueden ser aprobadas' as Motivo 
																										from #table_name# 
																										order by Motivo													
																									</cfquery>
																									<cftransaction action="rollback">
																								</cfif>
																							</cfif>	
																							
																							<!---Actualiza el centro funcional de las incidencias que no tienen el cf definido--->
																							<cfquery name="rsUpcf" datasource="#session.DSN#">
																								select distinct cf.CFid,a.Iid
																								from Incidencias a
																								inner join LineaTiempo lt
																								on lt.DEid = a.DEid
																								<!---and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																								 and <cf_dbfunction name="today">  between lt.LTdesde and  lt.LThasta--->
																								inner join RHPlazas pl
																								on lt.RHPid = pl.RHPid
																								inner join CFuncional cf
																								on pl.CFid =cf.CFid
																								where a.CFid is null
																								and  a.Iid in (<cfqueryparam  list="yes" cfsqltype="cf_sql_numeric" value="#valueList(rsIids.Iid)#">)
																							</cfquery>
																							<cfloop query="rsUpcf">
																								<cfset id = rsUpcf.Iid>
																								<cfquery  datasource="#session.DSN#">
																									update Incidencias
																									set CFid = #rsUpcf.CFid#
																									where Iid= #rsUpcf.Iid#
																								</cfquery>
																							</cfloop>
																							
																					</cftransaction>
																			</cfif>

															<cfelse>
																	<cfquery name="ERR" datasource="#session.dsn#">
																		select 'El Campo Icpespecial solo permite los valores (0,1)' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
																		from #table_name# 
																		where Icpespecial not in (0,1)
																		order by Motivo													
																	</cfquery>
															</cfif>		
										<cfelse>
										<cfif session.Incidencias.impcalculo><!---Si es importacion de incidencias tipo calculo--->	
														<cfquery name="ERR" datasource="#session.dsn#">
															select 'El concepto Incidente No Es De Tipo Calculo' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
															from #table_name# a
															where ltrim(rtrim(a.CIcodigo)) in (select ltrim(rtrim(CIcodigo)) 
																								from CIncidentes c 
																								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
																									and ltrim(rtrim(a.CIcodigo))=ltrim(rtrim(c.CIcodigo)) 
																									and CItipo != 3
																									and CIcarreracp = 0)
															order by Motivo													
														</cfquery>
											<cfelse><!----Importacion de incidencias NO tipo calculo---->
														<cfquery name="ERR" datasource="#session.dsn#">
															select 'Concepto Incidente Es De Tipo Calculo' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
															from #table_name# a
															where ltrim(rtrim(a.CIcodigo)) in (select ltrim(rtrim(CIcodigo)) 
																								from CIncidentes c 
																								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
																									and ltrim(rtrim(a.CIcodigo))=ltrim(rtrim(c.CIcodigo)) 
																									and CItipo = 3
																									and CIcarreracp = 0)
															order by Motivo
														</cfquery>	
											</cfif>
								</cfif><!---Fin de Validacion incidencias del tipo segun el importador----->
								<cfelse><!--- bcheckConcepto --->									
											<cfquery name="ERR" datasource="#session.dsn#">
												select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
												from #table_name# 
												where CIcodigo not in (	select rtrim(ltrim(CIcodigo))
																		from CIncidentes 
																		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">															
																		  and CIcarreracp = 0
																		)
												order by Motivo
											</cfquery>									
							</cfif><!--- bcheckConcepto --->
					<cfelse><!--- bcheckCfuncional --->
							<cfquery name="ERR" datasource="#session.dsn#">
								select 'Centro Funcional no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
								from #table_name# a
								where CFcodigo is not null
								and CFcodigo not in (select rtrim(ltrim(CFcodigo))
													from CFuncional
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
							</cfquery>
					</cfif><!--- bcheckCentroFuncional --->							
			<cfelse><!--- bcheckJornada --->
					<cfquery name="ERR" datasource="#session.dsn#">
						select 'Jornada no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
						from #table_name# a
						where Jornada is not null
						and Jornada not in (select rtrim(ltrim(RHJcodigo))
											from RHJornadas 
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
						order by Motivo
					</cfquery>
			</cfif><!--- bcheckJornada --->					
	<cfelse><!--- bcheckEmpl --->
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Empleado no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
			from #table_name# a
			where a.DEidentificacion not in ( 	
				select DEidentificacion 
				from DatosEmpleado b 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
				and a.DEidentificacion = b.DEidentificacion	)										
		</cfquery>
	</cfif><!--- bcheckEmpl --->
	
<cfelse><!--- bchek1 --->

		<cfif bcheck1 EQ 0 >	
					<cfquery name="ERR" datasource="#session.dsn#">
								select 'La Incidencia que desea insertar ya existe en el aplicativo' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha, a.Ivalor
								from #table_name# a, DatosEmpleado b, CIncidentes c, Incidencias d
								where a.DEidentificacion=b.DEidentificacion
									and rtrim(ltrim(a.CIcodigo))=rtrim(ltrim(c.CIcodigo))
									and b.DEid=d.DEid
									and c.CIid=d.CIid
									and a.Ifecha=d.Ifecha
									and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
					</cfquery>
		</cfif>
		
		<cfif bcheck4 EQ 0>	
				<cfquery name="ERR" datasource="#session.dsn#">
						select select 'Las Incidencia de Tipo Calculo ya existen' Motivo, b.DEidentificacion, a.CIcodigo, a.Ifecha, a.Ivalor
						from TMP_Incidentes a, DatosEmpleado b, CIncidentes c,  #table_name# d
						where a.CIid = c.CIid
							and a.DEid=b.DEid	<!---Mismo empleado---->			
							and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and rtrim(ltrim(c.CIcodigo)) = rtrim(ltrim(d.CIcodigo))	<!---Misma incidencia---->
							and a.Ifecha=d.Ifecha	<!---Misma fecha---->
					</cfquery>	
		</cfif>
		
		<cfif  bcheck6 EQ 0>	
					<cfquery name="ERR" datasource="#session.dsn#">
							select 'Incencias repetidas para un mismo empleado en una misma fecha' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha
							from #table_name# a
							group by a.DEidentificacion, a.Ifecha, a.CIcodigo
							having count(1) > 1
					</cfquery>	
		</cfif>
		
		<cfif  bcheck7 EQ 0>	
					<cfquery name="ERR" datasource="#session.dsn#">
							select 'Solo puede ingresar incidencias de sus colaboradores.' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha
							from #table_name# a
							where upper(rtrim(ltrim(a.DEidentificacion))) not in (
								select distinct upper(rtrim(ltrim(x.DEidentificacion)))  
								from DatosEmpleado x
								where x.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#valueList(rsSubalternos.DEid)#">)
								or x.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEidUser.DEid#">
								)
					</cfquery>	
		</cfif>
		
		<cfif  bcheck8 EQ 0>	
					<cfquery name="ERR" datasource="#session.dsn#">
						select 'Solo puede agregar sus propias incidencias.' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha
						from #table_name# a
						where upper(rtrim(ltrim(a.DEidentificacion))) not in (
							select distinct DEidentificacion from DatosEmpleado where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEidUser.DEid#">
							)
					</cfquery>	
		</cfif>
		
		<cfif  bcheck9 EQ 0>	
					<cfquery name="ERR" datasource="#session.dsn#">
							select 'Solo puede agregar sus propias incidencias.' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha
							from #table_name# a
							where upper(rtrim(ltrim(a.CFcodigo))) not in (
									select distinct upper(rtrim(ltrim(x.CFcodigo)))
									from LineaTiempo a
										inner join RHPlazas y
										on y.RHPid = a.RHPid	
										inner join CFuncional x
										on y.CFid = x.CFid
									where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEidUser.DEid#">
									and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between a.LTdesde and a.LThasta
									)
					</cfquery>	
		</cfif>
		
		<cfif  bcheck10 EQ 0>	
					<cfquery name="ERR" datasource="#session.dsn#">
						select 'Las incidencias que desea agregar no son permitidas desde autogestion.' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha
						from CIncidentes c,  #table_name# a
						where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and rtrim(ltrim(c.CIcodigo)) = rtrim(ltrim(a.CIcodigo))	<!---Misma incidencia---->
							and CIautogestion = 0
					</cfquery>	
		</cfif>
		
</cfif><!--- bchek1 --->
<!----<cfset session.Incidencias.impcalculo = false>--->