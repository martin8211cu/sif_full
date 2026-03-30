      var GvarEstudiante = "";
	  var GvarNotasBlanco = false;
      function fnCalcularPromedios(LprmRow)
      {
	    if (!document.getElementById("chkCalcular").checked)
		  return;
		  
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTblAmpliacion = document.getElementById("tblExtras");
        var LvarTblAjuste=document.getElementById("tblAjuste");
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
			if (GvarComponentes[i].CEVtipoCalificacion == "2")
			{
	            LvarNota = parseFloat(LvarNota/GvarComponentes[i].CEVpuntosMax*100);
				if (LvarNota > 100) 
				{
					LvarTblNotas.rows[LprmRow].cells[i].firstChild.value = "ERROR";
					LvarNota = 0;
				}
			}
			else
	            LvarNota = parseFloat(LvarNota);

            LvarTotal += LvarNota*GvarComponentes[i].CEVaporte/100;
			LvarProgreso += GvarComponentes[i].CEVaporte/100;

            var c = GvarComponentes[i].Concepto;

            LvarConceptosXEstudiante[c].Evaluado += 
               GvarComponentes[i].CEVaporte;
            LvarConceptosXEstudiante[c].Ganado   += 
               LvarNota*GvarComponentes[i].CEVaporte/100;

			LvarConceptosXEstudiante[c].Progreso  =
               LvarConceptosXEstudiante[c].Ganado * 100 /
               LvarConceptosXEstudiante[c].Evaluado;
		  }
        }

		if (LvarTblAmpliacion)
		{
			for (var i=0; i<GvarAmpliacionesN; i++)
			{
				var LvarNota = fnInputText(LvarTblAmpliacion.rows[LprmRow].cells[i]).value;
				if (LvarNota != "")
				{
					if (document.getElementById("CAMtipoCalificacion"+(i+1)).value == "2")
					{
						LvarNota = parseFloat(LvarNota/parseFloat(document.getElementById("CAMpuntosMax"+(i+1)).value)*100);
						if (LvarNota > 100) 
						{
							LvarTblAmpliacion.rows[LprmRow].cells[i].firstChild.value = "ERROR";
							LvarNota = 0;
						}
					}
					else
						LvarNota = parseFloat(LvarNota);
				}

				var txtBox = fnInputText(LvarTblAjuste.rows[LprmRow].cells[0]);
				if (LvarNota!="" && txtBox.value == "" && LvarNota >= GvarMinimoAprobacion)
				{
					if (GvarCursoTipoCalificacion == "1")
						txtBox.value = GvarMinimoAprobacion;
					else if (GvarCursoTipoCalificacion == "2")
						txtBox.value = Math.round(GvarMinimoAprobacion/100*GvarCursoPuntosMax/GvarCursoUnidadMin+GvarCursoRedondeo)*GvarCursoUnidadMin;	
					else
						txtBox.selectedIndex = fnInxValorTablaMateria (GvarMinimoAprobacion)+1;  // La 0 es que no escoge nada
					fnAjustarNota(txtBox, null, GvarCursoTipoCalificacion, GvarCursoPuntosMax, GvarCursoUnidadMin, GvarCursoRedondeo)
				}
			}
		}

		LvarTotEvaluado = 0;
		LvarTotGanado   = 0;
		LvarTotProgreso = 0;
		LvarTotConcepto = 0;
		for (var c in LvarConceptosXEstudiante)
        {
          if (LvarConceptosXEstudiante[c].Evaluado > 0)
		  {
			LvarTotEvaluado   += LvarConceptosXEstudiante[c].Evaluado;
			LvarTotGanado     += LvarConceptosXEstudiante[c].Ganado;
			LvarTotProgreso   += LvarConceptosXEstudiante[c].Progreso * GvarConceptos[c] / 100; 
		    LvarTotConcepto   += GvarConceptos[c];
		  }
        }
		LvarTotProgreso = Math.round(LvarTotProgreso*10000/LvarTotConcepto)/100;
        fnInputText(LvarTblPromedios.rows[LprmRow].cells[0]).value = fnFormatValorNota(LvarTotGanado, LvarHayNotas);
        fnInputText(LvarTblPromedios.rows[LprmRow].cells[1]).value = fnFormatValorNota(LvarTotProgreso, LvarHayNotas);
		GvarConceptosXEstudiantes[LvarEst].Ajuste = fnInputText(LvarTblAjuste.rows[LprmRow].cells[0]).value;
		if (fnVacio(GvarConceptosXEstudiantes[LvarEst].Ajuste))
	        fnInputText(LvarTblAjuste.rows[LprmRow].cells[1]).value = fnFormatValorNota(LvarTotProgreso, LvarHayNotas);
		else
	    {
			if (GvarCursoTipoCalificacion == "2")
				GvarConceptosXEstudiantes[LvarEst].Ajuste = parseFloat(GvarConceptosXEstudiantes[LvarEst].Ajuste)/GvarCursoPuntosMax*100 + "";
	        fnInputText(LvarTblAjuste.rows[LprmRow].cells[1]).value = fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste, true);
		}
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
      function objCalificacion (Concepto, CEVpeso, CEVaporte, CEVtipoCalificacion, CEVpuntosMax)
      {
		  this.Concepto		= Concepto;
          this.CEVpeso 		= CEVpeso;
          this.CEVaporte	= CEVaporte;
          this.CEVtipoCalificacion	= CEVtipoCalificacion;
          this.CEVpuntosMax	= CEVpuntosMax;
      }
      function fnResize()
      {
        var LvarTblAmpliacion = document.getElementById("tblExtras");
		
        var LvarNotas = Math.floor((parseInt(document.body.clientWidth))/50);
/*
		if (LvarNotas<4)
          LvarNotas=4;
        if (LvarNotas>GvarComponentesN)
          LvarNotas=GvarComponentesN;
        if (LvarNotas>6) 
          LvarNotas=6;
*/
        if (GvarComponentesN>6)
          LvarNotas=6;
		else
		  LvarNotas=GvarComponentesN;
		
		if (LvarTblAmpliacion)
		{
			if (LvarNotas+GvarAmpliacionesN<=6)
			  LvarExtras=GvarAmpliacionesN;
			else if (GvarAmpliacionesN==1)
			{
			  LvarExtras=1;
	          LvarNotas-=1;
			}
			else
			{
			  LvarExtras=2;
	          LvarNotas-=2;
			}

			if (document.getElementById("divWidthExtras"))
			{
			  document.getElementById("tdWidthExtras").style.width=LvarExtras*52;
			  document.getElementById("divWidthExtras").style.width=LvarExtras*52+1;
			  document.getElementById("tdWidthExtras").style.height=GvarEstudiantesN*21+125;
			  document.getElementById("divWidthExtras").style.height=GvarEstudiantesN*21+125;
			}
		}
			
        if (document.getElementById("divWidthNotas"))
        {
          document.getElementById("tdWidthNotas").style.width=LvarNotas*(52);
          document.getElementById("divWidthNotas").style.width=LvarNotas*(52)+1;
          document.getElementById("tdWidthNotas").style.height=GvarEstudiantesN*21+117;
          document.getElementById("divWidthNotas").style.height=GvarEstudiantesN*21+117;
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
		if (document.getElementById("cboPeriodo"))
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

		document.getElementById('chkCalcular').checked = LvarChkCalcular; 
		for (var i=0; i<GvarComponentesN; i++)
        {
          	fnRefrescarPromediosXComponente(i);
        }
		if (GvarComponentesN == 0)
          fnRefrescarPromediosXComponente(0);
		  
        // Porcentajes de Evaluacion
        var LvarTotPConcepto=0;
        var i=0;
        if (i == 0)
          var LvarNewCell = document.getElementById('tblPromedios').rows[GvarRow1].cells[2];
        else
        {
          var LvarNewCell = document.getElementById('tblNotas').rows[GvarRow1].cells[0];
        }
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

        var LvarXAlumno = eval(document.frmNotas.cboXAlumno.value);
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
      function fnAjustarNota(txtBox, e, pTipoCalificacion, pPuntosMax, pUnidadMin, pRedondeo)
      {
		if (txtBox.type == "text")
		{
			var LvarValor = parseFloat(txtBox.value);
			if (txtBox.value != "")
			{
				if (pTipoCalificacion == '1')
				{
					if (LvarValor>100.0)
					{
						alert ('La evaluacion se debe calificar con un porcentaje de 0% a 100%');
						txtBox.select();
						txtBox.focus();
						return false;
					}
					txtBox.value = fnFormat(LvarValor,2,".");
				}
				else if (pTipoCalificacion == '2')
				{
					if (LvarValor>pPuntosMax)
					{
						alert ('La evaluacion se debe calificar con un puntaje de 0 a ' + pPuntosMax + ' puntos');
						txtBox.select();
						txtBox.focus();
						return false;
					}
					LvarValor = Math.round(LvarValor/pUnidadMin+pRedondeo) * pUnidadMin;
					var LvarDecs = pUnidadMin - parseInt(pUnidadMin);
					LvarDecs = parseInt(LvarDecs * 100);
					if (LvarDecs == 0)
					{
						txtBox.value = LvarValor;
					}
					else if ((LvarDecs-parseInt(LvarDecs/10)*10) == 0)
					{
						txtBox.value = fnFormat(LvarValor,1,".");
					}
					else
					{
						txtBox.value = fnFormat(LvarValor,2,".");
					}
				}
			}

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
		if (LvarTBL.id == "tblAjuste")
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
        if (GvarCursoTipoCalificacion == "1")
          return fnFormat(LvarTotal,2)+"%";
        if (GvarCursoTipoCalificacion == "2")
		{
			LvarTotal = LvarTotal*GvarCursoPuntosMax/100;
			LvarTotal = Math.round(LvarTotal/GvarCursoUnidadMin+GvarCursoRedondeo) * GvarCursoUnidadMin;
			var LvarDecs = GvarCursoUnidadMin - parseInt(GvarCursoUnidadMin);
			LvarDecs = parseInt(LvarDecs * 100);
			if (LvarDecs == 0)
			{
				return LvarTotal+"pts";
			}
			else if ((LvarDecs-parseInt(LvarDecs/10)*10) == 0)
			{
				return fnFormat(LvarTotal,1)+"pts";
			}
			else
			{
				return fnFormat(LvarTotal,2)+"pts";
			}
		}
		var i = fnInxValorTablaMateria (LvarTotal);
        var LvarCodigo = GvarTablaMateria[i].Codigo;
        var LvarValor = GvarTablaMateria[i].Valor;
        var LvarDescripcion = GvarTablaMateria[i].Descripcion;
		if (LvarConValor)
		  LvarCodigo = LvarCodigo + " = " + LvarValor + "%";
		if (LvarConDesc)
		  LvarCodigo = LvarDescripcion;
        return LvarCodigo;
      }
	  function fnInxValorTablaMateria (LvarTotal)
	  {
        var LvarMayor = -1;
        for (var i=0; i<GvarTablaMateria.length; i++)
        {
          if ( (LvarTotal>=GvarTablaMateria[i].Min) && (LvarTotal<=GvarTablaMateria[i].Max) )
          {
		    LvarCodigo = GvarTablaMateria[i].Codigo;
            LvarValor = GvarTablaMateria[i].Valor;
            LvarDescripcion = GvarTablaMateria[i].Descripcion;
			return i;
		  }
          else if (GvarTablaMateria[i].Valor>LvarMayor)
          {
            LvarCodigo = GvarTablaMateria[i].Codigo;
            LvarValor = GvarTablaMateria[i].Valor;
            LvarDescripcion = GvarTablaMateria[i].Descripcion;
            LvarMayor = GvarTablaMateria[i].Valor;
          }
        }
		return i-1;
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
        var LvarTotConcepto = 0;
        var LvarTotEvaluado = 0;
        var LvarTotGanado = 0;
        var LvarTotProgreso = 0;
        var i=0;
        for (var c in LvarConceptosXEstudiante)
        {
		  //Porcentaje del Progreso
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[1],
            fnFormat(GvarConceptos[c],2)+"%");
		  //Evaluado
		  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[2],
            fnFormat(LvarConceptosXEstudiante[c].Evaluado,2)+"%");
		  //Ganado
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[3],
            fnFormat(LvarConceptosXEstudiante[c].Ganado,2)+"%");
		  //Progreso
          fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[4],
            fnFormat(LvarConceptosXEstudiante[c].Progreso,2)+"%");

          if (LvarConceptosXEstudiante[c].Evaluado > 0)
		  {
		    LvarTblConceptos.rows[i+LvarRow1].cells[1].style.fontWeight = "bold";
		    LvarTblConceptos.rows[i+LvarRow1].cells[4].style.fontWeight = "bold";
		    LvarTotEvaluado   += LvarConceptosXEstudiante[c].Evaluado;
			LvarTotGanado     += LvarConceptosXEstudiante[c].Ganado;
			LvarTotProgreso   += LvarConceptosXEstudiante[c].Progreso * GvarConceptos[c] / 100; 
		    LvarTotConcepto   += GvarConceptos[c];
		  }
		  else
		  {
		    LvarTblConceptos.rows[i+LvarRow1].cells[1].style.fontWeight = "normal";
		    LvarTblConceptos.rows[i+LvarRow1].cells[4].style.fontWeight = "normal";
			fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[3],"");
			fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[4],"");
		  }
          i= i + 1;
        }
		if (i>0)
			LvarRow1T = GvarConceptosN+LvarRow1;
		else
			LvarRow1T = 2;
        //if (i>-10)
        if (true)
        {
		  LvarTotProgreso = Math.round(LvarTotProgreso*10000/LvarTotConcepto)/100;
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[1],
                       fnFormat(LvarTotConcepto,2)+"%");
          //fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[2],
          //             " "+fnFormat(LvarTotEvaluado,2)+"%");
          //fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[3],
          //             " "+fnFormat(LvarTotGanado,2)+"%");
          fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[4],
                       " "+fnFormat(LvarTotProgreso,2)+"%");

		  if (GvarCursoTipoCalificacion == "1")
		  {
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[4],
                         fnFormat(GvarConceptosXEstudiantes[LvarEst].Ajuste,2)+"%", (GvarConceptosXEstudiantes[LvarEst].Ajuste==0));
            if ( !fnVacio(GvarConceptosXEstudiantes[LvarEst].Ajuste) )
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[2],
                           fnFormat(GvarConceptosXEstudiantes[LvarEst].Ajuste,2)+"%");
			else
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[2],
                           fnFormatValorNota(LvarTotProgreso,(LvarTotProgreso>0) ));
		  }
		  else if (GvarCursoTipoCalificacion == "2")
		  {
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[4],
                         fnFormatValorNota(LvarTotProgreso,(LvarTotProgreso>0),true ));
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[4],
                         fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,(GvarConceptosXEstudiantes[LvarEst].Ajuste>0),false ));
            if ( !fnVacio(GvarConceptosXEstudiantes[LvarEst].Ajuste) )
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],
                           fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,2));
			else
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],
                           fnFormatValorNota(LvarTotProgreso,(LvarTotProgreso>0) ));
		  }
          else
		  {
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[4],
                         fnFormatValorNota(LvarTotProgreso,(LvarTotProgreso>0),true));
            fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[4],
                         fnFormatValorNota(GvarConceptosXEstudiantes[LvarEst].Ajuste,(GvarConceptosXEstudiantes[LvarEst].Ajuste>0),false));
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
                           fnFormatValorNota(LvarTotProgreso,(LvarTotProgreso>0),false,true ));
              fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],
                           fnFormatValorNota(LvarTotProgreso,(LvarTotProgreso>0),false,false ));
			}
		  }
        }
      }
      function fnRefrescarPromediosXComponente(LprmCol)
      {
        var LvarTblNotas=document.getElementById("tblNotas");
        var LvarTblPromedios=document.getElementById("tblPromedios");
        var LvarTblAjuste=document.getElementById("tblAjuste");

		if (!document.getElementById("chkCalcular").checked)
		{
			if ( (LprmCol>=0) && (GvarConceptosN > 0) )
				fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol], "");
			fnCambiarTD (LvarTblPromedios.rows[GvarEstudiantesN+GvarRow1].cells[0], "");
			fnCambiarTD (LvarTblPromedios.rows[GvarEstudiantesN+GvarRow1].cells[1], "");
			fnCambiarTD (LvarTblAjuste.rows[GvarEstudiantesN+GvarRow1].cells[0], "");
			return;
		}
		  
        var LvarTotal=0;
        var LvarConta=0;
        var LvarTotalP=0;
        var LvarContaP=0;
        var LvarTotalProgreso=0;
        var LvarTotalFinal=0;
        var LvarTotalP=0;
        var LvarContaP=0;

        for (var i=0; i<GvarEstudiantesN; i++)
        {
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

          var LvarProgreso = fnInputTextValorNota(LvarTblPromedios.rows[i+GvarRow1].cells[1]);
          var LvarFinal    = fnInputTextValorNota(LvarTblAjuste.rows[i+GvarRow1].cells[1]);
		  
 		  if (GvarCursoTipoCalificacion == "2")
		  {
			LvarProgreso = parseFloat(LvarProgreso)/GvarCursoPuntosMax*100 + "";
			LvarFinal = parseFloat(LvarFinal)/GvarCursoPuntosMax*100 + "";
		  }
			  
          if (LvarProgreso != "")
          {
            LvarTotalProgreso += parseFloat(LvarProgreso);
            LvarTotalFinal += parseFloat(LvarFinal);
            LvarContaP ++;
          }
        }

        if ( (LprmCol>=0) && (GvarConceptosN > 0) )
        {
          if (LvarConta == 0)
            fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol], "");
          else
            fnCambiarTD (LvarTblNotas.rows[GvarEstudiantesN+GvarRow1].cells[LprmCol],
                         fnFormat(LvarTotal/LvarConta,2)+((GvarComponentes[LprmCol].CEVtipoCalificacion != "2") ? "%" : ""));
        }
		
        fnCambiarTD (LvarTblPromedios.rows[GvarEstudiantesN+GvarRow1].cells[1],
                     fnFormatValorNota(LvarTotalProgreso/LvarContaP, (LvarContaP!=0)) );
        fnCambiarTD (LvarTblAjuste.rows[GvarEstudiantesN+GvarRow1].cells[1],
                     fnFormatValorNota(LvarTotalFinal/LvarContaP, (LvarContaP!=0)) );
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
			if (document.getElementById("cboPeriodo"))
		        document.getElementById("cboPeriodo").selectedIndex=GvarPerIndex;
	        document.getElementById("cboOrdenamiento").selectedIndex=GvarOrdIndex;
		    alert("Grabe los cambios efectuados o marque la opcion 'Desechar cambios'");
            return false;
		  }
		}
		return true;
	  }
      function fnCerrarPeriodo(LvarOperacion) // 1=Cerrar Evaluaciones 2=Deshibir Evaluaciones
	  {
	    if (!fnVerificarCambios())
          return false;

		if (LvarOperacion == 1)
        {
          if ( (GvarComponentesN>0) && (!GvarPlaneado) )
		  {
		    alert ("El Curso no se ha terminado de planear, todavia no se puede cerrar las calificaciones");
			return false;
		  }
		  for (var i=0; i<GvarComponentesN; i++)
          {
            if (eval("document.frmNotas.chkCerrar"+(i+1)+".checked") != true)
        	{
              if (!confirm("Existen evaluaciones abiertas, ¿Desea cerrar todas las evaluaciones?")) 
              {
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
			  	if (!GvarNotasBlanco)
				{
                  alert("Existen Evaluaciones sin calificar, debe calificarlas antes de poderla cerrar.")
                  return false;
				}
                else if (confirm("Existen Evaluaciones sin calificar, las cuales no se tomaran en cuenta al calcular el promedio final. ¿Desea continuar con el cierre de las Calificaciones?"))
                  break RevisarComponentes;
                else
                {
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
		else if (LvarOperacion == 2)
		{
          for (var j=1; j<=GvarComponentesN; j++)
          {
            LvarChkCerrarI = eval("document.frmNotas.chkCerrar"+j);
            LvarChkCerrarI.disabled = false;
          }
        }
		else if ((LvarOperacion == 3) && (GvarAmpliacionMala))
		{
			if (!confirm("Existen calificaciones en Examenes de Ampliacion que no corresponden. ¿Desea continuar con el cierre del Curso?"))
			  return false;
		}

		if (!document.getElementById('chkCalcular').checked) 
			fnProcesoInicial();

		document.frmNotas.action = "calificarEvaluaciones_SQL.cfm";
		return true;
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
			  if (!GvarNotasBlanco)
			  {
                  alert("Existen Evaluaciones sin calificar, debe calificarlas antes de poderla cerrar.")
    	 	      chkBox.checked = false;
                  return false;
			  }
		      else if (confirm("Existen Evaluaciones sin calificar, las cuales no se tomaran en cuenta al calcular el promedio final. ¿Desea seguir con el cierre de la Evaluacion?"))
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
		var LvarRow1 = 3;
		var LvarTblConceptos = document.getElementById("tblConceptos");
	    if (!document.getElementById("chkCalcular").checked)
        {
			i=0;
			for (var c in GvarConceptos)
			{
			  //Evaluado
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[2],"");
			  //Ganado
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[3],"");
			  //Progreso
			  fnCambiarTD (LvarTblConceptos.rows[i+LvarRow1].cells[4],"");
	
			  i= i + 1;
			}
		    LvarRow1T = GvarConceptosN+LvarRow1;
			fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[1],"");
        	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[2],"");
          	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[3],"");
         	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T].cells[4],"");
          	if (GvarTablaMateria == "")
		  	{
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[4],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[2],"");
		  	}
          	else
		  	{
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+1].cells[4],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+2].cells[4],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[1],"");
            	fnCambiarTD (LvarTblConceptos.rows[LvarRow1T+3].cells[2],"");
		  	}
		}
		else if (GvarRowAnt >= 0)
		{
          fnCalcularPromedios(GvarRowAnt);
          fnRefrescarTblConceptos(GvarRowAnt);
		}
	    fnProcesoInicial();
      }
	  