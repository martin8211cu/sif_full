<cf_templateheader title="	Reasignaci&oacute;n de Solicitudes de Compra">
		<cf_web_portlet_start titulo="Reasignaci&oacute;n de Solicitudes de Compra">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
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
			
			function limpiar() {
				document.form1.CMCcodigo1.value = "";
				document.form1.CMCcodigo2.value = "";
				document.form1.CMCnombre1.value = "";
				document.form1.CMCnombre2.value = "";
				document.form1.fdesde.value = "";
				document.form1.fhasta.value = "";
			}
			
			function comprador(opcion, value){
				if ( value !='' ){
					document.getElementById("frComprador").src = "CompradoresConsulta.cfm?CMCcodigo="+value+"&opcion="+opcion;
				}
			}
			
		</script>	

		<form name="form1" method="post" action="ReasignacionSolicitudes-form.cfm" style="margin: 0;">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td width="50%" valign="top">
				  <table width="100%" cellpadding="2" cellspacing="0">
					<tr>
					  <td valign="top"> 
					  <cf_web_portlet_start border="true" titulo="Reasignaci&oacute;n de Solicitudes de Compra" skin="info1">
						<div align="justify">
						  <p>Este reporte muestra todas las Solicitudes de Compra reasignadas en el rango de fechas que usted especifique.</p>
						</div>
					  <cf_web_portlet_end></td>
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
                  <tr>
                    <td align="right" nowrap><strong>De la Fecha:</strong>&nbsp;</td>
                    <td nowrap colspan="3">
                      <cfif isdefined("Form.fdesde")>
                        <cfset fecha = Form.fdesde>
                        <cfelse>
                        <cfset fecha = "">
                      </cfif>
                      <cf_sifcalendario form="form1" value="#fecha#" name="fdesde"> </td>
                  </tr>
                  <tr>
                    <td nowrap align="right"><strong>Hasta:</strong>&nbsp;</td>
                    <td nowrap colspan="3">
                      <cfif isdefined("Form.fhasta")>
                        <cfset fecha = Form.fhasta>
                        <cfelse>
                        <cfset fecha = "">
                      </cfif>
                      <cf_sifcalendario form="form1" value="#fecha#" name="fhasta"> </td>
                  </tr>
                  <tr>
                    <td nowrap colspan="4">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="center" colspan="4">
                      <input type="submit" name="Reporte" value="Consultar">
					  <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
                    </td>
                  </tr>
                  <tr>
                    <td align="center" colspan="4">&nbsp;</td>
                  </tr>
                </table>
				</td>
			  </tr>
			</table>
		</form>
		<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>
