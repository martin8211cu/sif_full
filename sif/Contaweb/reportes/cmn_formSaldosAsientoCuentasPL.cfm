<cfquery name="rsParametros" datasource="#session.Conta.dsn#">
	select   CGPMES ,CGPANO  from CGX001  
</cfquery>

<cfquery name="rsSucursal" datasource="#session.Conta.dsn#">
	select A.CGE5COD  as CGE5COD, CGE5DES as CGE5DES
	from CGE005 A, CGE000 B
	WHERE A.CGE1COD = B.CGE1COD
</cfquery>

<cfquery name="rsPeriodo" datasource="#session.Conta.dsn#">
	select PERCOD,PERDES   from CGX051
</cfquery>

<cfquery name="rsMeses" datasource="#session.Conta.dsn#">
	select MESCOD,MESNOM   from CGX050
</cfquery>

<cfset H_ACTUAL = Hour(Now())>
<cfset T_ACTUAL = "AM">
<cfif H_ACTUAL gt 12>
	<cfset H_ACTUAL = H_ACTUAL - 12>
	<cfset T_ACTUAL = "PM">
</cfif>
<cfset M_ACTUAL = Minute(Now())>

<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<cfoutput>
<form name="form1" method="post" action="cmn_GeneraArchivo.cfm" onSubmit="">
	<table width="100%" border="0">
  		<tr>
    		<td>
				<!--- ---------------------------------------- --->
				<!--- --     INICIA PINTADO DE LA PANTALLA     --->
				<!--- ---------------------------------------- --->
			  	<table width="100%" border="0">
			  		<tr>
						<td align="left" colspan="4">
						    <input type="submit" name="GENERAR" value="Generar" onClick="" tabindex="10">
							<input type="reset" name="Limpiar"  onClick="javascript: OcultarCeldas()"value="Limpiar" tabindex="10">
							<input type="button" name="LISTA" value="Ver lista" onClick="javascript:if (window.verlista) verlista() ;"  tabindex="10">
						</td>
					</tr>
					<!--- ********************************************************************************* --->
					<tr>						<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
							<strong>Cuenta Contable</strong>
						</td>
					</tr>            
					<!--- ********************************************************************************* --->
					<tr>
						<td colspan="4">
							<table width="100%" border="0"  id="tblcuenta" >
								<tr>
									<cfinclude template="CajaNegra/CajaNegraCuentas.cfm">
									<td nowrap colspan="3">
										<input type="hidden"   name="LastOneCuenta" id="LastOneCuenta" value="ListaNon" tabindex="2">
					  					<input type="button"  disabled  id="agregarCuenta" name="agregarCuenta" value="Agregar" onClick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();"  tabindex="2">
									</td> 
								</tr>
							</table>
						</td>
					</tr>
					<!--- ********************************************************************************* --->			
					<tr>
						<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
							<strong>Criterios para Filtrar</strong>
						</td>
					</tr>
					<!---********************************************************************************* --->            
					<tr>
						<td align="left" nowrap><strong>Tipo  de archivo:</strong>&nbsp;</td>
					  	<td nowrap>
						<select name="TipoArchivo"  id="TipoArchivo" tabindex="5" onChange="ACTIVAMESES()">
						  		<option value="1">Saldos acumulados</option>
						  		<option value="2">Saldos del periodo</option>
						  		<option value="3">Movimientos del mes</option>
								<option value="4">Movimientos asiento del mes</option>
								<option value="5">Movimientos asiento consecutivo del mes</option>
							</select>
					  	</td>
					</tr>
					<!---********************************************************************************* --->					
					<tr>
					  	
<!--- 						<td width="21%" align="left" nowrap><strong>Nivel a Consultar:</strong>&nbsp;</td>
					  	<td width="23%" nowrap><input  tabindex="3" type="text" name="NivelDetalle" maxlength="10" value="" size="10" ></td>
 --->						
					  	<td width="23%" align="left" nowrap><strong>A&ntilde;o:</strong>&nbsp;</td>
					  	<td width="33%"   nowrap>
							<select name="AnoInicial" tabindex="4">
								<cfloop query="rsPeriodo">
									<option value="#rsPeriodo.PERCOD#" <cfif rsParametros.CGPANO EQ rsPeriodo.PERCOD>selected</cfif>>#rsPeriodo.PERDES#</option>
								</cfloop>
							</select>
					  	</td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  	<td align="left" nowrap>
							<INPUT  tabindex="-1" 
								ONFOCUS="this.blur();" 
								NAME="ETQINI" 
								ID  ="ETQINI" 
								VALUE="Mes Inicial:" 
								size="15"  
								style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
							>							
						</td>
					  	<td nowrap >
							<select name="MesInicial"  id="MesInicial" tabindex="5">
								<cfloop query="rsMeses">
									<option value="#rsMeses.MESCOD#" <cfif rsParametros.CGPMES EQ rsMeses.MESCOD>selected</cfif>>#rsMeses.MESNOM#</option>
								</cfloop>
							</select>
					  	</td>
					  	<td align="left" nowrap>
							<INPUT  tabindex="-1" 
								ONFOCUS="this.blur();" 
								NAME="ETQFIN" 
								ID  ="ETQFIN" 
								VALUE="Mes Final:" 
								size="15"  
								style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
							>							
						</td>
					  	<td nowrap >
							<select name="MesFinal"  id="MesFinal" tabindex="5">
								<cfloop query="rsMeses">
									<option value="#rsMeses.MESCOD#" <cfif rsParametros.CGPMES EQ rsMeses.MESCOD>selected</cfif>>#rsMeses.MESNOM#</option>
								</cfloop>
							</select>
					  	</td>
					</tr>
					<!---********************************************************************************* --->

					<tr>
						<td align="left" nowrap><strong>Hora de ejecución:</strong></td>
<!--- 						<td nowrap><input tabindex="6" type="checkbox"   ONCLICK="ACTIVACAMPOS()"  value="" name="ENLINEA"></td>					
						<td>
							<INPUT  tabindex="-1" 
								ONFOCUS="this.blur();" 
								NAME="ETIQUETA" 
								ID  ="ETIQUETA" 
								VALUE="Hora de ejecución:" 
								size="15"  
								style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
							>	
						</td> --->
					  	<td nowrap>
						<select id="HORA" name="HORA" tabindex="5">
						  	<cfloop from="1" to="12" index="H">
								<cfif H LT 10>
									<option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>0#H#</option>
								<cfelse>	
								   <option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>#H#</option>
								</cfif>
							</cfloop>
						</select>
						
						<select id="MINUTOS"  name="MINUTOS" tabindex="5">
						  	<cfloop from="0" to="59" index="M">
								<cfif M LT 10>
									<option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>0#M#</option>
								<cfelse>	
								   <option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>#M#</option>
								</cfif>
							</cfloop>
						</select>
						
						<select  id="PMAM" name="PMAM" tabindex="5">
							<option value="AM" <cfif "AM" EQ T_ACTUAL>selected</cfif>>AM</option>
							<option value="PM" <cfif "PM" EQ T_ACTUAL>selected</cfif>>PM</option>
						</select>
					  	</td>

					</tr>
					<!---********************************************************************************* --->
					<tr>
						<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong>Segmentos</strong></td>
					</tr>
					<!---********************************************************************************* --->
				</table>
				<A HREF="javascript:checkALL()" style="color: ##000000; text-decoration: none; "><strong>Seleccionar todos</strong></A> 
				- 
				<A HREF="javascript:UncheckALL()" style="color: ##000000; text-decoration: none; "><strong>Limpiar todos</strong></A>
				
                <table width="100%" border="0">				
					<cfoutput>
					<cfset ubica = 0>
					<cfloop query="rsSucursal">
						<cfif ubica EQ 0>	
							<tr>
							<td nowrap><input tabindex="6" type="checkbox"  value="#rsSucursal.CGE5COD#" name="CGE5COD"></td>					
							<td align="left" nowrap><strong>#rsSucursal.CGE5COD#-#rsSucursal.CGE5DES#</strong>&nbsp;</td>
							<cfset ubica = 1>
						<cfelse>
							<td nowrap><input tabindex="6" type="checkbox"  value="#rsSucursal.CGE5COD#" name="CGE5COD"></td>					
						    <td align="left" nowrap><strong>#rsSucursal.CGE5COD#-#rsSucursal.CGE5DES#</strong>&nbsp;</td>
							</tr>
							<cfset ubica = 0>
						</cfif>
					</cfloop>
					<cfif ubica EQ 1>
						</tr>
					</cfif>
					<cfif rsSucursal.recordcount gt 0>	
					<INPUT type="hidden" style="visibility:hidden" name="CANTIDAD" value="#rsSucursal.recordcount#">
					<cfelse>
					<INPUT type="hidden" style="visibility:hidden" name="CANTIDAD" value="0">
					</cfif>
					</cfoutput>	
					<!---********************************************************************************* --->
					<input type="hidden" name="LIST_SEGMENTO" id="LIST_SEGMENTO" value="-" tabindex="8">
					<input type="hidden" name="ID_REPORTE" id="ID_REPORTE" value="3" tabindex="8">
					<input type="hidden" name="NivelDetalle" id="NivelDetalle" value="3" tabindex="8">
					<INPUT type="hidden" style="visibility:hidden" name="ORIGEN" value="R" tabindex="7">
					<INPUT type="hidden" style="visibility:hidden" name="REP" value="L" tabindex="7">
				    <INPUT type="hidden" style="visibility:hidden" name="MASCARA" value="" tabindex="7">
					<INPUT type="hidden" style="visibility:hidden" name="NivelTotal" value="" tabindex="7">
				</table>
				
				<!--- -------------------------------------- --->
				<!--- --     FIN PINTADO DE LA PANTALLA      --->
				<!--- -------------------------------------- --->
    		</td>
  		</tr>
	</table>
</form>
<input type="image" id="imgDel" src="imagenes/Borrar01_S.gif"   title="Eliminar" style="display:none;" tabindex="9">
</cfoutput>

<!--- ********************** --->
<!--- ** AREA DE SCRIPTS  ** --->
<!--- ********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");
	objform1.LIST_SEGMENTO.required = true;
	objform1.LIST_SEGMENTO.description="debe selecionar al menos un segmento";	 
	_addValidator("isSEGMENTO",marcados);
	objform1.LIST_SEGMENTO.validateSEGMENTO();
  /***************************************************************************************************/
   function checkALL(){
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			eval("document.form1.CGE5COD["+i+"].checked=true")
		}
	}
	/***************************************************************************************************/
   function UncheckALL(){
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			eval("document.form1.CGE5COD["+i+"].checked=false")
		}
	}
	/***************************************************************************************************/
	function fnNuevaCuentaContable() 
	{	
		var LvarTable = document.getElementById("tblcuenta");
		var LvarTbody = LvarTable.tBodies[0];
		var LvarTR    = document.createElement("TR");

		var Lclass 	= document.form1.LastOneCuenta;
		var p1		= concatenaCuenta();				// Contiene la Cuenta mas la máscara.	
		document.form1.CGM1IM.value = "";
		document.form1.CG13ID_1.value = "";
		document.form1.CG13ID_2.value = "";
		document.form1.CG13ID_3.value = "";
		document.form1.CG13ID_4.value = "";
		document.form1.CG13ID_5.value = "";
		document.form1.CG13ID_6.value = "";
		document.form1.CG13ID_7.value = "";
		document.form1.CG13ID_8.value = "";
		document.form1.CG13ID_9.value = "";
		document.form1.CG13ID_10.value = "";
	
		// Valida no agregar vacíos
		if (p1=="") {
			return;
		}	  
		
		// Valida no agregar repetidos
		if (existeCodigoCuenta(p1)) {
			alert('La Cuenta Contable ya fue agregada.');
			return;
		}
	  
		// Agrega Columna 0
		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CuentaidList","CU");

		// Agrega Columna 1
		sbAgregaTdText  (LvarTR, Lclass.value, p1);

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
		OcultarCeldas();		
		
	}
	/***************************************************************************************************/
	function marcados(){
		document.form1.LIST_SEGMENTO.value = "";
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			if(eval("document.form1.CGE5COD["+i+"].checked")){
				document.form1.LIST_SEGMENTO.value = document.form1.LIST_SEGMENTO.value + eval("document.form1.CGE5COD["+i+"].value") + ",";
			}		
		}
		valor = document.form1.LIST_SEGMENTO.value;
		if (valor.length > 0){
			valor = valor.substring(0,valor.length -1);
			document.form1.LIST_SEGMENTO.value = valor;
		}	
		
	}
	/***************************************************************************************************/
	function OcultarCeldas() {
		document.form1.agregarCuenta.disabled 	= true;		
		document.form1.NivelDetalle.value 	= '';
		document.form1.NivelTotal.value 	= '';
		var CG13ID_1 = document.getElementById("CG13ID_1")
		var CG13ID_2 = document.getElementById("CG13ID_2")
		var CG13ID_3 = document.getElementById("CG13ID_3")
		var CG13ID_4 = document.getElementById("CG13ID_4")
		var CG13ID_5 = document.getElementById("CG13ID_5")
		var CG13ID_6 = document.getElementById("CG13ID_6")
		var CG13ID_7 = document.getElementById("CG13ID_7")
		var CG13ID_8 = document.getElementById("CG13ID_8")
		var CG13ID_9 = document.getElementById("CG13ID_9")
		var CG13ID_10= document.getElementById("CG13ID_10")
		for (var CELDA=1; CELDA<=10; CELDA++){
			eval("CG13ID_"+CELDA+".style.visibility='hidden'")
			eval("CG13ID_"+CELDA+".value=''")
		}
	}
	/***************************************************************************************************/
	// Funcion que valida que no exista el Código en la Lista
	function existeCodigoCuenta(v) 
	{
		var LvarTable = document.getElementById("tblcuenta");
		
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
	/***************************************************************************************************/
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName,origen) 
	{
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
		}
		if (LprmValue != "") { 
			if (origen == "CU") { 
				LvarInp.value = LprmValue +"¶" + document.form1.PRIMERNIVEL.value +"¶" + document.form1.VALORPRIMERNIVEL.value +"¶" + document.form1.NivelDetalle.value +"¶" + document.form1.NivelTotal.value;
			}
			else
				LvarInp.value = LprmValue;

		}

		LvarTD.appendChild(LvarInp);
		if (LprmClass!="") { 
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}
	/***************************************************************************************************/
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
	/***************************************************************************************************/
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
	/***************************************************************************************************/
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
	/***************************************************************************************************/
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
	/***************************************************************************************************/
	/*
	function ACTIVACAMPOS(){
		var ETIQUETA  	= document.getElementById("ETIQUETA")
		var HORA  		= document.getElementById("HORA")
		var MINUTOS  	= document.getElementById("MINUTOS")
		var PMAM  		= document.getElementById("PMAM")
		if (document.form1.ENLINEA.checked){
			document.form1.target = "_blank";
			ETIQUETA.style.visibility='hidden'
			HORA.style.visibility='hidden'
			MINUTOS.style.visibility='hidden'
			PMAM.style.visibility='hidden'
		}
		else{
			document.form1.target = "_self";
			ETIQUETA.style.visibility='visible'
			HORA.style.visibility='visible'
			MINUTOS.style.visibility='visible'
			PMAM.style.visibility='visible'
		}
	}
	*/
	/***************************************************************************************************/
	function verlista() {
		top.frames['workspace'].location.href = "cmn_listaArch.cfm";
	}
	/***************************************************************************************************/
	function ACTIVAMESES(){
		var ETQINI  	= document.getElementById("ETQINI")
		var ETQFIN  	= document.getElementById("ETQFIN")
		var MesInicial  = document.getElementById("MesInicial")
		var MesFinal  	= document.getElementById("MesFinal")
		switch(document.form1.TipoArchivo.value) {
			case '1': {
					ETQFIN.style.visibility='hidden';
					MesFinal.style.visibility='hidden';
					document.form1.ETQINI.value ='Mes:';
				break;
			}
			case '2': {
					ETQFIN.style.visibility='hidden';
					MesFinal.style.visibility='hidden';
					document.form1.ETQINI.value ='Mes:';
				break;
			}
			case '3': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}
			case '4': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}		
			case '5': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}									
		}	
	}
	ACTIVAMESES()
	/***************************************************************************************************/

</script> 
