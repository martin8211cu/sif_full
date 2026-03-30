<cfquery datasource="sdc" name="familia">
	select Pid, Pnombre + ' ' + Papellido1 + ' ' + Papellido2 as Nombre
	from Familiares
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and Ppais = 'CR'
	  and dependiente = 1
</cfquery>
<cfinclude template="../Utiles/general.cfm">
<cfif isDefined("url.TPID")><cflocation url="index.cfm?TPID=#url.TPID#"></cfif>
<html><!-- InstanceBegin template="/Templates/Tramites.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<SCRIPT SRC="../js/qForms/qforms.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>

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
		  <form name="form1" action="trpass01-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="2" cellpadding="4">
                <!--DWLayoutTable-->
                <tr> 
                  <td width="17">&nbsp;<input type="hidden" name="paso"></td>
                  <td width="418" >&nbsp;</td>
                  <td width="448" >&nbsp;</td>
                  <td width="1">&nbsp;</td>
                </tr>
                <tr> 
                  <td></td>
                  <td valign="top"><p><strong>Introducci&oacute;n:</strong> <br>
                      Mediante esta opci&oacute;n, usted puede iniciar su tr&aacute;mite 
                      para solicitud o renovaci&oacute;n de su pasaporte, agilizando 
                      este proceso as&iacute; como los pagos de derechos correspondientes.</p>
                    <p><strong>Requisitos:</strong>
                    <ol>
                      <li>C&eacute;dula de identidad vigente y en buen estado.</li>
                      <li>Fotocopia de Cédula de identidad (anotar por el frente 
                        direcci&oacute;n exacta y tel&eacute;fono).</li>
                      <li>Pasaportes extraviados o robados con menos de diez (10) 
                        años de vigencia, deben aportar denuncia ante el O.I.J. 
                        o una declaración jurada protocolizada confeccionada por 
                        un notario público.</li>
                    </ol> </p>
                    <font size="3"><strong>Paso 1 de 5:</strong></font> <span class="subTitulo">Solicitud 
                    del Tr&aacute;mite<br>
                    </span>
                    <table border="0" cellpadding="6">
                          <cfif #familia.RecordCount# GT 0>
                      <tr> 
                        <td><strong>Solicitar pasaporte para:</strong></td>
                        <td>
                          <select name="select" onChange="document.form1.cedula.value=this.value">
						  	<option value="">[ Seleccionar ]</option>
                            <cfoutput query="familia">
                              <option value="#familia.Pid#">#familia.Nombre#</option>
                            </cfoutput> 
                            <option value="">Otro...</option>
                          </select>
                          </td>
                      </tr>
                          </cfif>
                      <tr> 
                        <td><strong>N&uacute;mero de C&eacute;dula:</strong></td>
                        <td><input type="text" name="cedula" title="Ej: 9-1234-5678">
                          <strong>X-XXXX-XXXX</strong></td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="center" ><span class="subTitulo"> 
                          <input type="submit" name="Solicitar" value="Solicitar">
                          </span></td></tr>
                    </table>
                    <span class="subTitulo"><br>
                    <br>
                    </span> </td>
                  <td valign="top" bgcolor="#eeeeee" style="border:1px solid black" ><div align="left"> 
                      <strong>Pasos:</strong><br>
                      Los pasos para solicitud de pasaporte por medio del portal 
                      son: 
                      <ol>
                        <li>Ingreso de solicitud de tr&aacute;mite de pasaporte 
                          a trav&eacute;s de el n&uacute;mero de c&eacute;dula.</li>
                        <li> Una vez validada su solicitud, usted podr&aacute; 
                          realizar: 
                          <ol type="a">
                            <li>Solicitud de pasaporte nuevo. (US$ 45.00)</li>
                            <li>Revalidaci&oacute;n de pasaporte. (&cent; 600.00)</li>
                            <li>Renovaci&oacute;n de pasaporte. (US$ 45.00)</li>
                            <li>Reporte de extrav&iacute;o de pasaporte y solicitud 
                              de nuevo pasaporte. (US$ 90.00)</li>
                          </ol>
                        </li>
                        <li>Realizar el pago en l&iacute;nea de la solicitud deseada. 
                          (Puede realizarse mediante el portal)</li>
                        <li>Imprimir la confirmaci&oacute;n del pago.</li>
                        <li>Presentarse el due&ntilde;o del pasaporte en la Direcci&oacute;n 
                          General de Migraci&oacute;n y Extranjer&iacute;a con 
                          su c&eacute;dula para: 
                          <ol type="a">
                            <li>Toma de fotograf&iacute;a.</li>
                            <li>Toma de huella digital.</li>
                            <li>Entrega de pasaporte. </li>
                          </ol>
                        </li>
                      </ol>
                    </div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
            </form>
            <SCRIPT LANGUAGE="JavaScript">
<!--//
qFormAPI.errorColor = "#FFFFCC";
objForm = new qForm("form1");
objForm.cedula.toUpperCase();
objForm.cedula.description="Cédula";
objForm.cedula.required=true;
objForm.required("cedula", true);
objForm.cedula.validate=true;
var strErrorMsg="El valor de la cédula digitada no concuerda con el formato X-XXXX-XXXX";
objForm.cedula.validateFormat(' x-xxxx-xxxx', "numeric"); 
//-->
</SCRIPT>
            <!-- InstanceEndEditable -->
</td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
