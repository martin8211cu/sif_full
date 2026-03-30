<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="15%" nowrap>
	  <select name="MensPara" onChange="javascript: verPara(this)">
		  <option value="7">Alumno(s) y Encargado(s)
		  <option value="3">Docente(s)
		  <option value="1">Director(es)
	  </select>
	</td>
    <td width="42%" align="center" nowrap>
		  <div style="display: ;" id="ver_Cursos"> 
		  	<b>Curso: </b>
			<select size="1" name="cboCurso" onChange="javascript: cambioCurso(this);">
				<option value="-1">*** TODOS LOS CURSOS ***</option>
			  <cfloop query="qryCursos">
				<option value="#Ccodigo#">#NombreCurso#</option>
			  </cfloop>
			</select>
		  </div>

		  <div style="display: ;" id="ver_Profes"> 
		     <b>Docente: </b>
			<select size="1" name="cboDocente">
			  <cfloop query="qryProfes">
				<option value="#persona#">#nombreProf#</option>
			  </cfloop>
			</select>
		  </div>					

		  <div style="display: ;" id="ver_Directores"> 
		     <b>Director: </b>
			<select size="1" name="cboDirector">
			  <cfloop query="qryDirectores">
				<option value="#persona#">#nombreDir#</option>
			  </cfloop>
			</select>
		  </div>
		  
	</td>
	<td width="42%" align="right" colspan="2" nowrap>
	  <label style="display: ;" id="paraAlumno"><b>Alumno(s): </b></label> 
	  <input type="text" size="40" name="txtEtiqueta" readonly="true" value="" style="border: none; background-color: Window;">
	  <input type="hidden" name="cboAlumno" value="">
	</td>
	<td width="1%" nowrap><div style="display: ;" id="ver_conlis"><a href="javascript: doConlisAlumnos(this);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></div></td>
  </tr>
  <tr id="trAlumnos">
	<td>&nbsp;</td>
	<td align="right" style="padding-right: 10px;"><b>Enviar a: </b></td>
	<td nowrap>
		<input type="checkbox" name="opEnvio1" value="1" checked> Alumno
	</td>
	<td nowrap>
		<input type="checkbox" name="opEnvio2" value="2"> Padres de Familia o Encargados
	</td>
	<td>&nbsp;</td>
  </tr>
</table>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	} 
	
	function cambioCurso(obj){
		obj.form.txtEtiqueta.value = "";
		obj.form.cboAlumno.value = "";
	}


	function doConlisAlumnos() {
		popUpWindow("conlisAlumnos.cfm?forma=frmMail"
					+"&txtEtiqueta=txtEtiqueta"
					+"&cboCurso=" + document.frmMail.cboCurso.value ,250,200,650,400);
	}

	function fnVerificarDatos(form) {
	  if (form.txtAsunto.value == "") {
		alert("ERROR: Digite el asunto del Comunicado");
		form.txtAsunto.focus();
		return false;
	  }
	  if (form.txtMSG.value == ""){
		alert("ERROR: Digite el mensaje del Comunicado");
		form.txtMSG.focus();
		return false;
	  }

	  if (form.MensPara.value == 7) {	// Cuando el mensaje es para Alumnos y Encargados
	  	 if (form.cboAlumno.value == "") {
			alert('Debe elegir un alumno a quien enviar el mensaje. Recuerde marcar si quiere enviar el mensaje solo al alumno, al encargado o a ambos.');
			return false;
		 } else {
			 if (form.cboCurso.value == "-1") {
				return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS los cursos?"));
			 }
		 }
	  }

	  return true;
	  
	}

	function verPara(obj){
		var connVer_Cursos		= document.getElementById("ver_Cursos");
		var connVer_Profes		= document.getElementById("ver_Profes");
		var connVer_Directores	= document.getElementById("ver_Directores");
		var connVer_TipoDest	= document.getElementById("trAlumnos");
		var connVer_paraAlumno	= document.getElementById("paraAlumno");
		var connVer_conlis		= document.getElementById("ver_conlis");
		
		if(obj.value == 7){	//Alumnos y Encargados
			connVer_Cursos.style.display = "";
			connVer_Profes.style.display = "none";
			connVer_Directores.style.display = "none";
			connVer_paraAlumno.style.display = "";
			connVer_TipoDest.style.display = "";
			connVer_conlis.style.display = "";
			cambioCurso(document.frmMail.cboCurso);
		} else if(obj.value == 3){	//Docentes
			connVer_Cursos.style.display = "none";
			connVer_Profes.style.display = "";
			connVer_Directores.style.display = "none";
			connVer_paraAlumno.style.display = "none";
			connVer_TipoDest.style.display = "none";
			connVer_conlis.style.display = "none";
			obj.form.txtEtiqueta.value = "";
		} else if(obj.value == 1){	// Directores
			connVer_Cursos.style.display = "none";
			connVer_Profes.style.display = "none";
			connVer_Directores.style.display = "";
			connVer_paraAlumno.style.display = "none";
			connVer_TipoDest.style.display = "none";
			connVer_conlis.style.display = "none";
			obj.form.txtEtiqueta.value = "";
		}
	}
	<cfif not isdefined('form.btnEnviar')>		
		verPara(document.frmMail.MensPara);
	</cfif>
		
</script>

