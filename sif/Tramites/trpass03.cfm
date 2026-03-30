<cfinclude template="tpid.cfm">
<cfif #tramite.Avance# NEQ '3'><cflocation url="index.cfm?TPID=#TPID#"></cfif>
<cfquery name="rsdatos" datasource="SDC">
	select Iaba, convert(varchar,CBTcodigo) as CBTcodigo, CBcodigo, SUcodigo, CBdescripcion, Mcodigo, Usucodigo, Ulocalizacion, CBofxusuario, CBofxpassword, CBofxacctkey, CBorden, CBofxdtend
	from CtaBancaria  
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
</cfquery>

<cfquery name="rsfec" datasource="sdc">
select getdate() as fecha
</cfquery>

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
		  <form name="form1" action="trpass03-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="6%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td colspan="5">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                </tr>
                <tr> 
                  <td><input type="hidden" name="cedula" value='<cfoutput>#tramite.Cedula#</cfoutput>'></td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      3 de 5:</font></strong> <span class="subTitulo">Pago de 
                      pasaporte</span></p></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td width="45%">
				  <input type="hidden" name="monto" value="<cfoutput>#tramite.Importe#</cfoutput>">
				  <input type="hidden" name="moneda" value="<cfoutput>#tramite.Mcodigo#</cfoutput>">
				  </td>
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
                  <td colspan="7"><div align="justify">Es necesario realizar el 
                      tr&aacute;mite de pago para lo cual, se realiz&aacute; una 
                      transferencia en l&iacute;nea de su cuenta a la cuenta de 
                      la Direcci&oacute;n General de Migraci&oacute;n y Extranjer&iacute;a.</div></td>
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
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="4"><table width="100%" border="0">
                      <tr> 
                        <td width="10%">&nbsp;</td>
                        <td width="31%" nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fecha:</strong></font></div></td>
                        <td width="57%" nowrap><font color="#006699" size="2"> 
                          <cfif isdefined("rsfec")>
                            <cfoutput>#LSDateformat(rsfec.fecha,'dd-mm-yyyy')#</cfoutput> 
                          </cfif>
                          </font></td>
                        <td width="2%" nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tr&aacute;mite 
                            a realizar:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif"> 
                          <cfoutput>#tramite.AccionNombre#</cfoutput>
                          </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>C&eacute;dula:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif"> 
                            <font color="#006699"><cfoutput>#Trim(tramite.cedula)#</cfoutput></font> 
                          </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Monto 
                            a pagar por entero:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif">
						<cfoutput>#LSCurrencyFormat(tramite.importe)# #tramite.Miso4217#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td> <div align="left"><font face="Arial, Helvetica, sans-serif"><font size="2"></font></font> 
                          </div></td>
                        <td><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cuenta 
                            Bancaria a debitar:</strong></font></div></td>
                        <td><font size="2" face="Arial, Helvetica, sans-serif"> 
                          <cfif isdefined("rsdatos")>
                            <select name="cuentas">
                              <cfoutput query="rsdatos"> 
                                <option value="#rsdatos.CBcodigo#|#rsdatos.Iaba#|#rsdatos.CBTcodigo#">#rsdatos.CBdescripcion#</option>
                              </cfoutput> 
                            </select>
                          </cfif>
                          </font></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td><div align="right">PIN: </div></td>
                        <td><input type="password" name="papa"></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2"><strong>Nota:</strong> Esta clave no ser&aacute; 
                          almacenada en ning&uacute;n lugar y adem&aacute;s no 
                          podr&aacute; ser utilizada para otro prop&oacute;sito 
                          distinto al de esta transacci&oacute;n.</td>
                        <td>&nbsp;</td>
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
                        <td><input type="submit" name="Continuar" value="Continuar"> 
                          <input type="button" name="Regresar" value="Regresar" onclick="history.back();"></td>
                        <td>&nbsp;</td>
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
