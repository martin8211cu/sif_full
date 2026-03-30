<cfreturn>
<cfinclude template="../Utiles/queryMenu.cfm">
<table width='100%' border='0' cellspacing='0' cellpadding='0' >
  <tr>
    <td nowrap> 

<script type="text/javascript" language="JavaScript1.2">
<!--
stm_bm(["exnvfhr",400,"/cfmx/edu/js/DHTMLMenu/","blank.gif",0,"","",0,1,50,50,50,1,0,0]);
stm_bp("p0",[0,4,0,0,0,2,8,7,100,"",-2,"",-2,90,0,0,"#000000","#a0a0ba","",3,1,1,"#a0a0ba"]);
stm_ai("p0i0",[0,"Menú Principal","","",-1,-1,0,"","_self","","","","",5,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"#a0a0ba",0,"#a0a0ba",0,"","",3,3,1,1,"#a0a0ba","#666666","#ffffff","#ffffff","8pt Verdana","8pt Verdana",0,0]);
stm_bp("p1",[1,4,0,0,2,2,0,0,100,"",-2,"",-2,50,0,0,"#7f7f7f","#ffffff","",0,1,1,"#000000"]);
for (var contador=0; contador<menuPrincipalOptions.length-1; contador++) {
	stm_aix("p1i"+contador,"p0i0",[0,menuPrincipalOptions[contador][0],"","",-1,-1,0,menuPrincipalOptions[contador][1],"_self",menuPrincipalOptions[contador][0],menuPrincipalOptions[contador][0],"","",0,0,0,"","",0,0,0,0,1,"#ffffff",1,"#a0a0ba",0,"","",3,3,0,0,"#ffffff","#ffffff","#000000"]);
}
stm_ep();
stm_ai("p0i1",[6,1,"transparent","",0,0,0]);
stm_aix("p0i2","p0i0",[0,"Plan de Estudio","","",-1,-1,0,"","_self","","","","",8]);
stm_bpx("p2","p1",[1,4,0,0,2,2,8,0,100,"",-2,"",-2,50,0,0,"#000000"]);
stm_aix("p2i0","p1i0",[0,"Niveles","","",-1,-1,0,"/cfmx/edu/ced/plan/Nivel.cfm","_self","Niveles","Niveles"]);
stm_aix("p2i1","p1i0",[0,"Grados","","",-1,-1,0,"/cfmx/edu/ced/plan/Grado.cfm","_self","Grados","Grados","","",8]);
stm_aix("p2i2","p2i1",[0,"Períodos de Evaluación","","",-1,-1,0,"/cfmx/edu/ced/plan/PeriodoEvaluacion.cfm","_self","Períodos de Evaluación","Períodos de Evaluación"]);
stm_aix("p2i3","p2i1",[0,"Tipos de Curso Lectivo","","",-1,-1,0,"/cfmx/edu/ced/plan/PeriodoEscolar.cfm","_self","Tipos de Curso Lectivo","Tipos de Curso Lectivo"]);
stm_aix("p2i4","p2i1",[0,"Cursos Lectivos","","",-1,-1,0,"/cfmx/edu/ced/plan/listaSubPeriodoEscolar.cfm","_self","Cursos Lectivos","Cursos Lectivos"]);
stm_aix("p2i5","p2i1",[0,"Tipos de Materia","","",-1,-1,0,"/cfmx/edu/ced/plan/MateriaTipo.cfm","_self","Tipos de Materia","Tipos de Materia"]);
stm_aix("p2i6","p2i1",[0,"Conceptos de Evaluación","","",-1,-1,0,"/cfmx/edu/ced/plan/EvaluacionConcepto.cfm","_self","Conceptos de Evaluación","Conceptos de Evaluación"]);
stm_aix("p2i7","p2i1",[0,"Tablas de Evaluación","","",-1,-1,0,"/cfmx/edu/ced/plan/listaTablaEvaluac.cfm","_self","Tablas de Evaluación","Tablas de Evaluación"]);
stm_aix("p2i8","p2i1",[0,"Plan de Evaluación","","",-1,-1,0,"/cfmx/edu/ced/plan/listaEvaluacionPlan.cfm","_self","Plan de Evaluación","Plan de Evaluación"]);
stm_aix("p2i9","p2i1",[0,"Materias","","",-1,-1,0,"/cfmx/edu/ced/plan/Materias.cfm","_self","Materias","Materias"]);
stm_aix("p2i10","p2i1",[0,"Materias Complementarias","","",-1,-1,0,"/cfmx/edu/ced/plan/listaMateriasComplementarias.cfm","_self","Materias Complementarias","Materias Complementarias"]);
stm_aix("p2i11","p2i1",[0,"Materias Sustitutivas","","",-1,-1,0,"/cfmx/edu/ced/plan/listaMateriasSustitutivas.cfm","_self","Materias Sustitutivas","Materias Sustitutivas"]);
stm_aix("p2i12","p2i1",[0,"Materias Electivas","","",-1,-1,0,"/cfmx/edu/ced/plan/listaMateriasElectivas.cfm","_self","Materias Electivas","Materias Electivas"]);
stm_ep();
stm_aix("p0i3","p0i1",[6,1,"transparent","",1,1]);
stm_aix("p0i4","p0i0",[0,"Recurso","","",-1,-1,0,"","_self","","","","",8,0,0,"arrow_r.gif","arrow_r.gif",7,7,0,0,1,"#a0a0ba",0,"#a0a0ba",0,"","",3,3,1,1,"#a0a0ba","#a0a0ba"]);
stm_bpx("p3","p1",[]);
stm_aix("p3i0","p1i0",[0,"Infraestructura","","",-1,-1,0,"/cfmx/edu/ced/recurso/Infraestructura.cfm","_self","Infraestructura","Infraestructura"]);
stm_aix("p3i1","p1i0",[0,"Tipos de Horario","","",-1,-1,0,"/cfmx/edu/ced/plan/listaHorarioTipo.cfm","_self","Tipos de Horario","Tipos de Horario"]);
stm_aix("p3i2","p1i0",[0,"Calendario Escolar","","",-1,-1,0,"/cfmx/edu/ced/recurso/calendario.cfm","_self","Calendario Escolar","Calendario Escolar"]);
stm_aix("p3i3","p1i0",[0,"Recurso Humano","","",-1,-1,0,"/cfmx/edu/ced/recurso/rh.cfm","_self","Recurso Humano","Recurso Humano"]);
stm_aix("p3i4","p1i0",[0,"Biblioteca","","",-1,-1,0,"/cfmx/edu/ced/recurso/listaBiblioteca.cfm","_self","Biblioteca","Biblioteca"]);
stm_ep();
stm_aix("p0i5","p0i1",[]);
stm_aix("p0i6","p0i2",[0,"Alumnos"]);
stm_bpx("p4","p2",[]);
stm_aix("p4i0","p1i0",[0,"Mantenimiento de Promociones","","",-1,-1,0,"/cfmx/edu/ced/alumno/promociones.cfm","_self","Mantenimiento de Promociones","Mantenimiento de Promociones"]);
stm_aix("p4i1","p2i1",[0,"Proceso de Promoción","","",-1,-1,0,"/cfmx/edu/ced/alumno/PromocionProc.cfm","_self","Proceso de Promoción","Proceso de Promoción"]);
stm_aix("p4i2","p2i1",[0,"Alumnos","","",-1,-1,0,"/cfmx/edu/ced/alumno/alumno.cfm","_self","Alumnos","Alumnos"]);
stm_aix("p4i3","p2i1",[0,"Alumnos Retirados","","",-1,-1,0,"/cfmx/edu/ced/alumno/retirados.cfm","_self","Alumnos Retirados","Alumnos Retirados"]);
stm_aix("p4i4","p2i1",[0,"Alumnos Graduados","","",-1,-1,0,"/cfmx/edu/ced/alumno/Graduados.cfm","_self","Alumnos Graduados","Alumnos Graduados"]);
stm_aix("p4i5","p2i1",[0,"Matrícula Masiva","","",-1,-1,0,"/cfmx/edu/ced/alumno/MatriculaMasiva.cfm","_self","Matrícula Masiva","Matrícula Masiva"]);
stm_aix("p4i6","p2i1",[0,"Matrícula Individual","","",-1,-1,0,"/cfmx/edu/ced/alumno/MatriculaIndividual.cfm","_self","Matrícula Individual","Matrícula Individual"]);
stm_aix("p4i7","p2i1",[0,"Matrícula Extraordinaria","","",-1,-1,0,"/cfmx/edu/ced/alumno/MatriculaExtra.cfm","_self","Matrícula Extraordinaria","Matrícula Extraordinaria"]);
stm_ep();
stm_aix("p0i7","p0i1",[]);
stm_aix("p0i8","p0i2",[0,"Curso Lectivo"]);
stm_bpx("p5","p2",[1,4,0,0,2,2,0]);
stm_aix("p5i0","p1i0",[0,"Mantenimiento de Cursos","","",-1,-1,0,"/cfmx/edu/ced/cursolectivo/Cursos.cfm","_self","Mantenimiento de Cursos","Mantenimiento de Cursos"]);
stm_aix("p5i1","p1i0",[0,"Publicación de Notas","","",-1,-1,0,"/cfmx/edu/ced/plan/PublicarNotas.cfm","_self","Publicación de Notas","Publicación de Notas"]);
stm_ep();
stm_aix("p0i9","p0i1",[]);
stm_aix("p0i10","p0i2",[0,"Reportes"]);
stm_bpx("p6","p5",[]);
stm_aix("p6i0","p1i0",[0,"Alumnos por Grupo","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaEstudXGrupo.cfm","_self","Alumnos por Grupo","Alumnos por Grupo"]);
stm_aix("p6i1","p1i0",[0,"Cursos por Grupo","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListadoMateriasGrupo.cfm","_self","Cursos por Grupo","Cursos por Grupo"]);
stm_aix("p6i2","p1i0",[0,"Cursos por Profesor","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaCursosXProf.cfm","_self","Cursos por Profesor","Cursos por Profesor"]);
stm_aix("p6i3","p1i0",[0,"Horarios por Grupo","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListadoHorariosGrupo.cfm","_self","Horarios por Grupo","Horarios por Grupo"]);
stm_aix("p6i4","p1i0",[0,"Materias Electivas","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaMatElect.cfm","_self","Materias Electivas","Materias Electivas"]);
stm_aix("p6i5","p1i0",[0,"Encargados por Alumno","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaAlumnoEncar.cfm","_self","Encargados por Alumno","Encargados por Alumno"]);
stm_aix("p6i6","p1i0",[0,"Alumnos por Encargado","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaAlumnosXEncargado.cfm","_self","Alumnos por Encargado","Alumnos por Encargado"]);
stm_aix("p6i7","p1i0",[0,"Temarios y Evaluaciones","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaTemariosXCurso.cfm","_self","Temarios y Evaluaciones","Temarios y Evaluaciones"]);
stm_aix("p6i8","p1i0",[0,"Evaluaciones de Preescolar","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaEvalPree.cfm","_self","Evaluaciones de Preescolar","Evaluaciones de Preescolar"]);
stm_aix("p6i9","p1i0",[0,"Reporte de Progreso","","",-1,-1,0,"/cfmx/edu/ced/consultas/ProgressReport.cfm","_self","Reporte de Progreso","Reporte de Progreso"]);
stm_aix("p6i10","p1i0",[0,"Reporte de Evaluaciones","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaEvaluac.cfm","_self","Reporte de Evaluaciones","Reporte de Evaluaciones"]);
stm_aix("p6i11","p1i0",[0,"Reporte de Notas Finales","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaNotasFinales.cfm","_self","Reporte de Notas Finales","Reporte de Notas Finales"]);
stm_aix("p6i12","p1i0",[0,"Reporte de Progreso por Grupo","","",-1,-1,0,"/cfmx/edu/ced/consultas/ProgressReportGroup.cfm","_self","Reporte de Progreso por Grupo","Reporte de Progreso por Grupo"]);
stm_aix("p6i13","p1i0",[0,"Histórico de Evaluaciones de Preescolar","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaEvalPreeHist.cfm","_self","Histórico de Evaluaciones de Preescolar","Histórico de Evaluaciones de Preescolar"]);
stm_aix("p6i14","p1i0",[0,"Reporte de Aplazados y Mejores Promedios","","",-1,-1,0,"/cfmx/edu/ced/consultas/ListaPromedios.cfm","_self","Reporte de Aplazados y Mejores Promedios","Reporte de Aplazados y Mejores Promedios"]);
stm_ep();
stm_ep();
stm_em();
//-->
</script>

</td>
  </tr>
</table>
<cfset monitoreo_modulo="EDU">
<cfinclude template="../monitoreo.cfm">
