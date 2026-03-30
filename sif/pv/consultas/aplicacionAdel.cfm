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
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta Aplicaci&oacute;n de Adelantos">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="get" name="form1" action="aplicacionAdel-sql.cfm">
							<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
								  <td width="50%" valign="top">
										<cf_web_portlet_start border="true" titulo="Aplicaci&oacute;n de Adelantos" skin="info1">
											<div align="justify">En &eacute;ste reporte 
											  se detalla la informaci&oacute;n de todas 
											  las Aplicaciones de Adelantos por Cliente.
											  Encontraremos varios clasificaciones del
											  reporte, dependiendo por medio de qu&eacute; 
											  aspectos se desea detallar.
											  Este reporte se puede generar en varios
											  formatos, aumentando as&iacute; su utilidad 
											  y eficiencia en el traslado de datos.
											</div>
										<cf_web_portlet_end>
								  </td>
									<td width="50%" valign="top">
								  	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
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
                                        <td align="right"><strong>Documento:</strong></td>
										<td><input type="text" name="FAX14DOC"></td>
                                      </tr>	
                                      <tr>
                                        <td align="right" nowrap><strong>Fecha Inicial:</strong></td>
                                        <td>
											<cf_sifcalendario value="" form="form1" name="FAX14FEC_ini">
										</td>
                                      </tr>	
                                      <tr>
                                        <td align="right" nowrap><strong>Fecha Final:</strong></td>
                                        <td><cf_sifcalendario value="" form="form1" name="FAX14FEC_fin"></td>
                                      </tr>										  									  							  			
									  
                                      <tr>
                                        <td align="right"><strong>Formato</strong></td>
                                        <td><select name="formato">
                                            <option value="1">Flash Paper</option>
                                            <option value="2">Adobe PDF</option>
                                            <!--- <option value="3">Microsoft Excel</option> --->
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
					
					<cf_qforms>
					<script language="javascript">
						function _isFechas(){
							var valorINICIO=0;
							var valorFIN=0;
							var INICIO = document.form1.FAX14FEC_ini.value;
							var FIN = this.value;
							
							INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
							FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
							valorINICIO = parseInt(INICIO)
							valorFIN = parseInt(FIN)
					
							if (valorINICIO > valorFIN)
								this.error="Error, la fecha de inicio (" + document.form1.FAX14FEC_ini.value + ") no debe ser mayor que la fecha final (" + this.value + ")";
						}	
						
						_addValidator("isFechas", _isFechas);		
					
					
						objForm.FAX14FEC_fin.validateFechas();
					</script>
					
				<cf_web_portlet_end>
<cf_templatefooter>	  


