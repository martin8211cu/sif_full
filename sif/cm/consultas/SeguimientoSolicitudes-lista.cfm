
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cf_templateheader title="Compras - Consulta Seguimiento de Solicitudes">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Seguimiento de Solicitudes'>
			
			<cfoutput>
			<form name="form1" method="post" action="SeguimientoSolicitudes-form.cfm" style="margin: 0" onSubmit="return Valida()">
				<table width="100%" align="center" border="0" cellspacing="2" cellpadding="2">						
				<input name="ESidsolicitud" type="hidden" value="">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Consulta Seguimiento de Solicitudes" skin="info1">
										<div align="justify">
											<p> 
											En este reporte se muestran las Ordenes de Compra, las Cotizaciones y las Facturas que pertencen a la solicitud seleccionada.</p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
					
					<td width="50%" valign="top">
						<table width="100%" cellpadding="2" cellspacing="4" align="center">
							<tr>
							<td width="21%" align="right" nowrap><strong>Solicitud N°:</strong>&nbsp;</td>						
							  <td nowrap width="1%">							
									<input name="ESnumero" type="text" value="" size="15" 
									onblur="javascript:traeSolicitud(this.value); fm(this,-1)"
									onFocus="javascript:this.value=qf(this); this.select();"  
									onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo N° Solicitud"><input name="ESobservacion" type="text" value="" size="60" readonly="" disabled>								
								</td>
								<td width="8%">		
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitudes" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOC();'></a>
								</td>
							</tr>																	
							<tr align="center">
								<td align="center" colspan="5">
									<input type="submit" name="btnConsultar"  value="Filtrar">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</form>
			</cfoutput>		
			
			<script language="JavaScript" type="text/javascript">	
				function Valida(){					
					if(document.form1.ESnumero.value == ''){
						alert("El campo  N°. Solicitud es requerido");
						return false;
					}
				}
			
				 var popUpWin2 = 0;
				 function popUpWindow2(URLStr, left, top, width, height){
				  if(popUpWin2){
				   if(!popUpWin2.closed) popUpWin2.close();
				  }
				  popUpWin2 = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				 }
				
				 function doConlisOC() {
				  popUpWindow2("/cfmx/sif/cm/consultas/ConlisSolicitudes.cfm",10,150,1000,450);
				 }
				 
				 function traeSolicitud(value){
				  if (value!=''){	   
				   document.getElementById("fr").src = 'traerSolicitud.cfm?ESnumero='+value;
				  }
				  else{
				   document.form1.ESidsolicitud.value = '';
				   document.form1.ESnumero.value = '';
				   document.form1.ESobservacion.value = '';
				  }
				 }	 
			</script>	
			<!--- Iframe que contiene el sql que trae los datos de la solicitud cuando se ha digitado No seleccionado un ESnumero --->
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="10" width="10" scrolling="auto" src="" ></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>