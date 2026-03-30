<cf_templateheader title="Hist&oacute;rico de Reclamos (Seguimiento)">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Hist&oacute;rico de Reclamos'>
		<script language="JavaScript" type="text/javascript">
			function limpiar() {
				document.form1.SNcodigoI.value = "";
				document.form1.SNcodigoF.value = "";
				document.form1.EDRfecharecI.value = "";
				document.form1.EDRfecharecF.value = "";
				document.form1.EOidordenI.value = "";
				document.form1.EOidordenF.value = "";
				document.form1.SNnumeroI.value = "";
				document.form1.SNnumeroF.value = "";
				document.form1.SNnombreI.value = "";
				document.form1.SNnombreF.value = "";
			
			}
		</script>
		
			<cfoutput>
		<form method="post" name="form1" action="ReclamosHist-form.cfm"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Consulta Hist&oacute;rica de Reclamos de Compras" skin="info1">
										<div align="justify">
										  <p>En &eacute;ste reporte 
										  se muestra la informaci&oacute;n Hist&oacute;rica de los reclamos hechos a las Ordenes de Compras, &eacute;sto  por
										  proveedor, n&uacute;mero de Orden o fecha.
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
							  <!---<td width="50%" nowrap><div align="left"><cf_sifcalendario name="EDRfecharecI" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></div></td>--->
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="EDRfecharecI" value="" tabindex="1"></div></td>
							  <td nowrap><div align="left"><strong>Hasta:</strong>&nbsp;</div></td>
							  <!---<td width="50%" nowrap><div align="left"><cf_sifcalendario name="EDRfecharecF" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></div></td>--->
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="EDRfecharecF" value="" tabindex="1"></div></td>
						    </tr>
							<!---<tr>
							  <td align="center" nowrap><div align="left"><strong>De la Orden: </strong></div></td>
							  <td align="center" nowrap><div align="left">
							    <input type="text" name="EOidordenI"  id="EOidordenI" size="10" maxlength="10" >
						      </div></td>
							  <td align="center" nowrap><strong>Hasta:</strong>&nbsp;</td>
							  <td align="center" nowrap><div align="left">
							    <input type="text" name="EOidordenF"  id="EOidordenF" size="10" maxlength="10" >
						      </div></td>
						  </tr>--->
							<tr>
							  <td align="center">&nbsp;</td>
							  <td align="center">&nbsp;</td>
							  <td align="center">&nbsp;</td>
							  <td align="center">&nbsp;</td>
						  </tr>
							<tr>
							  <td colspan="4" align="center">
							  	<input type="submit" value="Consultar" name="Reporte" id="Reporte">
							    <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
							</td>
								</tr>
						</table>
					</td>
				</tr>
			</table>
		 </form>
		 </cfoutput>	
		 <!--- <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
			 <tr>
				<td>
					<cfif isdefined("form.Reporte")>
						<cfinclude template="ReclamosHistLista.cfm">
					</cfif>
				</td>
			</tr>
		</table> --->
			
						
		<cf_web_portlet_end>
	<cf_templatefooter>

