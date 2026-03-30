<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	
	//Función para agregar TRs
	function fnNuevoIn(campoHTML,nombreHTML,tipo){
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
		  document.form1.CPcodigo.value = "";
		  document.form1.CPdescripcion.value = "";
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
	function sbEliminarTR(e){
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
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
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

	function fnTdValue(LprmNode){
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
		var obj= document.getElementsByName("ListaTcodigoCalendario1");
		var check= document.getElementById("ckUtilizarFiltroFechas");

			if(obj.length == 0 && !check.checked){
				alert("<cf_translate key='LB_DebeSeleccionarUnaNomina' xmlFile='/rh/generales.xml'>Debe Escoger al menos una Nómina</cf_translate>");
				return false;
			}
		return true;
	}
</SCRIPT>
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfoutput>
	<body>
		<form name="form1" style="margin:0" action="ReporteCostosSalariales-sql.cfm" method="post" onSubmit="javascript:return validarSubmit();">
			<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
				
                <tr>
					<td align="left" colspan="2" nowrap>
                		<table>
							<tr>
								<td><strong>#LB_Empleado#&nbsp;:&nbsp;</strong></td>
								<td><cf_rhempleado tabindex="1" AgregarEnLista="True"><td>
							</tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td align="left" nowrap colspan="2">
						<table>
							<tr>
								<td><strong><cf_translate key="LB_Nomina">Nómina</cf_translate>&nbsp;:&nbsp;</strong></td>
								<td>
				                    <div style="" id="verNominasProceso"> 
										<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" agregarenlista="true">
									</div>	
								<td>
							</tr>
							<tr>
							 	<td >&nbsp;</td>
							 	<td align="right">
							 		 <table id="tbldynamic"><tr><td></td></tr></table> 
							 	</td>
							</tr> 
						</table> 
					</td>
				</tr>
				<tr>
				  	<td colspan="10">
						<table>
							<td align="left" nowrap>
								<strong><cf_translate key="LB_Utilizar_filtro_de_fechas">Utilizar filtro de fechas</cf_translate>:&nbsp;</strong><input type="checkbox" id="ckUtilizarFiltroFechas" name="ckUtilizarFiltroFechas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</td>			
							<td align="left" nowrap>
								<strong><cf_translate key="LB_Fecha_Desde" xmlFile="/rh/generales.xml">Fecha Desde</cf_translate>&nbsp;:&nbsp;</strong>
							</td> 
							<td align="left" nowrap>
								<cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
							</td> 
							<td colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td align="left" nowrap>
								<strong><cf_translate key="LB_Fecha_Hasta" xmlFile="/rh/generales.xml">Fecha Hasta</cf_translate>&nbsp;:&nbsp;</strong>
							</td>				
							<td align="left" nowrap>
								<cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
								</td>	
						</table>
					</td>
				</tr>
				<tr>
				  	<td align="left" nowrap colspan="2">
						<table>
							<tr>
							  	<td align="left" nowrap>
							  		<strong><cf_translate key="LB_Cuenta" xmlFile="/rh/generales.xml">Cuenta</cf_translate>&nbsp;:&nbsp;</strong>
							  	</td> 
							  	<td colspan="10">
									<cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" CFcuenta="CFcuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="40" tabindex="5">
								</td>
							</tr>
						</table>
					</td>	
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center">
						<label for="moneda"><font size="2"><cf_translate key="LB_Moneda">Moneda</cf_translate></font></label>
						<select name="sMoneda">
		                    <option value="CRC"><cf_translate key="LB_Colon">Colón</cf_translate></option>
		                    <option value="USD"><cf_translate key="LB_Dolar">US Dollar</cf_translate></option>
		                </select >	
					</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>
				<tr> 
					<td align="center" colspan="2">	
						<input type="radio" id="radRep3" value="1" name="radRep" tabindex="1" checked="checked" onClick="javascript: cambioTipoRep(this);">
						<label for="radRep3"><font size="2"><cf_translate key="LB_Incidencias">Incidencias</cf_translate></font></label>
						
						<input type="radio" id="radRep4" value="2" name="radRep" tabindex="1" onClick="javascript: cambioTipoRep(this);">
						<label for="radRep4"><font size="2"><cf_translate key="LB_Cargas_Patronales">Cargas Patronales</cf_translate></font></label>
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
						<div id="verIncid">
							<table id="listaIncidencias">
								<tr>
									<td><strong><cf_translate key="LB_Incidencias">Incidencias</cf_translate></strong></td>
									<td><cf_rhCIncidentes FiltroExtra="CInoanticipo = 0"></td>
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
				<input class="btnNormal" type="submit" name="Consultar" value="<cf_translate key='LB_Consulta'>Consultar</cf_translate> " />  
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
		var connveraICalculo = document.getElementById("verICalculo"); 
		
		switch(obj.value){
			case '1':{				
				connverDeduc.style.display = "none";
				connverCargas.style.display = "none";
				connverIncid.style.display = "";   
			}
			break;
			case '2':{				
				connverDeduc.style.display = "none";
				connverCargas.style.display = "";
				connverIncid.style.display = "none";   
			}
			break;
			case '3':{				
				connverDeduc.style.display = "";
				connverCargas.style.display = "none";
				connverIncid.style.display = "none";  
			}
			break;	
		}
	}

	function limpiarOpciones(){
		var connverDeduc	= document.getElementById("verDeduc");
		var connverCargas	= document.getElementById("verCargas");
		var connverIncid	= document.getElementById("verIncid");	 
		var connveraICalculo = document.getElementById("verICalculo"); 
		
		connverDeduc.style.display = "none";
		connverCargas.style.display = "none";
		connverIncid.style.display = "none"; 
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
		var connverIncid = document.getElementById("verIncid");

		if (document.form1.chkICalculo.checked){
			connverIncid.style.display = "none";
		}else{
			connverIncid.style.display = "";
		}
	}
</script> 
