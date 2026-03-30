<cfset navegacion = "">
<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
	<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
</cfif>
<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2)) >
	<cfset navegacion = navegacion & "&fEOnumero2=#form.fEOnumero2#">
</cfif>
<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
	<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
</cfif>
<cfif isdefined("Form.fEOfecha") and len(trim(form.fEOfecha))>
	<cfset navegacion = navegacion & "&fEOfecha=#form.fEOfecha#">
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
		<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>
			<cfinvokeargument name="Filtro_EOnumero" value="#form.fEOnumero#">
		</cfif>
		<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
			<cfinvokeargument name="Filtro_EOnumero2" value="#form.fEOnumero2#">
		</cfif>
		<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones))>
			<cfinvokeargument name="Filtro_Observaciones" value="#form.fObservaciones#">
		</cfif>
		<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
			<cfinvokeargument name="Filtro_SNcodigo" value="#Form.SNcodigoF#">
		</cfif>
		<cfif isdefined("Form.fEOfecha") and len(trim(form.fEOfecha))>
			<cfinvokeargument name="Filtro_EOfecha" value="#form.fEOfecha#">
		</cfif>
		<cfif isdefined("vnCompradores") and len(trim(vnCompradores))>
			<cfinvokeargument name="Comprador" value="#vnCompradores#">
		</cfif>
        <cfinvokeargument name="Ecodigo" value="#form.Ecodigo_f#">
</cfinvoke>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
<form name="lista1" method="post" action="ordenCompraACancelar.cfm">
<cfif lvarProvCorp>
	<input name="Ecodigo_f" type="hidden" value="<cfoutput>#form.Ecodigo_f#</cfoutput>" />
</cfif>
<br>
<cfinvoke component="sif.Componentes.pListas"	method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="cortes" value="CMTOdescripcion"/>
	<cfinvokeargument name="desplegar" value="EOnumero, Observaciones, EOfecha, SNnombre, Mnombre, EOtotal"/>
	<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Fecha, Proveedor, Moneda, Total"/>
	<cfinvokeargument name="formatos" value="V,V,D,V,V,V,M"/>
	<cfinvokeargument name="align" value="left,left,center,left,left,right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="checkboxes" value="S"/>
	<cfinvokeargument name="irA" value="ordenCompraACancelar.cfm"/>
	<!---<cfinvokeargument name="irA" value="../consultas/OrdenesCompra-vista.cfm "/>--->
	<cfinvokeargument name="keys" value="EOidorden"/>
	<cfinvokeargument name="funcion" value="doConlis"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="fparams" value="EOidorden"/>
	<!---<cfinvokeargument name="showLink" value="true"/>--->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="botones" value="Cancelar"/>
	<cfinvokeargument name="maxRows" value="15"/>
	<cfinvokeargument name="formname" value="lista1"/>
	<cfinvokeargument name="incluyeform" value="false"/>
</cfinvoke>
<input type="hidden" name="CancelarOrdenes" value="1">
<input type="hidden" name="textarea_justificacion1" value="">
</form>
<script language='javascript' type='text/JavaScript' >
<!--//

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?Ecodigo=<cfoutput>#form.Ecodigo_f#</cfoutput>&EOidorden="+valor,10,10,1000,550);
	}
	
	function hayAlgunoChequeado(){
		if (document.lista1.chk) {
			if (document.lista1.chk.value) {
				if (document.lista1.chk.checked)
					return true;
			} else {
				for (var i=0; i<document.lista1.chk.length; i++) {
					if (document.lista1.chk[i].checked) return true;
				}
			}
		}
		alert("Debe seleccionar al menos una orden de compra!");
		return false;
	}
	function hayJustificacion(){
		if (document.getElementById("textarea_justificacion").value!='')
			return true;
		alert("<cfoutput>#JSStringFormat('Debe indicar una justificación!')#</cfoutput>");
		document.getElementById("textarea_justificacion").focus();
		return false;
	}
	function funcCancelar(){
		if ( hayAlgunoChequeado() && hayJustificacion()) {
			if ( confirm('Desea cancelar las ordenes de compra seleccionadas?') ){
				document.lista1.textarea_justificacion1.value =  document.getElementById("textarea_justificacion").value;
				return true;
			}
		}
		return false;
	}
	document.getElementById("textarea_justificacion").focus();
//-->
</script>