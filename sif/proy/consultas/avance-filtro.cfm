<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Consulta de Avance de Proyectos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<script  type="text/javascript" language="javascript1.2">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisProyecto() {
		var f = document.form1;
		popUpWindow("ConlisProyectos.cfm?formulario=form1&id=PRJid&codigo=PRJcodigo&desc=PRJdescripcion",250,200,650,400);
	}

	//Obtiene la descripción con base al código
	function TraeProyecto(dato) {
		var params ="";
		params = "&formulario=form1&id=PRJid&codigo=PRJcodigo&desc=PRJdescripcion";
		if (dato != "") {
			document.getElementById("fr").src="/cfmx/sif/proy/consultas/proyectoquery.cfm?dato="+dato+"&form=form1"+params;
		}
		else{
			document.form1.PRJid.value = "";
			document.form1.PRJcodigo.value = "";
			document.form1.PRJdescripcion.value = "";
		}
		return;
	}

	function validar(){
		if ( document.form1.PRJid.value == '' ){
			alert('Debe seleccionar un proyecto para generar la consulta.');
			return false;
		}
		return true;
	}	
		
</script>

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
					  <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Avance de Proyectos'>
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								  <td>
									  <cfinclude template="../../portlets/pNavegacion.cfm">
								  </td>
							  </tr>
					
							  <tr> 
								  <td valign="top"> 
									  <form name="form1" method="post" action="consAvance.cfm" onSubmit="return validar();">
									  	<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr><td width="1%">&nbsp;</td></tr>
											<tr>
												<td>&nbsp;</td>
												<td width="30%" align="center">
													<cf_web_portlet border="true" skin="info1" tituloalign="center" titulo='Consulta de Avance de Proyectos'>
													<table width="100%" >
														<tr><td>Muestra para un proyecto previamente seleccionado, el monto presupuestado y el monto proyectado de acuerdo a las actividades que lo conforman.</td></tr>
													</table>
													</cf_web_portlet>
												</td>
												<td align="right" width="10%" valign="top">Proyecto:&nbsp;</td>
												<td width="40%" nowrap valign="top">
													<input 	name="PRJcodigo" type="text" onFocus="this.select();"  value="" size="15" maxlength="15" onblur="javascript:TraeProyecto(this.value);" >
													<input 	name="PRJdescripcion" type="text"  value="" size="50" maxlength="50" readonly >
													<img id="imgArticulo" src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisProyecto();">
													<input name="PRJid" type="hidden" value=""> 
												</td>
												<td valign="top"><input type="submit" name="Reporte" value="Reporte"></td>
											</tr>
										</table>
									  </form>
								  </td>
							  </tr>
						  </table>
					  </cf_web_portlet>	
				</td>	
			</tr>
		</table>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" src="" ></iframe>
	</cf_templatearea>
</cf_template>