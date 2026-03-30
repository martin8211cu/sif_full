<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10">&nbsp;</td>
    <td width="110" valign="top"><img src="/cfmx/educ/imagenes/administrativo.gif"></td>
    <td width="10">&nbsp;</td>
    <td width="81%" valign="top"> <p><font size="4"> <strong>Tareas Administrativas</strong> 
        </font> <font size="1"><br>
        <br>
        </font> <font size="2"> Con esta opci&oacute;n se realizan las tareas 
        de registro de docentes y estudiantes, as&iacute; como la matr&iacute;cula 
        y cobro.<br>
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
	xx.fnOpcion ("Registro de Directores","administrativo/personas/director.cfm?TP=DI");
	xx.fnOpcion ("Registro de Docentes","administrativo/personas/docente.cfm?TP=DO");
	xx.fnOpcion ("Registro de Estudiantes","administrativo/personas/alumno.cfm?TP=A");
	xx.fnOpcion ("Registro de Profesores Gu&iacute;a","administrativo/personas/profGuia.cfm?TP=PG");	
	xx.fnOpcion ("Matrícula","matricula/matricula.cfm?TPer=D");
//	xx.fnOpcion ("Autorizaciones","menuPlanAcadem.cfm");
	xx.fnOpcion ("Autorizaciones","javascript: alert('Esta opción se encuentra en construcción')");	
//	xx.fnOpcion ("Convalidaciones","menuPlanAcadem.cfm");
	xx.fnOpcion ("Convalidaciones","javascript: alert('Esta opción se encuentra en construcción')");	
</cfscript>
</table>
<br>
