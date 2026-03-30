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
	function fnNuevoIn(campoHTML,nombreHTML,tipo)
	{

	  var LvarTable = document.getElementById(campoHTML);
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
  	  var Lclass;
	  var p1;
	  var p2;
	  var p3;
		switch(tipo)
		{
		case 1://tipos de nomina
		   Lclass 	= document.form1.LastOneNomina;
		   p1 		= document.form1.CPid.value;
		   p2 		= document.form1.CPcodigo.value;//cod
		   p3 		= document.form1.CPdescripcion.value;//desc
		  document.form1.Tcodigo.value = "";
		  document.form1.Tdescripcion.value = "";
		  break;
		case 2://tipos de deducciones
		   Lclass 	= document.form1.LastOneDeduc;
		   p1 		= document.form1.TDcodigo.value;
		   p2 		= document.form1.TDcodigo.value;//cod
		   p3 		= document.form1.TDdescripcion.value;//desc
		  document.form1.TDcodigo.value = "";
		  document.form1.TDdescripcion.value = "";
		  break;
		case 3://tipos de cargas
		   Lclass 	= document.form1.LastOneCarga;
		   p1 		= document.form1.ECid.value;
		   p2 		= '';//cod
		   p3 		= document.form1.DCdescripcion.value;//desc
		  document.form1.DCdescripcion.value = "";
		  break;
		case 4://tipos de incidencias
		   Lclass 	= document.form1.LastOneIncidencia;
		   p1 		= document.form1.CIid.value;
		   p2 		= document.form1.CIcodigo.value;//cod
		   p3 		= document.form1.CIdescripcion.value;//desc
		  document.form1.CIcodigo.value = "";
		  document.form1.CIdescripcion.value = "";
		  break;
		}

	  // Valida no agregar vacíos
	  if (p1=="") return;	  

	  
	  // Valida no agregar repetidos
	  if (existeCodigoIN(p1,campoHTML)) {alert('Este dato ya fue agregado');return;}
	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", nombreHTML);

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
	
	function existeCodigoIN(v,campoHTML){
		var LvarTable = document.getElementById(campoHTML);
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

	function validarSubmit(){
<!---		var obj= document.getElementsByName("TcodigoList");
		var check= document.getElementById("ckNominasHistoricas");
			if(obj.length > 0 && check.checked){
				return true
			}
			alert("Debe Escoger una Nomina Historica");
		return false--->
		
		return true;
	}
	
</SCRIPT>


<cfoutput>
<body>
<form  name="form1" style="margin:0" action="ReporteNominas-sql.cfm" method="post" onSubmit="javascript:return validarSubmit();">
	<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
		<tr>
	  		<td align="left" colspan="2"><strong>N&oacute;minas Aplicadas:&nbsp;</strong><input type="checkbox" id="ckNominasHistoricas" name="ckNominasHistoricas" <cfif isdefined("form.Nomina") and trim(form.Nomina) eq 1>checked="checked"</cfif> onClick="javascript: CambiarNominas(this);"></td>
	  	</tr>
		  <tr>
			<td align="left" nowrap colspan="2">
			<table  id="tbldynamic" >
				<tr>
					<td><strong>N&oacute;mina&nbsp;:&nbsp;</strong></td>
					<td><cfif isdefined("form.Nomina") and trim(form.Nomina) eq 1>
						<div style="" id="verNominasProceso"> 
							<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true">
						</div>	
						<cfelse>
						<div style="" id="verNominasProceso"> 
							<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true">
						</div>	
						</cfif>
					<td>
					<td> <input type="button" name="agregarIn" onClick="javascript:if (window.fnNuevoIn) fnNuevoIn('tbldynamic','TcodigoList',1);" value="+" tabindex="2"></td>	
				  </tr>
				  <tr><td colspan="10">&nbsp;&nbsp;</td></tr>
				  <tr>
				  	<td colspan="10">
					<table>
					<td align="left" nowrap ><strong>Utilizar filtro de fechas:&nbsp;</strong><input type="checkbox" id="ckUtilizarFiltroFechas" name="ckUtilizarFiltroFechas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>			
					<td align="left" nowrap><strong>#LB_Fecha_Desde#&nbsp;:&nbsp;</strong></td> 
					<td align="left" nowrap><cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td> 
					<td colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td align="left" nowrap ><strong>#LB_Fecha_Hasta#&nbsp;:&nbsp;</strong></td>				
					<td align="left" nowrap ><cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>	
					</table>
					</td>
				  </tr>
				  <tr><td colspan="10">&nbsp;&nbsp;</td></tr>
			 </table> 
			</td>
		 </tr>
	 <tr> 
		 <td align="center" colspan="2">	
		 
		 	<input type="radio" id="radRep1" name="radRep"value="1" checked="checked" onClick="javascript: limpiarOpciones();"> 
			<label for="radRep1"><font size="2"><cf_translate key="LB_Resumido">Resumido</cf_translate></font></label>
			
			<input type="radio" id="radRep2" name="radRep" value="2" value="Detallado" onClick="javascript:cambioTipoRep(this);">  

			<label for="radRep2"><font size="2"><cf_translate key="LB_Detallado">Detallado</cf_translate></font></label>
			
			<input type="radio" id="radRep3" value="5" name="radRep" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep3"><font size="2"><cf_translate key="LB_Incidencias">Incidencias</cf_translate></font></label>
			
			<input type="radio" id="radRep4" value="4" name="radRep" tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep4"><font size="2"><cf_translate key="LB_Cargas_Patronales">Cargas Patronales</cf_translate></font></label>
			
			<input type="radio" id="radRep5" value="3" name="radRep"  tabindex="1" onClick="javascript: cambioTipoRep(this);">
			<label for="radRep5"><font size="2"><cf_translate key="LB_Deducciones">Deducciones</cf_translate></font></label>

		 </td>
	 </tr>	 
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
			<div style="display:none ;" id="verDetallado">
				<input   value="1" name="radRepDetallado" type="radio" checked >
				<label for="chkAgruparEm" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_AgruparPorEmpleado">Agrupar por Empleado</cf_translate>
				</label>
				<input value="2" name="radRepDetallado" type="radio">
				<label for="chkAgruparCenF" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_AgruparPorCentroFuncional">Agrupar por Centro Funcional</cf_translate>
				</label>
			</div>
		</td>
	</tr>
	 
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
			<div style="display:none ;" id="verAgrupar">
				<input name="chkAgruparRC" id="chkAgruparRC" type="checkbox" checked="checked" >
				<label for="chkAgrupar" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_AgruparPorCentroFuncional">Agrupar por Relaci&oacute;n de C&aacute;lculo</cf_translate>
				</label>
				<input name="chkAgrupar" id="chkAgrupar" type="checkbox">
				<label for="chkAgrupar" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_AgruparPorCentroFuncional">Agrupar por Centro Funcional</cf_translate>
				</label>
			</div>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td nowrap align="center">
			<div style="display:none ;" id="verDeduc">
				<table id="listaDeduccion">
					<tr>
						<td><strong><cf_translate key="LB_Deduccion">Deducci&oacute;n</cf_translate></strong></td>
						<td><cf_rhtipodeduccion form="form1" size= "40" tabindex="1"></td>
						<td><input type="button" name="agregarIn" onClick="javascript:if (window.fnNuevoIn) fnNuevoIn('listaDeduccion','DeduccionesList',2);" value="+" tabindex="2"></td>
					</tr>
				</table>	
			</div>
			<div style="display:none ;" id="verCargas">
				<table id="listaCargas">
					<tr>
						<td><strong><cf_translate key="LB_Cargas">Cargas</cf_translate></strong></td>
						<td>
							<input name="DCdescripcion" disabled type="text" value="" size="40" maxlength="40"  tabindex="1" id="DCdescripcion">
							<img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cargas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
						</td>
						<td><input type="button" name="agregarIn" onClick="javascript:if (window.fnNuevoIn) fnNuevoIn('listaCargas','CargasList',3);" value="+" tabindex="2"></td>
					</tr>
				</table>
			</div>
			<div style="display:none ;" id="verIncid">
				<table id="listaIncidencias">
					<tr>
						<td><strong><cf_translate key="LB_Incidencias">Incidencias</cf_translate></strong></td>
						<td><cf_rhCIncidentes></td>
						<td align="center"><input type="button" name="agregarIn" onClick="javascript:if (window.fnNuevoIn) fnNuevoIn('listaIncidencias','IncidenciasList',4);" value="+" tabindex="2"></td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	</table>
	<input name="ECid" id="ECid" type="hidden" value="" size="40" maxlength="40"  tabindex="1">
	<center>
	<input class="btnNormal" type="submit" name="Consultar" value="Consultar" />  
	<input class="btnNormal"  type="button" name="Limpiar" value="Limpiar" onClick="javascript: document.form1.reset();" />  
	</center>

	<input type="hidden" name="LastOneNomina" id="LastOneNomina" value="ListaNon">
	<input type="hidden" name="LastOneDeduc" id="LastOneNomina" value="ListaNon">
	<input type="hidden" name="LastOneCarga" id="LastOneNomina" value="ListaNon">
	<input type="hidden" name="LastOneIncidencia" id="LastOneNomina" value="ListaNon">
	
	<input type="hidden" name="Nomina" id="Nomina" value="0">
		
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
</form>

</body>
</cfoutput>

<script language="JavaScript" type="text/javascript">

	function cambioTipoRep(obj){
		var connverDeduc	= document.getElementById("verDeduc");
		var connverCargas	= document.getElementById("verCargas");
		var connverIncid	= document.getElementById("verIncid");		
		var connverAgrupa	= document.getElementById("verAgrupar");
		var connveraICalculo = document.getElementById("verICalculo");
		var connveraDetallado = document.getElementById("verDetallado");
		
		switch(obj.value){
			case '1':{				
				connverDeduc.style.display = "none";
				connverCargas.style.display = "none";
				connverIncid.style.display = "none";
				connverAgrupa.style.display ="none";
				connveraDetallado.style.display ="";
				document.form1.action = "/cfmx/rh/nomina/consultas/ReporteNominas-sql.cfm";
			}
			break;
			case '2':{				
				connverDeduc.style.display = "none";
				connverCargas.style.display = "none";
				connverIncid.style.display = "none";
				connverAgrupa.style.display ="none";
				connveraDetallado.style.display ="";
				document.form1.action = "/cfmx/rh/nomina/consultas/ReporteNominas-sql.cfm";
			}
			break;
			case '3':{				
				connverDeduc.style.display = "";
				connverCargas.style.display = "none";
				connverIncid.style.display = "none";
				connverAgrupa.style.display ="";
				connveraDetallado.style.display ="none";
				document.form1.action = "/cfmx/rh/nomina/consultas/ReporteNominas-DatosAgrupadosSQL.cfm";
			}
			break;
			case '4':{
				connverDeduc.style.display = "none";
				connverCargas.style.display = "";
				connverIncid.style.display = "none";
				connverAgrupa.style.display ="";
				connveraDetallado.style.display ="none";
				document.form1.action = "/cfmx/rh/nomina/consultas/ReporteNominas-DatosAgrupadosSQL.cfm";
			}
			break;			
			case '5':{
				connverDeduc.style.display = "none";
				connverCargas.style.display = "none";
				connverIncid.style.display = "";
				connverAgrupa.style.display ="";
				connveraDetallado.style.display ="none";
				document.form1.action = "/cfmx/rh/nomina/consultas/ReporteNominas-DatosAgrupadosSQL.cfm";
			}
			break;
		}
		
	}	
	function limpiarOpciones(){
				var connverDeduc	= document.getElementById("verDeduc");
				var connverCargas	= document.getElementById("verCargas");
				var connverIncid	= document.getElementById("verIncid");		
				var connverAgrupa	= document.getElementById("verAgrupar");
				var connveraAgrupado= document.getElementById("verAgrupa");
				var connveraICalculo = document.getElementById("verICalculo");
				var connveraDetallado = document.getElementById("verDetallado");
				
				connveraDetallado.style.display ="none";
				connverDeduc.style.display = "none";
				connverCargas.style.display = "none";
				connverIncid.style.display = "none";
				connverAgrupa.style.display ="none";
				document.form1.action = "ReporteNominas-sql.cfm";
	}
	
	function CambiarNominas(obj){
		var nomina= document.getElementById("Nomina");
			if(obj.checked){
				nomina.value="1";
			}else{
				nomina.value="0";
			}
			document.form1.action = "";
			document.form1.submit();
	}
	

	function validar(){	return true; }
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("/cfmx/rh/nomina/consultas/ConlisCargasEmpleados.cfm" ,250,200,650,350);
	}
	function limpiar() {
		document.form1.ECid.value = "";
		document.form1.DCdescripcion.value = "";
		document.form1.TDid.value = "";
		document.form1.TDcodigo.value = "";
		document.form1.TDdescripcion.value = "";
	}
	function habilitaInc(){
		var connverIncid	 = document.getElementById("verIncid");

		if (document.form1.chkICalculo.checked){
			connverIncid.style.display = "none";
		}else{
			connverIncid.style.display = "";
		}
		
	}

</script> 
