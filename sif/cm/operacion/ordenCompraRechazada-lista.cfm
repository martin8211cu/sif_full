<cfif isdefined("url.imprimir") and isdefined("url.EOidorden") and len(trim(url.EOidorden))>
	<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		var popUpWin = 0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
	
		function imprime() {
			var params ="";
			popUpWindow("/cfmx/sif/cm/operacion/imprimeOrden.cfm?EOidorden=#url.EOidorden#&tipoImpresion=1",250,200,650,400);
		}
		imprime();
	</script>
	</cfoutput>
</cfif>

<cfset navegacion = "">
<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
	<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
</cfif>
<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2)) >
	<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero2#">
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

<cfinvoke 
	component="sif.Componentes.CM_CancelaOC"
	method="CM_getOCRechazadas"
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
</cfinvoke>
<cfinvoke component="sif.Componentes.pListas"	method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="cortes" value="CMTOdescripcion"/>
	<cfinvokeargument name="desplegar" value="EOnumero, Observaciones, EOfecha, SNnombre, Mnombre, EOtotal, NRP, findimg"/>
	<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Fecha, Proveedor, Moneda, Total, NRP, "/>
	<cfinvokeargument name="formatos" value="V,V,D,V,V,M,V,V"/>
	<cfinvokeargument name="align" value="left,left,center,left,left,right,right,right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="radios" value="S"/>
	<cfinvokeargument name="irA" value="ordenCompraRechazada-form.cfm"/>
	<cfinvokeargument name="keys" value="EOidorden"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="botones" value="Aplicar"/>
	<cfinvokeargument name="maxRows" value="10"/>
	<cfinvokeargument name="inactivecol" value="inactivecol"/>
</cfinvoke>
<script language='javascript' type='text/JavaScript' >
<!--//
	function hayAlgunoChequeado(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				return (document.lista.chk.checked);
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) return true;
				}
			}
		}
		return false;
	}
	function funcAplicar(){
		if ( hayAlgunoChequeado() ) {
			if ( confirm('Desea aplicar las ordenes de compra seleccionadas?') ){
				document.lista.ACTION.value='ordenCompraRechazada.cfm';
				document.lista.action='ordenCompra-sql.cfm';
				return true;
			}
		}
		else{
			alert("Debe seleccionar al menos una orden de compra!");
		}	
		return false;
	}
//-->
</script>