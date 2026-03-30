<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
returnvariable="BTN_Filtrar"/>
																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Limpiar"
Default="Limpiar"
returnvariable="BTN_Limpiar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TiposEstadisticas"
Default="Tipos de Estad&iacute;sticas"
returnvariable="LB_TiposEstadisticas"/>

<cf_templateheader title="#LB_TiposEstadisticas#">

					<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.descripcion.value   = "";
																}
								</script>	

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
							<td valign="top">
						<cf_web_portlet_start titulo="#LB_TiposEstadisticas#">
						<cfset filtro = "">
							<cfif isdefined("form.descripcion") and len(trim(form.descripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(TPdescripcion) like '%#ucase(form.descripcion)#%' " >
							</cfif>
							<cfset filtro = filtro & "order by EDTEdescripcion">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						 
							<tr> 
							  <td colspan="3" >
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
											<!--- AREA DE BUSQUEDA --->
												<form name="filtro" method="post">
													<table border="0" width="100%" class="tituloListas">
														<tr> 
															<td colspan="2"><cf_translate key="LB_Decripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate></td>
														</tr>
														<tr> 
															<td><input type="text" name="descripcion" tabindex="1" value="<cfif isdefined("form.descripcion") and len(trim(form.descripcion)) gt 0 ><cfoutput>#form.descripcion#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
															<td nowrap>
																
																<cfoutput>
																<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
																<input type="submit" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
																</cfoutput>
															</td>
														</tr>
										</table>
												</form>						
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Descripcion"
													Default="Descripci&oacute;n"
													XmlFile="/rh/ExpDeportivo/generales.xml"
													returnvariable="LB_Descripcion"/>
									
						</td>
						
						
						<cfquery name="rsLista" datasource="#session.DSN#" result="rsListaGrupoNivel">
									select EDTEid, EDTEdescripcion
									from EDTipoEstadisticas
									where 1=1
									#PreserveSingleQuotes(filtro)#
						
						</cfquery>
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="EDTEdescripcion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
									<cfinvokeargument name="formatos" value="C,V"/>
									<cfinvokeargument name="align" value="left, left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="TipoEstadisticas.cfm"/>
									<cfinvokeargument name="keys" value="EDTEid"/>
									<cfinvokeargument name="EmptyListMsg" value="true"/>
								</cfinvoke> 
									
											<!--- AREA DE BUSQUEDA --->
											<td width="50%" valign="top"><cfinclude template="tiposestadisticas-form.cfm"></td>
										</tr>
									</table>
							  </td>
							  
							</tr>
							</table> 
						
						
						
						
						
						  </td>
					  </tr>
					</table>
	<cf_templatefooter>