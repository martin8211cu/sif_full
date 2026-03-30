<cfscript>
	bcheck0 = true;
	bcheck1 = false;
	bcheck2 = false;
	bcheck3 = false;
	bcheck4 = false;
</cfscript>

<cfif session.Incidencias.impcalculo><!---Si es importacion de incidencias tipo calculo--->			
	<cfquery name="rsCheck4" datasource="#session.dsn#">
		select count(1) as check4
		from IMPIncidentes a, DatosEmpleado b, CIncidentes c,  #table_name# d
		where a.CIid = c.CIid
			and a.DEid=b.DEid	<!---Mismo empleado---->			
			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and rtrim(ltrim(c.CIcodigo)) = rtrim(ltrim(d.CIcodigo))	<!---Misma incidencia---->
			and a.Ifecha=d.Ifecha	<!---Misma fecha---->
	</cfquery>	
</cfif>


<!--- 0. Valida que no haya registros repetidos en el archivo --->
<cfquery name="rsCheck0" datasource="#session.dsn#">
	select count(1) as check0
	from #table_name# a
	group by DEidentificacion, CIcodigo, Ifecha
	having count(DEidentificacion) != 1
</cfquery>

<cfif rsCheck0.RecordCount gt 0 and rsCheck0.check0 LT 1>
	<cfset bcheck0 = false>
</cfif>
<cfif bcheck0>
<!--- 1. Valida que no exista una incidencia igual --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	select count(1) as check1
	from #table_name# a, DatosEmpleado b, CIncidentes c, Incidencias d
	where rtrim(ltrim(a.DEidentificacion))=rtrim(ltrim(b.DEidentificacion))
		and rtrim(ltrim(a.CIcodigo))=rtrim(ltrim(c.CIcodigo))
		and b.DEid=d.DEid
		and c.CIid=d.CIid
		and a.Ifecha=d.Ifecha
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfset bcheck1 = rsCheck1.check1 LT 1>
<cfif bcheck1>
	<!--- 2. Valida existencia del empleado --->
	<cfquery name="rsCheckEmpl" datasource="#session.dsn#">
		select count(1) as checkEmpl
		from #table_name# 
		where rtrim(ltrim(DEidentificacion)) not in (select rtrim(ltrim(DEidentificacion))
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
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
							</cfquery>
							<cfif rsCheckConcepto.checkConcepto eq 0  >		
										<!--- *** I N I C I O *** --->
										<!--- Inserta Incidencias --->
										<cfif session.Incidencias.impcalculo><!---Si es importacion de incidencias tipo calculo--->											
										<cfquery datasource="#session.DSN#">
												insert into IMPIncidentes (DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo, RHJid)
												select 	( select min(DEid) from DatosEmpleado where ltrim(rtrim(DEidentificacion))=ltrim(rtrim(a.DEidentificacion)) and Ecodigo=#session.Ecodigo# ) as DEid, 
														( select min(CIid) from CIncidentes where ltrim(rtrim(CIcodigo))=ltrim(rtrim(a.CIcodigo)) and Ecodigo=#session.Ecodigo# ) as CIid, 
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
												from #table_name# a
											</cfquery>
											
													<cfquery name="rsListaRecorrido" datasource="#session.dsn#"><!--- para convertir la temporal en un query de coldfusion--->
														select Id
														from IMPIncidentes
													</cfquery>
													
													<cfset listaIdIncidencias=valueList(rsListaRecorrido.Id,',')>	
															
													<cfset Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!---Para utilizar la calculadora--->
														
													<cfloop list="#listaIdIncidencias#" index="Id">			<!--- recorre la lista de incidencias--->
											
													<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
																			select 	b.CIrango,
																					coalesce(b.CItipo,'m') as CItipo,
																					b.CIdia,
																					b.CImes,
																					b.CIcalculo,
																					c.Ifecha,
																					coalesce(b.CIcantidad,12) as CIcantidad,
																					c.DEid,
																					coalesce(c.RHJid,1) as RHJid,
																					(select Tcodigo from LineaTiempo x
																					 where x.DEid = c.DEid and LThasta = (select max(y.LThasta) from LineaTiempo y where y.DEid = x.DEid))  as Tcodigo
																					,c.DEid, c.CIid, c.CFid, c.Ifecha, c.Ifechasis
																					,c.Usucodigo, c.Ulocalizacion, c.RCNid, c.Icpespecial, c.IfechaRebajo 	
																					,c.Ivalor
																					, b.CIsprango
																					, coalesce(b.CIspcantidad,0) as CIspcantidad
																			from IMPIncidentes c	
																				inner join CIncidentes a
																					on c.CIid = a.CIid
																				left outer join CIncidentesD b
																					on a.CIid = b.CIid
																			where c.Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">				
																		</cfquery>
												
															
																<cfif rsDatosConcepto.RecordCount NEQ 0>		
																	<!------------------------------------------------->
																<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
																<cfset current_formulas = rsDatosConcepto.CIcalculo>

																<cfset presets_text = Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
																							   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
																							   rsDatosConcepto.CIcantidad,<!---CIcantidad--->																	  
																							   rsDatosConcepto.CIrango, <!---CIrango--->
																							   rsDatosConcepto.CItipo, <!---CItipo--->
																							   rsDatosConcepto.DEid,	<!---DEid--->
																							   rsDatosConcepto.RHJid, <!---RHJid--->
																							   session.Ecodigo, <!---Ecodigo--->
																							   0, <!---RHTid--->
																							   0, <!---RHAlinea--->																		   
																							   rsDatosConcepto.CIdia, <!---CIdia--->
																							   rsDatosConcepto.CImes,<!---CImes--->
																							   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
																							   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
																							   'false', <!---masivo--->
																							   '',<!---tabla_temporal--->
																							   0,<!---calc_diasnomina--->
																							   rsDatosConcepto.Ivalor
																							   , '' 
																							   ,rsDatosConcepto.CIsprango
																							   ,rsDatosConcepto.CIspcantidad
																							   )>
																	<cfset values = Calculadora.calculate( presets_text & ";" & current_formulas )>
																										
															   
																		<cfif Not IsDefined("values") or not isdefined("presets_text")>												
																			<cfinvoke component="sif.Componentes.Translate"
																				method="Translate"
																				Key="LB_NoEsPosibleRealizarElCalculo"
																				Default="No es posible realizar el calculo"
																				XmlFile="/rh/generales.xml"
																				returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
																			<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
																		</cfif>
																		<!----------------- Fin de calculadora ------------------->		
												
																		<cfquery name="rsIncidencias" datasource="#session.DSN#">
																			update IMPIncidentes
																			set Imontores=<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">
																				where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Id#">			
																		</cfquery>	
												
																</cfif>		
															

												</cfloop>	<!--- fin de recorrido de incidencias--->


										<cfelse>																						
											<cfquery name="rsIncidencias" datasource="#session.DSN#">
												insert into Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid, Icpespecial, IfechaRebajo )
												select 	( select min(DEid) from DatosEmpleado where ltrim(rtrim(DEidentificacion))=ltrim(rtrim(a.DEidentificacion)) and Ecodigo=#session.Ecodigo# ) as DEid, 
														( select min(CIid) from CIncidentes where ltrim(rtrim(CIcodigo))=ltrim(rtrim(a.CIcodigo)) and Ecodigo=#session.Ecodigo# ) as CIid, 
														( select min(CFid) from CFuncional where ltrim(rtrim(CFcodigo)) = ltrim(rtrim(a.CFcodigo)) and Ecodigo=#session.Ecodigo# ) as CFid, 
														a.Ifecha, 
														a.Ivalor, 
														<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> as Ifechasys, 
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as Usucodigo, 
														'00' as Ulocalizacion, 
														--( select min(CPid) from CalendarioPagos where ltrim(rtrim(CPcodigo)) =  ltrim(rtrim(a.CPcodigo)) and Ecodigo=#session.Ecodigo# ),
														null as RCNid,
														a.Icpespecial, 
														a.Ifecharebajo
												from #table_name# a
											</cfquery>
										</cfif>
                                        
							<cfelse><!--- bcheckConcepto --->
									<cfquery name="ERR" datasource="#session.dsn#">
										select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor 
										from #table_name# a
										where a.CIcodigo not in (select rtrim(ltrim(CIcodigo))
																from CIncidentes 
																where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
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
			where rtrim(ltrim(a.DEidentificacion)) not in ( 	select rtrim(ltrim(DEidentificacion))
												from DatosEmpleado b 
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	)
		</cfquery>
	</cfif><!--- bcheckEmpl --->
<cfelse><!--- bchek1 --->
	<cfquery name="ERR" datasource="#session.dsn#">
		select 'Registro ya existe' Motivo, a.DEidentificacion, b.DEidentificacion, DEnombre+' '+DEapellido1+' '+DEapellido2,a.CIcodigo, a.Ifecha, a.Ivalor
		from #table_name# a, DatosEmpleado b, CIncidentes c, Incidencias d
		where rtrim(ltrim(a.DEidentificacion)) = rtrim(ltrim(b.DEidentificacion))
		and rtrim(ltrim(a.CIcodigo))=rtrim(ltrim(c.CIcodigo))
		and b.DEid=d.DEid
		and c.CIid=d.CIid
		and a.Ifecha=d.Ifecha
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
</cfif><!--- bchek1 --->
<cfelse><!--- bchek0 --->
	<cfquery name="ERR" datasource="#session.dsn#">
		select 'Existen registros duplicados dentro del archivo cargado' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha
		from #table_name# a
		group by DEidentificacion, CIcodigo, Ifecha
		having count(DEidentificacion) != 1
	</cfquery>
</cfif><!--- bchek0 --->





----->