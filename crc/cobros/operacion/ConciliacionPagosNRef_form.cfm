<cfset Modo = ''>
<cfset aprobador = 0>
<cfif isDefined('form.Modo') and form.Modo eq 'Alta'>
	<cfset Modo = 'Alta'>
<cfelseif isDefined('form.BotonSel') and form.BotonSel eq 'btnNuevo'>
	<cfset Modo = 'Alta'>
<cfelseif isDefined('form.Modo') and form.Modo eq 'Cambio'>
	<cfset Modo = 'Cambio'>
</cfif>
<cfif isDefined('form.PNRId') and len(trim(form.PNRId)) gt 0 and form.PNRId neq ''>
	<cfset Modo = 'Cambio'>
</cfif>
<cfif isDefined('form.Aprobador') and len(form.Aprobador)>
	<cfset aprobador = form.Aprobador>
</cfif>
<cfset styleAlta = "visibility: visible;">
<cfset styleCambio = "visibility: collapse;">
<cfset styleCuenta = "visibility: collapse;">
<cfset styleInputs = "">
<cfif Modo eq 'Cambio'>
	<cfset styleAlta = "visibility: collapse;">
	<cfset styleCambio = "visibility: visible;">
	<cfset styleCuenta = "visibility: visible;">
	<cfset styleInputs = "readonly">
</cfif>
<cfset conciliaPagos =  createObject("component","crc.cobros.operacion.ConciliacionPagosNRef")>

<cfset referencia = "">
<cfset monto = 0>
<cfset PNRId = "">
<cfset _cuenta = "">
<cfif isdefined('form.PNRId') and Modo eq 'Cambio' >
	<cfset _cuenta = conciliaPagos.obtieneCuenta(form.PNRId)>
</cfif>

<cfif isDefined('form.PNRReferencias') and len(form.PNRReferencias)>
	<cfset referencia = form.PNRReferencias>
</cfif>
<cfif isDefined('form.PNRMonto') and len(form.PNRMonto)>
	<cfset monto = form.PNRMonto>
</cfif>
<cfif isDefined('form.PNRId') and len(form.PNRId)>
	<cfset PNRId = form.PNRId>
</cfif>

<cf_templateheader title="Conciliación de pagos no referenciados">
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
                <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conciliación de pagos no referenciados'>
					<form style="margin: 0" name="form1" method="post" id="form1" action="ConciliacionPagosNRef_sql.cfm">
						<!--- Tag para loading --->
						<cf_loadingSIF>
						<cfoutput>
						<input name="PNRId" id="PNRId" hidden value="#PNRId#">
						<input name="Aprobador" id="Aprobador" hidden value="#aprobador#">
						<table width="50%" align="center">
							<tr>
								<td>Fecha:&nbsp;</td>
								<td>
									<cfif isdefined("form.PNRFecha") and len(form.PNRFecha)>
										<cf_sifcalendario  form="frequisicion" name="fEAFecha" id="fEAFecha" value="#form.PNRFecha#" readonly="true">
									<cfelse>
										<cf_sifcalendario  form="frequisicion" name="fEAFecha" id="fEAFecha">
									</cfif>
								</td>
							</tr>
							<tr>
								<td>Referencias:&nbsp;</td>
								<td>
									<input #styleInputs# type="text" name="fEAReferencias" id="fEAReferencias" value="#referencia#" size="50">
								</td>
							</tr>
							<tr>
								<td>Monto:&nbsp;<br><br><br></td>
								
								<td>
									<input #styleInputs# type="number" name="fEAMonto" id="fEAMonto" value="#monto#" size="50">
									<br><br><br>
								</td>
							</tr>
							<tr style="#styleCuenta#" id="idCuenta">
								<td>Cuenta:&nbsp;<br><br><br></td>
								<td>
									<cf_conlis
									Campos="id,Numero, SNnombre, Tipo"
									Desplegables="N,S,S,S"
									Modificables="N,S,N,N"
									Size="0,10,30,20"
									valuesArray="#_cuenta#"
									tabindex="2"
									Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
									Columnas="cc.id,Numero,SNnombre, Tipo = case 
											when Tipo = 'D' then 'Distribuidor'
											when Tipo = 'TC' then 'Tarjeta de Credito'
											when Tipo = 'TM' then 'Tarjeta Mayorista' 
											end"
									form="form1"
									Filtro="sn.Ecodigo = #Session.Ecodigo#
											order by SNnombre"
									Desplegar="Numero, SNnombre, Tipo"
									Etiquetas="Numero, Nombre, Tipo"
									filtrar_por="Numero, SNnombre, Tipo"
									Formatos="S,S,S,S"
									Align="left,left, left, left"
									Asignar="id,Numero,SNnombre, Tipo"
									Asignarformatos="S,S,S,S"
									funcion = "validaTipo()"/>
									<br><br><br>
								</td>
								
							</tr>
							<cfif aprobador eq 0>
								<tr align="center" style="#styleCambio#" id="btnsCambio">
									<td colspan="2">
										<cf_botones values="Actualizar, Eliminar, Aplicar, Nuevo, Regresar" names="Guardar, Eliminar, Aplicar, Nuevo, Regresar">
									</td>
								</tr>
								<tr align="center" style="#styleAlta#"  id="btnsAlta">
									<td colspan="2">
										<cf_botones values="Agregar, Limpiar, Regresar" names="Agregar, Limpiar, Regresar">
									</td>
								</tr>
							<cfelse>
								<tr align="center" style="#styleCambio#" id="btnsCambio">
									<td colspan="2">
										<cf_botones values="Aprobar,Rechazar,Regresar" names="Aprobar, Rechazar, Regresar">
									</td>
								</tr>
							</cfif>
						</table>
						</cfoutput>
					</form>
				 <cf_web_portlet_end>
            </td>	
        </tr>
    </table>	
<cf_templatefooter>

<script language="JavaScript1.2" type="text/javascript">
	$( document ).ready(function() {
		hideLoading();
	});
	function valida(){
		if(document.form1.fEAFecha.value == ""){
			alert("Debe ingresar la fecha");
			document.form1.fEAFecha.focus();
			return false;
		}
		if(document.form1.fEAReferencias.value == ""){
			alert("Debe ingresar la referencia");
			document.form1.fEAReferencias.focus();
			return false;
		}
		if(document.form1.fEAMonto.value == ""){
			alert("Debe ingresar el monto");
			document.form1.fEAMonto.focus();
			return false;
		}
		if(document.form1.fEAMonto.value <= 0){
			alert("El monto debe ser mayor a 0");
			document.form1.fEAMonto.focus();
			return false;
		}
		return true;
	}
	function funcAgregar(){	
		event.preventDefault();
		if(valida()){
			showLoading();
			var Control    = "/cfmx/crc/cobros/operacion/ConciliacionPagosNRef.cfc";
			var parametros = "";
			
			parametros += "method=validaExistencia";
			parametros += "&fecha="+ document.form1.fEAFecha.value;	
			parametros += "&referencia="+ document.form1.fEAReferencias.value;
			parametros += "&monto="+ document.form1.fEAMonto.value;

			parametros=encodeURI(parametros);
			/*Peticion AJAX*/
			$.ajax ({
				url: Control + "?" + parametros,
				type: "get",
				dataType: "json",

				beforeSend: function() {},
				success: function(data) {
					hideLoading();
					if(typeof(data.MESSAGE) != 'undefined'){
						alert(data.MESSAGE);
						return false;
					}
					else if(data > 0){
						alert("Registro encontrado");
						document.getElementById('idCuenta').style.visibility = 'visible';
						document.getElementById('btnsCambio').style.visibility = 'visible';
						document.getElementById('btnsAlta').style.visibility = 'collapse';
						document.getElementById('fEAReferencias').readOnly = true;
						document.getElementById('fEAMonto').readOnly = true;
						document.form1.PNRId.value = data;
						<cfset modo = 'Cambio'>
					}
					return false;
				},
				error: function() {
					hideLoading();
					alert("Ocurrió un problema al consultar las referencias");
					return false;
				}
			});
		}
	}
	function funcEliminar(ref='ConciliacionPagosNRef.cfm'){	
		event.preventDefault();
		if (window.confirm("¿Desea eliminar el registro?")) {
			showLoading();
			var Control    = "/cfmx/crc/cobros/operacion/ConciliacionPagosNRef.cfc";
			var parametros = "";
			
			parametros += "method=EliminarRegistro";
			parametros += "&PNRId="+ document.form1.PNRId.value;	
	
			parametros=encodeURI(parametros);
			/*Peticion AJAX*/
			$.ajax ({
				url: Control + "?" + parametros,
				type: "get",
				dataType: "json",

				beforeSend: function() {},
				success: function(data) {
					hideLoading();
					if(typeof(data.MESSAGE) != 'undefined'){
						alert(data.MESSAGE);
					}
					setTimeout(() => {
						window.location.href=ref;
					}, "1000");	
				},
				error: function() {
					hideLoading();
					alert("Ocurrió un problema al eliminar las referencias");
					return false;
				}
			});
		}
	}
	function funcGuardar(){
		event.preventDefault();
		if(document.getElementById('id').value == ""){
			alert("Debe ingresar la cuenta");
			document.form1.Numero.focus();
			return false;
		}
		showLoading();
		var Control    = "/cfmx/crc/cobros/operacion/ConciliacionPagosNRef.cfc";
		var parametros = "";
		
		parametros += "method=ActualizaRegistro";
		parametros += "&PNRId="+ document.form1.PNRId.value;
		parametros += "&idCuenta="+ document.getElementById('id').value;
		
		parametros=encodeURI(parametros);
		/*Peticion AJAX*/
		$.ajax ({
			url: Control + "?" + parametros,
			type: "get",
			dataType: "json",

			beforeSend: function() {},
			success: function(data) {
				hideLoading();
				if(typeof(data.MESSAGE) != 'undefined'){
					alert(data.MESSAGE);
				}
			},
			error: function() {
				hideLoading();
				alert("Ocurrió un problema al actualizar la cuenta");
				return false;
			}
		});
	}
	function funcRegresar(){
		event.preventDefault();
		<cfif aprobador eq 0>
			window.location.href='ConciliacionPagosNRef.cfm';
		<cfelse>
			window.location.href='ConciliacionPagosNRef-Aprobador.cfm';
		</cfif>	
	}
	function funcNuevo(){
		event.preventDefault();
		window.location.href='ConciliacionPagosNRef_form.cfm';
	}
	function funcAplicar(){
		event.preventDefault();
		if (window.confirm("¿Desea mandar a aprobar el registro?")) {
			if(document.getElementById('id').value == ""){
				alert("Debe ingresar la cuenta");
				document.form1.Numero.focus();
				return false;
			}
			showLoading();
			var Control    = "/cfmx/crc/cobros/operacion/ConciliacionPagosNRef.cfc";
			var parametros = "";
			
			parametros += "method=AplicaRegistro";
			parametros += "&PNRId="+ document.form1.PNRId.value;		
			parametros=encodeURI(parametros);
			/*Peticion AJAX*/
			$.ajax ({
				url: Control + "?" + parametros,
				type: "get",
				dataType: "json",

				beforeSend: function() {},
				success: function(data) {
					hideLoading();
					if(typeof(data.MESSAGE) != 'undefined'){
						if(data.MESSAGE == "No se ha actualizado la cuenta"){
							alert(data.MESSAGE);
						}else{
							alert(data.MESSAGE);
							setTimeout(() => {
								window.location.href='ConciliacionPagosNRef.cfm';
							}, "1000");	
						}
					}
				},
				error: function() {
					hideLoading();
					alert("Ocurrió un problema al aplicar la conciliación");
					return false;
				}
			});
		}
	}
	function funcAprobar(){
		if (window.confirm("¿Desea aprobar el registro?")) {
			showLoading();
			return true;
		}else return false;
	}
	function funcRechazar(){
		event.preventDefault();
		if (window.confirm("¿Desea rechazar el registro?")) {
			showLoading();
			var Control    = "/cfmx/crc/cobros/operacion/ConciliacionPagosNRef.cfc";
			var parametros = "";
			
			parametros += "method=RechazarRegistro";
			parametros += "&PNRId="+ document.form1.PNRId.value;	
	
			parametros=encodeURI(parametros);
			/*Peticion AJAX*/
			$.ajax ({
				url: Control + "?" + parametros,
				type: "get",
				dataType: "json",

				beforeSend: function() {},
				success: function(data) {
					hideLoading();
					if(typeof(data.MESSAGE) != 'undefined'){
						alert(data.MESSAGE);
					}
					window.location.href='ConciliacionPagosNRef-Aprobador.cfm';
				},
				error: function() {
					hideLoading();
					alert("Ocurrió un problema al rechazar las referencias");
					return false;
				}
			});
		}
	}
	
</script>