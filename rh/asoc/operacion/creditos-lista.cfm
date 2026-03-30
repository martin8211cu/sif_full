<!--- VARIABLES DE TRADUCCION --->
<cfinvoke vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" default="Cr&eacute;ditos por Asociado" vsgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate"/>
<cfinvoke key="LB_Semanal" default="Semanal"	 returnvariable="LB_Semanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Bisemanal" default="Bisemanal"	 returnvariable="LB_Bisemanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Quincenal" default="Quincenal"	returnvariable="LB_Quincenal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mensual" default="Mensual"	 returnvariable="LB_Mensual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Todos" default="Todos"	 returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Filtrar" default="Filtrar"	 returnvariable="LB_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Asociado" default="Asociado"	 returnvariable="LB_Asociado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo_Credito" default="Tipo de Cr&eacute;dito"	 returnvariable="LB_Tipo_Credito" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo_Nomina" default="Tipo N&oacute;mina"	 returnvariable="LB_Tipo_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Periodicidad" default="Periocidad"	 returnvariable="LB_Periodicidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Monto" default="Monto"	 returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Amortizado" default="Amortizado"	 returnvariable="LB_Amortizado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Planilla" default="Planilla"	 returnvariable="LB_Planilla" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Nuevo" default="Nuevo"	 returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!--- FIN VARIABLE DE TRADUCCION --->
<cfif isdefined("url.f_identificacion") and not isdefined("form.f_identificacion") >
	<cfset form.f_identificacion = url.f_identificacion >
</cfif>
<cfif isdefined("url.f_asociado") and not isdefined("form.f_asociado") >
	<cfset form.f_asociado = url.f_asociado >
</cfif>
<cfif isdefined("url.f_periodicidad") and not isdefined("form.f_periodicidad") >
	<cfset form.f_periodicidad = url.f_periodicidad >
</cfif>

<cf_templateheader title="Recursos Humanos">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				    
					<cf_web_portlet_start titulo="#nombre_proceso#">
					  <cfinclude template="/rh/portlets/pNavegacion.cfm">

						<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
						  <tr><td>&nbsp;</td></tr>
						  <!--- filtro --->
							<cfset navegacion = '' >
							<cfset filtro = '' >
							<cfset extra = '' >
							<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
								<cfset filtro = " and upper(de.DEidentificacion) like '%#ucase(form.f_identificacion)#%' " >
								<cfset extra = ", '#form.f_identificacion#' as f_identificacion" >
							</cfif>
							<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
								<cfset filtro = filtro & " and ( upper(de.DEnombre) like '%#ucase(form.f_asociado)#%' or upper(de.DEapellido1) like '%#ucase(form.f_asociado)#%' or upper(de.DEapellido2) like '%#ucase(form.f_asociado)#%' ) " >
								<cfset extra = extra & ", '#form.f_asociado#' as f_asociado" >								
							</cfif>
							<cfif isdefined("form.f_periodicidad") and len(trim(form.f_periodicidad)) >
								<cfset filtro = filtro & "and ( exists (  select 1 from TiposNomina tn where tn.Ecodigo=a.Ecodigo and tn.Tcodigo=a.Tcodigo  and tn.Ttipopago = #form.f_periodicidad#) or ACCAperiodicidad = #form.f_periodicidad# )" >
								<cfset extra = extra & ", '#form.f_periodicidad#' as f_periodicidad" >																
							</cfif>
						  
						  <cfoutput>
						  <tr>
							<td>
								<form name="filtro" method="post" action="creditos-lista.cfm"  >
								<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
									<tr>
										<td><strong>#LB_Identificacion#</strong></td>
										<td><strong>#LB_Asociado#</strong></td>
										<td colspan="2"><strong>#LB_Periodicidad#</strong></td>
									</tr>
									<tr>
										<td><input type="text" size="30" maxlength="30" name="f_identificacion" value="<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >#form.f_identificacion#</cfif>" ></td>
										<td><input type="text" size="60" maxlength="60" name="f_asociado" value="<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >#form.f_asociado#</cfif>" ></td>
										<td>
											<select name="f_periodicidad">
												<option value="" >#LB_Todos#</option>
												<option value="0" <cfif isdefined("form.f_periodicidad") and form.f_periodicidad eq 0 >selected</cfif> >#LB_Semanal#</option>
												<option value="1" <cfif isdefined("form.f_periodicidad") and form.f_periodicidad eq 1 >selected</cfif> >#LB_Bisemanal#</option>
												<option value="2" <cfif isdefined("form.f_periodicidad") and form.f_periodicidad eq 2 >selected</cfif> >#LB_Quincenal#</option>
												<option value="3" <cfif isdefined("form.f_periodicidad") and form.f_periodicidad eq 3 >selected</cfif> >#LB_Mensual#</option>
											</select>
										</td>
										<td><input type="submit" name="Filtrar" class="btnFiltrar" value="#LB_Filtrar#">
											<input type="submit" name="btnNuevo" class="btnNuevo" value="#BTN_Nuevo#">
										</td>
									</tr>
									<tr></tr>
								</table>
								</form>
							</td>
						  </tr>
						  </cfoutput>
						  
						  
						  
						  
						  <tr>
							<td>
								<cfset botones = "Nuevo,Importar">
								<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',DEnombre" returnvariable="asociado" >
								<cf_dbfunction name="concat" args="Tcodigo,'-',Tdescripcion" returnvariable="tiponomina" >
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="ACCreditosAsociado a, ACCreditosTipo ct, ACAsociados b, DatosEmpleado de"/>
									<cfinvokeargument name="columnas" value="	a.ACCAid,
																				a.ACAid,
																				de.DEidentificacion,
																				#asociado# as asociado,
																				ct.ACCTcodigo,
																				ct.ACCTdescripcion, 
																				(select #tiponomina# from TiposNomina tn where tn.Ecodigo=a.Ecodigo and tn.Tcodigo=a.Tcodigo) as Tdescripcion,
																				(case ( case when a.Tcodigo is null then ACCAperiodicidad else (select Ttipopago from TiposNomina tn where tn.Ecodigo=a.Ecodigo and tn.Tcodigo=a.Tcodigo) end ) 
																				when 0 then '#LB_Semanal#'
																				when 1 then '#LB_Bisemanal#'
																				when 2 then '#LB_Quincenal#'
																				else '#LB_Mensual#' end) as periodicidad,
																				a.ACCTcapital, 
																				a.ACCTamortizado #preservesinglequotes(extra)#"/>
									<cfinvokeargument name="desplegar" value="DEidentificacion,asociado,periodicidad,ACCTcapital,ACCTamortizado"/>
									<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Asociado#,#LB_Periodicidad#,#LB_Monto#, #LB_Amortizado#"/>
									<cfinvokeargument name="formatos" value="S,S,S,M,M"/>
									<cfinvokeargument name="filtro" value=" a.Ecodigo=#session.Ecodigo#
																			and ct.ACCTid=a.ACCTid
																			and b.ACAid=a.ACAid
																			and (a.ACCTcapital - a.ACCTamortizado) > 0
																			and a.ACCestado = 0
																			and de.DEid=b.DEid #preservesinglequotes(filtro)# "/>
									<cfinvokeargument name="align" value="left, left, left, right, right"/>
									<cfinvokeargument name="ajustar" value="S"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="keys" value="ACCAid"/>
									<cfinvokeargument name="botones" value="#botones#"/>
									<cfinvokeargument name="irA" value="creditos.cfm"/>
									<cfinvokeargument name="formName" value="lista"/>
									<cfinvokeargument name="debug" value="N"/>
								</cfinvoke>
							</td>
						  </tr>
						</table>

				    <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>