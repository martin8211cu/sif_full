<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoComprobante" default="Tipo de Comprobante" returnvariable="LB_TipoComprobante" xmlfile="formComprobanteFiscal.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_CFDI" default="CFDI" returnvariable="RBTN_CFDI" xmlfile="formComprobanteFiscal.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_EXT" default="Extranjero" returnvariable="RBTN_Ext" xmlfile="formComprobanteFiscal.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="RBTN_CBB" default="Otro Nacional" returnvariable="RBTN_CBB" xmlfile="formComprobanteFiscal.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TimbreFiscal" default="Timbre Fiscal UUID:" returnvariable="LB_TimbreFiscal" xmlfile="formComprobanteFiscal.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Folio" default="Folio:" returnvariable="LB_Folio" xmlfile="formComprobanteFiscal.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Serie" default="Serie:" returnvariable="LB_Serie" xmlfile="formComprobanteFiscal.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ArchivoXML" default="Archivo XML CFDI" returnvariable="LB_ArchivoXML" xmlfile="formComprobanteFiscal.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ArchivoSoporte" default="Archivo Soporte" returnvariable="LB_ArchivoSoporte" xmlfile="formComprobanteFiscal.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Guardar" default="Guardar" returnvariable="BTN_Guardar" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Cambiar" default="Actualizar" returnvariable="BTN_Cambiar" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Eliminar" default="Eliminar" returnvariable="BTN_Eliminar" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Validar" default="Validar y Guardar" returnvariable="BTN_Validar" xmlfile="/sif/generales.xml"/>



<cfif isdefined('url.docid') and LEN(TRIM(url.docid))>
	<cfset Form.IDdocumento = url.docid>

</cfif>
<cfif isdefined('url.Origen') and LEN(TRIM(url.Origen))>
	<cfset Form.Origen = url.Origen>
</cfif>

<cfif isdefined('url.SNcodigo') and LEN(TRIM(url.SNcodigo))>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined('url.IDlinea') and LEN(TRIM(url.IDlinea))>
	<cfset Form.IDlinea = url.IDlinea>
<cfelse>
	<cfset Form.IDlinea = "">
</cfif>
<cfif isdefined('url.nombre') and LEN(TRIM(url.nombre))>
	<cfset Form.nombre = url.nombre>
</cfif>
<cfif isdefined('url.modo') and LEN(TRIM(url.modo))>
	<cfset Form.modo = url.modo>
<cfelse>
	<cfset Form.modo = "">
</cfif>

<cfif isdefined('url.doc') and LEN(TRIM(url.doc))>
	<cfset Form.doc = url.doc>
<cfelse>
	<cfif Form.modo EQ "">
	<cfif Form.Origen EQ "CPFC">
	 	<cfquery name="getDocumento" datasource="#session.dsn#">
	        select EDdocumento from EDocumentosCxP
	        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and IDdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IDdocumento#">
		</cfquery>
	    <cfset Form.doc = getDocumento.EDdocumento>
	</cfif>
	<cfif Form.Origen EQ "CCFC">
	 	<cfquery name="getDocumento" datasource="#session.dsn#">
	        select EDdocumento from EDocumentosCxC
	        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and EDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IDdocumento#">
		</cfquery>
	    <cfset Form.doc = getDocumento.EDdocumento>
	</cfif>
	<cfif Form.Origen EQ "TES">
	 	<cfquery name="getDocumento" datasource="#session.dsn#">
	        select TESDPdocumentoOri
			from TESdetallePago
	        where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and TESSPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IDlinea#">
		</cfquery>
	    <cfset Form.doc = getDocumento.TESDPdocumentoOri>
	</cfif>
</cfif>
</cfif>

<cfset modo="ALTA">
<cfquery name="getDoc"  datasource="#session.dsn#">
	select * from CERepoTMP
    where Ecodigo  = #session.Ecodigo#
    	and Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Origen#">
	<cfif form.modo EQ "">
	<cfif Form.Origen EQ "TES" or Form.Origen EQ "TSGS">
			and ID_Linea = #Form.IDlinea#
	<cfelse>
    	and ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IDdocumento#">
		</cfif>
	<cfelse>
		and ID_Documento = -1
		and ID_Linea = -1
	</cfif>
</cfquery>

<cfif getDoc.RecordCount GT 0>
	<cfset modo = "CAMBIO">
</cfif>

<!--- VALIDACION DE PARAMETRO VALIDA XML PROVEEDORES --->
<cfquery name="rsValidaXML"  datasource="#session.dsn#">
	SELECT * FROM Parametros WHERE Pcodigo = 200085 AND Mcodigo = 'CE' AND Pvalor = 'S' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- VALIDACION DE PARAMETRO NO VALIDAR RFC EMISOR TESORERIA --->
<!--- <cfquery name="rsValRFCTES" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200082 AND Mcodigo = 'CE' AND Pvalor = 'S' AND Ecodigo = #Session.Ecodigo#
</cfquery> --->

<!--- VALIDACION DE PARAMETRO NO VALIDAR MONEDA, MONTO Y TIPO DE CAM --->
<cfquery name="rsValMON" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset valMON = "N">
<cfif #rsValMON.RecordCount#  neq 0>
	<cfset valMON = rsValMON.Pvalor>
</cfif>

<html>
<head>
<title>Informaci&oacute;n CFDI</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<form name="form1" id="form1" action="SQLComprobanteFiscal.cfm" method="post" enctype="multipart/form-data" onsubmit="return validaForm()">
<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="2">
	    <tr><td>&nbsp;</td></tr>
		<tr><td align="right"><strong>#LB_TipoComprobante#:&nbsp;</strong></td>
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
		  <input type="hidden" name="xmlTimbrado" id="xmlTimbrado" value="">
		<!--- Campos ocultos --->
		  <input type="hidden" name="montoT" value=""><!--- Obtenemos el MontoTotal de infCFDIAjax --->
		  <input type="hidden" name="tipoCambio" value=""><!--- Obtenemos el TipoCambio de infCFDIAjax --->
		  <input type="hidden" name="Mcodigo" value=""><!--- Obtenemos el Mcodigo de infCFDIAjax --->
          <input type="hidden" name="AFnombreImagen" value="">
		  <input type="hidden" name="AFnombre" value="">
          <input type="hidden" name="AFnombreImagenSoporte" value="">
		  <input type="hidden" name="AFnombreSoporte" value="">
          <input type="hidden" name="modo" value="#modo#">
          <input type="hidden" name="origen" value="#Form.Origen#">
	<cfif Form.modo EQ "" >
		  <input type="hidden" name="sncodigo" value="#Form.SNcodigo#">
          <input type="hidden" name="documento" value="#Form.doc#">
          <input type="hidden" name="docID" value="#Form.IDdocumento#">
		  <input type="hidden" name="IDlinea" value="#Form.IDlinea#">
	</cfif>
		  <input type="hidden" name="nombre" value="#Form.nombre#">
		  <cfif modo NEQ "ALTA">
			  <input type="hidden" name="idRep" value="#getDoc.CEfileId#">
		  </cfif>
          <tr id="trCFDI" style="display:">
	          <td align="right"><strong><label id="lbltipAddedComment">#LB_TimbreFiscal#</label></strong></td>
	          <td ><input name="TimbreFiscal" tabindex="1" onFocus="javascript:this.select();" type="text"
					   value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.TimbreFiscal)#</cfoutput></cfif>" size="40" maxlength="37" <cfif modo NEQ "ALTA" and getDoc.TipoComprobante EQ 1 > readonly</cfif>>
           	  </td>
		   </tr>
		   <tr id="trCBBF" style="display:none">
			  <td align="right"><strong><label id="lbltipAddedComment">#LB_Folio#</label></strong></td>
		        <td ><input name="tFolio" tabindex="1" onFocus="javascript:this.select();" type="text"
				   value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.TimbreFiscal)#</cfoutput></cfif>" size="40" maxlength="37" <cfif modo NEQ "ALTA" and getDoc.TipoComprobante EQ 1 > readonly</cfif>>
		        </td>
		    </tr>
			<tr id="trCBBS" style="display:none">
		        <td align="right"><strong><label id="lbltipAddedComment">#LB_Serie#</label></strong></td>
		        <td ><input name="tSerie" tabindex="1" onFocus="javascript:this.select();" type="text"
				   value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLeditFormat(getDoc.Serie)#</cfoutput></cfif>" size="40" maxlength="37" <cfif modo NEQ "ALTA" and getDoc.Serie EQ 1 > readonly</cfif>>
	        </td>
			</tr>
			<cfif isdefined('getDoc.NomArchXML') and getDoc.NomArchXML neq ''>
          	<tr id="trXML" style="display:">
	            <td align="right">#LB_ArchivoXML#:</td>
	            <td align="left"><strong>#getDoc.NomArchXML#</strong></td>
			</tr>
           <cfelse>
			<tr id="trXML" style="display:">
	            <td align="right">#LB_ArchivoXML#:</td>
	            <td align="left"><input type="file" name="AFimagen" value="" onChange="javascript:extraeNombre(this.value); funcUpload(); funcValG();"  accept=".xml" size="40" tabindex="100"></td>
           	</tr>
		   </cfif>
		   <cfif isdefined('getDoc.NomArchSoporte') and getDoc.NomArchSoporte neq ''>
          	<tr id="trXMLS" style="display:">
	            <td align="right">#LB_ArchivoSoporte#:</td>
                <input type="hidden" name="NomArchSoporte" id="NomArchSoporte" value="#getDoc.NomArchSoporte#" />
                <input type="hidden" name="ExtArchSoporte" id="ExtArchSoporte" value="#getDoc.ExtArchSoporte#" />
	            <td align="left"><strong>#getDoc.NomArchSoporte#.#getDoc.ExtArchSoporte#</strong></td>
			</tr>
           <cfelse>
			<tr id="trXMLS" style="display:">
            	<td align="right">#LB_ArchivoSoporte#:</td>
                <td align="left"><input type="file" name="AFimagenPDF" value="" onChange="javascript:extraeNombreSoporte(this.value);" size="40" tabindex="100"></td>
          	</tr>
		   </cfif>

		<cfif valMON EQ "N" and valMON EQ "S">
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
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(getDoc.TotalCFDI,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
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
         <tr><td id="tdResult" colspan="2">&nbsp;</td></tr>
	 <tr>
         	<td colspan="2" id="tdResultValidateCFDI">&nbsp;</td>
         </tr>
         <tr><td colspan="2" align="center">
			 <cfif modo EQ "ALTA">
				<cfif Form.modo EQ "" >
					<span id="Hg"><!--- Default --->
						<input name="GuardarComprobante" class="btnGuardar"  tabindex="10" type="submit" value="#BTN_Guardar#" />
					</span>
					<span id="Hv" style="display:none"><!--- Si seleccionamos un archivo del input--->
					<cfif #rsValidaXML.RecordCount#  neq 0 AND valMON EQ "N">
						<input name="GuardarComprobante" class="btnAplicar" onclick="validacionXML()" tabindex="12"  type="button" value="#BTN_Validar#" />
					<cfelse>
						<input name="GuardarComprobante" class="btnGuardar"  tabindex="10" type="submit" value="#BTN_Guardar#" />
					</cfif>
					</span>
				<cfelse>
					<span id="inputhidden2"><!--- Default --->
						<button name="GuardarComprobante" onclick="if(validaForm())asignar()" class="btnGuardar"  tabindex="10" type="button">#BTN_Guardar#</button>
					</span>
					<span id="inputhidden" style="display:none"><!--- Si seleccionamos un archivo del input--->
					<cfif #rsValidaXML.RecordCount#  neq 0 AND valMON EQ "N">
						<button name="GuardarComprobante" onclick="if(validaForm())asignarVal()" class="btnGuardar"  tabindex="10" type="button">#BTN_Validar#</button>
					<cfelse>
						<button name="GuardarComprobante" onclick="if(validaForm())asignar()" class="btnGuardar"  tabindex="10" type="button">#BTN_Guardar#</button>
					</cfif>
					</span>
					<input type="hidden" name="SubirComprobante" id="SubirComprobante" value="true" />
					<input type="hidden" name="nombre_xTMP" id="nombre_xTMP" value="" />
					<input type="hidden" name="nombre_sTMP" id="nombre_sTMP" value="" />
					<input type="hidden" name="mform" id="mform" value="#url.form#" />
				</cfif>
             <cfelse>
             	<cfif #rsValidaXML.RecordCount#  neq 0 AND valMON EQ "N">
             		<input name="CambiarComprobante" class="btnAplicar" onclick="validacionXML()" tabindex="12"  type="button" value="#BTN_Validar#" />
             		<cfelse>
             		<input name="CambiarComprobante" class="btnGuardar"  tabindex="11" type="submit" value="#BTN_Cambiar#" />
             	</cfif>
				<input name="EliminarComprobante" class="btnEliminar"  tabindex="12" type="submit" value="#BTN_Eliminar#" />
     		 </cfif>
         </td></tr>
		<tr>
			<td colspan="2">
				<iframe width="100%" height="60px" id="upload_target" name="upload_target" src="" frameBorder="0"></iframe>
			</td>
		</tr>
	</table>

</cfoutput>
</form>
<cfquery name="rsMcodigo" datasource="#Session.DSN#">
	SELECT  Mcodigo
	FROM    Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cf_qforms form="form1" objForm="objForm">
<script language="javascript1.2" type="text/javascript">
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
		var varCFDI = document.getElementById("1").checked;
		<!--- var varCFDI = document.forms["form1"]["optTipoComprobante"].value; --->
		var varFiles = document.forms["form1"]["AFimagen"];
		var varOrigen = <cfoutput><cfif isdefined('form.Origen') and LEN(TRIM(form.Origen))>
			"#form.origen#"
			<cfelse>
			""
		</cfif></cfoutput>

		// TES - TESORERIA
		// TSGS - GASTOS EMPLEADO
		<!--- alert(varCFDI); --->
		if(varCFDI){
			if(varOrigen == "TES" || varOrigen == "TSGS"){
				if(varFiles.value != ""){
					validaXmlAjax();
				} else{
					document.form1.submit();
				}
			}else{
				validaXmlAjax();
				<!--- alert('no es tes...' + varOrigen) --->
			}
		}else{
			document.form1.submit();
		}
	}

	function validaXmlAjax(){
		// Esta funcion se encarga de validar el comprobante CFDI VS el WS del SAT

		// DECLARACION DE VARIABLES Y RECUPERACION DE VALORES
		<!--- var form =                     document.forms["form1"];
		var timbreFiscal =             document.forms["form1"]["TimbreFiscal"];
		var montoTotal =               document.forms["form1"]["montoT"]; --->
		var tdResultValidateCFDI =     document.getElementById('tdResultValidateCFDI');
		var fileSelect =               "";
		var files =                    "";
		var socioNegocioId =           "";
		var xmlTimbrado =              "";


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

		if(xmlTimbrado != ""){
			<!--- formData = formData + '&socioNegocioId=' + socioNegocioId --->
			document.forms["form1"]["xmlTimbrado"].value = xmlTimbrado;
		}

		if(fileSelect != ""){<!--- Valida que se haga seleccionado un archivo  --->
			var mForm = document.getElementById('form1');
			var att = document.createAttribute("target");
			att.value = "upload_target";
			mForm.setAttributeNode(att);
			<!--- Ejecuta la funcion de validar con el ws --->
			document.getElementById('form1').action = '/cfmx/sif/ce/operacion/validaCFDIAjax.cfm';
			document.getElementById('form1').submit();
			document.getElementById('form1').removeAttribute('target');
			document.getElementById('form1').action = 'SQLComprobanteFiscal.cfm';
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
		if(estado === "Vigente"){
				// SI ES VIGENTE, ES CORRECTO POR LO TANTO SI LO GUARDA/MODIFICA
				document.form1.submit();
		}else {
			alert(resCodigoEstado);
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
	<cfif valMON EQ "N"  and valMON EQ "S" and modo EQ "ALTA">
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
			<cfif valMON EQ "N" and valMON EQ "S" and modo EQ "ALTA">
			if (validBrowser()){
				var vMcodigo = document.getElementById('Mcodigo');
				if(vMcodigo != null)
					document.getElementById('Mcodigo').removeAttribute("disabled");
			}
			</cfif>
			return true;
		} else {
			<cfif valMON EQ "N" and valMON EQ "S" and modo EQ "ALTA">
			<!--- if (validBrowser()){
				document.forms["form1"]["Mcodigo"].setAttributeNode(document.createAttribute("disabled"));
			} --->
			</cfif>
			alert("Se encontraron los siguientes errores: \n\n" + msg);
			return false;
		}

	}
	</cfoutput>
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

	function asignarVal()
	{
		<cfoutput>
			window.opener.document.#url.form#.#form.nombre#.value = document.forms["form1"]["TimbreFiscal"].value;
			<cfset xmlName = "ce_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#_#session.Usucodigo#">
			document.forms["form1"]["nombre_xTMP"].value = "#xmlName#";
			window.opener.document.#url.form#.ce_nombre_xTMP.value = "#xmlName#";
			if(document.forms["form1"]["AFnombre"] != null && document.forms["form1"]["AFnombre"].value != ""){
				window.opener.document.#url.form#.ce_AFnombre.value = document.forms["form1"]["AFnombre"].value;
				<cfset xmlName = "xml_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#_#session.Usucodigo#.xml">
			}
			if(document.forms["form1"]["AFnombreSoporte"] != null && document.forms["form1"]["AFnombreSoporte"].value != ""){
				window.opener.document.#url.form#.ce_AFnombreImagenSoporte.value = document.forms["form1"]["AFnombreImagenSoporte"].value;
				window.opener.document.#url.form#.ce_AFnombreSoporte.value = document.forms["form1"]["AFnombreSoporte"].value;
			}
			window.opener.document.#url.form#.ce_modo.value = "#Form.modo#";
			window.opener.document.#url.form#.ce_origen.value = "#Form.Origen#";
			window.opener.document.#url.form#.ce_optTipoComprobante.value = document.forms["form1"]["optTipoComprobante"].value;
			if(document.forms["form1"]["optTipoComprobante"].value == "2"){
				window.opener.document.#url.form#.ce_tFolio.value = document.forms["form1"]["tFolio"].value;
				window.opener.document.#url.form#.#form.nombre#.value = document.forms["form1"]["tFolio"].value;
			}
			if(document.forms["form1"]["optTipoComprobante"].value == "3"){
				window.opener.document.#url.form#.ce_tFolio.value = document.forms["form1"]["tFolio"].value;
				window.opener.document.#url.form#.ce_tSerie.value = document.forms["form1"]["tSerie"].value;
				window.opener.document.#url.form#.#form.nombre#.value = document.forms["form1"]["tFolio"].value;
			}
			if(document.forms["form1"]["NomArchSoporte"] != null){
				window.opener.document.#url.form#.ce_NomArchSoporte.value = document.forms["form1"]["NomArchSoporte"].value;
				window.opener.document.#url.form#.ce_ExtArchSoporte.value = document.forms["form1"]["ExtArchSoporte"].value;
			}
			<cfif valMON EQ "N">
				if(window.opener.document.#url.form#.ce_montoT)window.opener.document.#url.form#.ce_montoT.value = document.forms["form1"]["montoT"].value;
				if(window.opener.document.#url.form#.ce_tipoCambio)window.opener.document.#url.form#.ce_tipoCambio.value = document.forms["form1"]["tipoCambio"].value;
				if(window.opener.document.#url.form#.ce_Mcodigo)window.opener.document.#url.form#.ce_Mcodigo.value = document.forms["form1"]["Mcodigo"].value;
			</cfif>
		</cfoutput>
		validacionXML();
	}

	function asignar()
	{
		<cfoutput>
			window.opener.document.#url.form#.#form.nombre#.value = document.forms["form1"]["TimbreFiscal"].value;
			<cfset xmlName = "ce_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#_#session.Usucodigo#">
			document.forms["form1"]["nombre_xTMP"].value = "#xmlName#";
			window.opener.document.#url.form#.ce_nombre_xTMP.value = "#xmlName#";
			if(document.forms["form1"]["AFnombre"] != null && document.forms["form1"]["AFnombre"].value != ""){
				window.opener.document.#url.form#.ce_AFnombre.value = document.forms["form1"]["AFnombre"].value;
				<cfset xmlName = "xml_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#_#session.Usucodigo#.xml">
			}
			if(document.forms["form1"]["AFnombreSoporte"] != null && document.forms["form1"]["AFnombreSoporte"].value != ""){
				window.opener.document.#url.form#.ce_AFnombreImagenSoporte.value = document.forms["form1"]["AFnombreImagenSoporte"].value;
				window.opener.document.#url.form#.ce_AFnombreSoporte.value = document.forms["form1"]["AFnombreSoporte"].value;
			}
			window.opener.document.#url.form#.ce_modo.value = "#Form.modo#";
			window.opener.document.#url.form#.ce_origen.value = "#Form.Origen#";
			window.opener.document.#url.form#.ce_optTipoComprobante.value = document.forms["form1"]["optTipoComprobante"].value;
			if(document.forms["form1"]["optTipoComprobante"].value == "2"){
				window.opener.document.#url.form#.ce_tFolio.value = document.forms["form1"]["tFolio"].value;
				//window.opener.document.#url.form#.#form.nombre#.value = document.forms["form1"]["tFolio"].value;
			}
			if(document.forms["form1"]["optTipoComprobante"].value == "3"){
				window.opener.document.#url.form#.ce_tFolio.value = document.forms["form1"]["tFolio"].value;
				window.opener.document.#url.form#.ce_tSerie.value = document.forms["form1"]["tSerie"].value;
				window.opener.document.#url.form#.#form.nombre#.value = document.forms["form1"]["tFolio"].value;
			}
			if(document.forms["form1"]["NomArchSoporte"] != null){
				window.opener.document.#url.form#.ce_NomArchSoporte.value = document.forms["form1"]["NomArchSoporte"].value;
				window.opener.document.#url.form#.ce_ExtArchSoporte.value = document.forms["form1"]["ExtArchSoporte"].value;
			}
			<cfif valMON EQ "N" and valMON EQ "S">
				if (validBrowser()){
					window.opener.document.#url.form#.ce_montoT.value = document.forms["form1"]["montoT"].value;
					window.opener.document.#url.form#.ce_tipoCambio.value = document.forms["form1"]["tipoCambio"].value;
					window.opener.document.#url.form#.ce_Mcodigo.value = document.forms["form1"]["Mcodigo"].value;
				}
			</cfif>
		</cfoutput>
		document.form1.submit();
	}

	function toggle_vit(itemID){
		var form = document.forms["form1"];
		switch (itemID) {
		    case "1":
		        document.getElementById('lbltipAddedComment').innerHTML = '<cfoutput>#LB_TimbreFiscal#</cfoutput>';
		        document.getElementById('trXML').style.display = ''
		        document.getElementById('trXMLS').style.display = ''
		        document.getElementById('trCFDI').style.display = ''
		        document.getElementById('trCBBF').style.display = 'none'
		        document.getElementById('trCBBS').style.display = 'none'
		        break;
		    case "2":
		        document.getElementById('lbltipAddedComment').innerHTML = '<cfoutput>#LB_Folio#</cfoutput>';
		        document.getElementById('trXML').style.display = 'none'
		        document.getElementById('trXMLS').style.display = ''
		        document.getElementById('trCFDI').style.display = ''
		        document.getElementById('trCBBF').style.display = 'none'
		        document.getElementById('trCBBS').style.display = 'none'
		        break;
		    case "3":
		        document.getElementById('trXML').style.display = 'none'
		        document.getElementById('trXMLS').style.display = 'none'
		        document.getElementById('trCFDI').style.display = 'none'
		        document.getElementById('trCBBF').style.display = ''
		        document.getElementById('trCBBS').style.display = ''
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
	<!--- Se ejecuta al llamar a la funcion = funcUpload --->
	function loadFromIfr(){
		var ifrm = document.getElementById('upload_target');
		var win = ifrm.contentWindow; // reference to iframe's window
		var doc = ifrm.contentDocument? ifrm.contentDocument: ifrm.contentWindow.document;

		document.forms["form1"]["TimbreFiscal"].value = doc.getElementById('hUUID').value; <!--- Asigno el TimbreFiscal infoCFDIAjax--->
		document.forms["form1"]["montoT"].value = doc.getElementById('hMontoTotal').value;<!--- Asigno el MontoTotal infoCFDIAjax--->
		document.forms["form1"]["tipoCambio"].value = doc.getElementById('hTipoCambio').value;<!--- Asigno el tipoCambio infoCFDIAjax--->
		document.forms["form1"]["Mcodigo"].value = doc.getElementById('hMcodigo').value;<!--- Asigno el Mcodigo de infoCFDIAjax--->
		<cfoutput>
		<cfif valMON EQ "N" and valMON EQ "S">
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

	function funcUpload()
	{
		var mForm = document.getElementById('form1');
		var fileSelect = document.form1.AFimagen;
		var labelResult = document.getElementById('tdResult');
		var att = document.createAttribute("target");
		att.value = "upload_target";
		mForm.setAttributeNode(att);
		document.getElementById('form1').action = '/cfmx/sif/ce/operacion/infoCFDIAjax.cfm';<!--- Obtiene los datos del xml --->
		document.getElementById('form1').submit();
		document.getElementById('form1').removeAttribute('target');
		document.getElementById('form1').action = 'SQLComprobanteFiscal.cfm';

	}

	function validBrowser(){
		if(navigator.appName.indexOf("Internet Explorer")!=-1){     //yeah, he's using IE
		    var badBrowser=(
		        //navigator.appVersion.indexOf("MSIE 9")==-1 &&   //v9 is ok
		        navigator.appVersion.indexOf("MSIE 1")==-1  //v10, 11, 12, etc. is fine too
		    );

		    if(badBrowser){
		       return false;
		    }
		}
		return true;
	}

	//Formatea como float un valor de un campo
	//Recibe como parametro el campo y la cantidad de decimales a mostrar
	function fm(campo,ndec) {
	   var s = "";
	   if (campo.name)
	     s=campo.value
	   else
	     s=campo

	   if(s=='' && ndec>0)
			s='0'

	   var nc=""
	   var s1=""
	   var s2=""
	   if (s != '') {
	      str = new String("")
	      str_temp = new String(s)
	      t1 = str_temp.length
	      cero_izq=true
	      if (t1 > 0) {
	         for(i=0;i<t1;i++) {
	            c=str_temp.charAt(i)
	            if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && cero_izq==false)) {
	               cero_izq=false
	               str+=c
	            }
	         }
	      }
	      t1 = str.length
	      p1 = str.indexOf(".")
	      p2 = str.lastIndexOf(".")
	      if ((p1 == p2) && t1 > 0) {
	         if (p1>0)
	            str+="00000000"
	         else
	            str+=".0000000"
	         p1 = str.indexOf(".")
	         s1=str.substring(0,p1)
	         s2=str.substring(p1+1,p1+1+ndec)
	         t1 = s1.length
	         n=0
	         for(i=t1-1;i>=0;i--) {
	             c=s1.charAt(i)
	             if (c == ".") {flag=0;nc="."+nc;n=0}
	             if (c>="0" && c<="9") {
	                if (n < 2) {
	                   nc=c+nc
	                   n++
	                }
	                else {
	                   n=0
	                   nc=c+nc
	                   if (i > 0)
	                      nc=","+nc
	                }
	             }
	         }
	         if (nc != "" && ndec > 0)
	            nc+="."+s2
	      }
	      else {ok=1}
	   }

	   if(campo.name) {
		   if(ndec>0) {
			 campo.value=nc
		   } else {
			 campo.value=qf(nc)
			}
	   } else {
	     return nc
	   }
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

		<script>
		 !window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
		</script>

</body>
</html>