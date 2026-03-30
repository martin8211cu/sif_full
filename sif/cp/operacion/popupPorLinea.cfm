<link href="/cfmx/plantillas/erp/css/erp.css " rel="stylesheet" type="text/css">

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Lb_Encabezado = t.Translate('Lb_Encabezado','Favor de relacionar las lineas de la Nota de cr&eacute;dito vs las de la Factura')>
<cfset Lb_LineasNC = t.Translate('Lb_LineasNC','Nota de cr&eacute;dito')>
<cfset Lb_LineasFC = t.Translate('Lb_LineasFC','Factura')>
<cfset Lb_Title = t.Translate('Lb_Title','Relaci&oacute;n de linea NC vs FC')>
<br>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lb_Title#'>
<cfoutput>

	<cfif isdefined("url.IdNC")>
		<cfset IdNC="#url.IdNC#">
	</cfif>
	<cfif isdefined("url.IdFC")>
		<cfset IdFC="#url.IdFC#">
	</cfif>
	<cfif isdefined("url.Mov")>
		<cfset IdMovimiento="#url.Mov#">
	</cfif>


	<!--- INICIA QUERYS --->
	<cfquery name="rsLineasNC" datasource="#Session.DSN#">
		SELECT d.DDlinea,
		       d.DDtipo AS ItemNC,
		       d.DDescripcion AS DescNC,
		       (d.DDtotallin + (d.DDtotallin*(i.Iporcentaje/100))) totalNC,
		       i.Iporcentaje,
		       d.Ddocumento,
		       CASE d.codIEPS
		          WHEN '-' THEN -1
		          WHEN '0' THEN -1
		          ELSE (SELECT Iporcentaje FROM Impuestos WHERE Icodigo = d.codIEPS and Ecodigo = #Session.Ecodigo#)
		       END ieps
		FROM DDocumentosCP d
		INNER JOIN Impuestos i ON i.Icodigo = d.Icodigo
		AND d.Ecodigo = i.Ecodigo
		AND d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IdNC#">
		AND d.CPTcodigo = 'NC'
		AND d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		AND d.DDlinea NOT IN (SELECT NCId FROM CPrelacionLineasNcFc WHERE
		  			  		  Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  			  		  AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IdMovimiento#">)
		ORDER BY d.DDlinea ASC
	</cfquery>

	<cfquery name="rsLineasFC" datasource="#Session.DSN#">
		SELECT d.DDlinea,
		       d.DDtipo AS ItemFC,
		       d.DDescripcion AS DescFC,
		       (d.DDtotallin + (d.DDtotallin*(i.Iporcentaje/100))) totalFC,
		       i.Iporcentaje,
		       d.Ddocumento,
		       CASE d.codIEPS
		          WHEN '-' THEN -1
		          WHEN '0' THEN -1
		          ELSE (SELECT Iporcentaje FROM Impuestos WHERE Icodigo = d.codIEPS and Ecodigo = #Session.Ecodigo#)
		       END ieps
		FROM DDocumentosCP d
		INNER JOIN Impuestos i ON i.Icodigo = d.Icodigo
		AND d.Ecodigo = i.Ecodigo
		AND d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IdFC#">
		AND d.CPTcodigo IN
		  (SELECT CPTcodigo
		   FROM CPTransacciones
		   WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		     AND CPTtipo = 'C')
		AND d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		AND d.DDlinea NOT IN (SELECT FCId FROM CPrelacionLineasNcFc WHERE
		  			  		  Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  			  		  AND MovAplicacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IdMovimiento#">)
		ORDER BY d.DDlinea ASC
	</cfquery>

	<!--- FINALIZA QUERYS --->


	<cfif rsLineasNC.recordCount LT rsLineasFC.recordCount>
		<cfset totalLineasPorRelacionar = rsLineasNC.recordCount>
	<cfelse>
		<cfset totalLineasPorRelacionar = rsLineasFC.recordCount>
	</cfif>
	<form action="SQLRelacionPorLineas.cfm" method="post" name="form1">
		<table id="tblNC-FC" align="center" width="97%" border="0" style="font-family:arial;font-size:13px;" cellspacing="0" cellpadding="0">
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
				<td align="left" colspan="5"><strong>#Lb_Encabezado#</strong></td>
			</tr>
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr><td colspan="5">&nbsp;</td></tr>
			<cfif rsLineasNC.recordCount GT 0 AND rsLineasFC.recordCount GT 0>
				<tr>
					<!--- NOTAS DE CREDITO --->
					<td align="center" colspan="2" width="45%" valign="top">
						<div id="refreshTableNC">
							<table width="100%" border="0" style="font-family:arial;font-size:12px;" cellspacing="0" cellpadding="0">
								<tr><td align="center" colspan="6"><strong>#Lb_LineasNC#: #rsLineasNC.Ddocumento#</strong></td></tr>
								<tr>
									<td width="7%">&nbsp;</td>
									<td width="12%" align="center"><strong>N&uacute;m.</strong></td>
									<td width="12%" align="center"><strong>Item</strong></td>
									<td width="15%" align="center"><strong>IVA</strong></td>
									<td width="15%" align="center"><strong>IEPS</strong></td>
									<td><strong>Concepto</strong></td>
									<td align="center"><strong>Monto</strong></td>
								</tr>
								<cfset countNC = 0>
								<cfloop query="rsLineasNC">
									<cfset countNC++>
									<tr>
										<cfset NCporcentajeIVA = "">
										<cfif Len(Trim(#rsLineasNC.Iporcentaje#)) NEQ 0><cfset NCporcentajeIVA = "#rsLineasNC.Iporcentaje#%"></cfif>
										<td width="7%"><input type="radio" name="radgroupNC" id="radgroupNC_#NCporcentajeIVA#_#rsLineasNC.DDlinea#_#rsLineasNC.totalNC#" value="#rsLineasNC.DDlinea#"></td>
										<td width="12%" align="center">#countNC#</td>
										<td width="12%" align="center">#rsLineasNC.ItemNC#</td>
										<td width="12%" align="center">#NCporcentajeIVA#</td>
										<td width="12%" align="center"><cfif #rsLineasNC.ieps# NEQ -1>#rsLineasNC.ieps&'%'#</cfif></td>
										<td>#rsLineasNC.DescNC#</td>
										<td align="right">#LSCurrencyFormat(rsLineasNC.totalNC,'none')#</td>
									</tr>
								</cfloop>
							</table>
						</div>
					</td>
					<td width="7%">&nbsp;</td>
					<!--- FACTURAS --->
					<td align="center" colspan="2" width="45%" valign="top">
						<div id="refreshTableFC">
							<table width="100%" border="0" style="font-family:arial;font-size:12px;" cellspacing="0" cellpadding="0">
								<tr><td align="center" colspan="6"><strong>#Lb_LineasFC#: #rsLineasFC.Ddocumento#</strong></td></tr>
								<tr>
									<td width="7%">&nbsp;</td>
									<td width="12%" align="center"><strong>N&uacute;m.</strong></td>
									<td width="12%" align="center"><strong>Item</strong></td>
									<td width="15%" align="center"><strong>IVA</strong></td>
									<td width="15%" align="center"><strong>IEPS</strong></td>
									<td><strong>Concepto</strong></td>
									<td align="center"><strong>Monto</strong></td>
								</tr>
								<cfset countFC = 0>
								<cfloop query="rsLineasFC">
									<cfset countFC++>
									<!--- Len(Trim(Form.datos)) NEQ 0 --->
									<tr>
										<cfset FCporcentajeIVA = "">
										<cfif Len(Trim(#rsLineasFC.Iporcentaje#)) NEQ 0><cfset FCporcentajeIVA = "#rsLineasFC.Iporcentaje#%"></cfif>
										<td width="7%"><input type="radio" name="radgroupFC" id="radgroupFC_#FCporcentajeIVA#_#rsLineasFC.DDlinea#_#rsLineasFC.totalFC#" value="#rsLineasFC.DDlinea#"></td>
										<td width="8%" align="center">#countFC#</td>
										<td width="8%" align="center">#rsLineasFC.ItemFC#</td>
										<td width="12%" align="center">#FCporcentajeIVA#</td>
										<td width="12%" align="center"><cfif #rsLineasFC.ieps# NEQ -1>#rsLineasFC.ieps&'%'#</cfif></td>
										<td>#rsLineasFC.DescFC#</td>
										<td align="right">#LSCurrencyFormat(rsLineasFC.totalFC,'none')#</td>
									</tr>
								</cfloop>
							</table>
						</div>
					</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td colspan="5" align="center">
						<!--- <input type="button" name="Agregar" id="Agregar" value="Relacionar" onclick="validaInfo();"> --->
						<input type="button" name="Agregar" id="Agregar" value="Relacionar" onclick="checkSelection();">
					</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td colspan="5">&nbsp;
						<div id="showRelacion"></div>
					</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td colspan="8" align="center">
						<!---
						<input type="button" name="Aceptar" id="Aceptar" value="Aceptar" onclick="validarRelaciones();">
						<input type="button" name="Cancelar" id="Cancelar" value="Cancelar" onclick="deleteInfo()"> --->
						<input type="button" name="Aceptar" id="Aceptar" value="Aceptar" onclick="validarRelaciones();">
						<input type="button" name="Cancelar" id="Cancelar" value="Cancelar" onclick="window.close();">
					</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr><td colspan="5">&nbsp;</td></tr>
			</cfif>
		</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<!--- Javascript --->
<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-1.8.2.min.js"><\/script>')</script>

<script language="JavaScript">

	function checkSelection(){
		var radiosFC = document.querySelectorAll('*[id^="radgroupFC"]');
		var radiosNC = document.querySelectorAll('*[id^="radgroupNC"]');
		var selectedFC = "";
		var selectedNC = "";


		for(var i = 0; i < radiosFC.length; i++){
			if(radiosFC[i].checked){selectedFC = radiosFC[i].id;}
		}
		for(var i = 0; i < radiosNC.length; i++){
			if(radiosNC[i].checked){selectedNC = radiosNC[i].id;}
		}

		if(selectedFC == "" && selectedNC == ""){alert("Escoja una linea de Nota de Credito y una Factura");}
		if(selectedFC == "" && selectedNC != ""){alert("Escoja una linea de factura");}
		if(selectedFC != "" && selectedNC == ""){alert("Escoja una linea de Nota de Credito");}
		if(selectedFC != "" && selectedNC != ""){
			var ivaNC = selectedNC.split('_')[1];
			var ivaFC = selectedFC.split('_')[1];
			if( ivaNC != ivaFC){
				alert("Error al relacionar la NC IVA "+ivaNC+" con la FC IVA "+ivaFC+".\nLas lineas deben coincidir en el IVA.");
			}else{
				guardarInfo(selectedNC.split('_')[2],selectedFC.split('_')[2]);
			}
		}

	}

	function RelacionPorProporcion(radiosFC,radiosNC){
		var SUB_total_factura = 0;
		var IVA_total_factura = 0;
		var SUB_Total_notaCredito = 0;
		var IVA_Total_notaCredito = 0;

		for(var i = 0; i < radiosFC.length; i++){
			var iva = radiosFC[i].id.split('_')[1].replace('%','');
			var total = radiosFC[i].id.split('_')[3];
			var subtotal = total/(1+(iva/100));
			var iva = total - subtotal;
			SUB_total_factura += subtotal;
			IVA_total_factura += iva;
		}
		for(var i = 0; i < radiosNC.length; i++){
			var iva = radiosNC[i].id.split('_')[1].replace('%','');
			var total = radiosNC[i].id.split('_')[3];
			var subtotal = total/(1+(iva/100));
			var iva = total - subtotal;
			SUB_Total_notaCredito += subtotal;
			IVA_Total_notaCredito += iva;
		}

		SUB_Total_notaCredito = round(SUB_Total_notaCredito);
		IVA_Total_notaCredito = round(IVA_Total_notaCredito);
		SUB_total_factura = round(SUB_total_factura);
		IVA_total_factura = round(IVA_total_factura);

	}

	function round(n){
		return Math.round((n+0.00001)*100)/100;
	}

	<!--- Valida existencia de relaciones --->
	function validarRelaciones(){
		var radiosFC = document.querySelectorAll('*[id^="radgroupFC"]');
		var radiosNC = document.querySelectorAll('*[id^="radgroupNC"]');
		var msgConfirm = "";
		-//return false;
		<cfoutput>
			$.ajax({
				method: "post",
			    url: "AjaxRelacionaLineasNcFc.cfc",
			    async:false,
			    data: {
			    	method: "existRelations",
			        returnFormat: "JSON",
			        movAplicacion: "#IdMovimiento#",
			        totalLineas: "#totalLineasPorRelacionar#",
			    },
			    dataType: "json",
			    success: function(obj) {
						if(obj.MSG == 'faltan'){
							alert("Es necesario relacionar todas las líneas!");
						}
						else if(obj.MSG == 'existeOK'){
							msgConfirm = "¿Desea aplicar el documento?";
						}
						else if(obj.MSG == 'noExiste'){
							/*showAlertCero = false;
							for(var i = 0; i < radiosNC.length; i++){
								if(radiosNC[i].id.split('_')[1] == "0%"){ showAlertCero = true; }
							}
							if(showAlertCero){
								alert("Las Notas de Crédito con IVA 0% deben ser asignadas por Línea");
							}else{
								if(confirm("Desea relacionar por proporcion?")){
									RelacionPorProporcion(radiosFC,radiosNC);
								}
							}*/
							msgConfirm = "¿Desea relacionar por proporcion?";
						}
						if (confirm(msgConfirm)) {
							<!--- Aplica el documento  --->
							window.opener.document.getElementById("IDpago").value = "#IdMovimiento#";
							window.opener.document.getElementById("form1").action = "AplicaDocsAfavor.cfm?Aplicar=ok";
							window.opener.document.getElementById("form1").submit();
							window.close();
						}
			    	}
			 });
		</cfoutput>
	}


	function guardarInfo(lineaNC, lineaFC){
		<cfoutput>
			$.ajax({
		        method: "post",
		        url: "AjaxRelacionaLineasNcFc.cfc",
		        async:false, //Validacion si espera o no a que termine ajax
		        data: {
		            method: "guardarRelacionLineas",
		            lineaNC: lineaNC,
		            lineaFC: lineaFC,
		            movAplicacion: "#IdMovimiento#",
		            returnFormat: "JSON"
		        },
		        dataType: "json",
		        success: function(obj) {
					if(obj.MSG == 'InsertOK'){
						showRelacion("#IdMovimiento#");
						refreshTableNC();
						refreshTableFC();
					} else {
						alert(obj.MSG);
					}
		        }
		    });
	    </cfoutput>
	}

	function showRelacion(IdMov) {
	    $.ajax({
	        type: "post",
	        url: "AjaxRelacionaLineasNcFc.cfc",
	        async: false,
	        data: {
	            method: "consultaRelaciones",
	            MovAplicacion: IdMov,
	        },
	        cache: false,
	        success: function(msg) {
	            document.getElementById("showRelacion").innerHTML = msg;
	        }
	    });
	}

	<!--- Refresca tabla principal NC--->
	function refreshTableNC(){
		<cfoutput>
			$.ajax({
			 type:"post",
			 url:"AjaxRelacionaLineasNcFc.cfc",
			 async:false,
			 data: {
		        method: "refreshTableNC",
		        IDdocumento: "#IdNC#",
				movAplicacion: "#IdMovimiento#",
		     },
			 cache:false,
			 success: function(msg) {
			 	document.getElementById("refreshTableNC").innerHTML =  msg;
				}
			});
		</cfoutput>
	}

	<!--- Refresca tabla principal FC--->
	function refreshTableFC(){
		<cfoutput>
			$.ajax({
			 type:"post",
			 url:"AjaxRelacionaLineasNcFc.cfc",
			 async:false,
			 data: {
		        method: "refreshTableFC",
		        IDdocumento: "#IdFC#",
		        movAplicacion: "#IdMovimiento#",
		     },
			 cache:false,
			 success: function(msg) {
			 	document.getElementById("refreshTableFC").innerHTML =  msg;
				}
			});
		</cfoutput>
	}

	<!--- Elimina relacion --->
	function deleteInfo(){
		<cfoutput>
			$.ajax({
				method: "post",
			    url: "AjaxRelacionaLineasNcFc.cfc",
			    async:false, //Validacion si espera o no a que termine ajax
			    data: {
			    	method: "deleteRelacion",
			        returnFormat: "JSON",
			        movAplicacion: "#IdMovimiento#",
			    },
			    dataType: "json",
			    success: function(obj) {
					if(obj.MSG == 'DeleteOK'){
						window.close();
					} else {
						alert(obj.MSG);
					}
			     }
			 });
		</cfoutput>
	}

	<!--- Elimina relacion no deseada --->
	function eliminaUnaRelacion(Id){
		if (confirm('Desea eliminar la relacion de líneas?')) {
			<cfoutput>
				$.ajax({
					method: "post",
				    url: "AjaxRelacionaLineasNcFc.cfc",
				    async:false, //Validacion si espera o no a que termine ajax
				    data: {
				    	method: "deleteUnaRelacion",
				        returnFormat: "JSON",
				        movAplicacion: "#IdMovimiento#",
				        IdLinea: Id,
				    },
				    dataType: "json",
				    success: function(obj) {
						if(obj.MSG == 'DeleteOK'){
							<!--- Actualiza tablas principales --->
							refreshTableNC();
							refreshTableFC();
							showRelacion("#IdMovimiento#");
						} else {
							alert(obj.MSG);
						}
				     }
				 });
			</cfoutput>
		}
	}
</script>