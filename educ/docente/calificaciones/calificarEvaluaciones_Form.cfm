<!--- 
ESTE PROGRAMA REGISTRA LAS CALIFICACIONES DE UN CURSO QUE DURA UNICAMENTE UN PERIODO:
	LAS CALIFICACIONES SE REGISTRAN EN CursoAlumnoEvaluacion
	LAS AMPLIACIONES SE REGISTRAN EN CursoAlumnoAmpliacion
	LOS PROMEDIOS SE ALMACENAN EN CursoAlumno
	(CursoAlumnoPeriodo NO SE TOMA EN CUENTA)
 --->
<cfset GvarDiv = find("MSIE",CGI.HTTP_USER_AGENT) gt 0 and find("Windows",CGI.HTTP_USER_AGENT) gt 0>
<cfset GvarDiv = find("Mac",CGI.HTTP_USER_AGENT) eq 0>

<cfinclude template="commonDocencia.cfm">

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar")); 
  sbInitFromCookie("cboOrdenamiento", "0");
  sbInitFromCookie("cboXAlumno", "0");
  sbInitFromCookieChks("chkCalcular","1");
</cfscript> 
<cfcookie name="docencia.chkCalcular" value="#Form.chkCalcular#" expires="never">
<cfcookie name="docencia.cboOrdenamiento" value="#Form.cboOrdenamiento#" expires="never">
<cfcookie name="docencia.cboXAlumno" value="#Form.cboXAlumno#" expires="never">

<cfinclude template="qrysProfesorCursoPeriodo.cfm">

<cfif qryCursos.recordCount EQ 0>
  <div align="center">
  	<strong>El profesor no tiene cursos asignados</strong>
  </div>
  <cfexit>
</cfif>

<cfquery datasource="#Session.DSN#" name="qryCurso">
    set nocount on
    select 	convert(varchar,m.Mcodigo) as Mcodigo,
			convert(varchar,c.Ccodigo) as Ccodigo,
			m.MtipoCicloDuracion,
			c.PEcodigo,
			PEnombre + ' de ' + PLnombre as Periodo,
		 	c.CtipoCalificacion, 
			isnull(c.CpuntosMax, 0.0000) as CpuntosMax, 
			isnull(c.CunidadMin, 0.0000) as CunidadMin, 
			isnull(c.Credondeo, 0.0000) as Credondeo,
			c.TEcodigo,
			c.Cestado, c.CestadoCalificacion,
			tr.TRcantidadAmpliacion, trrA.TRRminimo TRRminimoAprobacion, trrB.TRRminimo TRRminimoAmpliacion
      from Curso c, Materia m
	     , PeriodoLectivo pl, PeriodoEvaluacion pe
		 , TablaResultado tr, TablaResultadoRango trrA, TablaResultadoRango trrB
     where c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and c.Mcodigo = m.Mcodigo
	   and c.PLcodigo = pl.PLcodigo
	   and c.PEcodigo = pe.PEcodigo
	   and tr.TRcodigo = c.TRcodigo
	   and trrA.TRcodigo = tr.TRcodigo
	   and trrA.TRRtipo = '1' <!--- Aprobado --->
	   and trrB.TRcodigo = tr.TRcodigo
	   and trrB.TRRtipo = '2' <!--- Aplazado --->
    set nocount off
</cfquery>

<cfif qryCurso.MtipoCicloDuracion EQ 'L'>
	IR A CALIFICAR CURSO POR PERIODO LECTIVO
	<cfabort>
</cfif>

<cfset GvarCursoTipoCalificacion = qryCurso.CtipoCalificacion>
<cfif qryCurso.CtipoCalificacion EQ "T">
	<cfset GvarTablaMateria = qryCurso.TEcodigo>
<cfelse>
	<cfset GvarTablaMateria = "">
</cfif>
<cfif qryCurso.recordCount GT 0>
	<cfset session.Ccodigo = qryCurso.Ccodigo>
	<cfset session.PEcodigo = qryCurso.PEcodigo>
<cfelse>
	<cfset session.Ccodigo = -1>
	<cfset session.PEcodigo = -1>
</cfif>

<cfquery datasource="#Session.DSN#" name="qryValoresTabla">
  set nocount on
  select convert(varchar,TEcodigo) as Tabla, TEVvalor as Codigo, TEVnombre as Descripcion, 
  	     TEVequivalente as EVorden, 
         TEVequivalente as Equivalente, TEVminimo as Minimo, TEVmaximo as Maximo
    from TablaEvaluacionValor vt
   where exists(
           select *
             from CursoEvaluacion cev
            where cev.Ccodigo    = #session.Ccodigo#
              and cev.PEcodigo   = #session.PEcodigo#
              and cev.CEVtipoCalificacion = 'T'
			  and cev.TEcodigo   = vt.TEcodigo
		   )
   or    exists(
           select *
             from CursoAmpliacion cam
            where cam.Ccodigo    = #session.Ccodigo#
              and cam.CAMtipoCalificacion = 'T'
			  and cam.TEcodigo   = vt.TEcodigo
		   )
      <cfif GvarTablaMateria neq "">
      or vt.TEcodigo = #GvarTablaMateria#
	  </cfif>		   
  set nocount off
</cfquery>

<cfif isDefined("form.btnGrabar")>
  <cfinclude template="calificarEvaluaciones_SQL.cfm">
</cfif>

<cfquery datasource="#Session.DSN#" name="qryComponentes">
  set nocount on
  select convert(varchar,ce.CEcodigo) as CEcodigo,      ce.CEnombre as CEnombre,   
  	     str(cce.CCEporcentaje,6,2) as CCEporcentaje, 	cce.CCEorden as OrdenEC,
         convert(varchar,cev.CEVcodigo) as CEVcodigo, 	cev.CEVnombre as CEVnombre, 
		 str(cev.CEVpeso,6,2) as CEVpeso, 
		 str(cce.CCEporcentaje*cev.CEVpeso/100.0,6,2) as CEVaporte,
		 cce.CCEporcentaje*cev.CEVpeso/100.0 as CEVaporteNum,
		 cev.CEVestado, 
		 cev.CEVtipoCalificacion, isnull(cev.CEVpuntosMax,0) as CEVpuntosMax, cev.CEVunidadMin, cev.CEVredondeo, cev.TEcodigo
    from CursoConceptoEvaluacion cce, 
         ConceptoEvaluacion ce, 
         CursoEvaluacion cev
   where cce.Ccodigo    = #session.Ccodigo#
     and cce.PEcodigo   = #session.PEcodigo#
     and ce.CEcodigo    = cce.CEcodigo
     and cev.Ccodigo    = cce.Ccodigo
     and cev.PEcodigo   = cce.PEcodigo
     and cev.CEcodigo    = cce.CEcodigo
  <cfif form.cboOrdenamiento eq 0>
  order by isnull(cev.CEVfechaReal, cev.CEVfechaPlan), cce.CCEorden, cev.CEVcodigo
  <cfelseif form.cboOrdenamiento eq 1>
  order by cce.CCEorden, cev.CEVcodigo
  <cfelseif form.cboOrdenamiento eq 2>
  order by cev.CEVcodigo
  </cfif>
  set nocount off
</cfquery>

<cfquery dbtype="query" name="qryConceptos">
  select distinct CEcodigo, CEnombre, CCEporcentaje
    from qryComponentes
  order by OrdenEC
</cfquery>

<cfquery datasource="#Session.DSN#" name="qryEstudiantes">
  set nocount on
  select convert(varchar,ca.Apersona) as Codigo, 
  	     p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre, 
         str(ca.CAporcAjuste,6,2) as CAporcAjuste, 
		 ca.CAnotaAjuste,
		 ca.CAnotaFinal
    from CursoAlumno ca, 
         Alumno p
   where ca.Ccodigo      = #session.Ccodigo#
     and ca.Apersona = p.Apersona
     and ca.CAestado <> 10
  order by p.Papellido1, p.Papellido2, p.Pnombre
  set nocount off
</cfquery>
<cfquery datasource="#Session.DSN#" name="qryNotas">
  set nocount on
  select convert(varchar,ca.Apersona) as Estudiante, 
  		 cae.CAEnota, 
		 cev.CEVestado, cev.CEVtipoCalificacion, isnull(cev.CEVpuntosMax,0) as CEVpuntosMax, cev.CEVunidadMin, cev.CEVredondeo,
  	     convert(varchar,cev.TEcodigo) as Tabla,
		 cev.CEVfechaReal, cev.CEVfechaPlan, cce.CCEorden, cev.CEVcodigo
    from Curso c,                          -- Curso
         CursoConceptoEvaluacion cce,      -- Conceptos de Evaluación de un Curso
         ConceptoEvaluacion ce,            -- Catalogo Conceptos de Evaluación
		 CursoEvaluacion cev,              -- Componentes del Concepto de Evaluación de un Curso
         CursoAlumno ca,   				   -- Alumnos de un Curso
         CursoAlumnoEvaluacion cae,        -- Calificaciones Alumno por Componente
		 Alumno a
   where c.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
     and c.Ccodigo      = #session.Ccodigo#

     and cce.Ccodigo    = c.Ccodigo
     and cce.PEcodigo   = #session.PEcodigo#
	 and cce.CEcodigo   = ce.CEcodigo

     and cev.Ccodigo    = cce.Ccodigo
     and cev.PEcodigo   = cce.PEcodigo
	 and cev.CEcodigo   = cce.CEcodigo

	 and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
     and ca.Ccodigo      = #session.Ccodigo#
     and ca.Apersona     = a.Apersona
     and ca.CAestado <> 10

     and cae.Ccodigo      =* cev.Ccodigo
     and cae.PEcodigo     =* cev.PEcodigo
     and cae.CEVcodigo    =* cev.CEVcodigo
     and cae.Apersona     =* ca.Apersona
  order by a.Papellido1, a.Papellido2, a.Pnombre,
  <cfif form.cboOrdenamiento eq 0>
           isnull(cev.CEVfechaReal, cev.CEVfechaPlan), cce.CCEorden, cev.CEVcodigo
  <cfelseif form.cboOrdenamiento eq 1>
           cce.CCEorden, cev.CEVcodigo
  <cfelseif form.cboOrdenamiento eq 2>
           cev.CEVcodigo
  </cfif>
  set nocount off
</cfquery>
<cfif qryCurso.CestadoCalificacion GTE "2">
	<cfquery datasource="#Session.DSN#" name="qryAmpliaciones">
	  set nocount on
	  select cam.CAMsecuencia, 
			 cam.CAMtipoCalificacion, isnull(cam.CAMpuntosMax,0) as CAMpuntosMax, cam.CAMunidadMin, cam.CAMredondeo, cam.TEcodigo
		from CursoAmpliacion cam
	   where cam.Ccodigo    = #session.Ccodigo#
	  order by CAMsecuencia
	  set nocount off
	</cfquery>
	<cfif qryAmpliaciones.recordCount lt qryCurso.TRcantidadAmpliacion>
		<cfquery datasource="#Session.DSN#">
			<cfloop index="i" from="1" to="#qryCurso.TRcantidadAmpliacion#">
			  if not exists(select * from CursoAmpliacion where Ccodigo=#session.Ccodigo# and CAMsecuencia=#i#)
				insert into CursoAmpliacion (Ccodigo, CAMsecuencia, CAMtipoCalificacion, CAMpuntosMax, CAMunidadMin, CAMredondeo, TEcodigo)
				select Ccodigo, #i#, CtipoCalificacion, CpuntosMax, CunidadMin, Credondeo, TEcodigo
				  from Curso
				 where Ccodigo = #session.Ccodigo#
			</cfloop>
		</cfquery>
		<cfquery datasource="#Session.DSN#" name="qryAmpliaciones">
		  set nocount on
		  select cam.CAMtipoCalificacion, isnull(cam.CAMpuntosMax,0) as CAMpuntosMax, cam.CAMunidadMin, cam.CAMredondeo, cam.TEcodigo
			from CursoAmpliacion cam
		   where cam.Ccodigo    = #session.Ccodigo#
		  order by CAMsecuencia
		  set nocount off
		</cfquery>
	</cfif>
	
	<cfquery datasource="#Session.DSN#" name="qryNotasAmpliacion">
	  set nocount on
	  select convert(varchar,ca.Apersona) as Estudiante, 
			 caa.CAAnota, isnull(caa.CAAporcentaje*100,0) as CAAporcentaje,
			 cam.CAMtipoCalificacion, isnull(cam.CAMpuntosMax,0) as CAMpuntosMax, cam.CAMunidadMin, cam.CAMredondeo,
			 convert(varchar,cam.TEcodigo) as Tabla,
			 cam.CAMfechaReal, cam.CAMfechaPlan, cam.CAMsecuencia,
			 isnull(ca.CAporcProgreso*100,0) as CAporcProgreso
		from Curso c,                          -- Curso
			 CursoAmpliacion cam,              -- Componentes del Concepto de Evaluación de un Curso
			 CursoAlumno ca,   				   -- Alumnos de un Curso
			 CursoAlumnoAmpliacion caa,        -- Calificaciones Alumno por Componente
			 Alumno a
	   where c.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		 and c.Ccodigo      = #session.Ccodigo#
	
		 and cam.Ccodigo    =* c.Ccodigo
	
		 and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		 and ca.Ccodigo      = #session.Ccodigo#
		 and ca.Apersona     = a.Apersona
	     and ca.CAestado <> 10

		 and caa.Ccodigo      =* cam.Ccodigo
		 and caa.CAMsecuencia =* cam.CAMsecuencia
		 and caa.Apersona     =* ca.Apersona
	  order by a.Papellido1, a.Papellido2, a.Pnombre, cam.CAMsecuencia
	  set nocount off
	</cfquery>
</cfif>
<cfset LvarBorder = "border=1px solid ##CCCCCC;">
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        background-color: #FF0000;
        WIDTH: 20px;
        HEIGHT:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
        display: none;
      }
      .txtPar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        border:0;
      }
      .txtImpar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        background-color:#D8E5F2;
        border:0;
      }
      .linEnc {
        background-color:#A9C6E1;
        height:38px; width:51px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : center;
        vertical-align : middle;
      }
      .linEncPrc {
        background-color:#A9C6E1;
        height:40px; width:51px;
        font:  normal 10px Verdana, Arial, Helvetica, sans-serif;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : center;
        vertical-align : middle;
      }
      .linEncProm {
        background-color:#A9C6E1;
        height:19px;
        font:  normal 10px Verdana, Arial, Helvetica, sans-serif;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : right;
      }
      .linEncEva {
        background-color:#A9C6E1;
        width:100%;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        text-align : center;
        vertical-align : middle;
      }
      .linPar {
		border: solid 1px #D8E5F2;
		height: 21px;
		font:  10px Verdana, Arial, Helvetica, sans-serif;
		wrap:  none;
      }
      .linImpar {
        background-color:#D8E5F2; 
		border: solid 1px #D8E5F2; 
		height: 21px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
      }
    -->
    </style>
<script language="JavaScript" src="/cfmx/educ/docente/calificaciones/commonDocencia1_00.js"></script>
<script language="JavaScript" src="/cfmx/educ/docente/calificaciones/calificarEvaluaciones1_00.js"></script>
<script language="JavaScript" type="text/JavaScript">
    <!--

      var GvarRow1 = 4;
      var GvarRowN = 2;
      var GvarRowAlumno = -1;
      var GvarProIndex = 0;
      var GvarCurIndex = 0;
      var GvarPerIndex = 0;
      var GvarOrdIndex = 0;

      GvarValueAnt = "";
      GvarRowAnt = -1;

      // Uno por Concepto
      var GvarConceptos = new Array();
      <cfset LvarCount=0>
      <cfoutput query="qryConceptos">
        <cfset LvarCount=LvarCount+1>
        GvarConceptos["C#CEcodigo#"] = #CCEporcentaje#;
      </cfoutput>
	  <cfoutput>
      var GvarConceptosN = #LvarCount#;
	  <cfif qryCurso.CestadoCalificacion GTE "2">
	  var GvarAmpliacionesN = #qryCurso.TRcantidadAmpliacion#;
	  </cfif>
	  </cfoutput>
	
      // Uno por Estudiante
      var GvarConceptosXEstudiantes = new Array();
      var GvarEstudiantesN = <cfoutput>#qryEstudiantes.RecordCount#</cfoutput>;

      // Uno por Calficacion
      var GvarComponentes = new Array(
      <cfset LvarTotPlaneado=0>
      <cfoutput query="qryComponentes">
        <cfset LvarTotPlaneado=LvarTotPlaneado + CEVaporteNum>
        <cfif currentRow eq 1>
            new objCalificacion("C#CEcodigo#",#CEVpeso#,#CEVaporte#,"#CEVtipoCalificacion#",#CEVpuntosMax#)
        <cfelse>
          , new objCalificacion("C#CEcodigo#",#CEVpeso#,#CEVaporte#,"#CEVtipoCalificacion#",#CEVpuntosMax#)
        </cfif>
      </cfoutput>
        );
      var GvarComponentesN = GvarComponentes.length;
      var GvarPlaneado = <cfif round(LvarTotPlaneado*100)/100.0 eq 100.0><cfset GvarPlaneado=true>true<cfelse><cfset GvarPlaneado=false>false</cfif>;
	  
<cfif GvarTablaMateria neq "">
      <cfquery dbtype="query" name="qryValoresMateria">
       select Codigo, Equivalente, Minimo, Maximo, Descripcion
         from qryValoresTabla
        where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarTablaMateria#">
        order by EVorden desc
      </cfquery>
      var GvarTablaMateria = new Array (
	  <cfoutput query="qryValoresMateria">
        <cfif currentRow eq 1>
            new objTabla("#Codigo#",#Equivalente#,#Minimo#,#Maximo#,"#Descripcion#")
        <cfelse>
          , new objTabla("#Codigo#",#Equivalente#,#Minimo#,#Maximo#,"#Descripcion#")
        </cfif>
      </cfoutput>
        );
      function objTabla(Codigo, Valor, Min, Max, Descripcion)
      {
          this.Codigo = Codigo;
          this.Valor  = Valor;
          this.Min    = Min;
          this.Max    = Max;
		  this.Descripcion = Descripcion;
      }
<cfelse>
      var GvarTablaMateria = "";
</cfif>
<cfif qryCurso.recordCount GT 0>
<cfoutput>
      var GvarCursoTipoCalificacion = "#qryCurso.CtipoCalificacion#";
      var GvarCursoPuntosMax = #qryCurso.CpuntosMax#;
      var GvarCursoUnidadMin = #qryCurso.CunidadMin#;
      var GvarCursoRedondeo = #qryCurso.Credondeo#;
	  var GvarMinimoAprobacion = #qryCurso.TRRminimoAprobacion#;
</cfoutput>
</cfif>

      function fnInicializarCalculos(LvarEst)
	  {
        GvarConceptosXEstudiantes[LvarEst] = new objConceptoXEstudiante (new Array(), 0);
        <cfoutput query="qryConceptos">
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C#CEcodigo#"] = new objCXE(0,0,0);
        </cfoutput>
	  }
    -->
    </script>
<form name="frmNotas" method="post" action=""
          style="font:10px Verdana, Arial, Helvetica, sans-serif; margin=0">
<table width="865">
  <tr>
    <td width="99%" valign="top">
		<table>
		  <tr>
			<td>
			  Profesor: 
			  <select name="cboProfesor" id="cboProfesor"
					  style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					  onChange='javascript: if (this.value != "-999") fnReLoad();'>
				  <cfif isdefined("RolActual") and RolActual EQ 11><option value="-999"></option></cfif>
				<cfset LvarSelected="0">
				<cfoutput query="qryProfesores">
				  <option value="#Codigo#"<cfif #form.cboProfesor# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
				</cfoutput>			  
				<cfif #LvarSelected# eq "0">
				  <cfset form.cboProfesor="-999">
				</cfif>
			  </select>
			  Curso:
			  <select name="cboCurso" id="cboCurso" 
					  style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					  onChange='javascript: if (this.value != "-999") fnReLoad();'>
				<option value="-999"></option>
				<cfset LvarSelected="0">
				<cfoutput query="qryCursos">
				  <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
				</cfoutput>
				<cfif #LvarSelected# eq "0">
				  <cfset form.cboCurso="-999">
				</cfif>
			  </select>
			  <BR>
			  Período:&nbsp; 
			  <cfif true>
			  <cfoutput>#qryCurso.Periodo#</cfoutput>
			  <cfelse>
			  <select name="cboPeriodo" id="cboPeriodo" 
					  style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					  onChange='javascript: if (this.value == "-999") 
								  fnLoadcalificarCurso();
								else
								  fnReLoad();'>
				<cfoutput query="qryPeriodos">
				  <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected</cfif>>#Descripcion#</option>
				</cfoutput>			  
			  </select>
			  </cfif>
			  <BR>
			  <BR>
		
			  <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
				</td></tr></table>
				</td></tr></table>
				<cfexit>
			  </cfif>
			  <cfoutput>
				<input type="hidden" name="txtRows" id="txtRows" value="#qryEstudiantes.recordCount#">
				<input type="hidden" name="txtCols" id="txtCols" value="#qryComponentes.recordCount#">
				<cfif qryCurso.CestadoCalificacion GTE "2">
				<input type="hidden" name="txtColsAmpl" id="txtColsAmpl" value="#qryCurso.TRcantidadAmpliacion#">
				</cfif>
			  </cfoutput>
			</td>
		  </tr>
			<cfif qryEstudiantes.RecordCount NEQ 0>
			<tr>
				  <td colspan="5">
						<input name="btnGrabar" id="btnGrabar" type="submit" value="Guardar Cambios" disabled onClick="javascript: if (!document.getElementById('chkCalcular').checked) fnProcesoInicial();action='calificarEvaluaciones_SQL.cfm'">
						<input name="chkDesecharCambios" id="chkDesecharCambios" type="checkbox" value="1" checked onClick="document.frmNotas.btnGrabar.disabled=document.frmNotas.chkDesecharCambios.checked;">
						Desechar Cambios&nbsp;&nbsp;&nbsp; 
						<cfif qryCurso.CestadoCalificacion EQ "1">
						<input name="btnAmpliacion" type="submit" value="Cerrar Calificaciones" onClick="javascript: return fnCerrarPeriodo(1);">
						<cfelseif qryCurso.CestadoCalificacion EQ "2">
						<input name="btnAbrir" type="submit" value="Abrir Calificaciones" onClick="javascript: return fnCerrarPeriodo(2);">
						<input name="btnCerrar" type="submit" value="Cerrar Curso" onClick="javascript: return fnCerrarPeriodo(3);">
						<cfelse>
						<input name="btnReAbrir" type="submit" value="Abrir Curso" onClick="javascript: return fnCerrarPeriodo(0);">
						</cfif>
				  </td> 
			</tr>
			</cfif>
		</table>
	</td>
	<cfif qryEstudiantes.RecordCount NEQ 0>
	<td valign="top" width="1%">
		<table>
			<tr>
				<td nowrap>Ordenar Evaluaciones:</td>
				<td align="left">
				  <div align="left">
					<select name="cboOrdenamiento" id="cboOrdenamiento" size="1" 
						  style="font:10px Verdana, Arial, Helvetica, sans-serif;"
						  onChange="javascript: fnReLoad();">
					  <option value="0"<cfif form.cboOrdenamiento eq "0"> selected</cfif>>Cronológico</option>
					  <option value="1"<cfif form.cboOrdenamiento eq "1"> selected</cfif>>Por Concepto</option>
					</select>
					</div></td>
			</tr>
			<tr>
				<td nowrap>Digitar calificaciones:</td>
				<td align="left">
					<div align="left">
					  <select name="cboXAlumno" id="cboXAlumno" size="1" 
						style="font:10px Verdana, Arial, Helvetica, sans-serif;">
						<option value="0" <cfif form.cboXAlumno EQ 0>selected</cfif>>Por Evaluacion</option>
						<option value="1" <cfif form.cboXAlumno EQ 1>selected</cfif>>Por Alumno</option>
					  </select>
					</div></td>
			</tr>
			<tr>
				<td nowrap>Calcular en Linea:</td>
				<td align="left">
					<div align="left">
					  <input type="hidden" name="hdnChkCalcular" value="">
					  <input type="checkbox" name="chkCalcular" id="chkCalcular" style="font:10px Verdana, Arial, Helvetica, sans-serif;"
								  <cfif form.chkCalcular eq "1">checked</cfif>
								  onClick="fnChkCalcular();" value="1">
					  </div></td>
			</tr>
		</table>
	</td>
	</cfif>
	</tr>
</table>
    <cfif qryEstudiantes.RecordCount eq 0>
		<table>
		  <tr><td bgcolor="#A9C6E1">No existen alumnos matriculados en este curso, FAVOR COMUNIQUESE CON LA ADMINISTRACION</td></tr>
		</table>
	<cfelse>
    <table style="border:none; padding:0; margin:0"><tr><td style="color:#0000FF; font-size:12px; font-weight:bold">
    <cfif qryCurso.CestadoCalificacion EQ "1">
		<cfif #qryConceptos.RecordCount# eq 0>
			El curso está en proceso de Calificación de Evaluaciones pero no ha sido planeado para el período indicado
		<cfelseif not GvarPlaneado>
			El curso está en proceso de Calificación de Evaluaciones pero no se ha terminado de planear para el período indicado
		<cfelse>
			El curso está en proceso de Calificación de Evaluaciones
		</cfif>
    <cfelseif qryCurso.CestadoCalificacion EQ "2">
		El curso está en proceso de <cfif qryCurso.TRcantidadAmpliacion>Calificación de Ampliaciones y </cfif>Ajustes Finales
	<cfelse>
		El curso está Cerrado
	</cfif>
	</td></tr></table>
	
<cfset LvarNoLockMaloT = false>
<table border="0" width="100%">
	<tr>
	<td valign="top">
		<!--- INICIO DE TABLAS SINCRONIZADAS EN 3 TDs--->
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<!--- TABLA DE ESTUDIANTES --->
				<td width="150" valign="top">
					<div style="width:150px; overflow:hidden; border-right:1px solid #FFFFFF">
						<table id="tblEstudiantes" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="150" class="linEnc" style="text-align:left;">Estudiante</td>
							</tr>
							<tr>
								<td width="150" class="linEncProm" style="text-align:Left;">Tipo Calificacion<BR>&nbsp;</td>
							</tr>
							<tr>
								<td width="150" class="linEncProm" style="text-align:Left;">
								<cfif qryCurso.CestadoCalificacion EQ "1">
									Cerrar Evaluaci&oacute;n
								</cfif>
								</td>
							</tr>
							<tr class="tdInvisible">
								<td></td>
							</tr>
							<cfset LvarPar="Impar">
						<cfoutput query="qryEstudiantes">
							<cfif LvarPar eq "Impar"><cfset LvarPar="Par"><cfelse><cfset LvarPar="Impar"></cfif>
							<tr onClick="fnRefrescarTblConceptos(this.rowIndex);">
								<td class="lin#LvarPar#" nowrap style="cursor:pointer">#Nombre#</td>
								<td><input type="hidden" name="txtApersona#currentRow#" id="txtApersona#currentRow#" value="#Codigo#"></td>
							</tr>
						</cfoutput>
							<tr>
								<td class="linEncProm" style="text-align:Left; font-weight:bold;" onDblClick="return fnVerPrms();">Promedio</td>
							</tr>
							<tr id="trprm1">
								<td style="height:20px;">&nbsp;</td>
							</tr>
						</table>
					</div>
				</td>
				<!--- TABLA DE NOTAS --->
				<td id="tdWidthNotas" valign="top" style="border: none; padding: 0px; margin: 0px; ">
				<cfset tam = 0>
				<cfif qryComponentes.recordCount GT 3>
					<cfset tam = 204>
				<cfelse>
					<cfset tam = qryComponentes.recordCount * 51>
				</cfif>
				<cfif GvarDiv>
					<DIV id="divWidthNotas" style="BORDER: none; border-right: solid #FFFFFF 1px;PADDING: 0px; MARGIN: 0px; WIDTH: <cfoutput>#tam#</cfoutput>px; OVERFLOW:auto;">
				</cfif>
						<table id="tblNotas" border="0" cellspacing="0" cellpadding="0">
							<tr>
							<cfoutput query="qryComponentes">
								<cfif CEVtipoCalificacion EQ "T">
									<cfquery dbtype="query" name="qryValores">
										select Codigo, Equivalente, Minimo, Maximo
										  from qryValoresTabla
										 where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryComponentes.TEcodigo#">
										 order by EVorden desc
									</cfquery>
								</cfif>
								<td class="linEnc">
									<div onClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden; cursor:pointer; text-decoration:underline" 
									title=
"Concepto Evaluación: 	#CEnombre# (#CCEporcentaje#% ) 
Evaluacion a Calificar:    	#CEVnombre# (#CEVpeso#% )
Contribución Promedio:	#CEVpeso#%  de #CCEporcentaje#%  = #CEVaporte#%
Tipo de Calificacion:      	<cfif CEVtipoCalificacion EQ "1">Porcentual de 0% a 100%<cfelseif CEVtipoCalificacion EQ "2">Puntaje de 0 a #CEVpuntosMax# puntos<cfelse>Tabla de Evaluacion</cfif>
<cfif CEVtipoCalificacion EQ "T">
	<cfloop query="qryValores">#Codigo# = #Equivalente#%
	</cfloop>
</cfif>">
										#CEVnombre#
									</div>
								</td>
							</cfoutput>			  
							</tr>
							<tr class="linEncProm">
							<cfoutput query="qryComponentes">
								<cfif CEVtipoCalificacion EQ "1">
								<td class="linEncProm" style="text-align:center;">hasta<BR>#CEVpuntosMax#%</td>
								<cfelseif CEVtipoCalificacion EQ "2">
								<td class="linEncProm" style="text-align:center;">hasta<BR>#numberformat(CEVpuntosMax,"0")#pts</td>
								<cfelseif CEVtipoCalificacion EQ "T">
								<td class="linEncProm" style="text-align:center;">Valor<BR>Tabla</td>
								</cfif>
							</cfoutput>			  
							</tr>
							<tr class="linEncProm">
							<cfoutput query="qryComponentes">
								<td class="linEncProm"> 
									<input name="chkCerrar#currentRow#" id="chkCerrar#currentRow#" type="checkbox" 
										value="1"
										class="linEncProm" style="border:0px"
										<cfif qryComponentes.CEVestado neq "1" or qryCurso.CestadoCalificacion neq "1">checked</cfif>
										<cfif qryCurso.CestadoCalificacion neq "1">disabled</cfif>
										onClick="fnCerrarComponente(this,event);"> 
									<input name="hdnCerrar#currentRow#" id="hdnCerrar#currentRow#" type="hidden" 
										value="<cfif qryCurso.CestadoCalificacion neq "1">2<cfelse>#CEVestado#</cfif>">
								</td>
							</cfoutput>			  
							</tr>
							<tr class="tdInvisible">
							<cfoutput query="qryComponentes">
								<td class="tdInvisible" style="width:101; height:15px";>
									<input type="text" name="txtCEVcodigo#currentRow#" id="txtCEVcodigo#currentRow#" value="#CEVcodigo#" class="tdInvisible">
									<input type="text" name="txtCEVtipoCalificacion#currentRow#" id="txtCEVtipoCalificacion#currentRow#" value="#CEVtipoCalificacion#" class="tdInvisible">
									<cfif CEVtipoCalificacion EQ "T">
										<input type="text" name="txtTEcodigo#currentRow#" id="txtTEcodigo#currentRow#" class="tdInvisible" value="#TEcodigo#">
									<cfelseif CEVtipoCalificacion EQ "2">
										<input type="text" name="txtCEVpuntosMax#currentRow#" id="txtCEVpuntosMax#currentRow#" class="tdInvisible" value="#CEVpuntosMax#">
									</cfif>
								</td>
							</cfoutput>			  
							</tr>
							<cfset LvarLins=qryEstudiantes.RecordCount>
							<cfset LvarCols=qryComponentes.RecordCount>
							<cfset LvarLin=1>
							<cfset LvarCol=1>
							<cfset LvarPar="Par">
							<tr>
							<cfoutput>
							<cfloop query="qryNotas">
								<td class="lin#LvarPar#">
								<cfif CEVtipoCalificacion NEQ "T">
									<input type="text" name="txtNota#LvarLin#_#LvarCol#" id="txtNota#LvarLin#_#LvarCol#" maxlength="6"
										class="txt#LvarPar#"
										onFocus="return fnFocus(this,event);"
										onBlur="return fnAjustarNota(this, event, '#CEVtipoCalificacion#', #CEVpuntosMax#, #CEVunidadMin#, #CEVredondeo#);"
										onKeyDown="return fnKeyDown(this, event);"
										onKeyPress="return fnKeyPressNum(this, event);"
										<cfif CEVestado neq "1" or qryCurso.CestadoCalificacion neq "1">Readonly<cfelse>style="#LvarBorder#;"</cfif>
										
										value="#replace(replace(CAEnota,"%",""),"pts","")#">
								<cfelse>
									<select name="cboValor#LvarLin#_#LvarCol#" id="cboValor#LvarLin#_#LvarCol#"
										class="txt#LvarPar#"
										<cfif CEVestado neq "1" or qryCurso.CestadoCalificacion neq "1">onChange="javascript: this.value = GvarValueAnt;"</cfif>
										onFocus="return fnFocus(this,event);"
										onBlur="return fnAjustarNota(this, event, '#CEVtipoCalificacion#');"
										onKeyDown="return fnKeyDown(this, event);"
										onKeyPress="return fnKeyPressNum(this, event);">
										<option value=""<cfif CAEnota eq ""> selected</cfif>>&nbsp;</option>
										<cfset LvarNota = CAEnota>
										<cfloop query="qryValores">
										<option value="#Equivalente#"<cfif compareNoCase(trim(LvarNota),trim(Codigo)) EQ 0> selected</cfif>>#Codigo#</option>
										</cfloop>
									</select>
								</cfif>
								</td>
								<cfif CurrentRow mod LvarCols is 0 and CurrentRow neq recordCount>
									<cfset LvarLin=LvarLin+1>
									<cfset LvarCol=0>
									<cfif LvarPar neq "Par">
										<cfset LvarPar="Par">
									<cfelse>
										<cfset LvarPar="Impar">
									</cfif>
							</tr>
							<tr>
								</cfif>
								<cfset LvarCol=LvarCol+1>
							</cfloop>
							</cfoutput>
							</tr>
							<tr>
							<cfloop from="1" index="i" to="#qryComponentes.RecordCount#">
								<td class="linEncProm">0.00</td>
							</cfloop>
							</tr>
						</table>
				<cfif GvarDiv>
					</DIV>
				</cfif>
          		</td>
				<!--- TABLA DE PROMEDIOS --->
				<td width="51" valign="top">
					<table id="tblPromedios" border="0" cellspacing="0" cellpadding="0">
						<cfif qryCurso.CestadoCalificacion NEQ "1">
							<cfset LvarEsconder="style=""display:none""">
						<cfelse>
							<cfset LvarEsconder="">
						</cfif>
						<cfoutput>
						<tr>
							<td class="linEnc" width="101" #LvarEsconder#>Ganado</td>
							<td class="linEnc" width="101">Progreso</td>
						</tr>
						<tr>
							<td class="linEncProm" width="101" #LvarEsconder#>&nbsp;<br>&nbsp;</td>
							<td class="linEncProm" width="101">&nbsp;<br>&nbsp;</td>
						</tr>
						<tr>
							<td class="linEncProm" width="101" #LvarEsconder#>&nbsp;</td>
							<td class="linEncProm" width="101">&nbsp;</td>
						</tr>
						<tr class="tdInvisible">
							<td #LvarEsconder#></td>
							<td></td>
						</tr>
					</cfoutput>
					<cfset LvarPar="Impar">
					<cfoutput query="qryEstudiantes">
						<cfif LvarPar eq "Par"><cfset LvarPar="Impar"><cfelse><cfset LvarPar="Par"></cfif>
						<tr class="lin#LvarPar#">
							<td width="101" class="lin#LvarPar#" #LvarEsconder#>
								<input type="text" class="txt#LvarPar#" 
										name="txtGanado#CurrentRow#" id="txtGanado#CurrentRow#"
										readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
										onFocus="fnFocus(this,event);this.style.border='0px solid';"
										value="0">
							</td>
							<td width="101" class="lin#LvarPar#">
								<input type="text" class="txt#LvarPar#" 
										name="txtProgreso#CurrentRow#" id="txtProgreso#CurrentRow#"
										readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
										onFocus="fnFocus(this,event);this.style.border='0px solid';"
										value="0">
							</td>
						</tr>
					</cfoutput>
						<tr>
							<td class="linEncProm" <cfoutput>#LvarEsconder#</cfoutput>></td>
							<td class="linEncProm" style="text-align=center; font-weight:bold; color:#0000FF;"></td>
						</tr>
					</table>
				</td>
				<!--- TABLA Ampliacion --->
			<cfif qryCurso.CestadoCalificacion GTE "2" and qryCurso.TRcantidadAmpliacion GT 0>
				<td id="tdWidthExtras" valign="top" style="border: none; padding: 0px; margin: 0px; ">
				<cfset tam = 0>
				<cfif qryCurso.TRcantidadAmpliacion GT 3>
					<cfset tam = 204>
				<cfelse>
					<cfset tam = qryCurso.TRcantidadAmpliacion * 51>
				</cfif>
				<cfif GvarDiv>
					<DIV id="divWidthExtras" style="BORDER: none; border-right: solid #FFFFFF 1px;PADDING: 0px; MARGIN: 0px; WIDTH: <cfoutput>#tam#</cfoutput>px; OVERFLOW:auto;">
				</cfif>
						<table id="tblExtras" border="0" cellspacing="0" cellpadding="0">
							<tr>
							<cfoutput query="qryAmpliaciones">
								<cfif CAMtipoCalificacion EQ "T">
									<cfquery dbtype="query" name="qryValores">
										select Codigo, Equivalente, Minimo, Maximo
										  from qryValoresTabla
										 where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TEcodigo#">
										 order by EVorden desc
									</cfquery>
								</cfif>
								<td class="linEnc">
									<div onClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden; cursor:pointer; text-decoration:underline" 
									title=
"Examen de Ampliación #CAMsecuencia#
Tipo de Calificacion:      	<cfif CAMtipoCalificacion EQ "1">Porcentual de 0% a 100%<cfelseif CAMtipoCalificacion EQ "2">Puntaje de 0 a #CAMpuntosMax# puntos<cfelse>Tabla de Evaluacion</cfif>
<cfif CAMtipoCalificacion EQ "T">
	<cfloop query="qryValores">#Codigo# = #Equivalente#%
	</cfloop>
</cfif>">
										Extra #CAMsecuencia#
									</div>
								</td>
							</cfoutput>			  
							</tr>
							<tr class="linEncProm">
							<cfoutput query="qryAmpliaciones">
								<cfif CAMtipoCalificacion EQ "1">
								<td class="linEncProm" style="text-align:center;">hasta<BR>#CAMpuntosMax#%</td>
								<cfelseif CAMtipoCalificacion EQ "2">
								<td class="linEncProm" style="text-align:center;">hasta<BR>#numberformat(CAMpuntosMax,"0")#pts</td>
								<cfelseif CAMtipoCalificacion EQ "T">
								<td class="linEncProm" style="text-align:center;">Valor<BR>Tabla</td>
								</cfif>
							</cfoutput>			  
							</tr>
							<tr class="linEncProm">
							<cfoutput query="qryAmpliaciones">
								<td class="linEncProm">&nbsp; 
								</td>
							</cfoutput>			  
							</tr>
							<tr class="tdInvisible">
							<cfoutput query="qryNotasAmpliacion">
								<td class="tdInvisible" style="width:101; height:15px";>
									<input type="text" name="CAMsecuencia#currentRow#" id="CAMsecuencia#currentRow#" value="#CAMsecuencia#" class="tdInvisible">
									<input type="text" name="CAMtipoCalificacion#currentRow#" id="CAMtipoCalificacion#currentRow#" value="#CAMtipoCalificacion#" class="tdInvisible">
									<cfif CAMtipoCalificacion EQ "T">
										<input type="text" name="TEcodigoAmpl#currentRow#" id="TEcodigoAmpl#currentRow#" class="tdInvisible" value="#Tabla#">
									<cfelseif CAMtipoCalificacion EQ "2">
										<input type="text" name="CAMpuntosMax#currentRow#" id="CAMpuntosMax#currentRow#" class="tdInvisible" value="#CAMpuntosMax#">
									</cfif>
								</td>
							</cfoutput>			  
							</tr>
							<cfset LvarLins=qryEstudiantes.RecordCount>
							<cfset LvarCols=qryCurso.TRcantidadAmpliacion>
							<cfset LvarLin=1>
							<cfset LvarCol=1>
							<cfset LvarPar="Par">
							<tr>
							<cfoutput>
							<cfloop query="qryNotasAmpliacion">
								<cfif LvarCol EQ 1>
									<cfset LvarExtraAnterior = qryNotasAmpliacion.CAporcProgreso>
								</cfif>
								<td class="lin#LvarPar#">
								<cfif qryCurso.CestadoCalificacion neq "2">
									<cfset LvarLock = true>
								<cfelse>
									<cfset LvarLock = (LvarExtraAnterior GTE qryCurso.TRRminimoAprobacion or qryNotasAmpliacion.CAporcProgreso LT qryCurso.TRRminimoAmpliacion) AND CAAnota EQ "">
								</cfif>
								<cfset LvarNoLockMalo = (LvarExtraAnterior GTE qryCurso.TRRminimoAprobacion or qryNotasAmpliacion.CAporcProgreso LT qryCurso.TRRminimoAmpliacion) AND CAAnota NEQ "">
								<cfset LvarNoLockMaloT = LvarNoLockMaloT OR LvarNoLockMalo>
								<cfif CAMtipoCalificacion NEQ "T">
									<input type="text" name="txtExtra#LvarLin#_#LvarCol#" id="txtExtra#LvarLin#_#LvarCol#" maxlength="6"
										class="txt#LvarPar#"
										onFocus="return fnFocus(this,event);"
										onBlur="return fnAjustarNota(this, event, '#CAMtipoCalificacion#', #CAMpuntosMax#, #CAMunidadMin#, #CAMredondeo#);"
										onKeyDown="return fnKeyDown(this, event);"
										onKeyPress="return fnKeyPressNum(this, event);"
										<cfif LvarLock>Readonly<cfelse>style="#LvarBorder#;"</cfif>
										<cfif LvarNoLockMalo>style="color:##FF0000"</cfif>
										value="#replace(replace(CAAnota,"%",""),"pts","")#">
								<cfelse>
									<select name="cboExtra#LvarLin#_#LvarCol#" id="cboExtra#LvarLin#_#LvarCol#"
										class="txt#LvarPar#"
										<cfif LvarLock>onChange="javascript: this.value = GvarValueAnt;"</cfif>
										<cfif LvarNoLockMalo>style="color:##FF0000"</cfif>
										onFocus="return fnFocus(this,event);"
										onBlur="return fnAjustarNota(this, event, '#CAMtipoCalificacion#');"
										onKeyDown="return fnKeyDown(this, event);" 
										onKeyPress="return fnKeyPressNum(this, event);"> 
										<option value=""<cfif CAAnota eq ""> selected</cfif>>&nbsp;</option>
										<cfset LvarNota = CAAnota>
										<cfloop query="qryValores">
										<option value="#Equivalente#"<cfif compareNoCase(trim(LvarNota),trim(Codigo)) EQ 0> selected</cfif>>#Codigo#</option>
										</cfloop>
									</select>
								</cfif>
								<cfset LvarExtraAnterior = qryNotasAmpliacion.CAAporcentaje*100>
								</td>
								<cfif CurrentRow mod LvarCols is 0 and CurrentRow neq recordCount>
									<cfset LvarLin=LvarLin+1>
									<cfset LvarCol=0>
									<cfif LvarPar neq "Par">
										<cfset LvarPar="Par">
									<cfelse>
										<cfset LvarPar="Impar">
									</cfif>
							</tr>
							<tr>
								</cfif>
								<cfset LvarCol=LvarCol+1>
							</cfloop>
							</cfoutput>
							</tr>
							<tr>
							<cfloop from="1" index="i" to="#qryCurso.TRcantidadAmpliacion#">
								<td class="linEncProm"></td>
							</cfloop>
							</tr>
						</table>
				<cfif GvarDiv>
					</DIV>
				</cfif>
          		</td>
			</cfif>
				<!--- TABLA DE AJUSTE --->
				<td width="51" valign="top" <cfif qryCurso.CestadoCalificacion EQ "1">style="display:none;"</cfif>>
					<table id="tblAjuste" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="linEnc" width="50">
					<cfoutput>
									<div onClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold; overflow:hidden; cursor:pointer; text-decoration:underline" 
									title=
"Ajuste de la Nota Final
Tipo de Calificacion:      	<cfif qryCurso.CtipoCalificacion EQ "1">Porcentual de 0% a 100%<cfelseif qryCurso.CtipoCalificacion EQ "2">Puntaje de 0 a #qryCurso.CpuntosMax# puntos<cfelse>Tabla de Evaluacion</cfif>
<cfif qryCurso.CtipoCalificacion EQ "T">
	<cfloop query="qryValoresMateria">#Codigo# = #Equivalente#%
	</cfloop>
</cfif>">
										Ajuste
									</div>
								
							</td>
							<td class="linEnc" width="50">
								Promedio<br>Final
							</td>
						</tr>
						<tr>
							<cfif qryCurso.CtipoCalificacion EQ "1">
							<td class="linEncProm" style="text-align:center;">hasta<BR>100%</td>
							<cfelseif qryCurso.CtipoCalificacion EQ "2">
							<td class="linEncProm" style="text-align:center;">hasta<BR>#numberformat(qryCurso.CpuntosMax,"0")#pts</td>
							<cfelseif qryCurso.CtipoCalificacion EQ "T">
							<td class="linEncProm" style="text-align:center;">Valor<BR>Tabla</td>
							</cfif>
							<td class="linEncProm" width="101">&nbsp;<BR>&nbsp;</td>
						</tr>
						<tr>
							<td class="linEncProm" width="101">&nbsp;</td>
							<td class="linEncProm" width="101">&nbsp;</td>
						</tr>
						<tr class="tdInvisible">
							<td>
								<cfif GvarTablaMateria neq ""><input type="text" name="txtTEcodigoM" id="txtTEcodigoM" class="tdInvisible" value="<cfoutput>#GvarTablaMateria#</cfoutput>"></cfif>
							</td>
						</tr>
					</cfoutput>
					<cfset LvarPar="Impar">
					<cfoutput query="qryEstudiantes">
						<cfif LvarPar eq "Par"><cfset LvarPar="Impar"><cfelse><cfset LvarPar="Par"></cfif>
						<tr class="lin#LvarPar#">
						<cfif GvarTablaMateria eq "">
							<td width="101" class="lin#LvarPar#">
								<input type="text" class="txt#LvarPar#" 
										name="txtAjuste#CurrentRow#" id="txtAjuste#CurrentRow#"
										<cfif qryCurso.CestadoCalificacion neq "2">Readonly<cfelse>Style="#LvarBorder#"</cfif>
										onFocus="document.frmNotas.cboXAlumno.selectedIndex=0; return fnFocus(this,event);"
										onBlur="return fnAjustarNota(this, event, '#qryCurso.CtipoCalificacion#', #qryCurso.CpuntosMax#, #qryCurso.CunidadMin#, #qryCurso.Credondeo#);"
										onKeyDown="return fnKeyDown(this, event);"
										onKeyPress="return fnKeyPressNum(this, event);"
										value="#replace(replace(CAnotaAjuste,"%",""),"pts","")#">
							</td>
						<cfelse>
							<td width="101" class="lin#LvarPar#">
								<select name="txtAjuste#CurrentRow#" id="txtAjuste#CurrentRow#"
										<cfif qryCurso.CestadoCalificacion neq "2">OnChange="javascript: this.value = GvarValueAnt;"</cfif>
										class="txt#LvarPar#"
										onFocus="return fnFocus(this,event);"
										onBlur="return fnAjustarNota(this, event, '#qryCurso.CtipoCalificacion#');"
										onKeyDown="return fnKeyDown(this, event);"
										onKeyPress="return fnKeyPressNum(this, event);">
								<cfset LvarNota=CAnotaAjuste>
								<cfif CAporcAjuste EQ "">
									<cfset LvarPorc="-1">
								<cfelse>
									<cfset LvarPorc=CAporcAjuste*100>
								</cfif>
								
									<option value=""<cfif (LvarNota eq "" or LvarNota eq "-1") and LvarPorc eq ""> selected</cfif>>&nbsp;</option>
								<cfloop query="qryValoresMateria">
									<option value="#Equivalente#" <cfif (LvarPorc neq "" and LvarPorc gte Minimo and LvarPorc lte Maximo)>selected</cfif>>#Codigo#</option>
								</cfloop>
								</select>
							</td>
						</cfif>
							<td width="101" class="lin#LvarPar#">
								<input type="text" class="txt#LvarPar#"  style="font-weight:bold"
										name="txtFinal#CurrentRow#" id="txtFinal#CurrentRow#"
										readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
										onFocus="fnFocus(this,event);this.style.border='0px solid';"
										value="#CAnotaFinal#">
							</td>
						</tr>
					</cfoutput>
						<tr>
							<td class="linEncProm" style="text-align=center; font-weight:bold; color:#0000FF;"></td>
							<td class="linEncProm" style="text-align=center; font-weight:bold; color:#0000FF;"></td>
						</tr>
					</table>
				</td>
			</tr>
			<cfif LvarNoLockMaloT>
			<tr>
				<td></td>
				<td colspan="6" style="color:#FF0000">(*) Existen Exámenes de Ampliación que no deberían tener calificación debido a que ya existe una calificación anterior suficiente para aprobar el curso o porque su nota de progreso no es suficiente para realizar Ampliación</td>
			</tr>
			</cfif>
		</table>
		<!--- FIN DE TABLAS SINCRONIZADAS EN 3 TDs--->
	</td>
	<td></td>
	<td width="100" valign="top"><input name="tdCodigoAlumno" id="tdCodigoAlumno" type="hidden" value="-1">
          <table width="350" id="tblConceptos" border="0" cellspacing="0" cellpadding="0" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
            <tr class="linEnc">
              <td id="tdNombreAlumno" colspan="5" style=" font-weight:bolder; border-Bottom: 1px solid #FFFFFF; text-align:center; font-size: 14px; color: #0000FF">Estudiante</td>
            </tr>
            <tr>
              <td width="130"></td>
              <td width="55"></td>
              <td width="55"></td>
              <td width="55"></td>
              <td width="55"></td>
            </tr>
            <cfif #qryConceptos.RecordCount# neq 0>
              <tr class="linEncEva">
                <td align="center" nowrap style="border-right: 1px solid #FFFFFF"><b>Concepto de Evaluacion</b></td>
                <td class="linEncProm" style="text-align=center;"
			    	title="%Concepto = Porcentaje asignado al Concepto de Evaluacion"
					style="font-weight: bold;cursor:pointer"
					onclick="alert(this.title)">%&nbsp;del Concepto</td>
                <td class="linEncProm" style="text-align=center;"
			    	title="Evaluado = Sumatoria por cada Evaluación ya calificada del Concepto (Contribución al Promedio)"
					style="font-weight: bold;cursor:pointer"
					onclick="alert(this.title)">Evaluado</td>
                <td class="linEncProm" style="text-align=center;" 
			    	title="Ganado = Sumatoria por cada Evaluación ya calificada del Concepto (Nota Obtenida x Contribución al Promedio)"
					style="font-weight: bold;cursor:pointer"
					onclick="alert(this.title)">Ganado</td>
                <td class="linEncProm" style="text-align=center;font-weight: bold;" 
			    	title="Progreso = Proporción del porcentaje ganado con respecto a lo evaluado = Ganado / Evaluado"
					style="font-weight: bold;cursor:pointer"
					onclick="alert(this.title)">Progreso</td>
              </tr>
              <cfset LvarPar="1">
              <cfoutput query="qryConceptos">
                <cfif LvarPar neq "linPar">
                  <cfset LvarPar="linPar">
                  <cfelse>
                  <cfset LvarPar="linImpar">
                </cfif>
                <tr class="#LvarPar#">
                  <td>#CEnombre#&nbsp;</td>
                  <td class="txtPar" align="right">#CCEporcentaje#%</td>
                  <td class="txtPar" align="right"></td>
                  <td class="txtPar" align="right"></td>
                  <td class="txtPar" style="font-weight:bold;text-align:right"></td>
                </tr>
              </cfoutput>
            </cfif>
              <tr class="linEncProm" style="font-weight: bold;">
                <td align="left">Obtenido</td>
                <td align="right" 
					title="Total %Conceptos Evaluados = Sumatoria por cada Concepto con alguna Evaluacion calificada(%Concepto)" 
					style="font-weight: bold;cursor:pointer"
					onclick="alert(this.title)">&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="left" 
					title="Total Progreso = Sumatoria por cada Concepto (Progreso X %Concepto) / Total %Conceptos, 
es decir, es el promedio ponderado de los Progresos de cada Concepto de Evaluacion con calificación" 
					style="font-weight:bold;text-align:CENTER;cursor:pointer"
					onclick="alert(this.title)">&nbsp;</td>
              </tr>
              <cfif GvarCursoTipoCalificacion neq "1">
                <tr class="linEncProm" style="font-weight: bold;">
                  <td align="left">Equivalente</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td align="center" style="color: #0000FF; font-weight: bold;">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </cfif>
              <tr class="linEncProm" style="font-weight: bold;">
                <td align="left">Ajuste</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <cfif GvarTablaMateria neq "">
                  <td align="center" style="color: #0000FF; font-weight: bold;" title="Ajuste digitado por el profesor al final del periodo.">&nbsp;</td>
                  <cfelse>
                  <td align="center" style="color: #0000FF;" title="Ajuste digitado por el profesor al final del periodo.">&nbsp;</td>
                </cfif>
              </tr>
              <tr class="linEncProm" style="font-weight: bold;">
                <td align="left">Asignado</td>
                <td colspan="3" align="center" nowrap style="color: #0000FF; font-weight: bold; overflow:hidden;">&nbsp;</td>
                <td align="center" nowrap style="color: #0000FF; font-weight: bold; overflow:hidden;">&nbsp;</td>
              </tr>
          </table></td>
</tr>
  </table>
    <br>
    <br>
</form>
    <script type="text/javascript">var GvarAmpliacionMala = <cfif LvarNoLockMaloT>true<cfelse>false</cfif>;fnProcesoInicial();</script>
</cfif> <!--- qryEstudiantes.RecordCount eq 0 --->
