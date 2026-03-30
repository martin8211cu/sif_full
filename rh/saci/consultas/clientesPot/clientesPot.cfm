<cf_templateheader title="Consulta de Control de Ventas por Agente">
	<cf_web_portlet_start titulo="Consulta de Control de Ventas por Agente">
		<cfoutput>
			<form method="get" name="form1" action="clientesPot-sql.cfm">
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
					  <td width="43%">
							<table width="100%">
								<tr>
									<td valign="top">	
										<cf_web_portlet_start tipo="box" titulo="Consulta de Control de Ventas por Agente">
											<div align="justify">
												Este reporte permite visualizar la cantidad de clientes potenciales que se le 
												asignaron, formalizaron o descartaron al agente.
											</div>
										<cf_web_portlet_end> 
									</td>
								</tr>
							</table>  
					  </td>
						<td width="57%" valign="top">
							<table width="100%"  border="0" cellspacing="2" cellpadding="0">
							  <tr>
								<td width="21%" align="right"><strong>Agente</strong>:</td>
								<td>
									<cf_identificacion 
										soloAgentes="true"
										ocultarPersoneria="true"
										editable="false"
										pintaEtiq="false">
								</td>
							  </tr>										
							  <tr>
								<td width="21%" align="right"><strong>Modo:</strong></td>
								<td nowrap>
									<input name="rbModo" type="radio" value="1" <cfif isdefined('form.rbModo') and form.rbModo EQ 1> checked<cfelse> checked</cfif>>
									Por Agente.
									<input name="rbModo" type="radio" value="2" <cfif isdefined('form.rbModo') and form.rbModo EQ 1> checked</cfif>>
									Detalle de Prospectos. </td>
							  </tr>							  
							  <tr>
								<td></td>
							  </tr>
							  <tr>
								<td align="right"><strong>Formato:</strong></td>
								<td>
									<select name="formato">
										<option value="1">Flash Paper</option>
										<option value="2">Adobe PDF</option>
										<option value="3">Microsoft Excel</option>
									</select>
								</td>
							  </tr>
							  <tr>
								<td colspan="2" align="center">&nbsp;</td>
							  </tr>
							  <tr>
								<td colspan="2" align="center"><input type="submit" value="Consultar" name="Reporte"></td>
							  </tr>
							</table>
					  </td>
					</tr>
				</table>
			</form>
		</cfoutput>
	<cf_web_portlet_end> 
<cf_templatefooter>