	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Empleados sin Componentes">
			<script type="text/javascript" language="javascript1.2">
				function funcValida(){
					if (document.form1.CSid.value == ''){
						alert("Debe seleccionar el componente");
						return false;
					}
					return true;
				}
			</script>
			<table width="100%" border="0" cellspacing="0">			  
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				<td valign="top">
					<form name="form1" action="EmpleadosSinComponentes-SQL.cfm" method="post">
						<table width="98%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="50%">															
									<cf_web_portlet_start border="true" titulo="Empleados sin componentes" skin="info1">
										<div align="justify">
										  <p>Reporte listado de los empleados que no recibieron un componente en su salario, para 
										  un rango de fechas y un componente seleccionados.</p>
										</div>
									<cf_web_portlet_end>
								</td>
								<td width="50%">
									<table width="98%" cellpadding="0" cellspacing="0">
										<tr>
											<td width="26%" align="right"><strong>Fecha desde:&nbsp;</strong></td>
											<td width="74%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechadesde">
										  </td>
										</tr>
										<tr>
											<td align="right"><strong>Fecha hasta:&nbsp;</strong></td>
											<td>                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechahasta">
											</td>
										</tr>
										<tr>
											<td align="right"><strong>Componente:&nbsp;</strong></td>
											<td>                            
												<cf_conlis 
													campos="CSid, CScodigo, CSdescripcion"
													asignar="CSid, CScodigo, CSdescripcion"
													size="0,8,25"
													desplegables="N,S,S"
													modificables="N,S,N"						
													title="Lista de Componentes"
													tabla="ComponentesSalariales a"
													columnas="CSid, CScodigo, CSdescripcion"
													filtro="a.Ecodigo = #Session.Ecodigo# "
													filtrar_por="CScodigo, CSdescripcion"
													desplegar="CScodigo, CSdescripcion"
													etiquetas="C&oacute;digo, Descripci&oacute;n"
													formatos="S,S"
													align="left,left"								
													asignarFormatos="S,S,S"
													form="form1"
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
												<input type="submit" name="btn_consultar" value="Consultar" onclick="javascript: return funcValida();"/>
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
