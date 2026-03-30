
    
<cf_templateheader title="Reporte de Seguimiento de Ordenes de Compra en T&aacute;nsito">
<cf_templatecss>
    <cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Reporte de Seguimiento de Ordenes de Compra en T&aacute;nsito">
    <cfinclude template="../../portlets/pNavegacion.cfm">
        <cfoutput>
            <form method="post" name="form1" action="rpSegOrdenesTransito-form.cfm">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Reporte de Seguimiento de &Oacute;rdenes de Compra en Tr&aacute;nsito" skin="info1">
										<div align="justify">
											<p> 
											Este reporte muestra el seguimiento de las &Oacute;rdenes de Compra que se encuentran en Tr&aacute;nsito</p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
                        <td width="50%" align="top">
                            <table width="100%"  border="0" cellspacing="2" cellpadding="0" align="center">
                                <tr>
                                    <td width="19%" align="right" nowrap><strong>Del Comprador:</strong>&nbsp;</td>
                                    <td nowrap colspan="3">
                                        &nbsp;<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(1,this.value);" >
                                        <input type="text" name="CMCnombre1" id="CMCnombre1" tabindex="1" readonly value="" size="40" maxlength="80">
                                        <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores1();'></a>
                                        <input type="hidden" name="CMCid1" value="" >
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
                                    <td nowrap colspan="3">
                                        &nbsp;<input type="text" name="CMCcodigo2" maxlength="10" value="" size="10" onBlur="javascript:comprador(2,this.value);" >
                                        <input type="text" name="CMCnombre2" id="CMCnombre2" tabindex="1" readonly value="" size="40" maxlength="80">
                                        <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores2();'></a>
                                        <input type="hidden" name="CMCid2" value="" >
                                    </td>
                                </tr>
                               <tr>
								<td align="right" nowrap><strong>&Oacute;rden de Compra Inicial:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									&nbsp;<input type="text" name="NumeroOC1" maxlength="10" value="" size="10" onBlur="javascript:existeOrden(1,this.value);" >									
                                    <input type="text" name="ObservacionOC1" id="ObservacionOC1" tabindex="1" readonly value="" size="40" maxlength="80">
									<input type="hidden" name="IDOC1" value="" >
								</td>
							</tr>
						
							<tr>
								<td align="right" nowrap><strong>&Oacute;rden de Compra Final:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									&nbsp;<input type="text" name="NumeroOC2" maxlength="10" value="" size="10" onBlur="javascript:existeOrden(2,this.value);" >									
                                    <input type="text" name="ObservacionOC2" id="ObservacionOC2" tabindex="1" readonly value="" size="40" maxlength="80">
									<input type="hidden" name="IDOC2" value="" >
								</td>
							</tr>
                            <!--- <tr align="left">
                                <td nowrap align="right"><strong>De la Fecha:</strong>&nbsp;</td>
                                <td colspan="3" nowrap><cf_sifcalendario name="FechaInicial" value="" tabindex="1"></td>
						    </tr>
                            <tr align="left">
								<td  nowrap align="right"><strong>Hasta:</strong>&nbsp;</td>
								<td nowrap colspan="3"><cf_sifcalendario name="FechaFinal" value="" tabindex="1"></td>
						    </tr> --->
                                <tr>
                                    <td colspan="3" align="center">
                                    	<input type="submit" value="Generar" name="Reporte" class="btnNormal">
										<input type="reset" value="Limpiar" name="reset" class="btnNormal">
                                     </td>
                                </tr>
                                <tr><td colspan="3" align="center">&nbsp;</td></tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </form>
			<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
        </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	
	var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
	
	function existeOrden(opcion, value){
		
		var _form = document.form1;
		
		if (!/^([0-9])*$/.test(value)){
			alert("El valor insertado " + value + " no es un número")
		}
		else{
			if ( value !='' ){
				document.getElementById("frComprador").src = "OrdenesConsulta.cfm?NumeroOC=" + value + "&opcion=" + opcion + "&Empresas=" + <cfoutput>#session.Ecodigo#</cfoutput>;
			}
		}
	}
	
	function comprador(opcion, value){
		if ( value !='' ){
			document.getElementById("frComprador").src = "CompradoresConsulta.cfm?CMCcodigo="+value+"&opcion="+opcion+"&Ecodigo=-1";
		}
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
</script>