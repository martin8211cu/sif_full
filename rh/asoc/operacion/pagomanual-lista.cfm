<cfif isdefined("url.f_identificacion") and not isdefined("form.f_identificacion") >
	<cfset form.f_identificacion = url.f_identificacion >
</cfif>
<cfif isdefined("url.f_asociado") and not isdefined("form.f_asociado") >
	<cfset form.f_asociado = url.f_asociado >
</cfif>
<cfif isdefined("url.pageNum_lista0") and not isdefined("form.pageNum_lista0") >
	<cfset form.pageNum_lista0 = url.pageNum_lista0 >
</cfif>

<!---=============== TRADUCCION =================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	xmlfile="/rh/generales.xml"	
	returnvariable="LB_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Identificacion"/>
<!---
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Inicio"
	Default="Fecha Inicio"	
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Fecha_Inicio"/>
--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Asociado"
	Default="Asociado"
	xmlfile="/rh/asoc/general.xml"		
	returnvariable="LB_Asociado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Listado_de_asociados"
	Default="Listado de asociados con cr&eacute;ditos pendientes"
	xmlfile="/rh/asoc/general.xml"		
	returnvariable="LB_Listado"/>

<!---
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_Credito"
	xmlfile="/rh/asoc/general.xml"			
	Default="Tipo de Cr&eacute;dito"	
	returnvariable="LB_Tipo_Credito"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Monto"
	Default="Monto"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Amortizado"
	Default="Amortizado"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Amortizado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Saldo"
	Default="Saldo"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Saldo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Monto_Pago"
	Default="Monto pago"	
	xmlfile="/rh/asoc/general.xml"				
	returnvariable="LB_Monto_Pago"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Todos"/>
--->	
<cf_templateheader title="Recursos Humanos">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				    
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Registro manual de Pagos"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					<cf_web_portlet_start titulo="#nombre_proceso#">
					  <cfinclude template="/rh/portlets/pNavegacion.cfm">

<!---
						<script language="JavaScript" type="text/javascript">
							//Eliminar Relaciones de Cálculo
							function funcEliminar() {
								var form = document.listaRelaciones;
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
								if (result) {
									<cfoutput>
									if (!confirm('#LB_ElimarRegistrosSeleccionados#'))
										result = false;
									</cfoutput>
								}
								else
									<cfoutput>alert('#LB_SeleccionarRegistros#');</cfoutput>
								return result;
							}
							//validación al intentar crear un nuevo registro
							function funcNuevo() {
							<cfif rsCalendarios.recordCount EQ 0>
								<cfoutput>alert('#LB_NoCalendariosDefinidos#')</cfoutput>;
								return false;
							<cfelse>
								return true;
							</cfif>
							}
						</script>
--->
						<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
						  <tr><td>&nbsp;</td></tr>
						  <!--- filtro --->
							<cfset navegacion = '' >
							<cfset filtro_empl = '' >
							<!---<cfset filtro_credito = '' >--->
							<cfset extra = '' >
							<cfif isdefined("form.pageNum_lista0") and len(trim(form.pageNum_lista0)) >
								<cfset extra = ", '#form.pageNum_lista0#' as pageNum_lista0" >
							</cfif>
							
							<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
								<cfset filtro_empl = " and upper(e.DEidentificacion) like '%#ucase(form.f_identificacion)#%' " >
								<cfset extra = ", '#form.f_identificacion#' as f_identificacion" >
								<cfset navegacion = navegacion & '&f_identificacion=#form.f_identificacion#' >
							</cfif>
							<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
								<cfset filtro_empl = filtro_empl & " and ( upper(e.DEnombre) like '%#ucase(form.f_asociado)#%' or upper(e.DEapellido1) like '%#ucase(form.f_asociado)#%' or upper(e.DEapellido2) like '%#ucase(form.f_asociado)#%' ) " >
								<cfset extra = extra & ", '#form.f_asociado#' as f_asociado" >
								<cfset navegacion = navegacion & '&f_asociado=#form.f_asociado#' >								
							</cfif>
							<!---
							<cfif isdefined("form.f_tipocredito") and len(trim(form.f_tipocredito)) >
								<cfset filtro_credito = "and d.ACCTid = '#form.f_tipocredito#'" >
								<cfset extra = extra & ", '#form.f_tipocredito#' as f_tipocredito" >																
							</cfif>
							--->
						  <cfoutput>
						  <tr>
							<td>
								<form name="filtro" method="post" action="pagomanual-lista.cfm"  >
								<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
									<tr>
										<td><strong>#LB_Identificacion#</strong></td>
										<td><strong>#LB_Asociado#</strong></td>
										<!---<td colspan="2"><strong>#LB_tipo_credito#</strong></td>--->
									</tr>
									<tr>
										<td><input type="text" size="30" maxlength="30" name="f_identificacion" value="<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >#form.f_identificacion#</cfif>" ></td>
										<td><input type="text" size="60" maxlength="60" name="f_asociado" value="<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >#form.f_asociado#</cfif>" ></td>
										<!---
										<td>
											<cfquery name="rsTipoCredito" datasource="#session.DSN#"	>
												select ACCTid, ACCTcodigo, ACCTdescripcion
												from ACCreditosTipo
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												order by ACCTcodigo
											</cfquery>
											<select name="f_tipocredito">
												<option value="" >#LB_Todos#</option>
												<cfloop query="rsTipoCredito">
													<option value="#rsTipoCredito.ACCTid#" <cfif isdefined("form.f_tipocredito") and form.f_tipocredito eq rsTipoCredito.ACCTid >selected</cfif> >#trim(rsTipoCredito.ACCTcodigo)# - #rsTipoCredito.ACCTdescripcion#</option>
												</cfloop>
											</select>

										</td>
										--->
										<td><input type="submit" name="Filtrar" class="btnFiltrar" value="#LB_Filtrar#">
											<!---<input type="submit" name="btnNuevo" class="btnNuevo" value="#BTN_Nuevo#">--->
										</td>
									</tr>
									<tr></tr>
								</table>
								</form>
							</td>
						  </tr>
						  </cfoutput>
						  
							<tr><td class="tituloListas"><strong><cfoutput>#LB_Listado#</cfoutput></strong></td></tr>
						  <tr>
							<td>
								<cfset botones = "Nuevo">
								<cf_dbfunction name="concat" args="e.DEapellido1,' ',e.DEapellido2,' ',e.DEnombre" returnvariable="asociado" >

								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value=" 	ACAsociados c
																			
																			inner join DatosEmpleado e
																			on e.DEid=c.DEid
																			and e.Ecodigo=#session.Ecodigo#
																			#filtro_empl#"/>
									<cfinvokeargument name="columnas" value="  c.ACAid,
																			   e.DEidentificacion, 
																			   #asociado# as asociado
																			   #extra#"/>
									<cfinvokeargument name="desplegar" value="DEidentificacion,asociado"/>
									<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Asociado#"/>
									<cfinvokeargument name="formatos" value="S,S"/>
									<cfinvokeargument name="filtro" value="exists( select 1
																				   from ACCreditosAsociado
																				   where ACAid=c.ACAid
																				   and ACCTcapital > ACCTamortizado )
																		   order by e.DEidentificacion, e.DEapellido1, e.DEapellido2, e.DEnombre"/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="S"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="keys" value="ACAid"/>
									<cfinvokeargument name="irA" value="pagomanual.cfm"/>
									<cfinvokeargument name="formName" value="lista"/>
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="PageIndex" value="0" />
									<cfinvokeargument name="navegacion" value="#navegacion#" />
								</cfinvoke>
							</td>
						  </tr>
						</table>

				    <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>