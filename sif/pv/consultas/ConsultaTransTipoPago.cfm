<!--- QUERY PARA el tag de Oficinas--->
<cfquery name = "rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
    from Oficinas
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cf_templateheader title="Punto de Venta - Consulta de Transacciones por Tipo">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Transacciones por Tipo de Pago">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="post" name="form1" action="ConsultaTransTipoPago-sql.cfm">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="50%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cf_web_portlet_start border="true" titulo="Transacciones por Tipo de Pago" skin="info1">
														<div align="justify">En &eacute;ste reporte 
														  se detalla la informaci&oacute;n de todas 
														  las Transacciones por Tipo.
														  Encontraremos varios clasificaciones del
														  reporte, dependiendo por medio de qu&eacute; 
														  aspectos se desea detallar.
														  Este reporte se puede generar en varios
														  formatos, aumentando as&iacute; su utilidad 
														  y eficiencia en el traslado de datos.
														</div>
													<cf_web_portlet_end>
												</td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%"  border="0" cellspacing="2" cellpadding="0">
										  <tr>
										   	<td align="right"><strong>Oficina</strong></td>
											<td>
												<cf_sifoficinas form="form1" >							
											</td>
										  </tr>
										  <tr>
										   	<td align="right"><strong>Moneda</strong></td>
											<td>
												 <cf_sifmonedas CrearMoneda = 'false' Conlis = 'S'>							
											</td>
										  </tr>
										  <tr>
											<td align="right"><strong>Tipo</strong></td>
											<td> <select name="FAX01TPG">
												<option value="">-Seleccionar-</option>
												<option value=1 >Cr&eacute;dito </option>
												<option value=0 >Contado</option>
											</select></td>
										  </tr>
										   <tr>
											<td align="right"><strong>Estado</strong></td>
											<td> <select name="estado">
												<option value="">-Seleccionar-</option>
												<option value="T" >Terminada </option>
												<option value="C" >Contabilizada</option>
												<option value="A">Anulada</option>
											</select></td>
										  </tr>
										  
										  						  
										  <tr>
											<td align="right"><strong>Formato</strong></td>
											<td><select name="formato">
											  <option value="flashpaper">Flash Paper</option>
											  <option value="pdf">Adobe PDF</option>
											  <option value="excel">Microsoft Excel</option>
											</select></td>
										  </tr>
										  <tr>
											<td colspan="2" align="center">&nbsp;</td>
										  </tr>
										  <tr>
											<td colspan="2" align="center"><input type="submit" value="Generar" name="Reporte"></td>
										  </tr>
										</table>
								  </td>
								</tr>
							</table>
						</form>
					</cfoutput>
				<cf_web_portlet_end>
<cf_templatefooter>	  