<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="15%" nowrap>
	  <select name="MensPara" onChange="javascript: verPara(this)">
		  <option value="3">Docente(s) 
		  <option value="2">Hijo(s)
		  <option value="1">Director(es)
	  </select>
	</td>
    <td width="42%" align="center" nowrap>
		  <div style="display: ;" id="ver_Directores"> 
		     Director (a): 
			<select size="1" name="cboDirectorTemp" onChange="javascript: cambioDirector(this);">
			  <cfif qryDirectDistinc.recordCount GT 0>
				  <option value="-999">* * TODOS LOS DIRECTORES (AS) * *</option>
			  </cfif>
			  <cfloop query="qryDirectDistinc">
				<option value="#persona#">#NombreDir#</option>
			  </cfloop>
			</select>
		  </div>					

		  <div style="display: ;" id="ver_Hijos"> 
			<select size="1" name="cboHijoTemp">
			  <cfif qryHijos.recordCount GT 0>
				  <option value="-999">* * TODOS LOS HIJOS * *</option>
			  </cfif>
			  <cfloop query="qryHijos">
				<option value="#persona#">#nombreAl#</option>
			  </cfloop>
			</select>
		  </div>

		  <div style="display: ;" id="ver_MateDoc"> Materia : 
			<select size="1" name="cboMateDocTemp" onChange="javascript: cambioMate(this);">
			  <cfif qryMateXDoc.recordCount GT 0>
				  <option value="-999|* * TODOS LOS PROFESORES (AS) * *">* * TODAS LAS MATERIAS * *</option>
			  </cfif>
			  <cfloop query="qryMateXDoc">
				<option value="#Mconsecutivo#">#Mnombre#</option>
			  </cfloop>
			</select>
			<input type="hidden" name="cboDocenteTemp" value="">
		  </div>
	</td>
	<td width="43%" align="right" nowrap>
	  <label style="display: ;" id="paraProf"><b>Profesor (a):</b> </label> 
	  <label style="display: ;" id="paraDir"><b>Nivel Asociado:</b> </label>	
	  <label style="display: ;" id="paraCompa"><b>Compa&ntilde;eros (as):</b> </label> 
	  <input type="text" size="40" name="txtEtiqueta" readonly="true" value="" style="border: none; background-color: Window;">
	</td>
  </tr>
</table>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	var arrNivXDirect = new Array();	
	
	<cfloop query="qryNivelXDirec">
		arrNivXDirect[arrNivXDirect.length] = '<cfoutput>#qryNivelXDirec.Ncodigo#</cfoutput>' + '|' + '<cfoutput>#qryNivelXDirec.persona#</cfoutput>' + '|' + '<cfoutput>#qryNivelXDirec.Ndescripcion#</cfoutput>'; 
	</cfloop>

	function cambioDirector(obj){
		var temp = "";
		var temp2 = "";		
		if (obj.value == '-999'){
			temp = "** TODOS LOS DIRECTORES (AS) **";
		} else {
			for (var i=0; i<arrNivXDirect.length; i++) {
				temp2 = arrNivXDirect[i].split('|');
				if(temp2[1] == obj.value){
					temp = temp + (temp2[2] + ',');
				}
			}
		}
		obj.form.txtEtiqueta.value = temp;
	}	
	
	function cambioMate(obj){
		var temp = obj.value.split('|');
		
		if (temp[0]) obj.form.cboDocenteTemp.value = temp[0];
		if (temp[1]) obj.form.txtEtiqueta.value = temp[1];
	}
	
	function verPara(obj){
		var connVer_Directores	= document.getElementById("ver_Directores");
		var connVer_Hijos	= document.getElementById("ver_Hijos");	
		var connVer_MateDoc	= document.getElementById("ver_MateDoc");
		var connVer_paraProf	= document.getElementById("paraProf");			
		var connVer_paraDir	= document.getElementById("paraDir");
		var connVer_paraCompa	= document.getElementById("paraCompa");						
		
		if(obj.value == 1){	//Directores
			connVer_Directores.style.display = "";
			connVer_Hijos.style.display = "none";
			connVer_MateDoc.style.display = "none";						
			connVer_paraProf.style.display = "none";						
			connVer_paraDir.style.display = "";
			connVer_paraCompa.style.display = "none";				
			cambioDirector(document.frmMail.cboDirectorTemp);				
		} else if(obj.value == 2){	//Hijos
			connVer_Directores.style.display = "none";
			connVer_Hijos.style.display = "";			
			connVer_MateDoc.style.display = "none";											
			connVer_paraProf.style.display = "none";						
			connVer_paraDir.style.display = "none";					
			connVer_paraCompa.style.display = "none";				
			obj.form.txtEtiqueta.value = "";
		} else if(obj.value == 3){	// Docentes
			connVer_Directores.style.display = "none";
			connVer_Hijos.style.display = "none";			
			connVer_MateDoc.style.display = "";
			connVer_paraProf.style.display = "";						
			connVer_paraDir.style.display = "none";
			connVer_paraCompa.style.display = "none";				
			cambioMate(document.frmMail.cboMateDocTemp);
		}
	}
	<cfif not isdefined('form.btnEnviar')>		
		verPara(document.frmMail.MensPara);
	</cfif>
	
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
		  
	  if (form.MensPara.value == 1){	//Directores
		  if (form.cboDirectorTemp.value == "-999") {
			return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS lo directores del alumno?"));
		  } else if (form.cboDirectorTemp.value == "") {
		  	alert("ERROR: No hay ningún director a quien enviarle un mensaje");
			return false;
		  }
	  } else if (form.MensPara.value == 2) {	//Hijos
		  if (form.cboHijoTemp.value == "-999") {
			return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS sus hijos ?"));
		  } else if (form.cboHijoTemp.value == "") {
		  	alert("ERROR: No hay ningún Hijo a quien enviarle un mensaje");
			return false;
		  }
	  } else if (form.MensPara.value == 3){	//Profesores
		  if (form.cboDocenteTemp.value == "-999"){
			return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS lo profesores del alumno?"));
		  } else  if (form.cboDocenteTemp.value == "") {
		  	alert("ERROR: No hay ningún Profesor a quien enviarle un mensaje");
			return false;
		  }				  
	  }
	  
	  return true;
	}
</script>
