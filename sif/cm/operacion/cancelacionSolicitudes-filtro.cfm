<cfif isdefined("url.fESnumero") and len(url.fESnumero) and not isdefined("form.fESnumero")>
	<cfset form.fESnumero = url.fESnumero>
</cfif>
<cfif isdefined("url.fESobservacion") and len(url.fESobservacion) and not isdefined("form.fESobservacion")>
	<cfset form.fESobservacion = url.fESobservacion>
</cfif>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfoutput>
	<form action="#GetFileFromPath(GetTemplatePath())#" name="fsolicitud" method="post" style="margin: 0">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
			<tr> 
				<td class="fileLabel" nowrap width="1%" align="right">N&uacute;mero Solicitud:</td>	
				<td nowrap width="1%">				
					<input type="text" name="fESnumero" id="fESnumero" value="<cfif isDefined("form.fESnumero")>#form.fESnumero#</cfif>" size="11" maxlength="10" tabindex="-1" onblur="javascript:traerCancelacionSolicitudes(this.value);">
					<input type="text" name="fESobservacion" id="fESobservacion" value="<cfif isDefined("form.fESobservacion")>#form.fESobservacion#</cfif>" size="60" readonly>
					<a href="##" tabindex="-1">
					<img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCancelacionSolicitud();">
					</a>        											
				</td>
				<td align="right" colspan="2">
					<input type="submit" name="btnFiltro" value="Filtrar">&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) {
				popUpWin.close();
			}
	  	}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	//Funcion del conlis de tipos de solicitud
	function doConlisCancelacionSolicitud() {
		<cfoutput>
		<cfif isdefined("LvarEsAdmin") and LvarEsAdmin gt 0>
			popUpWindow("conlisCancelacionSolicitudes.cfm?formulario=fsolicitud&admin="+#LvarEsAdmin#,200,200,950,400);
		<cfelse>
			popUpWindow("conlisCancelacionSolicitudes.cfm?formulario=fsolicitud",200,200,950,400);
		</cfif>	
		</cfoutput>
	}
	
	//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerCancelacionSolicitudes(value) {
		if (value!='') {
			document.getElementById("fr").src = 'traerCancelacionSolicitudes.cfm?formulario=fsolicitud&fESnumero='+value;
		}
		else {
			document.fsolicitud.fESnumero.value = '';
			document.fsolicitud.fESobservacion.value = '';
		}
	}	
</script>