<!---	Creado: Rebeca Corrales Alfaro --->
<!---	Fecha:  12/08/2005 			   --->
<!---	Modificado por: 			   --->
<!--- 	Fecha: 		 				   --->

<cfquery name="verifica_Parametro" datasource="#session.dsn#">
	select 1 from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 480
	and Pvalor = '1'
</cfquery>

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isdefined("Url.fDEnombre") and not isdefined("Form.fDEnombre")>
	<cfset Form.fDEnombre = Url.fDEnombre>
</cfif>
<cfif isdefined("Url.fDEidentificacion") and not isdefined("Form.fDEidentificacion")>
	<cfset Form.fDEidentificacion = Url.fDEidentificacion>
</cfif>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Control de Marcas-Autorizaci&oacute;n Pago de Horas
	</cf_templatearea>
	<cf_templatecss>
	<cf_templatearea name="body">
		<!----=================== TRADUCCION =======================---->
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Autorizaci&oacute;n Pago de Horas"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Identificacion"
			Default="Identificaci&oacute;n"	
			returnvariable="LB_Identificacion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Nombre"
			Default="Nombre"	
			returnvariable="LB_Nombre"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Generar"
			Default="Generar"
			returnvariable="BTN_Generar"/>			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Esta_seguro_de_que_desea_Generar_para_los_empleados_seleccionados"
			Default="¿Está seguro de que desea Generar para los empleados seleccionados ?"	
			returnvariable="MSG_GenerarEmpleados"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Debe_seleccionar_al_menos_un_empleado_antes_de_Generar"
			Default="Debe seleccionar al menos un empleado antes de Generar"	
			returnvariable="MSG_SeleccionarEmpleados"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_proceso_de_Generacion_de_Pago_de_Horas_se_realizo_satisfactoriamente"
			Default="El proceso de Generación de Pago de Horas se realizó satisfactoriamente"	
			returnvariable="MSG_GeneracionPagoSatisfactoria"/>	
		
		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
			<cfoutput>
				<table border="0" width="100%" cellspacing="0" cellpadding="0">
					<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					<cfif verifica_parametro.recordcount GT 0>
						<tr>
							<td valign="top">
								<form name="filtroListaEmp" method="post" action="AutPagoHora.cfm" style="margin: 0; ">
									<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
									  <input type="hidden" name="RHPMid" value="<cfoutput>#Form.RHPMid#</cfoutput>">
									</cfif>
									<cfif isdefined("Form.RHCMid") and Len(Trim(Form.RHCMid))>
									  <input type="hidden" name="RHCMid" value="<cfoutput>#Form.RHCMid#</cfoutput>">
									</cfif>
									  <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
										<tr> 
										  <td width="23%" nowrap class="fileLabel">#LB_Identificacion#</td>
										  <td width="66%" nowrap class="fileLabel"><cf_translate key="LB_Nombre_del_Empleado">Nombre del empleado</cf_translate></td>
										  <td width="2%" nowrap class="fileLabel">&nbsp;</td>
										  <td width="9%" rowspan="2" align="center" nowrap>
											<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
										  </td>
										</tr>
										<tr> 
										  <td nowrap>
											<input name="fDEidentificacion" type="text" id="fDEidentificacion" size="30" maxlength="60" value="<cfif isdefined('form.fDEidentificacion')><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>">
										  </td>
										  <td nowrap>
											<input name="fDEnombre" type="text" id="fDEnombre" size="60" maxlength="260" value="<cfif isdefined('form.fDEnombre')><cfoutput>#form.fDEnombre#</cfoutput></cfif>">
										  </td>
										</tr>
									  </table>
								</form>
								<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
				 					<tr>
										<td align="center">
											<!--- Variables para Navegación --->
											<cfif isdefined("url.fDEnombre") and len(trim(url.fDEnombre))>
												<cfset form.fDEnombre = url.fDEnombre>
											</cfif>
											
											<cfif isdefined("url.fDEidentificacion") and len(trim(url.fDEidentificacion))>
												<cfset form.fDEidentificacion = url.fDEidentificacion>
											</cfif>
															
											<cfset navegacion = "">
											<cfquery name="rsListaMarcasEmp" datasource="#Session.DSN#">
												select distinct a.DEid, a.DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(a.DEapellido1, ' ') },a.DEapellido2)}, ' ')},a.DEnombre) } as nombreEmpl 
												from RHProcesamientoMarcas b
													inner join DatosEmpleado a
														on a.Ecodigo = b.Ecodigo
														<cfif isdefined("Form.fDEnombre") and Len(Trim(Form.fDEnombre)) NEQ 0>
															and upper({fn concat({fn concat({fn concat({ fn concat(a.DEapellido1, ' ') },a.DEapellido2)}, ' ')},a.DEnombre) }) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.fDEnombre)#%">
															<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "fDEnombre="&form.fDEnombre>								
														</cfif>
														<cfif isdefined("Form.fDEidentificacion") and Len(Trim(Form.fDEidentificacion)) NEQ 0>
															and upper(a.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.fDEidentificacion)#%">
															<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "fDEidentificacion="&form.fDEidentificacion>		
														</cfif>
													inner join RHControlMarcas rm
														on rm.DEid = a.DEid
														
													inner join RHUsuariosMarcas um
														on b.Ecodigo = um.Ecodigo
														and b.CFid = um.CFid
														and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
														and (um.RHUMtmarcas = 1 or um.RHUMgincidencias = 1)
														
													inner join IncidenciasMarcas im
														on rm.RHCMid = im.RHCMid
														and rm.RHPMid = im.RHPMid	
														
													inner join RHDetalleIncidencias di
														on di.RHDMid = im.RHDMid
														and di.RHPMid = im.RHPMid
														and di.RHCMid = im.RHCMid													
														
												where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
												group by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre
											</cfquery>
											<cfinvoke 
											 component="rh.Componentes.pListas"
											 method="pListaQuery"
											 returnvariable="pListaEmpl">
												<cfinvokeargument name="query" value="#rsListaMarcasEmp#"/>
												<cfinvokeargument name="desplegar" value="DEidentificacion,nombreEmpl"/>
												<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#"/>
												<cfinvokeargument name="formatos" value="V,V"/>
												<cfinvokeargument name="formname" value="listaEmpleados"/>
												<cfinvokeargument name="align" value="left,left"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="checkboxes" value="S"/>
												<cfinvokeargument name="irA" value="AutPagoHora-form.cfm"/>
												<cfinvokeargument name="keys" value="DEid"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>												
												<cfinvokeargument name="botones" value="Generar"/>
											</cfinvoke>
										</td>
									</tr>
				 					<tr>
										<td align="center">&nbsp;
										</td>
									</tr>										
								</table>
							</td>
						</tr>
					<cfelse>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<strong><cf_translate key="LB_NoTienAutorizacionParaAccederEstaInformacion">No tiene Autorizaci&oacute;n para acceder esta informaci&oacute;n</cf_translate></strong>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</cfif>
				</table>
			</cfoutput>
				
			<script language="JavaScript">
			// Aplicar
				function algunoMarcado(){
					<cfoutput>
					var aplica = false;
					if (document.listaEmpleados.chk) {
						if (document.listaEmpleados.chk.value) {
							aplica = document.listaEmpleados.chk.checked;
						} else {
							for (var i=0; i<document.listaEmpleados.chk.length; i++) {
								if (document.listaEmpleados.chk[i].checked) { 
									aplica = true;
									break;
								}
							}
						}
					}
					if (aplica) {			
						return (confirm("#MSG_GenerarEmpleados#"));
					} else {
						alert('#MSG_SeleccionarEmpleados#');
						return false;
					}
					</cfoutput>
				}			
				function funcGenerar() {
					if (algunoMarcado())
						document.listaEmpleados.action = "AutPagoHoraGenerar.cfm";
					else
						return false;
				}						
				
				function Despl_Mensaje(){
					<cfoutput>
					alert('#MSG_GeneracionPagoSatisfactoria#');
					</cfoutput>
					return false;
				}
				
				<cfif isdefined("form.inc_generada")>
					Despl_Mensaje();
				</cfif>
				
			</script>
			
			
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

