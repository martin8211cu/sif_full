<table width="980" border="0" align="center" cellpadding="0" cellspacing="0" class="iconoTop">
  <!--DWLayoutTable-->
  <tr>
    <td colspan="9" valign="top"><img src="/cfmx/plantillas/soinasp01/images/spacer.gif" alt="MiGestion.net" width="163" height="25"></td>
  </tr>
  <tr>
    <td width="438" valign="top"><img src="/cfmx/plantillas/soinasp01/images/spacer.gif" alt="MiGestion.net" width="163" height="25" /></td>
    <td width="250" align="right" valign="top" class="iconoUsuario"><!--DWLayoutEmptyCell-->&nbsp;</td>
    <td width="56">&nbsp;</td>
    <td width="86" align="center" class="iconoPreferencias"><a href="/cfmx/home/menu/micuenta/"><img src="/cfmx/plantillas/soinasp01/images/Preferences.gif" alt="Preferences" width="27" height="21" border="0"></a></td>
    <td width="14" align="center">&nbsp;</td>
    <td width="45" align="center" class="iconoPreferencias"><a href="javascript:helpWindow()"><img src="/cfmx/plantillas/soinasp01/images/Help.gif" alt="Help" width="27" height="21" border="0"></a></td>
    <td width="14" align="center">&nbsp;</td>
    <td width="44" align="center" class="iconoPreferencias" ><a href="/cfmx/home/public/logout.cfm"><img src="/cfmx/plantillas/soinasp01/images/Logout.gif" alt="Logout" width="27" height="21" border="0"></a></td>
    <td width="33">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top"><img src="/cfmx/plantillas/soinasp01/images/spacer.gif" alt="MiGestion.net" width="163" height="20" /></td>
    <td align="right" valign="top" class="iconoUsuario"><cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
      <cfoutput>#HTMLEditFormat(session.datos_personales.nombre)# #HTMLEditFormat(session.datos_personales.apellido1)# #HTMLEditFormat(session.datos_personales.apellido2)#</cfoutput>
    </cfif></td>
    <td>&nbsp;</td>
    <td align="center" class="iconoPreferencias"><a href="/cfmx/home/menu/micuenta/">Preferencias</a></td>
    <td align="center">&nbsp;</td>
    <td align="center" class="iconoPreferencias"><a href="javascript:helpWindow()">Ayuda</a></td>
    <td align="center">&nbsp;</td>
    <td align="center" class="iconoPreferencias"><a href="/cfmx/home/public/logout.cfm">Salir</a></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="9" valign="top"><img src="/cfmx/plantillas/soinasp01/images/spacer.gif" alt="MiGestion.net" width="163" height="5" /></td>
  </tr>
  
</table>
<script type="text/javascript">
	var popUpWinAyuda=null;
	function helpWindow()
	{
		  var width = 800, height = 700, left = 200, top = 0;
		  if(popUpWinAyuda)
		  {
			if(!popUpWinAyuda.closed) popUpWinAyuda.close();
		  }
		  popUpWinAyuda = window.open('/cfmx/saci/ayuda/', 'popUpWinAyuda', 
				'toolbar=no,location=no,directories=no,status=no,menubar=no,copyhistory=yes,width='+
				width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
		  if (!popUpWinAyuda && !document.popupblockerwarning) {
			alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
			document.popupblockerwarning = 1;
		  }
	}
</script>