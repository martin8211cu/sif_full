<html><!-- InstanceBegin template="/Templates/csudemo.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Template 19</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#CCCCCC" text="#000000" leftmargin="0" topmargin="0">
<table width="760" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table width="760" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <table width="760" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="335"><img src="/cfmx/csudemo/consultas/images/your_logo.gif" width="335" height="71"></td>
                <td><img src="/cfmx/csudemo/consultas/images/top_nav_1.gif" width="551" height="71"  border="0"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height="8"><img src="/cfmx/csudemo/consultas/images/gray_spacer.gif" width="8" height="8"></td>
        </tr>
        <tr>
          <td>
            <table width="893" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="194" valign="top" bgcolor="#333366"> 
                  <table width="168" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><img src="/cfmx/csudemo/consultas/images/blue_heading1.gif" width="168" height="21"></td>
                    </tr>
                    <tr>
                      <td height="7"><img src="/cfmx/csudemo/consultas/images/blue_heading.gif" width="168" height="9"></td>
                    </tr>
                    <tr>
                      <td bgcolor="333366"> 
                        <p>&nbsp;</p>
                          <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr>
                              <td>
                                <div align="center"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF">You 
                                  can put your information here, mention of special 
                                  offers, or any other important details.</font></b></div>
                              </td>
                            </tr>
                          </table>
                          <p>&nbsp;</p>
                      </td>
                    </tr>
                    <tr>
                      <td><img src="/cfmx/csudemo/consultas/images/blue_heading2.gif" width="168" height="21"></td>
                    </tr>
                    <tr>
                      <td height="9"><img src="/cfmx/csudemo/consultas/images/blue_heading.gif" width="168" height="9"></td>
                    </tr>
                    <tr>
                      <td bgcolor="333366"> 
                        <p>&nbsp;</p>
                        <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                          <tr> 
                            <td> 
                              <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#FFFFFF">put 
                                link here....<br>
                                put link here....<br>
                                put link here....<br>
                                put link here....</font></b></div>
                            </td>
                          </tr>
                        </table>
                        <p>&nbsp;</p>
                      </td>
                    </tr>
                    <tr>
                      <td><img src="/cfmx/csudemo/consultas/images/blue_heading3.gif" width="168" height="21"></td>
                    </tr>
                    <tr>
                      <td height="9"><img src="/cfmx/csudemo/consultas/images/blue_heading.gif" width="168" height="9"></td>
                    </tr>
                    <tr>
                      <td bgcolor="333366"> 
                        <p>&nbsp;</p>
                        <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                          <tr> 
                            <td> 
                              <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#FFFFFF">put 
                                link here....<br>
                                put link here....<br>
                                put link here....<br>
                                put link here....</font></b></div>
                            </td>
                          </tr>
                        </table>
                        <p>&nbsp;</p>
                      </td>
                    </tr>
                  </table>
                </td>
                <td width="8"><img src="/cfmx/csudemo/consultas/images/gray_spacer.gif" width="8" height="8"></td>
                <td valign="top" bgcolor="#FFFFFF"> <br>
                  <table width="596" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr> 
                      <td align="center" valign="middle" width="248"> 
                        <p><!-- InstanceBeginEditable name="Titulo" --><b>Bienvenido a CSU </b><!-- InstanceEndEditable --></p>
                      </td>
                      <td width="348" align="right"><img src="/cfmx/csudemo/consultas/images/building.jpg" width="150" height="100" border="1"></td>
                    </tr>
                    <tr> 
                      <td colspan="2"><!-- InstanceBeginEditable name="Contenido" -->
<form name="form1" action="csu_pedidos.cfm" method="post" style="margin:0; " onSubmit="return validar(this);">
	<cfset inicio = dateformat(DateAdd("d", -7, now()),'dd/mm/yyyy') >
	<cfset fin = dateformat(now(),'dd/mm/yyyy') >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right">Fecha Inicial:&nbsp;</td>
		<td><cf_sifcalendario name="fechai" value="#inicio#"></td>
		<td align="right">Fecha Final:&nbsp;</td>
		<td><cf_sifcalendario name="fechaf" value="#fin#"></td>
	</tr>
	<tr><td colspan="4" align="center" ><input type="submit" name="Consultar" value="Consultar"></td></tr>
</table>
</form>

<script language="javascript1.2" type="text/javascript">
	function validar(f){
		var msg = '';
		if( document.form1.fechai.value == '' ){
			msg = msg + ' - El campo Fecha Inicial es requerido.\n';
		}
		if( document.form1.fechaf.value == '' ){
			msg = msg + ' - El campo Fecha Final es requerido.\n';
		}
		
		if(msg != ''){
			msg = 'Se presentaron los siguientes errores:\n' + msg;
			alert(msg);
			return false;
		}
		return true;
	
	}
</script>                      <!-- InstanceEndEditable --></td>
                    </tr>
                </table>                  <img src="/cfmx/csudemo/consultas/images/gray_spacer.gif" width="8" height="8"></td>
                <td width="7" valign="top">&nbsp;                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<p align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><a href="http|//www.soin.co.cr/">&copy;2005 SOIN Soluciones Integrales, S.A.</a> </font></b></p>

</body>
<!-- InstanceEnd --></html>
