
<cfset navegacion = "">
<cfif isdefined("url.LvarXML") and len(trim(url.LvarXML)) >
	<cfset paginaSQL = #url.LvarXML#>
<cfelse>
	<cfset paginaSQL = "SQLGenerarXMLPolizasAuxiliar">
</cfif>
<cfif isdefined("url.lote") and len(trim(url.lote)) >
	<cfset navegacion = navegacion & "&lote=#url.lote#">
</cfif>
<cfif isdefined("url.poliza") and len(trim(url.poliza)) >
	<cfset navegacion = navegacion & "&poliza=#url.poliza#">
</cfif>
<cfif isdefined("url.descripcion") >
	<cfset navegacion = navegacion & "&Referencia=#JSStringFormat(url.descripcion)#">
</cfif>
<cfif isdefined("url.fi") >
	<cfset navegacion = navegacion & "&fechaIni=#url.fi#">
</cfif>
<cfif isdefined("url.ff") >
	<cfset navegacion = navegacion & "&fechaFin=#url.ff#">
</cfif>
<cfif isdefined("url.periodo") >
	<cfset navegacion = navegacion & "&periodo=#url.periodo#">
</cfif>
<cfif isdefined("url.mes")>
	<cfset navegacion = navegacion & "&mes=#url.mes#">
</cfif>
<cfif isdefined("url.ECusuario")>
	<cfset navegacion = navegacion & "&ECusuario=#url.ECusuario#">
</cfif>
<cfif isdefined("url.fechaGenIni") >
	<cfset navegacion = navegacion & "&fechaGenIni=#url.fechaGenIni#">
</cfif>
<cfif isdefined("url.fechaGenFin") >
	<cfset navegacion = navegacion & "&fechaGenFin=#url.fechaGenFin#">
</cfif>
<cfif isdefined("url.ver")>
	<cfset navegacion = navegacion & "&ver=#url.ver#">
</cfif>
<cfif isdefined("url.origen")>
	<cfset navegacion = navegacion & "&origen=#url.origen#">
</cfif>
<cfif isdefined("url.moneda")>
	<cfset navegacion = navegacion & "&moneda=#url.moneda#">
</cfif>
<cfif isdefined("url.documento")>
	<cfset navegacion = navegacion & "&documento=#url.documento#">
</cfif>
<cfif isdefined("url.chk")>
	<cfset navegacion = navegacion & "&chk=#url.chk#">
</cfif>
<cfif isdefined("url.Referencia")>
	<cfset navegacion = navegacion & "&Referencia=#url.Referencia#">
</cfif>
<BODY onload="RecuperaDatos();">

	<cfform action="#paginaSQL#.cfm" method="post" name="formXML" style="margin:0;" onSubmit="return sinbotones()">
		<br>


		<table width="100%"  border="0" cellspacing="1" cellpadding="1"  align="center" class="AreaFiltro">
			<tr><td colspan="2"><strong style="font-family: Arial, Helvetica, sans-serif;font-size: 14px;">Favor de proporcionar los siguientes datos:</strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td style="font-family: Arial, Helvetica, sans-serif;font-size: 14px;" align="right"><strong>Tipo Solicitud:</strong></td>
				<td>
					 <select name="tipoSolicitud" id="tipoSolicitud" style="width:180px" onchange="changeVal(this);">
					  <option value="-1">--Seleccione--</option>
					  <option value="AF">Acto de Fiscalizaci&oacute;n</option>
					  <option value="CO">Compensaci&oacute;n</option>
					  <option value="DE">Devoluci&oacute;n</option>
					  <option value="FC">Fiscalizaci&oacute;n Compulsa</option>
					</select>
				</td>
			</tr>
			<tr id="trnumOrden">
				<td style="font-family: Arial, Helvetica, sans-serif;font-size: 14px;" align="right"><strong>N&uacute;m. Orden:</strong></td>
				<td>
					<input type"text" id="numOrden" name="numOrden" size="25"></input>
				</td>
			</tr>
			<tr id="trnumTramite">
				<td style="font-family: Arial, Helvetica, sans-serif;font-size: 14px;" align="right"><strong>N&uacute;m. Tr&aacute;mite:</strong></td>
				<td>
					<input type"text" id="numTramite" name="numTramite" size="25"></input>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="button" onclick="validaCampos()" value="Generar"></td>
			</tr>
		</table>
	</cfform>

</BODY>
<script language="javascript" type="text/javascript">
	function changeVal(obj){
		if(obj.value == 'AF' || obj.value == 'FC'){
			document.getElementById('numTramite').value = "";
			document.getElementById('trnumTramite').style.display = 'none';
			document.getElementById('trnumOrden').style.display = '';
		}else{
			document.getElementById('trnumTramite').style.display = '';
			document.getElementById('numOrden').value = "";
			document.getElementById('trnumOrden').style.display = 'none';
		}
	}

	function validaCampos()
	{
		var tipoSolicitud = document.getElementById("tipoSolicitud").value;
		var numOrden = document.getElementById('numOrden');
		var numTramite = document.getElementById('numTramite');
		var url = "";
		var stop = false;

		if(tipoSolicitud == "-1"){
			alert('Favor de seleccionar un tipo de solicitud.');
			tipoSolicitud.focus();
			stop = true;
		}else if(tipoSolicitud == "AF" || tipoSolicitud == "FC"){
			if(numOrden.value == ""){
				alert('Para este tipo de Solicitud, el numero de orden es requerido.')
				numOrden.focus()
				stop = true;
			}else{
				stop = false;
			}
		}
		if(tipoSolicitud == "DE" || tipoSolicitud == "CO"){
			if(numTramite.value == ""){
				alert('Para este tipo de Solicitud, el numero de tramite es requerido.')
				numTramite.focus()
				stop = true;
			}else{
				stop = false;
			}
		}
		if(!stop){
			Devuelve();
		}
	}


	//creamos una variable de tipo array para recuperar y devolver los datos
	var datos=new Array();
	//aqui recuperamos los datos de la ventana padre
	function RecuperaDatos(){
		datos=dialogArguments;
		tipoSolicitud.value=datos[0];
		numOrden.value=datos[1];
		numTramite.value=datos[2];
		}
	//aqui le devolvemos los datos a la ventana padre
	function Devuelve(){
		datos[0]=document.getElementById("tipoSolicitud").value;
		datos[1]=document.getElementById("numOrden").value;
		datos[2]=document.getElementById("numTramite").value;
		returnValue = datos;
		window.close();
	}

</script>