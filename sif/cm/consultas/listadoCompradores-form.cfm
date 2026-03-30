<form action="listadoCompradores-sql.cfm" method="get" name="form1">
    <table border="0" align="center">
        <tr>
            <td>Código:</td>
            <td><input type="text" name="Codigo"/></td>
            <td>&nbsp;</td>
            <td>Centro Funcional:</td>
            <td><cf_rhcfuncional></td>
        </tr>
        <tr>
            <td>Nombre:</td>
            <td><input type="text" name="Nombre"/></td>
            <td>&nbsp;</td>
            <td>Estatus:</td>
            <td>
                <select name="Estatus">
                    <option value="">-Todos-</option>
                    <option value="1">Activo</option>
                    <option value="0">Inactivo</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Tipo Solicitud:</td>
            <td>
            	<input name="CMTScodigo" type="text" id="CMTScodigo" size="5" maxlength="5" tabindex="-1" onblur="javascript:traerTSolicitud(this.value,1);">
        		<input name="CMTSdescripcion" type="text" id="CMTSdescripcion" value="" size="40">
				<a href="##" tabindex="-1">
						<img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisSolicitudes();">
				</a>        	
            </td>
            <td>&nbsp;</td>
            <td>Formato:</td>
            <td>
                <select name="Formato">
                    <option value="FlashPaper">FlashPaper</option>
                    <option value="HTML">HTML</option>
                    <option value="Excel">Excel</option>
                    <option value="RTF">RTF</option>
                </select>
             </td>
            </tr>
        <tr>
            <td colspan="5" align="center">
            	<input type="submit" name="Consultar" value="Consultar" class="btnFiltrar" />
            </td>
        </tr>
    </table>
</form>
<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<script language="javascript" type="text/javascript">
//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerTSolicitud(value){
			  if (value!=''){	   
			   document.getElementById("fr").src = '/cfmx/sif/cm/catalogos/traerTSolicitud.cfm?CMTScodigo='+value;
			  }
			  else{
			   document.form1.CMTScodigo.value = '';
			   document.form1.CMTSdescripcion.value = '';
			  }
	 }	
	 //Funcion del conlis de tipos de solicitud
	function doConlisSolicitudes() {
		popUpWindow("/cfmx/sif/cm/catalogos/conlisSolicitudes.cfm?form=form1",250,150,550,400);
	}
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) {
				popUpWin.close();
			}
	  	}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
</script>