      function objPXE(Cerrado, Progreso, Ganado, Ajuste)
      {
          this.Cerrado   = Cerrado;
          this.Progreso  = Progreso;
          this.Ganado    = Ganado;
          this.Ajuste    = Ajuste;
		  if (Ajuste!=-999)
            this.Asignado  = Ajuste;
		  else
            this.Asignado  = Progreso;
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
      function fnFocus(txtBox, e)
      {
        if (GvarRowAnt == -99)
          return false;

        if (txtBox.type == "text")
		{
          if (txtBox.readOnly == true)
            txtBox.style.border='1px dashed #CCCCCC';
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
        if (LvarTBL.id == "tblCurso")
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
          fnRefrescarTblPeriodos(LvarRow);
		  fnRefrescarPromediosXPeriodo(LvarCol);
        }

        return true;
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
              alert("No se puede cerrar el curso porque hay periodos abiertos. Modifique primero el periodo");
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
		    alert("Grabe los cambios efectuados o marque la opcion 'Desechar cambios'");
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
        else if (LvarNotas>GvarPeriodosN)
          LvarNotas=GvarPeriodosN;
        else if (LvarNotas>6)
          LvarNotas=6;
        //document.getElementById("divWidth1").style.width=LvarNotas*51+1;
        //document.getElementById("divWidth2").style.width=LvarNotas*51+1;
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
        /*var LvarInputText = fnInputText(LvarNewCell);
        if (LvarInputText != null)
        {
          //LvarInputText.focus();
        }*/
      }
      function fnCalcularPromedios(LprmRow)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblCurso=document.getElementById("tblCurso");
        var LvarTotal=0;
		var LvarEst = LprmRow-GvarRow1;

        // Calcular Promedio del Estudiante
        var LvarPeriodosXEstudiante = GvarPeriodosXEstudiantes[LvarEst];
		var LvarConta=0;
		var LvarTotGanado=0;
		var LvarTotProgreso=0;

        for (var i=0; i<GvarPeriodosN; i++)
        {
		  if (LvarPeriodosXEstudiante[i].Asignado != -999)
          {
            if (LvarPeriodosXEstudiante[i].Ganado != -999)
              LvarTotGanado += LvarPeriodosXEstudiante[i].Ganado;
            LvarTotProgreso += LvarPeriodosXEstudiante[i].Asignado;
            LvarConta ++;
          }
        }
		LvarTotGanado = Math.round(LvarTotGanado*100)/100;
		LvarTotProgreso = Math.round(LvarTotProgreso*100)/100;
        fnInputText(LvarTblCurso.rows[LprmRow].cells[0]).value =
                     fnFormatValorNota(LvarTotGanado/LvarConta,(LvarConta>0) );
        fnInputText(LvarTblCurso.rows[LprmRow].cells[1]).value =
                     fnFormatValorNota(LvarTotProgreso/LvarConta,(LvarConta>0) );
      }
      function fnRefrescarTblPeriodos(LprmRow)
      {
        var LvarTblPeriodos = document.getElementById("tblPeriodos");
        var LvarRow1 = 2;
        var LvarEst = LprmRow-GvarRow1;

        // Fila Alumno
        var LvarPeriodosXEstudiante = GvarPeriodosXEstudiantes[LvarEst];
        GvarRowAlumno = LprmRow;

        // Nombre del Alumno
        fnCambiarTD (document.getElementById("tdNombreAlumno"),
            document.getElementById("tblEstudiantes").rows[LprmRow].cells[0].firstChild.nodeValue);
        document.getElementById("tdCodigoAlumno").value = 
		    document.getElementById("tblEstudiantes").rows[LprmRow].cells[1].firstChild.value;

        // Promedios por Evaluacion
        var LvarTotGanado = 0;
        var LvarTotProgreso = 0;
        var LvarConta = 0;
        for (var i=0; i<GvarPeriodosN; i++)
        {
          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[1],
              fnFormatValorNota(LvarPeriodosXEstudiante[i].Ganado,(LvarPeriodosXEstudiante[i].Ganado != -999)));
			
          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[2],
              fnFormatValorNota(LvarPeriodosXEstudiante[i].Progreso,(LvarPeriodosXEstudiante[i].Progreso != -999)));

          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[3],
              fnFormatValorNota(LvarPeriodosXEstudiante[i].Ajuste,(LvarPeriodosXEstudiante[i].Ajuste != -999)));
			
          fnCambiarTD (LvarTblPeriodos.rows[i+LvarRow1].cells[4],
              fnFormatValorNota(LvarPeriodosXEstudiante[i].Asignado,(LvarPeriodosXEstudiante[i].Asignado != -999)));

		  if (LvarPeriodosXEstudiante[i].Asignado != -999)
          {
            if (LvarPeriodosXEstudiante[i].Ganado != -999)
			  LvarTotGanado += LvarPeriodosXEstudiante[i].Ganado;
            LvarTotProgreso += LvarPeriodosXEstudiante[i].Asignado;
            LvarConta ++;
          }
        }
		LvarTotGanado = Math.round(LvarTotGanado*100)/100;
		LvarTotProgreso = Math.round(LvarTotProgreso*100)/100;
        fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[1],
                     fnFormatValorNota(LvarTotGanado/LvarConta,(LvarConta>0)));
        fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[2],
                     fnFormatValorNota(LvarTotProgreso/LvarConta,(LvarConta>0) ));

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
		  LvarNota = fnFormatValorNota(LvarTotProgreso/LvarConta,(LvarConta>0));
		  LvarValor = LvarTotProgreso/LvarConta;
		}

        fnCambiarTD (LvarTblPeriodos.rows[GvarPeriodosN+LvarRow1].cells[4],
                     LvarNota, (LvarNota=="") );

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
		  if (LprmCol >= 0)
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
          if (fnVacio(LvarPromedio))
            LvarPromedio = fnInputText(LvarTblPromedios.rows[i+GvarRow1].cells[1]).value;

          if (!fnVacio(LvarPromedio))
          {
			if (document.frmNotas.chkCursoCerrado == "")
              LvarPromedio = fnInputText(LvarTblPromedios.rows[i+GvarRow1].cells[0]).value;
			  
            LvarPromedio = parseFloat(LvarPromedio);
            LvarTotalP += LvarPromedio;
            LvarContaP ++;
          }
        }
	  if (LprmCol >= 0)
	  {
        if (LvarConta == 0)
          fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol], "");
		else
          fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol],
                     fnFormat(LvarTotal/LvarConta,2)+"%");
	  }

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
