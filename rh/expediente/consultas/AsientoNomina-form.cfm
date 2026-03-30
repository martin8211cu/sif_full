<style type="text/css">
	.tit{
		font-weight:bold;
	}
	
	.visible{
		display:none;
	}
	.novisible{
		display:block;
	}
</style>
<cfquery name="rsAgnos" datasource="#session.dsn#">
	select distinct Periodo from RCuentasTipo where Ecodigo = #session.Ecodigo#
</cfquery>
<form name="form1" method="post" action="AsientoNomina-result.cfm" onsubmit="return fnValidar();">
<table border="0" cellpadding="5" cellspacing="0">
	<tr>
		<td class="tit" align="right">Formato:&nbsp;</td>
		<td><input type="Radio" name="formato" value="1" onclick="fnOcultarCampos(this.value)" checked> Resumido</td>
		<td><input type="Radio" name="formato" value="2" onclick="fnOcultarCampos(this.value)"> Detallado </td>
	</tr>
	<tr>
		<td class="tit" align="right">Filtar por:&nbsp;</td>
		<td><input type="Radio" name="porRango" value="1" onclick="fnPorRango(this.value)" checked> Rango</td>
		<td><input type="Radio" name="porRango" value="2" onclick="fnPorRango(this.value)"> Periodo </td>
	</tr>
	<tr><td colspan="3">
		<table cellpadding="2" cellspacing="2" border="0" align="center" width="100%">
			<tr id="trPeriodo">
				<td class="tit" align="right">A&ntilde;o:&nbsp;</td>
				<td>
					<select name="periodo">
						<cfoutput query="rsAgnos">
							<option value="#rsAgnos.Periodo#" <cfif Year(now()) eq rsAgnos.Periodo>selected</cfif>>#rsAgnos.Periodo#</option>
						</cfoutput>
					</select>
				</td>
				<td class="tit" align="right">Mes:&nbsp;</td>
				<td>
					<cfset meses = "1,Enero|2,Febrero|3,Marzo|4,Abril|5,Mayo|6,Junio|7,Julio|8,Agosto|9,septiembre|10,Octubre|11,Noviembre|12,Diciembre">
					<select name="mes">
						<cfloop list="#meses#" index="mes" delimiters="|">
							<cfoutput>
							<option value="#ListGetAt(mes, 1)#" <cfif Month(now()) eq ListGetAt(mes, 1)>selected</cfif>>#ListGetAt(mes, 2)#</option>
							</cfoutput>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr id="trRango">
				<td class="tit" align="right">Fecha inicial</td>
				<td><cf_sifcalendario form="form1" value="" name="Fdesde" tabindex="1"></td>
				<td class="tit" align="right">Fecha final</td>
				<td><cf_sifcalendario form="form1" value="" name="Fhasta" tabindex="1"></td>
			</tr>
			
		</table>
	</td></tr>
			
	<tr>
		<td class="tit" valign="top" align="right">Calendario de Pago:&nbsp;</td>
		<td colspan="2"><cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" orientacion="2" size="10" descsize="30" conMes="true" conPeriodo="true"></td>
	</tr>

	<tr id="trfiltro">
		<td colspan="3">
		
		<table border="0" width="100%">
		<tr>
		<td class="tit" align="right">Por:&nbsp;</td>
		<td><input type="Radio" name="filtro" value="1" onclick="fnOcultarTRegistros(this.value)" checked=> Centro Funcional</td>
		<td><input type="Radio" name="filtro" value="2" onclick="fnOcultarTRegistros(this.value)"> Empleado</td>
		</tr>
		
		</table> 
		
		</td>
	</tr>
	<tr id="trtregistro">
		<td class="tit" align="right">Tipo Registro:&nbsp;</td>
		<td>
			<select name="stregistro"></select>
		</td>
		<td>
			<input 	type="button" id="AGRE" name="AGRE" value="+"class="btnNormal" onClick="javascript:if (window.fnAgregarTRegistro) fnAgregarTRegistro();">
		</td>
	</tr>
	<tr id="trfregistros">
		<td colspan="3" align="center">
			<table id="tblregistro" width="50%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr><td></td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
			<input type="submit" id="consultar" name="consultar" value="Consultar" class="btnAplicar"/>
			<input type="hidden"   name="clase" id="clase" value="ListaNon">
		</td>
	</tr>
</table>
</form>
<input type="image" id="imgDel"src="../../imagenes/Borrar01_S.gif"  title="Eliminar" style="display:none;" tabindex="1">

<script language="javascript1.2" type="text/javascript">
	
	var arrayTRegistros = new Array(
									new Array ("10,11","Salarios ",new Array ("1","2")), 
									new Array ("20,21","Incidencias ",new Array ("1","2")), 
									new Array ("30,31","Cargas Patronales (Gasto)",new Array ("1","2")), 
									new Array ("40,41","Cargas Patronales (CxC)",new Array ("1")), 
									new Array ("50,51,52","Cargas Empleado ",new Array ("1")), 
									new Array ("55,56,57","Cargas Patronales ",new Array ("1")), 
									new Array ("60","Deducciones ",new Array ("1")), 
									new Array ("70","Renta",new Array ("1")),  
									new Array ("80,85","Salarios Liquidos ",new Array ("1","2"))
								);
	
	function fnOcultarCampos(v){
		document.getElementById("trfiltro").style.display = ( v == 1) ? 'none' : '';
		document.getElementById("trtregistro").style.display = ( v == 1) ? 'none' : '';
		tabla = document.getElementById('tblregistro');
		eliminarTrs();
	
	}
	
	function fnOcultarTRegistros(v){		
	try{
		oSelect = document.form1.stregistro;
		fnBorrarAllTRegistros(oSelect);
		for(i = 0; i < arrayTRegistros.length; i++){
			ArrayOption = arrayTRegistros[i];
			if(fnvalidaPermisos(ArrayOption[2],v)){
				option = document.createElement("option");
				option.text = ArrayOption[1];
				option.value = ArrayOption[0];
				try {
					oSelect.add(option, null); //Standard
				}catch(error) {
					oSelect.add(option); // IE only
				}
			}
		}
		eliminarTrs();
	}catch(error){
		alert("No puede agregar m\u00e1s Tipos de Registros");
	}
	
	}
	
	function eliminarTrs(){
		tabla = document.getElementById('tblregistro');
		try{
			
			while(tabla.rows.length > 1){
				tabla.deleteRow();
			}
		}
		catch(error){
			tabla.innerHTML = "<tr><td></td></tr>";	
		}
	
	}
	
	function fnvalidaPermisos(array, v){
		for(a = 0; a < array.length; a++){
			if(array[a] == v)
				return true;
		}
		return false;
	}
	
	function fnBorrarAllTRegistros(s){
		for(a = s.length; a >= 0 ; a--){
			s.options[a] = null;
		}
	}
	
	function fnAgregarTRegistro(){
	try{
		var LvarTable 	= document.getElementById("tblregistro");
		var LvarTR    	= document.createElement("TR");
		var LvarTBody = LvarTable.tBodies[0];	
		var Lclass 		= document.form1.clase;
		p1 = document.form1.stregistro.options[document.form1.stregistro.selectedIndex];
		if (fnExisteTRegistro(p1.value)) {
			alert('El Tipo de Registro ya fue agregada.');
			return;
		}
		sbAgregaTdInput (LvarTR, Lclass.value, p1.value, "hidden", "tregistro");
		sbAgregaTdText  (LvarTR, Lclass.value, p1.text);
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}
		LvarTR.name = "XXXXX";
		LvarTBody.appendChild(LvarTR);
		if (Lclass.value == "ListaNon") {
			Lclass.value = "ListaPar";
		}
		else {
			Lclass.value = "ListaNon";
		}
		
		document.form1.stregistro.options[document.form1.stregistro.selectedIndex] = null;
	}catch(error){
		alert('No puede agregar m\u00e1s Tipo Registros');
	}			
	}

	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
			LvarInp.id = LprmName;
		}
		
		if (LprmValue != "") {
			LvarInp.value = LprmValue;
		} 

		LvarTD.appendChild(LvarInp);
		if (LprmClass!="") { 
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}
	
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
		var LvarTD    = document.createElement("TD");
		var LvarTxt   = document.createTextNode(LprmValue);
		LvarTD.appendChild(LvarTxt);
		if (LprmClass!="") {
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LvarTD.noWrap = true;
		LprmTR.appendChild(LvarTD);
	}
	
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
	
		var LvarTDimg 	= document.createElement("TD");
		var LvarImg 	= document.getElementById(LprmNombre).cloneNode(true);
		LvarImg.style.display="";
		LvarImg.align=align;
		LvarTDimg.appendChild(LvarImg);
		if (LprmClass != "") {
			LvarTDimg.className = LprmClass;
		}
		GvarNewTD = LvarTDimg;
		LprmTR.appendChild(LvarTDimg);
	}
	
	function sbEliminarTR(e){

		var LvarTR;
		
		if (document.all) {
			LvarTR = e.srcElement;
				
		}
		else {
			LvarTR = e.currentTarget;
		}
		while (LvarTR.name != "XXXXX") {
			LvarTR = LvarTR.parentNode;
		}

		LvarTR.parentNode.removeChild(LvarTR);	/*Borra el hijo*/
		
		var  v=document.form1.filtro[0].checked  ? 1 : 2
		oSelect = document.form1.stregistro;
		fnBorrarAllTRegistros(oSelect);
		for(i = 0; i < arrayTRegistros.length; i++){//recorre todo el array
		
			ArrayOption = arrayTRegistros[i];
			
			if(fnvalidaPermisos(ArrayOption[2],v)){//comparará unicamente el array según la opcion Centro funcional o Empleado

				if(fnExisteTRegistro(ArrayOption[0])==false){//pregunta si ya se esta agregado el registro de lo contrario lo agrega
						option = document.createElement("option");
						option.text = ArrayOption[1];
						option.value = ArrayOption[0];
						try {
							oSelect.add(option, null); //Standard
						}catch(error) {
							oSelect.add(option); // IE only
						}
				}//fin de for agregar registro
				
			}//fin for centro funcional o empleado
		}//fin for array	

	}
	
	function fnExisteTRegistro(v){
		var LvarTable = document.getElementById("tblregistro");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}
	
	function fnTdValue(LprmNode){
		var LvarNode = LprmNode;
		while (LvarNode.hasChildNodes()) {
			LvarNode = LvarNode.firstChild;
			if (document.all == null) {
				if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes()) {
					LvarNode = LvarNode.nextSibling;
				}
			}
		}
		if (LvarNode.value) {
			return LvarNode.value;
		} 
		else {
			return LvarNode.nodeValue;
		}
	}
	
	function fnValidar() {
		var errores = "";
		if(document.form1.formato[1].checked && !document.getElementById("tregistro"))
			errores = errores + '- No se ha agregado el filtro de Tipo de Registro.\n';
		
		if(document.form1.porRango[0].checked ){
			if(document.form1.Fdesde.value == ""){
				errores = errores + '- Debe seleccionar la fecha inicial.\n';
			}
			if(document.form1.Fhasta.value == ""){
				errores = errores + '- Debe seleccionar la fecha final.\n';
			}	
		}
		if(document.form1.porRango[1].checked ){
			if(document.form1.periodo.value == ""){
				errores = errores + '- Debe seleccionar el periodo.\n';
			}
			if(document.form1.mes.value == ""){
				errores = errores + '- Debe seleccionar el mes.\n';
			}	
		}
		
		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}	
		
		return true;
	}	
	
	function fnPorRango(val) {
		if (val == 1){
			document.getElementById('trPeriodo').style.display = 'none';
			document.getElementById('trRango').style.display = '';
		}
		if (val == 2){
			document.getElementById('trRango').style.display = 'none';
			document.getElementById('trPeriodo').style.display = '';
		}		
	}
	
	
	fnOcultarCampos(document.form1.formato[0].checked  ? 1 : 2);
	fnOcultarTRegistros(document.form1.filtro[0].checked  ? 1 : 2);
	fnPorRango(document.form1.porRango[0].checked  ? 1 : 2);
	
	
</script>