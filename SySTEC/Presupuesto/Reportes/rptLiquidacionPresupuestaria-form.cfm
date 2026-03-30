<cfif  isDefined("url.Archivo")>
	<cfset Form.Archivo = url.Archivo>
</cfif>
<cfif not isDefined("Form.Archivo")>
	<cfset Form.Archivo = 'N'>
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsPeriodosPres" datasource="#session.dsn#">
	select  CPPid, 
		case CPPtipoPeriodo 
			when 1 then 'Mensual' 
			when 2 then 'Bimestral' 
			when 3 then 'Trimestral' 
			when 4 then 'Cuatrimestral' 
			when 6 then 'Semestral' 
			when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
       case <cf_dbfunction name="date_part" args="MM,CPPfechaDesde">
	        when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# 
		case 
			when <cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY"> <> <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY"> 
			then <cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY"> else ''
		end
			#_Cat# ' a ' #_Cat# 
		case <cf_dbfunction name="date_part" args="MM,CPPfechaHasta">
			when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY">  as descripcion
		from CPresupuestoPeriodo
		where Ecodigo = #session.Ecodigo#
	order by CPPfechaDesde desc
</cfquery>
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Oficodigo, Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.Ecodigo#
	order by Oficodigo, Odescripcion
</cfquery>

<cfquery name="rsGO" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>

<cfset VCEcodigo = #Session.CEcodigo#>

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

<cfoutput>
<form method="post" action="rptLiquidacionPresupuestaria-imprimir.cfm" name="form1"  onSubmit="return validar();"  style="MARGIN:0;">
	<table align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td nowrap><strong>Periódo Presupuestal:&nbsp;&nbsp;</strong></td>
			<td>
				<select name="CPPid" size="1" id="CVid" tabindex="1">
				  <cfloop query="rsPeriodosPres">
					<option value="#rsPeriodosPres.CPPid#">#rsPeriodosPres.descripcion#</option>
				  </cfloop>
				</select>			
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td><strong>Oficina/Grupos:</strong></td>
			<td><table border="0" cellpadding="0" cellspacing="0"><tr>
				<td>
					<select name="ubicacion" style="width:200px" tabindex="1" onchange="viewAddGroupofi()">
						<cfif rsGO.RecordCount>
						  <optgroup label="Grupo de Oficinas">
						  <cfloop query="rsGO">
							<option value="go,#rsGO.GOid#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'go,' & rsGO.GOid>selected</cfif> > #HTMLEditFormat(rsGO.GOnombre)#</option>
						  </cfloop>
						  </optgroup>
						</cfif>
						<optgroup label="Oficina">
						<cfloop query="rsOficinas">
						  <option value="of,#rsOficinas.Ocodigo#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'of,' & rsOficinas.Ocodigo>selected</cfif> >
							#rsOficinas.Oficodigo# - #HTMLEditFormat(rsOficinas.Odescripcion)#</option>
						</cfloop>
						</optgroup>
						
					 </select>
				</td>
				<td>
					<img src="../../../sif/imagenes/mas.gif" name="agregarGO" id="agregarGO" onclick="crear(this)" />
				</td>
			</tr></table></td>
		</tr>
		<!---===========Listado de Grupos de Oficinas===================--->
		<tr>
			<td>&nbsp;</td>
			<td>
				<fieldset id="fiel" style="display:none; border:hidden">
				</fieldset>
			</td>
		</tr>
		<tr>
			<td><strong>Tipo de Reporte :</strong></td>
			<td>
				<select name="ID_REPORTE" tabindex="1" onchange="javascript:  MostrarBoton()">
					<option value="1">Una Cuenta Contables</option>
					<option value="2">Un Rango de Cuentas Contables</option>
					<option value="3">Una Lista de Cuentas Contables</option>
				</select>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>	
		<tr>
			<td><strong>Cuenta Presupuestal:</strong></td>
			<td>
				<table cellpadding="0" cellspacing="0" border="0" >
					<tr>
						<td>
							<div id="IframeCuentaP">
								<table cellpadding="0" cellspacing="0" border="0"><tr>
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
						<td><div id="tagCuentaP"><cf_CuentaPresupuesto></div></td>
						<td>						
							<input 	type="button"  
									id="AGRE" 
									name="AGRE"
									value="Agregar"
									tabindex="1"
									onClick="javascript:if (window.fnNuevaCuentaPresupuestal) fnNuevaCuentaPresupuestal();" 
							style="display:none">
						</td>
					</tr>
				</table>
				<table align="center" cellpadding="0" cellspacing="0" border="0" >
					<tr><td>
						<div id="divcuenta">
							<table align="center" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" >
								<tr><td></td></tr>
							</table>
						</div>
					</td></tr>
				</table>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td><strong>Nivel Detalle:</strong></td>
			<td>
				<select name="nivelDetalle" size="1" id="nivel">
				  <cfloop index="i" from="0" to="#VNmax#">
					<option value="#i#">#i#</option>
				  </cfloop>
					<option value="-1">--Último nivel--</option>
				</select>			
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td><strong>Formato de Montos:</strong></td>
			<td>
				<select name="Formato" size="1" id="Formato" tabindex="1">
					<option value="L" selected>Moneda Local</option>
					<option value="M">Miles</option>
				</select>		
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>  
			<td  align="center" colspan="2">
				<input type="submit" name="Procesar" value="Procesar" id="Procesar" onClick="" tabindex="1" class="btnSiguiente">
				<input type="reset" name="Limpiar"  onClick="LimpiaCajas();BorrarAllGO();" value="Limpiar" tabindex="1" class="btnLimpiar">
				<input type="hidden"   name="LastOneCuenta" id="LastOneCuenta" value="ListaNon">
				<input type="hidden" name="LastOneAsiento" id="LastOneAsiento" value="ListaNon">
			</td>
		</tr>
	</table>
	<input type="hidden" name="CtaFinal" value="">
	<input type="hidden" name="CuentasADD" value="0">
	<input type="hidden" name="PROGRAMADO" value="#Form.Archivo#">


</form>
<input type="image" id="imgDel"src="../../../sif/imagenes/Borrar01_S.gif"  title="Eliminar" style="display:none;" tabindex="1">

</cfoutput>
<script language="JavaScript1.2">
	/*********************************************************************************************************/
	form = document.form1;
	form.ID_REPORTE.focus();
	num=0;
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
		if(window.parent.cuentasIframe.RetornaCuenta2){
			window.parent.cuentasIframe.RetornaCuenta2();
		}
	}	
	
	/*********************************************************************************************************/
	function validar() {
		var errores = "";
		switch (document.form1.ID_REPORTE.value){
			case '1' :
				fnNuevaCuentaPresupuestal();
				if(document.form1.CPformato.value == "" ){
					errores = errores + '- Para este tipo de reporte es necesario tener una cuenta presupuestal.\n';
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

		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}
	}	

	/*********************************************************************************************************/
	function MostrarBoton() {
		switch (document.form1.ID_REPORTE.value){
			case '1' :
				document.getElementById("tagCuentaP").style.display="block";
				document.getElementById("IframeCuentaP").style.display="none";	
			break;
			case '2' :
				document.getElementById("tagCuentaP").style.display="block";
				document.getElementById("IframeCuentaP").style.display="none";	
			break;
			case '3' :
				document.getElementById("tagCuentaP").style.display="none";
				document.getElementById("IframeCuentaP").style.display="block";
			break;
		}
		eliminaCuentas();
		Cmayor = document.form1.Cmayor;
		Cmayor.value = "";
		LimpiaCajas();
		AGRE = document.form1.AGRE;
        if(document.form1.ID_REPORTE.value != '1'){
			AGRE.style.display = ''
			AGRE.disabled = false;		
		}
		else{
			AGRE.style.display = 'none';
		}
	}

	// Función que valida que no exista el código en la lista
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
	
	/********************************************************************************************************/
	function fnNuevaCuentaPresupuestal()	{	
		var LvarTable 	= document.getElementById("tblcuenta");
		var LvarTbody 	= LvarTable.tBodies[0];
		var LvarTR    	= document.createElement("TR");
		var Lclass 		= document.form1.LastOneCuenta;
		idR = document.form1.ID_REPORTE.value ;
		if(idR != '3'){
			var cuenta	= document.form1.CPformato.value;
		}	
		else if(idR == '3'){
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
	
	/*********************************************************************************************************/
	function eliminaCuentas(){
		var LvarDiv = document.getElementById("divcuenta");
		LvarDiv.innerHTML = '<table align="center" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" ><tr><td></td></tr></table>';
		document.form1.CuentasADD.value = 0;
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
	}	<!---===Funcion Permite agregar un listado de grupos de Oficinas======================--->
	function crear(obj){
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
	function borrar(obj){
		fi = document.getElementById('fiel'); 
		fi.removeChild(document.getElementById(obj)); 
	}
	<!---============Borrar todo el listado de Grupo de Oficinas============--->
	function BorrarAllGO(){
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
	/*********MUESTRA EL BOTON DE AGREGA GRUPO DE OFICINAS**************************************/
	function viewAddGroupofi(){
		var ubication = document.form1.ubicacion.value.split(',');
		 switch (ubication[0])
		 {
			case 'go' :
				document.getElementById("agregarGO").style.display="block";	
			break;
			case 'of' :
				document.getElementById("agregarGO").style.display="none";
				document.getElementById("fiel").style.display="none";
				BorrarAllGO();
			break;
		 }
	}
	MostrarBoton();
	viewAddGroupofi();
</script>
