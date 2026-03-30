<cf_templateheader title="Compras - Consulta de los Datos por Comprador por Rango">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Datos por Comprador por Rango'>

		<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
		
			function doConlisCompradores1() {
				var params = "";
					params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function doConlisCompradores2() {
				var params = "";
					params = "?formulario=form1&CMCid=CMCid2&CMCcodigo=CMCcodigo2&desc=CMCnombre2";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function comprador(opcion, value){
				if ( value !='' ){
					document.getElementById("frComprador").src = "CompradoresConsulta.cfm?CMCcodigo="+value+"&opcion="+opcion;
				}
			}
			
			function doConlis(CMCcodigo1, CMCcodigo2) {
				var params  = "";
					params += "CMCcodigo1=" + CMCcodigo1 + "&CMCcodigo2=" + CMCcodigo2
				popUpWindow("/cfmx/sif/cm/consultas/DatosCompradorRango-Imprime.cfm?"+params,10,10,1000,550);
			}

		</script>	

		<form name="form1" method="post" action="DatosCompradorRango.cfm">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Consulta de Datos por Comprador por Rango" skin="info1">
										<div align="justify">
											<p> 
											&Eacute;ste reporte muestran los datos asociados del comprador, donde se puede filtrar por un comprador, por un rango de compradores o todos los compradores que tenga la  empresa. </p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
					
					<td width="50%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td align="right" nowrap><strong>Del Comprador:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(1,this.value);" >
									<input type="text" name="CMCnombre1" id="CMCnombre1" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores1();'></a>
									<input type="hidden" name="CMCid1" value="" >
								</td>
							</tr>
						
							<tr>
								<td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="CMCcodigo2" maxlength="10" value="" size="10" onBlur="javascript:comprador(2,this.value);" >
									<input type="text" name="CMCnombre2" id="CMCnombre2" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores2();'></a>
									<input type="hidden" name="CMCid2" value="" >
								</td>
							</tr>
					
							<tr><td nowrap colspan="4">&nbsp;</td></tr>
					
							<tr>
								<td align="center" colspan="4">
									<input type="button" name="Reporte" value="Consultar" onClick="javascript: doConlis(document.form1.CMCcodigo1.value, document.form1.CMCcodigo2.value); ">
									<input type="reset" name="Limpiar" value="Limpiar">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
		
		<cf_web_portlet_end>
	<cf_templatefooter>


