	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_PuestosPresupuestarios"
			Default="Puestos Presupuestarios"
			returnvariable="LB_PuestosPresupuestarios"/>
		
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_PuestosPresupuestarios#">
			<table width="100%" border="0" cellspacing="0">			  
				<tr><td valign="top"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			  	<tr><td>&nbsp;</td></tr>
			  	<tr>
					<td valign="top">
					<form name="form1" action="PuestosPresupuestarios-SQL.cfm" method="get">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="44%" valign="top">															
									<cf_web_portlet_start border="true" titulo="#LB_PuestosPresupuestarios#" skin="info1">
										<div align="justify">
										  <p>
										  	<cf_translate key="LB_ReporteDePuestosDeRecursosHumanosPorPuestoPresupuestarioAsignado">Reporte de puestos de recursos humanos por puesto presupuestario asignado</cf_translate>.
											</p>
										</div>
									<cf_web_portlet_end>
							  </td>
								<td width="56%">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Codigo"
										Default="C&oacute;digo"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Codigo"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Descripcion"
										Default="Descripci&oacute;n"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Descripcion"/>											                         
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_ListaDeTiposDePuesto"
										Default="Lista de Tipos de Puesto"
										returnvariable="LB_ListaDeTiposDePuesto"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_NoSeEncontraronRegistros"
										Default="No se encontraron registros"
										returnvariable="LB_NoSeEncontraronRegistros"/>
									<table width="99%" cellpadding="0" cellspacing="0">
										<tr>
											<td width="40%" align="right"><strong><cf_translate key="LB_PuestoPresupuestarioDesde">Puesto presupuestario desde</cf_translate>:&nbsp;</strong></td>
											<td width="60%">   
												<cf_conlis 
													campos="RHMPPid_desde,RHMPPcodigo_desde,RHMPPdescripcion_desde"
													asignar="RHMPPid_desde,RHMPPcodigo_desde,RHMPPdescripcion_desde"
													size="0,15,25"
													desplegables="N,S,S"
													modificables="N,S,N"						
													title="#LB_ListaDeTiposDePuesto#"
													tabla="RHMaestroPuestoP a"
													columnas="RHMPPid as RHMPPid_desde, RHMPPcodigo as RHMPPcodigo_desde, RHMPPdescripcion as RHMPPdescripcion_desde"
													filtro="a.Ecodigo = #Session.Ecodigo# 
															order by RHMPPcodigo, RHMPPdescripcion"
													filtrar_por="RHMPPcodigo, RHMPPdescripcion"
													desplegar="RHMPPcodigo_desde, RHMPPdescripcion_desde"
													etiquetas="#LB_Codigo#, #LB_Descripcion#"
													formatos="S,S"
													align="left,left"								
													asignarFormatos="S,S,S"
													form="form1"
													top="50"
													left="200"
													showEmptyListMsg="true"
													EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
													tabindex="1"
												/>
										  </td>
										</tr>
										<tr>
											<td width="40%" align="right"><strong><cf_translate key="LB_PuestoPresupuestarioHasta">Puesto presupuestario hasta</cf_translate>:&nbsp;</strong></td>
											<td width="60%">                            
												<cf_conlis 
													campos="RHMPPid_hasta,RHMPPcodigo_hasta,RHMPPdescripcion_hasta"
													asignar="RHMPPid_hasta,RHMPPcodigo_hasta,RHMPPdescripcion_hasta"
													size="0,15,25"
													desplegables="N,S,S"
													modificables="N,S,N"						
													title="#LB_ListaDeTiposDePuesto#o"
													tabla="RHMaestroPuestoP a"
													columnas="RHMPPid as RHMPPid_hasta, RHMPPcodigo as RHMPPcodigo_hasta, RHMPPdescripcion as RHMPPdescripcion_hasta"
													filtro="a.Ecodigo = #Session.Ecodigo# 
															order by RHMPPcodigo, RHMPPdescripcion"
													filtrar_por="RHMPPcodigo, RHMPPdescripcion"
													desplegar="RHMPPcodigo_hasta, RHMPPdescripcion_hasta"
													etiquetas="#LB_Codigo#, #LB_Descripcion#"
													formatos="S,S"
													align="left,left"								
													asignarFormatos="S,S,S"
													form="form1"
													top="50"
													left="200"
													showEmptyListMsg="true"
													EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
													tabindex="1"
												/>
										  </td>
										</tr>

										<tr>
											<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
											<td>
												<select name="formato" tabindex="1">
													<option value="FlashPaper">FlashPaper</option>
													<option value="pdf">Adobe PDF</option>
													<option value="Excel">Microsoft Excel</option>
												</select>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="BTN_Consultar"
													Default="Consultar"
													XmlFile="/rh/generales.xml"
													returnvariable="BTN_Consultar"/>
												<input type="submit" name="btn_consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>" tabindex="1"/>
											</td>
										</tr>
								  </table>
							  </td>
							</tr>
					  </table>
					</form>
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>	
