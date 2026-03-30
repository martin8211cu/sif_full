<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
	<cfset navegacion = navegacion & "&fCMTScodigo=#Trim(form.fCMTScodigo)#">
</cfif>
<cfif isdefined("form.fCMTSdescripcion") and len(trim(form.fCMTSdescripcion)) >
	<cfset navegacion = navegacion & "&fCMTSdescripcion=#form.fCMTSdescripcion#">
</cfif>							

<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) >
	<cfset navegacion = navegacion & "&fESnumero=#form.fESnumero#">
</cfif>

<cfif isdefined("form.fESnumero2") and len(trim(form.fESnumero2)) >
	<cfset navegacion = navegacion & "&fESnumero2=#form.fESnumero2#">
</cfif>

<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
	<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
</cfif>
<cfif isdefined("Form.CFid_filtro") and len(trim(form.CFid_filtro)) >
	<cfset navegacion = navegacion & "&CFid_filtro=#form.CFid_filtro#">
</cfif>
<cfif isdefined("Form.CFcodigo_filtro") and len(trim(form.CFcodigo_filtro)) >
	<cfset navegacion = navegacion & "&CFcodigo_filtro=#form.CFcodigo_filtro#">
</cfif>

<cfif isdefined("Form.fESfecha") and len(trim(form.fESfecha))>
	<cfset navegacion = navegacion & "&fESfecha=#form.fESfecha#">
</cfif>

<cfset filtro = filtro & " order by ESfecha desc " >

<cfinvoke 
	component="sif.Componentes.CM_CancelaSolicitud"
	method="CM_getDetalleSolicitudesACancelar"
	returnvariable="rsLista">
		<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones))>
			<cfinvokeargument name="Filtro_ESobservacion" value="#form.fObservaciones#">
		</cfif>
		<cfif isdefined("Form.CFid_filtro") and len(trim(form.CFid_filtro))>
			<cfinvokeargument name="Filtro_CFid" value="#form.CFid_filtro#">
		</cfif>
		<cfif isdefined("Form.fESfecha") and len(trim(form.fESfecha))>
			<cfinvokeargument name="Filtro_ESfecha" value="#form.fESfecha#">
		</cfif>
		<cfif isdefined("Form.fESnumero") and len(trim(form.fESnumero))>
			<cfinvokeargument name="Filtro_ESnumero" value="#form.fESnumero#">
		</cfif>
		<cfif isdefined("Form.fESnumero2") and len(trim(form.fESnumero2))>
			<cfinvokeargument name="Filtro_ESnumeroH" value="#form.fESnumero2#">
		</cfif>
		<cfif isdefined("Form.fCMTScodigo") and len(trim(form.fCMTScodigo))>
			<cfinvokeargument name="Filtro_CMTScodigo" value="#form.fCMTScodigo#">
		</cfif>
</cfinvoke>

<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<cfset iCount = 1>
<form name="lista" method="post" action="cancelarSolicitudCompra.cfm">
	<fieldset>
	<legend>Justificación</legend>
		<table align="center"  border="0" cellspacing="0" cellpadding="0">
  			<tr>
    			<td><textarea name="textarea_justificacion" rows="3" cols="125"></textarea></td>
  			</tr>
  			<tr>
    			<td class="Ayuda" align="center"><span class="style1">Ind&iacute;que en esta &aacute;rea el motivo de la cancelaci&oacute;n!</span></td>
  			</tr>
		</table>
	</fieldset>
	<br>
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="cortes" value="CMTSdescripcion,Solicitud"/>
		<cfinvokeargument name="desplegar" value="DSconsecutivo, codigo, DSdescripcion, DScant, DScantsurt, Ucodigo, CFcodigo, Almcodigo, Impuesto, DStotallinest"/>
		<cfinvokeargument name="etiquetas" value="L&iacute;nea, C&oacute;digo, &Iacute;tem, Cant., Cant.Surt., Unidad, Ctro.Funcional, Almac&eacute;n, Impuesto, Total Estimado L&iacute;nea"/>
		<cfinvokeargument name="formatos" value="V, V, V, I, I, V, V, V, V, M"/>
		<cfinvokeargument name="align" value="left, left, left, right, right, left, left, left, left, right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="S"/>
		<cfinvokeargument name="irA" value="cancelarSolicitudCompra.cfm"/>
		<cfinvokeargument name="botones" value="Cancelar"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="keys" value="ESidsolicitud,DSlinea"/>
		<cfinvokeargument name="maxRows" value="10"/>
		<cfinvokeargument name="formname" value="lista"/>
		<cfinvokeargument name="incluyeform" value="false"/>
		<cfinvokeargument name="funcion" value="doConlis"/>
		<cfinvokeargument name="fparams" value="ESidsolicitud,ESestado"/>
	</cfinvoke>
</form>

<script language='javascript' type='text/JavaScript' >
<!--//

// Funcion para mostrar popup con datos de la solicitud 
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor,estado) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+valor+"&ESestado="+estado,20,20,900,600);
	}
//------
	function hayAlgunoChequeado(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				if (document.lista.chk.checked)
					return true;
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) 
						return true;
				}
			}
		}
		alert("Debe seleccionar al menos una solicitud!");
		return false;
	}
	function hayJustificacion(){
		if (document.lista.textarea_justificacion.value!='')
			return true;
		alert("<cfoutput>#JSStringFormat('Debe indicar una justificación!')#</cfoutput>");
		document.lista.textarea_justificacion.focus();
		return false;
	}
	function funcCancelar(){
		if ( hayAlgunoChequeado() && hayJustificacion() ) {
			if ( confirm('Desea cancelar las solicitudes seleccionadas?') ){
				return true;
			}
		}
		return false;
	}
	document.lista.textarea_justificacion.focus();
//-->
</script>
