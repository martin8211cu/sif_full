<cf_templateheader title="Punto de Venta - Consulta de Estado de Facturaci&oacute;n">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Estado de Facturaci&oacute;n">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
					  <table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
                        <tr>
                          <td width="50%" valign="top">
						  	<cf_web_portlet_start border="true" titulo="Adelantos" skin="info1">
                            	<div align="justify">Este reporte muestra un resumen de una o varias transacciones procesadas de 
								acuerdo con los criterios de selección indicados. </div>
                         	 <cf_web_portlet_end> 
						 </td>
                          <form method="get" name="form1" action="ConsultaEstadosFactura-sql.cfm" onSubmit="javascript: return funcValida();">
						  <td width="50%" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="2">
                              <tr>
                                <td align="right"><strong>Documento:</strong></td>
                                <td><input type="text" name="FAX01DOC" size="20" maxlength="20" tabindex="1"></td>
                              </tr>
                              <tr>
                                <td align="right"><strong>Caja:</strong></td>
                                <td><cf_sifcajaspv form="form1" Ocodigo="Ocodigo2" tabindex="2"></td>
                              </tr>
                              <tr>
                                <td align="right" nowrap="nowrap"><strong>Fecha Inicial:</strong></td>
                                <td><cf_sifcalendario value="" form="form1" name="fechadesde" tabindex="3"></td>
                              </tr>
                              <tr>
                                <td align="right" nowrap="nowrap"><strong>Fecha Final:</strong></td>
                                <td><cf_sifcalendario value="" form="form1" name="fechahasta" tabindex="4"></td>
                              </tr>
                              <tr>
                                <td align="right" nowrap="nowrap"><strong>Estado de transacci&oacute;n:</strong></td>
                                <td>
									<select name="FAX01STA" tabindex="5">
										<option value="T">Terminada</option>
										<option value="C">Contablizada</option>
										<option value="A">Terminada y contabilizada</option>
									</select>
                                </td>
                              </tr>
                              <tr>
                                <td align="right" nowrap="nowrap"><strong>Cliente:</strong></td>
                                <td><cf_sifclientedetcorp modo='ALTA' tabindex="6"> </td>
                              </tr>
							  <tr>
                                <td align="right" nowrap="nowrap"><strong>Oficina:</strong></td>
                                <td><cf_sifoficinas form="form1" tabindex="7"></td>
                              </tr>
                              <tr>
                                <td align="right"><strong>Formato</strong></td>
                                <td>
									<select name="formato" tabindex="8">
										<option value="html">HTML</option>
										<option value="flashpaper">Flash Paper</option>
										<option value="pdf">Adobe PDF</option>
									</select>
                                </td>
                              </tr>
                              <tr>
                                <td colspan="2">&nbsp;</td>
                              </tr>
                              <tr>
                                <td colspan="2" align="center"><input type="submit" value="Generar" name="Generar"></td>
                              </tr>
                          </table></td>
						  </form>
                        </tr>
                      </table>						
					  
					</cfoutput>

					<cf_qforms>
					<script language="javascript">
						function funcValida(){
							if (document.form1.FAX01STA.value != 'T'){
								if (document.form1.fechadesde.value == '' || document.form1.fechahasta.value == ''){
									alert("Debe seleccionar la fecha desde y la fecha hasta");
									return false;
								}
							}
							return true;
						}
					</script>
		<cf_web_portlet_end>
<cf_templatefooter>	  
