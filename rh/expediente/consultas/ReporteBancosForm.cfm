<!--- Modified with Notepad --->
<cfsilent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_Moneda"
		Default="Moneda"
		returnvariable="JSMSG_Moneda"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_TipoCambio"
		Default="Tipo de Cambio"
		returnvariable="JSMSG_TipoCambio"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_El_campo"
		Default="El campo"
		returnvariable="JSMSG_El_campo"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_es_requerido"
		Default="es requerido"
		returnvariable="JSMSG_es_requerido"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_La_lista_de_Nominas_es_requerida"
		Default="La lista de Nóminas es requerida"
		returnvariable="JSMSG_La_lista_de_Nominas_es_requerida"/> 
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mcodigo
			, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	</cfquery>
	<cfquery name="rsMonLoc" datasource="#session.dsn#">
		select Mcodigo
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
	<cfquery name="rsTiposNominas" datasource="#session.dsn#">
		select Tcodigo, Tdescripcion 
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
</cfsilent>
<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="#Gvar_action#" style="margin:0;">
	<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
	<input type="hidden" name="CPidlist1" id="CPidlist1" value="" tabindex="1">
	<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>
			<td nowrap align="right"> <strong><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
			<td>
				<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true">
			</td>
			<td>
				<input type="button" name="agregarCalendario1" onClick="javascript:if (window.fnNuevoCalendario) fnNuevoCalendario();" value="+" tabindex="1">
			</td>
		</tr>
		<tr>
			<td colspan = "3">
				<table id="tblcalendario1" width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tbody>
					</tbody>
				</table>
			</td>
		</tr>
		
		<cfif FindNoCase('SA',Gvar_action) GT 0>
			<tr>
				<td nowrap align="right"> <strong><cf_translate  key="LB_Moneda">Moneda</cf_translate> :&nbsp;</strong></td>
				<td>
					<select name="Mcodigo" onChange="javascript: setTipoCambio();">
						<cfloop query="rsMonedas">
							<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo eq rsMonLoc.Mcodigo>selected</cfif>>#rsMonedas.Mnombre#</option>
						</cfloop>
					</select >
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap align="right"> <strong><cf_translate  key="LB_TipoCambio">Tipo de Cambio</cf_translate> :&nbsp;</strong></td>
				<td><cf_inputNumber name="TipoCambio" decimales="2" tabindex="1" value="1.00"></td>
				<td>&nbsp;</td>
			</tr>
		</cfif>
		<tr><td align="center" colspan="3">&nbsp;</td></tr>
		<tr>
			<td align="right"><strong><cf_translate  key="LB_Exportar">Exportar</cf_translate> :&nbsp;</strong></td>
			<td><table cellpadding="0" cellspacing="0" border="0" width="100%"><tr>
					<td><input name="chkExportar" type="checkbox" onchange="javascript: showExportadores(this);"/></td>
					<td id="TDExp" style="display:none">
						 <cfquery name="rsFORM" datasource="#Session.DSN#">
							  select a.Bid, a.EIid, RHEdescripcion, b.Bdescripcion as Banco, a.ts_rversion
								from RHExportaciones a, Bancos b
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  	and a.Bid = b.Bid
								<!---and a.EIid = 2192--->	<!---Se quema el exportador que se va a utilizar--->
							  order by Banco
						  </cfquery>
						 <select name="EIidBid" id="EIidBid">
							<cfloop query="rsFORM">
							<option  value="#rsFORM.EIid#,#rsFORM.Bid#" <cfif isdefined('form.EIidBid') and form.EIidBid EQ '#rsFORM.EIid#,#rsFORM.Bid#'>selected="selected"</cfif> >#rsFORM.Banco# - #rsFORM.RHEdescripcion#</option>
							</cfloop>
						 </select>			
					</td></tr>
				</table>
			</td>
			
		</tr>
		<tr id="trBTNgen">
			<td align="center" colspan="3">
				<cf_botones values="Generar" tabindex="1">
			</td>
		</tr>
		<tr id="trBTNexp" style="display:none">
			<td align="center" colspan="3">
				<cf_botones values="Exportar" tabindex="1" functions="irAExportar()">
			</td>
		</tr>
	</table>
</form>
<script language="javascript" type="text/javascript">
	
	function irAExportar(){
		document.form1.action="ReporteBancosExportar.cfm";
	}
	
	function showExportadores(chk){
		if(chk.checked) {
			document.getElementById("TDExp").style.display = '';
			document.getElementById("trBTNexp").style.display = '';
			document.getElementById("trBTNgen").style.display = 'none';
		}
		else{
			document.getElementById("TDExp").style.display = 'none';
			document.getElementById("trBTNexp").style.display = 'none';
			document.getElementById("trBTNgen").style.display = '';
		}
	}
	
	var vnContadorListas1 = 0;
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
	
	function fnTdValue(LprmNode){
	  var LvarNode = LprmNode;
	  while (LvarNode.hasChildNodes()){
		LvarNode = LvarNode.firstChild;
		if (document.all == null){
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
	
	function existeCalendario(v){
		var LvarTable = document.getElementById("tblcalendario1");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v){
				return true;
			}
		}
		return false;
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
	
	//Función para eliminar TRs
	function sbEliminarTR1(e){
	  vnContadorListas1 = vnContadorListas1 - 1;
	  var LvarTR;
	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
	  LvarTR.parentNode.removeChild(LvarTR);
	}

	function getTdescripcion(Tcodigo){
		<cfloop query="rsTiposNominas">
		if (Tcodigo=="#trim(Tcodigo)#") return "#Tdescripcion#";
		</cfloop>
		return "";
	}
		
	function fnNuevoCalendario(){
	  //verifica que exista una nómina seleccionada
	  if (document.form1.Tcodigo1.value == '' && document.form1.CPid1.value == ''){
	  	return;
	  }
	  
		var LvarTable = document.getElementById("tblcalendario1");
		var LvarTbody = LvarTable.tBodies[0];
		var LvarTR    = document.createElement("TR");
		var Lclass 	= document.form1.LastOneCalendario;
 		var p1 = document.form1.CPid1.value.toString(); //id del calendario
 		var p2 = getTdescripcion(document.form1.Tcodigo1.value.toString()); //tipo de nomina
		var p3 = document.form1.CPcodigo1.value.toString(); //codigo de nomina
		var p4 = document.form1.CPdescripcion1.value.toString(); //descripcion de nomina
		var p5 = 1;
		var p6 = "CPidlist1";
		vnContadorListas1 = vnContadorListas1 + 1;
		document.form1.Tcodigo1.value = '';
		document.form1.CPid1.value = '';
		document.form1.CPcodigo1.value = '';
		document.form1.CPdescripcion1.value = '';

	  // Valida no agregar vacíos
	  if (p1=="") return;	  
	  // Valida no agregar repetidos
	  if (existeCalendario(p1,p5)) {alert('Este Calendario ya fue agregado.');return;}
  	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", p6);
	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  // Agrega Columna 2
	  sbAgregaTdText (LvarTR, Lclass.value, p3);
	  // Agrega Columna 3
	  sbAgregaTdText  (LvarTR, Lclass.value, p4);
	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (p5==1) {
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR1);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR1, false);
	  } else {
		  if (document.all)
			GvarNewTD.attachEvent ("onclick", sbEliminarTR2);
		  else
			GvarNewTD.addEventListener ("click", sbEliminarTR2, false);
	  }
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
	/*función que actualiza el tipo de cambio y lo habilita/desahbilita*/
	<cfif FindNoCase('SA',Gvar_action) GT 0>
		function setTipoCambio(){
			document.form1.TipoCambio.value='1.00';
			document.form1.TipoCambio.disabled=(document.form1.Mcodigo.value==#rsMonLoc.Mcodigo#);
		}
		setTipoCambio();
	</cfif>
	/*validar el formulario 1*/
	function _validateForm1(){
		if (!objForm._allowSubmitOnError) {
			if (vnContadorListas1<=0) objForm.CPidlist1.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
			<cfif FindNoCase('SA',Gvar_action) GT 0>
				if (objForm.Mcodigo.getValue()=='') objForm.Mcodigo.throwError("#JSMSG_El_campo# #JSMSG_Moneda# #JSMSG_es_requerido#");
				if (objForm.TipoCambio.getValue()=='') objForm.TipoCambio.throwError("#JSMSG_El_campo# #JSMSG_TipoCambio# #JSMSG_es_requerido#");
			</cfif>
		}
	}
	/*funcion antes de hacer submit*/
	function _submitForm1(){
		<cfif FindNoCase('SA',Gvar_action) GT 0>
		document.form1.TipoCambio.disabled=false;
		</cfif>
	}
</script>
</cfoutput>
<cf_qforms onValidate="_validateForm1" onSubmit="_submitForm1">