<!---mcz
Se modifico para que el reporte que despliegue sea con el ColdFusion Report Builder
por lo tanto las opciones del combo cambian--->
<cf_templateheader title="Cotizaciones">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Solicitud de Cotizaciones'>
		<script language="JavaScript" type="text/javascript">
			function limpiar() {
				document.form1.SNcodigoI.value = "";
				document.form1.SNcodigoF.value = "";
				document.form1.ECfechacotI.value = "";
				document.form1.ECfechacotF.value = "";
				document.form1.ECnumeroI.value = "";
				document.form1.ECnumeroF.value = "";
				document.form1.SNnumeroI.value = "";
				document.form1.SNnumeroF.value = "";
				document.form1.SNnombreI.value = "";
				document.form1.SNnombreF.value = "";
			
			}
		</script>
		
			<cfoutput>
		<form method="get" name="form1" action="SolicitudCotLocal-rep.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Solicitud de Cotizaci&oacute;n Local" skin="info1">
										<div align="justify">
										  <p>En &eacute;ste reporte 
										  se muestra la informaci&oacute;n de las cotizaciones locales, por
										  proveedor, n&uuml;mero de solicitud o proveedor. Este reporte
										  se puede generar en varios formatos,
										    aumentando as&iacute; su utilidad
										  y eficiencia en el traslado de datos. </p>
								    </div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="50%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center">
							<tr>
							  <td align="center" nowrap><div align="left"><strong>Del Proveedor:</strong>&nbsp; </div></td>
							  <td align="center" nowrap><cf_sifsociosnegocios2  sntiposocio="P" tabindex="1" sncodigo="SNcodigoI" snnumero="SNnumeroI" snnombre="SNnombreI" frame="frame1"></td>
							  <td align="center" nowrap><strong>Hasta:</strong>&nbsp;</td>
							  <td align="center" nowrap> <cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" sncodigo="SNcodigoF" snnumero="SNnumeroF" snnombre="SNnombreF" frame="frame2"></td>
						  </tr>
							<tr align="left">
							  <td width="50%" nowrap><div align="left"><strong>De la Fecha: </strong></div></td>
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="ECfechacotI" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></div></td>
							  <td nowrap><div align="left"><strong>Hasta:</strong>&nbsp;</div></td>
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="ECfechacotF" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></div></td>
						    </tr>
							<tr>
							  <td align="center" nowrap><div align="left"><strong>De la Orden: </strong></div></td>
							  <td align="center" nowrap><div align="left">
							    <input type="text" name="ECnumeroI"  id="ECnumeroI" size="10" maxlength="10" >
						      </div></td>
							  <td align="center" nowrap><strong>Hasta:</strong>&nbsp;</td>
							  <td align="center" nowrap><div align="left">
							    <input type="text" name="ECnumeroF"  id="ECnumeroF" size="10" maxlength="10" >
						      </div></td>
						  </tr>
							<tr align="left">
							  <td nowrap><div align="left"><strong>Formato:&nbsp;</strong>
                              </div></td>
                              <td nowrap><select name="formato">
                                <option value="fla">Flashpaper</option>
                                <option value="pdf">Adobe PDF</option>
                              
                              </select></td>
                              <td nowrap>&nbsp;</td>
                              <td nowrap>&nbsp;</td>
						  </tr>
							<tr>
							  <td align="center">&nbsp;</td>
							  <td align="center">&nbsp;</td>
							  <td align="center">&nbsp;</td>
							  <td align="center">&nbsp;</td>
						  </tr>
							<tr>
							  <td colspan="4" align="center"><input type="submit" value="Consultar" name="Reporte">
							    <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
								</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		</cfoutput>
			
			
		<cf_web_portlet_end>
	<cf_templatefooter>
