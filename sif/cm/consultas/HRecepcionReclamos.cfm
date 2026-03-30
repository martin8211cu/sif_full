<cf_templateheader title="Hist&oacute;rico de Recepci&oacute;n / Reclamos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Hist&oacute;rico de Recepci&oacute;n y Reclamos'>
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

			function doConlisOC() {
				var w = 800;
				var h = 500;
				var l = (screen.width-w)/2;
				var t = (screen.height-h)/2;
				popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompra.cfm",l,t,w,h);
			}

			function traeOrden(value) {
				if (value!='') {
					document.getElementById("fr").src = '/cfmx/sif/cm/consultas/traerOrden.cfm?EOnumero='+value;
				}
				else {
					document.form1.EOidorden.value = '';
				}
			}
		
		</script>
		
		<cfoutput>
		<form method="post" name="form1" action="HRecepcionReclamos-form.cfm"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Hist&oacute;rico de Recepci&oacute;n y Reclamos" skin="info1">
										<div align="justify">
										  En &eacute;ste reporte se muestra la informaci&oacute;n Hist&oacute;rica de una Orden de Compra con los datos de recepciones y reclamos asociados.
								    	</div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="50%" valign="top">
						<table width="100%" cellpadding="2" cellspacing="0" align="center">
							<tr>
								<td class="fileLabel">Orden de Compra:</td>
								<td>
									<input type="hidden" name="EOidorden" value="">
									<input type="text" name="EOnumero" id="EOnumero" value="" size="10" 
											onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onFocus="javascript:this.select();" 
											onChange="javascript: fm(this,0);" 
											onblur="javascript:traeOrden(this.value)" >
									<input type="text" name="Observaciones" id="Observaciones" value="" size="40" readonly>
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOC();'></a>
								</td>
						  	</tr>
							<tr>
							  <td colspan="2" align="center">
							  	<input type="submit" value="Consultar" name="Reporte" id="Reporte">
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
		
			objForm.EOnumero.required = true;
			objForm.EOnumero.description="Orden de Compra";
		
		</script>
		
		<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>

