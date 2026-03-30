<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="15%" nowrap>
	  <select name="MensPara" onChange="javascript: verPara(this)">
		  <option value="3">Docente(s)
		  <option value="1">Director(es)
	  </select>
	</td>
    <td width="42%" align="center" nowrap>
		  <div style="display: ;" id="ver_Profes"> 
		     <b>Docente: </b>
			<select size="1" name="cboDocente">
				<option value="-1">*** TODOS LOS DOCENTES ***</option>
			  <cfloop query="qryProfes">
				<option value="#persona#">#nombreProf#</option>
			  </cfloop>
			</select>
		  </div>					

		  <div style="display: ;" id="ver_Directores"> 
		     <b>Director: </b>
			<select size="1" name="cboDirector">
				<option value="-1">*** TODOS LOS DIRECTORES ***</option>
			  <cfloop query="qryDirectores">
				<option value="#persona#">#nombreDir#</option>
			  </cfloop>
			</select>
		  </div>

	</td>
	<td width="43%" align="right" colspan="2" nowrap>&nbsp;
		
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

	  if (form.MensPara.value == 3) {	// Cuando el mensaje es para Docentes
		 if (form.cboDocente.value == "-1") {
			return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS los docentes?"));
		 }
	  } else if (form.MensPara.value == 1) {	// Cuando el mensaje es para Directores
		 if (form.cboDirector.value == "-1") {
			return (confirm("¿Esta seguro que desea enviar el comunicado a TODOS los directores?"));
		 }
	  }
	  
	  return true;
	  
	}

	function verPara(obj){
		var connVer_Profes		= document.getElementById("ver_Profes");
		var connVer_Directores	= document.getElementById("ver_Directores");
		
		if (obj.value == 3) {	//Docentes
			connVer_Profes.style.display = "";
			connVer_Directores.style.display = "none";
		} else if (obj.value == 1){	//Directores
			connVer_Profes.style.display = "none";
			connVer_Directores.style.display = "";
		}
	}
	<cfif not isdefined('form.btnEnviar')>	
		verPara(document.frmMail.MensPara);
	</cfif>
		
</script>
