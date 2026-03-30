<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoComprobante" default="Tipo de Comprobante" returnvariable="LB_TipoComprobante" xmlfile="formComprobanteFiscalPoliza.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_CFDI" default="CFDI" returnvariable="RBTN_CFDI" xmlfile="formComprobanteFiscalPoliza.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_EXT" default="Extranjero" returnvariable="RBTN_Ext" xmlfile="formComprobanteFiscalPoliza.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CargaMasiva" default="Carga Masiva de CFDIs" returnvariable="LB_CargaMasiva" xmlfile="formComprobanteFiscalPoliza.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_CBB" default="Otro Nacional" returnvariable="RBTN_CBB" xmlfile="formComprobanteFiscal.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TimbreFiscal" default="Timbre Fiscal UUID: " returnvariable="LB_TimbreFiscal" xmlfile="formComprobanteFiscalPoliza.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Folio" default="Folio: " returnvariable="LB_Folio" xmlfile="formComprobanteFiscalPoliza.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Serie" default="Serie:" returnvariable="LB_Serie" xmlfile="formComprobanteFiscalPoliza.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ArchivoXML" default="Archivo XML CFDI " returnvariable="LB_ArchivoXML" xmlfile="formComprobanteFiscalPoliza.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ArchivoSoporte" default="Archivo Soporte"
returnvariable="LB_ArchivoSoporte" xmlfile="formComprobanteFiscalPoliza.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Guardar" default="Guardar" returnvariable="BTN_Guardar"
xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Cambiar" default="Actualizar" returnvariable="BTN_Cambiar"
xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Eliminar" default="Eliminar" returnvariable="BTN_Eliminar"
xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Validar" default="Validar y Guardar" returnvariable="BTN_Validar" xmlfile="/sif/generales.xml"/>

<cfif isdefined('url.IDContable') and LEN(TRIM(url.IDContable))>
	<cfset Form.IDContable = url.IDContable>
</cfif>
<cfif isdefined('url.Dlinea') and LEN(TRIM(url.Dlinea))>
	<cfset Form.Dlinea = url.Dlinea>
</cfif>
<cfif isdefined('url.Dlinea') and LEN(TRIM(url.Dlinea))>
	<cfset Form.Dlinea = url.Dlinea>
</cfif>

<cfset modo="ALTA">
<cfquery name="getDoc"  datasource="#session.dsn#">
	select * from CERepositorio
    where Ecodigo  = #session.Ecodigo#
    	and IdContable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDContable#">
		and linea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dlinea#">
</cfquery>

<cfif getDoc.RecordCount GT 0>
	<cfset modo = "CAMBIO">
	<cfset LobjRepo = createObject( "component","sif.ce.Componentes.RepositorioCFDIs")>
	<cfset axml = LobjRepo.getInfoXML(#getDoc.IdRep#)>
</cfif>

<cfquery name="rsValMON" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset valMON = "N">
<cfif #rsValMON.RecordCount#  neq 0>
	<cfset valMON = rsValMON.Pvalor>
</cfif>


<!--- VALIDACION DE PARAMETRO VALIDA XML PROVEEDORES --->
<cfquery name="rsValidaXML"  datasource="#session.dsn#">
	SELECT * FROM Parametros WHERE Pcodigo = 200085 AND Mcodigo = 'CE' AND Pvalor = 'S' AND Ecodigo = #Session.Ecodigo#
</cfquery>


<html>
<head>
<title>Informaci&oacute;n CFDI</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>

<script>
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
</head>
<body>
<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">
				<strong>
					#LB_CargaMasiva#:
				</strong>
			</td>
			<td ><cfoutput>
				<input name="chkCargaMasiva" type="checkbox" <cfif isdefined('url.masiva')> checked  disabled</cfif>
					tabindex="1" onclick="toggleit('trXML2,trlXML')"></cfoutput>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr id="trlXML" style="display:<cfif isdefined('url.masiva')>none</cfif>">
			<td align="center" colspan="2">
				<form name="form1" id="form1" action="../../ce/operacion/SQLComprobanteFiscalPoliza.cfm" method="post" enctype="multipart/form-data" onsubmit="return validaForm()">
					<table width="100%" border="0" cellpadding="0" cellspacing="2">
						<tr><td>&nbsp;</td></tr>
						<tr><td align="right"><strong>#LB_TipoComprobante#:</strong></td>
							<td >
                					<input name="optTipoComprobante" id="1" type="radio" value="1" <cfif modo EQ "ALTA">checked="checked"<cfelse><cfif getDoc.TipoComprobante EQ "1">checked="checked"</cfif></cfif>
										tabindex="1" onchange="javascript:toggle_vit(this.value);"> <strong>#RBTN_CFDI# &nbsp;&nbsp;</strong>
					                <input name="optTipoComprobante" id="2" type="radio" value="2" <cfif getDoc.TipoComprobante EQ "2">checked="checked"</cfif>
										tabindex="2" onchange="javascript:toggle_vit(this.value);"> <strong> #RBTN_EXT#</strong>
							<!--- <input name="optTipoComprobante" id="3" type="radio" value="3" <cfif getDoc.TipoComprobante EQ "3">checked="checked"</cfif>
										tabindex="3" onchange="javascript:toggle_vit(this.value);"> <strong> #RBTN_CBB#</strong> --->
							</td>
						</tr>
        					<tr><td>&nbsp;</td></tr>
						<!---Campos ocultos asignados del metodo validaXmlAjax  --->
						<input type="hidden" name="socioNegocioId" id="socioNegocioId" value="">
						<input type="hidden" name="rfcEmisor" id="rfcEmisor" value="">
						<!---Campos ocultos  --->
						<input type="hidden" name="montoT" value=""><!--- Obtenemos el MontoTotal de infCFDIAjax --->
		 				<input type="hidden" name="tipoCambio" value=""><!--- Obtenemos el TipoCambio de infCFDIAjax --->
		 				<input type="hidden" name="Mcodigo" value=""><!--- Obtenemos el Mcodigo de infCFDIAjax --->
						<input type="hidden" name="AFnombreImagen" value="">
						<input type="hidden" name="AFnombre" value="">
						<input type="hidden" name="AFnombreImagenSoporte" value="">
						<input type="hidden" name="AFnombreSoporte" value="">
						<input type="hidden" name="modo" value="#modo#">
						<input type="hidden" name="IDContable" value="#Form.IDContable#">
						<input type="hidden" name="Dlinea" value="#Form.Dlinea#">
						<tr id="trCFDI" style="display:">
				          <td align="right"><strong><label id="lbltipAddedComment">#LB_TimbreFiscal#</label></strong></td>
				          <td >
				          	<input name="TimbreFiscal" tabindex="1" onFocus="javascript:this.select();" type="text"
								   value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.timbre)#</cfoutput></cfif>" size="40" maxlength="37" <cfif modo NEQ "ALTA" and getDoc.TipoComprobante EQ 1 > readonly</cfif>>
							<cfif getDoc.xmlTimbrado NEQ "">
								<cfset archXML = XmlParse("#getDoc.xmlTimbrado#")>
								<cfif isDefined("archXML.Comprobante.Emisor.XmlAttributes.rfc") AND LEN(TRIM(archXML.Comprobante.Emisor.XmlAttributes.rfc))>
									<cfset rfcEmisor = "#Trim(archXML.Comprobante.Emisor.XmlAttributes.rfc)#">
								</cfif>
							</cfif>
			           	  </td>
					   </tr>
					   <tr id="trCBBF" style="display:none">
						  <td align="right"><strong><label id="lbltipAddedComment">#LB_Folio#</label></strong></td>
					        <td ><input name="tFolio" tabindex="1" onFocus="javascript:this.select();" type="text"
							   value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.timbre)#</cfoutput></cfif>" size="40" maxlength="37"<cfif modo NEQ "ALTA" and getDoc.TipoComprobante EQ 1 > readonly</cfif>>
					        </td>
					    </tr>
						<tr id="trCBBS" style="display:none">
					        <td align="right"><strong><label id="lbltipAddedComment">#LB_Serie#</label></strong></td>
					        <td ><input name="tSerie" tabindex="1" onFocus="javascript:this.select();" type="text"
							   value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.Serie)#</cfoutput></cfif>" size="40" maxlength="37" <cfif modo NEQ "ALTA" and getDoc.Serie EQ 1 > readonly</cfif>>
				        </td>
						</tr>
						<cfif isdefined('getDoc.archivoXML') and len(trim(toString(getDoc.archivoXML))) GT 0>
							<tr id="trXML" style="display:">
								<td align="right">#LB_ArchivoXML#:&nbsp;</td>
								<td align="left"><strong>#getDoc.timbre#.xml</strong></td>
							</tr>
						<cfelse>
							<tr id="trXML" style="display:">
								<td align="right">#LB_ArchivoXML#:&nbsp;</td>
								<td align="left"><input type="file" name="AFimagen" id="AFimagen" value="" onChange="javascript:extraeNombre(this.value); funcUploadXML(); funcValG(); "  accept=".xml" size="40" tabindex="100">

							</td>
							</tr>
						</cfif>
						<cfif isdefined('getDoc.nombreArchivo') and getDoc.nombreArchivo neq ''>
							<tr id="trXMLS" style="display:">
								<td align="right">#LB_ArchivoSoporte#:&nbsp;</td>
								<input type="hidden" name="NomArchSoporte" id="NomArchSoporte" value="#getDoc.nombreArchivo#" />
								<input type="hidden" name="ExtArchSoporte" id="ExtArchSoporte" value="#getDoc.extension#" />
								<td align="left"><strong>#getDoc.nombreArchivo#.#getDoc.extension#</strong></td>
							</tr>
						<cfelse>
							<tr id="trXMLS" style="display:">
								<td align="right">#LB_ArchivoSoporte#:&nbsp;</td>
								<td align="left"><input type="file" name="AFimagenPDF" value="" onChange="javascript:extraeNombreSoporte(this.value);" size="40" tabindex="100"></td>
							</tr>
						</cfif>
						<cfif valMON EQ "N">
  		 <!--- <tr id="trComp" style="display:">
		 	<td colspan="2" id="tdMonto">
				<table width="100%" border="0" cellpadding="0" cellspacing="2">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="35%">Moneda:</td>
                		<td align="left">
							<cfif modo EQ "ALTA">
								<cf_sifmonedas frame="frame2" tabindex="1" Todas="S" value="-1" onchange="funcChMoneda(this.value)">
							<cfelse>
								<cfset vMcodigo = "-1">
								<cfif getDoc.Mcodigo NEQ "">
									<cfset vMcodigo = getDoc.Mcodigo>
								</cfif>
								<cf_sifmonedas value="#vMcodigo#" tabindex="1" Todas="S" onchange="funcChMoneda(this.value)">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right">Monto Total:</td>
                		<td align="left">
							<input name="montoT" tabindex="1" type="text" style="text-align:right"
							onfocus="javascript:document.form1.montoT.select();" onchange="javascript:fm(this,2);"
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(getDoc.total,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
						</td>
					</tr>
					<tr>
						<td align="right">Tipo Cambio:</td>
                		<td align="left">
							<input name="tipoCambio" tabindex="1" type="text" style="text-align:right"
							onfocus="javascript:document.form1.tipoCambio.select();" onchange="javascript:fm(this,2);"
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(getDoc.TipoCambio,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
						</td>
					</tr>
				</table>
			</td>
         </tr> --->
		</cfif>
         <tr><td id="tdResult">&nbsp;</td></tr>
						<tr align="center">
							<td colspan="2">
								<cfif modo EQ "ALTA">
									<span id="Hg"><!--- Default --->
										<input name="GuardarComprobante" class="btnGuardar"  tabindex="10" type="submit" value="#BTN_Guardar#" />
									</span>
									<span id="Hv" style="display:none"><!--- Si seleccionamos un archivo del input--->
									<cfif #rsValidaXML.RecordCount#  neq 0>
										<input name="GuardarComprobante" class="btnAplicar" onclick="validacionXML()" tabindex="10" type="button" value="#BTN_Validar#" />
									<cfelse>
										<input name="GuardarComprobante" class="btnGuardar"  tabindex="10" type="submit" value="#BTN_Guardar#" />
									</cfif>
									</span>
								<cfelse>
									<span id="inputhidden2"><!--- Default --->
										<input name="CambiarComprobante" class="btnGuardar"  tabindex="11" type="submit" value="#BTN_Cambiar#" />
									</span>
									<span id="inputhidden" style="display:none"><!--- Si seleccionamos un archivo del input--->
									<cfif #rsValidaXML.RecordCount#  neq 0>
										<input name="CambiarComprobante" class="btnAplicar" onclick="validacionXML()"  tabindex="11" type="button" value="#BTN_Validar#" />
									<cfelse>
										<input name="CambiarComprobante" class="btnGuardar"  tabindex="11" type="submit" value="#BTN_Cambiar#" />
									</cfif>
									</span>
									<cfif getDoc.numDocumento EQ "" and getDoc.IdDocumento EQ "">
										<input name="EliminarComprobante" class="btnEliminar" onclick="return confirmDel();" tabindex="12" type="submit" value="#BTN_Eliminar#" />
									</cfif>
								</cfif>
							</td>
						</tr>

						<tr>
							<td colspan="2">
								<iframe width="100%" height="60px" id="upload_target" name="upload_target" src="" frameBorder="0"></iframe>
							</td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
		<tr id="trXML2" style="display:<cfif isdefined('url.masiva')><cfelse>none</cfif>">
			<td align="center" colspan="2">
				<form id="file-form" action="formComprobanteFiscalPoliza.cfm" method="POST" onsubmit="return funcUpload()">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="right">
								#LB_ArchivoXML#:&nbsp;
							</td>
							<td >
								<input type="file" id="file-select" name="photos[]" multiple/>
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;
							</td>
						</tr>
						<input type="hidden" name="IDContable" id="IDContable" value="#Form.IDContable#">
						<input type="hidden" name="Dlinea" id="Dlinea" value="#Form.Dlinea#">
						<tr>
							<td align="center">
								<button type="submit" id="upload-button">Guardar</button>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<div id="labelResult">
								</div>
							</td>
						</tr>
				  	</table>
				</form>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<div id="labelResult">
				</div>
			</td>
		</tr>
		<tr>
         	<td colspan="2" id="tdResultValidateCFDI">&nbsp;</td>
         </tr>
	</table>
</cfoutput>

<cfquery name="rsMcodigo" datasource="#Session.DSN#">
	SELECT  Mcodigo
	FROM    Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cf_qforms form="form1" objForm="objForm">
<script language="javascript1.2" type="text/javascript">
	function confirmDel() {
       if (confirm('Se va a eliminar el CFDI de todos los documentos relacionados, Desea continuar?')) {
           return true;
       } else {
           return false;
       }
    }

	<cfoutput>
	function funcChMoneda(value){
		if(#rsMcodigo.Mcodigo# == value){
			document.forms["form1"]["tipoCambio"].value = "1.00";
			document.forms["form1"]["tipoCambio"].setAttributeNode(document.createAttribute("readonly"));
		}else{
			document.forms["form1"]["tipoCambio"].value = "0.00";
			document.forms["form1"]["tipoCambio"].removeAttribute("readonly");
		}
	}
	</cfoutput>

	function validacionXML(){
		//var varCFDI = document.forms["form1"]["optTipoComprobante"].value;
		var varCFDI = document.getElementById("1").checked

		if(varCFDI){
			validaXmlAjax();
		}else{
			document.form1.submit();
		}
	}
	<!--- Esta funcion se encarga de validar el comprobante CFDI VS el WS del SAT  --->
	function validaXmlAjax()
	{
		// DECLARACION DE VARIABLES Y RECUPERACION DE VALORES
		<!--- 	var form =                     document.forms["form1"];
		var timbreFiscal =             document.forms["form1"]["TimbreFiscal"];
		var montoTotal =               document.forms["form1"]["montoT"];--->
		var tdResultValidateCFDI =     document.getElementById('tdResultValidateCFDI');
		var fileSelect =               "";
		var files =                    "";
		var socioNegocioId =           "";
		var xmlTimbrado =              "";
		var rfcEmisor =                "";

		<cfoutput>
			<cfif isDefined("rfcEmisor") AND #rfcEmisor# NEQ "">
				rfcEmisor = '#rfcEmisor#'
			</cfif>
		</cfoutput>

		if (typeof(document.forms["form1"]["AFimagen"]) === "undefined") {
			<!---<cfoutput>
				<cfif #getDoc.RecordCount#  NEQ 0 AND #getDoc.xmlTimbrado# NEQ "">
					xmlTimbrado = '#getDoc.xmlTimbrado#'
				</cfif>
			</cfoutput>--->
		}else{
			fileSelect = document.forms["form1"]["AFimagen"];
			files = fileSelect.files;
		}

		// Validacion para paso de socio de negocio ID
		<cfoutput>
		<cfif isDefined("Form.SNcodigo")>
			socioNegocioId = "#Form.SNcodigo#"
		</cfif>
		</cfoutput>

		// Paso de parametros a formData
		if(socioNegocioId != ""){
			<!--- formData = formData + '&socioNegocioId=' + socioNegocioId --->
			document.forms["form1"]["socioNegocioId"].value = socioNegocioId;
		}
		if(rfcEmisor != ""){
			<!--- formData = formData + '&rfcEmisor=' + rfcEmisor; --->
			document.forms["form1"]["rfcEmisor"].value = rfcEmisor;
		}

		if(fileSelect != ""){	<!--- Valida que se haga seleccionado un archivo --->
			var mForm = document.getElementById('form1');
			var att = document.createAttribute("target");
			att.value = "upload_target";
			mForm.setAttributeNode(att);
			<!--- Ejecuta la funcion de validar con el ws --->
			document.getElementById('form1').action = '/cfmx/sif/ce/operacion/validaCFDIAjax.cfm';
			document.getElementById('form1').submit();
			document.getElementById('form1').removeAttribute('target');
			document.getElementById('form1').action = 'SQLComprobanteFiscalPoliza.cfm';
		}

	}


	<!--- Metodo llamado de la pag validaCFDIAjax --->
	function msgws(){
		var ifrm = document.getElementById('upload_target');
		var win = ifrm.contentWindow; // reference to iframe's window
		var doc = ifrm.contentDocument? ifrm.contentDocument: ifrm.contentWindow.document;

		<!--- Obtengo los mensajes del ws --->
		var resCodigoEstado = doc.getElementById('resCodigoEstado').value;
		var estado = doc.getElementById('resEstado').value;
			if(estado === "No Encontrado"){
				// COMO NO SE ENCUENTRA, ENTONCES SE NOTIFICA AL USUARIO Y NO SE GUARDA
				alert(resCodigoEstado)
			}else if(estado === "Vigente"){
				// SI ES VIGENTE, ES CORRECTO POR LO TANTO SI LO GUARDA/MODIFICA
				<!--- alert(estado); --->
				document.form1.submit();
			}
	}


	function confirmDel() {
       if (confirm('Se va a eliminar el CFDI de todos los documentos relacionados, Desea continuar?')) {
           return true;
       } else {
           return false;
       }
    }

	function validaForm()
	{
		var rbt = document.forms["form1"]["optTipoComprobante"].value;
		var msg = "";

		switch (rbt) {
		    case "1":
		      	var tf = document.forms["form1"]["TimbreFiscal"].value;
		      	var fxml = document.forms["form1"]["AFimagen"].value;
			    if ((tf==null || tf=="") && (fxml==null || fxml=="") ) {
			    	msg = msg + " -El campo Timbre Fiscal es requerido \n";
			    }
		    	break;
		    case "2":
				var tf = document.forms["form1"]["TimbreFiscal"].value;
		      	if (tf==null || tf=="") {
			    	msg = msg + " -El campo Folio es requerido \n";
			    }
		    	break;
		    case "3":
				var tf = document.forms["form1"]["tFolio"].value;
				var ts = document.forms["form1"]["tSerie"].value;
		      	if (tf==null || tf=="") {
			    	msg = msg + " -El campo Folio es requerido \n";
			    }
			    if (ts==null || ts=="") {
			    	msg = msg + " -El campo Serie es requerido \n";
			    }
		    	break;
		}

	<cfoutput>
	<cfif valMON EQ "N" and modo EQ "ALTA">
		var vtrComp = document.getElementById("trComp");
		if(vtrComp !=null && vtrComp.style.display == ''){
			var mt = document.forms["form1"]["montoT"].value;
			var tc = document.forms["form1"]["tipoCambio"].value;
			var mon = document.forms["form1"]["Mcodigo"].value;
			if (mt==null || mt=="" || Number(mt) <= 0) {
		    	msg = msg + " -El campo Monto Total debe ser un numero mayor que 0 \n";
		    }
		    if (tc==null || tc=="" || Number(tc) <= 0) {
		    	<!--- msg = msg + " -El campo Tipo Cambio debe ser un numero mayor que 0 \n"; --->
		    	tc.value = 1.00;
		    }
		    <!--- var fxml = document.forms["form1"]["AFimagen"].value;
		    if (fxml==null || fxml=="") {
			    if (mon==null || mon=="" || Number(mon) < 1) {
			    	msg = msg + " -El campo Moneda es requerido \n";
			    }
	    	} --->
		}
	</cfif>
		if (msg=="") {
			<cfif valMON EQ "N" and modo EQ "ALTA">
			if (validBrowser()){
			document.forms["form1"]["Mcodigo"].removeAttribute("disabled");
			}
			</cfif>
			return true;
		} else {
			<cfif valMON EQ "N" and modo EQ "ALTA">
			if (validBrowser()){
			document.forms["form1"]["Mcodigo"].setAttributeNode(document.createAttribute("disabled"));
			}
			</cfif>
			alert("Se encontraron los siguientes errores: \n\n" + msg);
			return false;
		}
	</cfoutput>
	}

	function validBrowser(){
		if(navigator.appName.indexOf("Internet Explorer")!=-1){     //yeah, he's using IE
		    var badBrowser=(
		        navigator.appVersion.indexOf("MSIE 9")==-1 &&   //v9 is ok
		        navigator.appVersion.indexOf("MSIE 1")==-1  //v10, 11, 12, etc. is fine too
		    );

		    if(badBrowser){
		       return false;
		    }
		}
		return true;
	}

	<!--- Se ejecuta al llamar a la funcion = funcUpload --->
	function loadFromIfr(){
		var ifrm = document.getElementById('upload_target');
		var win = ifrm.contentWindow; // reference to iframe's window
		var doc = ifrm.contentDocument? ifrm.contentDocument: ifrm.contentWindow.document;

		document.forms["form1"]["TimbreFiscal"].value = doc.getElementById('hUUID').value;
		document.forms["form1"]["montoT"].value = doc.getElementById('hMontoTotal').value;<!--- Asigno el MontoTotal infoCFDIAjax--->
		document.forms["form1"]["tipoCambio"].value = doc.getElementById('hTipoCambio').value;<!--- Asigno el tipoCambio infoCFDIAjax--->
		document.forms["form1"]["Mcodigo"].value = doc.getElementById('hMcodigo').value;<!--- Asigno el Mcodigo de infoCFDIAjax--->
		<cfoutput>
		<cfif valMON EQ "N">
			//alert(doc.getElementById('hMcodigo').value);
			var mc = doc.getElementById('hMcodigo').value;
			var selectObj = document.forms["form1"]["Mcodigo"];
			document.forms["form1"]["montoT"].value = doc.getElementById("hMontoTotal").value;
			document.forms["form1"]["tipoCambio"].value = doc.getElementById("hTipoCambio").value;

			document.forms["form1"]["montoT"].setAttributeNode(document.createAttribute("readonly"));

			document.forms["form1"]["tipoCambio"].removeAttribute('readonly');
			document.forms["form1"]["Mcodigo"].removeAttribute('disabled');
			//if(doc.getElementById('hMcodigo').value != '-1'){
				document.forms["form1"]["Mcodigo"].setAttributeNode(document.createAttribute("disabled"));
				document.forms["form1"]["tipoCambio"].setAttributeNode(document.createAttribute("readonly"));
			//}
			selectObj.value = mc;
		</cfif>
		</cfoutput>
	}

	function funcUploadXML()
	{
		var mForm = document.getElementById('form1');
		var fileSelect = document.form1.AFimagen;
		var labelResult = document.getElementById('tdResult');
		var att = document.createAttribute("target");
		att.value = "upload_target";
		mForm.setAttributeNode(att);
		document.getElementById('form1').action = '/cfmx/sif/ce/operacion/infoCFDIAjax.cfm';
		document.getElementById('form1').submit();
		document.getElementById('form1').removeAttribute('target');
		document.getElementById('form1').action = '../../ce/operacion/SQLComprobanteFiscalPoliza.cfm';
	}

	function getInternetExplorerVersion()
	// Returns the version of Internet Explorer or a -1
	// (indicating the use of another browser).
	{
	  var rv = -1; // Return value assumes failure.
	  if (navigator.appName == 'Microsoft Internet Explorer')
	  {
	    var ua = navigator.userAgent;
	    var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
	    if (re.exec(ua) != null)
	      rv = parseFloat( RegExp.$1 );
	  }
	  return rv;
	}
	function checkVersion()
	{
	  var msg = false;
	  var ver = getInternetExplorerVersion();
	  if ( ver > -1 )
	  {
	    if ( ver > 8.0 ) 
	      msg = true;
	    
	  }else
	  	msg = true;
	  return msg;
	}

	function funcUpload()
	{
		var form = document.getElementById('file-form');
		var fileSelect = document.getElementById('file-select');
		var uploadButton = document.getElementById('upload-button');
		var labelResult = document.getElementById('labelResult');
		var vIdContable = document.getElementById('IDContable');
		var vIdLinea = document.getElementById('Dlinea');

		if (checkVersion()){
			// obteniendo los archivos del input.
			var files = fileSelect.files;
			// Crea  new FormData object.
			var formData = new FormData();

			if(files.length<1){
				alert("Seleccione al menos un archivo");
				return false;
			}

			uploadButton.innerHTML = 'Espere...';
			uploadButton.disabled = true;

			// Iterando sobre cada archivo seleccionado.
			for (var i = 0; i < files.length; i++) {
			  var file = files[i];

			  formData.append('file'+i, file, file.name);
			  formData.append('name'+i, file.name);
			}
			formData.append('idcontable', vIdContable.value);
			formData.append('idLinea', vIdLinea.value);
			var xhr = new XMLHttpRequest();
			xhr.open('POST', '/cfmx/sif/ce/operacion/SQLComprobanteFiscalPolizaMultipleAjax.cfm', true);

			xhr.onload = function () {
				if (xhr.status === 200) {
					uploadButton.innerHTML = 'Guardar';
					var res = xhr.responseText;
					labelResult.innerHTML = res;
					if(res.indexOf("Errores") > -1){
						uploadButton.disabled = false;
					}

				} else {
				    alert('Error al subir los archivos!');
				}
			};
			xhr.send(formData);
		}
		else {
		    alert('Su navegador es incompatible con esta operacion!');
		}
		return false;
	}

	function ocultaCFDI()
	{
		<cfoutput>#LB_Folio#</cfoutput>
		document.form1.AFimagen.style.visibility="hidden";
		<cfset ocultaCFDI=1>
	}
	function ocultaExt()
	{
		<cfset ocultaExt=1>

	}
	<!--- Valida que se haya seleccionado un archivo xml del input --->
	function funcValG(){
		var element1 = document.getElementById("inputhidden");
		var element2 = document.getElementById("inputhidden2");
		var element3 = document.getElementById("Hg");
		var element4 = document.getElementById("Hv");

		if(element1 != null){
			document.getElementById("inputhidden").style.display = 'block';
			document.getElementById("inputhidden2").style.display = 'none';
		}

		if(element3 != null){
			document.getElementById("Hg").style.display = 'none';
			document.getElementById("Hv").style.display = 'block';
		}

	}
	function toggle_vit(itemID){
		var form = document.forms["form1"];
		switch (itemID) {
		    case "1":
		        document.getElementById('lbltipAddedComment').innerHTML = '<cfoutput>#LB_TimbreFiscal#</cfoutput>';
		        document.getElementById('trXML').style.display = '';
		        document.getElementById('trXMLS').style.display = '';
		        document.getElementById('trCFDI').style.display = '';
		        document.getElementById('trCBBF').style.display = 'none';
		        document.getElementById('trCBBS').style.display = 'none';
		        break;
		    case "2":
		        document.getElementById('lbltipAddedComment').innerHTML = '<cfoutput>#LB_Folio#</cfoutput>';
		        document.getElementById('trXML').style.display = 'none';
		        document.getElementById('trXMLS').style.display = '';
		        document.getElementById('trCFDI').style.display = '';
		        document.getElementById('trCBBF').style.display = 'none';
		        document.getElementById('trCBBS').style.display = 'none';
		        break;
		    case "3":
		        document.getElementById('trXML').style.display = 'none';
		        document.getElementById('trXMLS').style.display = 'none';
		        document.getElementById('trCFDI').style.display = 'none';
		        document.getElementById('trCBBF').style.display = '';
		        document.getElementById('trCBBS').style.display = '';
		        break;
		}
	<cfoutput>
		<cfif modo EQ "ALTA">
			form.reset();
			document.forms["form1"]["AFnombre"].value = "";
		</cfif>
			document.getElementById(itemID).checked = true;
	</cfoutput>
	}

	function toggleit(str){
		  var temp = new Array();
		  temp = str.split(",");

		for	(index = 0; index < temp.length; index++) {
			var element =  document.getElementById(temp[index].toString());

			if (typeof(element) != 'undefined' && element != null){
				  if ((document.getElementById(temp[index].toString()).style.display == 'none')) {
				  		document.getElementById(temp[index].toString()).style.display = ''
				  		//event.preventDefault();
			      } else {
			            document.getElementById(temp[index].toString()).style.display = 'none';
			            //event.preventDefault();
			      }
			} else {
					//alert('Elemento no encontrado')	;
			}
		  }
	}

	function toggle_it(itemID){
	      var element =  document.getElementById(itemID);
			if (typeof(element) != 'undefined' && element != null)
			{
			  if ((document.getElementById(itemID).style.display == 'none')) {
			  		document.getElementById(itemID).style.display = ''
			  		document.getElementById('lbltipAddedComment').innerHTML = '<cfoutput>#LB_TimbreFiscal#</cfoutput>';
		            event.preventDefault()
		      } else {
		            document.getElementById(itemID).style.display = 'none';
		            document.getElementById('lbltipAddedComment').innerHTML = '<cfoutput>#LB_Folio#</cfoutput>';
		            event.preventDefault()
		      }
			} else {
				//alert('Elemento no encontrado')	;
			}
	}

	function printDiv(divName) {
	     var printContents = document.getElementById(divName).innerHTML;
	     var originalContents = document.body.innerHTML;

	     document.body.innerHTML = printContents;

	     window.print();
		 Finalizar(false);
	     //document.body.innerHTML = originalContents;
	}
	function Finalizar(refresh){
		if(typeof(refresh)==='undefined') refresh = true;
		if(refresh){
			if (window.opener.funcRefrescar) {
				window.opener.funcRefrescar()
			}
			if (window.opener.funcClick) {
				window.opener.funcClick()
			}
		}
		window.close();

	}

</script>
 <script language="javascript" type="text/javascript">
			function extraeNombre(value){
				 var extensionTemp = "";
				  var nombreArchivo = "";

				 for(i=value.length-1;i>=0;i--)
				  {
					  if(value.charAt(i) == '.')
						{
						   break;
						}
						else
						{
						 extensionTemp = value.charAt(i)+extensionTemp ;
						}
				   }

					document.form1.AFnombreImagen.value=extensionTemp;

				 for(i=value.length-1;i>=0;i--)
				  {
					  if(value.charAt(i) == '\\')
						{
						   break;
						}
						else
						{
						 nombreArchivo = value.charAt(i)+nombreArchivo ;
						}
				   }

					document.form1.AFnombre.value=nombreArchivo;


				}
				function extraeNombreSoporte(value){
				 var extensionTemp = "";
				  var nombreArchivo = "";

				 for(i=value.length-1;i>=0;i--)
				  {
					  if(value.charAt(i) == '.')
						{
						   break;
						}
						else
						{
						 extensionTemp = value.charAt(i)+extensionTemp ;
						}
				   }

					document.form1.AFnombreImagenSoporte.value=extensionTemp;

				 for(i=value.length-1;i>=0;i--)
				  {
					  if(value.charAt(i) == '\\')
						{
						   break;
						}
						else
						{
						 nombreArchivo = value.charAt(i)+nombreArchivo ;
						}
				   }

					document.form1.AFnombreSoporte.value=nombreArchivo;


				}

				<cfoutput>
				<cfif modo NEQ "ALTA">
					toggle_vit("#getDoc.TipoComprobante#");
				</cfif>
				</cfoutput>
			</script>

</body>
</html>