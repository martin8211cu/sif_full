<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">

		<cf_templatecss>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Cursos por Centro Funcional">
					<form name="form1" method="get" action="cursos-cf.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="Cursos por Centro Funcional" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>Esta consulta muestra un listado de los cursos y los colaboradores que lo tomaron, para un Centro Funcional espec&iacute;fico.</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap >Centro Funcional:&nbsp;</td>
										<td ><cf_rhcfuncional></td>
									</tr>
									<!---<tr>
										<td width="10%" align="right" nowrap >Formato:&nbsp;</td>
										<td>
											<select name="formato">
												<option value="flashpaper">Flashpaper</option>
												<option value="pdf">PDF</option>
												<option value="excel">Excel</option>
											</select>
										</td>
									</tr>--->
									<tr>
										<td colspan="2" align="center"><input type="submit" name="Consultar" value="Consultar"></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						function validar(form){
							var mensaje = '';
							
							if ( form.CFdescripcion.value == '' ){
								mensaje += ' - El campo Centro Funcional es requerido.\n';
							}

							if ( mensaje != '' ){
								mensaje = 'Se presentaron los siguientes errores:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							
							return true;
							
						}
					</script>
					
					
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>