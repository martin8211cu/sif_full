<cf_templateheader title="&Oacute;rdenes de Compra por Proveedor">
		<cf_web_portlet_start titulo="Ordenes Compra Locales por Proveedor">

			<form name="form1" method="get" action="OCLocalProveedor-rep.cfm" >		
				<table width="97%" align="center" border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
					</tr>
					<tr>
						<td width="50%" valign="top">
							<table width="100%">
								<tr>
									<td valign="top"> 
										<cf_web_portlet_start border="true" titulo="&Oacute;rdenes de Compra por Proveedor" skin="info1">
											<div align="justify">
												<p>En este reporte se muestran las órdenes de compra locales ordenadas por proveedor en el rango de fechas y/o de proveedores especificados por el usuario</p>
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
									<td nowrap>
										<cf_sifsociosnegocios2 sntiposocio="P" sncodigo="codigo1" snnumero="numero1" snnombre="nombre1" frame="frame1">
									</td>
									<td align="right" nowrap><strong>&nbsp;Hasta:</strong>&nbsp;</td>
									<td nowrap>
										<cf_sifsociosnegocios2 sntiposocio="P" sncodigo="codigo2" snnumero="numero2" snnombre="nombre2" frame="frame2">
									</td>
								</tr>
					
								<tr>
									<td align="right" nowrap><strong>De la Fecha:</strong>&nbsp;</td>
									<td nowrap>
										<cfif isdefined("Form.fdesde")><cfset fecha = Form.fdesde><cfelse><cfset fecha = ""></cfif>
										<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="fdesde"> 
									</td>
									<td align="right" nowrap><strong>&nbsp;Hasta:</strong>&nbsp;</td>
									<td nowrap>
										<cfif isdefined("Form.fhasta")><cfset fecha = Form.fhasta><cfelse><cfset fecha = ""></cfif>
										<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="fhasta"> 
									</td>
								</tr>

								<tr>
									<td align="right" nowrap><strong>&nbsp;Formato:</strong>&nbsp;</td>
							  		<td colspan="3" nowrap>
                                    	<select name="formato">
                                      		<option value="flashpaper">Flashpaper</option>
                                      		<option value="pdf">Adobe PDF</option>
                                    	</select>
                              		</td>
                          		</tr>
					
								<tr><td nowrap colspan="4">&nbsp;</td></tr>
					
								<tr>
									<td align="center" colspan="4">
										<input type="submit" name="Reporte" value="Generar">
										<input type="reset" name="Limpiar" value="Limpiar" >
									</td>
								</tr>
							</table>
						</td>
					</tr>				
				</table>
			</form>
			
		<cf_web_portlet_end>
	<cf_templatefooter>
