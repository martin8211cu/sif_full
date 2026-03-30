<cfinclude template="tpid.cfm">
<cfif #tramite.Avance# NEQ '2'><cflocation url="index.cfm?TPID=#TPID#"></cfif>
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
		  <form name="form1" action="trpass02-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="6%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td colspan="5">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      2 de 5:</font></strong> <span class="subTitulo">Estado actual 
                      de su pasaporte</span></p></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td width="45%">&nbsp;</td>
                  <td width="16%" colspan="-1">&nbsp;</td>
                  <td width="2%" colspan="-1">&nbsp;</td>
                  <td width="2%" colspan="-1">&nbsp;</td>
                  <td width="10%" colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7">Acorde con la DGME la solicitud de pasaporte 
                    para la c&eacute;dula <font color="#006699"><strong> 
					  <cfoutput>#tramite.Cedula#</cfoutput> 
                    </strong></font>
					<cfif #Len(Trim(tramite.Pnombre))# NEQ 0> 
						perteneciente a <cfoutput>#tramite.Pnombre#</cfoutput></cfif>
					<br>se encuentra en estado <strong><font color="#9999CC">
					<cfoutput>#tramite.EstadoNombre#</cfoutput></font></strong>.<br>
                    <br>
                    Le recordamos que es caso de extrav&iacute;o debe reportarlo 
                    y presentar la denuncia ante el Ministerio P&uacute;blico.</td>
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
                  <td colspan="5"><strong>Usted puede:</strong></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
				<cfquery datasource="sdc" name="accion">
					select a.Accion,a.AccionNombre
					from TramitePasaporte t, TramitePasaporteAccion a
					where t.TPID = #TPID#
					  and (t.Pestado = 'N' and a.Accion = 'N'
					   or  t.Pestado = 'E' and a.Accion = 'E'
					   or  t.Pestado = 'R' and a.Accion = 'R'
					   or  t.Pestado in ('R', 'V') and a.Accion = 'P')
				</cfquery>
				
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="4"><table width="100%" border="0">
                    <cfoutput query="accion"> 
                      <tr> 
                        <td width="11%">&nbsp;</td>
                        <td width="89%" colspan="3">
						<label> 
                          <input name="accion" type="radio" value="#Accion#" checked>
                          #AccionNombre#</label>
						  </td>
                      </tr>
                    </cfoutput>
                      <tr> 
                        <td>&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td nowrap><input type="submit" value="Continuar">
                          <input type="button" name="Regresar" value="Regresar" onclick="history.back();"></td>
                        <td width="60%">&nbsp;</td>
                      </tr>
                    </table></td>
                  <td colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
                  <td colspan="5">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
