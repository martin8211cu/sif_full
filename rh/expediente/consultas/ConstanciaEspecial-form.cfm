<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = Url.DEid>
</cfif>
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select CIid, <cf_dbfunction name="concat" args="CIcodigo,' - ',CIdescripcion"> as Descripcion, CIcantmin, CIcantmax, CItipo
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
          <!---
	  and CItipo != 3
          --->
	order by Descripcion
</cfquery>
<script language="JavaScript" type="text/javascript">
	function ValidaForm(f) {
		
		if (f.DEidentificacion) {
			if (f.DEidentificacion.value == '') {
				alert('Debe seleccionar un Empleado');
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
	  if (existeCodigoIN(p1)) {alert('Esta Incidencia ya fue agregada.');return;}
	  
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

<form name="form1" action="ConstanciaEspecial-result.cfm" method="post" onSubmit="javascript: return ValidaForm(this);">
	<input type="hidden" name="Ecodigo" value="#Session.Ecodigo#">
	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
	  <tr>
	  	<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		<td class="fileLabel"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:</strong></td>
		<td>
			<cf_rhempleado size="80"> 
		</td>
	  </tr>
	  <tr>
        <td class="fileLabel"><strong>
        <cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate>:</strong></td>
        <td>
          <cfset fechahoy = LSDateFormat(Now(), 'dd/mm/yyyy')>
          <cf_sifcalendario form="form1" value="#fechahoy#" name="fechaI"> </td>
      </tr>
	  <tr>
		<td class="fileLabel"><strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>:</strong></td>
		<td>
			<cfset fechafin = LSDateFormat(Now(), 'dd/mm/yyyy')>
			<cf_sifcalendario form="form1" value="#fechafin#" name="fechaF">
		</td>
	  </tr>
	  <tr>
	  	<td><strong><cf_translate key="LB_Incidencias">Incidencias</cf_translate>:</strong>&nbsp;</td>
		<td>
			<table id="tblin" width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td></td>
					<td></td>
					<td width="100%">&nbsp;</td>
				  </tr>
				  <tr>
				    <td></td>
					<td>
						<cf_rhCIncidentes tabindex="1" ExcluirTipo=" "><!--- CIid, CIcodigo, CFdescripcion --->
					</td>
					<td>&nbsp;
                        <input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">
                        <input type="button" name="agregarIn" onClick="javascript:if (window.fnNuevoIn) fnNuevoIn();" value="+" tabindex="2">
                    </td>
				  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
	  	<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="2" align="center">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Generar"
			Default="Generar"
			returnvariable="BTN_Generar"/>		
		
			<input type="submit" value="#BTN_Generar#">
		</td>
	  </tr>
	</table>
</form>
</cfoutput>

<SCRIPT LANGUAGE="JavaScript">
	
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicial"
	Default="Fecha Inicial"
	returnvariable="LB_FechaInicial"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinal"
	Default="Fecha Final"
	returnvariable="LB_FechaFinal"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>	
		
	objForm.fechaI.required = true;
	objForm.fechaI.description = "<cfoutput>#LB_FechaInicial#</cfoutput>";
	
	objForm.fechaF.required = true;
	objForm.fechaF.description = "<cfoutput>#LB_FechaFinal#</cfoutput>";
		
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description = "<cfoutput>#LB_Empleado#</cfoutput>";
	
	
	// 
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.fechaI.required = false;
		objForm.fechaF.required = false;
		objForm.DEidentificacion.required = false;
		
	}
	
	function limpiar(){

		document.form1.DEid.value   	       	= '';
		document.form1.DEidentificacion.value  	= '';
		document.form1.NombreEmp.value   	   	= '';
		document.form1.CIid.value   	    	= '';
		document.form1.CIcodigo.value      		= ''; 
		document.form1.CIdescripcion.value	 	= ''; 
		
		document.form1.fechaI.value 	   		= ''; 
		document.form1.fechaF.value 	   		= ''; 
				
	}
	
	
</SCRIPT>