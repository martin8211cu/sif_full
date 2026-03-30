<cfinclude template="tpid.cfm">
<cfif #tramite.Avance# NEQ '5'><cflocation url="index.cfm?TPID=#TPID#"></cfif>
<html><!-- InstanceBegin template="/Templates/Tramites.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<!-- InstanceEndEditable -->
<cf_templatecss>
<cf_templatecss>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<cf_templatecss>
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="middle"><img src="/cfmx/sif/Imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="top" style="padding-left: 5; padding-bottom: 5;">
	
	<cfinclude template="../portlets/pubica.cfm">  
	
	  </td>
  </tr>
  <tr> 
    <td valign="top">
	 
        
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  <!--- [ Empresas iba aqui ] --->
		  </td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Tr&aacute;mite 
              de Pasaporte</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <!-- InstanceBeginEditable name="Menu" --><cfinclude template="jsTramites.cfm" ><!-- InstanceEndEditable --></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      	
	
		</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="84" align="left" valign="top" nowrap>
	  </td>
    <td width="661" height="1" align="left" valign="top">
	   
      </td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap>  
       
	  <cfinclude template="/sif/menu.cfm">
	  </td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="/cfmx/sif/Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Tr&aacute;mite 
            de Pasaporte<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="/cfmx/sif/Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">

<!-- InstanceBeginEditable name="Contenido" -->
		  <form name="form1" action="trpass05-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="3%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td colspan="5">
				  </td>
                  <td width="3%">&nbsp;</td>
                  <td width="8%">&nbsp;</td>
                  <td width="11%">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      5 de 5:</font></strong> <span class="subTitulo">Fin del 
                      Proceso </span></p></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td width="18%">&nbsp;</td>
                  <td width="19%" colspan="-1">&nbsp;</td>
                  <td width="4%" colspan="-1">&nbsp;</td>
                  <td width="0%" colspan="-1">&nbsp;</td>
                  <td width="34%" colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7"><div align="justify">Usted ha realizado satisfactoriamente 
                      el pago de su tr&aacute;mite de pasaporte.<br><br>A continuaci&oacute;n 
                      le indicamos el c&oacute;digo de autorizaci&oacute;n as&iacute; 
                      como los pasos a seguir para la entrega de su pasaporte:</div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="4"><table width="95%" border="0">
                      <tr> 
                        <td width="5%">&nbsp;</td>
                        <td width="41%" nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fecha:</strong></font></div></td>
                        <td width="35%" nowrap><font size="2"><cfoutput>#tramite.FechaFin#</cfoutput></font></td>
                        <td width="19%" nowrap>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><strong><font size="2">N&uacute;mero 
                            de Confirmaci&oacute;n:</font></strong></div></td>
                        <td nowrap><font size="2"><cfoutput>#tramite.TPID#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>N&uacute;mero 
                            de Transferencia:</strong></font></div></td>
                        <td nowrap><font size="2"><cfoutput>#Replace( tramite.TIcodigo,"00","","all")#
						#Replace (tramite.TIsrvrtid, "00", "","all")#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Importe 
                            pagado: </strong></font></div></td>
                        <td nowrap><font size="2">
						<cfoutput>#LSCurrencyFormat(tramite.Importe)# #tramite.Miso4217#</cfoutput> </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tr&aacute;mite:</strong></font></div></td>
                        <td nowrap><font color="#006699" size="2"><cfoutput>#tramite.AccionNombre#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2" nowrap><div align="center"> 
                            <input type="button" name="Submit" value="Imprimir" onclick="javascript:window.print();">
                            <input type="submit" name="Finalizar" value="Finalizar">
                          </div></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"><div align="justify"></div></td>
                        <td>&nbsp;</td>
                      </tr>
                    </table></td>
                  <td colspan="4" valign="top"><div align="justify"></div></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7"><div align="justify"><font size="2">Por favor, 
                      <strong>imprima</strong> esta confirmaci&oacute;n y dir&iacute;jase 
                      a la Direcci&oacute;n General de Migraci&oacute;n y Extranjer&iacute;a, 
                      a la ventanilla de Tr&aacute;mites en L&iacute;nea para 
                      tomar su fotograf&iacute;a y hacerle entrega del pasaporte. 
                      Este tr&aacute;mite es personal y debe presentarse con su 
                      c&eacute;dula de identidad vigente y en buen estado.</font></div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7"><strong>Nota:</strong> En caso de reportar una 
                    p&eacute;rdida de pasaporte, le recordamos que debe debe reportarlo 
                    y presentar la denuncia ante el Ministerio P&uacute;blico, 
                    trayendo la copia correspondiente para finalizar el tr&aacute;mite.</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
            </form>
            <!-- InstanceEndEditable -->
</td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
