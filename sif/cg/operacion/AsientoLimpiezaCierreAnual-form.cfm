<!--- 
	Creado por Gustavo Fonseca H.
	Fecha: 5-1-2007.
	Motivo: Soporte del proceso de Cierre Anual.
 --->


<cfoutput>
	<form name="form1" method="post" action="AsientoLimpiezaCierreAnual.cfm" onSubmit="<cfif not isdefined("form.Procesar")>return Valida()</cfif>"  style="MARGIN:0;">
		<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
			<tr>
				<td style="width:25%">&nbsp;</td>
				<td align="center" colspan="4" nowrap>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td width="14%" nowrap="nowrap" align="right"><strong>Cuenta Contable Origen:&nbsp;</strong></td>

				<td width="3%">					
					<input type="text" name="Cmayor" maxlength="4" size="4" width="100%" 
							onfocus="this.select();"
							onBlur="javascript:CargarCajas(this.value);">									
				</td>	
				<td width="48%">	
					<iframe marginheight="0"
					marginwidth="0" 
					scrolling="no" 
					name="cuentasIframe" 
					id="cuentasIframe" 
					width="100%" 
					height="20"
					frameborder="0"></iframe>
					<input type="hidden" name="CtaFinal">
				</td>	
				<td colspan="3">						
					<input 	type="button"  
							id="AGRE" 
							name="AGRE"
							value="Agregar"
							tabindex="0"
							onClick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();" 
					style="display:none">
				</td>
			</tr>
			<!--- ******************************************************************************************** --->						
			<tr>
				<td>&nbsp;</td>
				<td width="14%" nowrap="nowrap" align="right"><strong>Cuenta Contrapartida:&nbsp;</strong></td>

				<td width="3%">
				
					<input type="text" name="CmayorContra" maxlength="4" size="4" width="100%" 
						onfocus="this.select();"
						onBlur="javascript:CargarCajasContra(this.value);">
				</td>	
				<td width="48%">
					<iframe marginheight="0" 
						marginwidth="0" 
						scrolling="no" 
						name="cuentasIframeContra" 
						id="cuentasIframeContra" 
						width="100%" 
						height="20" 
						frameborder="0"></iframe>
					<input type="hidden" name="CtaFinalContra">				
				
				</td>	
				<td colspan="3">
					<input 	type="button"  
							id="AGREContra" 
							name="AGREContra"
							value="AgregarContra"
							tabindex="0"
							onClick="javascript:if (window.fnNuevaCuentaContableContra) fnNuevaCuentaContableContra();" 
					style="display:none">
				</td>
			</tr>
			
			<!--- ******************************************************************************************** --->		
			<tr>
				<td>&nbsp;</td>
				<td align="right"><strong>Oficina:&nbsp;</strong></td>
				<td colspan="3">								
					<cfset ArrayOF=ArrayNew(1)>
					<cf_conlis
						Campos="Ocodigo,Oficodigo,Odescripcion"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						ValuesArray="#ArrayOF#" 
						Title="Lista de Oficinas"
						Tabla="Oficinas"
						Columnas="Ocodigo,Oficodigo,Odescripcion"
						Filtro="Ecodigo = #Session.Ecodigo#"
						Desplegar="Oficodigo,Odescripcion"
						Etiquetas="C&oacute;digo,Descripci&oacute;n"
						filtrar_por="Oficodigo,Odescripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="Ocodigo,Oficodigo,Odescripcion"
						Asignarformatos="S,S,S"/>
				</td>	
			</tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>  
				<td   align="center" colspan="5">
                	<cfif not isdefined("form.Procesar")>
						<input type="submit" name="Procesar" 			value="Procesar" 	id="Procesar" onclick="javascript: return validaCmayor()">
                    </cfif>
                    <input type="submit" name="btnRegresar" 		value="Regresar" 	tabindex="1" onclick="document.form1.action='DocumentosContablesCierreAnual.cfm?inter=N&modo=ALTA'">
					<input type="hidden" name="Eperiodo" 			value="#form.Eperiodo#">
					<input type="hidden" name="Emes" 				value="#form.Emes#">
					<input type="hidden" name="Cconcepto" 			value="#form.Cconcepto#">
					<input type="hidden" name="LastOneCuenta" 		value="ListaNon"	id="LastOneCuenta" >
					<input type="hidden" name="LastOneAsiento" 		value="ListaNon"	id="LastOneAsiento" >
					<input type="hidden" name="LastOneCuentaContra" value="ListaNon"	id="LastOneCuentaContra">
					<input type="hidden" name="LastOneAsientoContra" value="ListaNon"	id="LastOneAsientoContra">
					<!---<input type="hidden" name="CtaFinal" 			value="">--->
					<!---<input type="hidden" name="CtaFinalContra" 		value="">--->
					<input type="hidden" name="CuentasADD" 			value="0">
					<input type="hidden" name="CuentasADDContra" 	value="0">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<script language="JavaScript1.2">
	/*********************************************************************************************************/
	function LimpiaCajas()
	{
		//Para limpiar las cajas luego de agregar la cuenta
		CargarCajas(document.form1.AGRE.value)
	}

	/*********************************************************************************************************/
	function CargarCajas(Cmayor) {
		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas2.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA"
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
		FrameFunction();
		var cuentaContra = document.form1.CtaFinal.value	
		var vectorcuentaContra = cuentaContra.split('-');
		var p1 = "";
		
		for(i=0;i < vectorcuentaContra.length;i++) {
			if(vectorcuentaContra[i].length > 0)
				p1 = p1 + vectorcuentaContra[i] + '-';
		}
		p1 = p1.substring(0,p1.length-1)
		
		document.form1.CtaFinal.value = p1;

		if (document.form1.CtaFinal.value.length == 0) {
			errores = errores + '- El campo cuenta contable  es requerido.\n';
		}	
		
		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}
		
	}	
	/********************************************************************************************************/
	function fnNuevaCuentaContable()	{	
		var LvarTable 	= document.getElementById("tblcuenta");
		var LvarTbody 	= LvarTable.tBodies[0];
		var LvarTR    	= document.createElement("TR");
		var Lclass 		= document.form1.LastOneCuenta;
		FrameFunction();
		var cuenta		 = document.form1.CtaFinal.value	
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
			alert('La Cuenta Contable ya fue agregada.');
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
			LvarInp.value = LprmValue +"|" 
			+ document.form1.nivelDet.value +"|"		 
			+ document.form1.nivelTot.value;

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
	
	
	
	
	


/*********************************************************************************************************/
	function LimpiaCajasContra()
	{
		//Para limpiar las cajas luego de agregar la cuenta
		CargarCajasContra(document.form1.AGREContra.value)
	}

	/*********************************************************************************************************/
	function CargarCajasContra(CmayorContra) {
		if (document.form1.CmayorContra.value != '') {
			var aContra = '0000' + document.form1.CmayorContra.value;
			aContra = aContra.substr(aContra.length-4, 4);
			document.form1.CmayorContra.value = aContra;
		}
		var frContra = document.getElementById("cuentasIframeContra");
		frContra.src = "/cfmx/sif/Utiles/generacajas2Contra.cfm?CmayorContra="+document.form1.CmayorContra.value+"&MODO=ALTA"
	}
	/*********************************************************************************************************/
	function FrameFunctionContra() {
		if(window.parent.cuentasIframeContra.RetornaCuenta2Contra){
			window.parent.cuentasIframeContra.RetornaCuenta2Contra();
		}
	}	
	/*********************************************************************************************************/
	function validarContra() {
		var errores = "";
		FrameFunctionContra();
		var cuentaContra = document.form1.CtaFinalContra.value	
		var vectorcuentaContra = cuentaContra.split('-');
		var p1 = "";
		for(i=0;i < vectorcuentaContra.length;i++) {
			if(vectorcuentaContra[i].length > 0)
				p1 = p1 + vectorcuentaContra[i] + '-';
		}
		p1 = p1.substring(0,p1.length-1)
		
		document.form1.CtaFinalContra.value = p1;

		if (document.form1.CtaFinalContra.value.length == 0) {
			errores = errores + '- El campo cuenta Contrapartida  es requerido.\n';
		}	
	
		
		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}	
		
	}	
	/********************************************************************************************************/
	function fnNuevaCuentaContableContra()	{	
		var LvarTable 	= document.getElementById("tblcuentaContra");
		var LvarTbody 	= LvarTable.tBodies[0];
		var LvarTR    	= document.createElement("TR");
		var Lclass 		= document.form1.LastOneCuentaContra;
		FrameFunctionContra();
		var cuentaContra = document.form1.CtaFinalContra.value	
		var vectorcuentaContra = cuentaContra.split('-');
		var p1 = "";
		for(i=0;i < vectorcuentaContra.length;i++) {
			if(vectorcuentaContra[i].length > 0)
				p1 = p1 + vectorcuentaContra[i] + '-';
		}
		p1 = p1.substring(0,p1.length-1) 

		if (p1=="") {
			return;
		}	

		if (existeCodigoCuentaContra(p1)) {
			alert('La Cuenta Contable ya fue agregada.');
			return;
		}

		

		sbAgregaTdInputContra (LvarTR, Lclass.value, p1, "hidden", "CuentaidListContra");
		sbAgregaTdTextContra  (LvarTR, Lclass.value, p1);
		sbAgregaTdImageContra (LvarTR, Lclass.value, "imgDel", "right");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTRContra);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTRContra, false);
		}
		LvarTR.name = "XXXXX";
		LvarTbody.appendChild(LvarTR);
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
		var cantContra = new Number(document.form1.CuentasADDContra.value);
		cantContra = cantContra + 1;
		document.form1.CuentasADDContra.value = cantContra;

		LimpiaCajasContra();
	}	
	/*********************************************************************************************************/
	function existeCodigoCuentaContra(v){
		var LvarTable = document.getElementById("tblcuentaContra");
		for (var i=0; i<LvarTable.rows.length; i++){
			var valueContra = new String(fnTdValueContra(LvarTable.rows[i]));
			var dataContra = valueContra.split('|');
			if (dataContra[0] == v) {
				return true;
			}
		}
		return false;
	}
	/*********************************************************************************************************/
	function sbAgregaTdInputContra (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
		}
		
		if (LprmValue != "") {
			LvarInp.value = LprmValue +"|" 
			+ document.form1.nivelDetContra.value +"|"		 
			+ document.form1.nivelTotContra.value;

		} 

		LvarTD.appendChild(LvarInp);
		if (LprmClass!="") { 
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}
	/*********************************************************************************************************/
	function sbAgregaTdTextContra (LprmTR, LprmClass, LprmValue){
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
	function sbAgregaTdImageContra (LprmTR, LprmClass, LprmNombre, align){
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
	function sbEliminarTRContra(e){
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
		var cantContra = new Number(document.form1.CuentasADDContra.value);
		cantContra = cantContra -1;
		document.form1.CuentasADDContra.value = cantContra;
	}
	/*********************************************************************************************************/
	function fnTdValueContra(LprmNode){
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
	function Valida(){
		validarContra();
		validar();
			return;
	}
	
	function validaCmayor(){
		if (document.form1.Cmayor.value != document.form1.CmayorContra.value){
				alert('La cuenta mayor y la contracuenta mayor deben ser las mismas.');	
				return false;
			}
		else{
				document.form1.submit();

		}
	}
</script>

<cfif isdefined("form.Procesar")>
	<cfset LvarOcodigo = "-1">
	<cfif isdefined("form.Ocodigo") and Len(trim(form.Ocodigo)) and form.Ocodigo GTE 0>
		<cfset LvarOcodigo = form.Ocodigo>
	</cfif>
	<cfinvoke 
		component="sif.Componentes.CG_CierreAnual" 
			method="AsientoLimpia"
			  CMayor="#form.Cmayor#"
			  mascara="#form.CtaFinal#"
			  mascara2="#form.CtaFinalContra#"
			  Ecodigo="#session.Ecodigo#"
			  Periodo="#form.EPeriodo#"
			  Mes="#form.EMes#"
			  Ocodigo="#LvarOcodigo#"
			  Cconcepto="#form.Cconcepto#"
			  debug="false"/>

	<form name="form2" method="post" action="">
	    <input type="submit" name="btnRegresar" value="Regresar" tabindex="1" onclick="document.form2.action='DocumentosContablesCierreAnual.cfm?inter=N&modo=ALTA'">	
    </form>
	<cflocation url="listaDocumentosContablesCierreAnual.cfm" addtoken="no">
</cfif>
	
