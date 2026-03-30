<cfquery name="rsParametros" datasource="#session.Conta.dsn#">
	select   CGPMES ,CGPANO  from CGX001  
</cfquery>

<cfquery name="rsSucursal" datasource="#session.Conta.dsn#">
	select A.CGE5COD  as CGE5COD, CGE5DES as CGE5DES
	from CGE005 A, CGE000 B
	WHERE A.CGE1COD = B.CGE1COD
	union
	select cod_suc as Codigo, CGE5DES  as Descripcion
	from anex_sucursal
	order by 1 	
</cfquery>

<cfquery name="rsPeriodo" datasource="#session.Conta.dsn#">
	select PERCOD,PERDES   from CGX051
</cfquery>

<cfquery name="rsMeses" datasource="#session.Conta.dsn#">
	select MESCOD,MESNOM   from CGX050
</cfquery>

<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<cfoutput>
<form name="form1" method="post" action="ImprimeReporte.cfm" onSubmit="">
	<table width="100%" border="0">
  		<tr>
    		<td>
				<!--- ---------------------------------------- --->
				<!--- --     INICIA PINTADO DE LA PANTALLA     --->
				<!--- ---------------------------------------- --->
			  	<table width="100%" border="0">
			  		<tr>
						<td align="left" colspan="4">
							<input type="submit" name="Reporte" value="Consultar" onClick="" tabindex="10">
							<input type="reset" name="Limpiar"  onClick="javascript: OcultarCeldas()"value="Limpiar" tabindex="10">
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
					  	<td align="left" nowrap><strong>Nivel Detalle:</strong>&nbsp;</td>
					  	<td nowrap><input  tabindex="3" type="text" name="NivelDetalle" maxlength="10" value="" size="10" ></td>
					  	<td align="left" nowrap><strong>Nivel Total:</strong>&nbsp;</td>
					  	<td nowrap><input  tabindex="3" type="text" name="NivelTotal" maxlength="10" value="" size="10" ></td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  	<td align="left" nowrap><strong>A&ntilde;o:</strong>&nbsp;</td>
					  	<td  colspan="3" nowrap>
							<select name="AnoInicial" tabindex="4">
								<cfloop query="rsPeriodo">
									<option value="#rsPeriodo.PERCOD#" <cfif rsParametros.CGPANO EQ rsPeriodo.PERCOD>selected</cfif>>#rsPeriodo.PERDES#</option>
								</cfloop>
							</select>
					  	</td>
					  	
<!--- 						<td align="left" nowrap><strong>A&ntilde;o Final:</strong>&nbsp;</td>
					  	<td nowrap>
							<select name="AnoFinal" tabindex="4">
								<cfloop query="rsPeriodo">
									<option value="#rsPeriodo.PERCOD#" <cfif rsParametros.CGPANO EQ rsPeriodo.PERCOD>selected</cfif>>#rsPeriodo.PERDES#</option>
								</cfloop>
							</select>
					  	</td> --->
					</tr>
					<!---********************************************************************************* --->
					<tr>
					  	<td align="left" nowrap><strong>Mes Inicial:</strong>&nbsp;</td>
					  	<td nowrap >
							<select name="MesInicial" tabindex="5">
								<cfloop query="rsMeses">
									<option value="#rsMeses.MESCOD#" <cfif rsParametros.CGPMES EQ rsMeses.MESCOD>selected</cfif>>#rsMeses.MESNOM#</option>
								</cfloop>
							</select>
					  	</td>
					  	<td align="left" nowrap><strong>Mes Final:</strong>&nbsp;</td>
					  	<td nowrap >
							<select name="MesFinal" tabindex="5">
								<cfloop query="rsMeses">
									<option value="#rsMeses.MESCOD#" <cfif rsParametros.CGPMES EQ rsMeses.MESCOD>selected</cfif>>#rsMeses.MESNOM#</option>
								</cfloop>
							</select>
					  	</td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
						<td align="left" nowrap><strong>Tipo Impresi&oacute;n:</strong>&nbsp;</td>
					  	<td nowrap>
							<select name="TipoFormato" tabindex="6">
						  		<option value="4">Resumido</option>
						  		<option value="2">Detallado por Mes</option>
						  		<option value="3">Detallado por Asiento</option>
								<option value="1">Detallado por Consecutivo</option>
							</select>
					  	</td>
					  	<td align="left" nowrap><strong>Segmento:</strong>&nbsp;</td>
					  	<td nowrap>
							<select name="Segmento" tabindex="6">
						  		<option value="T">Todas</option>
						  		<cfloop query="rsSucursal">
									<option value="#rsSucursal.CGE5COD#" >#rsSucursal.CGE5COD#-#rsSucursal.CGE5DES#</option>
						  		</cfloop>
							</select>
					  </td>
					</tr>
					<tr>
					  	<td align="left" nowrap><strong>Incluir Segmento:</strong>&nbsp;</td>
						<td nowrap><input tabindex="7" type="checkbox" name="ID_incsucursal"></td>
					  	<td align="left" nowrap><strong>Saldo Total en Resumen:</strong>&nbsp;</td>
						<td nowrap><input tabindex="7" type="checkbox" name="ID_TotalCtaRes"></td>
					</tr

					><!---********************************************************************************* --->
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td colspan="4" align="left" nowrap>
						<strong>No incluir cuentas con movimientos mensuales en cero:</strong>&nbsp;
						<input tabindex="8" type="checkbox" name="ID_NoIncluir">
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>					
					<tr>
						<td align="center" colspan="4" nowrap bgcolor="##CCCCCC">
							<strong>Listas de Asientos Contables</strong>
						</td>
					</tr>
					<!---********************************************************************************* --->
					<tr>	
						<td  colspan="4">		
							<table width="100%" border="0"  id="tblasiento">
								<tr>
									<td width="16%" nowrap><strong>Asiento contable:</strong></td>
									<td width="56%" nowrap>	
										<cf_cjcConlis 	
											size		="30"  
											tabindex    ="7"
											name 		="CG5CON" 
											desc 		="CG5DES" 
											cjcConlisT 	="cmn_traeAsiento"
											frame		="CG5CON_FRM"
										>			
									</td>
									<td width="28%" align="left" nowrap>
										<input type="hidden" name="LastOneAsiento" id="LastOneAsiento" value="ListaNon" tabindex="7">
										<input type="button" name="agregarAsiento" value="+" onClick="javascript:if (window.fnNuevoAsientoContable) fnNuevoAsientoContable();"  tabindex="7">
									</td>
								</tr>	
							</table>
						</td>
					</tr>
					<!---********************************************************************************* --->
					<input type="hidden" name="ID_REPORTE" id="ID_REPORTE" value="3" tabindex="8">
					<INPUT type="hidden" style="visibility:hidden" name="ORIGEN" value="R" tabindex="7">
				    <INPUT type="hidden" style="visibility:hidden" name="MASCARA" value="" tabindex="7">
				</table>
				
				<!--- -------------------------------------- --->
				<!--- --     FIN PINTADO DE LA PANTALLA      --->
				<!--- -------------------------------------- --->
    		</td>
  		</tr>
	</table>
</form>
<input type="image" id="imgDel"src="../../imagenes/Borrar01_S.gif"   title="Eliminar" style="display:none;" tabindex="9">
</cfoutput>

<!--- ********************** --->
<!--- ** AREA DE SCRIPTS  ** --->
<!--- ********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");

	//objform1.CGM1IM.required = true;
	//objform1.CGM1IM.description="Cuenta mayor";	 
	//objform1.NivelDetalle.required = true;
	//objform1.NivelDetalle.description="Nivel Detalle";	 
	//objform1.NivelTotal.required = true;
	//objform1.NivelTotal.description="Nivel Total";	 

	function Total_valida(){
		var TOTAL = new Number(this.value)	
		var DETALLE = new Number(document.form1.NivelDetalle.value)	
		if ( TOTAL > DETALLE){
			this.error = "El nivel total debe ser menor o igual a nivel detalle";
		}		
	}

	_addValidator("isTotal", Total_valida);
	objform1.NivelTotal.validateTotal();

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
		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "AsieContidList","AS");
	  	
		// Agrega Columna 1
		sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);
		// Agrega Evento de borrado en Columna 2
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "left");
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
	// Funcion que valida que no exista la Cuenta en la Lista
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
