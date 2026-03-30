
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

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript1.2" type="text/javascript">
 	<!--//
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	
	var vnContadorListas = 0;

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
		if (vnContadorListas <= 0){
			document.form1.SEL.value = "3";
			document.form1.action = "registro_evaluacion.cfm";
			return true;
		}
		else{
			if (confirm("<cfoutput>Esta Seguro Que Desea Continuar Y Perder La Configuracion Actual</cfoutput>")){				
				document.form1.SEL.value = "3";
				document.form1.action = "registro_evaluacion.cfm";
				return true;
			}
			else {return false;}
		}
	}
	
	//**********************************Tabla Dinámica**********************************************
	
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoCF(){
		if (document.form1.CFcodigo.value != '' && document.form1.CFid.value != ''){ 
	  		vnContadorListas = vnContadorListas + 1;
	  	}
	  
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
	  	if (existeCodigoCF(p1)){
	  		alert('<cfoutput>Este Centro Funcional Ya Fue Agregado</cfoutput>.');
	  		return;
	  	}
	   
	  	// Agrega Columna 0
	  	sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + ((p4) ? "1" : "0"), "hidden", "CFidList");
 		
	  	// Agrega Columna 1
	  	sbAgregaTdText (LvarTR, Lclass.value, p2 + ' - ' + p3);
	   	
	  	// Agrega Columna 2
	  	sbAgregaTdImage (LvarTR, Lclass.value, ((p4) ? "imgCheck" : "imgUnCheck"), "left");
	 
	  	// Agrega Evento de borrado en Columna 3
	  	sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "center");
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
	
	function fnNuevoOD(){
		if (document.form1.Ocodigo.value != '' && document.form1.Dcodigo.value != ''){ 
      		vnContadorListas = vnContadorListas + 1;
	 	}	
	 		
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
	  	if (existeCodigoOD(p1,p3)){
	  		alert('<cfoutput>Esta Oficina Departamento Ya Fue Agregada</cfoutput>.');
	  		return;
	  	}
	  
	  	// Agrega Columna 0
	  	sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + p3, "hidden", "ODidList");

	  	// Agrega Columna 1
	  	sbAgregaTdText (LvarTR, Lclass.value, p2);
	  	
	  	// Agrega Columna 2
	  	sbAgregaTdText (LvarTR, Lclass.value, p4);

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
	
	function fnNuevoEmpleado()
	{		
	  	if (document.form1.DEid.value != '' && document.form1.DEidentificacion.value != ''){
	  		vnContadorListas = vnContadorListas + 1;
	  	}
	  
	  	var LvarTable = document.getElementById("tblempleado");
	  	var LvarTbody = LvarTable.tBodies[0];
	  	var LvarTR    = document.createElement("TR");
	  
	  	var Lclass 	= document.form1.LastOneEmpleado;
	  	var p1 		= document.form1.DEid.value.toString();//cod
	  	var p2 		= document.form1.NombreEmp.value;//desc

	  	document.form1.DEid.value="";
	  	document.form1.NombreEmp.value="";

	  	// Valida no agregar vacíos
	  	if (p1=="") return;
	  
	  	// Valida no agregar repetidos
	  	if (existeEmpleado(p1)){
	  		alert('<cfoutput>Este Empleado Ya Fue Agregado</cfoutput>.');
	  		return;
	  	}
  	  
	  	// Agrega Columna 0
	  	sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "EmpleadoidList");

	  	// Agrega Columna 1
	  	sbAgregaTdText (LvarTR, Lclass.value, p2);
	  	
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
	
	function existeEmpleado(v){
		var LvarTable = document.getElementById("tblempleado");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}
	
	//Función para eliminar TRs
	function sbEliminarTR(e){
		vnContadorListas = vnContadorListas - 1;
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
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
	  	// Copia una imagen existente
	  	var LvarTDimg    = document.createElement("TD");
	  	var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  	LvarImg.style.display="";
	  	LvarImg.align=align;
	  	LvarTDimg.appendChild(LvarImg);
	  	if (LprmClass != "") 
	  		LvarTDimg.className = LprmClass;
	
	  	GvarNewTD = LvarTDimg;
	  	LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
		var LvarTD    = document.createElement("TD");
	  	var LvarTxt   = document.createTextNode(LprmValue);
	  	LvarTD.appendChild(LvarTxt);
	  	if (LprmClass!="") 
	  		LvarTD.className = LprmClass;

	  	GvarNewTD = LvarTD;
	  	LvarTD.noWrap = true;
	  	LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
	  	var LvarTD    = document.createElement("TD");
	  	var LvarInp   = document.createElement("INPUT");
	  	LvarInp.type = LprmType;
	  	if (LprmName!="") 
	  		LvarInp.name = LprmName;
	  	if (LprmValue!="") 
	  		LvarInp.value = LprmValue;
	  	LvarTD.appendChild(LvarInp);
	  	if (LprmClass!="") 
	  		LvarTD.className = LprmClass;
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
		var LvarTable = document.getElementById("tblpuesto");
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

	function fnTdValue(LprmNode){
		var LvarNode = LprmNode;
	
	  	while (LvarNode.hasChildNodes()){
			LvarNode = LvarNode.firstChild;
		
		if (document.all == null){
		  	if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes())
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

<!--- Imagenes --->
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgCheck" src="/cfmx/rh/imagenes/checked.gif" title="" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">

<cfoutput>
<form name="form1" method="post" action="registroMasivoAjuste-sql.cfm" onsubmit="javascript: return validar();">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0">
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4" align="center">
				<table width="80%" border="0" cellspacing="0" cellpadding="2" >
					<tr>
						<td colspan="4" style=" background-color:##CCCCCC;font-family:Arial, Helvetica, sans-serif; font-size:16px; font-weight:bold; border:1px solid ##CCCCCC;"><cf_translate key="LB_InfoAjuste">Proceso de ajuste masivo de vacaciones</cf_translate></td>
					</tr>
					<tr>
						<td nowrap="nowrap" width="1%" ><strong>#LB_Descripcion#:</strong>&nbsp;</td>
						<td nowrap="nowrap">
							<input name="Descripcion" type="text" size="60" maxlength="60" value="">
						</td>
					</tr>
					<tr><td colspan="4"><br /><strong>#LB_Fechas#:</strong></td></tr>
					<tr><td colspan="4">
						<table width="100%" cellpadding="2">
							<tr>
								<td nowrap="nowrap" width="1%" ><strong>#LB_FechaDesde#:</strong>&nbsp;</td>
								<td width="1%">
									<cf_sifcalendario name="fechaDesde" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
								</td>
								<td nowrap="nowrap" width="1%" ><strong>#LB_FechaHasta#:</strong>&nbsp;</td>
								<td>
									<cf_sifcalendario name="fechaHasta" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
								</td>
							</tr>
						</table>
					</td></tr>
				</table>
			</td>
		</tr>	

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="3">
				<table width="35%"  border="0" cellspacing="0" cellpadding="5">
					<tr><td colspan="4" nowrap="nowrap"><strong>#LB_Agregar_Empleados#:</strong></td></tr>
					<tr>
					<td valign="middle" width="1%"><input type="radio" name="opt" value="0" tabindex="1" onClick="javascript: mostrar_div('CF');"></td>
					<td valign="middle" nowrap="nowrap" width="1%"><label><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></label></td>
					<td valign="middle" width="1%"><input type="radio" name="opt" value="1" tabindex="1" onClick="javascript: mostrar_div('OD');"></td>
					<td valign="middle" nowrap="nowrap"><label><cf_translate key="LB_OficinaDepartamento">Oficina/Departamento</cf_translate></label></td>			
					</tr>
				</table>	
			</td>
		</tr>
		
		<tr>
			<td colspan="4" align="center">
				<div id="div_CF" style="display:;" >
					<table width="75%" align="center" border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
						
						
						<tr>
							<td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_IncluirempleadosPorCentroFuncional">Incluir empleados por Centro Funcional</cf_translate></td>
						</tr>
						<tr>
							<td>
								<table id="tblcf" width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td></td>
										<td><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td></td>
										<td><cf_rhcfuncional size="20" tabindex="2"><!--- CFid, CFcodigo, CFdescripcion ---></td>
										
										<td nowrap>
											<input type="checkbox" name="CFdependencias" tabindex="2"><strong><cf_translate key="LB_IncluirDependencias">Incluir Dependencias</cf_translate></strong>
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
						
						<tr><td>&nbsp;</td></tr>	  
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</div>
				
				<div id="div_OD" style="display:none;">
					<table width="75%" align="center"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">			
						<tr><td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_IncluirEmpleadosPorOficinaDepartamento">Incluir empleados por Oficina/Departamento</cf_translate></td></tr>
						<tr>
							<td>
								<table id="tblod" width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td></td>
										<td><strong><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate>:</strong>&nbsp;</td>
										<td><strong><cf_translate key="LB_Departamento"  XmlFile="/rh/generales.xml">Departamento</cf_translate>:</strong>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<select name="Ocodigo" tabindex="2" >
												<cfloop query="rsOficinas">
													<option value="#rsOficinas.Ocodigo#|#rsOficinas.Odescripcion#">#rsOficinas.Odescripcion#</option>				
												</cfloop>
											</select>
										</td>
										<td>
											<select name="Dcodigo" tabindex="2">
												<cfloop query="rsDepartamentos">
													<option value="#rsDepartamentos.Dcodigo#|#rsDepartamentos.Ddescripcion#">#rsDepartamentos.Ddescripcion#</option>
												</cfloop>		
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
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>				
				</div>
				<script language="JavaScript" type="text/javascript">
					mostrar_div('CF');
				</script>
							
			</td>
		</tr>
		
		
		<tr>
			<td colspan="4" align="center">
				<br />
				<table id="tblempleado" width="75%" align="center"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr><td class="subtitulo_seccion_small" colspan="3">&nbsp;<cf_translate key="LB_Incluir_empleados_de_manera_individual" >Incluir empleados de manera individual</cf_translate></td></tr>
					<tr>
						<td></td>
						<td><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>:</strong>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<cf_rhempleado size="40">				
						</td>
						<td align="right"><!----align="right"---->
							<input type="hidden" name="LastOneEmpleado" id="LastOneEmpleado" value="ListaNon" tabindex="3">
							&nbsp;<input type="button" name="agregarEmpleado" onClick="javascript:if (window.fnNuevoEmpleado) fnNuevoEmpleado();" value="+" tabindex="4">
						</td>
					</tr>
					<tbody>
					</tbody>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>		
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4" align="center">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
				  <tr>
					<td align="center">
						<input type="hidden" name="botonSel" value="">
						<input type="submit" name="btnGenerar" class="btnGuardar" value="Generar" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcGenerar) return funcGenerar();" tabindex="0">
						<input type="submit" name="btnImportar" class="btnNormal" value="Importar" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcImportar) return funcImportar();" tabindex="0">
					</td>
				  </tr>
				</table>				
			</td>
		</tr>
	</table>
</form>
</cfoutput>		

<cf_qforms>
<script>
	objForm.Descripcion.required = true;
	objForm.Descripcion.description = '<cfoutput>#LB_Descripcion_JS#</cfoutput>';
	objForm.fechaDesde.required = true;
	objForm.fechaDesde.description = '<cfoutput>#LB_fechaDesde#</cfoutput>';
	
	function validar(){
		if ( document.form1.fechaHasta.value == '' ){
			document.form1.fechaHasta.value = document.form1.fechaDesde.value
		}
		return true;
	}
	
	function funcImportar(){
		document.form1.action = 'registroMasivoAjuste-importar.cfm';
		objForm.Descripcion.required = false;
		objForm.fechaDesde.required = false;			
	}
	
</script>