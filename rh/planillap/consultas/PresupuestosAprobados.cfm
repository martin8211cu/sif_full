<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Presupuestos Aprobados">
		<table width="100%" border="0" cellspacing="0">			  
		  <tr>
			<td valign="top">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
			</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr>
			<td valign="top">
				<form name="form1" action="PresupuestosAprobados-SQL.cfm" method="post">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="47%" valign="top">															
								<cf_web_portlet_start border="true" titulo="Presupuestos Aprobados" skin="info1">
									<div align="justify">
									  <p>Reporte de las partidas presupuestarias aprobadas en el escenario.</p>
									</div>
								<cf_web_portlet_end>
						  </td>
							<td width="53%">
								<table width="99%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="28%" align="right"><strong>Escenario:&nbsp;</strong></td>
										<td width="72%">                            
											<cf_conlis 
												campos="RHEid, RHEdescripcion"
												asignar="RHEid, RHEdescripcion"
												size="0,25"
												desplegables="N,S"
												modificables="N,S"						
												title="Lista de Escenarios"
												tabla="RHEscenarios a"
												columnas="RHEid, RHEdescripcion"
												filtro="a.Ecodigo = #Session.Ecodigo# 
														and a.RHEestado = 'A'"
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
