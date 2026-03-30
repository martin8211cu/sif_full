<cf_templateheader title="Menú de implatación AH">
	<cf_template template="/plantillas/soinasp01/plantilla.cfm ">
		<cf_templatearea name="title">
			Men&uacute; Implantaci&oacute;n Application Hosting
		</cf_templatearea>
		
		<cf_templatearea name="body">        
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>&nbsp;</td>				
				</tr>
				<tr>
					<td width="49%" align="left">
						<cf_web_portlet border="true" skin="portlet" tituloalign="center" titulo="Consultas al Plan de cuentas"> 
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle" >
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Consultas/ConsultaMascaras.cfm"><img src="Images/ConsultaMascara.gif" width="16" height="16" border="0"></a></td>
												<td align="left" valign="middle"><a href="Consultas/ConsultaMascaras.cfm">Consulta Mascaras </a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
										<p align="justify"> La consulta de Mascaras del plan de cuentas, permite visualizar 
															las mascaras dadas de alta en el sistema. Permite visualizar el
															detalle de los catalogos y niveles que conforman cada una de 
															las mascaras</p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Consultas/ConsultaCuentas.cfm"><img src="Images/ConsultaCuenta.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Consultas/ConsultaCuentas.cfm">Consulta Cuentas de Mayor</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> La Consulta de Cuentas de Mayor permite visualizar de forma simplificada
												las cuentas de mayor mostrando la mascara aplicada y los distintos niveles 
												que conforman cada una de las cuentas de mayor, de acuerdo a la mascara que
												le haya sido parametrizada </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Consultas/ConsultaOrigen.cfm"><img src="Images/ConsultaOrigen.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Consultas/ConsultaOrigen.cfm">Consulta a los Origenes Contables</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> La Consulta de Origenes Contables permite ver la configuracion de cada uno 
												de los origenes registrados en el sistema, tanto de módulos SIF como de módulos
												Externos. Ademas permite verificar las cuentas y la configuración de dichas cuentas
												dentro de cada uno de los Origenes y profundizar analizando la configuracion de 
												los complementos contables para los catálogos, desde el nivel de Origen-Cuenta Mayor, 
												hasta permitir tener una vista global de todos los complementos en el sistema </p>
										</blockquote>
									</td>
								</tr>
							</table>
						</cf_web_portlet>
					</td>
					
					<td width="2%" align="left">
					</td>
					<td width="49%" align="left">
						<cf_web_portlet border="true" skin="portlet" tituloalign="center" titulo="Opciones de Seguridad"> 
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle" >
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" class="etiquetaProgreso"><a href="seguridad/Permisos_Rol.cfm"><img src="../Images/Permisos_Rol.gif" width="16" height="16" border="0"></a></td>
												<td width="99%" class="etiquetaProgreso"><a href="seguridad/Permisos_Rol.cfm" tabindex="-1">Asignacion Masiva de Permisos a Rol</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
										<p align="justify"> La asignación masiva de Permisos agiliza el registro de roles 
															permitiendo asignar varios procesos a la vez a un rol</p>
										</blockquote>
									</td>
								</tr>
                                <tr>
									<td align="left" valign="middle" >
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" class="etiquetaProgreso"><a href="../../../asp/admin/tasks/schedule.cfm"><img src="../Images/ScheduleTask.gif" width="16" height="16" border="0"></a></td>
												<td width="99%" class="etiquetaProgreso"><a href="../../../asp/admin/tasks/schedule.cfm" tabindex="-1">Tareas Programadas</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
										<p align="justify"> La asignación masiva de Permisos agiliza el registro de roles 
															permitiendo asignar varios procesos a la vez a un rol</p>
										</blockquote>
									</td>
								</tr>
							</table>
						</cf_web_portlet>
                        &nbsp;
                        <cf_web_portlet border="true" skin="portlet" tituloalign="center" titulo="Consultas Sistema"> 
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Consultas/Memoria.cfm"><img src="Images/Memoria.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Consultas/Memoria.cfm">Consulta Memoria</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite Verificar el uso de la memoria del servidor </p>
										</blockquote>
									</td>
								</tr>
                                <tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Consultas/Soinprintdocs.cfm"><img src="Images/SoinPrintdocs.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Consultas/Soinprintdocs.cfm">Consulta Soinprintdocs</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Verifica el estatus del soinprintdocs.ocx y da la solucion para la instalacion </p>
										</blockquote>
									</td>
								</tr>
							</table>
						</cf_web_portlet>	
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td width="49%" align="left">
						<cf_web_portlet border="true" skin="portlet" tituloalign="center" titulo="Importadores"> 
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/CargaCxP-from.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/CargaCxP-from.cfm">Carga Documentos de CxP</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar documentos al auxiliar de Cuentas por pagar dejandolos en 
												registro de Facturas listos para ser aplicados </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/CargaCxC-form.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/CargaCxC-form.cfm">Carga Documentos de CxC</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar documentos al auxiliar de Cuentas por cobrar dejandolos en 
												registro de Facturas listos para ser aplicados </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/CargaConceptos-form.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/CargaConceptos-form.cfm">Carga Conceptos de Servicio</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar Conceptos de Servicio al sistema SIF </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/CargaSN-from.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/CargaSN-from.cfm">Carga Socios de Negocios</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar los socios de negocios. Los socios de negocios se 
												cargan sin la información contable, esta debe ser configurada desde 
												el sistema </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/ImportarAsientosMasivo-form.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/ImportarAsientosMasivo-form.cfm">Carga Masiva de Pólizas</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar pólizas de forma masiva. </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/ImportarCobros-form.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/ImportarCobros-form.cfm">Carga de documentos de Cobro</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar documentos de cobro al auxiliar de CxC. </p>
										</blockquote>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/ImportarPagos-form.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/ImportarPagos-form.cfm">Carga de documentos de Pago</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar documentos de pago al auxiliar de CxP. </p>
										</blockquote>
									</td>
								</tr>
                                <tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="Importadores/CargaCuentasExp-form.cfm"><img src="Images/Importa.gif" width="16" height="16"  border="0"></a></td>
												<td align="left" valign="middle"><a href="Importadores/CargaCuentasExp-form.cfm">Carga Cuentas de Excepcion</a></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<blockquote>
											<p> Permite importar las cuentas de Excepcion para los Socios de Negocios </p>
										</blockquote>
									</td>
								</tr>
							</table>
						</cf_web_portlet>
					</td>
					<td width="2%" align="left">
					</td>
                    <td width="49%" align="left">
						
					</td>
				</tr>
			</table>
			
		</cf_templatearea>
	</cf_template>
<cf_templatefooter>