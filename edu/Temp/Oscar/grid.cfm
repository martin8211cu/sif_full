<cfparam name="Session.CENEDCODIGO" default="5">
Session.CENEDCODIGO=5


<cfparam name="Session.Splaza"   default="-999">
<cfparam name="Session.Ccodigo"  default="-999">
<cfparam name="Session.PEcodigo" default="-999">
<cfparam name="Session.CEOrdenamiento"  default="0">

<cfparam name="form.cboProfesor" default="#Session.Splaza#">
<cfparam name="form.cboCurso"    default="#Session.Ccodigo#">
<cfparam name="form.cboPeriodo"  default="#Session.PEcodigo#">
<cfparam name="form.cboOrdenamiento"  default="#Session.CEOrdenamiento#">
<cfset Session.Splaza   = form.cboProfesor>
<cfset Session.Ccodigo  = form.cboCurso>
<cfset Session.PEcodigo = form.cboPeriodo>
<cfset Session.CEOrdenamiento = form.cboOrdenamiento>

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
<cfquery datasource="Educativo" name="qryCursos">
  <cfif #form.cboProfesor# neq "0">
    select Ccodigo as Codigo, Cnombre as Descripcion
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = #Session.CENEDCODIGO#
       and c.Mconsecutivo = m.Mconsecutivo
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
       and c.Splaza       = null
       and m.Ncodigo      = v.Ncodigo
       and c.PEcodigo     = v.PEcodigo
       and c.SPEcodigo    = v.SPEcodigo
       and m.Ncodigo      = n.Ncodigo
    order by n.Norden, Cnombre
  </cfif>
</cfquery>
<cfquery datasource="Educativo" name="qryPeriodos">
  select p.PEcodigo Codigo, p.PEdescripcion as Descripcion
    from Curso c, Materia m, PeriodoEvaluacion p
   where c.CEcodigo     = #Session.CENEDCODIGO#
     and c.Ccodigo      = #form.cboCurso#
     and c.Mconsecutivo = m.Mconsecutivo
     and m.Ncodigo      = p.Ncodigo
  order by p.PEorden
</cfquery>
<cfquery datasource="Educativo" name="qryComponentes">
  select ec.ECcodigo as CodigoEC,       ec.ECnombre as DescripcionEC,   str(ecc.ECCporcentaje,6,2) as PorcentajeEC, ec.ECorden as OrdenEC,
         cec.ECcomponente as CodigoCEC, cec.ECnombre as DescripcionCEC, str(cec.ECporcentaje,6,2) as PorcentajeCEC, str(ecc.ECCporcentaje*cec.ECporcentaje/100.0,6,2) as Porcentaje
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
  order by isnull(cec.ECreal, cec.ECplaneada)
  <cfelseif form.cboOrdenamiento eq 1>
  order by ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 2>
  order by cec.ECcomponente
  </cfif>
</cfquery>
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
</cfquery>
<cfquery dbtype="query" name="qryConceptos">
  select distinct CodigoEC, DescripcionEC, PorcentajeEC
    from qryComponentes
  order by OrdenEC
</cfquery>
<cfquery datasource="Educativo" name="qryEstudiantes">
  select a.Ecodigo as Codigo, p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre
    from AlumnoCalificacionCurso a, 
         Estudiante e, 
         PersonaEducativo p
   where a.Ccodigo      = #form.cboCurso#
     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona
  order by p.Papellido1, p.Papellido2, p.Pnombre
</cfquery>
<cfquery datasource="Educativo" name="qryNotas">
  select n.ACnota as Nota, n.ACvalor as Valor, cec.EVTcodigo as Tabla
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
     and cec.Ccodigo      *= n.Ccodigo
     and cec.ECcomponente *= n.ECcomponente
  order by p.Papellido1, p.Papellido2, p.Pnombre,
  <cfif form.cboOrdenamiento eq 0>
           isnull(cec.ECreal, cec.ECplaneada)
  <cfelseif form.cboOrdenamiento eq 1>
           ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 2>
           cec.ECcomponente
  </cfif>
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
        display:none;
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
        height:28px; width:50px;
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
        GvarConceptos["C#CodigoEC#"] = #PorcentajeEC#;
      </cfoutput>
      var GvarConceptosN = <cfoutput>#LvarCount#</cfoutput>;

      // Uno por Estudiante
      var GvarConceptosXEstudiantes = new Array();
      var GvarEstudiantesN = <cfoutput>#qryEstudiantes.RecordCount#</cfoutput>;

      // Uno por Calficacion
      var GvarComponentes = new Array(
      <cfset LvarCount=0>
      <cfoutput query="qryComponentes">
        <cfset LvarCount=LvarCount+1>
        <cfif LvarCount eq 1>
            new objCalificacion("C#CodigoEC#",#PorcentajeCEC#,#Porcentaje#)
        <cfelse>
          , new objCalificacion("C#CodigoEC#",#PorcentajeCEC#,#Porcentaje#)
        </cfif>
      </cfoutput>
        );
      var GvarComponentesN = GvarComponentes.length;

      function objCXE(Evaluado, Ganado, Progreso)
      {
          this.Evaluado   = Evaluado;
          this.Ganado     = Ganado;
          this.Progreso   = Progreso;
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

        var LvarXAlumno = eval(document.frmNotas.chkXAlumno.value);
        var LvarNewCell = txtBox;
        var LvarNewRow = null;
        var LvarTD = txtBox.parentNode;
        var LvarTR = LvarTD.parentNode;
        var LvarTB = LvarTR.parentNode;
        var LvarCol = LvarTD.cellIndex;
        var LvarRow = LvarTR.rowIndex;

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

            fnInputText(LvarNewCell).focus();
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

            fnInputText(LvarNewCell).focus();
            return false;
          }
        }
        else if (keycode == 39 && keyCtrl)  //DERECHA
        {
          if (LvarCol < LvarTR.cells.length-1)
            LvarNewCell = LvarTR.cells[LvarCol + 1];
          fnInputText(LvarNewCell).focus();
          return false;
        }
        else if (keycode == 37 && keyCtrl)  //IZQUIERDA
        {
          if (LvarCol > 0)
            LvarNewCell = LvarTR.cells[LvarCol - 1];
          fnInputText(LvarNewCell).focus();
          return false;
        }
        else if (keycode == 40 && keyCtrl)  //ABAJO
        {
          if (LvarRow < LvarTB.rows.length-GvarRowN)
          {
            LvarNewRow = LvarTB.rows[LvarRow + 1];
            LvarNewCell = LvarNewRow.cells[LvarCol];
          }
          fnInputText(LvarNewCell).focus();
          return false;
          }
          else if (keycode == 38 && keyCtrl)  //ARRIBA
          {
            if (LvarRow > GvarRow1)
            {
              LvarNewRow = LvarTB.rows[LvarRow - 1];
              LvarNewCell = LvarNewRow.cells[LvarCol];
            }

            fnInputText(LvarNewCell).focus();
            return false;
        }
        else if (keycode == 36 && keyCtrl)  //HOME
        {
          LvarNewCell = LvarTB.rows[LvarRow].cells[0];

          fnInputText(LvarNewCell).focus();
          return false;
        }
        else if (keycode == 35 && keyCtrl)  //END
        {
          LvarNewCell = LvarTB.rows[LvarRow].cells(LvarTR.cells.length-1);

          fnInputText(LvarNewCell).focus();
          return false;
        }
        else if (keycode == 33 && keyCtrl)  //PgUp
        {
          LvarNewCell = LvarTB.rows[GvarRow1].cells[LvarCol];

          fnInputText(LvarNewCell).focus();
          return false;
        }
        else if (keycode == 34 && keyCtrl)  //PgDn
        {
          LvarNewCell = LvarTB.rows[LvarTB.rows.length-GvarRowN].cells[LvarCol];

          fnInputText(LvarNewCell).focus();
          return false;
        }
      }
      function fnInputText(LprmTD)
      {
        for (var i=0; i<LprmTD.childNodes.length; i++)
          if (LprmTD.childNodes[i].nodeType == 1)
            return LprmTD.childNodes[i];
        return LprmTD;
      }
      function fnFocus(txtBox, e)
      {
        if (GvarRowAnt == -99)
          return false;

        if (txtBox.type == "text")
        {
          txtBox.style.border='1px solid #0099FF';
          txtBox.select();
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

        if (GvarValueAnt != txtBox.value)
        {
          document.getElementById("chkDesecharCambios").checked = false;
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
          fnInputText(LvarNewCell).focus();
        }

        return;
      }

      function fnActualizaAjuste(txtBox, e)
      {
        if (parseFloat(txtBox.value)>100.0)
        {
          txtBox.select();
          txtBox.focus();
          GvarRowAnt=-99;
          return;
        }

        GvarRowAnt=-1;
        if (txtBox.value != "")
          txtBox.value = fnFormat(txtBox.value,2,".");

        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarRow = GvarRowAlumno;
        fnInputText(LvarTblPromedios.rows[LvarRow].cells[1]).value = txtBox.value;
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
            LprmValor *= Math.abs(LprmValor);
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
        }
        else
        {
          document.getElementById("trprm1").style.display="none";
          document.getElementById("trprm2").style.display="none";
        }
      }
      function fnConcepto(chkBox, e)
      {
        if (chkBox.checked)
        {
          document.getElementById("tblConceptos").style.display="";
        }
        else
        {
          document.getElementById("tblConceptos").style.display="none";
        }
      }
      function fnCambiarTD(LprmTD,LprmTexto)
      {
        var LvarTexto = document.createTextNode(LprmTexto);
        LprmTD.replaceChild(LvarTexto,LprmTD.firstChild);
      }

      function fnVerificarCambios()
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
		return true;
	  }
      function fnProcesoInicial()
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblConceptos = document.getElementById("tblConceptos");
        var LvarRow1 = 3;
        GvarProIndex = document.getElementById("cboProfesor").selectedIndex;
        GvarCurIndex = document.getElementById("cboCurso").selectedIndex;
        GvarPerIndex = document.getElementById("cboPeriodo").selectedIndex;
        GvarOrdIndex = document.getElementById("cboOrdenamiento").selectedIndex;

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
        fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[4],
                     fnFormat(LvarTotPConcepto,2)+"%");
        var LvarNewCell = document.getElementById('tblNotas').rows[GvarRow1].cells[0];
        fnInputText(LvarNewCell).focus();
      }
      function fnCalcularPromedios(LprmRow)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTotal=0;
		var LvarEst = LprmRow-GvarRow1;

        // Calcular Promedio del Estudiante
        GvarConceptosXEstudiantes[LvarEst] = new objConceptoXEstudiante (new Array());
        <cfoutput query="qryConceptos">
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C#CodigoEC#"] = new objCXE(0,0,0);
        </cfoutput>
        var LvarConceptosXEstudiante = GvarConceptosXEstudiantes[LvarEst];

        for (var i=0; i<GvarComponentesN; i++)
        {
          var LvarNota = fnInputText(LvarTblNotas.rows[LprmRow].cells[i]).value;
          if (LvarNota != "")
          {
            LvarNota = parseFloat(LvarNota);

            LvarTotal += LvarNota*GvarComponentes[i].PNota/100;

            var c = GvarComponentes[i].Concepto;
            LvarConceptosXEstudiante.Evaluaciones[c].Evaluado += 
               GvarComponentes[i].PCalificacion;
            LvarConceptosXEstudiante.Evaluaciones[c].Ganado   += 
               LvarNota*GvarComponentes[i].PCalificacion/100;
            LvarConceptosXEstudiante.Evaluaciones[c].Progreso  =
               LvarConceptosXEstudiante.Evaluaciones[c].Ganado * 100 /
               LvarConceptosXEstudiante.Evaluaciones[c].Evaluado;
          }
        }
        fnCambiarTD (LvarTblPromedios.rows[LprmRow].cells[0],
                     fnFormat(LvarTotal,2)+"%");
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
        fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[1],
                     fnFormat(LvarTotEvaluado,2)+"%");
        fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[3],
                     fnFormat(LvarTotEvaluacion*100/LvarTotEvaluado,2)+"%");
        fnCambiarTD (LvarTblConceptos.rows[GvarConceptosN+LvarRow1].cells[5],
                     fnFormat(LvarTotEvaluacion,2)+"%");

        // Ajuste al Promedio
        var LvarTblPromedios=document.getElementById("tblPromedios");
        document.getElementById("txtAjuste").value =
            fnInputText(LvarTblPromedios.rows[LprmRow].cells[1]).value;
      }
      function fnRefrescarPromediosXComponente(LprmCol)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTotal=0;
        var LvarConta=0;

        for (var i=0; i<GvarEstudiantesN; i++)
        {
          var LvarNota = fnInputText(LvarTblNotas.rows[i+GvarRow1].cells[LprmCol]).value;
          if (LvarNota != "")
          {
            LvarNota = parseFloat(LvarNota);
            LvarTotal += LvarNota;
            LvarConta ++;
          }
        }
        if (LvarConta == 0)
          LvarConta=1;

        fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol],
                     fnFormat(LvarTotal/LvarConta,2)+"%");
      }
    -->
    </script>
  </head>

  <body onLoad="fnProcesoInicial();">
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
      Período:
      <select name="cboPeriodo" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange="fnReLoad();">
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfoutput query="qryPeriodos">
          <option value="#Codigo#"<cfif #form.cboPeriodo# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboPeriodo="-999">
		</cfif>
      </select>
	  <br>
      Ordenamiento Componentes: 
      <select name="cboOrdenamiento" size="1" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange="fnReLoad();">
        <option value="0"<cfif form.cboOrdenamiento eq "0"> selected</cfif>>Cronológico</option>
        <option value="1"<cfif form.cboOrdenamiento eq "1"> selected</cfif>>Por Concepto</option>
        <option value="2"<cfif form.cboOrdenamiento eq "2"> selected</cfif>>Predefinido</option>
      </select>
      <br>
      <br>
	  
  <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999" or #form.cboPeriodo# eq "-999">
    
    
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
                      <tr id="trPrcC1" class="linEncPrc">
                        <td style="text-align:Left;">Porcentajes del Concepto</td>
                        <td></td>
                      </tr>
                      <tr id="trPrcP1" class="linEncProm">
                        <td style="text-align:Left;">Contribución al Promedio</td>
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
                            <td nowrap>#Nombre#</td>
                            <td><input type="hidden" name="txtEcodigo#currentRow#"#Codigo#></td>
                          </tr>
            			<cfelse>
                          <cfset LvarPar="1">
                          <tr class="linImpar">
                            <td nowrap>#Nombre#</td>
                          </tr>
            			</cfif>
            		  </cfoutput>
                      <tr id="trprm1">
                        <td class="linEncProm" style="text-align:Left; font-weight:bold;">Promedio</td>
                      </tr>
                      <tr id="trprm1">
                        <td>&nbsp;</td>
                      </tr>
                    </table>
                  </div>
                </td>
                <td  valign="top" style="BORDER: 0; PADDING: 0px; MARGIN: 0px; WIDTH: 255px; HEIGHT=100%;">
                  <DIV style="BORDER: 0; border-right=1px solid #FFFFFF;PADDING: 0px; MARGIN: 0px; WIDTH: 255px; OVERFLOW: auto; HEIGHT:100%;">
                    <DIV style="BORDER: 0; PADDING: 0px; MARGIN: 0px; WIDTH:255px;">
                      <table id="tblNotas" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <cfoutput query="qryComponentes">
                          <td><div class="linEnc" title="#DescripcionEC#, #DescripcionCEC#">#DescripcionCEC#</div></td>
                          </cfoutput>			  
                        </tr>
                        <tr id="trPrcC2" class="linEncPrc">
                          <cfoutput query="qryComponentes">
                          <td class="linEncPrc">#PorcentajeCEC#%<BR>de<BR>#PorcentajeEC#%</td>
                          </cfoutput>			  
                        </tr>
                        <tr  id="trPrcP2" class="linEncProm">
                          <cfoutput query="qryComponentes">
                          <td class="linEncProm">#Porcentaje#%</td>
                          </cfoutput>			  
                        </tr>
                        <tr  id="trPrcP2" class="linEncProm">
                          <cfoutput query="qryComponentes">
                          <td class="tdInvisible"><input type="text" name="txtECcomponente#currentRow#" value="#CodigoCEC#" class="tdInvisible"></td>
                          </cfoutput>			  
                        </tr>
                        <cfset LvarLins=qryEstudiantes.RecordCount>
                        <cfset LvarCols=qryComponentes.RecordCount>
                        <cfset LvarLin=1>
                        <cfset LvarCol=1>
                        <cfset LvarPar=1>
                        <tr class="linPar">
                        <cfoutput><cfloop query="qryNotas">
                          <td> 
                          <cfif Tabla eq "">
                            <input type="text" name="txtNota#LvarLin#_#LvarCol#" maxlength="6"
                            <cfif LvarPar eq 1>
                                   class="txtPar"
                            <cfelse>
                                   class="txtImpar"
                            </cfif>
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPress(this, event);"
                                   value="#Nota#">
                          <cfelse>
                            <select name="cboValor#LvarLin#_#LvarCol#"
                            <cfif LvarPar eq 1>
                                   class="txtPar"
                            <cfelse>
                                   class="txtImpar"
                            </cfif>
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPress(this, event);">
                                <option value=""<cfif valor eq ""> selected</cfif>>&nbsp;</option>
                                <cfquery dbtype="query" name="qryValores">
                                   select Codigo, Equivalente
                                     from qryValoresTabla
                                    where Tabla = #Tabla#
                                    order by EVorden
                                </cfquery>
                                <cfoutput query="qryValores">
                                <option value="#Equivalente#"<cfif Valor eq Equivalente> selected</cfif>>#Codigo#</option>
                                </cfoutput>
                              </select>
                          </cfif>
                          </td>
                          <cfif CurrentRow mod LvarCols is 0 and CurrentRow neq recordCount>
                            <cfset LvarLin=LvarLin+1>
                        </tr>
                            <cfset LvarCol=1>
                            <cfif LvarPar eq 0>
                              <cfset LvarPar=1>
                        
                    <tr class="linPar">
                            <cfelse>
                              <cfset LvarPar=0>
                        <tr class="linImpar">
                            </cfif>
                          </cfif>
                          <cfset LvarCol=LvarCol+1>
                        </cfloop></cfoutput>
                        </tr>
                        <tr id="trPrm2">
						  <cfloop from="1" index="i" to="#qryComponentes.RecordCount#">
                          <td class="linEncProm">0.00</td>
						  </cfloop>
                        </tr>
                      </table>
                    </DIV>
                  </DIV>
                </td>
                <td width="102" valign="top">
                  <table id="tblPromedios" border="0" cellspacing="0" cellpadding="0">
                    <tr class="linEnc">
                      <td width="101" class="linEnc">Promedio</td>
                      <td width="101" class="tdInvisible">Ajuste</td>
                    </tr>
                    <tr id="trPrcC3" class="linEncPrc">
                      <td width="101">&nbsp;</td>
                      <td width="101"class="tdInvisible">&nbsp;</td>
                    <tr id="trPrcP3" class="linEncProm">
                      <td width="101">&nbsp;</td>
                      <td width="101"class="tdInvisible">&nbsp;</td>
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
                      <td width="101" class="txtPar">#qryEstudiantes.CurrentRow#</td>
                      <td width="101" class="tdInvisible">
                        <input type="text" class="tdInvisible" name="txtAjusteE" value="1">
                      </td>
                    </tr>
					  <cfelse>
                      <cfset LvarPar="1">
                    <tr class="linImpar">
                      <td width="101" class="txtImpar">80</td>
                      <td width="101" class="tdInvisible">
                        <input type="text" class="tdInvisible" name="txtAjusteE"
                               value="2">
                      </td>
                    </tr>
 					  </cfif>
                    </cfoutput>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td>
          </td>
          <td valign="top" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
            <table id="tblConceptos" border="0" cellspacing="0" cellpadding="0">
          <tr class="linEnc"> 
            <td id="tdNombreAlumno" colspan="6" style="border-Bottom: 1px solid #FFFFFF; text-align:left;">.</td>
          </tr>
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
            <td align="center" style="border-top: 1px solid #FFFFFF"> <p align="center"><b>%Evaluado</b></p></td>
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
          <tr class="linEnc"> 
            <td align="left">Promedio Final</td>
            <td align="right">0</td>
            <td></td>
            <td align="right" style="color: #0000FF">0</td>
            <td align="right">0</td>
            <td align="right" style="color: #0000FF">0</font></td>
          </tr>
          <tr class="linEnc"> 
            <td align="left">Ajuste</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td align="right" style="color: #0000FF"> <input type="text" class="txtPar" name="txtAju1" id="txtAjuste" maxlength="6"
                       onFocus="this.select();"
                       onBlur="fnActualizaAjuste(this, event);"
                       onKeyDown="fnEnterAjuste(this, event);"
                       onKeyPress="return fnKeyPress(this, event);" size="20"
                       style="border='1px solid #0099FF'; background-color:#A9C6E1;"> 
            </td>
          </tr>
        </table>
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
                      onClick="fnPorcentajes(this,event,'C');" value="1" checked>
                Porcentajes por Concepto<br>
                <input type="checkbox" name="chkPorcentajesXPromedio" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                     onClick="fnPorcentajes(this,event,'P');" value="1" checked>
                Porcentajes al Promedio <br>
                <input type="checkbox" name="chkPromedio" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                   onClick="fnPromedio(this,event);" value="1" checked>
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
	    <input name="btnGrabar" type="submit" value="Grabar">
        <input name="chkDesecharCambios" type="checkbox" value="1" checked> Desechar Cambios
		</td>
        </tr>
      </table>
    <br>
    <br>
    </form>
  </body>
</html>
