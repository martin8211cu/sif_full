<cfinclude template="isadmin.cfm">

<cfquery datasource="sdc" name="tramite">
select 
	convert (varchar, a.TPID) as TPID, a.Cedula,
	a.Pagado, a.Procesado,
	convert (varchar, isnull (a.FechaFin, a.FechaInicio), 103) as Fecha,
	u.Usulogin,
	u.Pnombre + ' ' + u.Papellido1 + ' ' + u.Papellido2 as Nombre,
	a.TIcodigo, c.TIsrvrtid, a.Importe, b.Miso4217,
	d.AccionNombre, a.Avance
from TramitePasaporte a, Moneda b, TramitePasaporteAccion d,
	TramitePasaporteEstado e, Usuario u, Transferencia c
where a.TPID = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.TPID#">
  and b.Mcodigo =* a.Mcodigo
  and d.Accion =* a.Accion
  and e.Pestado =* a.Pestado
  and u.Usucodigo = a.Usucodigo
  and u.Ulocalizacion = a.Ulocalizacion
  and c.TIcodigo =* a.TIcodigo
</cfquery>
<!--- <cfdump var="#mydata#"> --->
<cfif tramite.RecordCount EQ 0 >
	<cflocation url="error.cfm?msg=tpid-invalido">
</cfif>


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
            <!-- InstanceBeginEditable name="Menu" --><cfinclude template="jsTramitesAdmin.cfm" ><!-- InstanceEndEditable --></td>
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
		  <form name="form1" action="consulta-detalle-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="2">
                <!--DWLayoutTable-->
                <tr> 
                  <td width="17"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td width="13"> </td>
                  <td width="190"></td>
                  <td width="277"></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="3" valign="top"><p align="justify"><strong><font size="3">Detalle</font><font size="3"> 
                      del tr&aacute;mite</font></strong></p></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>Fecha:</strong></font></div></td>
                  <td valign="top" nowrap><font size="2"><cfoutput>#tramite.Fecha#</cfoutput></font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>Solicitado 
                      por:</strong></font></div></td>
                  <td valign="top" nowrap><font size="2"><cfoutput>#tramite.Usulogin# - #tramite.Nombre#</cfoutput></font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>C&eacute;dula:</strong></font></div></td>
                  <td valign="top" nowrap><font size="2"><cfoutput>#tramite.Cedula#</cfoutput></font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><strong><font size="2">N&uacute;mero 
                      de Confirmaci&oacute;n:</font></strong></div></td>
                  <td valign="top" nowrap><font size="2"><cfoutput>#tramite.TPID#</cfoutput></font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>N&uacute;mero 
                      de Transferencia:</strong></font></div></td>
                  <td valign="top" nowrap><font size="2"> <cfoutput>#tramite.TIcodigo# #tramite.TIsrvrtid#</cfoutput></font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>Importe 
                      pagado: </strong></font></div></td>
                  <td valign="top" nowrap><font size="2"> <cfoutput>#tramite.Importe# #tramite.Miso4217#</cfoutput> </font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>Tr&aacute;mite:</strong></font></div></td>
                  <td valign="top" nowrap><font color="#006699" size="2"><cfoutput>#tramite.AccionNombre#</cfoutput></font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>Pagado:</strong></font></div></td>
                  <td valign="top" nowrap><font color="#006699" size="2"> 
                    <cfif #tramite.Pagado#>
                      S&iacute; 
                      <cfelse>
                      No 
                    </cfif>
                    </font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap><div align="right"><font size="2" ><strong>Procesado:</strong></font></div></td>
                  <td valign="top" nowrap><font color="#006699" size="2"> 
                    <cfif #tramite.Procesado#>
                      S&iacute; 
                      <cfelse>
                      No 
                    </cfif>
                    </font></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" valign="top" nowrap align="center">
                      <input type="button" value="Regresar" onclick="history.back()">
					  <cfif (#tramite.Procesado# EQ 0) AND (#tramite.Pagado# EQ 1) AND (#tramite.Avance# EQ '5' or #tramite.Avance# EQ '6')>
                      <input type="submit" value="Marcar como procesado" >
					  </cfif>
					  </td>
                </tr>
              </table></form>
            <!-- InstanceEndEditable -->
</td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
