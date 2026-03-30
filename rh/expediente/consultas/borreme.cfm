<cfparam name="FORM.RHEEID" type="numeric">
<!--- Consultas--->
<!--- Departamentos--->
<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ddescripcion
</cfquery>
<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Odescripcion
</cfquery>
<!--- JavaScript --->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript1.2" type="text/javascript">
 	<!--//
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	function funcAnterior(){
		document.form1.SEL.value = "1";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
	function mostrar_div(which){
		var div_cf = document.getElementById("div_CF");
		var div_od = document.getElementById("div_OD");
		if (which=="CF"){
			div_cf.style.display = '';
			div_od.style.display = 'none';
			document.form1.opt[0].checked = true;
			document.form1.opt[1].checked = false;}
		else{
			div_cf.style.display = 'none';
			div_od.style.display = '';
			document.form1.opt[0].checked = false;
			document.form1.opt[1].checked = true;}
	}

	function funcSiguiente(){
		document.form1.SEL.value = "3";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}

	
	//**********************************Tabla Dinámica**********************************************
	
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoCF()
	{

	  var LvarTable = document.getElementById("tblcf");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= document.form1.CFid.value.toString();//id
	  var p2 		= document.form1.CFcodigo.value;//cod
	  var p3 		= document.form1.CFdescripcion.value;//desc
	  var p4 		= document.form1.CFdependencias.checked;//agregar dependencias
	  
	  document.form1.CFid.value = "";
	  document.form1.CFcodigo.value = "";
	  document.form1.CFdescripcion.value = "";
	  document.form1.CFdependencias.checked = false;

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCF(p1)) {alert('Este Centro Funcional ya fue agregado.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + ((p4) ? "1" : "0"), "hidden", "CFidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2 + ' - ' + p3);
	  	
	  // Agrega Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, ((p4) ? "imgCheck" : "imgUnCheck"), "right");
	
	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	
	function fnNuevoOD()
	{

	  var LvarTable = document.getElementById("tblod");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneOD;
	  var p1t 		= document.form1.Ocodigo.value.toString();//Oficina
	  var p2t 		= document.form1.Dcodigo.value;//Departamento
	  
	  document.form1.Ocodigo.options[0].selected = true;
	  document.form1.Dcodigo.options[0].selected = true;

	  var p1d		= p1t.split("|");
	  var p2d		= p2t.split("|");
	  
	  var p1		= p1d[0];
	  var p2		= p1d[1];
	  var p3		= p2d[0];
	  var p4		= p2d[1];
	  
	  // Valida no agregar vacíos
	  if (p1=="") return;
	  if (p3=="") return
	  
	  // Valida no agregar repetidos
	  if (existeCodigoOD(p1,p3)) {alert('Esta Oficina / Departamento. ya fue agregada.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + p3, "hidden", "ODidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  	
	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p4);

	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	
	function fnNuevoPuesto()
	{

	  var LvarTable = document.getElementById("tblpuesto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOnePuesto;
	  var p1 		= document.form1.RHPcodigo.value.toString();//cod
	  var p2 		= document.form1.RHPdescpuesto.value;//desc
	  
	  document.form1.RHPcodigo.value="";
	  document.form1.RHPdescpuesto.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoPuesto(p1)) {alert('Este Puesto ya fue agregado.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "PuestoidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	function existeCodigoCF(v){
		var LvarTable = document.getElementById("tblcf");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}
	
	function existeCodigoOD(v1,v2){
		var LvarTable = document.getElementById("tblod");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v1 && data[1] == v2){
				return true;
			}
		}
		return false;
	}

	function existeCodigoPuesto(v){
		var LvarTable = document.getElementById("tblPuesto");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}
	
	//-->
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgCheck" src="/cfmx/rh/imagenes/checked.gif" title="" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">
<form action="registro_criterios_empleados_sql.cfm" method="post" name="form1">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0">
    <tr>
  	<td rowspan="8">&nbsp;</td>
	<td colspan="5"><p>Seleccione los criterios para agreagar empleados a la Relaci&oacute;n:</p></td>
	<td rowspan="8">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="5">&nbsp;</td>
  </tr>
<tr>
  	<td colspan="5">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  		<tr>
			<td><table border="0" cellspacing="0" cellpadding="0"><tr><td valign="top"><strong>Empleados incluidos antes de:</strong>&nbsp;</td><td valign="baseline"><cf_sifcalendario value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">&nbsp;</td></tr></table></td>
			<td>&nbsp;</td>
			<td valign="top"><input type="radio" name="opt" value="0" tabindex="1" onClick="javascript: mostrar_div('CF');">&nbsp;Centro Funcional</td>
			<td>&nbsp;</td>
			<td valign="top"><input type="radio" name="opt" value="1" tabindex="1" onClick="javascript: mostrar_div('OD');">&nbsp;Oficina/Departamento.</td>
		</tr>
		</table>
	</td>
  </tr>
    <tr>
  	<td valign="top" width="60%" colspan="3">
		<div id="div_CF" style="display:;">
		<fieldset><legend></legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="subtitulo_seccion_small">&nbsp;Centro Funcional</td>
		  </tr>
		  <tr>
			<td>
				<table id="tblcf" width="100%"    border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td></td>
					<td><strong>Centro Funcional:</strong>&nbsp;</td>
					<td></td>
					<td></td>
				  </tr>
				  <tr>
				    <td></td>
					<td>
						<cf_rhcfuncional size="20" tabindex="2"><!--- CFid, CFcodigo, CFdescripcion --->
					</td>
					<td nowrap>
						  <input type="checkbox" name="CFdependencias" tabindex="2"><strong>Incluir Dependencias</strong>
					</td>
					<td align="right">
						<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">
						<input type="button" name="agregarCF" onClick="javascript:if (window.fnNuevoCF) fnNuevoCF();" value="+" tabindex="2">
					</td>
				  </tr>
				  <tbody>
				  </tbody>
				</table>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
		</fieldset>
		</div>
		<div id="div_OD" style="display:none;">
		<fieldset><legend></legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="subtitulo_seccion_small">&nbsp;Oficina/Departamento.</td>
		  </tr>
		  <tr>
			<td>
				<table id="tblod" width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td></td>
					<td><strong>Oficina:</strong>&nbsp;</td>
					<td><strong>Departamento:</strong>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td></td>
					<td>
						<select name="Ocodigo" tabindex="2" >
							<cfoutput query="rsOficinas">
								<option value="#rsOficinas.Ocodigo#|#rsOficinas.Odescripcion#">#rsOficinas.Odescripcion#</option>				
							</cfoutput>
						</select>
					</td>
					<td>
						<select name="Dcodigo" tabindex="2">
							<cfoutput query="rsDepartamentos">
								<option value="#rsDepartamentos.Dcodigo#|#rsDepartamentos.Ddescripcion#">#rsDepartamentos.Ddescripcion#</option>
							</cfoutput>		
						</select>
					</td>
					<td align="right">
						<input type="hidden" name="LastOneOD" id="LastOneOD" value="ListaNon">
						<input type="button" name="agregarOD" onClick="javascript:if (window.fnNuevoOD) fnNuevoOD();" value="+" tabindex="2">
					</td>
				  </tr>
				  <tbody>
				  </tbody>
				</table>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>				
		</fieldset>
		</div>
		<script language="JavaScript" type="text/javascript">
			mostrar_div('CF');
		</script>
	</td>
	<td width="2%">&nbsp;</td>
	<td valign="top" width="38%">
		<fieldset><legend></legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="subtitulo_seccion_small">&nbsp;Puestos</td>
		  </tr>
		  <tr>
			<td>
				<table id="tblpuesto" width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td></td>
					<td><strong>Puesto:</strong>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
				  	<td></td>
					<td>
						<cf_rhpuesto size="20" tabindex="3">
					</td>
					<td align="right">
						<input type="hidden" name="LastOnePuesto" id="LastOnePuesto" value="ListaNon" tabindex="3">
						<input type="button" name="agregarPuesto" onClick="javascript:if (window.fnNuevoPuesto) fnNuevoPuesto();" value="+" tabindex="3">
					</td>
				  </tr>
				  <tbody>
				  </tbody>
				</table>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
		</fieldset>
	</td>
  </tr>
  <tr>
  	<td colspan="5">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="5" align="center">
		<cfoutput>
			<input type="hidden" name="SEL" value="">
			<input type="hidden" name="RHEEid" value="#form.RHEEid#">
		</cfoutput>
		<!--- <cfset Botones.TabIndex = 4>
		<input type="submit" name="Regresar" value="<< Anterior" onclick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); if (window.anterior) return anterior();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
		<input type="submit" name="Actualizar" value="&nbsp;&nbsp;&nbsp; Generar &nbsp;&nbsp;&nbsp;" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
		<input type="submit" name="Siguiente" value="Siguiente >>" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); if (window.siguiente) return siguiente();" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>> --->
		<cf_botones values="<< Anterior,Generar,Siguiente >>" names="Anterior,Actualizar,Siguiente" nbspbefore="4" nbspafter="4" tabindex="4">
	</td>
  </tr>
</table>
</form>
<script language="javascript1.2" type="text/javascript">
	//inicializa el form
	qFormAPI.errorColor = "#FFFFCC";
	var objForm = new qForm("form1");
	objForm.fecha.obj.focus();
</script>
