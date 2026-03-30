<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10">&nbsp;</td>
    <td width="110" valign="top"><img src="/cfmx/educ/imagenes/docencia.gif"></td>
    <td width="10">&nbsp;</td>
    <td width="81%" valign="top"> <p><font size="4"> <strong>Docencia</strong> 
        </font> <font size="1"><br>
        <br>
        </font> <font size="2"> Con esta opci&oacute;n los profesores pueden planear 
        sus Cursos y registrar las calificaciones.<br>
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
//	xx.fnOpcion ("Planificación de Curso","menuParamAcadem.cfm");
	xx.fnOpcion ("Planificación de Curso","docente/planificacion/planificacion.cfm");
//	xx.fnOpcion ("Registro de Calificaciones","MenuEstructura.cfm");
	xx.fnOpcion ("Registro de Calificaciones","javascript: alert('Esta opción se encuentra en construcción')");		
//	xx.fnOpcion ("Control de Asistencia y Observaciones","menuPlanAcadem.cfm");
	xx.fnOpcion ("Control de Asistencia y Observaciones","javascript: alert('Esta opción se encuentra en construcción')");			
	xx.fnOpcion ("Matrícula","matricula/matricula.cfm?TPer=D");	
</cfscript>
</table>
<br>
