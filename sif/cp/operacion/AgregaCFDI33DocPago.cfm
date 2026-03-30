<!--- 
	Creado por Israel Rodiguez.
		Fecha: 16-OCT-2017.
		Motivo: Proceso para agregar  CFDIS a los documentos de Pago 
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_PagosR 	= t.Translate('TIT_PagosR','Agrega CFID a Documentos de Pago')>



<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_PagosR#'>

<cfquery name="rsValMON" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset valMON = "N">
<cfif #rsValMON.RecordCount#  neq 0>
	<cfset valMON = rsValMON.Pvalor>
</cfif>
<cfoutput>
	<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="AgregaCFDI33DocPago.cfm" onsubmit="return validaForm()">

	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
				 
			 <input type="hidden"id='totales' name="Totales" value="">
			 <input type="hidden" name="Exitosos" value="">
			 <input type="hidden" name="Fallaron" value="">
			 <input type="hidden" name="BaseTotal" value="">
			 <input type="hidden" name="hBaseRepetidos" value="">
			 <input type="hidden" name="BaseRealizados" value="">
			 <input type="hidden" id='contador' name="contador" value="-1">
			 <input type="hidden" id='limite' name="limite" value="">
			 <input type="hidden" id="lista" name="lista"  value="">
			 <input type="hidden" id="data" name="data"  value="">
			 <input type="hidden" name="AFimagen" value="">

			 
		     <input type="hidden" name="AFnombreImagen" value="">
		  <input type="hidden" name="AFnombre" value="">
			<td valign="top" align="center">
			<fieldset>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr>
			<td  colspan="2" nowrap align="center" width="47%"><input type="file"  id="files"name="files" onChange="javascript:cambiaBoton();"  multiple accept=".xml" />
            <output id="list">			
           
					<tr>
						<tr><td>&nbsp;</td></tr>
						<td  colspan="2" nowrap align="center" width="47%">
							<strong>Agrega CFDIs:</strong>

						</td>
						
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="2" nowrap align="center" width="47%">
					<input type="button" disabled id="AgregarPagos" value="Agregar"  onclick="funcUpload()"  />
					</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				<td  colspan="2" nowrap align="center" width="47%">	 <div id="labelResult"></td>	</tr>

<tr>
					<td colspan="2">
				<iframe width="100%" height="60px" id="upload_target" name="upload_target" src="" frameBorder="0"></iframe>
			</td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
    <script language="javascript1.2" type="text/javascript">
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

	// document.getElementById('guarda').addEventListener('submit', funcGuardarPago, false);
	function cambiaBoton(){

		var uploadButton = document.getElementById('AgregarPagos');
		uploadButton.disabled = false;
	
	
	}

	function funcUpload()
	{
		console.log('Entro');
		var form = document.getElementById('form1');
		var fileSelect = document.getElementById('files');
	
		var labelResult = document.getElementById('labelResult');
          
		if (checkVersion()){
			// obteniendo los archivos del input.
			var files = fileSelect.files;
			// Crea  new FormData object.
			var formData = new FormData();

			if(files.length<1){
				alert("Seleccione al menos un archivo");
		
				return false;
			}

	

			// Iterando sobre cada archivo seleccionado.
			for (var i = 0; i < files.length; i++) {
			  var file = files[i];

			  formData.append('file'+i, file, file.name);
			  formData.append('name'+i, file.name);
			}
			formData.append('PagosMultiples', 'SI');
				console.log('post');
				var xhr = new XMLHttpRequest();
			xhr.open('POST', '/cfmx/sif/ce/operacion/infoCFDIAjax.cfm', true);

			xhr.onload = function () {
				

				if (xhr.status === 200) {
					var res = xhr.responseText;
					labelResult.innerHTML = res;
					if(res.indexOf("Errores") > -1){
						
						}

					if(form.Guardar.value=='Guardar'){
							labelResult.innerHTML = res;
						loadFromIfr();
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

	function loadFromIfr(){

	          console.log('Totales'+document.getElementById('hTotales').value);
	          console.log('Exitosos'+document.getElementById('hExitosos').value);
	          console.log('Fallaron'+document.getElementById('hFallaron').value);	           
	          console.log('Base Total'+document.getElementById('hBaseTotal').value);
	          console.log('Base Repetidos'+document.getElementById('hBaseRepetidos').value);
	          console.log('Base Realizados'+document.getElementById('hBaseRealizados').value);
	     
	
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
	



</script>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
