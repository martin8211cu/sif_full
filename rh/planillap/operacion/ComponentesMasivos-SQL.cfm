<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
	update RHEscenarios
		set RHEcalculado = 0
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
</cfquery>
<!---- ////////////////////////// INSERCION MASIVA DE COMPONENTES ///////////////////----->
<cfif isdefined("form.btn_aceptar")>
	<cfif isdefined("form.origen") and len(trim(form.origen)) and isdefined("form.RHEid") and len(trim(form.RHEid))>
		<cftransaction>
			<!---- /*/-*/-/-*/-*/-*/-*/-*/-*/-*/ COMPONTENTES DE TABLAS SALARIALES (RHDTablasEscenario) /-*/-*/-*/-*/-*/-*/-*/*-/-*/-*/----->
			<cfif form.origen EQ 'tablas' and isdefined("form.RHETEid") and len(trim(form.RHETEid))>			
				<!---Moneda de la empresa--->
				<cfquery name="rsMoneda" datasource="#session.DSN#">
					select Mcodigo
					from Empresas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<!---- /////////////////// Update del componente de las tablas salariales que ya lo tienen ///////////////////---->
				<cfquery name="rsUpdate" datasource="#session.DSN#">
					update RHDTablasEscenario
						set RHDTEmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Monto,',','','all')#">						
					from RHDTablasEscenario a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
						and a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
						and a.RHDTEfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ffinal)#">
						and a.RHDTEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.finicial)#">
						<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
							and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
						</cfif>
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>
				</cfquery>	
				<!----////////////////////// Inserta el componente a las tablas salariales que no lo tienen ////////////////////----->
				<cfquery name="rsInsert" datasource="#session.DSN#">
					insert into RHDTablasEscenario(	Ecodigo, 
													RHETEid, 
													RHEid, 
													RHTTid, 
													RHMPPid, 
													RHCid,
													CSid, 
													RHDTEmonto, 
													Mcodigo, 
													RHDTEfdesde, 
													RHDTEfhasta,
													BMfecha, 
													BMUsucodigo)
					select	distinct <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							a.RHETEid,
							a.RHEid,
							b.RHTTid,
							a.RHMPPid,
							a.RHCid,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Monto,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.finicial)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ffinal)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					from RHDTablasEscenario a
						inner join RHETablasEscenario b
							on a.RHETEid = b.RHETEid
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
						<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
							and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
						</cfif>
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>
						and not exists (select CSid from RHDTablasEscenario b
										where a.RHETEid = b.RHETEid
											and b.RHCid = a.RHCid
											and b.RHMPPid = a.RHMPPid 
											and b.Ecodigo = a.Ecodigo
											and b.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
											and b.RHDTEfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ffinal)#">
											and b.RHDTEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.finicial)#">
										) 
				</cfquery>
			<!---- /*/-*/-/-*/-*/-*/-*/-*/-*/-*/ COMPONTENTES DE PLAZAS (RHCSituacionActual) TAB SITUACION ACTUAL /-*/-*/-*/-*/*-/-*/-*/----->
			<cfelseif form.origen EQ 'sitactual'>
				<!----/////////////// Actualiza el MONTO a las plazas que ya tienen el componente ///////////////----->
				<cfquery name="rsUpdate" datasource="#session.DSN#">
					update RHCSituacionActual
						set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Monto,',','','all')#">
					from RHSituacionActual a
						inner join RHCSituacionActual b
							on a.RHSAid = b.RHSAid
							and a.Ecodigo = b.Ecodigo
							and b.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
							
						inner join RHPlazaPresupuestaria c
							on a.RHPPid = c.RHPPid
							and a.Ecodigo = c.Ecodigo
						
							<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
								inner join RHPlazas d
									on c.RHPPid = d.RHPPid
									and c.Ecodigo = d.Ecodigo
									and d.RHPactiva = 1								
								
									inner join RHPuestos e
										on d.RHPpuesto = e.RHPcodigo
										and d.Ecodigo = e.Ecodigo
										and e.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
							</cfif>				
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and a.RHPPid is not null					
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>
						<cfif isdefined("form.fhasta") and len(trim(form.fhasta))>
							and a.fdesdeplaza <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">						
						</cfif>	
						<cfif isdefined("form.fdesde") and len(trim(form.fdesde))>
							and a.fhastaplaza >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
						</cfif>								
				</cfquery>
				<!----/////////////// Inserta el componente a las Plazas que no lo tienen ///////////////------> 
				<cfquery name="rsInserta" datasource="#session.DSN#">
					insert into RHCSituacionActual(RHSAid, 
													CSid, 
													Ecodigo, 
													Cantidad, 
													Monto,
													CFformato, 
													BMfecha, 
													BMUsucodigo)
						select 	a.RHSAid,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#form.Cantidad#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Monto,',','','all')#">,
								<cfif isdefined("form.CScomplemento") and len(trim(form.CScomplemento))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#"><cfelse>null</cfif>,							
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">						
						from RHSituacionActual a	
								
							inner join RHPlazaPresupuestaria c
								on a.RHPPid = c.RHPPid
								and a.Ecodigo = c.Ecodigo
							
								<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
									inner join RHPlazas d
										on c.RHPPid = d.RHPPid
										and c.Ecodigo = d.Ecodigo	
										and d.RHPactiva = 1
									
										inner join RHPuestos e
											on d.RHPpuesto = e.RHPcodigo
											and d.Ecodigo = e.Ecodigo
											and e.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
								</cfif>	
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
							and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							and a.RHPPid is not null	
							<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
								and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
							</cfif>
							<cfif isdefined("form.fhasta") and len(trim(form.fhasta))>
								and a.fdesdeplaza <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">						
							</cfif>	
							<cfif isdefined("form.fdesde") and len(trim(form.fdesde))>
								and a.fhastaplaza >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
							</cfif>							
							and not exists (select 1 from RHCSituacionActual b
											where a.RHSAid = b.RHSAid 
												and a.Ecodigo = b.Ecodigo)							
				</cfquery>
			<!---- /*/-*/-/-*/-*/-*/-*/ COMPONTENTES DE PLAZAS SOLICITADAS (RHCSituacionActual) TAB SOLICITUD PLAZAS /-*/-*/-*/-*/*-/-*/-*/----->	
			<cfelseif form.origen EQ 'psolicitadas'>
				<!---Actualiza el monto del componente a las plazas solicitadas que ya lo tengan----->
				<cfquery name="rsUpdate" datasource="#session.DSN#">
					update RHCSituacionActual 
						set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Monto,',','','all')#">
					from RHSituacionActual pe
						inner join RHCSituacionActual cp
							on pe.RHSAid = cp.RHSAid
							and pe.Ecodigo = cp.Ecodigo
							and cp.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
						
						inner join RHSolicitudPlaza sp
							on pe.RHSPid = sp.RHSPid
							and pe.Ecodigo = sp.Ecodigo		
							<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
								and sp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
							</cfif>				
					where pe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and pe.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and pe.RHSPid is not null
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and pe.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>	
						<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
							and pe.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
						</cfif>	
						<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
							and pe.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
						</cfif>	
				</cfquery>			
				<!----Inserta el componente a las solicitudes de plaza que no lo tengan---->
				<cfquery name="rsInserta" datasource="#session.DSN#">
					insert into RHCSituacionActual(RHSAid, 
													CSid, 
													Ecodigo, 
													Cantidad, 
													Monto,
													CFformato, 
													BMfecha, 
													BMUsucodigo)				
						select 	pe.RHSAid,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#form.Cantidad#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.Monto,',','','all')#">,
								<cfif isdefined("form.CScomplemento") and len(trim(form.CScomplemento))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#"><cfelse>null</cfif>,							
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">			
						from RHSituacionActual pe
							inner join RHSolicitudPlaza sp
								on pe.RHSPid = sp.RHSPid
								and pe.Ecodigo = sp.Ecodigo
								<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
									and sp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
								</cfif>
	
						where pe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
							and pe.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							and pe.RHSPid is not null
							<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
								and pe.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
							</cfif>	
							<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
								and pe.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
							</cfif>	
							<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
								and pe.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
							</cfif>	
							and not exists (select 1 from RHCSituacionActual cp
											where pe.RHSAid = cp.RHSAid 
												and pe.Ecodigo = cp.Ecodigo
												and cp.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">)										
				</cfquery>
			</cfif>	
		</cftransaction>
		<script type="text/javascript" language="javascript1.2">
			window.close();
		</script>	
	</cfif>
<!---- ////////////////////////// ELIMINADO MASIVO DE COMPONENTES ///////////////////----->
<cfelseif isdefined("form.btn_eliminar")>
	<cfif isdefined("form.origen") and len(trim(form.origen)) and isdefined("form.RHEid") and len(trim(form.RHEid))>
		<cftransaction>			
			<!---- /*/-*/-/-*/-*/-*/-*/-*/-*/-*/ COMPONTENTES DE TABLAS SALARIALES (RHDTablasEscenario) /-*/-*/-*/-*/-*/-*/-*/*-/-*/-*/----->
			<cfif form.origen EQ 'tablas' and isdefined("form.RHETEid") and len(trim(form.RHETEid))>							
				<!---- /////////////////// Elimina del componente de las tablas salariales que lo tienen ///////////////////---->
				<cfquery name="rsdelete" datasource="#session.DSN#">
					delete  RHDTablasEscenario
					from RHDTablasEscenario a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
						and a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
						<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
							and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
						</cfif>
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>
				</cfquery>
			<!---- /*/-*/-/-*/-*/-*/-*/-*/-*/-*/ COMPONTENTES DE PLAZAS (RHCSituacionActual) TAB SITUACION ACTUAL /-*/-*/-*/-*/*-/-*/-*/----->
			<cfelseif form.origen EQ 'sitactual'>
				<!----/////////////// Elimina las plazas que tienen el componente ///////////////----->
				<cfquery name="rsdelete" datasource="#session.DSN#">
					delete RHCSituacionActual
					from RHSituacionActual a
						inner join RHCSituacionActual b
							on a.RHSAid = b.RHSAid
							and a.Ecodigo = b.Ecodigo
							and b.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
							
						inner join RHPlazaPresupuestaria c
							on a.RHPPid = c.RHPPid
							and a.Ecodigo = c.Ecodigo
						
							<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
								inner join RHPlazas d
									on c.RHPPid = d.RHPPid
									and c.Ecodigo = d.Ecodigo
									and d.RHPactiva = 1								
								
									inner join RHPuestos e
										on d.RHPpuesto = e.RHPcodigo
										and d.Ecodigo = e.Ecodigo
										and e.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
							</cfif>				
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and a.RHPPid is not null					
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>
						<cfif isdefined("form.fhasta") and len(trim(form.fhasta))>
							and a.fdesdeplaza <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">						
						</cfif>	
						<cfif isdefined("form.fdesde") and len(trim(form.fdesde))>
							and a.fhastaplaza >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
						</cfif>								
				</cfquery>
			<!---- /*/-*/-/-*/-*/-*/-*/ COMPONTENTES DE PLAZAS SOLICITADAS (RHCSituacionActual) TAB SOLICITUD PLAZAS /-*/-*/-*/-*/*-/-*/-*/----->	
			<cfelseif form.origen EQ 'psolicitadas'>
				<!---///////// Elimina el componente de las plazas solicitadas que lo tengan /////////----->
				<cfquery name="rsdelete" datasource="#session.DSN#">
					delete RHCSituacionActual 
					from RHSituacionActual pe
						inner join RHCSituacionActual cp
							on pe.RHSAid = cp.RHSAid
							and pe.Ecodigo = cp.Ecodigo
							and cp.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
						
						inner join RHSolicitudPlaza sp
							on pe.RHSPid = sp.RHSPid
							and pe.Ecodigo = sp.Ecodigo		
							<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
								and sp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
							</cfif>				
					where pe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
						and pe.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and pe.RHSPid is not null
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							and pe.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						</cfif>	
						<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
							and pe.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
						</cfif>	
						<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
							and pe.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
						</cfif>	
				</cfquery>			
			</cfif>	
		</cftransaction>
		<script type="text/javascript" language="javascript1.2">
			window.close();
		</script>	
	</cfif>
</cfif>	

