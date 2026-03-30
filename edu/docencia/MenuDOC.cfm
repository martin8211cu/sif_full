<!-- InstanceBegin template="/Templates/LMenuDOC.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<link id="webfx-tab-style-sheet" type="text/css" rel="stylesheet" href="/cfmx/edu/css/tab.webfx.css"/>
<script type="text/javascript" src="/cfmx/edu/js/tabpane/tabpane.js"></script>
<!-- InstanceEndEditable -->
	<link href="../css/portlets.css" rel="stylesheet" type="text/css">
	<link href="../css/edu.css" rel="stylesheet" type="text/css">
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
	<script language="JavaScript" type="text/javascript">
		// Funciones para Manejo de Botones
		botonActual = "";
	
		function setBtn(obj) {
			botonActual = obj.name;
		}
		function btnSelected(name, f) {
			if (f != null) {
				return (f["botonSel"].value == name)
			} else {
				return (botonActual == name)
			}
		}
	</script>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
		<td valign="top">
			<cfset RolActual = 5>
			<cfset Session.RolActual = 5>
			<cfinclude template="../portlets/pEmpresas2.cfm">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="area" style="padding-bottom: 3px;"> 
			  <td nowrap style="padding-left: 10px;">
			  <cfinclude template="../portlets/pminisitio.cfm">
			  </td>
			  <td valign="top" nowrap> 
		  <!-- InstanceBeginEditable name="MenuJS" --> 
	  		<cfinclude template="jsMenuDOC.cfm">
      <!-- InstanceEndEditable -->	
			  </td>
			</tr>
		  </table>
		</td>
	  </tr>
	</table>
	  
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
		<td align="left" valign="top" nowrap></td>
		<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
	  </tr>
	  <tr> 
		<td valign="top" nowrap>
			<cfinclude template="/sif/menu.cfm">
		</td>
		<td valign="top" width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
			  <td width="2%"class="Titulo"><img  src="../Imagenes/sp.gif" width="15" height="15" border="0"></td>
			  <td width="3%" class="Titulo" >&nbsp;</td>
			  <td width="94%" class="Titulo">
			  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Men&uacute; Principal<!-- InstanceEndEditable -->
			  </td>
			  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
			</tr>
			<tr> 
			  <td colspan="3" class="contenido-lbborder">
			  <!-- InstanceBeginEditable name="Mantenimiento2" -->
<cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
<div class="tab-pane" id="tabPaneDoc">

	<script type="text/javascript">
	tp1 = new WebFXTabPane( document.getElementById( "tabPaneDoc" ) );
	</script>

	<div class="tab-page" id="tabPage1">
        <h2 class="tab">Docencia</h2>
		
		<script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage1" ) );</script>
<cfelse>
        <h2 class="tab">Docencia</h2>

</cfif>
		
			    <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0" dwcopytype="CopyTableCell">
                  <tr align="left"> 
                    <td height="24" colspan="2" valign="middle"><font size="2"><a href="planearPeriodo.cfm"><strong>Planear</strong></a><strong>:</strong></font></td>
                  </tr>
                  <tr> 
                    <td width="4%" height="24" align="right" valign="middle"> 
                      <div align="right"><a href="planearPeriodo.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div>
                    </td>
                    <td nowrap style="padding-right: 10px;"><font size="2"><a href="planearPeriodo.cfm">Planificar 
                      Periodo</a></font></td>
                  </tr>
                  <tr> 
                    <td height="24" align="right" valign="middle">&nbsp;</td>
                    <td nowrap style="padding-right: 10px;">&nbsp;</td>
                  </tr>
                  <tr align="left"> 
                    <td colspan="2" valign="middle"><font size="2"><a href="planearPeriodo.cfm"><strong>Calificar</strong></a><strong>:</strong></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"> 
                      <div align="right"><a href="calificarEvaluaciones.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div>
                    </td>
                    <td nowrap><font size="2"><a href="calificarEvaluaciones.cfm">Evaluar 
                      Per&iacute;odo</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="calificarCurso.cfm" onMouseOver="MM_preloadImages('/cfmx/edu/Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="calificarCurso.cfm">Evaluar 
                      Curso Final</a></font></td>
                  </tr>
                  <tr> 
                    <td height="24" align="right" valign="middle">&nbsp;</td>
                    <td nowrap style="padding-right: 10px;">&nbsp;</td>
                  </tr>
                  <tr align="left"> 
                    <td colspan="2" valign="middle"><font size="2"><a href="planearPeriodo.cfm"><strong>Otros</strong></a><strong>:</strong></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="incidencias.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td align="left" nowrap><font size="2"><a href="incidencias.cfm">Incidencias</a></font></td>
                  </tr>
				  <cfoutput>
                  <tr>
                    <td align="right" valign="middle"><a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td align="left" nowrap><font size="2"><a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#">Comunicados</a> </font></td>
                  </tr>
				  </cfoutput>
                  <tr> 
                    <td align="right" valign="middle"><a href="../asistencia/utilitarios/copiaTemaEval.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="utilitarios/copiaTemaEval.cfm">Copia 
                      de Temarios y Evaluaciones</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"> 
                      <div align="right"><a href="recalendarizar.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div>
                    </td>
                    <td nowrap><font size="2"><a href="recalendarizar.cfm">Recalendarizaci&oacute;n 
                      de Temarios y Evaluaciones</a></font></td>
                  </tr>
                  <tr>
                    <td align="right" valign="middle">
                      <div align="right"><a href="MaterialApoyo/documentos.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div>
                    </td>
                    <td nowrap><font size="2"><a href="MaterialApoyo/documentos.cfm">Carga de Material Did&aacute;ctico</a></font></td>
                  </tr>
				  <!---
                  <tr>
                    <td align="right" valign="middle">
                      <div align="right"><a href="javascript:a=window.open('/cfmx/edu/responsable/comunicados.cfm', 'Comunicados','left=50,top=10,scrollbars=yes,resiable=yes,width=500,height=350,alwaysRaised=yes','Comunicados al Profesor');a.focus();"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div>
                    </td>
                    <td nowrap><font size="2"><a href="javascript:a=window.open('/cfmx/edu/responsable/comunicados.cfm', 'Comunicados','left=50,top=10,scrollbars=yes,resiable=yes,width=500,height=350,alwaysRaised=yes','Comunicados al Profesor');a.focus();">Comunicados</a></font></td>
                  </tr>
				  --->				  
                  <tr> 
                    <td height="24" align="right" valign="middle">&nbsp;</td>
                    <td nowrap style="padding-right: 10px;">&nbsp;</td>
                  </tr>
                </table>		
<cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
	</div>

	<div class="tab-page" id="tabPage5">
		        <h2 class="tab">Reportes</h2>
		
		<script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage5" ) );</script>
<cfelse>
		        <h2 class="tab">Reportes</h2>
		
</cfif>		
                <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0" dwcopytype="CopyTableCell">
                  <tr> 
                    <td width="4%" align="right" valign="middle"> <div align="right"><a href="consultas/ListaAlumnosXProf.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                    <td nowrap><font size="2"><a href="consultas/ListaAlumnosXProf.cfm">Listado 
                      de Alumnos</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="consultas/ListaTemariosEvalXProf.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="consultas/ListaTemariosEvalXProf.cfm">Listado 
                      de Temarios y Evaluaciones</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="consultas/ListaConceptosEval.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="consultas/ListaConceptosEval.cfm"> 
                      Listado de Conceptos de Evaluacion</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="consultas/ListaIncidencias.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap> <font size="2"><a href="consultas/ListaIncidencias.cfm"> 
                      Reporte de Incidencias</a></font> </td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="consultas/ListaEvalXProf.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap> <font size="2"><a href="consultas/ListaEvalXProf.cfm"> 
                      Reporte de Evaluaciones</a></font></td>
                  </tr>
				  <!---
                  <tr> 
                    <td nowrap  align="right" valign="middle"><a href="/cfmx/edu/Docencia/consultas/ListaNotasFinalesDOC.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="/cfmx/edu/Docencia/consultas/ListaNotasFinalesDOC.cfm">Reporte 
                      de Notas Finales</a></font></td>
                  </tr>
				  --->
                  <tr> 
                    <td align="right" valign="middle">&nbsp;</td>
                    <td nowrap>&nbsp;</td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"> <div align="right"></div></td>
                    <td nowrap>&nbsp;</td>
                  </tr>
                </table>		
<cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
	</div>

</div>

<script type="text/javascript">
setupAllTabs();
</script>
</cfif>

<font size="2" >
	<a href="/cfmx/home/menu/modulo.cfm?s=ESCUELA"><strong><< Regresar al Men&uacute; Educacion</strong></a>
</font>
          <!-- InstanceEndEditable -->
			  </td>
			  <td class="contenido-brborder">&nbsp;</td>
			</tr>
		  </table>
		 </td>
	  </tr>
	</table>

	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->