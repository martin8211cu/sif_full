	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Solicitudes de Plaza Terminadas">			
			<table width="100%" border="0" cellspacing="0">			  
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				<td valign="top">
					<form name="form1" action="PlazasTerminadas-SQL.cfm" method="post">
						<table width="98%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="40%" valign="top">															
									<cf_web_portlet_start border="true" titulo="Solicitudes de Plaza Terminadas" skin="info1">
										<div align="justify">
										  <p>Reporte de las plazas terminadas que fueron atendidas por uno o varios escenarios.</p>
										</div>
									<cf_web_portlet_end>
								</td>
								<td width="60%">
									<table width="98%" cellpadding="0" cellspacing="0">
										<tr>
											<td width="34%" align="right"><strong>Centro Funcional:&nbsp;</strong></td>
										  <td width="66%" colspan="2" align="left" nowrap><cf_rhcfuncional tabindex="1"></td>
										</tr>										
										<tr>
											<td align="right"><strong>Solicitante:&nbsp;</strong></td>
											<td><cf_sifusuario form="form1"></td>
										</tr>
										<tr>
											<td width="34%" align="right"><strong>No.Solicitud desde:&nbsp;</strong></td>
										  <td width="66%"><input type="text" name="RHSPconsecutivo_desde" value="" size="10"/></td>
										</tr>
										<tR>
											<td width="34%" align="right"><strong>No.Solicitud hasta:&nbsp;</strong></td>
										  <td width="66%"><input type="text" name="RHSPconsecutivo_hasta" value="" size="10"/></td>
										</tR>
										<tr>
											<td align="right"><strong>Escenario:&nbsp;</strong></td>
											<td>                            
												<cf_conlis 
													campos="RHEid, RHEdescripcion"
													asignar="RHEid, RHEdescripcion"
													size="0,25"
													desplegables="N,S"
													modificables="N,S"						
													title="Lista de Escenarios"
													tabla="RHEscenarios a"
													columnas="RHEid, RHEdescripcion"
													filtro="a.Ecodigo = #Session.Ecodigo# "
													filtrar_por="RHEdescripcion"
													desplegar="RHEdescripcion"
													etiquetas="Descripci&oacute;n"
													formatos="S"
													align="left"								
													asignarFormatos="S,S"
													form="form1"
													top="50"
													left="200"
													showEmptyListMsg="true"
													EmptyListMsg=" --- No se encontraron registros --- "
												/>
											</td>
										</tr>
										<tr>
											<td align="right"><strong>Formato:&nbsp;</strong></td>
											<td>
												<select name="formato">
													<option value="FlashPaper">FlashPaper</option>
													<option value="pdf">Adobe PDF</option>
													<option value="Excel">Microsoft Excel</option>
												</select>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<input type="submit" name="btn_consultar" value="Consultar"/>
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
