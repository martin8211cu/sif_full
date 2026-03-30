	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestosDeRecursosHumanosPorTipo"
	Default="Puestos de Recursos Humanos por Tipo"
	returnvariable="LB_PuestosDeRecursosHumanosPorTipo"/>
	
	
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_PuestosDeRecursosHumanosPorTipo#">
			<table width="100%" border="0" cellspacing="0">			  
			 	<tr>
			  		<td valign="top"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
			  	</tr>
			  	<tr><td>&nbsp;</td></tr>
			  	<tr>
					<td valign="top">
					<form name="form1" action="PuestosPorTipo-SQL.cfm" method="get">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="46%" valign="top">															
									<cf_web_portlet_start border="true" titulo="#LB_PuestosDeRecursosHumanosPorTipo#" skin="info1">
										<div align="justify">
										  	<p>
										  		<cf_translate key="LB_ReporteDePuestosDeRecursosHumanosOrdenadosPorTipoDePuesto">
													Reporte de puestos de recursos humanos ordenados por tipo de puesto
												</cf_translate>.
											</p>
										</div>
									<cf_web_portlet_end>
							  </td>
								<td width="54%">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_ListaDeTiposDePuesto"
										Default="Lista de Tipos de Puesto"
										returnvariable="LB_ListaDeTiposDePuesto"/>
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
										Key="LB_NoSeEncontraronRegistros"
										Default="No se encontraron registros"
										returnvariable="LB_NoSeEncontraronRegistros"/>
									<table width="99%" cellpadding="0" cellspacing="0">
										<tr>
											<td width="36%" align="right"><strong><cf_translate key="LB_TipoDePuestoDesde">Tipo de puesto desde</cf_translate>:&nbsp;</strong></td>
											<td width="64%">    
												<cf_conlis 
													campos="RHTPid_desde,RHTPcodigo_desde,RHTPdescripcion_desde"
													asignar="RHTPid_desde,RHTPcodigo_desde,RHTPdescripcion_desde"
													size="0,15,25"
													desplegables="N,S,S"
													modificables="N,S,N"						
													title="#LB_ListaDeTiposDePuesto#"
													tabla="RHTPuestos a"
													columnas="RHTPid as RHTPid_desde, RHTPcodigo as RHTPcodigo_desde, RHTPdescripcion as RHTPdescripcion_desde"
													filtro="a.Ecodigo = #Session.Ecodigo# 
															order by RHTPcodigo, RHTPdescripcion"
													filtrar_por="RHTPcodigo, RHTPdescripcion"
													desplegar="RHTPcodigo_desde, RHTPdescripcion_desde"
													etiquetas="#LB_Codigo#,#LB_Descripcion#"
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
											<td width="36%" align="right"><strong><cf_translate key="LB_TipoDePuestoHasta">Tipo de puesto hasta</cf_translate>:&nbsp;</strong></td>
											<td width="64%">  
												<cf_conlis 
													campos="RHTPid_hasta,RHTPcodigo_hasta,RHTPdescripcion_hasta"
													asignar="RHTPid_hasta, RHTPcodigo_hasta, RHTPdescripcion_hasta"
													size="0,15,25"
													desplegables="N,S,S"
													modificables="N,S,N"						
													title="#LB_ListaDeTiposDePuesto#"
													tabla="RHTPuestos a"
													columnas="RHTPid as RHTPid_hasta, RHTPcodigo as RHTPcodigo_hasta, RHTPdescripcion as RHTPdescripcion_hasta"
													filtro="a.Ecodigo = #Session.Ecodigo# 
															order by RHTPcodigo, RHTPdescripcion"
													filtrar_por="RHTPcodigo, RHTPdescripcion"
													desplegar="RHTPcodigo_hasta, RHTPdescripcion_hasta"
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
											<td width="36%" align="right"><strong><cf_translate key="LB_Estado">Estado</cf_translate>:&nbsp;</strong></td>
											<td>
												<select name="RHPactivo" tabindex="1">
													<option value="-1"><cf_translate key="LB_Todos">Todos</cf_translate></option>
													<option value="1"><cf_translate key="LB_Activo">Activo</cf_translate></option>
													<option value="0"><cf_translate key="LB_Inactivo">Inactivo</cf_translate></option>
												</select>
											</td>
										</tr>
										<tr>
											<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
											<td>
											<select name="formato">
												<option value="flashpaper">Flashpaper</option>
												<option value="pdf">PDF</option>
												<option value="excel">Excel</option>
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
