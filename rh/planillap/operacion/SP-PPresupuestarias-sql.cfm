<cfoutput>
<!----///////////////// ELIMINADO DE PLAZA SOLICITADA /////////////////////////----->
<cfif isdefined("form.RHSAidEliminar") and len(trim(form.RHSAidEliminar)) and isdefined("form.RHSAidEliminar")>	
	<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
	<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
		update RHEscenarios
			set RHEcalculado = 0
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
	<!----//////////////// Eliminar el registro de la formulacion //////////////////---->
	<!---Eliminar  cortes de la formulacion--->
	<cfquery name="rsEliminaCortesF" datasource="#session.DSN#">
		delete  RHCortesPeriodoF 
		from RHCortesPeriodoF a		
			inner join RHCFormulacion b
				on a.RHCFid = b.RHCFid
				and a.Ecodigo = b.Ecodigo
			inner join RHFormulacion c
				on b.RHFid = c.RHFid
				and b.Ecodigo = c.Ecodigo
				and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				and c.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAidEliminar#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!---Eliminar  Componentes de la formulacion--->
	<cfquery name="rsEliminaComponentesF" datasource="#session.DSN#">
		delete RHCFormulacion
		from RHCFormulacion a
			inner join RHFormulacion b
				on a.RHFid = b.RHFid
				and a.Ecodigo = b.Ecodigo	
				and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				and b.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAidEliminar#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!---Eliminar registro en Formulacion--->
	<cfquery name="rsEliminaComponentesF" datasource="#session.DSN#">				
		delete from RHFormulacion
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAidEliminar#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!----//////////////// Eliminar las solicitudes de plaza //////////////////---->
	<!----Eliminar detalles (Componenetes)----->
	<cfquery name="rsEliminaDetalle" datasource="#session.DSN#">
		delete from RHCSituacionActual
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAidEliminar#">		
	</cfquery>
	<!----Eliminar encabezados (Plazas)----->
	<cfquery name="rsEliminaDetalle" datasource="#session.DSN#">
		delete from RHSituacionActual
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAidEliminar#">
	</cfquery>	
</cfif>
<!----////////////////////// PROCESO DE IMPORTACION DE SOLICITUDES DE PLAZAS PRESUPUESTARIAS //////////////////////------>
<cfif isdefined("form.btn_importar")>
	<cfif isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta)) and isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))
		and isdefined("form.RHEid") and len(trim(form.RHEid))>					
		<cfoutput>
			<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
			<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
				update RHEscenarios
					set RHEcalculado = 0
				where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<!----//////////////// ELIMINAR EL CALCULO DEL ESCENARIO //////////////////---->
			<!---Eliminar cortes del detalle(componentes) de la formulacion---->
			<cfquery datasource="#session.DSN#">
				delete RHCortesPeriodoF
				from RHCortesPeriodoF a			
					inner join RHCFormulacion b
						on a.RHCFid = b.RHCFid
						and a.Ecodigo = b.Ecodigo
				
						inner join RHFormulacion c
							on c.RHFid = b.RHFid
							and c.Ecodigo = b.Ecodigo
							and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">			
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<!---Eliminar componentes de la formulacion---->
			<cfquery datasource="#session.DSN#">
				delete RHCFormulacion 
				from RHCFormulacion a
				inner join RHFormulacion b
					on b.RHFid=a.RHFid
					and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<!----Eliminar formulacio del escenario------>
			<cfquery name="rsElimina" datasource="#session.DSN#">
				delete 
				from RHFormulacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<!----//////////////////////////// ELIMINAR LAS PLAZAS SOLICITADAS /////////////////////////////// ---->						
			<!--- Eliminar los componentes de las plazas solicitadas importadas para escenario --->
			<cfquery name="EliminaDetalle" datasource="#session.DSN#">
				delete from RHCSituacionActual
				where exists (select RHSAid 
								from RHSituacionActual
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
									and RHSPid is not null	
								)
			</cfquery>
			<!---Eliminar todos los registros que tengan RHSPid (Los que fueron importados desde la solicitud de plazas)---->
			<cfquery name="EliminaENcabezado" datasource="#session.DSN#">
				delete from RHSituacionActual
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					and RHSPid is not null	
			</cfquery>
			<!----//////////////////////////// INSERTAR DE NUEVO LAS PLAZAS CON LOS CAMBIOS /////////////////////////////// ---->
			<cftransaction>
				<cfquery name="rsSolicitadas" datasource="#session.DSN#">
					select 	a.RHSPconsecutivo as 'A', a.RHSPfdesde,
							a.RHSPfhasta,
							a.RHCid,
							a.RHMPPid,
							a.RHTTid,
							a.RHSPid,
							a.saldo as RHSPcantidad,
							a.RHMPnegociado,
							a.CFid
									
					from RHSolicitudPlaza a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHSPestado = 20 <!---Al aplicar solicitudes desde RH se ponen en estado 20 ---->
						and a.saldo > 0 
						and a.RHSPfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">				
						and a.RHSPfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#">					
						<!---QUITAR VALIDACION DE QUE RHMPPid no sea nulo (SE SUPONE QUE ESE VALOR SE LLENA SIEMPRE)
						and a.RHMPPid is not null
						----->
						<!--- solo las tablas salariales del escenario, confirmado por marcel --->
						and exists ( select te.RHTTid
									 from RHDTablasEscenario te
									 where te.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
									 and te.RHTTid = a.RHTTid )
				</cfquery>

				<cfloop query="rsSolicitadas"><!---Para c/solicitud de plaza----->								
					<!---<cfloop index="i" from="1" to="#rsSolicitadas.RHSPcantidad#">---><!----Insertar n registros segun el campo RHSPcantidad de c/solicitud---->
						<!----VALIDAR SI EL SALARIO ES NEGOCIADO O NO---->
						<!----=========================== SI ES NEGOCIADO ========================================
								Solicitudes que SON negociadas, los datos de los componentes se toman 
								de: RHCSolicitud 
						===================================================================---->
						<cfif rsSolicitadas.RHMPnegociado EQ 'N' or len(trim(rsSolicitadas.RHMPnegociado)) EQ 0>	
							<!----//////////// Inserta el encabezado ///////////--->
							<cfquery name="rsEncabezado" datasource="#session.DSN#">
								insert into RHSituacionActual(	RHEid, 
																RHPPid, 
																Ecodigo, 
																RHTTid, 
																RHMPPid, 
																RHCid, 
																RHSPid, 
																fdesdeplaza, 
																fhastaplaza, 
																RHMPnegociado, 
																CFid, 
																RHSAocupada, 
																<!----RHMPestadoplaza, Inserta el Default 'A' (Activa)---->
																BMfecha, 
																BMUsucodigo
																)																			
									values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
											null,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
											<cfif isdefined("rsSolicitadas.RHTTid") and len(trim(rsSolicitadas.RHTTid))>
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHTTid#">
											<cfelse>
												null
											</cfif>,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHMPPid#">,
											<cfif isdefined("rsSolicitadas.RHCid") and len(trim(rsSolicitadas.RHCid))>
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHCid#">
											<cfelse>
												null
											</cfif>,								
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHSPid#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSolicitadas.RHSPfdesde#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSolicitadas.RHSPfhasta#">,
											<cfif len(trim(rsSolicitadas.RHMPnegociado))>
												<cfqueryparam cfsqltype="cf_sql_char" value="#rsSolicitadas.RHMPnegociado#">
											<cfelse>
												'N'
											</cfif>,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.CFid#">,
											null,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">						
											)
									<cf_dbidentity1 datasource="#session.DSN#">			
							</cfquery>
							<cf_dbidentity2 datasource="#session.DSN#" name="rsEncabezado">
							<!----////////////// Inserta el detalle ////////////////////----->
							<cfquery name="rsDetalle" datasource="#session.DSN#">
								insert into RHCSituacionActual(RHSAid, 
															CSid, 
															Ecodigo, 
															Cantidad, 
															Monto,
															CFformato, 
															BMfecha, 
															BMUsucodigo)
									select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.identity#">,
											c.CSid,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
											c.Cantidad,
											c.Monto,										
											d.CScomplemento,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									from RHSolicitudPlaza b
										
										inner join RHCSolicitud c
											on b.RHSPid = c.RHSPid
											and b.Ecodigo = c.Ecodigo
											
											left outer join ComponentesSalariales d
												on c.CSid = d.CSid
												and c.Ecodigo = d.Ecodigo
											
									where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and b.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHSPid#">					
							</cfquery>		
						<cfelse>
							<!----=========================== SI NO ES NEGOCIADO ========================================
									Solicitudes que NO son negociadas, los datos de los componentes se toman 
									de: RHDTablasEscenario.
									Se insertan N registros con cortes segun las tablas salariales en
									las que caigan
							===================================================================---->													
							<!----Obtener los datos------>
							<cfquery name="rsDatos" datasource="#session.DSN#">
								select 	distinct 
										c.RHTTid,
										c.RHMPPid,
										c.RHCid,
										b.RHSPid,
										e.RHETEfdesde as fdesdeplaza,
										e.RHETEfhasta as fhastaplaza,
										b.RHMPnegociado,
										b.CFid,
										e.RHETEid
																				
									from RHSolicitudPlaza b																		
									inner join RHDTablasEscenario c
										on b.RHMPPid = c.RHMPPid
										and b.RHCid = c.RHCid
										and b.RHTTid = c.RHTTid	
									    and b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHTTid#">
									    and b.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHMPPid#">
									    and b.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHCid#">										  
										
										and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
										<!---and b.RHSPfdesde <= c.RHDTEfhasta
										and b.RHSPfhasta >= c.RHDTEfdesde--->
										
									inner join RHETablasEscenario e
										on c.RHETEid = e.RHETEid																														
																												
								where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and b.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.RHSPid#">
							</cfquery>
							<!----Para cada corte(Tabla salarial) contenidas en las fechas de la solicitud 
								  insertar los componentes de la tabla------>
							<cfloop query="rsDatos">
								<!----//////////// Inserta el encabezado ///////////--->
								<cfquery name="rsEncabezado" datasource="#session.DSN#">
									insert into RHSituacionActual(  RHEid, 
																	RHPPid, 
																	Ecodigo, 
																	RHTTid, 
																	RHMPPid, 
																	RHCid, 
																	RHSPid, 
																	fdesdeplaza, 
																	fhastaplaza, 
																	RHMPnegociado, 
																	CFid, 
																	RHSAocupada, 
																	<!----RHMPestadoplaza, Inserta el Default 'A' (Activa)---->
																	BMfecha, 
																	BMUsucodigo
																	)																												
										values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
												null,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
												<cfif isdefined("rsDatos.RHTTid") and len(trim(rsDatos.RHTTid))>
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHTTid#">
												<cfelse>
													null
												</cfif>,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHMPPid#">,
												<cfif isdefined("rsDatos.RHCid") and len(trim(rsDatos.RHCid))>
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCid#">
												<cfelse>
													null
												</cfif>,								
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHSPid#">,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.fdesdeplaza#">,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.fhastaplaza#">,
												<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.RHMPnegociado#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitadas.CFid#">,
												null,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">	
												)
									<cf_dbidentity1 datasource="#session.DSN#">			
								</cfquery>
								<cf_dbidentity2 datasource="#session.DSN#" name="rsEncabezado">
								<!----//////////////// Inserta el detalle /////////////////---->
								<cfquery name="rsDetalle" datasource="#session.DSN#">
									insert into RHCSituacionActual(RHSAid, 
																CSid, 
																Ecodigo, 
																Cantidad, 
																Monto,
																CFformato, 
																BMfecha, 
																BMUsucodigo)
										select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.identity#">,
												a.CSid,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
												1,
												a.RHDTEmonto,										
												b.CScomplemento,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
										from RHDTablasEscenario a 
											inner join ComponentesSalariales b
												on a.CSid = b.CSid	
										where a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHETEid#">
										<!--- ================================================================================= --->
										  and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHTTid#">
										  and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHMPPid#">
										  and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCid#">										  
										<!--- ================================================================================= --->
								</cfquery>
							</cfloop><!---Fin de loop de cortes de tablas salariales---->
						</cfif><!---Fin de si es Negociado----->
					<!---</cfloop>--->
				</cfloop>
			</cftransaction>
		</cfoutput>	
	</cfif>
</cfif>
<form action="SP-PPresupuestarias.cfm" method="post" name="sql">
	<cfif isdefined("form.RHEid") and Len(Trim(form.RHEid))>
		<input name="RHEid" type="hidden" value="#Form.RHEid#">
	</cfif>
	<cfif isdefined("form.RHEfhasta") and Len(Trim(form.RHEfhasta))>
		<input name="RHEfhasta" type="hidden" value="#Form.RHEfhasta#">
	</cfif>
	<cfif isdefined("form.RHEfdesde") and Len(Trim(form.RHEfdesde))>
		<input name="RHEfdesde" type="hidden" value="#Form.RHEfdesde#">
	</cfif>
</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
