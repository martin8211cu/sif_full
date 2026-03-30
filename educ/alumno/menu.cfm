<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10">&nbsp;</td>
    <td width="110" valign="top"><img src="/cfmx/educ/imagenes/estudiante.gif"></td>
    <td width="10">&nbsp;</td>
    <td width="81%" valign="top"> <p><font size="4"> <strong>Servicios Estudiantiles</strong> 
        </font> <font size="1"><br>
        <br>
        </font> <font size="2"> Con esta opci&oacute;n el estudiante podr&aacute; 
        matricularse, estar al d&iacute;a con los temas, trabajos y calificaciones 
        del curso, y consultar su expediente estudiantil.<br>
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
//	xx.fnOpcion ("Matricula","menuParamAcadem.cfm");
	xx.fnOpcion ("Matricula","javascript: alert('Esta opción se encuentra en construcción')");				
//	xx.fnOpcion ("Mis cursos","MenuEstructura.cfm");
	xx.fnOpcion ("Mis cursos","javascript: alert('Esta opción se encuentra en construcción')");
//	xx.fnOpcion ("Expediente","menuPlanAcadem.cfm");
	xx.fnOpcion ("Expediente","javascript: alert('Esta opción se encuentra en construcción')");	
</cfscript>
</table>
<br>
