<cf_templateheader title="SIF - Cuentas por Cobrar RH">
	<cfinclude template="../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal de Cuentas por Cobrar Empleados">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="75%">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" align="center"	width="75%">
							<!--- *** --->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="operacion/listaEmpleados.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
												<td align="left" valign="middle"><a href="operacion/InclusionDeducciones.cfm">Registro de Deducciones por Empleado</a></td>
											</tr>
										</table>
									</td>
								</tr>
			
								<tr>
									<td>
										<blockquote>
										<p align="justify">Realice el registro de las deducciones  a ser controladas y deducidas mediante los procesos de pago de nómina para cada uno de los empleados de la empresa; calculando en caso de ser necesario el plan de pagos y tasas de interés asociadas a cada documento de deducción.</p>
										</blockquote>
									</td>
								</tr>
							</table>	
						</td>	
					</tr>
			
					<tr>
						<td valign="top" align="center"	width="75%">
							<!--- *** --->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="operacion/planPagosFiltro.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
												<td align="left" valign="middle"><a href="operacion/planPagosFiltro.cfm">Trabajar con Planes de Pago</a></td>
											</tr>
										</table>
									</td>
								</tr>
			
								<tr>
									<td>
										<blockquote>
										<p align="justify">Modifique el monto de las cuotas de pago para las deducciones existentes y pendientes de cancelarse; ya sea mediante una modificación a las tasas de interés asociadas a los documentos de deducción o mediante el ajuste a la cantidad de cuotas de pago pendientes de realizarse.</p>
										</blockquote>
									</td>
								</tr>
							</table>	
						</td>	
					</tr>
			
					<tr>
						<td valign="top" align="center"	width="75%">
							<!--- *** --->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="operacion/registroPagosEFiltro.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
												<td align="left" valign="middle"><a href="operacion/registroPagosEFiltro.cfm">Registro de Pagos Extraordinarios</a></td>
											</tr>
										</table>
									</td>
								</tr>
			
								<tr>
									<td>
										<blockquote>
										<p align="justify">Realice la cancelación o afectación del saldo pendiente de las deducciones de un empleado, ya sea realizando la afectación del saldo de los documentos por cuotas extraordinarias, documentos internos o documentos de respaldo de pago</p>
										</blockquote>
									</td>
								</tr>
							</table>	
						</td>	
					</tr>					
					<!--- ========= Nueva opcion de "Registro de Pagos de Caja" (Para Nacion) =========----->
					<tr>
						<td valign="top" align="center"	width="75%">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="left" valign="middle">
										<table width="100%"  border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="1%" align="right" valign="middle"><a href="operacion/registroPagosEFiltro.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
												<td align="left" valign="middle"><a href="operacion/registroPagosCajaFiltro.cfm">Registro de Pagos de Caja</a></td>
											</tr>
										</table>
									</td>
								</tr>
			
								<tr>
									<td>
										<blockquote>
										<p align="justify">Realice la cancelación o afectación del saldo pendiente de las deducciones de un empleado, utilizando documentos pagados en las diferentes cajas.</p>
										</blockquote>
									</td>
								</tr>
							</table>	
						</td>	
					</tr>
					<!----- ========= Fin de pagos de caja =========---->
				</table>	
			</td>
			<td valign="top"><table width="100%"><tr><td><br><cfinclude template="MenuConsultasCCRH.cfm"></td><td>&nbsp;</td></tr></table></td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
