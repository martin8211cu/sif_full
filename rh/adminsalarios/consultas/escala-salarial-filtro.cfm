<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Valoraci&oacute;n HAY vs Escala Salarial.">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td ><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td>
						<table width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="50%" align="center" valign="top">
									<cf_web_portlet_start border="true" titulo="Valoraci&oacute;n HAY vs Escala Salarial." skin="info1">
										<table width="100%" align="center">
											<tr><td><p>Escala Salarial.</p></td></tr>
										</table>
									<cf_web_portlet_end>
								</td>								
								<td valign="top">
									<form name="form1" method="post" action="escala-salarial.cfm" onSubmit="return validar(this);">
									<table width="100%" align="center">
										<tr>
											<td align="right" valign="middle">Escala Salarial:&nbsp;</td>
											<cfquery name="escala" datasource="#session.DSN#">
												select ESid, EScodigo, ESdescripcion 
												from RHEscalaSalHAY 
												where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
												and ESestado = 10
											</cfquery>
											<td valign="middle" >
												<select name="ESid" >
													<option value="">- seleccionar -</option>
													<cfoutput>
														<option value="#escala.ESid#">#trim(escala.EScodigo)# - #escala.ESdescripcion#</option>
													</cfoutput>
												</select>
											</td>
										</tr>
										<tr>
											<td></td>
											<td align="center"><input type="submit" name="Consultar" value="Consultar"></td>
										</tr>
									</table>
									</form>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<script language="javascript1.2" type="text/javascript">
				function validar(form){
					var mensaje = '';
					
					if ( form.ESid.value == '' ){
						mensaje += ' - El campo Escala Salarial es requerido.\n';
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
<cf_templatefooter>	