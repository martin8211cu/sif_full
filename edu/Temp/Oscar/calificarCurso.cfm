<cfparam name="Session.CENEDCODIGO" default="5">
Session.CENEDCODIGO=5<br>
Soy Asistente<br>
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
  <cfif isdefined("form.#LprmChk#")>
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
  sbInitFromSessionChks("chkPromedioXPeriodo","1",isDefined("form.btnGrabar"));
</cfscript>

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
<cfquery datasource="Educativo" name="qryMateria">
    select EVTcodigo, m.Mconsecutivo, m.Melectiva as Tipo
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
<cfif GvarTablaMateria neq "">
  <cfquery datasource="Educativo" name="qryValores">
    select EVvalor as Codigo, EVdescripcion as Descripcion, 
           EVequivalencia as Equivalente, EVminimo as Minimo, EVmaximo as Maximo
      from EvaluacionValores
     where EVTcodigo = #GvarTablaMateria#
	 order by EVorden
  </cfquery>
</cfif>

<!--- 
VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL PROFESOR INDICADO
 --->
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
<cfif isDefined("form.btnGrabar")>
  <cfinclude template="calificarCurso_Grabar.cfm">
</cfif>

<cfquery datasource="Educativo" name="qryCursos">
  <cfif #form.cboProfesor# neq "0">
    select Ccodigo as Codigo, Cnombre as Descripcion
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = #Session.CENEDCODIGO#
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva <> 'E'    -- Que no sea un curso Electivo
<!--- 
	   and not exists(           -- Que no sea un curso Hijo de un Complementario
			select *
			  from MateriaElectiva ME, Curso CC, Materia MC
			 where m.Melectiva    = 'R'
			   and m.Mconsecutivo = ME.Mconsecutivo
			   and ME.Melectiva    = MC.Mconsecutivo
			   and MC.Mconsecutivo = CC.Mconsecutivo
			   and MC.Melectiva    = 'C'
			   and CC.CEcodigo     = c.CEcodigo
			   and CC.PEcodigo     = c.PEcodigo
			   and CC.SPEcodigo    = c.SPEcodigo
			   and CC.GRcodigo     = c.GRcodigo
               )
 --->
       and c.Splaza = #form.cboProfesor#
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
	   and m.Melectiva <> 'E'    -- Que no sea un curso Electivo
<!--- 
	   and not exists(           -- Que no sea un curso Hijo de un Complementario
			select *
			  from MateriaElectiva ME, Curso CC, Materia MC
			 where m.Melectiva    = 'R'
			   and m.Mconsecutivo = ME.Mconsecutivo
			   and ME.Melectiva    = MC.Mconsecutivo
			   and MC.Mconsecutivo = CC.Mconsecutivo
			   and MC.Melectiva    = 'C'
			   and CC.CEcodigo     = c.CEcodigo
			   and CC.PEcodigo     = c.PEcodigo
			   and CC.SPEcodigo    = c.SPEcodigo
			   and CC.GRcodigo     = c.GRcodigo
               )
 --->
       and c.Splaza       = null
       and m.Ncodigo      = v.Ncodigo
       and c.PEcodigo     = v.PEcodigo
       and c.SPEcodigo    = v.SPEcodigo
       and m.Ncodigo      = n.Ncodigo
    order by n.Norden, Cnombre
  </cfif>
</cfquery>
<cfquery datasource="Educativo" name="qryCursoCerrado">
  select isnull(max(ACCcerrado),'0') as Cerrado from AlumnoCalificacionCurso 
   where CEcodigo = #Session.CENEDCODIGO#
	 and Ccodigo  = #form.cboCurso#
</cfquery>
<cfquery datasource="Educativo" name="qryEstudiantes">
  select distinct a.Ecodigo as Codigo, p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre, 
         str(a.ACCnotacalculada,6,2) as Ajuste, 
         str(a.ACCnota,6,2) as Promedio, 
         str(a.ACCnotaprog,6,2) as Progreso, 
         a.ACCvalorcalculado as AjusteValor, 
         a.ACCvalor as PromedioValor, 
         a.ACCvalorprog as ProgresoValor, 
        (select isnull(max(ACPEcerrado),'0') from AlumnoCalificacionPerEval ac1
         where ac1.Ecodigo     = a.Ecodigo
           and ac1.CEcodigo    = #Session.CENEDCODIGO#
           and ac1.Ccodigo     = #form.cboCurso#) as Cerrado 
    from AlumnoCalificacionCurso a,
         Estudiante e, 
         PersonaEducativo p
   where a.Ccodigo      = #form.cboCurso#
     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona
  order by p.Papellido1, p.Papellido2, p.Pnombre
</cfquery>
<cfquery datasource="Educativo" name="qryPeriodos">
  select pe.PEcodigo Codigo, pe.PEdescripcion as Descripcion,
        (select isnull(max(ACPEcerrado),'0') 
		   from AlumnoCalificacionPerEval ac
          where ac.PEcodigo    = pe.PEcodigo
            and ac.CEcodigo    = c.CEcodigo
            and ac.Ccodigo     = c.Ccodigo
        ) as Cerrado
    from Curso c, Materia m, PeriodoEvaluacion pe
   where c.CEcodigo     = #Session.CENEDCODIGO#
     and c.Ccodigo      = #form.cboCurso#
     and c.Mconsecutivo = m.Mconsecutivo
     and m.Ncodigo      = pe.Ncodigo
  order by pe.PEorden
</cfquery>
<cfquery datasource="Educativo" name="qryNotas">
  select c.CEcodigo as Estudiante, 
         str(isnull(n.ACPEnotacalculada,n.ACPEnota),6,2) as NotaAsignada, 
		 str(isnull(n.ACPEnota,-999),6,2) as Ganado, 
		 str(isnull(n.ACPEnotacalculada,-999),6,2) as Ajuste, 
		 str(isnull(n.ACPEnotaprog,-999),6,2) as Progreso,
         isnull(n.ACPEvalorcalculado,n.ACPEvalor) as Valor,
        (select isnull(max(n2.ACPEcerrado),'0')
		    from AlumnoCalificacionPerEval n2
           where n2.PEcodigo     = pe.PEcodigo
             and n2.CEcodigo     = a.CEcodigo
             and n2.Ccodigo      = a.Ccodigo
		 ) as Cerrado
    from Curso c,                          -- Curso
         AlumnoCalificacionCurso a,        -- Alumnos de un Curso
		 Estudiante e,                     -- Join entre Alumno y Persona
		 PersonaEducativo p,               -- Catalogos de Personas
         AlumnoCalificacionPerEval n,      -- Calificaciones Alumno por Periodo
		 PeriodoEvaluacion pe,             -- Periodos de Evaluacion
		 Materia m
   where c.Ccodigo      = #form.cboCurso#

     and a.Ecodigo      = e.Ecodigo
     and a.CEcodigo     = #Session.CENEDCODIGO#
     and a.Ccodigo      = #form.cboCurso#

     and e.persona      = p.persona

     and pe.PEcodigo      *= n.PEcodigo
     and a.Ecodigo        *= n.Ecodigo
     and a.CEcodigo       *= n.CEcodigo
     and a.Ccodigo        *= n.Ccodigo

     and m.Mconsecutivo = c.Mconsecutivo
     and m.Ncodigo      = pe.Ncodigo
  order by p.Papellido1, p.Papellido2, p.Pnombre,
           pe.PEorden
</cfquery>
<html>
  
<head>
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px;
        HEIGHT:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
        background-color:#FF33CC;
        display:"none";
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
      var GvarRow1 = 3;
      var GvarRowN = 2;
      var GvarRowAlumno = -1;
      var GvarProIndex = 0;
      var GvarCurIndex = 0;
      var GvarPerIndex = 0;
      var GvarOrdIndex = 0;

      GvarValueAnt = "";
      GvarRowAnt = -1;

      var GvarPeriodosN = <cfoutput>#qryPeriodos.RecordCount#</cfoutput>;

      // Uno por Estudiante
      var GvarPeriodosXEstudiantes = new Array();
      <cfoutput>
        <cfset LvarCols=qryPeriodos.RecordCount>
        <cfset LvarEst = -1> 
        <cfset LvarPer = -1> 
        <cfloop query="qryNotas">
          <cfif CurrentRow mod LvarCols is 1>
		    <cfset LvarEst = LvarEst+1> 
		    <cfset LvarPer = -1> 
	  GvarPeriodosXEstudiantes[#LvarEst#] = new Array();
	      </cfif>
          <cfset LvarPer = LvarPer+1> 
	  GvarPeriodosXEstudiantes[#LvarEst#][#LvarPer#] = new objPXE(<cfif #Cerrado# eq "1">true<cfelse>false</cfif>, <cfif Progreso eq "" or Progreso eq -1>-999<cfelse>#Progreso#</cfif>, <cfif Ganado eq "" or Ganado eq -1>-999<cfelse>#Ganado#</cfif>, #Ajuste#);
        </cfloop>
	  </cfoutput>
      var GvarEstudiantesN = GvarPeriodosXEstudiantes.length;

<cfif GvarTablaMateria neq "">
      var GvarTablaMateria = new Array (
	  <cfoutput query="qryValores">
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

      function objPXE(Cerrado, Progreso, Ganado, Ajuste)
      {
          this.Cerrado   = Cerrado;
          this.Progreso  = Progreso;
          this.Ganado    = Ganado;
          this.Ajuste    = Ajuste;
		  if (Ajuste!=-999)
            this.Asignado  = Ajuste;
		  else if (Cerrado)
            this.Asignado  = Progreso;
		  else
            this.Asignado  = Ganado;
      }
      function objConceptoXEstudiante (Evaluaciones)
      {
          this.Evaluaciones = Evaluaciones;
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

        var LvarNewCell = txtBox;
        var LvarNewRow = null;
        var LvarTD = txtBox.parentNode;
        var LvarTR = LvarTD.parentNode;
        var LvarTB = LvarTR.parentNode;
        var LvarCol = LvarTD.cellIndex;
        var LvarRow = LvarTR.rowIndex;

        if (keycode == 46)    //DEL
          return true;
		  
        if (keycode == 13)    //ENTER
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
            txtBox.style.border='1px dotted #0099FF';
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
          fnRefrescarTblPeriodos(LvarRow);
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
          fnRefrescarTblPeriodos(LvarRow);
          fnRefrescarPromediosXPeriodo(LvarCol);
        }

        return true;
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
      function fnTrabajarConPeriodo(LprmPeriodo)
	  {
        var LvarHidden = document.createElement("INPUT");	
        LvarHidden.name = "cboPeriodo";
        LvarHidden.value = LprmPeriodo;
        LvarHidden.type = "hidden";
        document.frmNotas.appendChild(LvarHidden);
		document.frmNotas.action="calificarEvaluaciones.cfm";
		document.frmNotas.submit();
	  }
      function fnCerrarPeriodo()
	  {
        if (document.frmNotas.chkCerrarCurso.checked)
        {
		  for (var i=0; i<GvarPeriodosN; i++)
          {
            if (eval("document.frmNotas.chkCerrar"+(i+1)+".checked") != true)
        	{
              alert("No se puede cerrar el curso porque hay perídos abiertos. Modifique primero el período");
              document.frmNotas.chkCerrarCurso.checked=false;
              return false;
        	}
          }
        }
        document.frmNotas.chkDesecharCambios.checked = false;
        document.frmNotas.btnGrabar.disabled = false;
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
		    alert("Grabe los cambios efectuados o marque la opción 'Desechar cambios'");
            return false;
		  }
		}
		return true;
	  }
      function fnResize()
      {
        var LvarNotas = Math.floor((parseInt(document.body.clientWidth)-550)/50);
        if (LvarNotas<2)
          LvarNotas=2;
        <cfoutput>
        else if (LvarNotas>#qryPeriodos.recordCount#)
          LvarNotas=#qryPeriodos.recordCount#;
        </cfoutput>
        else if (LvarNotas>6)
          LvarNotas=6;
        document.getElementById("divWidth1").style.width=LvarNotas*51+1;
        document.getElementById("divWidth2").style.width=LvarNotas*51+1;
        //document.getElementById("divWidth3").style.width=LvarNotas*51;
      }
      function fnProcesoInicial()
      {
        fnResize();

        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblNotas = document.getElementById("TblNotas");
        var LvarRow1 = 3;
        GvarProIndex = document.getElementById("cboProfesor").selectedIndex;
        GvarCurIndex = document.getElementById("cboCurso").selectedIndex;

        if (!LvarTblNotas)
          return;

        for (var i=0; i<GvarEstudiantesN; i++)
        {
          fnCalcularPromedios(i+GvarRow1);
        }
        for (var i=0; i<GvarPeriodosN; i++)
        {
          fnRefrescarPromediosXPeriodo(i);
        }

        var LvarNewCell = document.getElementById('tblNotas').rows[GvarRow1].cells[0];
        var LvarInputText = fnInputText(LvarNewCell);
        if (LvarInputText != null)
        {
          LvarInputText.focus();
        }
      }
      function fnCalcularPromedios(LprmRow)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblCurso=document.getElementById("tblCurso");
        var LvarTotal=0;
		var LvarEst = LprmRow-GvarRow1;

         <cfset LvarLins=qryEstudiantes.RecordCount>
         <cfset LvarCols=qryPeriodos.RecordCount>
        // Calcular Promedio del Estudiante
        var LvarPeriodosXEstudiante = GvarPeriodosXEstudiantes[LvarEst];
		var LvarConta=0;
		var LvarContaProg=0;

        for (var i=0; i<GvarPeriodosN; i++)
        {
          var LvarNota = fnInputText(LvarTblNotas.rows[LprmRow].cells[i]).value;
          if (LvarNota != "")
          {
            LvarNota = parseFloat(LvarNota);

            LvarTotal += LvarNota;
			LvarConta ++;
			LvarContaProg ++;
          }
		  else if (!LvarPeriodosXEstudiante[i].Cerrado)
			LvarConta ++;
        }
          fnInputText(LvarTblCurso.rows[LprmRow].cells[0]).value =
                      fnFormatValorNota(LvarTotal/LvarContaProg,(LvarContaProg>0) );
          fnInputText(LvarTblCurso.rows[LprmRow].cells[1]).value =
                      fnFormatValorNota(LvarTotal/LvarConta,(LvarConta>0) );
      }
      function fnRefrescarTblPeriodos(LprmRow)
      {
        var LvarTblPeriodos = document.getElementById("TblPeriodos");
        var LvarRow1 = 2;
        var LvarEst = LprmRow-GvarRow1;

        // Fila Alumno
        GvarRowAlumno = LprmRow;

        // Nombre del Alumno
        fnCambiarTD (document.getElementById("tdNombreAlumno"),
            document.getElementById("tblEstudiantes").rows[LprmRow].cells[0].firstChild.nodeValue);

        // Promedios por Evaluacion
        var LvarTotEvaluado = 0;
        var LvarConta = 0;
		var LvarContaProg = 0;
        for (var i=0; i<GvarPeriodosN; i++)
        {
          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[1],
              fnFormatValorNota(GvarPeriodosXEstudiantes[LvarEst][i].Progreso,(GvarPeriodosXEstudiantes[LvarEst][i].Progreso != -999)));

          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[2],
              fnFormatValorNota(GvarPeriodosXEstudiantes[LvarEst][i].Ganado,(GvarPeriodosXEstudiantes[LvarEst][i].Ganado != -999)));
			
          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[3],
              fnFormatValorNota(GvarPeriodosXEstudiantes[LvarEst][i].Ajuste,(GvarPeriodosXEstudiantes[LvarEst][i].Ajuste != -999)));
			
          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[4],
              fnFormatValorNota(GvarPeriodosXEstudiantes[LvarEst][i].Asignado,(GvarPeriodosXEstudiantes[LvarEst][i].Asignado != -999)));
		  if (GvarPeriodosXEstudiantes[LvarEst][i].Asignado != -999)
          {
            LvarTotEvaluado += GvarPeriodosXEstudiantes[LvarEst][i].Asignado;
            LvarConta ++;
            LvarContaProg ++;
          }
		  else if (!GvarPeriodosXEstudiantes[LvarEst][i].Cerrado)
            LvarConta ++;
        }

        fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[1],
                     fnFormatValorNota(LvarTotEvaluado/LvarContaProg,(LvarContaProg>0) ));
        fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[2],
                     fnFormatValorNota(LvarTotEvaluado/LvarConta,(LvarConta>0)));
        var LvarTblCurso=document.getElementById("tblCurso");
        var LvarAjuste = fnInputText(LvarTblCurso.rows[LprmRow].cells[2]).value;
		var LvarNota = "";
		var LvarValor = 0;
		fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[3],
                     fnFormatValorNota(LvarAjuste,(LvarAjuste!="") ));
		if (LvarAjuste!="")
		{
		  LvarNota = fnFormatValorNota(LvarAjuste,(LvarAjuste!=""));
		  LvarValor = LvarAjuste;
		}
		else
		{
		  LvarNota = fnFormatValorNota(LvarTotEvaluado/LvarConta,(LvarConta>0));
		  LvarValor = LvarTotEvaluado/LvarConta;
		}

        fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[4],
                     LvarNota, (LvarNota!="") );

		if (GvarTablaMateria != "")
          fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1+1].cells[1],
                     fnFormatValorNota(LvarValor,(LvarNota!=""),false,true) );
      }
      function fnRefrescarPromediosXPeriodo(LprmCol)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblCurso");
        var LvarTotal=0;
        var LvarConta=0;
        var LvarTotalP=0;
        var LvarContaP=0;

        for (var i=0; i<GvarEstudiantesN; i++)
        {
          var LvarNota = fnInputText(LvarTblNotas.rows[i+GvarRow1].cells[LprmCol]).value;
          if (LvarNota != "")
          {
            LvarNota = parseFloat(LvarNota);
            LvarTotal += LvarNota;
            LvarConta ++;
          }

          var LvarPromedio = fnInputText(LvarTblPromedios.rows[i+GvarRow1].cells[1]).value;
          if (LvarPromedio == "")
            var LvarPromedio = fnInputText(LvarTblPromedios.rows[i+GvarRow1].cells[0]).value;
          if (LvarPromedio != "")
          {
            LvarPromedio = parseFloat(LvarPromedio);
            LvarTotalP += LvarPromedio;
            LvarContaP ++;
          }
        }
        if (LvarConta == 0)
          fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol], "");
		else
          fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol],
                     fnFormat(LvarTotal/LvarConta,2)+"%");

        if (LvarContaP == 0)
          fnCambiarTD (LvarTblPromedios.rows[GvarEstudiantesN+GvarRow1].cells[0], "");
		else
          fnCambiarTD (LvarTblPromedios.rows[GvarEstudiantesN+GvarRow1].cells[0],
                     fnFormat(LvarTotalP/LvarContaP,2)+"%");
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
              onChange="fnReLoad();">
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
              onChange="fnReLoad();">
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfoutput query="qryCursos">
          <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboCurso="-999">
		</cfif>
      </select>
  <br>
	  <cfoutput>
        <input type="hidden" name="txtRows" value="#qryEstudiantes.recordCount#">
        <input type="hidden" name="txtCols" value="#qryPeriodos.recordCount#">
	  </cfoutput>
  <br>
      <br>
	  
      <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
        <cfabort>
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
                      <tr class="linEncProm">
                        <td class="linEncProm" style="text-align:Left;">Período Cerrado</td>
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
                      <tr id="trprm1"<cfif form.chkPromedioXPeriodo neq "1"> style="display:none;"</cfif>>
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
                          <cfoutput query="qryPeriodos">
                          <td><div class="linEnc" style="font:9px; font-weight:bold;" title="#Descripcion#"><a href="javascript:fnTrabajarConPeriodo(#Codigo#)">#Descripcion#</a></div></td>
                          </cfoutput>        
                        </tr>
                        <tr class="linEncProm">
                        <cfoutput query="qryPeriodos">
                          <td class="linEncProm"> 
                            <input name="chkCerrar#currentRow#" type="checkbox" 
                                   value="1"
                                   class="linEncProm" style="border:0px"
                                   <cfif Cerrado eq "1">checked</cfif>
                                   disabled>
                          </td>
                        </cfoutput>        
                        </tr>
                        <tr class="tdInvisible">
                          <cfoutput query="qryPeriodos">
                          <td><input type="text" name="txtPEcodigo#currentRow#" class="tdInvisible" value="#Codigo#"></td>
                          </cfoutput>        
                        </tr>
                        <cfset LvarLins=qryEstudiantes.RecordCount>
                        <cfset LvarCols=qryPeriodos.RecordCount>
                        <cfset LvarLin=1>
                        <cfset LvarCol=1>
                        <cfset LvarPar="Par">
                        <tr class="linPar">
                        <cfoutput><cfloop query="qryNotas">
                          <td> 
                          <cfif Ajuste neq "-999">
                            <cfset LvarNotaAsignada = Ajuste>
                          <cfelseif Cerrado>
                            <cfset LvarNotaAsignada = Progreso>
                          <cfelse>
                            <cfset LvarNotaAsignada = Ganado>
                          </cfif>
                        <cfif GvarTablaMateria eq "">
                            <input type="text" name="txtNota#LvarLin#_#LvarCol#" maxlength="6"
                                   class="txt#LvarPar#"
                                   Readonly
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   value="<cfif LvarNotaAsignada eq "-999" or LvarNotaAsignada eq "-1"><cfelse>#LvarNotaAsignada#</cfif>">
                        <cfelse>
                            <select name="cboValor#LvarLin#_#LvarCol#"
                                   class="txt#LvarPar#"
                                   onChange="this.value = GvarValueAnt;"
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPress(this, event);">
                              <option value=""<cfif (LvarNotaAsignada eq "" or LvarNotaAsignada eq "-1") and Valor eq ""> selected</cfif>>&nbsp;</option>
                              <cfset LvarNota=LvarNotaAsignada>
                              <cfset LvarValor=Valor>
                              <cfloop query="qryValores">
                                <option value="#Equivalente#" <cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo)  or (LvarValor neq "" and LvarValor eq Equivalente)> selected</cfif>>#Codigo#</option>
                              </cfloop>
                            </select>
                        </cfif>
                          </td>
                      <cfif CurrentRow mod LvarCols is 0 and CurrentRow neq recordCount>
                        <cfset LvarLin=LvarLin+1>
                        <cfset LvarCol=0><cfif LvarPar neq "Par"><cfset LvarPar="Par"><cfelse><cfset LvarPar="Impar"></cfif>
                        </tr>
                        <tr class="lin#LvarPar#">
                      </cfif>
                          <cfset LvarCol=LvarCol+1>
                        </cfloop></cfoutput>

                        </tr>
                        <tr id="trPrm2"<cfif form.chkPromedioXPeriodo neq "1"> style="display:none;"</cfif>>
                        <cfloop from="1" index="i" to="#qryPeriodos.RecordCount#">
                          <td class="linEncProm">0.00</td>
                        </cfloop>
                        </tr>
                      </table>
                  </DIV>
			    </td>

                <td width="102" valign="top">
                  <table id="tblCurso" border="0" cellspacing="0" cellpadding="0">
                    <tr class="linEnc">
                      <td width="101">Progreso</td>
                      <td width="101">Ganado</td>
                      <td width="101">Ajuste</td>
                    </tr>
                    <tr class="linEncProm">
                      <td colspan="3" align="center"> Cerrar Curso: 
                        <input name="chkCerrarCurso" type="checkbox"
                               class="linEncProm" style="border:0px"
                               value="1"<cfif qryCursoCerrado.Cerrado eq "1"> checked</cfif>
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
                      <cfif LvarPar neq "Par">
                        <cfset LvarPar="Par">
					  <cfelse>
                        <cfset LvarPar="Impar">
					  </cfif>
                    <tr class="lin#LvarPar#">
                      <td width="101" class="txt#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtProgreso#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
                                value="#Progreso#">
					  </td>
                      <td width="101" class="txt#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtPromedio#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
                                value="#Promedio#">
					  </td>
                      <td width="101" class="txt#LvarPar#">
                       <cfif GvarTablaMateria eq "">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtAjuste#CurrentRow#"
                                <cfif qryCursoCerrado.Cerrado eq "1" or qryMateria.Tipo eq "C">Readonly</cfif>
                                onFocus="return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPress(this, event);"
                                value="#Ajuste#">
                       <cfelse>
                            <select name="cboAjuste#CurrentRow#"
                                   class="txt#LvarPar#"
                                   <cfif qryCursoCerrado.Cerrado eq "1" or qryMateria.Tipo eq "C">onChange="this.value = GvarValueAnt;"</cfif>
								   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPress(this, event);">
                                <option value=""<cfif (Ajuste eq "" or Ajuste eq "-1") and AjusteValor eq ""> selected</cfif>>&nbsp;</option>
						<cfset LvarNota=Ajuste>
						<cfset LvarValor=AjusteValor>
                        <cfloop query="qryValores">
                                <option value="#Equivalente#"
 							  <cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo) 
							     or (LvarValor neq "" and LvarValor eq Equivalente)> selected</cfif>>#Codigo#</option>
                        </cfloop>
                              </select>
                     </cfif>
 					  </td>
                    </tr>
                    </cfoutput>
                    <tr id="trprm3"<cfif form.chkPromedioXPeriodo neq "1"> style="display:none;"</cfif>>
                      <td class="linEncProm" colspan="3" style="text-align=center; font-weight:bold; color:#0000FF;">0</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td width="1px">
          </td>
          <td valign="top" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
            <table id="tblPeriodos" border="0" cellspacing="0" cellpadding="0">
          <tr class="linEnc"> 
            <td id="tdNombreAlumno" colspan="6" style="border-Bottom: 1px solid #FFFFFF; text-align:left; font-size: 14px; ">.</td>
          </tr>
          <tr class="linEncEva"> 
            <td align="left" style="border-right: 1px solid #FFFFFF">Per&iacute;odo</td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Progreso</b></p></td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>%Ganado</b></p></td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Ajuste</b></p></td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Nota Asignada</b></p></td>
          </tr>
          <cfset LvarPar="Impar">
          <cfoutput query="qryPeriodos"> 
		    <cfif LvarPar neq "Par">
              <cfset LvarPar="Par">
            <cfelse>
              <cfset LvarPar="Impar">
            </cfif>
            <tr class="lin#LvarPar#"> 
              <td>#Descripcion#</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align=center;"<cfelse>style="text-align=center;"</cfif>>0</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align=center;"<cfelse>style="text-align=center;"</cfif>>0</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align=center;"<cfelse>style="text-align=center;"</cfif>>0</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align=center;"<cfelse>style="text-align=center;"</cfif>>0</td>
            </tr>
          </cfoutput> 
          <tr class="linEnc" style="color: #0000FF"> 
            <td align="left">Resultado Curso</td>
            <td <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>>0</td>
            <td <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>>0</td>
            <td <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>>0</td>
            <td style="font:12px; font-weight:bold;" <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>>0</td>
          </tr>
        <cfif GvarTablaMateria neq "">
          <tr class="linEncProm" style="color: #0000FF"> 
            <td align="left">&nbsp;</td>
            <td align="center" colspan="4">0</td>
          </tr>
		</cfif>
          <!--- TABLA:
          <tr class="linEnc"> 
            <td align="left">&nbsp;</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
		  --->
        </table>
        <table border="0" width="100%" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
          <tr> 
            <td valign="middle"> Visualizar: </td>
          </tr>
          <tr> 
            <td valign="top"> <p> 
                <input type="checkbox" name="chkPromedioXPeriodo" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPromedioXPeriodo eq "1">checked</cfif>
                       onClick="fnPromedio(this,event);" value="1">
                Promedios por Periodo</p></td>
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
