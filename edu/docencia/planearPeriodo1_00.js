      function fnCalcularTotal(txtBox, e)
      {
        if (txtBox.type == "text")
        {
          if ( ((txtBox.value != "")) && ((parseFloat(txtBox.value)>100.0) || (parseFloat(txtBox.value)<=0)) )
          {
            txtBox.select();
            txtBox.focus();
            return false;
          }

          if (txtBox.value != "")
            txtBox.value = fnFormat(txtBox.value,2,".");
        }

        var LvarTotal = 0;
        var LvarN = parseInt(document.frmPlan.txtCantidad.value);
        for (var i=1; i<=LvarN; i++)
        {
		  var LvarPrc = eval("document.frmPlan.txtECprc" + i);
		  if (LvarPrc.value != "")
		    LvarTotal = LvarTotal + parseFloat(LvarPrc.value);
		  else if (eval("document.frmPlan.chkECcmp" + i + ".checked"))
		  {
		    alert("El Concepto tiene evaluaciones planeadas en el periodo, no se puede borrar");
			LvarPrc.value="0.00";
			LvarPrc.focus();
            document.frmPlan.txtTotal.value = "0.00%";
			break;
		  }
		}

        document.frmPlan.txtTotal.value = fnFormat(LvarTotal,2) +"%";
        return true;
      }
      function fnReLoad()
      {
        //if (fnVerificarCambios())
		  if (document.getElementById("hdnTipoOperacion"))
            document.getElementById("hdnTipoOperacion").value = "";
          document.frmPlan.submit();
      }
      function fnNuevoEvento(LprmFecha)
      {
		 document.getElementById("hdnTipoOperacion").value = "";
         document.getElementById("hdnFecha").value = "{ts '" + LprmFecha.substr(0,4)+"-"+LprmFecha.substr(4,2)+"-"+LprmFecha.substr(6,2) + " 00:00:00'}";
         document.frmPlan.submit();
      }
      function fnTrabajarConEvento(LprmTipo,LprmFecha,LprmCodigo)
      {
         document.getElementById("hdnTipoOperacion").value = LprmTipo;
         document.getElementById("hdnFecha").value = "{ts '" + LprmFecha.substr(0,4)+"-"+LprmFecha.substr(4,2)+"-"+LprmFecha.substr(6,2) + " 00:00:00'}";
         document.getElementById("hdnCodigo").value = LprmCodigo;
         document.frmPlan.submit();
      }
      function fnCopiarFecha(LprmFecha)
      {
         var LvarTipoOperacion = document.getElementById("hdnTipoOperacion").value;
         if (LvarTipoOperacion == "CE")
		   fnNuevoEvento(LprmFecha.substr(6,4)+LprmFecha.substr(3,2)+LprmFecha.substr(0,2));
		 else if (document.frmPlan.txtFecha)
           document.frmPlan.txtFecha.value=LprmFecha;
      }
      function fnVerificarDatos()
      {
         var LvarTipoOperacion = document.getElementById("hdnTipoOperacion").value;
         if (LvarTipoOperacion == "CE")
		 {  
		   if (parseFloat(document.getElementById("txtTotal").value) == 100)
		     return true;
           alert ('ERROR: El Porcentaje Total debe sumar 100%');
           return false;
		 }
         if ( fnVacio(LvarTipoOperacion) ) 
         {
           alert ('ERROR: Escoja el tipo de Evento');
           return false;
         }
         if (LvarTipoOperacion == "R") 
         {
           if (!document.frmPlan.chkEvaluaciones.checked && !document.frmPlan.chkTemas.checked)
           {
             alert("ERROR: Escoja por lo menos un tipo de evento");
             return false;
           }
           if ( fnVacio(document.frmPlan.txtFecha.value) )
           {
             alert("ERROR: Digite la fecha a partir de la cual se va a recalendarizar");
             return false;
           }
           if ((document.frmPlan.cboTipoRecal.value=="Correr") && fnVacio(document.frmPlan.txtDuracion.value) )
           {
             alert("ERROR: Digite el numero de lecciones en blanco a procesar");
             return false;
           }
           if ((document.frmPlan.cboTipoRecal.value=="Pasar") &&  fnVacio(document.frmPlan.txtAlaFecha.value) )
           {
             alert("ERROR: Digite la fecha a la que se recalendarizaran los eventos");
             return false;
           }
           if ( fnVacio(document.frmPlan.txtOrden.value) )
           {
             document.frmPlan.txtOrden.value = "0";
           }
		   return true
		 }
         if ((LvarTipoOperacion == "E") && ( fnVacio(document.frmPlan.cboECcodigo.value) ))
           {
           alert("ERROR: El curso no ha sido planeado para el período indicado");
           return false;
         }
         if ( fnVacio(document.frmPlan.txtNombre.value) )
         {
           alert("ERROR: Digite el nombre corto del Evento");
           return false;
         }
         if ( fnVacio(document.frmPlan.txtDescripcion.value) )
         {
           document.frmPlan.txtDescripcion.value = document.frmPlan.txtNombre.value;
         }
         if ( fnVacio(document.frmPlan.txtFecha.value) )
         {
           alert("ERROR: Digite la fecha planeada del Evento");
           return false;
         }
         else 
         { 
           var LvarFecha = fnToDateYYYYMMDD(document.frmPlan.txtFecha.value);
           if (LvarFecha < GvarFechaInicial || LvarFecha > GvarFechaFinal)
           {
             alert("ERROR: La fecha planeada esta fuera del ciclo lectivo");
             return false;
           }
         }
         if ( fnVacio(document.frmPlan.txtDuracion.value) )
         {
           document.frmPlan.txtDuracion.value = "1";
         }
         else if (parseFloat(document.frmPlan.txtDuracion.value)>1)
         {
		   if (LvarTipoOperacion == "E")
		   {
             alert("ERROR: La evaluacion no puede durar mas de un dia lectivo");
             return false;
		   }
		   else if ( !confirm("Se indico una duracion mayor a '1', por tanto, despues de grabar el tema, este se va a copiar adicionalmente en los proximos '" + (Math.ceil(parseFloat(document.frmPlan.txtDuracion.value))-1) + "' dias lectivos, ¿desea continuar con la operacion?") )
		   {
		     return false;
		   }
         }
		 
         if ( fnVacio(document.frmPlan.txtOrden.value) )
         {
           document.frmPlan.txtOrden.value = "999";
         }
         return true;
      }

 function fnHayDatosCalificados()
      {  var LvarCalificado = document.getElementById("hdnCalificado").value;
        
		   if (parseFloat(document.getElementById("hdnCalificado").value) == 0)
		     return true;
           alert ('ERROR: No se puede borrar la Evaluacion, por que esta ya esta calificada!');
           return false;
	  }