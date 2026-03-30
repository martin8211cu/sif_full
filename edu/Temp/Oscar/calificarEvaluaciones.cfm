<cfparam name="Session.CENEDCODIGO" default="5">
<cfset Session.CENEDCODIGO = "5">
Session.CENEDCODIGO=5<br>
Soy Asistente<BR>
<cffunction name="sbInitFromSession">
           <cfargument name="LprmControl" required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
           <cfargument name="LprmNoChange" required="false" type="boolean" default=false>
  <cfparam name="Session.calificarEvaluaciones.#LprmControl#" default="#LprmDefault#">
  <cfif LprmNoChange>
    <cfset form[LprmControl] = Session.calificarEvaluaciones[LprmControl]>
  <cfelse>
    <cfparam name="form.#LprmControl#" default="#Session.calificarEvaluaciones[LprmControl]#">
  </cfif>
  <cfset Session.calificarEvaluaciones[LprmControl] = form[LprmControl]>
</cffunction>

<cffunction name="sbInitFromSessionChks">
           <cfargument name="LprmChk"     required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
  <cfif isdefined("form.chkXAlumno")>
    <cfparam name="form.#LprmChk#" default="0">
  <cfelse>
    <cfparam name="Session.calificarEvaluaciones.#LprmChk#" default="#LprmDefault#">
    <cfparam name="form.#LprmChk#" default="#Session.calificarEvaluaciones[LprmChk]#">
  </cfif>
  <cfset Session.calificarEvaluaciones[LprmChk] = form[LprmChk]>
</cffunction>

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboOrdenamiento", "0");
  sbInitFromSessionChks("chkPorcentajesXConcepto","1");
  sbInitFromSessionChks("chkPorcentajesXPromedio","1");
  sbInitFromSessionChks("chkPromedioXComponente","1");
</cfscript>

<cfquery datasource="Educativo" name="qryProfesores">
  select distinct s.Splaza as Codigo,  Papellido1+' '+Papellido2+' '+Pnombre as Descripcion
    from Staff s, PersonaEducativo pe, Curso c
   where s.CEcodigo = #Session.CENEDCODIGO#
     and pe.persona = s.persona
     and c.Splaza   = s.Splaza
     and c.CEcodigo = s.CEcodigo
     and exists ( 
	     select *
           from Nivel n, PeriodoVigente pv , PeriodoEscolar pe , SubPeriodoEscolar spe
          where n.CEcodigo    = s.CEcodigo
            and n.Ncodigo     = pv.Ncodigo
            and pe.Ncodigo    = pv.Ncodigo
            and spe.PEcodigo  = pe.PEcodigo
            and spe.SPEcodigo = pv.SPEcodigo
			and spe.SPEcodigo = c.SPEcodigo 
			)
  UNION
    select 0,  '* Cursos sin Profesor'
  order by  2
</cfquery>
<!--- 
VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL PROFESOR INDICADO
 --->
<cfif form.cboProfesor neq "-999">
  <cfquery dbtype="query" name="qryPermiso">
    select count(*) as Permiso
	  from qryProfesores
	 where Codigo = #form.cboProfesor#
  </cfquery>
  <cfif qryPermiso.Permiso eq "0">
    NO TIENE AUTORIZACION PARA CALIFICAR LOS CURSOS DEL PROFESOR INDICADO
	<cfabort>
  </cfif>
</cfif>

<cfquery datasource="Educativo" name="qryMateria">
    select EVTcodigo, m.Mconsecutivo
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = #Session.CENEDCODIGO#
       and c.Ccodigo = #form.cboCurso#
       and c.Mconsecutivo = m.Mconsecutivo
       and c.GRcodigo = g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
     order by c.GRcodigo,Cnombre
</cfquery>
<cfset GvarTablaMateria = qryMateria.EVTcodigo>
<cfquery datasource="Educativo" name="qryComplementaria">
    select CC.Ccodigo as Curso, MC.Mconsecutivo as Materia, MC.EVTcodigo as Tabla
      from Curso c, Materia m, MateriaElectiva ME, Curso CC, Materia MC
     where c.CEcodigo = #Session.CENEDCODIGO#
       and c.Ccodigo = #form.cboCurso#
       and c.Mconsecutivo = m.Mconsecutivo
       and m.Melectiva    = 'R'
       and m.Mconsecutivo = ME.Mconsecutivo
       and ME.Melectiva    = MC.Mconsecutivo
       and MC.Mconsecutivo = CC.Mconsecutivo
       and MC.Melectiva    = 'C'
       and CC.CEcodigo     = c.CEcodigo
       and CC.PEcodigo     = c.PEcodigo
       and CC.SPEcodigo    = c.SPEcodigo
       and CC.GRcodigo     = c.GRcodigo
</cfquery>

<cfoutput>
#qryComplementaria.Curso#
</cfoutput>

<cfquery datasource="Educativo" name="qryValoresTabla">
  select EVTcodigo as Tabla, EVvalor as Codigo, EVdescripcion as Descripcion, EVorden as EVorden, 
         EVequivalencia as Equivalente, EVminimo as Minimo, EVmaximo as Maximo
    from EvaluacionValores vt
   where exists(
           select *
             from Curso c, 
                  EvaluacionConceptoCurso ecc, 
                  EvaluacionConcepto ec, 
                  EvaluacionCurso cec
            where c.CEcodigo     = #Session.CENEDCODIGO#
              and c.Ccodigo      = #form.cboCurso#
              and ecc.Ccodigo    = c.Ccodigo
              and ecc.PEcodigo   = #form.cboPeriodo#
              and ec.CEcodigo    = c.CEcodigo
              and ec.ECcodigo    = ecc.ECcodigo
              and cec.ECcodigo   = ec.ECcodigo
              and cec.Ccodigo    = c.Ccodigo
              and cec.PEcodigo   = ecc.PEcodigo
			  and vt.EVTcodigo   = cec.EVTcodigo
		   )
      <cfif GvarTablaMateria neq "">
      or vt.EVTcodigo = #GvarTablaMateria#
	  </cfif>		   
</cfquery>
<cfif isDefined("form.btnGrabar")>
  <cfinclude template="calificarEvaluaciones_Grabar.cfm">
</cfif>

<cfquery datasource="Educativo" name="qryCursos">
  <cfif #form.cboProfesor# neq "0">
    select Ccodigo as Codigo, Cnombre as Descripcion
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = #Session.CENEDCODIGO#
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.Splaza = <cfqueryparam cfsqltype="cf_sql_decimal" value="#form.cboProfesor#">
       and c.GRcodigo = g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
     order by c.GRcodigo,Cnombre
  <cfelse>
    select Ccodigo as Codigo, Ndescripcion+': '+Cnombre as Descripcion
      from Curso c, Materia m, PeriodoVigente v, Nivel n
     where c.CEcodigo     = #Session.CENEDCODIGO#
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.Splaza       = null
       and m.Ncodigo      = v.Ncodigo
       and c.PEcodigo     = v.PEcodigo
       and c.SPEcodigo    = v.SPEcodigo
       and m.Ncodigo      = n.Ncodigo
    order by n.Norden, Cnombre
  </cfif>
</cfquery>
<cfquery datasource="Educativo" name="qryPeriodos">
  select p.PEcodigo Codigo, p.PEdescripcion as Descripcion, PEevaluacion as Actual
    from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v
   where c.CEcodigo     = #Session.CENEDCODIGO#
     and c.Ccodigo      = #form.cboCurso#
     and c.Mconsecutivo = m.Mconsecutivo
     and m.Ncodigo      = p.Ncodigo
     and v.Ncodigo   = m.Ncodigo
     and v.PEcodigo  = c.PEcodigo
     and v.SPEcodigo = c.SPEcodigo
  order by p.PEorden
</cfquery>
<cfquery datasource="Educativo" name="qryComponentes">
  select ec.ECcodigo as CodigoEC,       ec.ECnombre as DescripcionEC,   str(ecc.ECCporcentaje,6,2) as PorcentajeEC, ec.ECorden as OrdenEC,
         cec.ECcomponente as CodigoCEC, cec.ECnombre as DescripcionCEC, str(cec.ECporcentaje,6,2) as PorcentajeCEC, str(ecc.ECCporcentaje*cec.ECporcentaje/100.0,6,2) as Porcentaje,
		 (select isnull(max(n.ACcerrado),'0')
		    from AlumnoCalificacion n
           where n.CEcodigo     = c.CEcodigo
             and n.Ccodigo      = c.Ccodigo
             and n.ECcomponente = cec.ECcomponente
		 ) as Cerrado, 
		 cec.EVTcodigo as EVTcodigo
    from Curso c, 
         EvaluacionConceptoCurso ecc, 
         EvaluacionConcepto ec, 
         EvaluacionCurso cec
   where c.CEcodigo     = #Session.CENEDCODIGO#
     and c.Ccodigo      = #form.cboCurso#
     and ecc.Ccodigo    = c.Ccodigo
     and ecc.PEcodigo   = #form.cboPeriodo#
     and ec.CEcodigo    = c.CEcodigo
     and ec.ECcodigo    = ecc.ECcodigo
     and cec.ECcodigo   = ec.ECcodigo
     and cec.Ccodigo    = c.Ccodigo
     and cec.PEcodigo   = ecc.PEcodigo
  <cfif form.cboOrdenamiento eq 0>
  order by isnull(cec.ECreal, cec.ECplaneada), ec.ECorden
  <cfelseif form.cboOrdenamiento eq 1>
  order by ec.ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 2>
  order by cec.ECcomponente
  </cfif>
</cfquery>
<cfquery dbtype="query" name="qryConceptos">
  select distinct CodigoEC, DescripcionEC, PorcentajeEC
    from qryComponentes
  order by OrdenEC
</cfquery>
<cfquery datasource="Educativo" name="qryPeriodoCerrado">
  select isnull(max(ACPEcerrado),'0') as Cerrado 
    from AlumnoCalificacionPerEval ac
   where ac.PEcodigo    = #form.cboPeriodo#
	 and ac.CEcodigo    = #Session.CENEDCODIGO#
     and ac.Ccodigo     = #form.cboCurso#
</cfquery>
<cfquery datasource="Educativo" name="qryEstudiantes">
  select a.Ecodigo as Codigo, p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre, 
         str(ac.ACPEnotacalculada,6,2) as Ajuste, 
		 ac.ACPEvalorcalculado         as ValorAjuste, 
        (select isnull(max(ACPEcerrado),'0') from AlumnoCalificacionPerEval ac1
         where ac1.PEcodigo    = #form.cboPeriodo#
           and ac1.Ecodigo    = ac.Ecodigo
           and ac1.CEcodigo    = #Session.CENEDCODIGO#
           and ac1.Ccodigo     = #form.cboCurso#) as Cerrado 
    from AlumnoCalificacionCurso a, AlumnoCalificacionPerEval ac,
         Estudiante e, 
         PersonaEducativo p
   where a.Ccodigo      = #form.cboCurso#
     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona
     and ac.PEcodigo    = #form.cboPeriodo#
     and ac.Ecodigo     =* e.Ecodigo
	 and ac.CEcodigo    = #Session.CENEDCODIGO#
     and ac.Ccodigo     = #form.cboCurso#
  order by p.Papellido1, p.Papellido2, p.Pnombre
</cfquery>
<cfquery datasource="Educativo" name="qryNotas">
  select c.CEcodigo as Estudiante, str(n.ACnota,6,2) as Nota, n.ACvalor as Valor, cec.EVTcodigo as Tabla,
        (select isnull(max(n2.ACcerrado),'0')
		    from AlumnoCalificacion n2
           where n2.CEcodigo     = a.CEcodigo
             and n2.Ccodigo      = a.Ccodigo
             and n2.ECcomponente = cec.ECcomponente
		 ) as Cerrado
    from Curso c,                          -- Curso
         EvaluacionConceptoCurso ecc,      -- Conceptos de Evaluación de un Curso
         EvaluacionConcepto ec,            -- Catalogo Conceptos de Evaluación
		 EvaluacionCurso cec,              -- Componentes del Concepto de Evaluación de un Curso
         AlumnoCalificacionCurso a,        -- Alumnos de un Curso
		 PersonaEducativo p,               -- Catalogos de Personas
		 Estudiante e,                     -- Join entre Alumno y Persona
         AlumnoCalificacion n              -- Calificaciones Alumno por Componente
   where c.CEcodigo     = #Session.CENEDCODIGO#
     and c.Ccodigo      = #form.cboCurso#
     and ecc.Ccodigo    = c.Ccodigo
     and ecc.PEcodigo   = #form.cboPeriodo#
     and ec.CEcodigo    = c.CEcodigo
     and ec.ECcodigo    = ecc.ECcodigo
     and cec.ECcodigo   = ec.ECcodigo
     and cec.Ccodigo    = c.Ccodigo
     and cec.PEcodigo   = ecc.PEcodigo

     and a.Ccodigo      = #form.cboCurso#
     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona

     and a.Ecodigo        *= n.Ecodigo
     and a.CEcodigo       *= n.CEcodigo
     and a.Ccodigo        *= n.Ccodigo
     and cec.ECcomponente *= n.ECcomponente
  order by p.Papellido1, p.Papellido2, p.Pnombre,
  <cfif form.cboOrdenamiento eq 0>
           isnull(cec.ECreal, cec.ECplaneada), ec.ECorden
  <cfelseif form.cboOrdenamiento eq 1>
           ec.ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 2>
           cec.ECcomponente
  </cfif>
</cfquery>

<html>
  
<head>
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        background-color: #FF0000;
        WIDTH: 20px;
        HEIGHT:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
        display:'none';
      }
      .txtPar {
        line-height: normal;
        width: 51px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        border:0;
      }
      .txtImpar {
        line-height: normal;
        width: 51px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        background-color:#D8E5F2;
        border:0;
      }
      .linEnc {
        background-color:#A9C6E1;
        height:38px; width:50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        text-align : center;
        vertical-align : middle;
      }
      .linEncPrc {
        background-color:#A9C6E1;
        height:40px; width:50px;
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
        border: solid 1px #D8E5F2; HEIGHT:19px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
      }
      .linImpar {
        background-color:#D8E5F2; border: solid 1px #D8E5F2; height:19px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
      }
    -->
    </style>
<script language="JavaScript" type="text/JavaScript">
    <!--
      var GvarRow1 = 5;
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
        GvarConceptos["C#CodigoEC#"] = #PorcentajeEC#;
      </cfoutput>
      var GvarConceptosN = <cfoutput>#LvarCount#</cfoutput>;

      // Uno por Estudiante
      var GvarConceptosXEstudiantes = new Array();
      var GvarEstudiantesN = <cfoutput>#qryEstudiantes.RecordCount#</cfoutput>;

      // Uno por Calficacion
      var GvarComponentes = new Array(
      <cfset GvarPlaneado=0>
      <cfoutput query="qryComponentes">
        <cfset GvarPlaneado=GvarPlaneado + Porcentaje>
        <cfif currentRow eq 1>
            new objCalificacion("C#CodigoEC#",#PorcentajeCEC#,#Porcentaje#)
        <cfelse>
          , new objCalificacion("C#CodigoEC#",#PorcentajeCEC#,#Porcentaje#)
        </cfif>
      </cfoutput>
        );
      var GvarComponentesN = GvarComponentes.length;
      var GvarPlaneado = <cfif GvarPlaneado eq 100><cfset GvarPlaneado=true>true<cfelse><cfset GvarPlaneado=false>false</cfif>;
<cfif GvarTablaMateria neq "">
      <cfquery dbtype="query" name="qryValoresMateria">
       select Codigo, Equivalente, Minimo, Maximo, Descripcion
         from qryValoresTabla
        where Tabla = #GvarTablaMateria#
        order by EVorden
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
      function objCXE(Evaluado, Ganado, Progreso)
      {
          this.Evaluado   = Evaluado;
          this.Ganado     = Ganado;
          this.Progreso   = Progreso;
      }
      function objConceptoXEstudiante (Evaluaciones, Ajuste)
      {
          this.Evaluaciones = Evaluaciones;
          this.Ajuste       = Ajuste;
      }
      function objCalificacion (Concepto, PCalificacion, PNota)
      {
          this.Concepto      = Concepto;
          this.PCalificacion = PCalificacion;
          this.PNota         = PNota;
      }
      function fnReLoad()
      {
	    if (fnVerificarCambios())
          document.frmNotas.submit();
      }
      function fnLoadcalificarCurso()
      {
	    if (fnVerificarCambios())
		{
          document.frmNotas.action="calificarCurso.cfm";
          document.frmNotas.submit();
		}
      }
	  function fnKeyPress(txtBox, e)
      {
        if (txtBox.type != "text")
          return true;

        var keycode;
        if (window.event)
          keycode = window.event.keyCode;
        else if (e)
          keycode = e.which;
        else
          return true;

        if (((keycode>47) && (keycode<58) ) || (keycode==8))
          return true;
        else if ((keycode==46) && (txtBox.value != "") &&
                 (txtBox.value.indexOf(".") == -1))
          return true;
        else
          return false;
      }

      function fnKeyDown(txtBox, e)
      {
        var keycode;
        var keyShift = false;
        var keyCtrl = false;
        var keyAlt = false;
        if (window.event)
        {
          keycode = window.event.keyCode;
          keyShift = window.event.shiftKey;
          keyCtrl = window.event.ctrlKey;
          keyAlt = window.event.altKey;
        }
        else if (e)
        {
          keycode = e.which;
          if (e.modifiers)
          {
            keyShift = e.modifiers & e.SHIFT_MASK;
            keyCtrl = e.modifiers & e.CONTROL_MASK;
            keyAlt = e.modifiers & Event.ALT_MASK;
          }
          else
          {
            keyShift = e.shiftKey;
            keyCtrl = e.ctrlKey;
            keyAlt = e.altKey;
          }
        }
        else
          return true;

        var LvarXAlumno = eval(document.frmNotas.chkXAlumno.value);
        var LvarNewCell = txtBox;
        var LvarNewRow = null;
        var LvarTD = txtBox.parentNode;
        var LvarTR = LvarTD.parentNode;
        var LvarTB = LvarTR.parentNode;
        var LvarCol = LvarTD.cellIndex;
        var LvarRow = LvarTR.rowIndex;

        if (keycode == 46)
		  return true;

        if (keycode == 13)    //ENTER
        {
          if (LvarXAlumno)
          {
            if (LvarCol < LvarTR.cells.length-1)
              LvarNewCell = LvarTR.cells[LvarCol + 1];
            else if (LvarRow < LvarTB.rows.length-GvarRowN)
            {
              LvarNewRow = LvarTB.rows[LvarRow + 1];
              LvarNewCell = LvarNewRow.cells[0];
            }
            else
            {
              LvarNewRow = LvarTB.rows[GvarRow1];
              LvarNewCell = LvarNewRow.cells[0];
            }

            var LvarInputText = fnInputText(LvarNewCell);
            if (LvarInputText != null)
             LvarInputText.focus();
            return false;
          }
          else
          {
            if (LvarRow < LvarTB.rows.length-GvarRowN)
            {
              LvarNewRow = LvarTB.rows[LvarRow + 1];
              LvarNewCell = LvarNewRow.cells[LvarCol];
            }
            else if (LvarCol < LvarTR.cells.length-1)
            {
              LvarNewRow = LvarTB.rows[GvarRow1];
              LvarNewCell = LvarNewRow.cells[LvarCol + 1];
            }
            else
            {
              LvarNewRow = LvarTB.rows[GvarRow1];
              LvarNewCell = LvarNewRow.cells[0];
            }

            var LvarInputText = fnInputText(LvarNewCell);
            if (LvarInputText != null)
              LvarInputText.focus();
            return false;
          }
        }
        else if (keycode == 39 && keyCtrl)  //DERECHA
        {
          if (LvarCol < LvarTR.cells.length-1)
            LvarNewCell = LvarTR.cells[LvarCol + 1];
          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
        }
        else if (keycode == 37 && keyCtrl)  //IZQUIERDA
        {
          if ((LvarCol > 0))
            LvarNewCell = LvarTR.cells[LvarCol - 1];
          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
        }
        else if (keycode == 40 && keyCtrl)  //ABAJO
        {
          if (LvarRow < LvarTB.rows.length-GvarRowN)
          {
            LvarNewRow = LvarTB.rows[LvarRow + 1];
            LvarNewCell = LvarNewRow.cells[LvarCol];
          }
          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
          }
          else if (keycode == 38 && keyCtrl)  //ARRIBA
          {
            if (LvarRow > GvarRow1)
            {
              LvarNewRow = LvarTB.rows[LvarRow - 1];
              LvarNewCell = LvarNewRow.cells[LvarCol];
            }

            var LvarInputText = fnInputText(LvarNewCell);
            if (LvarInputText != null)
              LvarInputText.focus();
            return false;
        }
        else if (keycode == 36 && keyCtrl)  //HOME
        {
          LvarNewCell = LvarTB.rows[LvarRow].cells[0];

          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
        }
        else if (keycode == 35 && keyCtrl)  //END
        {
          LvarNewCell = LvarTB.rows[LvarRow].cells(LvarTR.cells.length-1);

          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
        }
        else if (keycode == 33 && keyCtrl)  //PgUp
        {
          LvarNewCell = LvarTB.rows[GvarRow1].cells[LvarCol];

          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
        }
        else if (keycode == 34 && keyCtrl)  //PgDn
        {
          LvarNewCell = LvarTB.rows[LvarTB.rows.length-GvarRowN].cells[LvarCol];

          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
          return false;
        }
      }
      function fnInputText(LprmTD)
      {
        if (LprmTD.childNodes)
          for (var i=0; i<LprmTD.childNodes.length; i++)
            if (LprmTD.childNodes[i].nodeType == 1)
              return LprmTD.childNodes[i];
        return null;
      }
      function fnFocus(txtBox, e)
      {
        if (GvarRowAnt == -99)
          return false;

        if (txtBox.type == "text")
		{
          if (txtBox.readOnly == true)
		  {
            txtBox.style.border='1px dotted #0099FF';
		    txtBox.readOnly = true;
		  }
		  else
          {
            txtBox.style.border='1px solid #0099FF';
            txtBox.select();
          }
		}

        var LvarTD = txtBox.parentNode;
        var LvarTR = LvarTD.parentNode;
        var LvarRow = LvarTR.rowIndex;

        if (GvarRowAnt != LvarRow)
        {
          GvarRowAnt = LvarRow;
          fnRefrescarTblConceptos(LvarRow);
        }

        GvarValueAnt=txtBox.value;
        return true;
      }
      function fnBlur(txtBox, e)
      {
        if (txtBox.type == "text")
        {
          if (parseFloat(txtBox.value)>100.0)
          {
            txtBox.select();
            txtBox.focus();
            return false;
          }

          if (txtBox.value != "")
            txtBox.value = fnFormat(txtBox.value,2,".");
          txtBox.style.border='0px';
        }

        var LvarTD = txtBox.parentNode;
        var LvarTR = LvarTD.parentNode;
        var LvarCol = LvarTD.cellIndex;
        var LvarRow = LvarTR.rowIndex;

        if ( ( (GvarValueAnt!="") || (txtBox.value!="") ) && ( parseFloat(GvarValueAnt) != parseFloat(txtBox.value)) )
        {
          if (document.getElementById("chkDesecharCambios"))
          {
		    document.getElementById("chkDesecharCambios").checked = false;
			document.frmNotas.btnGrabar.disabled = false;
		  }
          fnCalcularPromedios(LvarRow);
          fnRefrescarTblConceptos(LvarRow);
          fnRefrescarPromediosXComponente(LvarCol);
        }

        return true;
      }

      function fnEnterAjuste(txtBox, e)
      {
        var keycode = 0;
        var LvarRow = GvarRowAlumno;

        if (window.event)
        {
          keycode = window.event.keyCode;
        }
        else if (e)
        {
          keycode = e.which;
        }
        if (keycode == 13)    //ENTER
        {
          var LvarNewCell = document.getElementById("tblNotas").rows[LvarRow].cells[0];
          var LvarInputText = fnInputText(LvarNewCell);
          if (LvarInputText != null)
            LvarInputText.focus();
        }

        return;
      }
      function fnFormat(LprmValor,LprmDec,LprmPuntoDec)
      {
        var LvarValOriginal = LprmValor;
        var LvarSigno = 1;
        var LvarPunto = 0;
        var LvarCeros = 0;
        var i = 0;

        // AJUSTA PARAMETROS, PRIMERO LOS CONVIERTE A STRING, Y LUEGO PONE VALORES DEFAULT

        LprmValor += "";
        if( (LprmValor.length == 0) || (isNaN(parseFloat(LprmValor))) )
          LprmValor = 0;
        else
        {
          LprmValor = parseFloat(LprmValor);
          if(LprmValor < 0)
          {
            LvarSigno = -1;
            LprmValor = Math.abs(LprmValor);
          }
        }

        LprmDec += "";
        if((parseInt(LprmDec,10)) || (parseInt(LprmDec,10) == 0))
        {
          LprmDec = Math.abs(parseInt(LprmDec,10));
        }
        else
        {
          LprmDec = 0;
        }

        LprmPuntoDec += "";
        if((LprmPuntoDec == "") || (LprmPuntoDec.length > 1))
          LprmPuntoDec = ".";

        // REDONDEA EL VALOR AL NUMERO DE DEC
        if (LprmDec == 0)
          LprmValor = "" + Math.round(LprmValor);
        else
          LprmValor = "" + Math.round(LprmValor * Math.pow(10,LprmDec)) / Math.pow(10,LprmDec);

        //if ((LprmValor.substring(1,2) == ".") || ((LprmValor + "")=="NaN"))
          //return(LvarValOriginal);

        if (LprmDec > 0)
        {
          // RELLENA CON CEROS A LA DERECHA DEL PUNTO DECIMAL
          LvarPunto = LprmValor.indexOf(LprmPuntoDec);
          if (LvarPunto == -1)
          {
            LprmValor += LprmPuntoDec;
            LvarPunto = LprmValor.indexOf(LprmPuntoDec);
          }
          LvarCeros =  LprmDec - (LprmValor.length - LvarPunto - 1);
          for(i = 0; i < LvarCeros; i++)
            LprmValor += "0";
        }

        if(LvarSigno == -1)
          LprmValor = "-" + LprmValor;

        return(LprmValor);
      }
      function fnPorcentajes(chkBox, e, t)
      {
        if (chkBox.checked)
        {
          document.getElementById("trPrc"+t+"1").style.display="";
          document.getElementById("trPrc"+t+"2").style.display="";
          document.getElementById("trPrc"+t+"3").style.display="";
        }
        else
        {
          document.getElementById("trPrc"+t+"1").style.display="none";
          document.getElementById("trPrc"+t+"2").style.display="none";
          document.getElementById("trPrc"+t+"3").style.display="none";
        }
      }
      function fnPromedio(chkBox, e)
      {
        if (chkBox.checked)
        {
          document.getElementById("trprm1").style.display="";
          document.getElementById("trprm2").style.display="";
          document.getElementById("trprm3").style.display="";
        }
        else
        {
          document.getElementById("trprm1").style.display="none";
          document.getElementById("trprm2").style.display="none";
          document.getElementById("trprm3").style.display="none";
        }
      }
      function fnCambiarTD(LprmTD,LprmTexto)
      {
        var LvarTexto = document.createTextNode(LprmTexto);
        LprmTD.replaceChild(LvarTexto,LprmTD.firstChild);
      }
      function fnCerrarComponente(chkBox, e)
	  {
	    if ( (GvarComponentesN>0) && (!GvarPlaneado) )
		{
		  alert ("El Curso no se ha terminado de planear, todavía no se puede cerrar el componente de evaluación");
     	  chkBox.checked = false;
		  return false;
		}

	    if ( chkBox.checked )
		{
          var LvarTblNotas=document.getElementById("tblNotas");
          var LvarTD = chkBox.parentNode;
          var LvarTR = LvarTD.parentNode;
          var LvarCol = LvarTD.cellIndex;
		  for (var i=0;i<GvarEstudiantesN;i++)
		    if (LvarTblNotas.rows[i+GvarRow1].cells[LvarCol].firstChild.value == "")
		      if (confirm("Existen Evaluaciones sin calificar, las cuales no se tomarán en cuenta al calcular el promedio final. ¿Desea seguir con el cierre de la Evaluación?"))
			    break;
			  else
			  {
    	 	    chkBox.checked = false;
			    return false;
     		  }
        }
        document.frmNotas.chkDesecharCambios.checked = false;
        document.frmNotas.btnGrabar.disabled = false;
      }
      function fnCerrarPeriodo()
	  {
        if (document.frmNotas.chkCerrarPeriodo.checked)
        {
          if ( (GvarComponentesN>0) && (!GvarPlaneado) )
		  {
		    alert ("El Curso no se ha terminado de planear, todavía no se puede cerrar el período");
     	    document.frmNotas.chkCerrarPeriodo.checked = false;
			return false;
		  }
		  for (var i=0; i<GvarComponentesN; i++)
          {
            if (eval("document.frmNotas.chkCerrar"+(i+1)+".checked") != true)
        	{
              if (!confirm("Existen evaluaciones abiertas, ¿Desea cerrar todas las evaluaciones?")) 
              {
			    document.frmNotas.chkCerrarPeriodo.checked = false;
				return false;
			  }
			  else
              break;
        	}
          }
		  RevisarComponentes:
          for (var j=1; j<=GvarComponentesN; j++)
          {
            chkCerrar = eval("document.frmNotas.chkCerrar"+j);
            var LvarTblNotas=document.getElementById("tblNotas");
            for (var i=0;i<GvarEstudiantesN;i++)
              if (LvarTblNotas.rows[i+GvarRow1].cells[j-1].firstChild.value == "")
                if (confirm("Existen Evaluaciones sin calificar, las cuales no se tomarán en cuenta al calcular el promedio final. ¿Desea seguir con el cierre del Período?"))
                  break RevisarComponentes;
                else
                {
                  document.frmNotas.chkCerrarPeriodo.checked = false;
                  return false;
                }
          }
          for (var j=1; j<=GvarComponentesN; j++)
          {
            LvarChkCerrarI = eval("document.frmNotas.chkCerrar"+j);
            LvarChkCerrarI.checked = true;
            LvarChkCerrarI.disabled = true;
          }
        }
		else
		{
          for (var j=1; j<=GvarComponentesN; j++)
          {
            LvarChkCerrarI = eval("document.frmNotas.chkCerrar"+j);
            LvarChkCerrarI.disabled = false;
          }
        }
        document.frmNotas.chkDesecharCambios.checked = false;
        document.frmNotas.btnGrabar.disabled = false;
        GvarRowAnt = -1;
	  }
      function fnVerificarCambios()
      {
        if (document.getElementById("chkDesecharCambios"))
		{
          var LvarCambios=document.getElementById("chkDesecharCambios").checked;
	      if (!LvarCambios)
		  {
	        document.getElementById("cboProfesor").selectedIndex=GvarProIndex ;
            document.getElementById("cboCurso").selectedIndex=GvarCurIndex;
	        document.getElementById("cboPeriodo").selectedIndex=GvarPerIndex;
	        document.getElementById("cboOrdenamiento").selectedIndex=GvarOrdIndex;
		    alert("Grabe los cambios efectuados o marque la opción 'Desechar cambios'");
            return false;
		  }
		}
		return true;
	  }
      function fnResize()
      {
        var LvarNotas = Math.floor((parseInt(document.body.clientWidth)-650)/50);
        if (LvarNotas<2)
          LvarNotas=2;
        <cfoutput>
        else if (LvarNotas>#qryComponentes.recordCount#)
          LvarNotas=#qryComponentes.recordCount#;
        </cfoutput>
        else if (LvarNotas>6)
          LvarNotas=6;
        if (document.getElementById("divWidth1"))
        {
          document.getElementById("divWidth1").style.width=LvarNotas*51+1;
          document.getElementById("divWidth2").style.width=LvarNotas*51+1;
        }
      }
      function fnProcesoInicial()
      {
        fnResize();

        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblConceptos = document.getElementById("tblConceptos");
        var LvarRow1 = 3;
        GvarProIndex = document.getElementById("cboProfesor").selectedIndex;
        GvarCurIndex = document.getElementById("cboCurso").selectedIndex;
        GvarPerIndex = document.getElementById("cboPeriodo").selectedIndex;
        GvarOrdIndex = document.getElementById("cboOrdenamiento").selectedIndex;

        if (!LvarTblNotas)
          return;

        for (var i=0; i<GvarEstudiantesN; i++)
        {
          fnCalcularPromedios(i+GvarRow1);
        }
        for (var i=0; i<GvarComponentesN; i++)
        {
          fnCambiarTD (LvarTblNotas.rows[1].cells[i],
                       fnFormat(GvarComponentes[i].PCalificacion,2)+"%");
          LvarTblNotas.rows[1].cells[i].replaceChild(
                       document.createTextNode(fnFormat(GvarConceptos[GvarComponentes[i].Concepto],2)+"%"),
                       LvarTblNotas.rows[1].cells[i].lastChild);
          fnCambiarTD (LvarTblNotas.rows[2].cells[i],
                       fnFormat(GvarComponentes[i].PNota,2)+"%");

          fnRefrescarPromediosXComponente(i);
        }
		if (GvarComponentesN == 0)
          fnRefrescarPromediosXComponente(0);

        // Porcentajes de Evaluacion
        var LvarTotPConcepto=0;
        var i=0;
        for (c in GvarConceptos)
        {
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[4],
                       fnFormat(GvarConceptos[c],2)+"%");
          LvarTotPConcepto += GvarConceptos[c];
          i++;
        }
        if (i == 0)
          var LvarNewCell = document.getElementById('tblPromedios').rows[GvarRow1].cells[2];
        else
        {
          fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[4],
                     fnFormat(LvarTotPConcepto,2)+"%");
          var LvarNewCell = document.getElementById('tblNotas').rows[GvarRow1].cells[0];
        }
        var LvarInputText = fnInputText(LvarNewCell);
        if (LvarInputText != null)
        {
          LvarInputText.focus();
        }
      }
      function fnCalcularPromedios(LprmRow)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTotal=0;
        var LvarProgreso=0;
        var LvarHayNotas=false;
		var LvarEst = LprmRow-GvarRow1;

        // Calcular Promedio del Estudiante
        GvarConceptosXEstudiantes[LvarEst] = new objConceptoXEstudiante (new Array(), 0);
        <cfoutput query="qryConceptos">
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C#CodigoEC#"] = new objCXE(0,0,0);
        </cfoutput>
        var LvarConceptosXEstudiante = GvarConceptosXEstudiantes[LvarEst].Evaluaciones;

        for (var i=0; i<GvarComponentesN; i++)
        {
          var LvarNota = fnInputText(LvarTblNotas.rows[LprmRow].cells[i]).value;
          if (LvarNota != "")
          {
		    LvarHayNotas = true;
            LvarNota = parseFloat(LvarNota);

            LvarTotal += LvarNota*GvarComponentes[i].PNota/100;
			LvarProgreso += GvarComponentes[i].PNota/100;

            var c = GvarComponentes[i].Concepto;
            LvarConceptosXEstudiante[c].Evaluado += 
               GvarComponentes[i].PCalificacion;
            LvarConceptosXEstudiante[c].Ganado   += 
               LvarNota*GvarComponentes[i].PCalificacion/100;
            LvarConceptosXEstudiante[c].Progreso  =
               LvarConceptosXEstudiante[c].Ganado * 100 /
               LvarConceptosXEstudiante[c].Evaluado;
          }
        }
        fnInputText(LvarTblPromedios.rows[LprmRow].cells[0]).value = fnFormatValorNota(LvarTotal/LvarProgreso, LvarHayNotas);
        fnInputText(LvarTblPromedios.rows[LprmRow].cells[1]).value = fnFormatValorNota(LvarTotal, LvarHayNotas);
		GvarConceptosXEstudiantes[LvarEst].Ajuste = fnInputText(LvarTblPromedios.rows[LprmRow].cells[2]).value;
      }
      function fnRefrescarTblConceptos(LprmRow)
      {
        var LvarTblConceptos = document.getElementById("tblConceptos");
        var LvarRow1 = 3;
        var LvarEst = LprmRow-GvarRow1;

        // Fila Alumno
        GvarRowAlumno = LprmRow;

        // Nombre del Alumno
        fnCambiarTD (document.getElementById("tdNombreAlumno"),
            document.getElementById("tblEstudiantes").rows[LprmRow].cells[0].firstChild.nodeValue);

        // Promedios por Evaluacion
		var LvarConceptosXEstudiante = GvarConceptosXEstudiantes[LvarEst].Evaluaciones;
        var LvarTotEvaluado = 0;
        var LvarTotEvaluacion = 0;
        var i=0;
        for (var c in LvarConceptosXEstudiante)
        {
		  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[1],
            fnFormat(LvarConceptosXEstudiante[c].Evaluado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[2],
            fnFormat(LvarConceptosXEstudiante[c].Ganado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[3],
            fnFormat(LvarConceptosXEstudiante[c].Progreso,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[5],
            fnFormat(LvarConceptosXEstudiante[c].Ganado*GvarConceptos[c]/100,2)+"%");
          LvarTotEvaluado   +=
            LvarConceptosXEstudiante[c].Evaluado * GvarConceptos[c]/100;
          LvarTotEvaluacion +=
            LvarConceptosXEstudiante[c].Ganado * GvarConceptos[c]/100;
          i++;
        }
        if (i>0)
        {
          fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[1],
                       fnFormat(LvarTotEvaluado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[3],
                       fnFormat(LvarTotEvaluacion*100/LvarTotEvaluado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[5],
                       fnFormat(LvarTotEvaluacion,2)+"%");
          if (GvarTablaMateria == "")
            if (GvarConceptosXEstudiantes[LvarEst].Ajuste != "")
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+1].cells[2],
                           fnFormat(GvarConceptosXEstudiantes[LvarEst].Ajuste,2)+"%");
		    else if(!document.frmNotas.chkCerrarPeriodo.checked)
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+1].cells[2],
                           fnFormatValorNota(LvarTotEvaluacion,(LvarTotEvaluado>0) ));
			else
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+1].cells[2],
                           fnFormatValorNota(LvarTotEvaluacion*100/LvarTotEvaluado,(LvarTotEvaluado>0) ));
          else
		  {
            fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+1].cells[3],
                         fnFormatValorNota(LvarTotEvaluacion*100/LvarTotEvaluado,(LvarTotEvaluado>0),true ));
            fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+1].cells[5],
                         fnFormatValorNota(LvarTotEvaluacion,(LvarTotEvaluado>0),true ));
            if (GvarConceptosXEstudiantes[LvarEst].Ajuste == "")
			{
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+2].cells[1],
                           fnFormatValorNota(LvarTotEvaluacion,(LvarTotEvaluado>0),false,true ));
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+2].cells[2],
                           fnFormatValorNota(LvarTotEvaluacion,(LvarTotEvaluado>0),true,false ));
			}
		    else
			{
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+2].cells[1],
                           fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,true,false,true ));
              fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1+2].cells[2],
                           fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,true,true,false ));
			}
		  }
        }
      }
      function fnRefrescarPromediosXComponente(LprmCol)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTotal=0;
        var LvarConta=0;
        var LvarTotalP=0;
        var LvarContaP=0;

        for (var i=0; i<GvarEstudiantesN; i++)
        {
          if (GvarConceptosN > 0)
		  {
            var LvarNota = fnInputText(LvarTblNotas.rows[i+GvarRow1].cells[LprmCol]).value;
            if (LvarNota != "")
            {
              LvarNota = parseFloat(LvarNota);
              LvarTotal += LvarNota;
              LvarConta ++;
            }
          }

          var LvarPromedio = fnInputText(LvarTblPromedios.rows[i+GvarRow1].cells[2]).value;
          if (LvarPromedio == "")
            LvarPromedio = fnInputTextValorNota(LvarTblPromedios.rows[i+GvarRow1].cells[1]);
          if (LvarPromedio != "")
          {
            LvarPromedio = parseFloat(LvarPromedio);
            LvarTotalP += LvarPromedio;
            LvarContaP ++;
          }
        }
        if (GvarConceptosN > 0)
        {
          if (LvarConta == 0)
            fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol], "");
          else
            fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol],
                         fnFormat(LvarTotal/LvarConta,2)+"%");
        }
		
        fnCambiarTD (LvarTblPromedios.rows[GvarEstudiantesN+GvarRow1].cells[0],
                     fnFormatValorNota(LvarTotalP/LvarContaP, (LvarContaP!=0)) );
      }
      function fnFormatValorNota(LvarTotal, LvarHayNotas, LvarConValor, LvarConDesc)
      {
        if (!LvarHayNotas)
          return "";
        if (GvarTablaMateria == "")
          return fnFormat(LvarTotal,2)+"%";
        var LvarMayor = -1;
		var LvarValor = 0;
		var LvarCodigo = 0;
		var LvarDescripcion = "";
        for (var i=0; i<GvarTablaMateria.length; i++)
        {
          if ( (LvarTotal>GvarTablaMateria[i].Min) && (LvarTotal<=GvarTablaMateria[i].Max) )
          {
		    LvarCodigo = GvarTablaMateria[i].Codigo;
            LvarValor = GvarTablaMateria[i].Valor;
            LvarDescripcion = GvarTablaMateria[i].Descripcion;
			break;
		  }
          else if (GvarTablaMateria[i].Valor>LvarMayor)
          {
            LvarCodigo = GvarTablaMateria[i].Codigo;
            LvarValor = GvarTablaMateria[i].Valor;
            LvarDescripcion = GvarTablaMateria[i].Descripcion;
            LvarMayor = GvarTablaMateria[i].Valor;
          }
        }
		if (LvarConValor)
		  LvarCodigo = LvarCodigo + " = " + LvarValor;
		if (LvarConDesc)
		  LvarCodigo = LvarDescripcion;
        return LvarCodigo;
      }
      function fnInputTextValorNota(LprmCelda)
      {
		var LvarValue = fnInputText(LprmCelda).value;
        if ( (GvarTablaMateria == "") || (LvarValue == "") )
          return LvarValue;
		  
        for (var i=0; i<GvarTablaMateria.length; i++)
        {
          if ( LvarValue == GvarTablaMateria[i].Codigo )
            return GvarTablaMateria[i].Valor;
        }
        return "";
      }
    -->
    </script>
</head>
 
  <body onLoad="fnProcesoInicial();" onResize="fnResize();">

<form name="frmNotas" method="POST" action=""
          style="font:10px Verdana, Arial, Helvetica, sans-serif;">
      <br>
      Profesor:
      <select name="cboProfesor"
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfoutput query="qryProfesores">
          <option value="#Codigo#"<cfif #form.cboProfesor# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboProfesor="-999">
		</cfif>
      </select>
      Curso:
      <select name="cboCurso" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfoutput query="qryCursos">
          <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboCurso="-999">
		</cfif>
      </select>
      Período:
      <select name="cboPeriodo" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='if (this.value == "-999") 
			              fnLoadcalificarCurso();
						else
						  fnReLoad();'>
          <option value="-999">CALIFICAR CURSO</option>
		<cfset LvarSelected="0">
		<cfset LvarSelectedActual="0">
		<cfset LvarSelectedPrimero="">
        <cfloop query="qryPeriodos">
		  <cfif currentRow eq 1>
		    <cfset LvarSelectedPrimero=Codigo>
		  </cfif>
          <cfif #form.cboPeriodo# eq #Codigo# >
		    <cfset LvarSelected="1">
		  </cfif>
          <cfif #form.cboPeriodo# eq #qryPeriodos.Actual# >
		    <cfset LvarSelectedActual="1">
		  </cfif>
        </cfloop>			  
		<cfif #LvarSelected# eq "0">
  		  <cfif #LvarSelectedActual# eq "0">
		    <cfset form.cboPeriodo=LvarSelectedPrimero>
		  <cfelse>
		    <cfset form.cboPeriodo=qryPeriodos.Actual>
		  </cfif>
		</cfif>
        <cfoutput query="qryPeriodos">
          <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
      </select>
	  
	  <br>
      <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
        <cfabort>
	  </cfif>
      Ordenamiento Componentes: 
      <select name="cboOrdenamiento" size="1" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange="fnReLoad();">
        <option value="0"<cfif form.cboOrdenamiento eq "0"> selected</cfif>>Cronológico</option>
        <option value="1"<cfif form.cboOrdenamiento eq "1"> selected</cfif>>Por Concepto</option>
        <option value="2"<cfif form.cboOrdenamiento eq "2"> selected</cfif>>Predefinido</option>
      </select>
	  <cfoutput>
        <input type="hidden" name="txtRows" value="#qryEstudiantes.recordCount#">
        <input type="hidden" name="txtCols" value="#qryComponentes.recordCount#">
	  </cfoutput>
      <br>
      <br>
    <cfif #qryConceptos.RecordCount# eq 0>
      <table>
          <tr><td bgcolor="#A9C6E1">El curso no ha sido planeado para el período indicado</td></tr>
      </table>
    <cfelseif not GvarPlaneado>
      <table>
        <tr><td bgcolor="#A9C6E1">El curso no se ha terminado de planear para el período indicado</td></tr>
      </table>
	</cfif>
      <table border="0" width="100%">
        <tr>
          <td valign="top">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="150" valign="top">
                  <div style="width:150px; overflow:hidden; border-right=1px solid #FFFFFF">
                    <table id="tblEstudiantes" border="0" cellspacing="0" cellpadding="0">
                      <tr class="linEnc">
                        <td class="linEnc" style="text-align:left;">Estudiante</td>
                        <td></td>
                      </tr>
                      <tr id="trPrcC1" class="linEncPrc"<cfif form.chkPorcentajesXConcepto neq "1"> style="display:none;"</cfif>>
                        
                    <td style="text-align:Left;">Porcentajes por Concepto</td>
                        <td></td>
                      </tr>
                      <tr id="trPrcP1" class="linEncProm"<cfif form.chkPorcentajesXPromedio neq "1"> style="display:none;"</cfif>>
                        <td style="text-align:Left;">Contribución al Promedio</td>
                        <td></td>
                      </tr>
                      <tr class="linEncProm">
                        
                    <td class="linEncProm" style="text-align:Left;">Cerrar Evaluaci&oacute;n</td>
                        <td></td>
                      </tr>
                      <tr class="tdInvisible">
                        <td></td>
                        <td></td>
                      </tr>
                      <cfset LvarPar="1">
                      <cfoutput query="qryEstudiantes">
                        <cfif LvarPar eq "1">
                          <cfset LvarPar="0">
                          <tr class="linPar">
            			<cfelse>
                          <cfset LvarPar="1">
                          <tr class="linImpar">
            			</cfif>
                            <td nowrap>#Nombre#</td>
                            <td><input type="hidden" name="txtEcodigo#currentRow#" value="#Codigo#"></td>
                          </tr>
            		  </cfoutput>
                      <tr id="trprm1"<cfif form.chkPromedioXComponente neq "1"> style="display:none;"</cfif>>
                        <td class="linEncProm" style="text-align:Left; font-weight:bold;">Promedio</td>
                      </tr>
                      <tr id="trprm1">
                        <td style="height:20px;">&nbsp;</td>
                      </tr>
                    </table>
                  </div>
                </td>
                <td  id="divWidth1" valign="top" style="BORDER: 0; PADDING: 0px; MARGIN: 0px; WIDTH: 255px; HEIGHT=100%;">
                  <DIV id="divWidth2" style="BORDER: 0; border-right=1px solid #FFFFFF;PADDING: 0px; MARGIN: 0px; WIDTH: 255px;  HEIGHT:100%;
				       OVERFLOW:<cfif find("Netscape",CGI.HTTP_USER_AGENT) eq 0>auto<cfelse>hidden</cfif>;">
                      <table id="tblNotas" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <cfoutput query="qryComponentes">
                          <td><div class="linEnc" style="font:9px; font-weight:bold;" title="#DescripcionEC#, #DescripcionCEC#">#DescripcionCEC#</div></td>
                          </cfoutput>			  
                        </tr>
                        <tr id="trPrcC2" class="linEncPrc"<cfif form.chkPorcentajesXConcepto neq "1"> style="display:none;"</cfif>>
                          <cfoutput query="qryComponentes">
                          <td class="linEncPrc">#PorcentajeCEC#%<BR>de<BR>#PorcentajeEC#%</td>
                          </cfoutput>			  
                        </tr>
                        <tr  id="trPrcP2" class="linEncProm"<cfif form.chkPorcentajesXPromedio neq "1"> style="display:none;"</cfif>>
                          <cfoutput query="qryComponentes">
                          <td class="linEncProm">#Porcentaje#%</td>
                          </cfoutput>			  
                        </tr>
                        <tr class="linEncProm">
                          <cfoutput query="qryComponentes">
                          
                        <td class="linEncProm"> 
                          <input name="chkCerrar#currentRow#" type="checkbox" 
                                 value="1"
								 class="linEncProm" style="border:0px"
								 <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">checked</cfif>
								 <cfif qryPeriodoCerrado.Cerrado eq "1">disabled</cfif>
                                 onClick="fnCerrarComponente(this,event);"> 
                        </td>
                          </cfoutput>			  
                        </tr>
                       <tr class="tdInvisible">
                          <cfoutput query="qryComponentes">
                          <td class="tdInvisible" style="width:101; height:15px";>
						    <input type="text" name="txtECcomponente#currentRow#" value="#CodigoCEC#" class="tdInvisible">
                            <cfif EVTcodigo neq ""><input type="text" name="txtEVTcodigo#currentRow#" class="tdInvisible" value="#EVTcodigo#"></cfif>
						  </td>
                          </cfoutput>			  
                        </tr>
                        <cfset LvarLins=qryEstudiantes.RecordCount>
                        <cfset LvarCols=qryComponentes.RecordCount>
                        <cfset LvarLin=1>
                        <cfset LvarCol=1>
                        <cfset LvarPar="Par">
                        <tr class="linPar">
                        <cfoutput>
						<cfloop query="qryNotas">
                          <td> 
                          <cfif Tabla eq "">
                            <input type="text" name="txtNota#LvarLin#_#LvarCol#" maxlength="6"
                                   class="txt#LvarPar#"
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPress(this, event);"
								   <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">Readonly</cfif>
								   value="<cfif Nota eq "-1"><cfelse>#Nota#</cfif>">
                          <cfelse>
                            <select name="cboValor#LvarLin#_#LvarCol#"
                                   class="txt#LvarPar#"
								   <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">onChange="this.value = GvarValueAnt;"</cfif>
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPress(this, event);">
                                <option value=""<cfif (Nota eq "" or Nota eq "-1") and Valor eq ""> selected</cfif>>&nbsp;</option>
								<cfset LvarNota=Nota>
								<cfset LvarValor=Valor>
                                <cfquery dbtype="query" name="qryValores">
                                   select Codigo, Equivalente, Minimo, Maximo
                                     from qryValoresTabla
                                    where Tabla = #Tabla#
                                    order by EVorden
                                </cfquery>
                                <cfloop query="qryValores">
                                <option value="#Equivalente#"
								<cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo) 
								   or (LvarValor neq "" and LvarValor eq Equivalente)> selected</cfif>>#Codigo#</option>
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
                        <tr class="lin#LvarPar#">
                          </cfif>
                          <cfset LvarCol=LvarCol+1>
                        </cfloop>
						</cfoutput>
                        </tr>
                        <tr id="trPrm2"<cfif form.chkPromedioXComponente neq "1"> style="display:none;"</cfif>>
						  <cfloop from="1" index="i" to="#qryComponentes.RecordCount#">
                          <td class="linEncProm">0.00</td>
						  </cfloop>
                        </tr>
                      </table>
                  </DIV>
                </td>
                <td width="102" valign="top">
                  <table id="tblPromedios" border="0" cellspacing="0" cellpadding="0">
                    <tr class="linEnc">
                      <td width="101">Progreso</td>
                      <td width="101">Ganado</td>
                      <td width="101">Ajuste</td>
                    </tr>
                    <tr id="trPrcC3" class="linEncPrc"<cfif form.chkPorcentajesXConcepto neq "1"> style="display:none;"</cfif>>
                      <td width="101">&nbsp;</td>
                      <td width="101">&nbsp;</td>
                      <td width="101">&nbsp;</td>
                    <tr id="trPrcP3" class="linEncProm"<cfif form.chkPorcentajesXPromedio neq "1"> style="display:none;"</cfif>>
                      <td width="101">&nbsp;</td>
                      <td width="101">&nbsp;</td>
                      <td width="101">&nbsp;</td>
                    </tr>
                    <tr class="linEncProm">
                      <td colspan="3" align="center"> Cerrar Per&iacute;odo: 
                        <input name="chkCerrarPeriodo" type="checkbox"
                               class="linEncProm" style="border:0px"
                               value="1"<cfif qryPeriodoCerrado.Cerrado eq "1"> checked</cfif>
                               onClick="fnCerrarPeriodo();"> 
					  </td>
                    </tr>
                    <tr class="tdInvisible">
                      <td></td>
                      <td></td>
                      <td>
                         <cfif GvarTablaMateria neq ""><input type="text" name="txtEVTcodigoM" class="tdInvisible" value="<cfoutput>#GvarTablaMateria#</cfoutput>"></cfif>
					  </td>
                    </tr>
					
                  <cfset LvarPar="Impar">
                  <cfoutput query="qryEstudiantes">
                    <cfif LvarPar eq "Par">
                      <cfset LvarPar="Impar">
                    <cfelse>
                      <cfset LvarPar="Par">
                    </cfif>
                    <tr class="lin#LvarPar#">
                      <td width="101" class="txt#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtProgreso#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
                                value="0">
					  </td>
                      <td width="101" class="txt#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtPromedio#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
                                value="0">
					  </td>
                    <cfif GvarTablaMateria eq "">
                      <td width="101" class="txt#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtAjuste#CurrentRow#"
                                <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">Readonly</cfif>
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPress(this, event);"
                                value="#Ajuste#">
 					  </td>
                    <cfelse>
                      <td width="101" class="txt#LvarPar#">
                         <select name="cboAjuste#CurrentRow#"
                                 <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">OnChange="this.value = GvarValueAnt;"</cfif>
                                 class="txt#LvarPar#"
                                 onFocus="return fnFocus(this,event);"
                                 onBlur="return fnBlur(this, event);"
                                 onKeyDown="return fnKeyDown(this, event);"
                                 onKeyPress="return fnKeyPress(this, event);">
								<cfset LvarNota=Ajuste>
								<cfset LvarValor=ValorAjuste>
                             <option value=""<cfif (LvarNota eq "" or LvarNota eq "-1") and LvarValor eq ""> selected</cfif>>&nbsp;</option>
                                <cfloop query="qryValoresMateria">
                             <option value="#Equivalente#"
								<cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo) 
								   or (LvarValor neq "" and LvarValor eq Equivalente)>selected</cfif>>#Codigo#</option>
                                </cfloop>
                         </select>
 					  </td>
                    </cfif>
                    </tr>
                  </cfoutput>
                    <tr id="trprm3"<cfif form.chkPromedioXComponente neq "1"> style="display:none;"</cfif>>
                      <td class="linEncProm" colspan="3" style="text-align=center; font-weight:bold; color:#0000FF;">0</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td></td>
          <td valign="top" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
            <table id="tblConceptos" border="0" cellspacing="0" cellpadding="0">
          <tr class="linEnc"> 
            <td id="tdNombreAlumno" width="350" colspan="6" style="border-Bottom: 1px solid #FFFFFF; text-align:left; font-size: 14px; ">.</td>
          </tr>
        <cfif #qryConceptos.RecordCount# neq 0>
          <tr class="linEncEva"> 
            <td align="center" style="border-right: 1px solid #FFFFFF"> <p align="left"><b>Concepto 
                de Evaluación</b></p></td>
            <td align="center" colspan="3" class="linEncProm"> <p align="center"><b>Avance 
                Evaluado</b> </td>
            <td align="center" class="linEncProm" colspan="2"> <p align="center"><b>Contribución<br>
                al Promedio</b></p></td>
          </tr>
          <tr class="linEncEva">
            <td align="center" style="border-right: 1px solid #FFFFFF">&nbsp;</td>
            <td align="center" class="linEncProm" style="border-top: 1px solid #FFFFFF"> 
			  <p align="center"><b>%Evaluado</b></p></td>
            <td align="center" class="linEncProm" style="border-top: 1px solid #FFFFFF"> 
              <p align="center"><b>Ganado</b></p></td>
            <td align="center" class="linEncProm" style="border-top: 1px solid #FFFFFF"> 
              <p align="center"><b>Progreso</b></p></td>
            <td align="center" class="linEncProm" style="border-top: 1px solid #FFFFFF"> 
              <p align="center"><b>%Concepto</b></p></td>
            <td align="center" class="linEncProm" style="border-top: 1px solid #FFFFFF"> 
              <p align="center"><b>%Ganado</b></p></td>
          </tr>
          <cfset LvarPar="1">
          <cfoutput query="qryConceptos">
            <cfif LvarPar eq "1">
              <cfset LvarPar="0">
              <tr class="linPar"> 
                <td>#DescripcionEC#</td>
                <td class="txtPar" align="right">0</td>
                <td class="txtPar" align="right">0</td>
                <td class="txtPar" align="right">0</td>
                <td class="txtPar" align="right" style="font-weight: bold">#PorcentajeEC#</td>
                <td class="txtPar" align="right">0</td>
              </tr>
			<cfelse>
              <cfset LvarPar="1">
              <tr class="linImpar"> 
                <td>#DescripcionEC#</td>
                <td class="txtImpar" align="right">0</td>
                <td class="txtImpar" align="right">0</td>
                <td class="txtImpar" align="right">0</td>
                <td class="txtImpar" align="right" style="font-weight: bold">#PorcentajeEC#</td>
                <td class="txtImpar" align="right">0</td>
              </tr>
			</cfif>
		  </cfoutput>
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Promedio Ganado</td>
            <td align="right">0</td>
            <td>&nbsp;</td>
            <td align="right" style="color: #0000FF">0</td>
            <td align="right">0</td>
            <td align="right" style="color: #0000FF">0</td>
          </tr>
          <cfif GvarTablaMateria neq "">
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Promedio Equivalente</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="center" style="color: #0000FF; font-weight: bold;">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="center" style="color: #0000FF; font-weight: bold;">&nbsp;</td>
          </tr>
          </cfif>		   
          <tr class="linEnc" style="font-weight: bold;"> 
            <td align="left">Resultado Asignado</td>
            <td align="center" colspan="4" nowrap width=202 style="color: #0000FF; font-weight: bold; overflow:hidden;">&nbsp;</td>
            <td align="center" style="font:12px; font-weight:bold; color: #0000FF; font-weight: bold;">&nbsp;</td>
          </tr>
        </table>
	    </cfif>
        <table border="0" width="100%" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
        <tr>
          <td valign="middle">
            Visualizar:
          </td>
            <td valign="middle">
            Digitar por:
          </td>
        </tr>
        <tr>
            <td valign="top"> <p> 
                <input type="checkbox" name="chkPorcentajesXConcepto" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPorcentajesXConcepto eq "1">checked</cfif>
                      onClick="fnPorcentajes(this,event,'C');" value="1">
                Porcentajes por Concepto<br>
                <input type="checkbox" name="chkPorcentajesXPromedio" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPorcentajesXPromedio eq "1">checked</cfif>
                       onClick="fnPorcentajes(this,event,'P');" value="1">
                Contribuci&oacute;n al Promedio <br>
                <input type="checkbox" name="chkPromedioXComponente" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPromedioXComponente eq "1">checked</cfif>
                       onClick="fnPromedio(this,event);" value="1">
                Promedios por Componente </p>
              </td>
            <td valign="top">
            <select name="chkXAlumno" size="1" 
			        style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;">
              <option value="false" selected>Calificacion</option>
              <option value="true">Alumno</option>
            </select>
          </td>
        </tr>
      </table>
	    <input name="btnGrabar" type="submit" value="Guardar" disabled>
        <input name="chkDesecharCambios" type="checkbox" value="1" checked onClick="document.frmNotas.btnGrabar.disabled=document.frmNotas.chkDesecharCambios.checked;"> Desechar Cambios
		</td>
        </tr>
      </table>
    <br>
    <br>
    </form>
  </body>
</html>
