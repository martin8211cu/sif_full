<cfset CATCOLUM = "TF"><!---Catalogo Default--->

<!---===================Oficinas===================--->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Oficodigo, Ocodigo, Odescripcion
	 from Oficinas
	where Ecodigo = #session.Ecodigo#
	order by Oficodigo, Odescripcion
</cfquery>
<!---============Grupo de Oficinas================--->
<cfquery name="rsGO" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>
<!---===========Periodo por Defecto===============--->
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid
	from CPresupuestoPeriodo p
	where p.Ecodigo = #Session.Ecodigo#
	  and p.CPPestado <> 0
</cfquery>
<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
<cfset session.CPPid = form.CPPid>
<!---Maxima Cantidad de Niveles de las Mascaras--->
<cfquery name="rsNiveles" datasource="#Session.DSN#">
	select Max(A.PCNid) as Nmax
	from PCNivelMascara A
		inner join PCEMascaras B
			on A.PCEMid = B.PCEMid
	where B.CEcodigo = #Session.CEcodigo#
</cfquery>
	<cfset VNmax = rsNiveles.Nmax>
<cfif VNmax LT 3 or len(trim(rsNiveles.Nmax)) EQ 0>
	<cfset VNmax = 6>
</cfif>
<!---=========Catalogo Columnar================--->
<cfquery name="rsCatColumn" datasource="#Session.DSN#">
	select PCEcatid,PCEcodigo,PCEdescripcion 
		from PCECatalogo 
	where CEcodigo = #session.CEcodigo# 
	  and PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CATCOLUM#">
</cfquery>
<cfoutput>
	<form name="form1" method="post" action="rptApliRecursosEjecR.cfm" onSubmit="return validar();"  style="MARGIN:0;">
		<table align="center" border="0">
<!---=================Periodo Presupuestal=========================--->
			<tr>
				<td nowrap>Período Presupuestario:</td>
				<td colspan="3"><cf_cboCPPid value="#session.CPPid#" onChange="javascript: this.form.action='';this.form.submit();" CPPestado="1,2"></td>
			</tr>
<!---=================Oficinas y Grupo de Oficinas-=================--->
			<tr>
				<td>Oficina(s):</td>
				<td colspan="3">
					<table border="0" cellpadding="0" cellspacing="0"><tr>
						<td>
							<select name="ubicacion" style="width:200px" tabindex="1" onchange="viewAddGroupofi()">
								<optgroup label="Grupo de Oficinas">
									 <cfloop query="rsGO">
										<option value="go,#rsGO.GOid#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'go,' & rsGO.GOid>selected</cfif> > #HTMLEditFormat(rsGO.GOnombre)#</option>
									 </cfloop>
								</optgroup>
								<optgroup label="Oficina">
									<cfloop query="rsOficinas">
										<option value="of,#rsOficinas.Ocodigo#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'of,' & rsOficinas.Ocodigo>selected</cfif> >
											#rsOficinas.Oficodigo# - #HTMLEditFormat(rsOficinas.Odescripcion)#
										</option>
									</cfloop>
								</optgroup>
							</select>
						</td>
						<td>
							<img src="../../../sif/imagenes/mas.gif" name="agregarGO" id="agregarGO" onclick="crear(this)" />
						</td>
						<td>
							<input type="checkbox" name="chkColGO" id="chkColGO" value="1" <cfif isdefined("form.chkColGO")>checked</cfif>> 
						</td>
						<td id="chkColGOTD">Visualizar grupos en columnas
			  			</td>
					</tr></table>
				</td>
			</tr>
<!---===========Listado de Grupos de Oficinas===================--->
			<tr>
				<td>&nbsp;</td>
				<td colspan="3">
					<fieldset id="fiel" style="display:none; border:hidden">
					</fieldset>
				</td>
			</tr>
<!----=================Tipo de Reporte-=========================--->
			<tr>
				<td>Tipo de Reporte:</td>
				<td colspan="3">
					<select name="ID_REPORTE" tabindex="1" onchange="javascript:  MostrarBoton()">
						<option value="1">Una Cuenta Presupuestal</option>
						<option value="2">Un Rango de Cuentas Presupuestales</option>
						<option value="3">Una Lista de Cuentas Presupuestales</option>
					</select>
				</td>
			</tr>
<!----=================Cuenta Contable=========================--->
			<tr>
				<td>Cuenta Presupuestal:</td>
				<td align="left">
					<div id="tagCuentaP">
						<cf_CuentaPresupuesto>
					</div>
					<div id="IframeCuentaP">
						<table width="100%" cellpadding="0" cellspacing="0" border="0" align="left">
							<tr>
								<td>
									<input type="text" name="Cmayor" maxlength="4" size="4" onBlur=	"javascript:CargarCajas(this.value)" value="" tabindex="1">
								</td>
								<td align="left">
									<iframe marginheight="0" marginwidth="0" scrolling="no" name="cuentasIframe" id="cuentasIframe" width="100%" height="20" frameborder="0"></iframe>
								</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<input type="button" id="AGRE" name="AGRE" class="btnGuardar" value="Agregar" tabindex="1" onClick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();" style="display:none">	
				</td>	
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3">
					<table width="50%" align="left" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" >
						<tr><td></td></tr>
					</table>
				</td>
			</tr>
<!----=================Nivel de Detalle de la cuenta=========================--->	
			<tr>		
				<td>Nivel Detalle:</td>
				<td colspan="3">
					<select name="nivelDet" size="1" id="nivel" tabindex="1">
					  <cfloop index="i" from="1" to="#VNmax#">
						<option value="#i#">#i#</option>
					  </cfloop>
					</select>			
				</td>
			</tr>
<!---=================Catalogo Columnar=======================================--->
			<tr>
				<td>Catalogo Columnar
				</td>
				<td>
					<cfif rsCatColumn.Recordcount GT 0 >	  
						<cf_sifcatalogos query="#rsCatColumn#" tabindex="2">
					<cfelse>	
						<cf_sifcatalogos tabindex="2">		
					</cfif>		  		
				</td>
			</tr>
<!---=================Mostrar Formato en Miles o Colones===================--->		
			<tr>
				<td>
					Formato de Montos: 
				</td>
				<td>
					<select name="Format" size="1" id="Format" tabindex="1">
						<option value="L">Moneda Local</option>
						<option value="M">Miles</option>
					</select>			
				</td>
			</tr>	
<!---=================Boton de Generar Reporte=============================--->				
			<tr>
				<td align="center" colspan="4">
					<input type="submit" name="Reporte" class="btnSiguiente" value="Procesar" id="Procesar" onClick="" tabindex="1">
				</td>
			</tr>
		</table>
		<input type="hidden" name="CtaFinal" 	  id="CtaFinal" 	 value="">
		<input type="hidden" name="CuentasADD" 	  id="CuentasADD"	 value="0">
		<input type="hidden" name="LastOneCuenta" id="LastOneCuenta" value="ListaNon">
		<input type="image"  name="imgDel"        id="imgDel" 		 value=""	src="../../../sif/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;" tabindex="1">
	</form>
</cfoutput>
<script language="javascript">
var form = document.form1;
num=0;
/*********MUESTRA EL BOTON DE AGREGA EN LA CUENTA CONTABLE**************************************/
function MostrarBoton() {
		var AGRE = document.getElementById("AGRE");
        switch (document.form1.ID_REPORTE.value){
			case '1' :
				AGRE.style.display = 'none';
				document.getElementById("tagCuentaP").style.display="block";
				document.getElementById("IframeCuentaP").style.display="none";	
			break;
			case '2' :
				AGRE.style.display = 'block';
				document.getElementById("tagCuentaP").style.display="block";
				document.getElementById("IframeCuentaP").style.display="none";	
			break;
			case '3' :
				AGRE.style.display = 'block';
				document.getElementById("tagCuentaP").style.display="none";
				document.getElementById("IframeCuentaP").style.display="block";
			break;
		}
		document.form1.Cmayor.value = "";
		document.form1.CPcuenta.value = "";
		document.form1.CPformato.value = "";
		CargarCajas(document.form1.Cmayor);
	}
/*********MUESTRA EL BOTON DE AGREGA GRUPO DE OFICINAS**************************************/
function viewAddGroupofi()
{
	var ubication = document.form1.ubicacion.value.split(',');
	 switch (ubication[0])
	 {
	 	case 'go' :
			document.getElementById("agregarGO").style.display="block";
			document.getElementById("chkColGO").style.display="block";
			document.getElementById("chkColGOTD").style.display="block";
			
		break;
		case 'of' :
			document.getElementById("agregarGO").style.display="none";
			document.getElementById("chkColGO").style.display="none";
			document.getElementById("chkColGOTD").style.display="none";
			document.getElementById("chkColGO").checked = false;
			
			document.getElementById("fiel").style.display="none";
			BorrarAllGO();
		break;
	 }
}
<!---===Funcion Permite agregar un listado de grupos de Oficinas======================--->
function crear(obj) 
{
	num++;
	var ubication = document.form1.ubicacion.value.split(',');	
	document.getElementById("fiel").style.display="";
	if (document.getElementById(ubication[1]))
	{
		alert('El grupo de Oficinas ya fue agregado a la lista');
		return;
	}
	<!---Se crea el conetenedor--->
	fi = document.getElementById('fiel'); 
	contenedor = document.createElement('div');
	contenedor.id = 'div'+num; 
	fi.appendChild(contenedor); 
		
	<!---Crea el campo que se ver en pantalla--->
	ele = document.createElement('label');
	ele.id = ubication[1];
	ele.style.fontStyle = 'normal';
	ele.style.fontWeight = 'normal';
	ele.innerHTML = form.ubicacion.options[form.ubicacion.selectedIndex].text;
	contenedor.appendChild(ele); 
		  
	<!---Crea el boton de Eliminar--->
	ele = document.createElement('img'); 
	ele.src = '../../../sif/imagenes/Borrar01_S.gif';
	ele.name = 'div'+num; 
	ele.onclick = function () {borrar(this.name)}
	contenedor.appendChild(ele); 
		  
	<!---Crea el Hiden que se enviar en el Form--->
	ele = document.createElement('input');
	ele.type = 'hidden'; 
	ele.name = 'listGO'; 
	ele.value = ubication[1];
	contenedor.appendChild(ele); 
}
<!---============Borrar un grupo de Oficinas============--->
function borrar(obj) 
{
	fi = document.getElementById('fiel'); 
	fi.removeChild(document.getElementById(obj)); 
}
<!---============Borrar todo el listado de Grupo de Oficinas============--->
function BorrarAllGO()
{
	var cell = document.getElementById("fiel");
	document.getElementById("fiel").style.display="none";
	if ( cell.hasChildNodes() )
	{
   		while ( cell.childNodes.length >= 1 )
    	{
        	cell.removeChild( cell.firstChild );       
    	} 
	}
}
/*********CARGA LAS CAJAS DE LA MASCARA DE LA MAYOR*********************************************/
function CargarCajas(Cmayor) {
		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas2.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA&TipoCuenta=P"
	}
/*********AGREGA UNA CUENTA CONTABLE AL LISTADO, CUANDO ES POR LISTADO O RANGO DE CUENTAS********/
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
			alert('La Cuenta Contable ya fue agregada.');
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
/*****/
function FrameFunction() {
		if(window.parent.cuentasIframe.RetornaCuenta2){
			window.parent.cuentasIframe.RetornaCuenta2();
		}
	}	
/*******************/
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
/*****OBTIENEN CADA UNO DE LOS VALORES DE UNA TABLA (TD)*************/
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
/*******Para limpiar las cajas luego de agregar la cuenta**********/
function LimpiaCajas()
	{
		CargarCajas(document.form1.AGRE.value);
	}
/*****************/
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
/******************/
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
/******************/
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
/*********************/
function validar() {
		var errores = "";
		switch (document.form1.ID_REPORTE.value){
			case '1' :
				///FrameFunction();
				var cuenta		 = document.form1.CPformato.value	
				var vectorcuenta = cuenta.split('-');
				var p1 = "";
				for(i=0;i < vectorcuenta.length;i++) {
					if(vectorcuenta[i].length > 0)
						p1 = p1 + vectorcuenta[i] + '-';
				}
				p1 = p1.substring(0,p1.length-1)
				
				document.form1.CPformato.value = p1;
	
				if (document.form1.CPformato.value.length == 0) {
					errores = errores + '- El campo cuenta contable  es requerido.\n';
				}	
			break;
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

		
		if (document.form1.PCEcatid.value.length == "") {
			errores = errores + '- El Catalogo Columnar no está Definido en la empresa.\n';
		}
		if (document.form1.nivelDet.value.length == "") {
			errores = errores + '- El Campo Nivel de Detalle es Requerido.\n';
		}
		
		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}	
		
		document.form1.Procesar.disabled = true;
		
	}	
	/*********************************************************************************************************/
	MostrarBoton();
	viewAddGroupofi();
	CargarCajas(document.form1.AGRE.value);
</script>