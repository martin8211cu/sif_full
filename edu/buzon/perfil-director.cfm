<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="15%"  valign="top" nowrap>
	  <select name="MensPara" onChange="javascript: verPara(this)">
		  <option value="3">Docente(s) 
		  <option value="7">Alumno(s) y Encargado(s)
		  <option value="1">Director(es)
	  </select>
	</td>
    <td align="center" colspan="2" nowrap>
		  <div style="display: ;" id="ver_MateDoc"> 
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td width="57%"><input type="radio" name="rdTipoDoc" checked value="1" onClick="javascript: rdNivel();">
			  Por Nivel</td>
			<td width="43%"><input type="radio" name="rdTipoDoc" value="2" onClick="javascript: rdTipoMateria();">
			  Por Tipo de Materia</td>
		  </tr>
		  <cfloop index="i" from="1" to="5">
			  <tr> 
				<td> <div style="display: ;" id="ver_Niveles#i#"> 
					<b>Niveles: </b>
					<select size="1" name="cboNivelesTemp#i#" onChange="javascript: cambioCombos(this,#i#);">
					  <option value="-1">** SELECCIONE EL NIVEL **</option>
					  <option value="-999">** TODOS LOS NIVELES **</option>						  
					  <cfloop query="qryNiveles">
						<option value="#Ncodigo#">#Ndescripcion#</option>
					  </cfloop>
					</select>
				  </div>
				  <div style="display: none;" id="ver_TiposMat#i#"><b>Tipo de materia: </b>
					<select size="1" name="cboTiposMatTemp#i#" onChange="javascript: cambioCombos(this,#i#);">
					  <option value="-1">** SELECCIONE EL TIPO DE MATERIA **</option>
					  <option value="-999">** TODOS LOS TIPOS DE MATERIA **</option>
					  <cfloop query="qryTiposMat">
						<option value="#MTcodigo#">#MTdescripcion#</option>
					  </cfloop>
					</select>
				  </div></td>
				<td nowrap><b>Docente: </b>
				  <input name="txtDocente#i#" type="text" id="txtDocente" size="35" maxlength="180" readonly="true"> 
				  <input type="hidden" name="cboDocenteTemp#i#" value="">					  
				  <a href="javascript: doConlisDocen(#i#);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a>
				  </td>
			  </tr>
		  </cfloop>
		</table>
		  </div>
		  
		  <div style="display: ;" id="ver_Grupos">
		  <table width="100%" cellpadding="0" cellspacing="0">
		  <tr>
		  	<td width="50%" align="center">
				<b>Grupo: </b>
				<select size="1" name="cboGrupo" onChange="javascript: cambioGrupo(this);">
				  <cfloop query="qryGrupos">
					<option value="#GRcodigo#">#GRnombre#</option>
				  </cfloop>
				</select>
			</td>
		  	<td width="49%" colspan="2">
			  <label style="display: ;" id="paraAlumno"><b>Alumno(s): </b></label> 
			  <input type="text" size="40" name="txtEtiqueta" readonly="true" value="" style="border: none; background-color: Window;">
			  <input type="hidden" name="cboAlumno" value="">
			</td>
			<td width="1%" nowrap><div style="display: ;" id="ver_conlis"><a href="javascript: doConlisAlumnos(this);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></div></td>
		  </tr>
		  <tr id="trAlumnos">
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
		  </div>
		  
		  <div style="display: ;" id="ver_Directores"> 
		  <table width="100%" cellpadding="0" cellspacing="0">
		  <tr>
		  	<td width="50%" align="center">
				 <b>Director: </b>
				<select size="1" name="cboDirector">
					<option value="-1">*** TODOS LOS DIRECTORES ***</option>
				  <cfloop query="qryDirectores">
					<option value="#persona#">#nombreDir#</option>
				  </cfloop>
				</select>
			</td>
		  	<td width="50%">&nbsp;
				
			</td>
		  </tr>
		  </table>
		  </div>
		  
	</td>
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

	function doConlisAlumnos() {
		popUpWindow("conlisAlumnosDir.cfm?forma=frmMail"
					+"&txtEtiqueta=txtEtiqueta"
					+"&cboGrupo=" + document.frmMail.cboGrupo.value ,250,200,650,400);
	}

	function doConlisDocen(opc) {
		var tipoLista = ((document.frmMail.rdTipoDoc[0].checked) ? 1 : 2);
					
		switch(opc){	//bloques (filas) de nivel o tipo de materia con el campo para el nombre del docente
			<cfloop index="i" from="1" to="5">
			<cfoutput>
			case #i#:{
				if(tipoLista == 1){	// para el Nivel
					if(document.frmMail.cboNivelesTemp#i#.value == "-1"){
						alert('Por favor elija un nivel');
					}else{
						popUpWindow("conlisDocentes.cfm?forma=frmMail"
									+"&txtDocente=txtDocente#i#"						
									+"&cboDocenteTemp=cboDocenteTemp#i#"
									+"&rdTipoDoc=" + tipoLista 
									+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp#i#.value
									+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp#i#.value,250,200,650,350);						
					}
				}else{	// Para el tipo de materia
					if(document.frmMail.cboTiposMatTemp#i#.value == "-1"){
						alert('Por favor elija un tipo de materia');
					}else{
						popUpWindow("conlisDocentes.cfm?forma=frmMail"
									+"&txtDocente=txtDocente#i#"						
									+"&cboDocenteTemp=cboDocenteTemp#i#"
									+"&rdTipoDoc=" + tipoLista 
									+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp#i#.value
									+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp#i#.value,250,200,650,350);						
					}					
				}	
			}
			break;
			</cfoutput>
			</cfloop>
		}
	}	

	function cambioCombos(obj,opc) {
		switch(opc) {
			<cfloop index="i" from="1" to="5">
			<cfoutput>
			case #i#: 
				obj.form.cboDocenteTemp#i#.value = "";					
				obj.form.txtDocente#i#.value = "";					
				break;
			</cfoutput>
			</cfloop>
		}
	}
		
	function rdTipoMateria(){
		<cfloop index="i" from="1" to="5">
		<cfoutput>
		var connVer_TiposMat	= document.getElementById("ver_TiposMat#i#");
		var connVer_Niveles		= document.getElementById("ver_Niveles#i#");
		connVer_TiposMat.style.display = "";
		connVer_Niveles.style.display = "none";
		document.frmMail.txtDocente#i#.value = "";
		document.frmMail.cboDocenteTemp#i#.value = "";
		cambioCombos(document.frmMail.cboNivelesTemp#i#,#i#);
		</cfoutput>
		</cfloop>
	}
	
	function rdNivel(){
		<cfloop index="i" from="1" to="5">
		<cfoutput>
		var connVer_TiposMat	= document.getElementById("ver_TiposMat#i#");
		var connVer_Niveles		= document.getElementById("ver_Niveles#i#");
		connVer_TiposMat.style.display = "none";
		connVer_Niveles.style.display = "";
		document.frmMail.txtDocente#i#.value = "";
		document.frmMail.cboDocenteTemp#i#.value = "";
		cambioCombos(document.frmMail.cboNivelesTemp#i#,#i#);
		</cfoutput>
		</cfloop>
	}

	function cambioGrupo(obj){
		obj.form.txtEtiqueta.value = "";
		obj.form.cboAlumno.value = "";
	}

	function fnVerificarDatos(form){
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
		  
		if(form.MensPara.value == 3) {	//solo valida cuando el mensaje es para el docente
			if(	((document.frmMail.cboDocenteTemp1.value == "-1") || (document.frmMail.cboDocenteTemp1.value == "")) &&
				((document.frmMail.cboDocenteTemp2.value == "-1") || (document.frmMail.cboDocenteTemp2.value == "")) &&
				((document.frmMail.cboDocenteTemp3.value == "-1") || (document.frmMail.cboDocenteTemp3.value == "")) &&
				((document.frmMail.cboDocenteTemp4.value == "-1") || (document.frmMail.cboDocenteTemp4.value == "")) &&
				((document.frmMail.cboDocenteTemp5.value == "-1") || (document.frmMail.cboDocenteTemp5.value == ""))){
				alert('debe elegir al menos un docente para el envio del comunicado');
				return false;
			} else {
				if (document.frmMail.rdTipoDoc[0].checked){	// para el Nivel
					if (document.frmMail.cboNivelesTemp1.value != "-1" && document.frmMail.cboDocenteTemp1.value == "") {
						alert('debe elegir el primer docente');
						return false;				
					}
					if (document.frmMail.cboNivelesTemp2.value != "-1" && document.frmMail.cboDocenteTemp2.value == ""){
						alert('Debe elegir el segundo docente');
						return false;					
					}
					if (document.frmMail.cboNivelesTemp3.value != "-1" && document.frmMail.cboDocenteTemp3.value == ""){
						alert('debe elegir el tercer docente');
						return false;				
					}
					if (document.frmMail.cboNivelesTemp4.value != "-1" && document.frmMail.cboDocenteTemp4.value == ""){
						alert('debe elegir el cuarto docente');
						return false;				
					}
					if (document.frmMail.cboNivelesTemp5.value != "-1" && document.frmMail.cboDocenteTemp5.value == ""){
						alert('debe elegir el quinto docente');
						return false;				
					}
				} else {	// para el Tipo de Materia
					if (document.frmMail.cboTiposMatTemp1.value != "-1" && document.frmMail.cboDocenteTemp1.value == "") {
						alert('debe elegir el primer docente');
						return false;				
					}
					if (document.frmMail.cboTiposMatTemp2.value != "-1" && document.frmMail.cboDocenteTemp2.value == ""){
						alert('Debe elegir el segundo docente');
						return false;					
					}
					if (document.frmMail.cboTiposMatTemp3.value != "-1" && document.frmMail.cboDocenteTemp3.value == ""){
						alert('debe elegir el tercer docente');
						return false;				
					}
					if (document.frmMail.cboTiposMatTemp4.value != "-1" && document.frmMail.cboDocenteTemp4.value == ""){
						alert('debe elegir el cuarto docente');
						return false;				
					}
					if (document.frmMail.cboTiposMatTemp5.value != "-1" && document.frmMail.cboDocenteTemp5.value == ""){
						alert('debe elegir el quinto docente');
						return false;				
					}
				}
			}
		} else if (form.MensPara.value == 7) {     // Cuando el mensaje es para Alumnos
			if (document.frmMail.cboAlumno.value == "") {
				alert('Debe elegir un alumno a quien enviar el mensaje. Recuerde marcar si quiere enviar el mensaje solo al alumno, al encargado o a ambos.');
				return false;
			}
		} else if (form.MensPara.value == 1) {	// Cuando el mensaje es para Directores
			if (form.cboDirector.value == "-1") {
				return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS los directores?"));
			}
		}
	  
	  return true;
	}
	
	function verPara(obj){
		var connVer_MateDoc		= document.getElementById("ver_MateDoc");
		var connVer_Grupo		= document.getElementById("ver_Grupos");
		var connVer_Directores	= document.getElementById("ver_Directores");
		var connVer_conlis		= document.getElementById("ver_conlis");
			
		if(obj.value == 3){	//Docentes
			connVer_MateDoc.style.display = "";
			connVer_Grupo.style.display = "none";
			connVer_Directores.style.display = "none";
			rdNivel();
		} else if(obj.value == 7){	//Alumnos y Encargados
			connVer_MateDoc.style.display = "none";
			connVer_Grupo.style.display = "";
			connVer_Directores.style.display = "none";
			cambioGrupo(document.frmMail.cboGrupo);
		} else if(obj.value == 1){	//Directores
			connVer_MateDoc.style.display = "none";
			connVer_Grupo.style.display = "none";
			connVer_Directores.style.display = "";
		}
	}
	<cfif not isdefined('form.btnEnviar')>		
		verPara(document.frmMail.MensPara);
	</cfif>
	
</script>
