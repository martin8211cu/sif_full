<cf_templateheader title="Hist&oacute;rico de Reclamos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Hist&oacute;rico de Reclamos'>
		
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript1.2" type="text/JavaScript">
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
	
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function doConlisOCDesde() {
				var w = 800;
				var h = 500;
				var l = (screen.width-w)/2;
				var t = (screen.height-h)/2;
				popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraV2.cfm?EOidordenName=EOidordenDesde&EOnumeroName=EOnumeroDesde&ObservacionesName=ObservacionesDesde",l,t,w,h);
			}
			
			function traeOrdenDesde(value) {
				if (value!='') {
					document.getElementById("frD").src = '/cfmx/sif/cm/consultas/traerOrdenV2.cfm?EOidordenName=EOidordenDesde&EOnumeroName=EOnumeroDesde&ObservacionesName=ObservacionesDesde&EOnumero='+value;
				}
				else {
					document.form1.EOidorden.value = '';
				}
			}

			function doConlisOCHasta() {
				var w = 800;
				var h = 500;
				var l = (screen.width-w)/2;
				var t = (screen.height-h)/2;
				popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraV2.cfm?EOidordenName=EOidordenHasta&EOnumeroName=EOnumeroHasta&ObservacionesName=ObservacionesHasta",l,t,w,h);
			}

			function traeOrdenHasta(value) {
				if (value!='') {
					document.getElementById("frH").src = '/cfmx/sif/cm/consultas/traerOrdenV2.cfm?EOidordenName=EOidordenHasta&EOnumeroName=EOnumeroHasta&ObservacionesName=ObservacionesHasta&EOnumero='+value;
				}
				else {
					document.form1.EOidorden.value = '';
				}
			}
			
			function limpiar() {
				document.form1.SNcodigoI.value = "";
				document.form1.SNcodigoF.value = "";
				document.form1.EDRfecharecI.value = "";
				document.form1.EDRfecharecF.value = "";
				document.form1.EOidordenDesde.value = "";
				document.form1.EOidordenHasta.value = "";
				document.form1.EOnumeroDesde.value = "";
				document.form1.EOnumeroHasta.value = "";
				document.form1.ObservacionesDesde.value = "";
				document.form1.ObservacionesHasta.value = "";
				document.form1.SNnumeroI.value = "";
				document.form1.SNnumeroF.value = "";
				document.form1.SNnombreI.value = "";
				document.form1.SNnombreF.value = "";
			}
		</script>
		
		<cfoutput>
			<form method="post" name="form1" action="ReclamosHist-formV2.cfm"> 
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<!--- Linea No. Uno --->
					<tr>
						<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
					</tr>
					<!--- Linea No. Dos --->
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<!--- Linea No. Tres --->
					<tr>
						<td width="50%" valign="top" nowrap="nowrap">
							<table width="100%">
								<tr valign="top">
									<td valign="top" nowrap="nowrap">	
										<cf_web_portlet_start border="true" titulo="Consulta Hist&oacute;rica de Reclamos de Compras" skin="info1">
											<div align="justify">
											 	<p>
												En &eacute;ste reporte 
											  	se muestra la informaci&oacute;n Hist&oacute;rica de los reclamos hechos a las Ordenes de Compras, &eacute;sto  por
											  	proveedor, n&uacute;mero de Orden, fecha o Número Recepción (Factura).
											</div>
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>  
						</td>
						<td width="50%" valign="top">
							<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
								<!--- Linea No. 1 --->
								<tr>
									<td align="right" nowrap><div align="left"><strong>Del Proveedor:</strong>&nbsp; </div></td>
								  	<td align="left" nowrap><cf_sifsociosnegocios2  sntiposocio="P" tabindex="1" sncodigo="SNcodigoI" snnumero="SNnumeroI" snnombre="SNnombreI" frame="frame1"></td>
								  	<td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
								  	<td align="left" nowrap> <cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" sncodigo="SNcodigoF" snnumero="SNnumeroF" snnombre="SNnombreF" frame="frame2"></td>
							  	</tr>
								<!--- Linea No. 2 --->
								<tr align="left">
								  	<td width="50%" nowrap><div align="left"><strong>De la Fecha: </strong></div></td>
								  	<td width="50%" nowrap><div align="left"><cf_sifcalendario name="EDRfecharecI" value="" tabindex="1"></div></td>
								  	<td nowrap><div align="right"><strong>Hasta:</strong>&nbsp;</div></td>
								  	<td width="50%" nowrap><div align="left"><cf_sifcalendario name="EDRfecharecF" value="" tabindex="1"></div></td>
								</tr>
								<!--- Linea No. 3 --->
								<tr>
									<td class="fileLabel" align="left"><strong>Orden de Compra desde:&nbsp;</strong></td>
									<td nowrap="nowrap">
										<input type="hidden" name="EOidordenDesde" value="">
										<input type="text" name="EOnumeroDesde" id="EOnumeroDesde" value="" size="10" 
											onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onFocus="javascript:this.select();" 
											onChange="javascript: fm(this,0);" 
											onblur="javascript:traeOrdenDesde(this.value)" >
										<input type="text" name="ObservacionesDesde" id="ObservacionesDesde" value="" size="25" readonly>
										<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOCDesde();'></a>&nbsp;
									</td>
									<td class="fileLabel" align="right"><strong>Hasta:&nbsp;</strong></td>
									<td nowrap="nowrap">
										<input type="hidden" name="EOidordenHasta" value="">
										<input type="text" name="EOnumeroHasta" id="EOnumeroHasta" value="" size="10" 
											onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onFocus="javascript:this.select();" 
											onChange="javascript: fm(this,0);" 
											onblur="javascript:traeOrdenHasta(this.value)" >
										<input type="text" name="ObservacionesHasta" id="ObservacionesHasta" value="" size="25" readonly>
										<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOCHasta();'></a>
									</td>
								</tr>
								<!--- Linea No. 4 --->
								<tr>
									<td align="right" nowrap><strong>Del N&uacute;mero:&nbsp;</strong></td>
								  	<td align="left" nowrap>
										<input type="text" name="EDRnumeroD" size="20" maxlength="100" value="<cfif isdefined('form.EDRnumeroD')><cfoutput>#form.EDRnumeroD#</cfoutput></cfif>" onFocus='this.select();' >
								  	</td>
								  	<td align="right" nowrap><strong>Hasta:&nbsp;&nbsp;</strong> </td>
								  	<td align="left" nowrap>
										<input type="text" name="EDRnumeroH" size="20" maxlength="100" value="<cfif isdefined('form.EDRnumeroH')><cfoutput>#form.EDRnumeroH#</cfoutput></cfif>" onFocus='this.select();' >
								  	</td>
								  	<td align="center">&nbsp;</td>
								</tr>
								<!--- Linea No. 5 --->
								<tr>
								  	<td align="center">&nbsp;</td>
								  	<td align="center">&nbsp;</td>
								  	<td align="center">&nbsp;</td>
								  	<td align="center">&nbsp;</td>
							  	</tr>
								<!--- Linea No. 6 --->
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
			
		<iframe name="frD" id="frD" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>	
		<iframe name="frH" id="frH" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
	
	<cf_web_portlet_end>
<cf_templatefooter>
