<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Desde" Default="Fecha Desde" returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_CFuncional" Default="Centro Funcional" returnvariable="CMB_CFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Puesto" Default="Puesto" returnvariable="CMB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="C&eacute;dula" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Salario" Default="Salario" returnvariable="CMB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Flashpaper" Default="Flashpaper" returnvariable="CMB_Flashpaper"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_PDF" Default="PDF" returnvariable="CMB_PDF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_HTML" Default="HTML" returnvariable="CMB_HTML"/>


<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	
//Función para agregar TRs
	function fnNuevoIn()
	{

	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
  
	  var Lclass 	= document.form1.LastOneCF;
	  var p1 		= document.form1.Tcodigo.value;<!---document.form1.CIid.value.toString();//id--->
	  var p2 		= document.form1.Tcodigo.value;//cod
	  var p3 		= document.form1.Tdescripcion.value;//desc
	 
	  //alert('1');
	  //alert(document.form1.CIcodigo.value);
	  document.form1.Tcodigo.value = "";
	  document.form1.Tdescripcion.value = "";
	 


	  // Valida no agregar vacíos
	  if (p1=="") return;	  

	  
	  // Valida no agregar repetidos
	  if (existeCodigoIN(p1)) {alert('Esta Nomina Ya fue agregada.');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "TcodigoList");

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
		var LvarTable = document.getElementById("tbldynamic");
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
<body>
<form  name="form1" style="margin:0" action="prontuario-sql.cfm" method="get" onSubmit="javascript: return ValidaForm(this);">
	<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
	  <tr id="fDesde">
		<td align="right" nowrap width="50%"><strong>#LB_Fecha_Desde#&nbsp;:&nbsp;</strong>&nbsp; </td>				
		<td><cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>					
	  </tr>	
	  
	  <tr>	     
		<td width="1%"  align="right" nowrap>
		<cf_translate key="LB_Fecha_de_Corte"><strong>Fecha Hasta&nbsp;:&nbsp;&nbsp;</strong></cf_translate></td>		
		<!---<input align="right"  type="text" value="<strong>#LB_Fecha_de_Corte#</strong>&nbsp;:&nbsp;&nbsp;" name="EtiqFechaDesde"  id="EtiqFechaDesde"   >--->		
		<td><cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
	  </tr>
	  <tr>
	  	<td align="right" nowrap colspan="2">
	  	<table  id="tbldynamic" >
			  	<td><strong>N&oacute;mina&nbsp;:&nbsp;</strong></td>
				<td><cf_rhtiponomina tabindex="1"><td>
				<td> <input type="button" name="agregarIn" onClick="javascript:if (window.fnNuevoIn) fnNuevoIn();" value="+" tabindex="2"></td>
			  </tr>
		 </table> 
	  	</td>
	 </tr> 
	  <tr>
	  	<td align="right"><strong>Mostrar Resumido&nbsp;:&nbsp;</strong></td>
	  	<td align="left"><input type="checkbox" name="ckResumido"></td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<select name="OrderBy">
				<option value="1">#CMB_Ceedula#</option>
				<option value="2">#CMB_Nombre#</option>
				<option value="3">#CMB_CFuncional#</option>
				<option value="4">#CMB_Puesto#</option>
			</select>
		</td>
	  </tr>
	</table>
	<center>
	<input class="btnNormal" type="submit" name="Consultar" value="Consultar" onClick="javascript: return SubmitEsteForm();" />  
	<input class="btnNormal"  type="button" name="Limpiar" value="Limpiar" onClick="javascript: document.form1.reset();" />  
	</center>

	<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">
	
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
</form>

</body>
</cfoutput>

<!---<SCRIPT LANGUAGE="JavaScript">
	
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
	
</SCRIPT>--->