<cf_templateheader title="Reporte de Saldos de la Mercadería en Tránsito">
	<cf_templatecss>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Reporte de Saldos de la Mercadería en Tránsito">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<script language="JavaScript" type="text/javascript">
							var popUpWin = 0;
							function popUpWindow(URLStr, left, top, width, height){
								if(popUpWin){
									if(!popUpWin.closed) popUpWin.close();
								}
								popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
							}
						
							function doConlisTrackings() {
								popUpWindow("/cfmx/sif/cm/proveedor/ConlisTrackings.cfm?idx=1",30,100,950,500);
							}
							
							function traeTracking(value, index){
								if (value!=''){	   
									document.getElementById("frTracking").src = '../proveedor/traerTracking.cfm?ETconsecutivo='+value+'&index='+index;
								}
								else{
									document.form1.ETidtracking_move1.value = '';
									document.form1.ETconsecutivo_move1.value = '';
									document.form1.ETnumtracking_move1.value = '';
								}
							}
							
							function doConlisCompradores1() {
								var params = "";
									params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1";
								popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
							}
							
							function comprador(opcion, value){
								if ( value !='' ){
									document.getElementById("frComprador").src = "CompradoresConsulta.cfm?CMCcodigo="+value+"&opcion="+opcion;
								}
							}							
							
							function doConlisOrdenesImportacion(valor) {
								popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraImportacion.cfm?idx="+valor,30,100,900,500);
							}
							
							function traerOrdenImportacion(value, index){
								if (value!=''){	   
									document.getElementById("frOrden").src = 'traerOrdenImportacion.cfm?EOnumero='+value+'&index='+index;
								}
								else{
									document.form1.EOidorden1.value = '';
									document.form1.EOnumero1.value = '';
									document.form1.Observaciones1.value = '';
									document.form1.EOidorden2.value = '';
									document.form1.EOnumero2.value = '';
									document.form1.Observaciones2.value = '';
								}
							 }
						</script>
						
						<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
						
						<form method="post" name="form1" action="SaldosMercaderiaTransito-vista.cfm" onSubmit="javascript:if(document.form1.Ccuenta.value == ''){alert('Debe elegir el auxiliar de tránsito');return false;}">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="40%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cf_web_portlet_start border="true" titulo="Reporte de Saldos de la Mercadería en Tránsito" skin="info1">
														<div align="justify">En &eacute;ste reporte 
														  se detalle los saldos de la mercadería en
														  tránsito (no ha sido desalmacenada).
														</div>
													<cf_web_portlet_end>
												</td>
											</tr>
										</table>  
									</td>
									<td width="60%" valign="top">
										<table width="100%"  border="0" cellspacing="2" cellpadding="0">
											<tr>
												<td align="right"><strong>Comprador</strong></td>
												<td>
													<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(1,this.value);">
													<input type="text" readonly name="CMCnombre1" id="CMCnombre1" size="40" maxlength="80">
													<input type="hidden" name="CMCid1" value="">
													<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores1();'></a>
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Proveedor</strong></td>
												<td>
													<cf_sifsociosnegocios2 sntiposocio="P" sncodigo="SNcodigo1" snnumero="SNnumero1" snnombre="SNnombre1" frame="frProveedor">
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Orden de Compra Inicial</strong></td>
												<td>
													<input type="hidden" name="EOidorden1" value="">
													<input type="text" size="10" name="EOnumero1" value="" onblur="javascript:if(isNaN(this.value)){this.value=''; document.form1.EOidorden1.value=''; document.form1.Observaciones1.value=''; return false;} traerOrdenImportacion(this.value,1);">
													<input type="text" size="40" readonly name="Observaciones1" value="" >									
													<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesImportacion(1);'></a>												
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Orden de Compra Final</strong></td>
												<td>
													<input type="hidden" name="EOidorden2" value="">
													<input type="text" size="10" name="EOnumero2" value="" onblur="javascript:if(isNaN(this.value)){this.value=''; document.form1.EOidorden2.value=''; document.form1.Observaciones2.value=''; return false;} traerOrdenImportacion(this.value,2);">
													<input type="text" size="40" readonly name="Observaciones2" value="" >									
													<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesImportacion(2);'></a></div>
												</td>
											</tr>											
											<tr>
												<td align="right"><strong>No. Tracking</strong></td>
												<td>
													<input type="hidden" name="ETidtracking_move1" value="">
													<input type="text" size="10" name="ETconsecutivo_move1" value="" onblur="javascript: if(isNaN(this.value)){this.value=''; document.form1.ETidtracking_move1.value=''; document.form1.ETconsecutivo_move1.value=''; return false;} traeTracking(this.value,1); fm(this,-1)">
													<input type="text" readonly name="ETnumtracking_move1" value="">
													<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackings de Embarque" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisTrackings();'></a>
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Auxiliar de Tránsito</strong></td>
												<td>
													<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frCuenta" auxiliares="N" movimiento="S" form="form1">
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Columnas Adicionales</strong></td>
												<td><input type="checkbox" name="ColumnasAdicionales"></td>
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
						<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
						<iframe name="frTracking" id="frTracking" marginheight="0" marginwidth="0" frameborder="0" height="0" width="10" scrolling="auto" src=""></iframe>
						<iframe name="frOrden" id="frOrden" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
					</cfoutput>
				<cf_web_portlet_end>
	<cf_templatefooter>
