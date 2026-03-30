<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="nombreproceso"
		Default="Autoevaluación Nuevo Sistema Desempeño"
		returnvariable="nombreproceso"/> 

	<cf_web_portlet_start titulo="#nombreproceso#" border="true" skin="#Session.Preferences.Skin#">	
	<cf_templatecss>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Guardar"
		Default="Guardar"
		returnvariable="BTN_Guardar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Aplicar"
		Default="Aplicar"
		returnvariable="BTN_Aplicar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EstaRelacionDeEvaluacionNoTieneConceptosAsociados"
		Default="Esta relaci&oacute;n de evaluaci&oacute;n no tiene conceptos asociados"
		returnvariable="MSG_NoConceptos"/>
	<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
		<cfset form.DEid = url.DEid>
	</cfif>
	<cfif isdefined("url.REid") and len(trim(url.REid)) and not isdefined("form.REid")>
		<cfset form.REid = url.REid>
	</cfif>
			
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<!---Datos de empleado---->
			<cfquery name="rsEmpleado" datasource="#Session.DSN#">
				select 	a.DEid, 
						case when a.Usucodigo is null then
							(select d.Usucodigo  
							from UsuarioReferencia d
							where d.STabla = 'DatosEmpleado'
								and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								and <cf_dbfunction name="to_number" args="llave"> = a.DEid)
						else 
							a.Usucodigo
						end as Usucodigo,
						a.DEidentificacion, 
						a.DEnombre, 
						a.DEapellido1, 
						a.DEapellido2,
						n.NTIdescripcion,
						d.RHPid,
						{fn concat(d.RHPcodigo,{fn concat(' - ',d.RHPdescripcion)})} as Puesto, 
						{fn concat(f.CFcodigo,{fn concat(' - ',f.CFdescripcion)})} as CFuncional							
				from DatosEmpleado a
					inner join NTipoIdentificacion n
						on a.NTIcodigo = n.NTIcodigo	

					inner join LineaTiempo c
						on a.DEid = c.DEid
 						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between c.LTdesde and c.LThasta
						and c.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = c.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
					
						inner join RHPlazas d
							on c.RHPid = d.RHPid

							inner join RHPuestos e
								on d.RHPpuesto = e.RHPcodigo

							inner join CFuncional f
								on d.CFid = f.CFid

				where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>
			
			<cfif rsEmpleado.RecordCount NEQ 0>
				<!--- BUSCA LOS CONCEPTOS A EVALUAR PARA EL EMPLEADO EN LA RELACION --->
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select 	e.IAEid,
							e.IAEtipoconc,
							e.IAEdescripcion,
							e.IAEpregunta,
							c.CDEid,	
							d.TEcodigo,
							c.CDERespuestae,
							a.REindicaciones
					from RHRegistroEvaluacion a
						inner join RHRegistroEvaluadoresE b
							on a.REid = b.REid 
							and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					
						inner join RHConceptosDelEvaluador c
							on b.REEid =c.REEid
					
							inner join RHIndicadoresRegistroE d
								on c.IREid = d.IREid

							inner join RHIndicadoresAEvaluar e
								on d.IAEid = e.IAEid
							
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
						and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
						and a.REaplicaempleado = 1
					order by e.IAEtipoconc desc, d.IREevaluajefe, d.IREevaluasubjefe				
				</cfquery>
				<cfoutput>			
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td>
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
					</td></tr>
					<tr>
						<td>
							<table width="100%" cellpadding="3" cellspacing="0">
								<tr> 
									<td class="#Session.preferences.Skin#_thcenter" colspan="2"><cf_translate key="LB_Datos_Generales">DATOS GENERALES</cf_translate></td>
								</tr>
								<tr> 
									<td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
									<cfinclude template="../../../expediente/consultas/frame-foto.cfm">
								</td>
								<td valign="top" nowrap> 
									<table width="100%" border="0" cellpadding="5" cellspacing="0">
										<tr> 
											<td class="fileLabel" width="10%" nowrap><strong><cf_translate key="LB_Nombre_Completo">Nombre Completo</cf_translate>:</strong></td>
											<td>#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</td>
										</tr>
										<tr> 
											<td class="fileLabel" nowrap><strong>#rsEmpleado.NTIdescripcion#:</strong></td>
											<td>#rsEmpleado.DEidentificacion#</td>
										</tr>	
										<tr> 
											<td class="fileLabel" nowrap><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:</strong></td>
											<td>#rsEmpleado.Puesto#</td>
										</tr>	
										<tr> 
											<td class="fileLabel" nowrap><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong></td>
											<td>#rsEmpleado.CFuncional#</td>
										</tr>		
									</table>
								</td>
								</tr>					
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>					
					<cfif rsDatos.RecordCount NEQ 0 and len(trim(rsDatos.REindicaciones)) and rsDatos.REindicaciones NEQ ''>
						<tr><td align="center">
							<iframe frameborder="0" id="indicaciones" style="overflow:auto; margin:0; border:1px solid gray;"  height="150" width="900" src="indicaciones.cfm?REid=#form.REid#&DEid=#form.DEid#"></iframe>
							<!--- estas lineas de script son necesarias para internet explorer.--->
							<script>
								document.getElementById("indicaciones").src = 'indicaciones.cfm?REid=#form.REid#&DEid=#form.DEid#';
							</script>
						</td></tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>					
					<tr><td>&nbsp;</td></tr>
					<form name="form1" method="post" action="autoevaluacion_empleado-sql.cfm">
						<input type="hidden" name="REid" value="<cfif isdefined("form.REid") and len(trim(form.REid))>#form.REid#</cfif>">
						<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">						
						<tr>
							<td>
								<table width="100%" cellpadding="2" cellspacing="1" border="0">							
									<cfset vs_respuesta = ''>
									<cfset vs_Tipo = ''>
									<cfset vn_TEcodigo = ''>									
									<cfloop query="rsDatos">																			
										<cfset vs_respuesta = rsDatos.CDERespuestae>	
										<cfset vs_Tipo = rsDatos.IAEtipoconc>		
										<cfset vn_TEcodigo = rsDatos.TEcodigo>						
										<tr>
											<input type="hidden" name="CDEid" value="#rsDatos.CDEid#">											
											<cfif vs_Tipo EQ 'A'>
												<td width="40%" align="right" valign="top">#rsDatos.IAEpregunta#:&nbsp;</td>
												<td width="55%"><textarea name="CDERespuestae#rsDatos.CDEid#" cols="50" rows="5"><cfif len(trim(vs_respuesta))>#vs_respuesta#</cfif></textarea></td>
											<cfelse>
												<cfif len(trim(vn_TEcodigo))>													
													<cfset rsValor.TEVvalor = ''><!---Limpia la variable de rs---->
													<!---Valores de la tabla para llenar el combo---->
													<cfquery name="rsValores" datasource="#session.DSN#">
														select TEcodigo, TEVvalor, TEVnombre, TEVvalor, TEVequivalente 
														from TablaEvaluacionValor
														where TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vn_TEcodigo#">
													</cfquery>
													<cfif len(trim(vs_respuesta))>
														<cfquery name="rsValor" datasource="#session.DSN#">
															select TEVvalor, TEVnombre 
															from TablaEvaluacionValor
															where TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vn_TEcodigo#">
																and TEVvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(vs_respuesta)#">
														</cfquery>		
													</cfif>
													<td width="50%" align="right" valign="top">
														<cfif len(trim(rsDatos.IAEpregunta))>
															#rsDatos.IAEpregunta#:&nbsp;
														<cfelse>
															#rsDatos.IAEdescripcion#:&nbsp;
														</cfif>
													</td>
													<td width="45%">														
														<select name="Valor#rsDatos.CDEid#">
															<option value="">---- <cf_translate key="LB_Seleccionar">Seleccionar</cf_translate> ----</option>
															<cfloop query="rsValores">														
																<option value="#rsValores.TEVvalor#" <cfif isdefined("rsValor") and (trim(rsValores.TEVvalor) EQ trim(rsValor.TEVvalor))>selected</cfif>>#rsValores.TEVnombre#</option>														
															</cfloop>
														</select>
													</td>
												</cfif>
											</cfif>										
										</tr>
									</cfloop>
									<tr><td>&nbsp;</td></tr>
									<cfif rsDatos.RecordCount NEQ 0>
										<tr>
											<td colspan="2" align="center">
												<input type="submit" name="btnGuardar" value="#BTN_Guardar#">
												<input type="submit" name="btnAplicar" value="#BTN_Aplicar#">
											</td>
										</tr>
									<cfelse>
										<tr>
											<td colspan="2" align="center"><strong>------#MSG_NoConceptos#------</strong></td>
										</tr>
									</cfif>
									<tr><td>&nbsp;</td></tr>
								</table>						
							</td>
						</tr>
					</form>
				</table>
				</cfoutput>
			</cfif>
		</cfif>
  	<cf_web_portlet_end>
<cf_templatefooter>
