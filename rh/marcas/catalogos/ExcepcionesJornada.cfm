<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<!--- Filtro --->

<cfif isdefined("url.RHJid_f")and len(trim(url.RHJid_f))NEQ 0>
	 <cfset form.RHJid_f = url.RHJid_f> 
</cfif>

<cfif isdefined("url.CIid_f")and len(trim(url.CIid_f))NEQ 0>
	<cfset form.CIid_f = url.CIid_f>
</cfif>

<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<!---============ TRADUCCION ================---->
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Planificación de Jornadas"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Fitrar"
			Default="Fitrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Fitrar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Jornada"
			Default="Jornada"
			returnvariable="LB_Jornada"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Incidencia"
			Default="Incidencia"
			returnvariable="LB_Incidencia"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Hora_Inicial"
			Default="Hora Inicial"
			returnvariable="LB_Hora_Inicial"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Hora_Final"
			Default="Hora Final"
			returnvariable="LB_Hora_Final"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_L_Lunes"
			Default="L"
			returnvariable="LB_L_Lunes"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_K_Martes"
			Default="K"
			returnvariable="LB_K_Martes"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_M_Miercoles"
			Default="M"
			returnvariable="LB_M_Miercoles"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_J_Jueves"
			Default="J"
			returnvariable="LB_J_Jueves"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_V_Viernes"
			Default="V"
			returnvariable="LB_V_Viernes"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_S_Sabado"
			Default="S"
			returnvariable="LB_S_Sabado"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_D_Domingo"
			Default="D"
			returnvariable="LB_D_Domingo"/>
	
			
		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
			
			<!--- Navegacion --->
			<cfset navegacion = "">
			
			<cfif isdefined("form.CIid_f")and len(trim(form.CIid_f))NEQ 0>
				<cfset navegacion = navegacion & 'CIid_f='& form.CIid_f>
			</cfif>
			
			<cfif isdefined("form.RHJid_f")and len(trim(form.RHJid_f))NEQ 0>
				<cfif navegacion NEQ "">
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "RHJid_f="&form.RHJid_f>
					<!--- <cfset navegacion = navegacion & ' & RHJid_f='&form.RHJid_f> --->
				<cfelse>	
					<cfset navegacion = navegacion & 'RHJid_f='&form.RHJid_f>
					<!--- <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "RHJid_f="&form.RHJid_f> --->
				</cfif> 
			</cfif>
			
			
			<!---  --->
			<table width="100%">
			<tr>
				<!--- Lista y filtro --->
				<td width="50%" valign="top">
					
					<table width="100%">
					<tr>
						<!--- Filtro --->
						<td valign="top">
								
								<cfquery name="rsJornadas" datasource="#Session.DSN#">
									select 	RHJid, 
											{fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
									from RHJornadas
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								</cfquery>
								
								<cfquery name="rsIncidencias" datasource="#Session.DSN#">
									select 	CIid, 
											{fn concat(rtrim(CIcodigo),{fn concat(' - ',CIdescripcion)})} as Descripcion
									from CIncidentes
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								</cfquery>
								
								<form action="ExcepcionesJornada.cfm" method="post" name="fFiltro">
									<table width="100%" class="areaFiltro">
									<tr valign="top">
										
										<td align="center" nowrap class="fileLabel"><strong><cf_translate key="LB_Jornada">Jornada</cf_translate>:</strong></td>
										<td nowrap>
											<select name="RHJid_f">
												<option value=""></option>
											<cfloop query="rsJornadas">
												<option <cfif isdefined("form.RHJid_f")and form.RHJid_f eq RHJid> selected </cfif>  value="<cfoutput>#RHJid#</cfoutput>"><cfoutput>#Descripcion#</cfoutput></option>
											</cfloop>
											</select>
										</td>
										<td>
											<cfoutput><input name="btnFitrar" type="submit" value="#BTN_Fitrar#"></cfoutput>
										</td>
									</tr>
									<tr>
										<td align="center" nowrap class="fileLabel"><strong><cf_translate key="LB_Incidente">Incidente</cf_translate>:</strong></td>
										<td nowrap colspan="2">
											<select name="CIid_f">
												<option value=""></option>
											<cfloop query="rsIncidencias">
												<option <cfif isdefined("form.CIid_f")and len(trim(form.CIid_f))NEQ 0 and form.CIid_f eq CIid>selected</cfif>  value="<cfoutput>#CIid#</cfoutput>"><cfoutput>#Descripcion#</cfoutput></option>
											</cfloop>
											</select>
										</td>
										
									 </tr>
									</table>
								</form>
						</td>
					</tr>
					<tr>
						<!--- Lista --->
						<td valign="top">
							<cfquery name="rsLista" datasource="#session.DSN#">
								select a.RHEJid,a.RHJid,a.CIid,
										b.CIdescripcion,
										c.RHJdescripcion,
										<!---Para hora de entrada---->
										case 	when datepart(hh, a.RHEJhorainicio) > 12 then 
													{fn concat(convert(varchar,(datepart(hh, a.RHEJhorainicio) - 12)),
														{fn concat(':',{fn concat(case len(convert(varchar,datepart(mi, a.RHEJhorainicio)))	when 1 then
																						'0' ||convert(varchar,datepart(mi, a.RHEJhorainicio))
																					else
																						convert(varchar,datepart(mi, a.RHEJhorainicio))	
																					end, 
																		{fn concat(' ',case when datepart(hh, a.RHEJhorainicio) < 12 then 'AM' else 'PM' 	end	)})}
														)}
													)}													
												when datepart(hh, a.RHEJhorainicio) = 0 then 
													{fn concat('12',{fn concat(':',
																	{fn concat(case len(convert(varchar,datepart(mi, a.RHEJhorainicio)))	when 1 then
																					'0' ||convert(varchar,datepart(mi, a.RHEJhorainicio))
																				else
																					convert(varchar,datepart(mi, a.RHEJhorainicio))	
																				end,{fn concat(' ',case when datepart(hh, a.RHEJhorainicio) < 12 then 'AM' else 'PM' end)}
																		)}
																	)}
													)}																										
												else 
													{fn concat(convert(varchar, datepart(hh, a.RHEJhorainicio)),
														{fn concat(':',
															{fn concat(case len(convert(varchar,datepart(mi, a.RHEJhorainicio)))	when 1 then
																			'0' ||convert(varchar,datepart(mi, a.RHEJhorainicio))
																		else
																			convert(varchar,datepart(mi, a.RHEJhorainicio))	
																		end,{fn concat(' ',case when datepart(hh, a.RHEJhorainicio) < 12 then 'AM' else 'PM' 	end	)}
															)}
														)}
													)}													
										end as HoraInicio,
										<!---Para la hora de finalizacion---->
										case 	when datepart(hh, a.RHEJhorafinal) > 12 then 
													{fn concat(convert(varchar,(datepart(hh, a.RHEJhorafinal) - 12)),
																{fn concat(':',
																	{fn concat(case len(convert(varchar,datepart(mi, a.RHEJhorafinal)))	when 1 then
																					'0' ||convert(varchar,datepart(mi, a.RHEJhorafinal))
																				else
																					convert(varchar,datepart(mi, a.RHEJhorafinal))	
																				end,
																				{fn concat(' ',case when datepart(hh, a.RHEJhorafinal) < 12 then 'AM' else 'PM' end)}			
																	)}
																)}
													)}													
												when datepart(hh, a.RHEJhorafinal) = 0 then 
													{fn concat('12',
														{fn concat(':',
															{fn concat(case len(convert(varchar,datepart(mi, a.RHEJhorafinal)))	when 1 then
																			'0' ||convert(varchar,datepart(mi, a.RHEJhorafinal))
																		else
																			convert(varchar,datepart(mi, a.RHEJhorafinal))	
																		end,{fn concat(' ',case when datepart(hh, a.RHEJhorafinal) < 12 then 'AM' else 'PM' end)}
															)}
														)}
													)}																									
												else 
													{fn concat(convert(varchar, datepart(hh, a.RHEJhorafinal)),
														{fn concat(':',
															{fn concat(case len(convert(varchar,datepart(mi, a.RHEJhorafinal)))	when 1 then
																			'0' ||convert(varchar,datepart(mi, a.RHEJhorafinal))
																		else
																			convert(varchar,datepart(mi, a.RHEJhorafinal))	
																		end,
																		{fn concat(' ',case when datepart(hh, a.RHEJhorafinal) < 12 then 'AM' else 'PM' end)}
															)}
														)}
													)}													
										end as HoraFin																				
										<cfif isdefined("form.CIid_f")and len(trim(form.CIid_f))NEQ 0>
											,CIid_f = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid_f#">
										</cfif>
										
										<cfif isdefined("form.RHJid_f")and len(trim(form.RHJid_f))NEQ 0>
											,RHJid_f = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid_f#">
										</cfif>	
										,
										case RHEJlunes when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJlunes,
										case RHEJmartes when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJmartes,
										case RHEJmiercoles when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJmiercoles,
										case RHEJjueves when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJjueves,
										case RHEJviernes when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJviernes,
										case RHEJsabado when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJsabado,
										case RHEJdomingo when 1 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>' else '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>' end as RHEJdomingo																		
								
								from RHExcepcionesJornada a
										
									inner join CIncidentes	b
									on b.CIid = a.CIid
										
									inner join RHJornadas	c
									on c.RHJid = a.RHJid
									and c.Ecodigo = b.Ecodigo
								where
									c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									<!--- filtro por Incidencias--->
									<cfif isdefined("form.CIid_f")and len(trim(form.CIid_f))NEQ 0>
									and  a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid_f#">
									</cfif>
									<!--- filtro por Jornadas--->
									<cfif isdefined("form.RHJid_f")and len(trim(form.RHJid_f))NEQ 0>
									and  a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid_f#">
									</cfif>	
							</cfquery>
							<cfinvoke
								Component= "rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="RHJdescripcion,CIdescripcion,HoraInicio,HoraFin,RHEJlunes,RHEJmartes,RHEJmiercoles,RHEJjueves,RHEJviernes,RHEJsabado,RHEJdomingo"/>
									<cfinvokeargument name="etiquetas" value="#LB_Jornada#,#LB_Incidencia#, #LB_Hora_Inicial#, #LB_Hora_Final#, #LB_L_Lunes#,#LB_K_Martes#,#LB_M_Miercoles#,#LB_J_Jueves#,#LB_V_Viernes#,#LB_S_Sabado#,#LB_D_Domingo#"/>
									<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,V,V,V,V"/>
									<cfinvokeargument name="align" value="left,left,center,center,center,center,center,center,center,center,center"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="ExcepcionesJornada.cfm"/>
									<cfinvokeargument name="keys" value="RHEJid"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>	
									<cfinvokeargument name="maxrows" value="10"/> 	
									<cfinvokeargument name="showEmptyListMsg" value="true"/> 	
							</cfinvoke>
						</td>
					</tr>
					</table>
					
				</td>
				<!--- Form ---> 
				<td width="50%" valign="top"> <cfinclude template="ExcepcionesJornada-form.cfm">
				</td>
			</tr>
			</table>
			<!---  --->
		
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>