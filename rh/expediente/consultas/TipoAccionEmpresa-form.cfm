
<body onload="ajaxFunction1_ComboConcepto();">
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = Url.DEid>
</cfif>
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select CIid, 		
		{fn concat(rtrim(CIcodigo),{fn concat(' - ',CIdescripcion)})} as Descripcion,
		CIcantmin, CIcantmax, CItipo
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and CItipo != 3
	order by Descripcion
</cfquery>

<!--- Consulta para los tipos de accion --->
<cfquery name="rsTipoAcc" datasource="#session.dsn#">
	select *
	from RHTipoAccion
	where Ecodigo=  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
</cfquery>

<!--- Variables de traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnEmpleado"
	Default="Debe seleccionar un Empleado"
	returnvariable="MSG_DebeSeleccionarUnEmpleado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaIncidenciaYaFueAgregada"
	Default="Esta Incidencia ya fue agregada"
	returnvariable="MSG_EstaIncidenciaYaFueAgregada"/>

<script language="JavaScript" type="text/javascript">
	function ValidaForm(f) {
		
		if (f.DEidentificacion) {
			if (f.DEidentificacion.value == '') {
				alert('<cfoutput>#MSG_DebeSeleccionarUnEmpleado#</cfoutput>');
				return false;
			}
		} else {
			return false;
		}
		
		return true;
	}
</script>
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var tipoConc= new Object();
	var rangoMin = new Object();
	var rangoMax = new Object();
	<cfloop query="rsConceptos">
		tipoConc['<cfoutput>#CIid#</cfoutput>'] = parseInt(<cfoutput>#CItipo#</cfoutput>);
		rangoMin['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmin#</cfoutput>);
		rangoMax['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmax#</cfoutput>);
	</cfloop>

//Función para agregar TRs
	function fnNuevoIn()
	{

	  var LvarTable = document.getElementById("tblin");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= document.form1.CIid.value.toString();//id
	  var p2 		= document.form1.CIcodigo.value;//cod
	  var p3 		= document.form1.CIdescripcion.value;//desc
	 
	  //alert('1');
	  //alert(document.form1.CIcodigo.value);
	  document.form1.CIid.value = "";
	  document.form1.CIcodigo.value = "";
	  document.form1.CIdescripcion.value = "";
	 

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoIN(p1)) {alert('<cfoutput>#MSG_EstaIncidenciaYaFueAgregada#</cfoutput>.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CIidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2 + ' - ' + p3);
	  	
	
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
	
	function existeCodigoIN(v){
		var LvarTable = document.getElementById("tblin");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
						
			if (value == v){
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
</SCRIPT>

<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">

<form name="form1" action="TipoAccionEmpresa-result.cfm" method="post" >
	<input type="hidden" name="Ecodigo" value="#Session.Ecodigo#">

	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
	  	<tr><td colspan="2">&nbsp;</td></tr>
	  	<tr>
			<td width="22%" class="fileLabel" nowrap><strong><cf_translate key="LB_ComportamientoDeLaAccion">Comportamiento de la Acción</cf_translate>:</strong></td>
			<td width="78%">				
				<select name="RHTcomportam"  tabindex="1" onchange="ajaxFunction1_ComboConcepto();">
					<option value="0" selected="true" ><cf_translate key="LB_Todos">Todos</cf_translate></option>
					<option value="1"  ><cf_translate key="LB_Nombramiento">Nombramiento</cf_translate></option>
					<option value="2"  ><cf_translate key="LB_Cese">Cese</cf_translate></option>
					<option value="3"  ><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></option>
					<option value="4"  ><cf_translate key="LB_Permiso">Permiso</cf_translate></option>
					<option value="5"  ><cf_translate key="LB_Incapacidad">Incapacidad</cf_translate></option>
					<option value="6"  ><cf_translate key="LB_Cambio">Cambio</cf_translate></option>
					<option value="7"  ><cf_translate key="LB_Anulacion">Anulaci&oacute;n</cf_translate></option>
					<option value="8"  ><cf_translate key="LB_Aumento">Aumento</cf_translate></option>
					<option value="9"  ><cf_translate key="LB_CambioDeEmpresa">Cambio de Empresa</cf_translate></option>
				</select>			
			</td>
	  	</tr>
		
		<tr height="20px">
		<td><cf_translate key="LB_TiposAcciones" ><strong>Tipos de Acci&oacute;n :</strong>  </cf_translate></td>
		<td>			
			<table id="tblCar" align="left"   border="0" cellspacing="0" cellpadding="0">
				<tr height="20px">
					<td> <span id="contenedor_Concepto1">					
					<select name="Concepto" id="concepto" >
						<cfloop query="rsTipoAcc">
							<option value="#RHTid#">#RHTdesc#</option>	
						</cfloop>
					</select>	
					</span> </td>
					<td  nowrap="nowrap">
						<div style="display:none ;" id="verCargas">
						    <input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">							
						</div>
					</td>
					<td>
						<input type="button" name="agregarCar" onClick="javascript:if (window.fnNuevoCar) fnNuevoCar();" value="+" tabindex="2">
					</td>
				</tr>
			</table>	
		  </td>		
		</tr>
		
		
	  	<tr>
			<td class="fileLabel"><strong><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate>:</strong></td>
			<td>
			  <cfset fechahoy = LSDateFormat(Now(), 'dd/mm/yyyy')>
			  <cf_sifcalendario form="form1" value="#fechahoy#" name="fechaI" tabindex="1"> 
			</td>
      	</tr>
	  	<tr>
			<td class="fileLabel"><strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>:</strong></td>
			<td>
				<cfset fechafin = LSDateFormat(Now(), 'dd/mm/yyyy')>
				<cf_sifcalendario form="form1" value="#fechafin#" name="fechaF" tabindex="1">
			</td>
	 	</tr>
	 	<tr><td colspan="2">&nbsp;</td></tr>
	  	<tr>
			<td colspan="2" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Generar"
					Default="Generar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Generar"/>
	
				<input type="submit" value="<cfoutput>#BTN_Generar#</cfoutput>" tabindex="1">
			</td>
	  	</tr>
	</table>
</form>
</cfoutput>
<!--- Variables de Traduccion --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaInicial"
	Default="Fecha Inicial"
	returnvariable="MSG_FechaInicial"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaFinal"
	Default="Fecha Final"
	returnvariable="MSG_FechaFinal"/>

</body>

<SCRIPT LANGUAGE="JavaScript">
	
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.fechaI.required = true;
	objForm.fechaI.description = "<cfoutput>#MSG_FechaInicial#</cfoutput>";
	
	objForm.fechaF.required = true;
	objForm.fechaF.description = "<cfoutput>#MSG_FechaFinal#</cfoutput>";
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	
	var vnContadorListas = 0;
	var GvarNewTD;
	
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.fechaI.required = false;
		objForm.fechaF.required = false;
		objForm.DEidentificacion.required = false;
		
	}
	
	function limpiar(){
		document.form1.CIid.value   	    	= '';
		document.form1.CIcodigo.value      		= ''; 
		document.form1.CIdescripcion.value	 	= ''; 
		
		document.form1.fechaI.value 	   		= ''; 
		document.form1.fechaF.value 	   		= ''; 
				
	}
	
	//Función para agregar TRs
	function fnNuevoCar()
	{
	  var IndexSelect= document.form1.Concepto.selectedIndex ;
	  var RHTidSelec = document.form1.Concepto.options[IndexSelect].value ;	  
	  var RHTdescSelec = document.form1.Concepto.options[IndexSelect].text;
	  
	<!---  alert(RHTidSelec);
	  alert(RHTdescSelec);--->
	 	  		 	
	  if (RHTidSelec != '' && RHTdescSelec != ''){ 
	 	vnContadorListas = vnContadorListas + 1; 		
	  }
	  
	  var LvarTable = document.getElementById("tblCar");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= RHTidSelec<!---toString()--->;//id
	  var p2 		= RHTdescSelec;//desc
		
	 <!--- document.form1.RHTcodigo.value="";--->
	  RHTidSelec = "";
	  RHTdescSelec = "";

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  
	  // Valida no agregar repetidos
	  if (existeCodigoCar(p1)) {alert('El código seleccionado es repetido.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CaridList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  
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
		  
	function existeCodigoCar(v){
		var LvarTable = document.getElementById("tblCar");
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
	
		function existeCodigoDed(v){
		var LvarTable = document.getElementById("tblDed");
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
	
	//Browser Support Code
	function ajaxFunction1_ComboConcepto(){
		var ajaxRequest1;  // The variable that makes Ajax possible!
		var vID_tipo_comportamiento ='';
		
		vID_tipo_comportamiento = document.form1.RHTcomportam.value;
		
		try{
			// Opera 8.0+, Firefox, Safari
			ajaxRequest1 = new XMLHttpRequest();
		} catch (e){
			// Internet Explorer Browsers
			try{
				ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try{
					ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}
		}
	
		ajaxRequest1.open("GET", '/cfmx/rh/expediente/consultas/ComboAcciones.cfm?RHTcomportam='+vID_tipo_comportamiento, false);
		ajaxRequest1.send(null);
		document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
	}
	
</SCRIPT>