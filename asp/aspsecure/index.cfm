<cf_templateheader title="Menú Principal de Autorizaciones">
	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal de Autorizaciones">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top" align="center"	width="75%">
			<!--- *** --->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td align="left" valign="middle" class="tituloSeccion">
						
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="1%" align="right" valign="middle" class="tituloSeccion"><a href="tipotarjeta.cfm"><img src="16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
							  <td align="left" valign="middle" class="tituloSeccion"><a href="tipotarjeta.cfm">Tipos de Tarjeta</a></td>
							</tr>
						</table>
						
						</td>
					  </tr>
					  <tr>
						<td class="textoSIF3"><blockquote>
						  <p align="justify"><a href="tipotarjeta.cfm">Entre a esta opci&oacute;n para indicar cu&aacute;les tipos de tarjetas de cr&eacute;dito o d&eacute;bito se aceptar&aacute;n para recibir pagos en las empresas afiliadas al portal, ya sea de donaciones a iglesias, de compras de bienes o servicios u otro tipo de pago. En este registro solamente deben indicarse las grandes clasificaciones de tarjetas (AMEX/VISA/MC), dejando de lado las marcas espec&iacute;ficas de cada emisor, como VISA Banco Nacional, VISA Dorada Plus, etc. </a></p>
						</blockquote></td>
					  </tr>
					  <tr>
						<td align="left" valign="middle" class="tituloSeccion">
						
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="1%" align="right" valign="middle" class="tituloSeccion"><a href="autorizador.cfm"><img src="16x16_flecha_right.gif" width="16" height="16"  border="0"></a></td>
							  <td align="left" valign="middle" class="tituloSeccion"><a href="autorizador.cfm">Autorizadores de Transacciones de Cr&eacute;dito</a></td>
							</tr>
						</table>
						
						</td>
					  </tr>
					  <tr>
						<td class="textoSIF3"><blockquote>
						  <p align="justify"><a href="autorizador.cfm">Aqu&iacute; se indica qu&eacute; instituciones financieras est&aacute;n en la posibilidad de autorizar transacciones de tarjetas de cr&eacute;dito o d&eacute;bito, y el mecanismo de interconexi&oacute;n con cada uno de ellos.<br>
						    Es importante hacer notar que para incluir un nuevo autorizador, probablemente se necesitar&aacute; implementar una conexi&oacute;n espec&iacute;fica para este autorizador, que puede incluir desde la firma de un contrato o la apertura de una cuenta en la instituci&oacute;n financiera, hasta la realizaci&oacute;n de un programa de conexi&oacute;n para realizar estas autorizaciones. </a></p>
						</blockquote></td>
					  </tr>
					  <tr>
						<td align="left" valign="middle" class="tituloSeccion">
						
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="1%" align="right" valign="middle" class="tituloSeccion"><a href="comercio.cfm"><img src="16x16_flecha_right.gif" width="16" height="16"  border="0"></a></td>
							  <td align="left" valign="middle" class="tituloSeccion"><a href="comercio.cfm">Comercios Afiliados </a></td>
							</tr>
						</table>
						
						</td>
					  </tr>
					  <tr>
						<td class="textoSIF3"><blockquote>
						  <p align="justify"><a href="comercio.cfm">Representa la afiliaci&oacute;n de un comercio a una instituci&oacute;n financiera, es decir, cada una de las cuentas en las que se depositar&aacute;n los pagos realizados con tarjetas de cr&eacute;dito. Normalmente estas cuentas ser&aacute;n abiertas por la administraci&oacute;n del portal y ser&aacute;n puestas a disposici&oacute;n de las empresas afiliadas al portal para recibir los pagos de sus transacciones comerciales. </a></p>
						</blockquote></td>
					  </tr>
					  <tr>
						<td align="left" valign="middle" class="tituloSeccion">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="1%" align="right" valign="middle" class="tituloSeccion"><a href="consulta.cfm"><img src="16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
							  <td align="left" valign="middle" class="tituloSeccion"><a href="consulta.cfm">Consulta de Autorizadores por Empresa </a></td>
							</tr>
						</table>
						</td>
					  </tr>
					  <tr>
						<td class="textoSIF3"><blockquote>
						  <p align="justify"><a href="consulta.cfm">Revisar qu&eacute; empresas se han afiliado a cada autorizador. </a></p>
						</blockquote></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
				</table> 
			</td>
			<td valign="top" align="center" width="25%"> </td>
		</tr>
	</table>
	<cf_web_portlet_end><cf_templatefooter>