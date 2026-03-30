<!--- QUERY PARA el tag de Oficinas--->
<cfquery name = "rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
    from Oficinas
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- QUERY PARA EL TAG combo DE PAIS--->
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>


<cf_templateheader title="Punto de Venta - Consulta de Clientes">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Clientes">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="get" name="form1" action="ConsultaClientes-sql.cfm">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="50%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cf_web_portlet_start border="true" titulo="Clientes" skin="info1">
														<div align="justify">En &eacute;ste reporte 
														  se detalla la informaci&oacute;n de todos 
														  los clientes.
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
											<td align="right"><strong>Cliente</strong></td>
											<td><cf_sifclientedetcorp modo='ALTA'> </td>
										  </tr>
										  						  
										  <tr>
										   	<td align="right"><strong>Pa&iacute;s</strong></td>
											<td align="left" nowrap>
												<select name="Ppais">
													<option value="">-Seleccionar-</option>
													<cfloop query="rsPais">
													  <option value="#rsPais.Ppais#">#rsPais.Pnombre#</option>
													</cfloop>
												</select>
											</td>
										  </tr>
										  <tr>
											<td align="right"><strong>Formato</strong></td>
											<td><select name="formato">
												  <option value="HTML">HTML</option>
												  <option value="flashpaper">Flash Paper</option>
												  <option value="pdf">Adobe PDF</option>
												</select>
											</td>
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