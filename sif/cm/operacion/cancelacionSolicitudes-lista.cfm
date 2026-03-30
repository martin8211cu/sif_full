<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) >
	<cfset navegacion = navegacion & "&fESnumero=#Trim(form.fESnumero)#">
</cfif>
<cfif isdefined("form.fESobservacion") and len(trim(form.fESobservacion)) >
	<cfset navegacion = navegacion & "&fESobservacion=#form.fESobservacion#">
</cfif>							

<cfinvoke 
	component="sif.Componentes.CM_CancelaSolicitud"
	method="CM_getCancelacionSolicitudes" 
	returnvariable="rsLista">
		<cfif isdefined("Form.fESnumero") and len(trim(form.fESnumero))>
			<cfinvokeargument name="Filtro_ESnumero" value="#form.fESnumero#">
		</cfif>
		<cfif not(IsDefined("session.compras.solicitante") and Len(Trim(session.compras.solicitante)))>
			<cfinvokeargument name="Solicitante" value="0">
		</cfif>		
</cfinvoke>

<cfset iCount = 1>

<cfoutput>
<form name="lista" method="post" action="cancelacionSolicitudes.cfm" >
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<cfif isdefined('rsLista') and rsLista.RecordCount GT 0>
			<tr>
				<td nowrap colspan="8" align="center">
					<fieldset>
					<legend>Justificación</legend>
						<table align="center"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><textarea name="textarea_justificacion" rows="3" cols="125"></textarea></td>
							</tr>
							<tr>
								<td class="Ayuda" align="center" style="color: ##FF0000; ">
									Ind&iacute;que en esta &aacute;rea el motivo de la cancelaci&oacute;n!
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<!---  --->
			<tr><td nowrap colspan="8" align="center">&nbsp;</td></tr>
			<!---  --->
			<tr style="background-color:##CCCC99; padding:5px;">
				<td width="6%" nowrap><strong>Solicitud:</strong>&nbsp;</td>
				<td width="41%" nowrap>#rsLista.Solicitud#</td>
				<td width="5%" align="right" nowrap><strong>Fecha:</strong>&nbsp;</td>
				<td width="10%" nowrap>#LSDateFormat(rsLista.ESfecha,'dd/mm/yyyy')#</td>
				<td width="7%" align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
				<td width="12%" nowrap>#rsLista.Mnombre#</td>
				<td width="17%" align="right" nowrap><strong>Ver Solicitud de Compra</strong>&nbsp;</td>
				<td width="2%" align="right" nowrap>
					<a href="javascript: doConlis(#rsLista.ESidsolicitud#,#rsLista.ESestado#)"><img border="0" src="../../imagenes/iedit.gif" alt="Muestra la Solicitud de Compra Completa."></a>
				</td>

			</tr>
			<!--- Inicio del Pintado del Detalle de la Solicitud --->
			<tr>
				<td nowrap colspan="8" >
					<table  width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="3%"  class="tituloListas" nowrap >&nbsp;</td>
							<td width="5%"  class="tituloListas" nowrap ><strong>L&iacute;nea</strong>&nbsp;</td>
							<td width="10%" class="tituloListas" nowrap ><strong>C&oacute;digo</strong>&nbsp;</td>
							<td width="40%" class="tituloListas" nowrap ><strong>&Iacute;tem</strong>&nbsp;</td>
							<td width="10%" class="tituloListas" nowrap align="right"><strong>Cantidad</strong>&nbsp;</td>
							<td width="10%" class="tituloListas" nowrap align="right"><strong>Cant.Surtida</strong>&nbsp;</td>
							<td width="10%" class="tituloListas" nowrap align="right"><strong>Saldo</strong>&nbsp;</td>
						</tr>
						<cfloop query="rsLista">
							<cfset solic = rsLista.ESidsolicitud>
							<cfset linea = rsLista.DSlinea>
							
							<tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
								<td nowrap width="3%" >
									<input type="checkbox" name="chk" id="chk" value="#solic#|#linea#">
								</td>
								<td nowrap width="5%" >#rsLista.DSconsecutivo#</td>
								<td nowrap width="10%">#rsLista.codigo#</td>
								<td nowrap width="40%">#rsLista.DSdescripcion#</td>
								<td nowrap width="10%" align="right">#LSNumberFormat(rsLista.DScant,',9.00')#</td>
								<td nowrap width="10%" align="right">#LSNumberFormat(rsLista.DScantsurt,',9.00')#</td>
								<td nowrap width="10%" align="right">#LSNumberFormat(rsLista.SaldoLinea,',9.00')#</td>
								<input type="hidden" name="saldo_#solic#_#linea#" value="#rsLista.SaldoLinea#">
							</tr>
							<cfset iCount = iCount + 1>
						</cfloop>
					</table>
				</td>
			</tr>
			<!--- Final del Pintado del Detalle de la Solicitud  --->
			<tr><td nowrap colspan="8" align="center"><hr></td></tr>
			<tr><td nowrap colspan="8" align="center"><input type="submit" name="btnCancelar" value="Cancelar"  onClick="javascript:return funcCancelar()"></td></tr>
		<cfelse>
			<tr>
				<td nowrap colspan="8" align="center">
					<strong> --- No se encontraron registros --- </strong>&nbsp;
				</td>
			</tr>
		</cfif>
		<tr><td nowrap colspan="8" align="center">&nbsp;</td></tr>
	</table>
</form>
</cfoutput>

<script language='javascript' type='text/JavaScript' >
	// Funcion para mostrar pop-up con datos de la Solicitud de Compra.
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
	
	function hayAlgunoChequeado(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				if (document.lista.chk.checked)
					return true;
			} 
			else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) {
						return true;
					}
				}
			}
		}
		alert("Debe seleccionar al menos una línea de la Solicitud de Compra!");
		return false;
	}
	function hayJustificacion(){
		if (document.lista.textarea_justificacion.value!='')
			return true;
		alert("<cfoutput>#JSStringFormat('Debe indicar una justificación de la cancelación!')#</cfoutput>");
		document.lista.textarea_justificacion.focus();
		return false;
	}
		
	function funcCancelar(){
		if ( hayAlgunoChequeado() ) {
			if ( hayJustificacion() ) {
				if ( confirm('Desea cancelar las línea(s) de solicitud(es) seleccionada(s)?') ){
					return true;
				}
			}
		}
		return false;
	}
	
	// Pone el curson en el campo de justificación
	<cfif isdefined('rsLista') and rsLista.RecordCount GT 0>
	document.lista.textarea_justificacion.focus();
	</cfif>
</script>
