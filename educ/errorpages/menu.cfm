<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10">&nbsp;</td>
    <td width="110" valign="top"><img src="plano.gif"></td>
    <td width="10">&nbsp;</td>
    <td width="81%" valign="top"> <p><font size="4"> 
        <strong>Administraci&oacute;n del Sistema</strong> </font> <font size="1"><br>
        <br>
        </font> <font size="2"> Con esta opci&oacute;n se definen los par&aacute;metros 
        de comportamiento y cat&aacute;logos necesarios para el funcionamiento 
        del sistema., as&iacute; como los planes de estudio de las diferentes 
        carreras acad&eacute;micas.<br>
        </font> </p></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</font>
<table width="90%" border="0" align="center" cellpadding="1" cellspacing="0"  style="border-bottom:solid 1px;">
<cfscript>
	xx = createObject("component", "educ.componentes.pFunciones");
	xx.fnOpcion ("Parámetros Académicos","menuParamAcadem.cfm");
	xx.fnOpcion ("Organización Académica","MenuEstructura.cfm");
	xx.fnOpcion ("Planes Académicos","menuPlanAcadem.cfm");
</cfscript>
</table>
<br>
