<!--- QUERY PARA el tag de Oficinas--->
<cfquery name = "rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
    from Oficinas
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name = "rsCajas" datasource="#session.DSN#">
	Select Ocodigo,FAM01CODD,FAM01DES
    from FAM001
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cf_templateheader title="Punto de Venta - Consulta de Adelantos">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta Añejamiento de Adelantos">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="get" name="form1" action="anejamAdel-sql.cfm">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="50%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cf_web_portlet_start border="true" titulo="Adelantos" skin="info1">
														<div align="justify">En &eacute;ste reporte 
														  se detalla la informaci&oacute;n de todos 
														  los Adelantos por Cliente.
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
									<td width="50%" valign="top">								  <table width="100%"  border="0" cellspacing="2" cellpadding="0">
                                      <tr>
                                        <td align="right"><strong>Oficina</strong></td>
                                        <td>
											<cf_sifoficinas form="form1">
										</td>
                                      </tr>
                                      <tr>
                                        <td align="right"><strong>Cliente</strong></td>
                                        <td><cf_sifclientedetcorp modo='ALTA'> </td>
                                      </tr>
                                      <tr>
											<td align="right"><strong>Caja</strong></td>
											<td><cf_sifcajasPV form="form1" name="FAM01CODD" Ocodigo="Ocodigo2" ></td>
									  </tr>
                                      <tr>
                                        <td align="right"><strong>Formato</strong></td>
                                        <td><select name="formato">
                                            <option value="1">Flash Paper</option>
                                            <option value="2">Adobe PDF</option>
                                        </select></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" align="right">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" align="center"><input type="submit" value="Generar" name="Reporte"></td>
                                      </tr>
                                    </table></td>
								</tr>
							</table>
						</form>
					</cfoutput>
				<cf_web_portlet_end>
<cf_templatefooter>	  