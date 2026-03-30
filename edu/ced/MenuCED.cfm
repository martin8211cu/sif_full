<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
		<link id="webfx-tab-style-sheet" type="text/css" rel="stylesheet" href="/cfmx/edu/css/tab.webfx.css"/>
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
				<cfset RolActual = 4>
				<cfset Session.RolActual = 4>
				<cfinclude template="../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
				  	<cfinclude template="jsMenuCED.cfm">
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
				  <!-- InstanceBeginEditable name="TituloPortlet" -->Men&uacute; Principal<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
				  <cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
					  <script type="text/javascript" src="/cfmx/edu/js/tabpane/tabpane.js"></script>
					  <div class="tab-pane" id="tabPaneMenuCED">
					  <script type="text/javascript">
						tp1 = new WebFXTabPane( document.getElementById( "tabPaneMenuCED" ) );
					  </script>
					  <div class="tab-page" id="tabPage1">
					  <h2 class="tab">Plan de Estudio</h2>
					  <script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage1" ) );</script>
                  <cfelse>
                  <h2 class="tab">Plan de Estudio</h2>
                  </cfif>
                  <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0" dwcopytype="CopyTableCell">
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="plan/Nivel.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/Nivel.cfm">Niveles</a></font></td>
                      <td align="right" valign="middle"><a href="plan/EvaluacionConcepto.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="plan/EvaluacionConcepto.cfm">Conceptos de Evaluaci&oacute;n</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="plan/Grado.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/Grado.cfm">Grados</a></font></td>
                      <td align="right" valign="middle"><a href="plan/listaTablaEvaluac.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="plan/listaTablaEvaluac.cfm">Tablas de Evaluaci&oacute;n</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="plan/PeriodoEvaluacion.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/PeriodoEvaluacion.cfm">Per&iacute;odos de Evaluaci&oacute;n</a></font></td>
                      <td align="right" valign="middle"><div align="right"><a href="plan/EvaluacionPlan.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="plan/listaEvaluacionPlan.cfm">Plan de Evaluaci&oacute;n</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="plan/PeriodoEscolar.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/PeriodoEscolar.cfm">Tipos de Curso Lectivo</a></font></td>
                      <td align="right" valign="middle"><a href="plan/Materias.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="plan/Materias.cfm">Materias</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="plan/listaSubPeriodoEscolar.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/listaSubPeriodoEscolar.cfm">Cursos Lectivos</a></font></td>
                      <td align="right" valign="middle"><a href="plan/listaMateriasComplementarias.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"> <a href="plan/listaMateriasComplementarias.cfm"> Materias Complementarias</a> </font> </td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="plan/MateriaTipo.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/MateriaTipo.cfm">Tipos de Materia</a></font></td>
                      <td align="right" valign="middle"><a href="plan/listaMateriasSustitutivas.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"> <a href="plan/listaMateriasSustitutivas.cfm"> Materias Sustitutivas</a> </font> </td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><!--- <a href="plan/PublicarNotas.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a> --->
                  &nbsp;</td>
                      <td style="padding-right: 10px;" nowrap><!--- <font size="2"><a href="plan/PublicarNotas.cfm">Publicaci&oacute;n 
							  de Notas </a></font> --->
                  &nbsp;</td>
                      <td align="right" valign="middle"><a href="plan/listaMateriasElectivas.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"> <a href="plan/listaMateriasElectivas.cfm"> Materias Electivas </a> </font> </td>
                    </tr>
                  </table>
                  <cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
                    </div>
                    <div class="tab-page" id="tabPage2">
                    <h2 class="tab">Recursos</h2>
                    <script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage2" ) );</script>
                    <cfelse>
                    <h2 class="tab">Recursos</h2>
                  </cfif>
                  <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0" dwcopytype="CopyTableCell">
                    <tr>
                      <td width="4%" align="right" valign="middle"><div align="right"><a href="recurso/Infraestructura.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="recurso/Infraestructura.cfm"> Infraestructura</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="plan/listaHorarioTipo.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size='2'><a href="plan/listaHorarioTipo.cfm">Tipos de Horario</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="recurso/calendario.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="recurso/calendario.cfm">Calendario Escolar</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="recurso/rh.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="recurso/rh.cfm">Recurso Humano</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="recurso/listaBiblioteca.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="recurso/listaBiblioteca.cfm">Biblioteca</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                  </table>
                  <cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
                    </div>
                    <div class="tab-page" id="tabPage3">
                    <h2 class="tab">Alumnos</h2>
                    <script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage3" ) );</script>
                    <cfelse>
                    <h2 class="tab">Alumnos</h2>
                  </cfif>
                  <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0" dwcopytype="CopyTableCell">
                    <tr>
                      <td width="4%" align="right" valign="middle"><div align="right"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></div></td>
                      <td nowrap><font size="2"><a href="alumno/promociones.cfm">Mantenimiento de Promociones</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/PromocionProc.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/PromocionProc.cfm">Proceso de Promoci&oacute;n</a></font></td>
                    </tr>
                    <!---                   <tr> 
							<td align="right" valign="middle"> <div align="right"><a href="alumno/Consultas/alumno.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
							<td nowrap><font size="2"><a href="alumno/Consultas/alumno.cfm">Alumnos 
							  Pruebas </a></font></td>
						  </tr> --->
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/alumno.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/alumno.cfm">Alumnos</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/retirados.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/retirados.cfm">Alumnos Retirados</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/Graduados.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/Graduados.cfm">Alumnos Graduados</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/MatriculaMasiva.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/MatriculaMasiva.cfm">Matr&iacute;cula Masiva</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/MatriculaIndividual.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/MatriculaIndividual.cfm">Matr&iacute;cula Individual</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="alumno/MatriculaExtra.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="alumno/MatriculaExtra.cfm">Matr&iacute;cula Extraordinaria</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle">&nbsp;</td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                  </table>
                  <cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
                    </div>
                    <div class="tab-page" id="tabPage4">
                    <h2 class="tab">Curso Lectivo</h2>
                    <script type="text/javascript">tp1.addTabPage( document.getElementById( "tabPage4" ) );</script>
                    <cfelse>
                    <h2 class="tab">Curso Lectivo</h2>
                  </cfif>
                  <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0" dwcopytype="CopyTableCell">
                    <tr>
                      <td width="4%" align="right" valign="middle"><div align="right"><a href="cursolectivo/Cursos.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="cursolectivo/Cursos.cfm">Mantenimiento de Cursos</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="plan/PublicarNotas.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td style="padding-right: 10px;" nowrap><font size="2"><a href="plan/PublicarNotas.cfm">Publicaci&oacute;n de Notas </a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"></div></td>
                      <td nowrap>&nbsp;</td>
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
                      <td width="4%" align="right" valign="middle"><div align="right"><a href="consultas/ListaEstudXGrupo.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"> <a href="consultas/ListaEstudXGrupo.cfm">Alumnos por Grupo</a> </font></td>
                      <td align="right" valign="middle"><a href="consultas/ListaAlumnosXEncargado.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaAlumnosXEncargado.cfm">Alumnos por Encargado</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="consultas/ListadoMateriasGrupo.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap ><font size="2"><a href="consultas/ListadoMateriasGrupo.cfm">Cursos por Grupo</a></font></td>
                      <td align="right" valign="middle"><div align="right"><a href="consultas/ListaMatElect.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="consultas/ListaTemariosXCurso.cfm">Temarios y Evaluaciones</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="consultas/ListaCursosXProf.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaCursosXProf.cfm">Cursos por Profesor</a></font></td>
                      <td align="right" valign="middle"><div align="right"><a href="consultas/ListaEvalPree.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="consultas/ListaEvalPree.cfm">Evaluaciones de Preescolar</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="consultas/ListadoHorariosGrupo.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListadoHorariosGrupo.cfm">Horarios por Grupo</a></font></td>
                      <td align="right" valign="middle"><a href="consultas/ProgressReport.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ProgressReport.cfm">Reporte de Progreso</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="consultas/ListaMatElect.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaMatElect.cfm">Materias Electivas</a></font></td>
                      <td nowrap  align="right" valign="middle"><a href="consultas/ListaEvaluac.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaEvaluac.cfm">Reporte de Evaluaciones</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><div align="right"><a href="consultas/ListaAlumnoEncar.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                      <td nowrap><font size="2"><a href="consultas/ListaAlumnoEncar.cfm">Encargados por Alumno</a></font></td>
                      <td nowrap  align="right" valign="middle"><a href="consultas/ListaNotasFinales.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaNotasFinales.cfm">Reporte de Notas Finales</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle"><a href="consultas/ProgressReportGroup.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ProgressReportGroup.cfm">Reporte de Progreso por Grupo </a></font></td>
                      <td align="right" valign="middle"><a href="consultas/ListaEvalPreeHist.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaEvalPreeHist.cfm">Hist&oacute;rico de Evaluaciones de Preescolar</a></font></td>
                    </tr>
                    <tr>
                      <td align="right" valign="middle">&nbsp;</td>
                      <td nowrap>&nbsp;</td>
                      <!---
							<td align="right" valign="middle"><a href="consultas/ListaNotasFinalesHist.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
							<td nowrap><font size="2"><a href="consultas/ListaNotasFinalesHist.cfm">Reporte Hist&oacute;rico de Notas Finales</a></font></td> 
							--->
                      <td align="right" valign="middle"><a href="consultas/ListaPromedios.cfm" onMouseOver="MM_preloadImages('../Imagenes/ftv4doc.gif')"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                      <td nowrap><font size="2"><a href="consultas/ListaPromedios.cfm">Reporte de Aplazados y Mejores Promedios</a></font></td>
                    </tr>
                  </table>
                  <cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
                    </div>
                    </div>
                    <script type="text/javascript">
					setupAllTabs();
		          </script>
                  </cfif>
                  <font size="2" > <a href="/cfmx/home/menu/modulo.cfm?s=ESCUELA"><strong><< Regresar al Men&uacute; Educacion</strong></a> </font> 
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