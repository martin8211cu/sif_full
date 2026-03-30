<cfreturn>
<cfinclude template="../Utiles/queryMenu.cfm">
<!--- <script id="Sothink Widgets:PageletServer.DynamicMenu" type="text/javascript" language="JavaScript1.2" src="/cfmx/edu/js/DHTMLMenu3.5/stm31.js"></script> --->
<table width='100%' border='0' cellspacing='0' cellpadding='0' >
  <tr>
    <td nowrap> 
	
<script type="text/javascript" language="JavaScript1.2">
<!--
stm_bm(["exnvfhr",400,"/cfmx/edu/js/DHTMLMenu/","blank.gif",0,"","",0,1,50,50,50,1,0,0]);
stm_bp("p0",[0,4,0,0,0,2,8,7,100,"",-2,"",-2,90,0,0,"#000000","#a0a0ba","",3,1,1,"#a0a0ba"]);
stm_ai("p0i0",[0,"Menú Principal","","",-1,-1,0,"","_self","","Menú Principal","","",5,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"#a0a0ba",0,"#a0a0ba",0,"","",3,3,1,1,"#a0a0ba","#666666","#ffffff","#ffffff","8pt Verdana","8pt Verdana",0,0]);
stm_bp("p1",[1,4,0,0,2,2,0,0,100,"",-2,"",-2,50,0,0,"#7f7f7f","#ffffff","",0,1,1,"#000000"]);
for (var contador=0; contador<menuPrincipalOptions.length-1; contador++) {
	stm_aix("p1i"+contador,"p0i0",[0,menuPrincipalOptions[contador][0],"","",-1,-1,0,menuPrincipalOptions[contador][1],"_self",menuPrincipalOptions[contador][0],menuPrincipalOptions[contador][0],"","",0,0,0,"","",0,0,0,0,1,"#ffffff",1,"#a0a0ba",0,"","",3,3,0,0,"#ffffff","#ffffff","#000000"]);
}
stm_ep();
stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
stm_aix("p0i2","p0i0",[0,"Docencia","","",-1,-1,0,"","_self","","Docencia","","",8]);
stm_bpx("p2","p1",[1,4,0,0,2,2,8,0,100,"",-2,"",-2,50,0,0,"#000000"]);
stm_aix("p2i0","p1i0",[0,"Planificar Período","","",-1,-1,0,"/cfmx/edu/docencia/planearPeriodo.cfm","_self","Planificar Período","Planificar Período"]);
stm_aix("p2i1","p1i0",[0,"Evaluar Período","","",-1,-1,0,"/cfmx/edu/docencia/calificarEvaluaciones.cfm","_self","Evaluar Período","Evaluar Período","","",8]);
stm_aix("p2i2","p1i0",[0,"Evaluar Curso Final","","",-1,-1,0,"/cfmx/edu/docencia/calificarCurso.cfm","_self","Evaluar Curso Final","Evaluar Curso Final"]);
stm_aix("p2i3","p1i0",[0,"Incidencias","","",-1,-1,0,"/cfmx/edu/docencia/incidencias.cfm","_self","Incidencias","Incidencias"]);
stm_aix("p2i4","p1i0",[0,"Copia de Temarios y Evaluaciones","","",-1,-1,0,"/cfmx/edu/docencia/utilitarios/copiaTemaEval.cfm","_self","Copia de Temarios y Evaluaciones","Copia de Temarios y Evaluaciones"]);
stm_aix("p2i5","p1i0",[0,"Recalendarización de Temarios y Evaluaciones","","",-1,-1,0,"/cfmx/edu/docencia/recalendarizar.cfm","_self","Recalendarización de Temarios y Evaluaciones","Recalendarización de Temarios y Evaluaciones"]);
stm_aix("p2i6","p1i0",[0,"Carga de Material Didáctico","","",-1,-1,0,"/cfmx/edu/docencia/MaterialApoyo/documentos.cfm","_self","Carga de Material Didáctico","Carga de Material Didáctico"]);
stm_ep();
stm_aix("p0i3","p0i0",[0,"Reportes","","",-1,-1,0,"","_self","Reportes","Reportes"]);
stm_bpx("p3","p1",[]);
stm_aix("p3i0","p1i0",[0,"Listado de Alumnos","","",-1,-1,0,"/cfmx/edu/docencia/consultas/ListaAlumnosXProf.cfm","_self","Listado de Alumnos","Listado de Alumnos"]);
stm_aix("p3i1","p1i0",[0,"Listado de Temarios y Evaluaciones","","",-1,-1,0,"/cfmx/edu/docencia/consultas/ListaTemariosEvalXProf.cfm","_self","Listado de Temarios y Evaluaciones","Listado de Temarios y Evaluaciones"]);
stm_aix("p3i2","p1i0",[0,"Listado de Conceptos de Evaluación","","",-1,-1,0,"/cfmx/edu/docencia/consultas/ListaConceptosEval.cfm","_self","Listado de Conceptos de Evaluación","Listado de Conceptos de Evaluación"]);
stm_aix("p3i3","p1i0",[0,"Reporte de Incidencias","","",-1,-1,0,"/cfmx/edu/docencia/consultas/ListaIncidencias.cfm","_self","Reporte de Incidencias","Reporte de Incidencias"]);
stm_aix("p3i4","p1i0",[0,"Reporte de Evaluaciones","","",-1,-1,0,"/cfmx/edu/docencia/consultas/ListaEvalXProf.cfm","_self","Reporte de Evaluaciones","Reporte de Evaluaciones"]);
stm_ep();
stm_ep();
stm_em();
//-->
</script>


</td>
  </tr>
</table>
<cfset monitoreo_modulo="EDU DOC">
<cfinclude template="../monitoreo.cfm">
