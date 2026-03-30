<cfquery name = "rsCajas" datasource="#session.DSN#">
	Select Ocodigo,FAM01CODD,FAM01DES
    from FAM001
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</script>

<cf_templateheader title="Punto de Venta - Consulta de Anulaci&oacute;n de Adelantos">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de  Anulaci&oacute;n de Adelantos">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="get" name="form1" action="ConsultaAnulacionAdelantos-sql.cfm" onSubmit="javascript: return funcValida();">
							<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
								  	<td width="50%" valign="top">
										<cf_web_portlet_start border="true" titulo="Adelantos" skin="info1">
											<div align="justify">En &eacute;ste reporte 
											  se listan los adelantos que han sido anulados para 
											  una caja espec&iacute;fica en un rango de fechas 
											  determinado.
											</div>
										<cf_web_portlet_end>
								  	</td>
									<td width="50%" valign="top">
								  	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
										<tr>
											<td align="right"><strong>Caja:</strong></td>
											<td><cf_sifcajasPV form="form1" tabindex="1"></td>
										</tr>
										<tr>
											<td align="right" nowrap="nowrap"><strong>Fecha Inicial:</strong></td>
											<td><cf_sifcalendario value="#LSDateFormat(now(),'dd/mm/yyyy')#" form="form1" name="fechadesde" tabindex="2"></td>
										</tr>
										<tr>
											<td align="right" nowrap="nowrap"><strong>Fecha Final:</strong></td>
											<td><cf_sifcalendario value="#LSDateFormat(now(),'dd/mm/yyyy')#" form="form1" name="fechahasta" tabindex="3"></td>
										</tr>
										<tr>
											<td align="right" nowrap="nowrap"><strong>Cliente:</strong></td>
											<td>
												<cf_sifclientedetcorp modo='ALTA' tabindex="4">
											</td>
										</tr>											
										<tr>
											<td align="right"><strong>No.Documento:</strong></td>
											<td><input type="text" name="Documento" size="20" maxlength="20" tabindex="5"></td>
										</tr>	
										<tr>
											<td align="right"><strong>Formato</strong></td>
											<td>
												<select name="formato" tabindex="6">
												  <option value="flashpaper">Flash Paper</option>
												  <option value="pdf">Adobe PDF</option>
												</select>
											</td>
										</tr>
										<tr><td colspan="2">&nbsp;</td></tr>									  
										<tr><td colspan="2" align="center"><input type="submit" value="Generar" name="Generar"></td></tr>
                                    </table></td>
								</tr>
							</table>
						</form>
					</cfoutput>

					<cf_qforms>
					<script language="javascript">
						function funcValida(){
							var vs_errores = "";
							var vb_error = false;
							if (document.form1.FAM01COD.value == ''){
								vs_errores = vs_errores + ' - El campo Caja es requerido \n';
								vb_error = true;
							}
							if (document.form1.fechadesde.value == ''){
								vs_errores = vs_errores + ' - El campo Fecha desde es requerido \n';
								vb_error = true;
							}
							if (document.form1.fechahasta.value == ''){
								vs_errores = vs_errores + ' - El campo Fecha hasta es requerido \n';
								vb_error = true;
							}
							if (vb_error){
								alert("Se presentaron los siguientes errores:\n"+vs_errores);
								return false;
							}
							return true;
						}
					</script>
		<cf_web_portlet_end>
<cf_templatefooter>	  
