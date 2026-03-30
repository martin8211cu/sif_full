<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Plazas Presupuestarias">
		<script type="text/javascript" language="javascript1.2">								
			function funcValidaciones(){
				if (document.form1.fechaCorte.value == ''){
					alert("Debe seleccionar la fecha  de corte");
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
				<form name="form1" action="PlazasPresupuestarias-SQL.cfm" method="post" onsubmit="javascript: return funcValidaciones();">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="49%" valign="top">															
								<cf_web_portlet_start border="true" titulo="Plazas Presupuestarias" skin="info1">
									<div align="justify">
									  <p>Reporte de plazas presupuestarias a una fecha dada.</p>
									</div>
								<cf_web_portlet_end>
						  </td>
							<td width="51%">
								<table width="99%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="37%" align="right"><strong>Ver:&nbsp;</strong></td>
										<td width="63%">                            
											<select name="Estado">
												<option value="A">Activas</option>
												<option value="C">Congeladas</option>
												<option value="B">Ambas</option>
											</select>
									  </td>
									</tr>
									<tr>
										<td width="37%" align="right"><strong>Fecha de corte:&nbsp;</strong></td>
										<td width="63%">                            
											<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaCorte" value="#LSDateFormat(now(),'dd/mm/yyyy')#">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>Centro funcional:&nbsp;</strong></td>
										<td>
											<cf_rhcfuncional form="form1" tabindex="4" size="30">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>Oficina:&nbsp;</strong></td>
										<td>
											<cf_sifoficinas form="form1">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>Departamento:&nbsp;</strong></td>
										<td>
											<cf_conlis 
												campos="Dcodigo,Deptocodigo,Ddescripcion"
												asignar="Dcodigo,Deptocodigo,Ddescripcion"													
												size="0,10,30"
												desplegables="N,S,S"
												modificables="N,S,N"						
												title="Lista de Departamentos"
												tabla="Departamentos"
												columnas="Dcodigo,Deptocodigo,Ddescripcion"
												filtro="Ecodigo = #session.Ecodigo#"
												filtrar_por="Dcodigo,Deptocodigo,Ddescripcion"
												desplegar="Deptocodigo,Ddescripcion"
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