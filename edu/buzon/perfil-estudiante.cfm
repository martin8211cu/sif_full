<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="15%" nowrap>
	  <select name="MensPara" onChange="javascript: verPara(this)">
		  <option value="6">Compañero(s) 
		  <option value="3">Docente(s) 
		  <option value="4">Encargado(s)
		  <!--- <option value="1">Director(es) --->
	  </select>
	</td>
    <td width="42%" align="center" nowrap>
		 <!---
		 <div style="display: ;" id="ver_Directores"> Director (a): 
			<select size="1" name="cboDirectorTemp" onChange="javascript: cambioDirector(this);">
			  <option value="-999">* * TODOS LOS DIRECTORES (AS) * *</option>
			  <cfloop query="qryDirectDistinc">
				<option value="#persona#">#NombreDir#</option>
			  </cfloop>
			</select>
		 </div>				  
		 --->
		 
		 <div style="display: ;" id="ver_Encargados"> 
			<select size="1" name="cboEncargadoTemp">
			  <option value="-999">* * TODOS MIS PADRES Y ENCARGADOS * *</option>
			  <cfloop query="qryEncargados">
				<option value="#persona#">#nombreEncar#</option>
			  </cfloop>
			</select>
		  </div>
		  
		  <div style="display: ;" id="ver_Compas"> 
			<select size="1" name="cboSustitTemp" onChange="javascript: cambioCompa(this);">
			  <option value="-999|<!--- ** TODOS LOS COMPAÑEROS **--->">Compañeros de Grupo</option>
			  <cfloop query="qrySustitutivas">
				<option value="#Ccodigo#">Compañeros de Electiva - #Cnombre#</option>
			  </cfloop>
			</select>
		  <input type="hidden" name="cboCompasTemp" value="">
		  <input type="hidden" name="unAlumno" value="">
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
	<td width="42%" align="right" nowrap>
	  <label style="display: ;" id="paraProf"><b>Profesor (a):</b> </label> 
	  <!--- <label style="display: ;" id="paraDir"><b>Nivel Asociado:</b> </label> --->
	  <label style="display: ;" id="paraCompa"><b>Compa&ntilde;eros (as):</b> </label> 
	  <input type="text" size="40" name="txtEtiqueta" readonly="true" value="" style="border: none; background-color: Window;">
	</td>
	<td width="1%" nowrap><div style="display: ;" id="ver_conlis"><a href="javascript: doConlisCompas(this);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></div></td>
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

	<!---
	var arrNivXDirect = new Array();	
	
	<cfloop query="qryNivelXDirec">
		arrNivXDirect[arrNivXDirect.length] = '<cfoutput>#qryNivelXDirec.Ncodigo#</cfoutput>' + '|' + '<cfoutput>#qryNivelXDirec.persona#</cfoutput>' + '|' + '<cfoutput>#qryNivelXDirec.Ndescripcion#</cfoutput>'; 
	</cfloop>

	function cambioDirector(obj){
		var temp = "";
		var temp2 = "";		
		if(obj.value == '-999'){
			temp = "** TODOS LOS DIRECTORES (AS) **";
		}else{
			for(var i=0;i<arrNivXDirect.length;i++) {
				temp2 = arrNivXDirect[i].split('|');
				
				if(temp2[1] == obj.value){
					temp = temp + (temp2[2] + ',');
				}
			}
		}
		
		obj.form.txtEtiqueta.value = temp;
	}	
	--->
	
	function cambioCompa(obj){
		var temp = obj.value.split('|');
		
		obj.form.cboCompasTemp.value = temp[0];
		obj.form.txtEtiqueta.value = temp[1];
		obj.form.unAlumno.value = "";
	}

	function cambioMate(obj){
		var temp = obj.value.split('|');
		
		if (temp[0]) obj.form.cboDocenteTemp.value = temp[0];
		if (temp[1]) obj.form.txtEtiqueta.value = temp[1];
	}
	
	function fnVerificarDatos(form) {
	  if (form.txtAsunto.value == "") {
		alert("ERROR: Digite el asunto del Comunicado");
		form.txtAsunto.focus();
		return false;
	  }
	  if (form.txtMSG.value == "") {
		alert("ERROR: Digite el mensaje del Comunicado");
		form.txtMSG.focus();
		return false;
	  }
	  
	  if (form.MensPara.value == 6) {	// Cuando el mensaje es para Compañeros
	  	 if (form.unAlumno.value == "") {
			alert('Debe elegir un compañero a quien enviar el mensaje');
			return false;
		 }
	  } 
	  
	  
	  return true;
	}

	function doConlisCompas() {
		cambioCompa(document.frmMail.cboSustitTemp);
		popUpWindow("conlisCompas.cfm?forma=frmMail"
					+"&txtEtiqueta=txtEtiqueta"
					+"&cboCompasTemp=cboCompasTemp"
					+"&cboCompasTempVAL=" + document.frmMail.cboCompasTemp.value,250,200,650,400);
	}
		
	function verPara(obj){
		<!---
		var connVer_Directores	= document.getElementById("ver_Directores");
		var connVer_paraDir		= document.getElementById("paraDir");
		--->
		var connVer_Encargados	= document.getElementById("ver_Encargados");
		var connVer_Compas		= document.getElementById("ver_Compas");			
		var connVer_MateDoc		= document.getElementById("ver_MateDoc");
		var connVer_paraProf	= document.getElementById("paraProf");			
		var connVer_paraCompa	= document.getElementById("paraCompa");
		var connVer_conlis		= document.getElementById("ver_conlis");
		<!---
		if(obj.value == 1){	//Directores
			connVer_Encargados.style.display = "none";		
			connVer_Compas.style.display = "none";						
			connVer_MateDoc.style.display = "none";						
			connVer_paraProf.style.display = "none";						
			connVer_paraCompa.style.display = "none";
			connVer_conlis.style.display = "none";
			<!---
			connVer_Directores.style.display = "";
			connVer_paraDir.style.display = "";
			cambioDirector(document.frmMail.cboDirectorTemp);
			--->
		} else
		--->
		if(obj.value == 4){	//Encargados
			<!---
			connVer_Directores.style.display = "none";
			connVer_paraDir.style.display = "none";
			--->
			connVer_Encargados.style.display = "";		
			connVer_Compas.style.display = "none";						
			connVer_MateDoc.style.display = "none";						
			connVer_paraProf.style.display = "none";						
			connVer_paraCompa.style.display = "none";
			connVer_conlis.style.display = "none";
			obj.form.txtEtiqueta.value = "";
		} else if(obj.value == 6){	// Compañeros
			<!---
			connVer_Directores.style.display = "none";
			connVer_paraDir.style.display = "none";
			--->
			connVer_Encargados.style.display = "none";		
			connVer_Compas.style.display = "";						
			connVer_MateDoc.style.display = "none";						
			connVer_paraProf.style.display = "none";						
			connVer_paraCompa.style.display = "";
			connVer_conlis.style.display = "";
			if(document.frmMail.cboSustitTemp.value == '-999'){
				obj.form.txtEtiqueta.value = "*** TODOS LOS COMPAÑEROS ***";
			} else {
				obj.form.txtEtiqueta.value = "";
			}
			cambioCompa(document.frmMail.cboSustitTemp);
		} else if (obj.value == 3) { // Docentes
			<!---
			connVer_Directores.style.display = "none";
			connVer_paraDir.style.display = "none";
			--->
			connVer_Encargados.style.display = "none";		
			connVer_Compas.style.display = "none";						
			connVer_MateDoc.style.display = "";
			connVer_paraProf.style.display = "";						
			connVer_paraCompa.style.display = "none";				
			connVer_conlis.style.display = "none";
			cambioMate(document.frmMail.cboMateDocTemp);
		}
	}
	<cfif not isdefined('form.btnEnviar')>		
		verPara(document.frmMail.MensPara);
	</cfif>
</script>
