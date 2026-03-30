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

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual"
	Default="Esta seguro que desea continuar y perder la configuración actual?"
	returnvariable="MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteCentroFuncionalYaFueAgregado"
	Default="Este Centro Funcional ya fue agregado"
	returnvariable="MSG_EsteCentroFuncionalYaFueAgregado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaOficinaDepartamentoYaFueAgregada"
	Default="Esta Oficina / Departamento. ya fue agregada"
	returnvariable="MSG_EstaOficinaDepartamentoYaFueAgregada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstePuestoYaFueAgregado"
	Default="Este Puesto ya fue agregado"
	returnvariable="MSG_EstePuestoYaFueAgregado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteEmpleadoYaFueAgregado"
	Default="Este Empleado ya fue agregado"
	returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>

<!--- JavaScript --->
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
			if (confirm("<cfoutput>#MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual#</cfoutput>")){				
				document.form1.SEL.value = "3";
				document.form1.action = "registro_evaluacion.cfm";
				return true;
			}
			else {return false;}
		}
	}
	
	function funcfecha(m){
		var objD1 = document.getElementById('date1');
		var objD2 = document.getElementById('date2');
		var objD3 = document.getElementById('date3');
		if (m==0){
			objD1.style.display = '';	
			objD2.style.display='none';	
			objD3.style.display='none';	
		}	
		if(m==1){
			objD1.style.display = 'none';	
			objD2.style.display='';	
			objD3.style.display='none';	
		}
		if(m==2){
			objD1.style.display = 'none';	
			objD2.style.display='none';	
			objD3.style.display='';	
		}
	}
	
	
	//**********************************Tabla Dinámica**********************************************
	
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoCF()
	{
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
	  if (existeCodigoCF(p1)) {alert('<cfoutput>#MSG_EsteCentroFuncionalYaFueAgregado#</cfoutput>.');return;}
	  
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
	  if (existeCodigoOD(p1,p3)) {alert('<cfoutput>#MSG_EstaOficinaDepartamentoYaFueAgregada#</cfoutput>.');return;}
	  
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
	  if (document.form1.RHPcodigo.value != '' && document.form1.RHPdescpuesto.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblpuesto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOnePuesto;
	  var p1 		= document.form1.RHPcodigo.value.toString();//cod
	  var p2 		= document.form1.RHPdescpuesto.value;//desc

	  document.form1.RHPcodigo.value="";
	  document.form1.RHPcodigoext.value="";
	  document.form1.RHPdescpuesto.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoPuesto(p1)) {alert('<cfoutput>#MSG_EstePuestoYaFueAgregado#</cfoutput>.');return;}
  	  
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
/*--------------------------------------------Tabla dinamica para los Empleados-----------------------------------------------------------------------*/
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
	  if (existeEmpleado(p1)) {alert('<cfoutput>#MSG_EsteEmpleadoYaFueAgregado#</cfoutput>.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "EmpleadoidList");

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
	
	function existeEmpleado(v){
		var LvarTable = document.getElementById("tblempleado");
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
	
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
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
	/*-----------------------------------------------------Tabla dinamica para los cursos---------------------------------------------------*/
	function fnNuevoCurso() 
	{	
	  if (document.form1.RHCcodigo.value != '' && document.form1.RHCnombre.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblcurso");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	 
	  var Lclass 	= document.form1.LastOneCurso;
	  var p1 		= document.form1.RHCid.value.toString();//cod
	  var p2 		= document.form1.RHCnombre.value;//desc
	  var p3        = document.form1.RHIAnombre.value;
	  
	  document.form1.RHCid.value="";
	  document.form1.RHCcodigo.value="";
	  document.form1.RHCnombre.value="";
	  document.form1.RHIAnombre.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCurso(p1)) {alert('Ese curso ya fue seleccionado.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CursoidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2+ ' - ' + p3);
	  	
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
	//-->
	function existeCurso(v){

		var LvarTable = document.getElementById("tblcurso");
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
	
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgCheck" src="/cfmx/rh/imagenes/checked.gif" title="" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">
<form action="registro_criterios_empleados_sql.cfm" method="post" name="form1">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0">
		<tr>
			<td rowspan="8">&nbsp;</td>
			<td colspan="5">
				<p>
				<cf_translate key="LB_SeleccioneLosCriteriosParaAgregarEmpleadosALaRelacion">Seleccione los criterios para agregar empleados a la Relaci&oacute;n</cf_translate>:
				</p>
			</td>
			<td rowspan="8">&nbsp;</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td colspan="5">
				<table width="100%"  border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td valign="middle" nowrap="nowrap" width="1%"><input type="radio" checked="checked" name="radfecha" value="0" onclick="javascript: funcfecha(this.value)" /><strong><cf_translate key="LB_EmpleadosIncluidosAntesDe">Empleados incluidos antes de</cf_translate>:</strong></td>
						<td valign="middle" style="display:''" id="date1" ><cf_sifcalendario name="fechaini" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
					<tr>					
						<td valign="middle" nowrap="nowrap" width="1%"><input type="radio" name="radfecha" value="1" onclick="javascript: funcfecha(this.value)" /><strong><cf_translate key="LB_Despuesde">Después de</cf_translate>:</strong></td>
						<td valign="middle" style="display:none" id="date2" ><cf_sifcalendario name="fechafin" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="2"></td>
					</tr>
					<tr><!--- fcastro 12/11/12 se agrega el filtro de situacion----->				
						<td valign="middle" nowrap="nowrap" width="1%"><input type="radio" name="radfecha" onclick="javascript: funcfecha(this.value)" value="2"><strong><cf_translate key="LB_Situacion">Situaci&oacute;n</cf_translate>:</strong></td>
					</tr>
					
					<tr><!--- fcastro 12/11/12 se agrega el filtro de situacion----->				
						<td valign="middle" nowrap="nowrap" id="date3" colspan="2" style="border:groove;display:none">
							<table  width="100%">
								<tr>
									<td rowspan="2" align="center" valign="middle">
										<select name="ambitoTiempoSituacion" tabindex="3" >
												<option value="0"><cf_translate key="LB_Antiguedad">Antig&uuml;edad</cf_translate></option>
												<option value="1"><cf_translate key="LB_Cese">Cese</cf_translate></option>
												<option value="2"><cf_translate key="LB_CambioPuesto">Cambio de Puesto (Asc/Desc)</cf_translate></option>
										</select>
									</td>
									<td nowrap="nowrap">
										<cf_translate key="LB_fechaReferencia">Fecha de Referencia</cf_translate>:
									</td>
									<td colspan="4">
										<cf_sifcalendario name="AmbitoTiempoFechaReferencia" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="3">
									</td>	
								</tr>	
								<tr>
									<td>
										<cf_translate key="LB_AmbitoTiempo">&Aacute;mbito de Tiempo</cf_translate>:
									</td>
									<td>
										<cf_inputNumber name="ambitoTiempoDesde" size="3" decimales="0" enteros="3" value="0">
									</td>	
									<td>&nbsp;&nbsp;a &nbsp;&nbsp;</td>
									<td>
										<cf_inputNumber name="ambitoTiempoHasta" size="3" decimales="0" enteros="3" value="0">
									</td>
									<td>
										<select name="ambitoTiempoTipoTiempo" tabindex="3" >
												<option value="0"><cf_translate key="LB_Dias">D&iacute;as</cf_translate></option>
												<option value="1"><cf_translate key="LB_Meses">Meses</cf_translate></option>
												<option value="2"><cf_translate key="LB_años">A&ntilde;os</cf_translate></option>
										</select>
									</td>	
								</tr>
							</table>	
						</td>
					</tr><!--- FIN fcastro 12/11/12 se agrega el filtro de situacion----->	
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="2">
							<table width="50%"  border="0" cellspacing="0" cellpadding="1">
								<td valign="middle" width="1%"><input type="radio" name="opt" value="0" tabindex="1" onClick="javascript: mostrar_div('CF');"></td>
								<td valign="middle" nowrap="nowrap"><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></td>
								<td valign="middle" width="1%"><input type="radio" name="opt" value="1" tabindex="1" onClick="javascript: mostrar_div('OD');"></td>
								<td valign="middle" nowrap="nowrap"><cf_translate key="LB_OficinaDepartamento">Oficina/Departamento</cf_translate></td>			
							</table>	
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="top" width="88%" colspan="3" >
				<div id="div_CF" style="display:;" >
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
						<tr>
							<td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></td>
						</tr>
						<tr>
							<td>
								<table id="tblcf" width="100%"    border="0" cellspacing="0" cellpadding="0">
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
											<input type="checkbox" name="CFdependencias" tabindex="2"><strong><cf_translate key="LB_IncluirDependencias">Incluir Dependencias</cf_translate></strong></td>
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
						<cfsavecontent variable="EVAL_RIGHT">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
								<tr>
									<td><img src="/cfmx/rh/imagenes/Excl32.gif"> </td>
							  	</tr>
								<tr>
									<td colspan="2">
										<b>Antig&uuml;edad</b>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td colspan="2">
										Seg&uacute;n la Fecha de Referencia y el &aacute;mbito de tiempo, se busca a los empleados cuya antig&uuml;edad cumpla con el criterio
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<b>Cese</b>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										Se busca a los empleado inactivos, seg&uacute;n la Fecha de Referencia y que fueron Cesados en el &aacute;mbito de tiempo indicado
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<b>Cambio de Puesto</b>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										Seg&uacute;n la Fecha de Referencia, se analiza en el &aacute;mbito de tiempo inferior el Puesto del Colaborador, si difiere del Puesto que tiene en el &aacute;bito de tiempo superior se considera para la evaluaci&oacute;n
									</td>
								</tr>
							</table>
						</cfsavecontent>
						
						<tr><td>&nbsp;</td></tr>	  
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</div>
				
				<div id="div_OD" style="display:none;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">			
						<tr><td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_OficinaDepartamento">Oficina/Departamento</cf_translate></td></tr>
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
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>				
				</div>
				<script language="JavaScript" type="text/javascript">
					mostrar_div('CF');
				</script>
			</td>
			<td width="2%">&nbsp;</td>
			<br />
		</tr>
		
		<tr>
			<td>
				<br />
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr><td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_Puestos" XmlFile="/rh/generales.xml">Puestos</cf_translate></td></tr>
					<tr>
						<td>
							<table id="tblpuesto" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td></td>
									<td><strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:</strong>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<cf_rhpuesto size="20" tabindex="3">
									</td>
									<td align="right">
										<input type="hidden" name="LastOnePuesto" id="LastOnePuesto" value="ListaNon" tabindex="3">
										&nbsp;<input type="button" name="agregarPuesto" onClick="javascript:if (window.fnNuevoPuesto) fnNuevoPuesto();" value="+" tabindex="3">
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
			</td>
		</tr>
		<tr>
			<td>
				<br />
				<table id="tblempleado" width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr><td class="subtitulo_seccion_small" colspan="3">&nbsp;<cf_translate key="LB_Empleados" XmlFile="/rh/generales.xml">Empleados</cf_translate></td></tr>
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
							<input type="hidden" name="LastOneEmpleado" id="LastOneEmpleado" value="ListaNon" tabindex="4">
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
			<td>
				<br />
				<table id="tblcurso" width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr><td class="subtitulo_seccion_small" colspan="3">&nbsp;<cf_translate key="LB_Cursos" XmlFile="/rh/generales.xml">Cursos</cf_translate></td></tr>
					<tr>
						<td></td>
						<td><strong><cf_translate key="LB_EmpleadosporCursos" XmlFile="/rh/generales.xml">Empleados por Cursos</cf_translate>:</strong>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>
					
							<cf_conlis title="LISTA DE CURSOS"
							campos = "RHCid,RHCcodigo,RHCnombre,,RHCfdesde,RHCfhasta,RHIAnombre" 
							desplegables = "N,S,S,,N,N,N" 
							modificables = "N,S,N,N,N,N" 
							size = "0,15,34,0,0,0"
							asignar="RHCid,RHCcodigo,RHCnombre,RHCfdesde,RHCfhasta,RHIAnombre"
							asignarformatos="S,S"
							tabla="RHCursos a inner join RHInstitucionesA b on a.RHIAid=b.RHIAid"
							columnas="RHCid,RHCcodigo,RHCnombre,RHCfdesde,RHCfhasta,RHIAnombre"
							filtro="a.Ecodigo = #Session.Ecodigo#"
							desplegar="RHCcodigo,RHCnombre,RHCfdesde,RHCfhasta,RHIAnombre"
							etiquetas="Codigo,Nombre,FechaDesde, FechaHasta,Institución"
							formatos="S,S,D,D,S"
							align="left,left,left,left,left"
							showEmptyListMsg="true"
							EmptyListMsg=""
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							fparams="RHCid"/>        			
						</td>
						<td align="right"><!----align="right"---->
							<input type="hidden" name="LastOneCurso" id="LastOneCurso" value="ListaNon" tabindex="5">
							&nbsp;<input type="button" name="agregarCurso" onClick="javascript:if (window.fnNuevoCurso) fnNuevoCurso();" value="+" tabindex="5">
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
		<td colspan="5">&nbsp;</td>
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
				<cf_botones values="Anterior,Generar,Siguiente" names="Anterior,Actualizar,Siguiente" functions="return true;,return validarFecha();,return true;" nbspbefore="4" nbspafter="4" tabindex="4">
			</td>
		</tr>
	</table>
</form>
<script language="javascript1.2" type="text/javascript">
	//inicializa el form
	qFormAPI.errorColor = "#FFFFCC";
	var objForm = new qForm("form1");
	//objForm.fecha.obj.focus();
	function validarFecha(){
	var errores='';
	if(document.form1.radfecha[2].checked){
		if (document.form1.AmbitoTiempoFechaReferencia.value == ''){
			errores=errores+'- Debe seleccionar una Fecha de Referencia';
		}
		if (document.form1.ambitoTiempoDesde.value == '' || document.form1.ambitoTiempoHasta.value == ''){
			errores=errores+'\n- Debe seleccionar el \xC1mbito de tiempo';
		}
		if(errores != ''){
			alert(errores);
			return false;
		}
	}
	return true;
	}
</script>