<!--- VARIABLES DE TRADUCCION --->
<cfif not isdefined("Form.visualizar") and not isdefined("url.visualizar")>
	<cfset Form.visualizar = 0><!--- 0 diario  1 semanal --->
</cfif>
<cfif isdefined("url.visualizar") and len(trim(url.visualizar)) and not isdefined("form.visualizar")>
	<cfset Form.visualizar = url.visualizar>
</cfif>

 
<cfinvoke vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" default="Procesamiento de Marcas" vsgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>						
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Todos" default="Todos"	 returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar"	 returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Procesar_Masivo" default="Aplicar Masivo"	 returnvariable="BTN_Procesar_Masivo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_LaCantidadRegistrosVisualizarNoMayorA50" default="La cantidad de registros a visualizar no puede ser mayor a 50	"	 returnvariable="MSG_CantidadMayor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Marca" default="Marca"	 returnvariable="LB_Marca" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_FDesde" default="F.Desde"	 returnvariable="LB_FDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FHasta" default="F.Hasta"	 returnvariable="LB_FHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jornada" default="Jornada"	 returnvariable="LB_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CJornada" default="Conbinaci&oacute;n<br> de Jornadas"	 returnvariable="LB_CJornada" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_HorasTrabajadas" default="H.T"	 returnvariable="LB_HT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HorasOcio" default="H.O"	 returnvariable="LB_HO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HorasLaboradas" default="H.L"	 returnvariable="LB_HL" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HorasARebajar" default="H.R"	 returnvariable="LB_HR" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HorasNormales" default="H.N"	 returnvariable="LB_HN" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HorasExtraA" default="H.EA"	 returnvariable="LB_HEA" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HorasExtraB" default="H.EB"	 returnvariable="LB_HEB" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MontoFeriado" default="M.Feriado"	 returnvariable="LB_MFeriado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Permiso" default="Permiso"	 returnvariable="LB_Permiso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Feriado" default="Feriado" returnvariable="LB_Feriado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Aplicar" default="Aplicar"	 returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Eliminar" default="Eliminar"	 returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConfirmaAplicar" default="Esta seguro que desea aplicar las marcas?"	 returnvariable="MSG_ConfirmaAplicar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_ConfirmaEliminar" default="Esta seguro que desea eliminar las marcas?"	 returnvariable="MSG_ConfirmaEliminar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="BTN_GeneraMarcasPorPermisos" default="Generar Marcas por Permisos"	 returnvariable="BTN_GeneraMarcasPorPermisos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_DeseaGenerarMarcasPorPermisos" default="Desea generar Marcas por Permisos?" returnvariable="BTN_DeseaGenerarMarcasPorPermisos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MarcaInconsistente" default="Marca Inconsistente" returnvariable="LB_MarcaInconsistente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MarcasInconsistentes" default="Marcas Inconsistentes" returnvariable="LB_MarcasInconsistentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes" default="Las marcas que aparecen en color rojo est&aacute;n inconsistentes" returnvariable="LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_HayMarcasInconsistentesNoSePuedeAplicar" default="Hay marcas inconsistentes no se puede aplicar."	 returnvariable="MSG_HayMarcasInconsistentesNoSePuedeAplicar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" default="Debe seleccionar al menos un registro para relizar esta acción" returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas" default="Las marcas que aparecen en color verde est&aacute;n Duplicadas" returnvariable="LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="Recursos Humanos">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<cfquery name="rsGrupos" datasource="#session.DSN#">
			select  b.Gid, b.Gdescripcion
			from RHCMGrupos b					
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="rsJornadas" datasource="#session.DSN#">
			select RHJid,RHJcodigo, RHJdescripcion
			from RHJornadas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfset navegacion = ''>
		<cfset arrayEmpleado = ArrayNew(1)>
		<cfset vnMaxrows = 50>
		<cfparam name="form.Pagina" default="1">
		<cfif isdefined("url.btnFiltrar")>
			<cfset form.btnFiltrar = url.btnFiltrar>
		</cfif>
		<cfif isdefined("form.btnFiltrar")>
			<cfset navegacion = navegacion & '&btnFiltrar=true'>
		</cfif>

		<cfif isdefined("url.visualizar") and len(trim(url.visualizar)) and not isdefined("form.visualizar")>
			<cfset form.visualizar = url.visualizar>	
		</cfif>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "visualizar=" & Form.visualizar>			

		<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid>	
		</cfif>
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "DEid=" & Form.DEid>			
		</cfif>
		<cfif isdefined("url.RHJid") and len(trim(url.RHJid)) and not isdefined("form.RHJid")>
			<cfset form.RHJid = url.RHJid>	
		</cfif>
		<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "RHJid=" & Form.RHJid>			
		</cfif>
		<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
			<cfset form.Grupo = url.Grupo>				
		</cfif>
		<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Grupo=" & Form.Grupo>
		</cfif>
		<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
			<cfset form.ver = url.ver>	
		</cfif>
		<cfif isdefined("form.ver") and len(trim(form.ver))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "ver=" & Form.ver>
			<cfset vnMaxrows = form.ver>
		</cfif>				
		<cfif isdefined("url.fechaInicio") and len(trim(url.fechaInicio)) and not isdefined("form.fechaInicio")>
			<cfset form.fechaInicio = url.fechaInicio>	
		</cfif>

		
		<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaInicio=" & Form.fechaInicio>
			<cfset fechaInicio = form.fechaInicio>
		</cfif>			
		<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
			<cfset form.fechaFinal = url.fechaFinal>	
		</cfif>
		<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaFinal=" & Form.fechaFinal>
			<cfset fechaFinal = form.fechaFinal>			
		</cfif>			
		<!---Limpiar variable QueryString_lista por problemas de navegacion---->
		<cfif ISDEFINED("CGI.QUERY_STRING")>
			<cfset QueryString_lista='&'&CGI.QUERY_STRING>
			<cfelse>
			<cfset QueryString_lista="">
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"btnFiltrar=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"Grupo=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"RHJid=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"DEid=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"ver=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"fechaInicio=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>
		<cfset tempPos=ListContainsNoCase(QueryString_lista,"fechaFinal=","&")>
		<cfif tempPos NEQ 0>
			<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
		</cfif>

		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>



				<form name="form1" action="ProcesaMarcas-Lista-sql.cfm" method="post" >
					<input  type="hidden" name="tab" value="1">
                    <input type="hidden" name="BOTON" value="">
					<table width="100%" cellpadding="3" cellspacing="0">
						<tr>
							<td>								
								<table width="100%" cellpadding="2" cellspacing="0" border="0">
									<tr>
										<td width="14%" align="right">&nbsp;</td>
										<td colspan="5">
											<input onclick="javascript: cambiomodo(this);" type="radio" id="visualizar" name="visualizar" value="0" <cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0 >checked</cfif> >
											<cf_translate key="LB_Diario">Diario</cf_translate>
											<input onclick="javascript: cambiomodo(this);" type="radio" id="visualizar" name="visualizar" value="1" <cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 1 >checked</cfif> >
											<cf_translate key="LB_Semanal">Semanal</cf_translate>
										</td>
									</tr>
									<tr>
										<td width="14%" align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
										<td colspan="3">
											<cfif isdefined("form.DEid") and len(trim(form.DEid))>
												<cfquery name="rsEmpleado" datasource="#session.DSN#">
													select 	DEid, 
															{fn concat({fn concat({fn concat({ fn concat(DEnombre, ' ') },DEapellido1)}, ' ')},DEapellido2) } NombreEmp,
															DEidentificacion,					
															NTIcodigo
													from DatosEmpleado
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
												</cfquery>
												<cf_rhempleado form="form1" size="60" query="#rsEmpleado#" tabindex="1">
											<cfelse>
												<cf_rhempleado form="form1" size="60"tabindex="1">												
											</cfif>
										</td>
										<td  nowrap="nowrap" width="6%" align="right"><strong><cf_translate key="LB_Ver">Ver</cf_translate>:&nbsp;</strong></td>										
										<td width="13%">
											<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
												<input tabindex="4" type="text" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#<cfelse>50</cfif>" size="7" >
											<cfelse>
												20
											</cfif>	
										</td>										
									</tr>
									<tr>
										<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaInicial">Fecha inicial</cf_translate>:&nbsp;</strong></td>
										<td width="12%">
											<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
												<cf_sifcalendario  tabindex="1" form="form1" name="fechaInicio" value="#form.fechaInicio#">
											<cfelse>
												<cf_sifcalendario  tabindex="1" form="form1" name="fechaInicio">
											</cfif>
										</td>
										<td width="13%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
										<td width="42%">	
											<select name="Grupo" tabindex="1">
												<option value="">--- #LB_Todos# ---</option>
												<cfloop query="rsGrupos">
													<option value="#rsGrupos.Gid#" <cfif isdefined("form.Grupo") and len(trim(form.Grupo)) and form.Grupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
												</cfloop>
											</select>
										</td>	
										<td colspan="2" align="center" rowspan="2">
											<input tabindex="5" type="submit" name="btnFiltrar" value="#BTN_Filtrar#" onclick="javascript: funcDeshabilitar(); document.form1.action = ''; ">
											<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
												<input tabindex="5" type="submit" name="btnProcesar_Masivo" value="#BTN_Procesar_Masivo#" onclick="javascript: return confirm('#MSG_ConfirmaAplicar#');">
											</cfif>	
										</td>
									</tr>
									<tr>
										<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaFinal">Fecha final</cf_translate>:&nbsp;</strong></td>										
										<td nowrap>
											<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
												<cf_sifcalendario  tabindex="1" form="form1" name="fechaFinal" value="#fechaFinal#">
											<cfelse>
												<cf_sifcalendario  tabindex="1" form="form1" name="fechaFinal">
											</cfif>
										</td>	
										<td align="right" width="13%">
											<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
												<strong>#LB_Jornada#:</strong>
											<cfelse>
												&nbsp;	
											</cfif>
										</td>
										<td >											
											<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
												<select name="RHJid" tabindex="1">
													<option value="">--- #LB_Todos# ---</option>
													<cfloop query="rsJornadas">
														<option value="#rsJornadas.RHJid#" <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) and form.RHJid EQ rsJornadas.RHJid>selected</cfif>>#rsJornadas.RHJcodigo# - #rsJornadas.RHJdescripcion#</option>
													</cfloop>
												</select>
											<cfelse>
												&nbsp;	
											</cfif>
										</td>
									</tr>
								</table>
								<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
									<table width="100%" cellpadding="2" cellspacing="0" border="0">
										<tr>
											<td>
												<strong>
													<a href="##" onclick="javascript:DespliegaG();">
														[<cf_translate key="LB_Generar_Feriados_Y_Permisos">Generar Feriados y Permisos</cf_translate>]
													</a>
												</strong>
											</td>
										</tr>								
									</table>
								</cfif>
								<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
									<table width="100%" cellpadding="2" cellspacing="0" border="0">
										<tr><td align="right" style="color: ##FF0000 ">#LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes#&nbsp;</td></tr>							
										<tr><td align="right" style="color: ##00CC00 ">#LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas#&nbsp;</td></tr>	
									</table>
								</cfif>
                                
							<table width="80%" align="center" cellpadding="2" cellspacing="0" border="0">
								<tr>
									<td>
										<fieldset id="tbFr" style="display:none">
										<legend> <cf_translate key="LB_Paraametros_para_Generar_Feriados">Par&aacute;metros para Generar Feriados</cf_translate> </legend>
										<table width="100%" cellpadding="2" cellspacing="0" border="0">
											<tr>
												<td nowrap><strong><cf_translate key="LB_Feriado">Feriado</cf_translate>&nbsp;:&nbsp;</strong></td>
												<td>
													<!--- Obtiene la información de los Feriados --->
													<cfquery name="rsFeriados" datasource="#Session.dsn#">
                                                          select a.RHFid, a.RHFdescripcion, a.RHFfecha
                                                          from RHFeriados a
                                                          where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                                                and a.RHFpagooblig = 1
                                                                and <cf_dbfunction name="dateaddx" args="mm,2,a.RHFfecha"> >= (
                                                                      select cp.CPdesde
                                                                      from CalendarioPagos cp 
                                                                      where cp.Ecodigo = a.Ecodigo
                                                                      and cp.CPid = 
                                                                      coalesce((
                                                                            select max(cp2.CPid) 
                                                                            from CalendarioPagos cp2 
                                                                            where cp2.Ecodigo = cp.Ecodigo
                                                                            and cp2.CPfenvio is not null
                                                                      ),(
                                                                            select min(cp2.CPid) 
                                                                            from CalendarioPagos cp2 
                                                                            where cp2.Ecodigo = cp.Ecodigo
                                                                      ))
                                                                )
                                                          order by 3
                                                   </cfquery>
													<select name="RHFid">
														<cfloop query="rsFeriados">
															<option value="#rsFeriados.RHFid#">#rsFeriados.RHFdescripcion# (#rsFeriados.RHFfecha#)</option>
														</cfloop>
													</select>
												</td>
												<td>
													<cf_botones values="Generar">
												</td>
											</tr>								
										</table>
										</fieldset>
									</td>
									<td>
										<fieldset id="tbPr" style="display:none">
										<legend>
											<cf_translate key="LB_Paraametros_para_Generar_Permisos">Par&aacute;metros para Generar Permisos</cf_translate> </legend>
											<table width="5%" cellpadding="2" cellspacing="0" border="0" align="center">
												<tr>
													<td align="center"><cf_botones values="GenerarPermisos"></td>
												</tr>								
											</table>
										</fieldset>
									</td>

								</tr>
								</table>
								
							</td>
						</tr>
						<!----LISTA---->
						<cfif isdefined("form.btnFiltrar")>
							<tr>
								<td>
									<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
										<input type="checkbox" name="chkTodos" value="" onclick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
										<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
									<cfelse>
										&nbsp;	
									</cfif>	
								</td>
							</tr>
							<tr>
								<td align="center">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr><td>
											<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
												<cfquery name="rsLista" datasource="#session.DSN#">
													select {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
															a.CAMfdesde, a.CAMfhasta, a.CAMid,a.CAMpermiso,
															case when a.RHJid is not null then 
																c.RHJdescripcion
															else
																'#LB_Feriado#'
															end as Jornada,
															coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0) as HT,
															coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0) as HO,
															coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0) as HL,
															coalesce(a.CAMcanthorasreb,0) as HR,
															coalesce(a.CAMcanthorasjornada,0) as HN,
															coalesce(a.CAMcanthorasextA,0) as HEA,
															coalesce(a.CAMcanthorasextB,0) as HEB,
															coalesce(a.CAMmontoferiado,0) as MFeriado,
															case a.CAMpermiso
															when 1 then '<img src=/cfmx/rh/imagenes/checked.gif>'
															else '<img src=/cfmx/rh/imagenes/unchecked.gif>' end as permiso,
															case when (	select count(1) 
																	from RHCMCalculoAcumMarcas x 
																	where x.DEid = a.DEid
																	  and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde">
																	  and x.CAMid <> a.CAMid
																	  and x.CAMpermiso <> a.CAMpermiso
																	  and x.CAMgeneradoporferiado = 0
																	  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
															else 0 end as inconsistencia,
															case when (	select count(1) 
															from RHCMCalculoAcumMarcas x 
															inner join RHControlMarcas z
																on x.DEid = z.DEid
																and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="z.fechahoramarca">
															where x.DEid = a.DEid
															  and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde">
															  and x.CAMid <> a.CAMid
															  and x.CAMpermiso = a.CAMpermiso
															  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
															else 0 end marcaIgual,
															case when (	select count(1) 
																	from RHCMCalculoAcumMarcas x 
																	where x.DEid = a.DEid
																	  <!--- and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> --->
																	  and x.CAMfdesde = a.CAMfdesde
																	  and x.CAMid <> a.CAMid
																	  and x.CAMpermiso <> a.CAMpermiso
																	  and x.CAMgeneradoporferiado = 0
																	  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado
																	  ) > 0 then (select count(1) 
																	from RHCMCalculoAcumMarcas x 
																	where x.DEid = a.DEid
																	  and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde">
																	  and x.CAMid <> a.CAMid
																	  and x.CAMpermiso <> a.CAMpermiso
																	  and x.CAMgeneradoporferiado = 0
																	  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado
																	  )
															else 0 end as inconsistencia2
													from RHCMCalculoAcumMarcas a
														inner join DatosEmpleado b
															on a.DEid = b.DEid
															and a.Ecodigo = b.Ecodigo
														left outer join RHJornadas c
															on a.RHJid = c.RHJid
															and a.Ecodigo = c.Ecodigo
														<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
															inner join RHCMEmpleadosGrupo d
																on a.DEid = d.DEid
																and a.Ecodigo = d.Ecodigo															
																and d.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
														</cfif>
														
													where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														and a.CAMestado = 'P'
														<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
															and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
														</cfif>
														<cfif isdefined("form.DEid") and len(trim(form.DEid))>
															and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
														</cfif>
														<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) 
																and isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
															<cfif form.fechaInicio GT form.fechaFinal>
																and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
															<cfelseif form.fechaFinal GT form.fechaInicio>
																and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#">
															<cfelse>
																and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
															</cfif>
														<cfelseif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) and (not isdefined("form.fechaFinal") or  len(trim(form.fechaFinal)) EQ 0)>
															and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
														<cfelseif isdefined("form.fechaFinal") and len(trim(form.fechaFinal)) and (not isdefined("form.fechaInicio") or  len(trim(form.fechaInicio)) EQ 0)>
															and <cf_dbfunction name="to_datechar" args="a.CAMfhasta"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#">
														</cfif>	
													order by {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)}, a.CAMfdesde, a.CAMfhasta
												</cfquery>
												<cfif isdefined("url.PageNum_lista") and len(trim(Url.PageNum_lista)) gt 0>
													<cfset form.Pagina = url.PageNum_lista>
												</cfif>
												<cfparam name="form.Pagina" default="1">
												<cfinvoke 
													 component="rh.Componentes.pListas"
													 method="pListaQuery"
													  returnvariable="pListaEmpl">
														<cfinvokeargument name="query" value="#rsLista#"/>
														<cfinvokeargument name="desplegar" value="Empleado,CAMfdesde,CAMfhasta,Jornada,HT,HO,HL,HR,HN,HEA,HEB,MFeriado,permiso"/>
														<cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_FDesde#,#LB_FHasta#,#LB_Jornada#,#LB_HT#,#LB_HO#,#LB_HL#,#LB_HR#,#LB_HN#,#LB_HEA#,#LB_HEB#,#LB_MFeriado#,#LB_Permiso#"/>
														<cfinvokeargument name="formatos" value="V,D,D,V,M,M,M,M,M,M,M,M,S"/>
														<cfinvokeargument name="align" value="left,left,left,left,center,center,center,center,center,center,center,left,center"/>
														<cfinvokeargument name="ajustar" value="N"/>
														<cfinvokeargument name="checkboxes" value="S"/>
														<cfinvokeargument name="irA" value="ProcesaMarcas-Cambio.cfm?Pagina=#form.Pagina#?band=1"/>
														<cfinvokeargument name="keys" value="CAMid"/>
														<cfinvokeargument name="maxRows" value="#vnMaxrows#"/>
														<cfinvokeargument name="incluyeForm" value="false"/>
														<cfinvokeargument name="formName" value="form1"/>
														<cfinvokeargument name="navegacion" value="#navegacion#"/>
														<cfinvokeargument name="showEmptyListMsg" value="yes"/>
														<cfinvokeargument name="QueryString_lista" value="#QueryString_lista#"/>
														<cfinvokeargument name="funcion" value="funcNoSubmit"/>
														<cfinvokeargument name="fparams" value="CAMid,CAMpermiso"/>
														<cfinvokeargument name="lineaRoja" value="inconsistencia"/>
														<cfinvokeargument name="lineaVerde" value="marcaIgual"/>
												</cfinvoke>												
											<cfelse>
												<!--- En este cfm se encuentra el proceso para ver las marcas agrupadas semanalmente. --->
												<cfinclude template="ProcesaMarcas-ListaS.cfm">
											</cfif>
										</td></tr>										
									</table>
								</td>
							</tr>
							<cfif isdefined("rsLista") and rsLista.RecordCount NEQ 0 and isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td align="center">
											<table width="34%" cellpadding="0" cellspacing="0" align="center">
												<tr>
													<td>
														<input type="button"  name="btnAplicar" value="#BTN_Aplicar#" 
															onclick="javascript: funcAplicar();">
													</td>
													<td>
														<input type="button"  name="btnEliminar" value="#BTN_Eliminar#" 
															onclick="javascript: funcEliminar();">
													</td>
												</tr>
											</table>
									</td>
								</tr>	
								<tr><td>&nbsp;</td></tr>
							</cfif>						
						</cfif>
					</table>
				</form>
			</cfoutput>						
		<cf_web_portlet_end>

		<cf_qforms form="form1">
		<script type="text/javascript" language="javascript1.2">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function funcDeshabilitar(){
				<cfif isdefined("form.btnFiltrar") and isdefined("rsLista") and rsLista.RecordCount NEQ 0 and isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
					objForm.chk.required = false;			
				</cfif>
			}
			
			function cambiomodo(obj){
				document.form1.action="ProcesaMarcas-Lista.cfm";
				document.form1.submit();
			}


			function funcChequeaTodos(){		
				if (document.form1.chkTodos.checked){			
					if (document.form1.chk && document.form1.chk.type) {						
						if (!document.form1.chk.disabled){
							document.form1.chk.checked = true
						}
					}
					else{
						if (document.form1.chk){
							for (var i=0; i<document.form1.chk.length; i++) {
								if (!document.form1.chk[i].disabled){
									document.form1.chk[i].checked = true	
								}				
							}
						}
					}
				}	
				else{
					<cfset url.Todos = 0>
					if (document.form1.chk && document.form1.chk.type) {
						document.form1.chk.checked = false
					}
					else{
						if (document.form1.chk){
							for (var i=0; i<document.form1.chk.length; i++) {
								document.form1.chk[i].checked = false					
							}
						}
					}
				}
			}
			function funcMarcar(){
				var chequeados =0
				if (document.form1.chk && document.form1.chk.type) {
					if(document.form1.chk.checked){
						document.form1.chkTodos.checked = true
					}
					else{
						if (document.form1.chk){
							document.form1.chkTodos.checked = false
						}	
					}
				}
				else{					
					if (document.form1.chk){
						for (var i=0; i<document.form1.chk.length; i++) {
							if(document.form1.chk[i].checked){
								chequeados=chequeados+1
							}				
						}
					}
					if (document.form1.chk){
						if(document.form1.chk.length == chequeados){
							document.form1.chkTodos.checked = true
						}
						else{
							document.form1.chkTodos.checked = false
						}
					}
				}
			}
			function DespliegaG(){
				_tbFr=document.getElementById('tbFr');
				_tbPr=document.getElementById('tbPr');
				if (_tbFr.style.display==''){
					_tbFr.style.display='none'
				}else{
					_tbFr.style.display=''
				}
				document.form1.btnGenerar.disabled=(_tbFr.style.display!='');
				if (_tbPr.style.display==''){
					_tbPr.style.display='none'
				}else{
					_tbPr.style.display=''
				}
				document.form1.btnGenerarPermisos.disabled=(_tbPr.style.display!='');
			}
			function funcNoSubmit(CAMid,Permiso){
				if (Permiso == 1){
					return false;
				}else{
					location.href = "ProcesaMarcas-Cambio.cfm?Pagina=<cfoutput>#form.Pagina#</cfoutput>&CAMid="+CAMid+"<cfoutput>#navegacion#</cfoutput>" + "&sid="+Math.random();
				}
			}
			function hayIncosistencias(){
				var form = document.form1;
				var result = false;
				
				if (form.chk!=null) {
					if (form.chk.length){
						for (var i=0; i<form.chk.length; i++){
							var x=i+1;
							var dato = 'form.INCONSISTENCIA_'+ x +'.value';
							if (Number(eval(dato))>0 && form.chk[i].checked)
								result = true;
						}
					}
					else{
						if (Number(eval('form.INCONSISTENCIA_1.value'))>0 && form.chk.checked)
							result = true;
					}
				}
				if (result) {
					result= true;
					alert('<cfoutput>#MSG_HayMarcasInconsistentesNoSePuedeAplicar#</cfoutput>');
				}else result = false;
				return result;
			}
			function funcAplicar(){
				if (hayMarcados()){
					 if (!hayIncosistencias()){
						if ( confirm('<cfoutput>#MSG_ConfirmaAplicar#</cfoutput>') ){
							document.form1.BOTON.value = 'Aplicar';
							document.form1.submit();
						}
					 }else{
						return false;
					 }
				 }
			}
			function hayMarcados(){
				var form = document.form1;
				var result = false;
				if (form.chk!=null) {
					if (form.chk.length){
						for (var i=0; i<form.chk.length; i++){
							if (form.chk[i].checked)
								result = true;
						}
					}
					else{
						if (form.chk.checked)
							result = true;
					}
				}
				if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
				return result;
			}
			function funcEliminar(){
				if (hayMarcados()){
					if ( confirm('<cfoutput>#MSG_ConfirmaEliminar#</cfoutput>') ){
						document.form1.BOTON.value = 'Eliminar';
						document.form1.submit();
					}
				 }
			}
		</script>	
<cf_templatefooter>
