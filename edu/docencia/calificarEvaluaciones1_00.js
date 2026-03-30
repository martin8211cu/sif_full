      var GvarEstudiante = "";
      function fnCalcularPromedios(LprmRow)
      {
	    if (!document.getElementById("chkCalcular").checked)
		  return;
		  
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTotal=0;
        var LvarProgreso=0;
        var LvarHayNotas=false;
		var LvarEst = LprmRow-GvarRow1;

        // Calcular Promedio del Estudiante
		fnInicializarCalculos(LvarEst);
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

        LvarTotEvaluado = 0;
		LvarTotProgreso = 0;
		LvarTotGanado   = 0;
		for (var c in LvarConceptosXEstudiante)
        {
          if (LvarConceptosXEstudiante[c].Evaluado > 0)
		  {
		    LvarTotEvaluado += GvarConceptos[c];
			LvarTotProgreso += LvarConceptosXEstudiante[c].Progreso * GvarConceptos[c]/100;
			LvarTotGanado     += LvarConceptosXEstudiante[c].Ganado * GvarConceptos[c]/100;
		  }
        }
        fnInputText(LvarTblPromedios.rows[LprmRow].cells[0]).value = fnFormatValorNota(LvarTotGanado, LvarHayNotas);
        fnInputText(LvarTblPromedios.rows[LprmRow].cells[1]).value = fnFormatValorNota(LvarTotProgreso*100/LvarTotEvaluado, LvarHayNotas);
		GvarConceptosXEstudiantes[LvarEst].Ajuste = fnInputText(LvarTblPromedios.rows[LprmRow].cells[2]).value;
      }

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
      function fnResize()
      {
        var LvarNotas = Math.floor((parseInt(document.body.clientWidth)-800)/50);
        if (LvarNotas<4)
          LvarNotas=4;
        else if (LvarNotas>GvarComponentesN)
          LvarNotas=GvarComponentesN;
        else if (LvarNotas>6) 
          LvarNotas=6;
        if (document.getElementById("divWidth2"))
        {
          document.getElementById("divWidth1").style.width=LvarNotas*51+1;
          document.getElementById("divWidth2").style.width=LvarNotas*51+1;
          document.getElementById("divWidth1").style.height=GvarEstudiantesN*21+135+20;
          document.getElementById("divWidth2").style.height=GvarEstudiantesN*21+135+20;
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

        var LvarChkCalcular = document.getElementById('chkCalcular').checked;
		document.getElementById('chkCalcular').checked = true; 

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
          i=i+2;
        }
        if (i == 0)
          var LvarNewCell = document.getElementById('tblPromedios').rows[GvarRow1].cells[2];
        else
        {
          var LvarNewCell = document.getElementById('tblNotas').rows[GvarRow1].cells[0];
        }
        /*var LvarInputText = fnInputText(LvarNewCell);
        if (LvarInputText != null)
        {
          //LvarInputText.focus();
        }*/

		document.getElementById('chkCalcular').checked = LvarChkCalcular; 
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
      function fnFocus(txtBox, e)
      {
        if (GvarRowAnt == -99)
          return false;

        if (txtBox.type == "text")
		{
          if (txtBox.readOnly == true)
		  {
            txtBox.style.border='1px dashed #CCCCCC';
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

          //txtBox.style.border='0px';
          if (txtBox.readOnly == true)
	      {
            txtBox.style.border='0px';
		  }
          else
          {
            txtBox.style.border='1px solid #CCCCCC';
          }

        }

        var LvarTD = txtBox.parentNode;
        var LvarTR = LvarTD.parentNode;
        var LvarTBL = LvarTR.parentNode.parentNode;
        var LvarCol = LvarTD.cellIndex;
        if (LvarTBL.id == "tblPromedios")
		    LvarCol = -1;
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
      function fnInputTextValorNota(LprmCelda)
      {
		var LvarValue = fnInputText(LprmCelda).value;
        if ( (GvarTablaMateria == "") || (fnVacio(LvarValue)) )
          return LvarValue;
		  
        for (var i=0; i<GvarTablaMateria.length; i++)
        {
          if ( LvarValue == GvarTablaMateria[i].Codigo )
            return GvarTablaMateria[i].Valor;
        }
        return "";
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
          if ( (LvarTotal>=GvarTablaMateria[i].Min) && (LvarTotal<=GvarTablaMateria[i].Max) )
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
      function fnRefrescarTblConceptos(LprmRow)
      {
	    if (!document.getElementById("chkCalcular").checked)
		  return;
		  
        if (LprmRow<0) 
		  return;
        var LvarTblConceptos = document.getElementById("tblConceptos");
        var LvarRow1 = 3;
        var LvarEst = LprmRow-GvarRow1;

        // Fila Alumno
        GvarRowAlumno = LprmRow;

        // Nombre del Alumno
        fnCambiarTD (document.getElementById("tdNombreAlumno"),
            document.getElementById("tblEstudiantes").rows[LprmRow].cells[0].firstChild.nodeValue);
		GvarEstudiante = document.getElementById("tblEstudiantes").rows[LprmRow].cells[1].firstChild.value;
        document.getElementById("tdCodigoAlumno").value = GvarEstudiante;

        // Promedios por Evaluacion
		var LvarConceptosXEstudiante = GvarConceptosXEstudiantes[LvarEst].Evaluaciones;
		var LvarTotProgreso = 0;
        var LvarTotEvaluado = 0;
        var LvarTotEvaluacion = 0;
        var LvarTotGanado = 0;
        var i=0;
        for (var c in LvarConceptosXEstudiante)
        {
		  //Ganado
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[1],
            fnFormat(LvarConceptosXEstudiante[c].Ganado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1+1].cells[0],
            fnFormat(LvarConceptosXEstudiante[c].Ganado*GvarConceptos[c]/100,2)+"%",(LvarConceptosXEstudiante[c].Evaluado==0));
		  //Evaluado
		  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[2],
            fnFormat(LvarConceptosXEstudiante[c].Evaluado,2)+"%");
		  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1+1].cells[1],
            fnFormat(LvarConceptosXEstudiante[c].Evaluado*GvarConceptos[c]/100,2)+"%",(LvarConceptosXEstudiante[c].Evaluado==0));
		  //Progreso
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[3],
            fnFormat(LvarConceptosXEstudiante[c].Progreso,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1+1].cells[2],
            fnFormat(LvarConceptosXEstudiante[c].Progreso*GvarConceptos[c]/100,2)+"%",(LvarConceptosXEstudiante[c].Evaluado==0));
		  //Porcentaje del Progreso
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[4],
            fnFormat(GvarConceptos[c],2)+"%");

          if (LvarConceptosXEstudiante[c].Evaluado > 0)
		  {
		    LvarTblConceptos.rows[i+LvarRow1].cells[4].style.fontWeight = "bold";
		    LvarTotEvaluado   += GvarConceptos[c];
            LvarTotProgreso   += LvarConceptosXEstudiante[c].Progreso * GvarConceptos[c]/100;
            LvarTotEvaluacion += LvarConceptosXEstudiante[c].Evaluado * GvarConceptos[c]/100;
			LvarTotGanado     += LvarConceptosXEstudiante[c].Ganado * GvarConceptos[c]/100;
		  }
		  else
		    LvarTblConceptos.rows[i+LvarRow1].cells[4].style.fontWeight = "normal";
          i= i + 2;
        }
		LvarRow1T = GvarConceptosN*2+LvarRow1;
        if (i>0)
        {
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[1],
                       fnFormat(LvarTotGanado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[2],
                       fnFormat(LvarTotEvaluacion,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[3],
                       fnFormat(LvarTotProgreso,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[4],
                       fnFormat(LvarTotEvaluado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[5],
                       fnFormat(LvarTotProgreso*100/LvarTotEvaluado,2)+"%");
          if (GvarTablaMateria == "")
		  {
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[5],
                         fnFormat(GvarConceptosXEstudiantes[LvarEst].Ajuste,2)+"%", (GvarConceptosXEstudiantes[LvarEst].Ajuste==0));
            if ( !fnVacio(GvarConceptosXEstudiantes[LvarEst].Ajuste) )
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[2],
                           fnFormat(GvarConceptosXEstudiantes[LvarEst].Ajuste,2)+"%");
			else
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[2],
                           fnFormatValorNota(LvarTotProgreso*100/LvarTotEvaluado,(LvarTotEvaluado>0) ));
		  }
          else
		  {
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[5],
                         fnFormatValorNota(LvarTotProgreso*100/LvarTotEvaluado,(LvarTotEvaluado>0),true ));
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[5],
                         fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,(GvarConceptosXEstudiantes[LvarEst].Ajuste>0),false ));
            if ( !fnVacio(GvarConceptosXEstudiantes[LvarEst].Ajuste) )
			{
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[1],
                           fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,true,false,true ));
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],
                           fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,true,false,false ));
			}
		    else
			{
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[1],
                           fnFormatValorNota(LvarTotProgreso*100/LvarTotEvaluado,(LvarTotEvaluado>0),false,true ));
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],
                           fnFormatValorNota(LvarTotProgreso*100/LvarTotEvaluado,(LvarTotEvaluado>0),false,false ));
			}
		  }
        }
      }
      function fnRefrescarPromediosXComponente(LprmCol)
      {
	    if (!document.getElementById("chkCalcular").checked)
		  return;
		  
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTotal=0;
        var LvarConta=0;
        var LvarTotalP=0;
        var LvarContaP=0;

        for (var i=0; i<GvarRow1-2; i++)
        {
	      if( (LvarTblPromedios.rows[i].cells[1]) && (document.frmNotas.chkCerrarPeriodo.checked) )
            LvarTblPromedios.rows[i].cells[0].style.display="none";
		  else
            LvarTblPromedios.rows[i].cells[0].style.display="";
		}
		
        for (var i=0; i<GvarEstudiantesN; i++)
        {
	      if(document.frmNotas.chkCerrarPeriodo.checked)
            LvarTblPromedios.rows[i+GvarRow1].cells[0].style.display="none";
		  else
            LvarTblPromedios.rows[i+GvarRow1].cells[0].style.display="";

          if ( (LprmCol>=0) && (GvarConceptosN > 0) )
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
          if ( fnVacio(LvarPromedio) )
            LvarPromedio = fnInputTextValorNota(LvarTblPromedios.rows[i+GvarRow1].cells[1]);
			  
          if (LvarPromedio != "")
          {
            LvarPromedio = parseFloat(LvarPromedio);
            LvarTotalP += LvarPromedio;
            LvarContaP ++;
          }
        }

        if ( (LprmCol>=0) && (GvarConceptosN > 0) )
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
      function fnVerificarCambios()
      {
        if (document.getElementById("chkDesecharCambios"))
		{
          var LvarCambios=document.getElementById("chkDesecharCambios").checked;
	      if (!LvarCambios)
		  {
	        document.getElementById("cboProfesor").selectedIndex=GvarProIndex;
            document.getElementById("cboCurso").selectedIndex=GvarCurIndex;
	        document.getElementById("cboPeriodo").selectedIndex=GvarPerIndex;
	        document.getElementById("cboOrdenamiento").selectedIndex=GvarOrdIndex;
		    alert("Grabe los cambios efectuados o marque la opcion 'Desechar cambios'");
            return false;
		  }
		}
		return true;
	  }
      function fnCerrarPeriodo()
	  {
        if (document.frmNotas.chkCerrarPeriodo.checked)
        {
          if ( (GvarComponentesN>0) && (!GvarPlaneado) )
		  {
		    alert ("El Curso no se ha terminado de planear, todavia no se puede cerrar el periodo");
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
              if ( fnVacio(LvarTblNotas.rows[i+GvarRow1].cells[j-1].firstChild.value) )
                if (confirm("Existen Evaluaciones sin calificar, las cuales no se tomaran en cuenta al calcular el promedio final. ¿Desea seguir con el cierre del Periodo?"))
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
          if (document.frmNotas.hdnCursoCerrado.value == "1")
          {
            alert("No se puede cerrar el periodo porque el curso ya fue cerrado. Modifique primero el curso");
            document.frmNotas.chkCerrarPeriodo.checked = true;
            return false;
       	  }
          for (var j=1; j<=GvarComponentesN; j++)
          {
            LvarChkCerrarI = eval("document.frmNotas.chkCerrar"+j);
            LvarChkCerrarI.disabled = false;
          }
        }
        fnRefrescarTblConceptos(GvarRowAlumno);
        fnRefrescarPromediosXComponente(-1);
        document.frmNotas.chkDesecharCambios.checked = false;
        document.frmNotas.btnGrabar.disabled = false;
        GvarRowAnt = -1;
	  }

      function fnCerrarComponente(chkBox, e)
	  {
	    if ( (GvarComponentesN>0) && (!GvarPlaneado) )
		{
		  alert ("El Curso no se ha terminado de planear, todavia no se puede cerrar el componente de evaluacion");
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
		    if ( fnVacio(LvarTblNotas.rows[i+GvarRow1].cells[LvarCol].firstChild.value) )
		      if (confirm("Existen Evaluaciones sin calificar, las cuales no se tomaran en cuenta al calcular el promedio final. ¿Desea seguir con el cierre de la Evaluacion?"))
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
      function fnVerPrms()
      {
        alert(
		          "Profesor=" + document.getElementById("cboProfesor").value +
			      ", Curso=" + document.getElementById("cboCurso").value +
			      ", Periodo=" + document.getElementById("cboPeriodo").value +
			      ", Estudiante=" + GvarEstudiante
			 );
	  }
      function fnChkCalcular()
	  {
	    if (!document.getElementById("chkCalcular").checked)
        {
            var LvarRow1 = 3;
            var LvarTblConceptos = document.getElementById("tblConceptos");
			i=0;
			for (var c in GvarConceptos)
			{
			  //Ganado
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[1],"");
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1+1].cells[0],"");
			  //Evaluado
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[2],"");
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1+1].cells[1],"");
			  //Progreso
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[3],"");
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1+1].cells[2],"");
			  //Porcentaje del Progreso
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[4],"");
	
			  i= i + 2;
			}
		    LvarRow1T = GvarConceptosN*2+LvarRow1;
			fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[1],"");
        	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[2],"");
          	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[3],"");
         	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[4],"");
         	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[5],"");
          	if (GvarTablaMateria == "")
		  	{
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[5],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[2],"");
		  	}
          	else
		  	{
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[5],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[5],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[1],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],"");
		  	}
		}
		else
		{
		  fnProcesoInicial();
		}
      }
	  