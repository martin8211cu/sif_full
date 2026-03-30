<cfsetting requesttimeout="8400">
<!----////////////////////// PROCESO DE IMPORTACION DE PLAZAS PRESUPUESTARIAS //////////////////////------>
<cfoutput>
<cf_navegacion name="RHPPids" navegacion="">
<cfif isdefined("form.Importar") or isdefined('form.RHPPids')>
	<cfif isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))
		and isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>		
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<cfif not isdefined('form.RHPPids')>
			<cftransaction>
			<!----//////////////// ELIMINAR EL CALCULO DEL ESCENARIO //////////////////---->
			<!---Eliminar cortes del detalle(componentes) de la formulacion---->
			<cfquery datasource="#session.DSN#">
				delete RHCortesPeriodoF
				from RHCortesPeriodoF a			
					inner join RHCFormulacion b
						on a.RHCFid = b.RHCFid and a.Ecodigo = b.Ecodigo
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
			<!----Eliminar formulacion del escenario------>
			<cfquery datasource="#session.DSN#">
				delete 
				from RHFormulacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<!-----//////////////// ELIMINAR DATOS DEL TAB DE EMPLEADOS ///////////////------>
			<cfquery datasource="#session.DSN#">
				delete from RHComponentesPlaza
				where RHPEid in (select RHPEid 
								from RHPlazasEscenario
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
								  and RHPPid is not null
								)
			</cfquery>
			<!----Eliminar las plazas actuales importadas para el escenario---->
			<cfquery datasource="#session.DSN#">
				delete from RHPlazasEscenario
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
					and RHPPid is not null
			</cfquery>
	
			<!----//////////////// ELIMINAR LA SITUACION ACTUAL //////////////////---->
			<!--- Eliminar los componentes de las plazas actuales importadas para escenario --->
			<cfquery datasource="#session.DSN#">
				delete from RHCSituacionActual
				where RHSAid in (select RHSAid
								from RHSituacionActual
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
									and RHPPid is not null								
								)
			</cfquery>
			<!----Eliminar las plazas actuales importadas para el escenario---->
			<cfquery datasource="#session.DSN#">
				delete from RHSituacionActual
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
					and RHPPid is not null
			</cfquery>
			</cftransaction>
		</cfif>
		<!----////////////////////// Insertar de nuevo la situacion actual //////////////////// ---->				    
		<cftransaction>
			<cfquery name="rsTEscenario" datasource="#session.DSN#">	
				select RHTTid
				from RHETablasEscenario
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<cfset Lvar_TablasEscenario = rsTEscenario.RHTTid>
			<cfif len(trim(Lvar_TablasEscenario)) eq 0>
				<cfthrow message="No se ha definido la Tabla Salarial">
			</cfif>
			<!----///////////// INSERTA LAS PLAZAS ACTUALES CON EL CORRESPONDIENTE EMPLEADO ASIGNADO ///////////---->			
			<cfquery name="rsEncabezado" datasource="#session.DSN#">
				insert into RHPlazasEscenario (RHEid, 
												RHPPid, 
												RHPEfinicioplaza, 
												RHPEffinplaza, 
												RHCid, 
												RHMPPid, 
												RHTTid, 
												RHSPid, 
												Ecodigo, 
												DEid, 
												BMfecha, 
												BMUsucodigo	)									
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
							pp.RHPPid,
							lt.LTdesde, 
							lt.LThasta,
							ltp.RHCid,
							ltp.RHMPPid,
							ltp.RHTTid,
							null,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							lt.DEid,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							
					from RHPlazaPresupuestaria pp
							inner join RHLineaTiempoPlaza ltp
								on ltp.Ecodigo = pp.Ecodigo
								and pp.RHPPid = ltp.RHPPid
							inner join LineaTiempo lt
								on lt.RHPid = ltp.RHPid 
								and lt.LTdesde <= ltp.RHLTPfhasta
								and lt.LThasta >= ltp.RHLTPfdesde
							inner join TiposNomina tn
								on tn.Ecodigo = lt.Ecodigo
								and tn.Tcodigo = lt.Tcodigo	
					where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">									
							and ltp.RHLTPfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">
							and ltp.RHLTPfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#">
							and ltp.RHMPestadoplaza = 'A'
							and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">
							and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#"> 
							<cfif isdefined('form.RHPPids')>
								and pp.RHPPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHPPids#">)
							</cfif>
			</cfquery>
			<cfquery name="rsDetalle" datasource="#session.DSN#">
				insert into RHComponentesPlaza (RHPEid, 
												CSid, 
												Ecodigo, 
												Cantidad, 
												Monto, 
												CFformato, 
												BMfecha, 
												BMUsucodigo)
					select 	e.RHPEid,
							d.CSid,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							dlt.DLTunidades,
							d.Monto,
							d.CFformato,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">					 					 		
					from RHPlazaPresupuestaria b
		
						inner join RHLineaTiempoPlaza c
							on b.RHPPid = c.RHPPid
							and b.Ecodigo = c.Ecodigo
							
							inner join LineaTiempo lt
								on lt.RHPid = c.RHPid 
								and lt.LTdesde <= c.RHLTPfhasta
								and lt.LThasta >= c.RHLTPfdesde
							inner join RHPlazasEscenario e
								on e.RHPPid=c.RHPPid
								and e.Ecodigo = c.Ecodigo
								and e.RHPEfinicioplaza = lt.LTdesde
								and e.RHPEffinplaza = lt.LThasta
																
							inner join RHCLTPlaza d
								on c.RHLTPid = d.RHLTPid
								and c.Ecodigo = d.Ecodigo
                            inner join DLineaTiempo dlt
                            	on dlt.LTid = lt.LTid
                                and dlt.CSid = d.CSid
											
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
								and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">
								and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#"> 
					  and c.RHTTid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Lvar_TablasEscenario#">)
					  <cfif isdefined('form.RHPPids')>
						and b.RHPPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHPPids#">)
					  </cfif>
			</cfquery>
			<!-----////////////////////// INSERTAR LA SITUACION ACTUAL ////////////////////////----->
			<cfquery name="rsEncabezado" datasource="#session.DSN#">				
				insert into RHSituacionActual(RHEid, 
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
											BMfecha, 
											BMUsucodigo
											)					
					select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#"> 		as RHEid,
							pp.RHPPid 															as RHPPid,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,
							ltp.RHTTid 	as RHTTid,
							ltp.RHMPPid as RHMPPid,
							ltp.RHCid 	as RHCid,
							null 		as RHSPid,
							ete.RHETEfdesde 	as fdesdeplaza,
							ete.RHETEfhasta 	as fhastaplaza,
							ltp.RHMPnegociado 	as RHMPnegociado,
							ltp.CFidautorizado 	as CFid,
							null 				as RHSAocupada,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 		  as BMfecha, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as BMUsucodigo												
					from RHPlazaPresupuestaria pp
						inner join RHLineaTiempoPlaza ltp
							on ltp.Ecodigo = pp.Ecodigo
							and pp.RHPPid = ltp.RHPPid
							and ltp.RHMPestadoplaza = 'A'
							and ltp.RHLTPfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfhasta#">
							and ltp.RHLTPfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHEfdesde#">
							and ltp.CFidautorizado is not null
						inner join RHETablasEscenario ete
							on ete.RHTTid = ltp.RHTTid		
					where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ltp.RHTTid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Lvar_TablasEscenario#">)
					<cfif isdefined('form.RHPPids')>
						and pp.RHPPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHPPids#">)
					</cfif>	
					and ete.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			
			<!---Inserta componentes para c/plaza presupuestaria insertada anteriormente---->
			<cfquery name="rsDetalle" datasource="#session.DSN#">
				insert into RHCSituacionActual(RHSAid, 
												CSid, 
												Ecodigo, 
												Cantidad, 
												Monto,
												CFformato, 
												BMfecha, 
												BMUsucodigo)
					select 	e.RHSAid,
							d.CSid,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							d.Cantidad,
							d.Monto,
							d.CFformato,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">					 					 		
					from RHPlazaPresupuestaria b
		
						inner join RHLineaTiempoPlaza c
							on b.RHPPid = c.RHPPid
							and b.Ecodigo = c.Ecodigo
		
							inner join RHSituacionActual e
								on e.RHPPid=c.RHPPid
								and e.Ecodigo = c.Ecodigo
								and e.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							
							inner join RHCLTPlaza d
								on c.RHLTPid = d.RHLTPid
						
								<!----and c.Ecodigo = d.Ecodigo---->
											
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and c.RHTTid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Lvar_TablasEscenario#">)
					<cfif isdefined('form.RHPPids')>
						and b.RHPPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHPPids#">)
					</cfif>	
			</cfquery>
			
			<cfquery name="rsUpSB" datasource="#session.dsn#">
				update RHCSituacionActual set Monto=(Select coalesce(min(RHDTEmonto),0) 
                										from RHDTablasEscenario a
														Inner join RHSituacionActual b
															on b.RHEid=a.RHEid
															and b.RHTTid =a.RHTTid
															and b.RHMPPid=a.RHMPPid
															and b.RHCid=a.RHCid		
															and a.RHDTEfdesde between b.fdesdeplaza and b.fhastaplaza
														Inner join RHCSituacionActual c
															on c.CSid=a.CSid
													Where c.RHSAid=b.RHSAid
													and c.RHSAid=RHCSituacionActual.RHSAid
													and c.CSid=RHCSituacionActual.CSid
													and a.RHEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
													and c.CSid in (select CSid from ComponentesSalariales where CSsalariobase=1) 
													)
				where CSid in (select CSid from ComponentesSalariales where CSsalariobase=1)  
			</cfquery>
            <!--- SE ACTUALIZA LA CANTIDAD PARA LOS COMPONENTES SALARIALES DE LA SITUACION PROPUESTA --->
            <cfquery datasource="#session.DSN#">
            	update RHCSituacionActual
                set Cantidad = coalesce((select max(Cantidad) 
                                    from RHPlazasEscenario pe
                                    inner join RHComponentesPlaza cpe
                                        on cpe.RHPEid = pe.RHPEid
                                     where pe.RHPPid = a.RHPPid
                                        and cpe.CSid = b.CSid),1)
                from RHSituacionActual a
                inner join RHCSituacionActual b
                    on b.RHSAid = a.RHSAid
                inner join ComponentesSalariales c
                    on c.CSid = b.CSid
                    and c.Ecodigo = a.Ecodigo
                where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
                  and c.CSsalariobase = 0
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>
            <!--- FIN ACTUALIZA CANTIDAD --->
			<!---- //////////////////// ACTUALIZA EL ESTADO DE LAS PLAZAS OCUPADAS ///////////////---->
			<cfquery name="rsUpdateEstado" datasource="#session.DSN#">
				update RHSituacionActual
					set RHSAocupada = 1
				from RHSituacionActual sta
					inner join RHPlazaPresupuestaria pp
						on pp.RHPPid = sta.RHPPid
						
                    inner join RHPlazas pl
                        on pl.RHPPid = pp.RHPPid
                        and pl.Ecodigo = pp.Ecodigo
                        
                    inner join LineaTiempo lt
                        on pl.RHPid = lt.RHPid
                        and sta.fdesdeplaza <= lt.LThasta
                        and sta.fhastaplaza >= lt.LTdesde
				
				where sta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and sta.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">		
                    and pl.RHPactiva = 1
					<cfif isdefined('form.RHPPids')>
						and pp.RHPPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHPPids#">)
					</cfif>			
			</cfquery>			
			<!--- /////////////////////////// ACTUALIZA EL COMPLEMENTO (CFformato) /////////////////////////////---->	
			<cfquery name="rsUpdateCFformato" datasource="#session.DSN#">
				update RHCSituacionActual
					set CFformato = cs.CScomplemento
				from RHCSituacionActual cp
					inner join ComponentesSalariales cs
						on cp.CSid = cs.CSid
						and cp.Ecodigo = cs.Ecodigo
				where RHSAid in (select RHSAid 
								from RHSituacionActual
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
									<cfif isdefined('form.RHPPids')>
										and RHPPid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHPPids#">)
									<cfelse>
										and RHPPid is not null
									</cfif>	
									)									
			</cfquery>			
		</cftransaction>		
	</cfif>	
<cfelseif isdefined("url.btnEliminar")>
	<cfif isdefined('form.RHEid') and isdefined('form.RHSAid')>
		<cfquery name="rsBorrarSA" datasource="#session.DSN#">
			select RHTTid, RHSAid, RHPPid, CFid, fdesdeplaza, fhastaplaza
			from RHSituacionActual
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			  and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
		</cfquery>
		<cftransaction>
			<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
			<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
				update RHEscenarios
					set RHEcalculado = 0
				where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			</cfquery>
			<!---Eliminar cortes del detalle(componentes) de la formulacion---->
			<cfquery datasource="#session.DSN#">
				delete RHCortesPeriodoF
				from RHCortesPeriodoF a			
					inner join RHCFormulacion b
						on a.RHCFid = b.RHCFid and a.Ecodigo = b.Ecodigo
					inner join RHFormulacion c
						on c.RHFid = b.RHFid and c.Ecodigo = b.Ecodigo
						  and c.RHEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						  and c.RHSAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">			
				where a.Ecodigo = #session.Ecodigo#
			</cfquery>
			<!---Eliminar componentes de la formulacion---->
			<cfquery datasource="#session.DSN#">
				delete RHCFormulacion 
				from RHCFormulacion a
					inner join RHFormulacion b
						on b.RHFid=a.RHFid
						  and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						  and b.RHSAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">	
				where a.Ecodigo = #session.Ecodigo#
			</cfquery>
			<!----Eliminar formulacion del escenario------>
			<cfquery datasource="#session.DSN#">
				delete from RHFormulacion
				where Ecodigo = #session.Ecodigo#
				  and RHEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				  and RHSAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">	
			</cfquery>
			<!----- ELIMINAR DATOS DEL TAB DE EMPLEADOS ------>
			<cfquery datasource="#session.DSN#">
				delete from RHComponentesPlaza
				where RHPEid in (select RHPEid 
								from RHPlazasEscenario pe
								where pe.Ecodigo = #session.Ecodigo#
								  and pe.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
								  and pe.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBorrarSA.RHPPid#">
								  and not exists(select 1 from 
								  			 RHSituacionActual sa 
											 where sa.RHSAid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
											   and sa.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBorrarSA.RHPPid#">
											   and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
											 )
								)
			</cfquery>
			<!----Eliminar las plazas actuales importadas para el escenario---->
			<cfquery datasource="#session.DSN#">
				delete from RHPlazasEscenario
				where Ecodigo = #session.Ecodigo#
				  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
				  and RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBorrarSA.RHPPid#">
				  and not exists(select 1 from 
							 RHSituacionActual sa 
							 where sa.RHSAid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
							   and sa.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBorrarSA.RHPPid#">
							   and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							 )
			</cfquery>
			<!----//////////////// ELIMINAR LA SITUACION ACTUAL //////////////////---->
			<!--- Eliminar los componentes de las plazas actuales importadas para escenario --->
			<cfquery datasource="#session.DSN#">
				delete from RHCSituacionActual
				where RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">	
			</cfquery>
			
			<!----Eliminar las plazas actuales importadas para el escenario---->
			<cfquery datasource="#session.DSN#">
				delete from RHSituacionActual
				where Ecodigo = #session.Ecodigo#
					and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
					and RHPPid is not null
			</cfquery>
			
			<!---<!--- Elimina Detalle Otras Partidas Con Distribusion por C. Funcional--->
			<cfquery datasource="#session.dsn#">
				delete from RHDOtrasPartidas
					from RHDOtrasPartidas dop
						inner join RHOtrasPartidas eop
							on eop.RHOPid = dop.RHOPid
							  and eop.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						inner join RHPOtrasPartidas pop
							on pop.Ecodigo = eop.Ecodigo and pop.RHPOPid = eop.RHPOPid and pop.RHPOPdistribucionCF = 1
				where dop.CFid not in (select distinct CFid
							  from RHSituacionActual
							  where Ecodigo = #session.Ecodigo#
								and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
								and RHPPid is not null
							 )
			</cfquery>

			
			<!--- Elimina Encabezado Otras Partidas --->
			<cfquery datasource="#session.dsn#">
				delete from RHOtrasPartidas
				where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				 and (select count(1) from RHDOtrasPartidas dop where dop.RHOPid = RHOtrasPartidas.RHOPid) = 0
			</cfquery>--->
			
		</cftransaction>
	</cfif>
</cfif>

<form action="SA-PPresupuestarias.cfm" method="post" name="sql">
	<cfif isdefined("form.RHEid") and Len(Trim(form.RHEid))>
		<input name="RHEid" type="hidden" value="#Form.RHEid#">
	</cfif>
</form>
</cfoutput>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
