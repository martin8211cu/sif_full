<cfset navegacion = "">
<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
	<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
</cfif>
<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
	<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
</cfif>
<cfparam name="form.Ecodigo_f" default="#Session.Ecodigo#">
<!----Verificar si esta encendido el parámetro de múltiples contratos---->
<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo = 730 
</cfquery>

<cfif isdefined("rsParametro_MultipleContrato") and rsParametro_MultipleContrato.Pvalor EQ 1>
	<!----Verificar que el usuario logueado sea un usuario autorizador de OC's---->
	<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#"><!---Maxrows="1" El maxrows es porque aun no se ha indicado si un Usuario puede ser autorizado por mas de 1 comprador---->
		select CMCid from CMUsuarioAutorizado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfif rsUsuario_autorizado.RecordCount NEQ 0>
		<cfset vnCompradores = valueList(rsUsuario_autorizado.CMCid)>
		<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
			<cfset vnCompradores = vnCompradores &','& session.compras.comprador>			
		</cfif>		
	</cfif>
</cfif>

<cfinvoke 
	component="sif.Componentes.CM_CancelaOC"
	method="CM_getOCACancelar"
	returnvariable="rsLista">
        <cfif isdefined("form.EOidorden1") and len(trim(form.EOidorden1))>
			<cfinvokeargument name="Filtro_EOidorden1" value="#form.EOidorden1#">
		</cfif>
		<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
			<cfinvokeargument name="Filtro_SNcodigo" value="#Form.SNcodigoF#">
		</cfif>
		<cfif isdefined("vnCompradores") and len(trim(vnCompradores))>
			<cfinvokeargument name="Comprador" value="#vnCompradores#">
		</cfif>
        <cfinvokeargument name="CancelacionP" value="2">
        <cfinvokeargument name="Ecodigo" value="#form.Ecodigo_f#">
</cfinvoke>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<cfset iCount = 1>

<cfoutput>
    <form name="lista2" id="lista2" method="post" action="ordenCompraACancelar.cfm">
    <cfif lvarProvCorp>
        <input name="Ecodigo_f" type="hidden" value="<cfoutput>#form.Ecodigo_f#</cfoutput>" />
    </cfif>
        <table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
            <cfif isdefined('rsLista') and rsLista.RecordCount GT 0>
                <tr><td nowrap colspan="8" align="center">&nbsp;</td></tr>
                <!---  --->
                <tr style="background-color:##CCCC99; padding:5px;">
                    <td width="6%" nowrap><strong>Orden:</strong>&nbsp;</td>
                    <td width="41%" nowrap>#rsLista.EOnumero#</td>
                    <td width="5%" align="right" nowrap><strong>Fecha:</strong>&nbsp;</td>
                    <td width="10%" nowrap>#LSDateFormat(rsLista.EOfecha,'dd/mm/yyyy')#</td>
                    <td width="7%" align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
                    <td width="12%" nowrap>#rsLista.Mnombre#</td>
                    <td width="17%" align="right" nowrap><strong>Ver Orden de Compra</strong>&nbsp;</td>
                    <td width="2%" align="right" nowrap>
                         <a href="javascript: ventanaSecundaria(#rsLista.EOnumero#,#rsLista.Ecodigo#);"><img border="0" src="../../imagenes/iedit.gif" alt="Muestra la Orden de Compra Completa."></a> 
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
                                <td width="40%" class="tituloListas" nowrap ><strong>Observaciones</strong>&nbsp;</td>
                                <td width="10%" class="tituloListas" nowrap align="right"><strong>Cantidad</strong>&nbsp;</td>
                                <td width="10%" class="tituloListas" nowrap align="right"><strong>Cant.Surtida</strong>&nbsp;</td>
                                <td width="10%" class="tituloListas" nowrap align="right"><strong>Cant.Canc.</strong>&nbsp;</td>
                                <td width="10%" class="tituloListas" nowrap align="right"><strong>Saldo</strong>&nbsp;</td>
                            </tr>
                            <cfloop query="rsLista">
                                <cfset orden = rsLista.EOidorden>
                                <cfset linea = rsLista.DOlinea>
                                
                                <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
                                    <td nowrap width="3%" >
                                        <input type="checkbox" name="chk" id="chk" value="#orden#|#linea#">
                                    </td>
                                    <td nowrap width="5%" >#rsLista.DOconsecutivo#</td>
                                    <td nowrap width="10%">#rsLista.codigo#</td>
                                    <td nowrap width="40%">#rsLista.DOdescripcion#</td>
                                    <td nowrap width="40%">#rsLista.DOobservaciones#</td>
                                    <td nowrap width="10%" align="center">#LSNumberFormat(rsLista.DOcantidad,',9.00')#</td>
                                    <td nowrap width="10%" align="center">#LSNumberFormat(rsLista.DOcantsurtida,',9.00')#</td>
                                    <td nowrap width="10%" align="center">#LSNumberFormat(rsLista.DOcantcancel,',9.00')#</td>
                                    <td nowrap width="10%" align="center">#LSNumberFormat(rsLista.SaldoLinea,',9.00')#</td>
                                    <input type="hidden" name="saldo_#orden#_#linea#" value="#rsLista.SaldoLinea#">
                                </tr>
                                <cfset iCount = iCount + 1>
                            </cfloop>
                        </table>
                    </td>
                </tr>
                <!--- Final del Pintado del Detalle de la Solicitud  --->
                <tr><td nowrap colspan="8" align="center"><hr></td></tr>
                <tr><td nowrap colspan="8" align="center"><input type="submit"  class="btnNormal" name="btnCancelar2" value="Cancelar"  onClick="javascript: return funcCancelar2();"></td></tr>
            <cfelse>
                <tr>
                    <td nowrap colspan="8" align="center">
                        <strong> --- No se encontraron registros --- </strong>&nbsp;
                    </td>
                </tr>
            </cfif>
            <tr><td nowrap colspan="8" align="center">&nbsp;</td></tr>
        </table>
        <input type="hidden" name="CancelarOrdenes" value="2" />
        <input type="hidden" name="textarea_justificacion2" value="">
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

	function ventanaSecundaria (indice, ecodigo){
			var OC =  indice;
			popUpWindow('/cfmx/sif/cm/consultas/OrdenesPendientesDetalleOC.cfm?OC='+OC+'&Ecodigo='+ecodigo,20,20,1100,600);
	}
	
	function hayAlgunoChequeado2(){
		 if (document.lista2.chk) {
			if (document.lista2.chk.value) {
				if (document.lista2.chk.checked)
					return true;
			} 
			else {
				for (var i=0; i<document.lista2.chk.length; i++) {
					if (document.lista2.chk[i].checked) {
						return true;
					}
				}
			}
		} 
		alert("Debe seleccionar al menos una línea de la Orden de Compra!");
		return false;
	}
	function hayJustificacion2(){
		if (document.getElementById("textarea_justificacion").value!='')
			return true;
		alert("<cfoutput>#JSStringFormat('Debe indicar una justificación de la cancelación!')#</cfoutput>");
		document.getElementById("textarea_justificacion").focus();
		return false;
	}
		
	function funcCancelar2(){
		if ( hayAlgunoChequeado2()) {
			if ( hayJustificacion2() ) {
				if ( confirm('Desea cancelar las línea(s) de la Orden seleccionada?') ){
					document.lista2.textarea_justificacion2.value =  document.getElementById("textarea_justificacion").value;
					return true;
				}
			}
		}
		return false;
	}
	
	// Pone el curson en el campo de justificación
	<cfif isdefined('rsLista') and rsLista.RecordCount GT 0>
		document.getElementById("textarea_justificacion").focus();
	</cfif>
</script>