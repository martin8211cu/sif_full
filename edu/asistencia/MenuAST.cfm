<!-- InstanceBegin template="/Templates/LMenuAST.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
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
				<cfset RolActual = 11>
				<cfset Session.RolActual = 11>
				<cfinclude template="../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
			<cfinclude template="jsMenuAST.cfm">
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
				  <!-- InstanceBeginEditable name="TituloPortlet" -->Men&uacute; 
            Principal<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
            <table width="92%" border="0" align="center" cellpadding="1" cellspacing="0">
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"></div></td>
                <td width="31%" nowrap><font size="2">&nbsp;</font></td>
                <td width="4%">&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="1%" nowrap><font size="2">&nbsp;</font></td>
                <td width="9%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2"><strong>&nbsp;Planear:</strong></font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"></div></td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
                <td width="1%"><font size="2"><strong>Reportes</strong></font></td>
                <td width="5%" nowrap>&nbsp;</td>
                <td align="right" valign="middle"> <div align="right"></div></td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"><a href="planearPeriodo.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="planearPeriodo.cfm"> Planificar 
                  Per&iacute;odo</a></font></td>
                <td align="right" valign="middle"> <div align="right"><a href="consultas/ProgressReportGroup.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="consultas/ProgressReportGroup.cfm"> Progreso 
                  por Grupo </a></font></td>
                <td width="5%">&nbsp;</td>
                <td align="right" valign="middle"> <div align="right"></div></td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%" height="26"><font size="2">&nbsp;</font></td>
                <td width="5%" nowrap><font size="2"><strong>Calificar</strong>:</font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"></div></td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td align="right" valign="middle"> <div align="right"></div></td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"><a href="calificarEvaluaciones.cfm" onMouseOver="MM_preloadImages('/cfmx/edu/Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"> <a href="calificarEvaluaciones.cfm">Evaluar 
                  Per&iacute;odo</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td align="right" valign="middle"><a href="calificarCurso.cfm" onMouseOver="MM_preloadImages('/cfmx/edu/Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="calificarCurso.cfm">Evaluar 
                  Curso Final</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td width="1%" align="right" valign="middle">&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td width="5%" nowrap><font size="2"><strong>Otros:</strong></font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"></div></td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle">&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"> <div align="right"><a href="incidencias.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="incidencias.cfm"> Incidencias</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle">&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <cfoutput> 
                <tr> 
                  <td>&nbsp;</td>
                  <td nowrap><font size="2">&nbsp;</font></td>
                  <td align="right" valign="middle"> <div align="right"><a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                  <td nowrap><font size="2"><a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#"> 
                    Comunicados</a></font></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td align="right" valign="middle">&nbsp;</td>
                  <td nowrap>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </cfoutput> 
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"> <div align="right"><a href="utilitarios/copiaTemaEval.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"> <a href="utilitarios/copiaTemaEval.cfm">Copia 
                  de Temarios y Evaluaciones</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"> <div align="right"><a href="MaterialApoyo/documentos.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"> <a href="MaterialApoyo/documentos.cfm">Carga 
                  de Material Did&aacute;ctico</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
            <div align="center"></div>
            <div align="center"></div>
<font size="2" >
	<a href="/cfmx/home/menu/modulo.cfm?s=ESCUELA"><strong><< Regresar al Menú Educacion</strong></a>
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