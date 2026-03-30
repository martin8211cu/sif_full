<cfset paramsuri = ArrayNew (1)>
<cfif isdefined("url.CuentaidList") and len(trim(url.CuentaidList)) gt 0 >
	<cfset ArrayAppend(paramsuri, 'CuentaidList='         & URLEncodedFormat(url.CuentaidList))>
</cfif>

<cfoutput>
<form method="post" action="ConsCuentasPresupuestales-sql.cfm" name="form1"  onSubmit="return validar();"  style="MARGIN:0;">
	<table width="100%" border="0" cellspacing="2" cellpadding="2" >
		<tr>
			<td align="center" colspan="2" nowrap bgcolor="##CCCCCC"><strong>Tipo de Reporte</strong></td>
		</tr>	

		<tr>
			<td><strong>Tipo de Reporte :</strong></td>
			<td>
				<select name="ID_REPORTE" tabindex="1" onchange="javascript:  fnReset()">
					<option value="2">Un Rango de Cuentas Presupuestales</option>
					<option value="3">Una Lista de Cuentas Presupuestales</option>
				</select>
			</td>
		</tr>	
		<tr>
			<td></td>
			<td colspan="3">
				<INPUT 	TYPE="textbox" 
					NAME="AYUDA" 
					VALUE="Consulta de las cuentas presupestales para un rango de cuentas" 
					SIZE="100" 
					readonly="yes"
					tabindex="-1"
					style=" font-size:12;  border: medium none; text-align:left; size:auto;"
				>		
			</td>
		</tr>
		
		<tr>
			<td align="center" colspan="2" nowrap bgcolor="##CCCCCC"><strong>Cuenta Presupuestal</strong></td>
		</tr>
		<tr>
			<td nowrap="nowrap"><strong>Cuenta Presupuestal:</strong></td>
			<td><table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td>
					<div id="IframeCuentaP">
						<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
						<td><input type="text" name="Cmayor" maxlength="4" size="4" onBlur=	"javascript:CargarCajas(this.value)" value="" tabindex="1"></td>
						<td><iframe marginheight="0"
						marginwidth="0" 
						scrolling="no" 
						name="cuentasIframe" 
						id="cuentasIframe" 
						width="100%" 
						height="20"
						frameborder="0"></iframe></td></tr></table>
					</div>
					</td>
					<td>
						<div id="tagCuentaP">
							<cf_CuentaPresupuesto>
						</div>
					</td>
					<td>						
						<input 	type="button"  
								id="AGRE" 
								name="AGRE"
								value="Agregar"
								tabindex="1"
								onClick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();">
					</td>
				</tr>
				</table>
				<BR>
				<table width="50%" align="center" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" >
					<tr><td></td></tr>
				</table>
			</td>
		</tr>
		<tr>  
			<td  align="center" colspan="2">
				<input type="submit" name="consultar" value="Consultar" id="consultar" tabindex="1">
				<input type="reset" name="Limpiar"  onClick="javascript: if (window.fnReset) return fnReset();" value="Limpiar" tabindex="1">
				<input type="hidden"   name="LastOneCuenta" id="LastOneCuenta" value="ListaNon">
				<input type="hidden" name="LastOneAsiento" id="LastOneAsiento" value="ListaNon">
			</td>
		</tr> 
	</table>
	<input type="hidden" name="CtaFinal" value="">
	<input type="hidden" name="CuentasADD" value="0">

</form>
<input type="image" id="imgDel"src="../../imagenes/Borrar01_S.gif"  title="Eliminar" style="display:none;" tabindex="1">

</cfoutput>
<script language="JavaScript1.2">
	/*********************************************************************************************************/
	document.form1.ID_REPORTE.focus();
	
	/*********************************************************************************************************/
	function fnReset(){
		document.getElementById("tblcuenta").innerHTML = "<tr><td></td></tr>";
		document.form1.AGRE.disabled = false;
		document.form1.CuentasADD.value = "0";
		document.form1.consultar.disabled = false;
		MostrarBoton();
		LimpiaCajas();
		
	}
	
	/*********************************************************************************************************/
	function LimpiaCajas()
	{
		//Para limpiar las cajas luego de agregar la cuenta
		CargarCajas(document.form1.AGRE.value);
	}

	/*********************************************************************************************************/
	function CargarCajas(Cmayor) {
		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas2.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA&TipoCuenta=P"
	}
	/*********************************************************************************************************/
	function FrameFunction() {
		// RetornaCuenta2() es máscara completa, rellena con comodín
		if(window.parent.cuentasIframe.RetornaCuenta2){
			window.parent.cuentasIframe.RetornaCuenta2();
		}
	}
	/*********************************************************************************************************/
	function validar() {
		var errores = "";
		switch (document.form1.ID_REPORTE.value){
			case '2' :
				cantidad = new Number(document.form1.CuentasADD.value);
				if(cantidad < 2 ){
					errores = errores + '- Para este tipo de reporte es necesario tener una cuenta inicial y otro final.\n';
				}				
			break;
			case '3' :
				cantidad = new Number(document.form1.CuentasADD.value);
				if(cantidad < 1 ){
					errores = errores + '- Para este tipo de reporte es necesario tener al menos una cuenta agregada.\n';
				}				
			break;
		}

		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}	
		
		document.form1.consultar.disabled = true;
		
	}	

	/*********************************************************************************************************/
	function MostrarBoton() {
		switch (document.form1.ID_REPORTE.value){
			case '2' :
				document.form1.AYUDA.value = "Consulta de las cuentas presupestales para un rango de cuentas";
				document.getElementById("tagCuentaP").style.display="block";
				document.getElementById("IframeCuentaP").style.display="none";	
			break;
			case '3' :
				document.form1.AYUDA.value = "Consulta de las cuentas presupestales para una lista de cuentas";
				document.getElementById("tagCuentaP").style.display="none";
				document.getElementById("IframeCuentaP").style.display="block";
			break;
		}
		document.form1.Cmayor.value = "";
		document.form1.CPcuenta.value = "";
		document.form1.CPformato.value = "";
		CargarCajas(document.form1.Cmayor);
	}
	MostrarBoton();

	/********************************************************************************************************/
	function fnNuevaCuentaContable()	{	
		var LvarTable 	= document.getElementById("tblcuenta");
		var LvarTbody 	= LvarTable.tBodies[0];
		var LvarTR    	= document.createElement("TR");
		var Lclass 		= document.form1.LastOneCuenta;
		if(document.form1.ID_REPORTE.value == '2')
			var cuenta	= document.form1.CPformato.value;
		else{
			FrameFunction();
			var cuenta		 = document.form1.CtaFinal.value;
		}
		var vectorcuenta = cuenta.split('-');
		var p1 = "";
		for(i=0;i < vectorcuenta.length;i++) {
			if(vectorcuenta[i].length > 0)
				p1 = p1 + vectorcuenta[i] + '-';
		}
		p1 = p1.substring(0,p1.length-1) 

		if (p1=="") {
			return;
		}	

		if (existeCodigoCuenta(p1)) {
			alert('La Cuenta Presupestal ya fue agregada.');
			return;
		}

		if(document.form1.ID_REPORTE.value == '2' && p1.indexOf('_',0) > -1){
			LimpiaCajas();
			alert('Para este tipo de reporte no se pueden utilizar comodines');
			return;
		}

		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CuentaidList");
		sbAgregaTdText  (LvarTR, Lclass.value, p1);
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}
		LvarTR.name = "XXXXX";
		LvarTbody.appendChild(LvarTR);
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
		var cant = new Number(document.form1.CuentasADD.value);
		cant = cant + 1;
		document.form1.CuentasADD.value = cant;

		if(document.form1.ID_REPORTE.value == '2' && cant >= 2)
		{
			document.form1.AGRE.disabled 	= true;		
		}	
				
		LimpiaCajas();
	}	
	/*********************************************************************************************************/
	function existeCodigoCuenta(v){
		var LvarTable = document.getElementById("tblcuenta");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}
	/*********************************************************************************************************/
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
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
	/*********************************************************************************************************/
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
	/*********************************************************************************************************/
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
	/*********************************************************************************************************/
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
		LvarTR.parentNode.removeChild(LvarTR);
		var cant = new Number(document.form1.CuentasADD.value);
		cant = cant -1;
		document.form1.CuentasADD.value = cant;
        if(document.form1.ID_REPORTE.value == '2' && cant < 2){
			document.form1.AGRE.disabled 	= false;		
		}		
	}
	/*********************************************************************************************************/
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
	
</script>
