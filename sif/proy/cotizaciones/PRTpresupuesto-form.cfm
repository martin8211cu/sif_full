<script  type="text/javascript" language="javascript1.2">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisObras() {
		var f = document.form1;
		popUpWindow("ConlisObras.cfm?formulario=form1&id=PRJPOid&codigo=PRJPOcodigo&desc=PRJPOdescripcion",250,200,650,400);	   
	}

	//Obtiene la descripciÃ³n con base al cÃ³digo
	function TraeObra(dato) {
		var params ="";
		params = "&formulario=form1&id=PRJPOid&codigo=PRJPOcodigo&desc=PRJPOdescripcion";		
		if (dato != "") {
			document.getElementById("fr").src="/cfmx/sif/proy/cotizaciones/Obraquery.cfm?dato="+dato+params;
		}
		else{
			document.form1.PRJPOid.value = "";
			document.form1.PRJPOcodigo.value = "";
			document.form1.PRJPOdescripcion.value = "";
		}
		return;
	}

	function validar(){
		if ( document.form1.PRJPOid.value == '' ){
			alert('Debe seleccionar una obra para generar la consulta.');
			return false;
		}
		return true;
	}	
		
</script>

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">					 
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">				
							  <tr> 
								  <td valign="top"> 
									  <form name="form1" method="post" action="consPresup.cfm" onSubmit="return validar();">
									  	<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr><td width="1%">&nbsp;</td></tr>
											<tr>
												<td>&nbsp;</td>
												<td width="30%" align="center">
													<cf_web_portlet border="true" skin="info1" tituloalign="center" titulo='Consulta de AnÃ¡lisis de Proyectos'>
													<table width="100%" >
														<tr><td>Este reporte premite hacer un anÃ¡lisis de presupuesto de acuerdo a los productos por obra.</td></tr>
													</table>
													</cf_web_portlet>
												</td>
												<td align="right" width="10%" valign="top">Obra:&nbsp;</td>
												<td width="40%" nowrap valign="top">
													<input 	name="PRJPOcodigo" type="text" onFocus="this.select();"  value="" size="15" maxlength="15" onblur="javascript:TraeObra(this.value);" >
													<input 	name="PRJPOdescripcion" type="text"  value="" size="50" maxlength="50" readonly >
													<img id="imgArticulo" src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisObras();">
													<input name="PRJPOid" type="hidden" value=""> 
												</td>
												<td valign="top"><input type="submit" name="Reporte" value="Reporte"></td>
											</tr>
										</table>
									  </form>
								  </td>
							  </tr>
						  </table>
				</td>	
			</tr>
		</table>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="1" height="120" width="0" scrolling="auto" src="" ></iframe>
