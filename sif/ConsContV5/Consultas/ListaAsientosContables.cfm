<script language="javascript" type="text/javascript">
	var popUpWin = 0;
	
	function fnPopUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisAsientoContable() 
	{
		var params 	= "";
			params += "&CG5CON=CG5CON&CG5DES=CG5DES";
		fnPopUpWindow("ConlisAsientos.cfm?formulario=form1" + params,250,200,650,400);
	}
	
	function traeAsientoContable()
	{
		alert("Randall");
	}
	
	/* *****      Tabla Dinámica      ***** */
	/* ***** Función para agregar TRs ***** */
	var GvarNewTD;
			
	function fnNuevoAsientoContable() 
	{
		var LvarTable = document.getElementById("tblasiento");
		var LvarTbody = LvarTable.tBodies[0];
		var LvarTR    = document.createElement("TR");

		var Lclass 	= document.form1.LastOneAsiento;
		var p1 		= document.form1.CG5CON.value.toString();	// Código
		var p2 		= document.form1.CG5DES.value;				// Descripción

		document.form1.CG5CON.value = "";
		document.form1.CG5DES.value = "";
		
		// Valida no agregar vacíos
		if (p1=="") {
			return;
		}	  
		
		// Valida no agregar repetidos
		if (existeCodigoAsieCont(p1)) {
			alert('El Asiento Contable ya fue agregada.');
			return;
		}
	  
		// Agrega Columna 0
		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "AsieContidList");

		// Agrega Columna 1
		sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);

		// Agrega Evento de borrado en Columna 2
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}

		// Nombra el TR
		LvarTR.name = "XXXXX";
		
		// Agrega el TR al Tbody
		LvarTbody.appendChild(LvarTR);
	  
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
	}
			
	// Funcion que valida que no exista el Código en la Lista
	function existeCodigoAsieCont(v) 
	{
		var LvarTable = document.getElementById("tblasiento");
		
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
		
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}

	// Estas funciones las utilizan las Listas de Sucursales y de Asientos Contables
	// Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName) 
	{
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

	// Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue) 
	{
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

	// Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align) 
	{
		// Copia una imagen existente
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

	//Función para eliminar TRs
	function sbEliminarTR(e) 
	{
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
	}

	function fnTdValue(LprmNode) 
	{
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

<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<input type="image" id="imgDel" src="../imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">

<fieldset><legend></legend>
	<table width="90%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="subtitulo_seccion_small">&nbsp;Asientos Contables </td>
		</tr>
		<tr>
			<td>
				<table id="tblasiento" width="90%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
						<td colspan="2"><strong>Asiento Contable :</strong>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					  	<td nowrap>
							<input type="text" name="CG5CON" value="" size="6"  maxlength="6" onBlur="javascript:traeAsientoContable();">
							<input type="text" name="CG5DES" value="" size="30" maxlength="60" disabled>															  
							<a href="#" tabindex="-1" >
								<img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Sucursales" name="imagen2" width="18" height="14" border="0" align="absmiddle"  onClick='javascript:doConlisAsientoContable();'>
							</a>&nbsp;
						</td>
						<td align="right" nowrap>
							<input type="hidden" name="LastOneAsiento" id="LastOneAsiento" value="ListaNon" tabindex="3">
							<input type="button" name="agregarAsiento" value="+" onClick="javascript:if (window.fnNuevoAsientoContable) fnNuevoAsientoContable();"  tabindex="3">
						</td>
					</tr>
					<tbody>
					</tbody>
				</table>
			</td>
		</tr>
	</table>
</fieldset>

