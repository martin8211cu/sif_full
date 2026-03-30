<cf_templateheader title="	Compras - Compras por Proveedor (Montos)">
		<cf_web_portlet_start titulo="Compras por Proveedor (Montos)">
		
			<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
			<script language="JavaScript" type="text/JavaScript">
				<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				//-->
			</script>
		
			<cfoutput>
				<form name="form1" method="post" action="ComprasProveedorRP-Imprime.cfm" >		
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<table width="100%">
									<tr>
										<td valign="top"> 
											<cf_web_portlet_start border="true" titulo="&Oacute;rdenes de Compra por Proveedor (Montos)" skin="info1">
												<div align="justify">
													<p>Este reporte muestra todas las Ordenes de Compra que tiene el Proveedor a la fecha, en el rango de fechas especificados por el usuario en la aplicación.</p>
												</div>
											<cf_web_portlet_end> 
										</td>
									</tr>
								</table>
							</td>
						
							<td width="50%" valign="top">
								<table width="100%" cellpadding="0" cellspacing="0" align="center">
									<tr>
										<td align="right" nowrap><strong>Del Proveedor:</strong>&nbsp;</td>
										<td nowrap colspan="3">
											<cf_sifsociosnegocios2 sntiposocio="P" sncodigo="SNcodigo" snnumero="SNnumero" snnombre="SNnombre" frame="frame1">
										</td>
									</tr>
						
									<tr>
										<td align="right" nowrap><strong>De la Fecha:</strong>&nbsp;</td>
										<td nowrap colspan="3">
											<cfif isdefined("Form.fdesde")>
												<cfset fecha = Form.fdesde>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fdesde"> 
										</td>
									</tr>
								
									<tr>
										<td nowrap align="right"><strong>Hasta:</strong>&nbsp;</td>
										<td nowrap colspan="3">
											<cfif isdefined("Form.fhasta")>
												<cfset fecha = Form.fhasta>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fhasta"> 
										</td>
									</tr>
	
									<tr><td nowrap colspan="4">&nbsp;</td></tr>
						
									<tr>
										<td align="center" colspan="4">
											<input type="submit" name="Reporte" value="Generar">
											<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
										</td>
									</tr>
								</table>
							</td>
						</tr>				
					</table>
				</form>
			</cfoutput>
			
			<script language="JavaScript1.2" type="text/javascript">	
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");
	
				objForm.SNnumero.required = true;
				objForm.SNnumero.description="Proveedor";

				function deshabilitarValidacion(){
					objForm.SNnumero.required = false;
				}
				function limpiar(){
					objForm.SNcodigo.value = '';
					objForm.SNnumero.value = '';
					objForm.SNnombre.value = '';
					objForm.fdesde.value = '';
					objForm.fhasta.value = '';
				}
			</script>

		<cf_web_portlet_end>
	<cf_templatefooter>