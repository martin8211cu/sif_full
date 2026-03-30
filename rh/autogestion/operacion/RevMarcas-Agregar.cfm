<!-----
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">---->

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Agregar de Marcas de Reloj"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Empleado"
			Default="Empleado"	
			returnvariable="LB_Empleado"/>						
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ListaDeEmpleados"
			Default="Lista de Empleados"	
			returnvariable="LB_ListaDeEmpleados"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_NoSeEncontraronRegistros"
			Default="No se encontraron registros"	
			returnvariable="LB_NoSeEncontraronRegistros"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Identificacion"
			Default="Identificación"	
			returnvariable="LB_Identificacion"/>		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Marca"
			Default="Marca"	
			returnvariable="LB_Marca"/>			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha"
			Default="Fecha"	
			returnvariable="LB_Fecha"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Agregar"
			Default="Agregar"	
			returnvariable="BTN_Agregar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Limpiar"
			Default="Limpiar"	
			returnvariable="BTN_Limpiar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			Default="Regresar"	
			returnvariable="BTN_Regresar"/>			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Ninguno"
			Default="Ninguno"	
			returnvariable="LB_Ninguno"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaYHoraDeLaMarca"
			Default="Fecha y hora de la marca"	
			returnvariable="LB_FechaYHoraDeLaMarca"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaYHoraDelReloj"
			Default="Fecha y hora del reloj"	
			returnvariable="LB_FechaYHoraDelReloj"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_RegistradoManualmente"
			Default="Registrado manualmente"	
			returnvariable="LB_RegistradoManualmente"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Modificar"
			Default="Modificar"	
			returnvariable="BTN_Modificar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Eliminar"
			Default="Eliminar"	
			returnvariable="BTN_Eliminar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ConfirmaEliminar"
			Default="Esta seguro que desea eliminar la marca?"	
			returnvariable="MSG_ConfirmaEliminar"/>
				
		<cfquery name="rsAcciones" datasource="#session.DSN#">
			select RHASid,RHAScodigo, RHASdescripcion
			from RHAccionesSeguir
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfset modo = 'ALTA'>
		<cfif not isdefined("form.btnAgregar") and isdefined("form.RHCMid") and len(trim(form.RHCMid))>
			<cfset modo = 'CAMBIO'>
		</cfif>
		<cfif modo NEQ 'ALTA'>
			<!--- DAG 14/05/2007: SE ESTANDARIZA PARA DBMSS: ORACLE, MSSQLSERVER, SYBASE --->
			<!--- Date Part de fecha hora reloj --->
			<cf_dbfunction name="date_part" args="hh, a.fechahorareloj" returnvariable="Lvar_fechahorareloj_hh">
			<cf_dbfunction name="date_part" args="mi, a.fechahorareloj" returnvariable="Lvar_fechahorareloj_mi">
			<!--- To char del Date Part de fecha hora reloj --->
			<cf_dbfunction name="to_char" args="#Lvar_fechahorareloj_hh#" returnvariable="Lvar_to_char_fechahorareloj_hh">
			<cf_dbfunction name="to_char" args="#Lvar_fechahorareloj_hh#-12" returnvariable="Lvar_to_char_fechahorareloj_hh_m12">
			<cf_dbfunction name="to_char" args="#Lvar_fechahorareloj_mi#" returnvariable="Lvar_to_char_fechahorareloj_mi">
			<!--- Date Part de fecha hora marca --->
			<cf_dbfunction name="date_part" args="hh, a.fechahoramarca" returnvariable="Lvar_fechahoramarca_hh">
			<cf_dbfunction name="date_part" args="mi, a.fechahoramarca" returnvariable="Lvar_fechahoramarca_mi">
			<!--- To char del Date Part de fecha hora marca --->
			<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#" returnvariable="Lvar_to_char_fechahoramarca_hh">
			<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#-12" returnvariable="Lvar_to_char_fechahoramarca_hh_m12">
			<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_mi#" returnvariable="Lvar_to_char_fechahoramarca_mi">
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select 	a.DEid,
						a.tipomarca, 
						a.fechahorareloj,
						a.RHCMid,
						<!--- case when a.fechahorareloj is null then 
							'#LB_RegistradoManualmente#'
						else
							case 	when (#PreserveSingleQuotes(Lvar_fechahorareloj_hh)#) > 12 then 
									{fn concat((#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_hh_m12)#),
										{fn concat(':',{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#))	when 1 then
																		{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#))}
																	else
																		(#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#)	
																	end, 
														{fn concat(' ',case when (#PreserveSingleQuotes(Lvar_fechahorareloj_hh)#) < 12 then 'AM' else 'PM' 	end	)})}
										)}
									)}													
								when (#PreserveSingleQuotes(Lvar_fechahorareloj_hh)#) = 0 then 
									{fn concat('12',{fn concat(':',
													{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#))	when 1 then
																	{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#))}
																else
																	(#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#)	
																end,{fn concat(' ',case when (#PreserveSingleQuotes(Lvar_fechahorareloj_hh)#) < 12 then 'AM' else 'PM' end)}
														)}
													)}
									)}																										
								else 
									{fn concat((#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_hh)#),
										{fn concat(':',
											{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#))	when 1 then
															{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#))}
														else
															(#PreserveSingleQuotes(Lvar_to_char_fechahorareloj_mi)#)	
														end,{fn concat(' ',case when (#PreserveSingleQuotes(Lvar_fechahorareloj_hh)#) < 12 then 'AM' else 'PM' 	end	)}
											)}
										)}
									)}													
								end 
							end as horaReloj,  --->
							a.fechahoramarca,
							case when (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) > 12 then 
									(#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) - 12 
								when (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) = 0 then 
									12 
								else 
									(#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) 
							end as horas,
						(#PreserveSingleQuotes(Lvar_fechahoramarca_mi)#) as minutos,
						case when (#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#) < 12 then 'AM' else 'PM' end as segundos,
						a.RHASid,
						a.registroaut,
						a.justificacion
				from RHControlMarcas a
				where a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">						
			</cfquery>
			<!---Datos de empleado---->
			<cfquery name="rsEmpleado" datasource="#Session.DSN#">
				select 	a.DEid, 
						a.DEidentificacion, 
						a.DEnombre, 
						a.DEapellido1, 
						a.DEapellido2,
						n.NTIdescripcion									
				from DatosEmpleado a, NTipoIdentificacion n
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
					and a.NTIcodigo = n.NTIcodigo									
			</cfquery>
		</cfif>
		<cfif isdefined("url.PageNum") and len(trim(url.PageNum))>
			<cfset form.pagina = url.PageNum>
		</cfif>	
		<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<cfset form.pagina = url.Pagina>
		</cfif>	
		<cfparam name="form.pagina" default="1">
		<!----
		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">---->
			<cfoutput>
				<form name="form1" action="RevMarcas-Agregar-sql.cfm" method="post">					
					<input type="hidden" name="RHCMid" value="<cfif modo NEQ 'ALTA'>#rsDatos.RHCMid#</cfif>">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<cfif modo EQ 'ALTA'>
							<tr>
								<td width="25%" align="right"><strong>#LB_Empleado#:&nbsp;</strong> </td>
								<td colspan="2">
									<cf_conlis
									   campos="DEid,DEidentificacion,Nombre"
									   desplegables="N,S,S"
									   modificables="N,S,N"
									   size="0,20,40"
									   title="#LB_ListaDeEmpleados#"
									   tabla=" RHCMAutorizadoresGrupo a
												inner join RHCMEmpleadosGrupo b
													on a.Gid = b.Gid
													and a.Ecodigo = b.Ecodigo
													
													inner join DatosEmpleado c
														on b.DEid = c.DEid
														and b.Ecodigo = c.Ecodigo"
									   columnas="b.DEid, c.DEidentificacion , {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as Nombre"
									   filtro="a.Ecodigo = #session.Ecodigo#
												and a.Usucodigo = #session.Usucodigo#"
									   desplegar="DEidentificacion,Nombre"
									   filtrar_por="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}"
									   filtrar_por_delimiters="|"
									   etiquetas="#LB_Identificacion#,#LB_Empleado#"
									   formatos="S,S"
									   align="left,left"
									   asignar="DEid,DEidentificacion,Nombre"
									   asignarformatos="S,S,S"
									   showemptylistmsg="true"
									   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
									   tabindex="1"> 
								</td>
							</tr>
						<cfelse>
							<input type="hidden" name="DEid" value="#rsDatos.DEid#">
							<tr>
								<td colspan="3" align="center">
									<cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm">
								</td>
							</tr>
						</cfif>
						<tr>
							<td width="25%" align="right"><strong><cf_translate key="LB_TipoMarca">Tipo de marca</cf_translate>:&nbsp;</strong> </td>
							<td colspan="2">
								<select name="AtipoMarca" tabindex="2">
								  <option value="E" <cfif modo NEQ 'ALTA' and trim(rsDatos.tipomarca) EQ 'E'>selected</cfif>><cf_translate key="LB_Entrada">Entrada</cf_translate></option>
								  <option value="S" <cfif modo NEQ 'ALTA' and trim(rsDatos.tipomarca) EQ 'S'>selected</cfif>><cf_translate key="LB_Salida">Salida</cf_translate></option>
								  <option value="SB" <cfif modo NEQ 'ALTA' and trim(rsDatos.tipomarca) EQ 'SB'>selected</cfif>><cf_translate key="LB_SalidaBreak">Salida Break</cf_translate></option>
								  <option value="EB" <cfif modo NEQ 'ALTA' and trim(rsDatos.tipomarca) EQ 'EB'>selected</cfif>><cf_translate key="LB_EntradaBreak">Entrada Break</cf_translate></option>
								</select>
							</td>
						</tr>
						<cfif modo NEQ 'ALTA'>
							<tr>
								<td align="right"><strong><cf_translate key="LB_FechaYHoraReloj">Fecha y hora del reloj</cf_translate>:&nbsp;</strong></td>
								<td colspan="2">
									<cfif len(trim(rsDatos.fechahorareloj))>
										#LSDateFormat(rsDatos.fechahorareloj,'dd/mm/yyyy')#
									</cfif>									
									<!--- #rsDatos.horaReloj#  --->#TimeFormat(rsDatos.fechahorareloj, "hh:mm:ss tt")#

								</td>
							</tr>
						</cfif>
						<tr>
							<td width="25%" align="right"><strong>
								#LB_FechaYHoraDeLaMarca#:&nbsp;
							</strong></td>
							<td width="9%">
								<cfif modo NEQ 'ALTA'>
									<cf_sifcalendario  tabindex="3" form="form1" name="fechahoramarca" value="#LSDateFormat(rsDatos.fechahoramarca,'dd/mm/yyyy')#"> 
								<cfelse>
									<cf_sifcalendario  tabindex="3" form="form1" name="fechahoramarca"> 
								</cfif>								
							</td>
							<td width="66%">
								<select id="horamarca_h" name="horamarca_h" tabindex="4">
								  <cfloop index="i" from="1" to="12">
									<option value="<cfoutput>#i#</cfoutput>"<cfif modo NEQ 'ALTA' and rsDatos.horas EQ i>selected</cfif>>
										<cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput>
									</option>
								  </cfloop>
								</select>:
								<select id="horamarca_m" name="horamarca_m" tabindex="5">
								  <cfloop index="i" from="0" to="59">
									<option value="<cfoutput>#i#</cfoutput>"<cfif modo NEQ 'ALTA' and rsDatos.minutos EQ i>selected</cfif>>
										<cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput>
									</option>
								  </cfloop>
								</select>
								<select id="horamarca_s"  name="horamarca_s" tabindex="6">
								  <option value="AM" <cfif modo NEQ 'ALTA' and rsDatos.segundos EQ 'AM'>selected</cfif>>AM</option>
								  <option value="PM" <cfif modo NEQ 'ALTA' and rsDatos.segundos EQ 'PM'>selected</cfif>>PM</option>
								</select>
							</td>
						</tr>
						<tr>
							<td width="25%" align="right" valign="top">
								<strong><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:&nbsp;</strong> 
							</td>
							<td colspan="2" valign="top"><textarea cols="90" rows="8" name="justificacion" tabindex="7"><cfif modo NEQ 'ALTA'>#rsDatos.justificacion#</cfif></textarea></td>
						</tr>
						<tr>
							<td width="25%" align="right" valign="top">
								<strong><cf_translate key="LB_AccionASeguir">Acci&oacute;n a seguir</cf_translate>:&nbsp;</strong> 
							</td>
							<td colspan="2">
								<select name="RHASid" tabindex="8">
								  <option value="">--- #LB_Ninguno# ---</option>
								  <cfloop query="rsAcciones">
									<option value="#rsAcciones.RHASid#" <cfif modo NEQ 'ALTA' and rsDatos.RHASid EQ rsAcciones.RHASid>selected</cfif>>#rsAcciones.RHAScodigo# - #rsAcciones.RHASdescripcion#</option>
								  </cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td width="25%" align="right" valign="top">
								<strong><cf_translate key="LB_MarcaAutorizada">Marca Autorizada</cf_translate>:&nbsp;</strong> 
							</td>
							<td>
								<input type="checkbox" name="registroaut" value="" tabindex="9" <cfif modo NEQ 'ALTA' and rsDatos.registroaut EQ 0><cfelse>checked</cfif>>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="3" align="center">
								<table width="33%" cellpadding="0" cellspacing="0">
									<tr>
										<cfif modo NEQ 'ALTA'>
											<td><input type="submit" name="btnModificar" value="#BTN_Modificar#"></td>
											<td><input type="submit" name="btnEliminar" value="#BTN_Eliminar#" onClick="javascript: if ( confirm('#MSG_ConfirmaEliminar#') ){funcDeshabilitar();}else{return false;}"></td>										
										<cfelse>
											<td><input type="submit" name="btnAgregar" value="#BTN_Agregar#"></td>
											<td><input type="reset" name="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript: document.form1.DEid.value = '';"></td>										
										</cfif>
										<td><input type="submit" name="btnRegresar" value="#BTN_Regresar#" onClick="javascript: funcDeshabilitar(); document.form1.action = 'RevMarcas-tabs.cfm?tab=1'; document.form1.submit();"></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					  </table>
					  	<!----Campos de los filtros recibidos de la pantalla anterior----->
						<input type="hidden" name="btnFiltrar" value="btnFiltrar">	
						<input type="hidden" name="chk" value="<cfif isdefined("form.chk") and len(trim(form.chk))>#form.chk#</cfif>">	
						<input type="hidden" name="FDEid" value="<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>#form.FDEid#</cfif>">		
						<input type="hidden" name="FDEIdentificacion" value="<cfif isdefined("form.FDEIdentificacion") and len(trim(form.FDEIdentificacion))>#form.FDEIdentificacion#</cfif>">
						<input type="hidden" name="FNombre" value="<cfif isdefined("form.FNombre") and len(trim(form.FNombre))>#form.FNombre#</cfif>">
						<input type="hidden" name="Grupo" value="<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>#form.Grupo#</cfif>">
						<input type="hidden" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#</cfif>">
						<input type="hidden" name="Inicio_h" value="<cfif isdefined("form.Inicio_h") and len(trim(form.Inicio_h))>#form.Inicio_h#</cfif>">	
						<input type="hidden" name="Inicio_m" value="<cfif isdefined("form.Inicio_m") and len(trim(form.Inicio_m))>#form.Inicio_m#</cfif>">	
						<input type="hidden" name="Inicio_s" value="<cfif isdefined("form.Inicio_s") and len(trim(form.Inicio_s))>#form.Inicio_s#</cfif>">	
						<input type="hidden" name="Fin_h" value="<cfif isdefined("form.Fin_h") and len(trim(form.Fin_h))>#form.Fin_h#</cfif>">	
						<input type="hidden" name="Fin_m" value="<cfif isdefined("form.Fin_m") and len(trim(form.Fin_m))>#form.Fin_m#</cfif>">	
						<input type="hidden" name="Fin_s" value="<cfif isdefined("form.Fin_s") and len(trim(form.Fin_s))>#form.Fin_s#</cfif>">
						<input type="hidden" name="FTipoMarca" value="<cfif isdefined("form.FTipoMarca") and len(trim(form.FTipoMarca))>#form.FTipoMarca#</cfif>">						
						<input type="hidden" name="fechaInicio" value="<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>#form.fechaInicio#</cfif>">
						<input type="hidden" name="fechaFinal" value="<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>#form.fechaFinal#</cfif>">
						<input type="hidden" name="ordenarpor" value="<cfif isdefined("form.ordenarpor") and len(trim(form.ordenarpor))>#form.ordenarpor#</cfif>">
						<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and len(trim(form.Estado))>#form.Estado#</cfif>">	
						<input type="hidden" name="pagina" value="#form.pagina#">
			  	</form>
			</cfoutput>						
		<cf_web_portlet_end>
		<cf_qforms form="form1">
		<script type="text/javascript" language="javascript1.2">
			objForm.fechahoramarca.description="<cfoutput>#LB_FechaYHoraDeLaMarca#</cfoutput>";
			objForm.fechahoramarca.required = true;	
			objForm.DEid.description="<cfoutput>#LB_Empleado#</cfoutput>";
			objForm.DEid.required = true;	

			function funcDeshabilitar(){
				objForm.DEid.required = false;	
				objForm.fechahoramarca.required = false;
			}
		</script>
<!----
</cf_templatearea>
</cf_template>---->