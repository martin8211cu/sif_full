<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

<cfif isdefined("url.impOrden") and isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfoutput>
		function imprimeOrden() {
			var width = 500;
			var height = 200;
			var left = (screen.width-width)/2;
			var top = (screen.height-height)/2;
			var URLStr = "/cfmx/sif/cm/operacion/ordenCompra-resumen.cfm?ESidsolicitud=#url.ESidsolicitud#"
			window.open(URLStr, 'DetalleOrden', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
		imprimeOrden();
	</cfoutput>
</cfif>

<cfif isdefined("url.imprimir") and isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfoutput>
		function imprime() {
			var params ="";
			popUpWindow("/cfmx/sif/cm/operacion/imprimeSolicitud.cfm?ESidsolicitud=#url.ESidsolicitud#",250,200,650,400);
		}
		imprime();
	</cfoutput>
</cfif>

</script>


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

<cfinvoke component="sif.Componentes.CM_CancelaSolicitud" method="CM_getSolicitudesRechazadas" returnvariable="rsLista">
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
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" 				value="#rsLista#"/>
	<cfinvokeargument name="cortes" 			value="CMTSdescripcion"/>
	<cfinvokeargument name="desplegar" 			value="ESnumero, ESobservacion, CentroFunc, ESfecha, NRP, findimg"/>
	<cfinvokeargument name="etiquetas" 			value="N&uacute;mero, Descripci&oacute;n, Centro Funcional, Fecha, NRP, "/>
	<cfinvokeargument name="formatos" 			value="v, V, V, D, V, V"/>
	<cfinvokeargument name="align" 				value="left, left, left, left, right, right"/>
	<cfinvokeargument name="ajustar" 			value="N"/>
	<cfinvokeargument name="radios" 			value="S"/>
	<cfinvokeargument name="irA" 				value="solicitudesRechazadas-form.cfm"/>
	<cfinvokeargument name="botones" 			value="Aplicar"/>
	<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
	<cfinvokeargument name="showLink" 			value="true"/>
	<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
	<cfinvokeargument name="keys" 				value="ESidsolicitud"/>
	<cfinvokeargument name="maxRows" 			value="10"/>
	<cfinvokeargument name="inactivecol" 		value="inactivecol"/>
</cfinvoke>
<script language='javascript' type='text/JavaScript' >
<!--//
	var directa = new Object();
	<cfoutput query="rsLista">directa['#rsLista.ESidsolicitud#'] = #rsLista.CMTScompradirecta#;</cfoutput>
	var solID = "0";

	function hayAlgunoChequeado(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				solID = document.lista.chk.value;
				return (document.lista.chk.checked);
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						solID = document.lista.chk[i].value;
						return true;
					}
				}
			}
		}
		return false;
	}
	
	function funcAplicar(){
		if ( hayAlgunoChequeado() ) {
			var bifurcar = (directa[solID] == 1);
			if (bifurcar) {
				document.lista.ACTION.value='solicitudesRechazadas.cfm';
				document.lista.action = 'ordenCompra-solicitudesRechazadas.cfm';
				return true;
			} else {
				if ( confirm('Desea aplicar las solicitudes seleccionadas?') ){
					document.lista.ACTION.value='solicitudesRechazadas.cfm';
					document.lista.action='solicitudes-sql.cfm';
					return true;
				}
			}
		}
		else{
			alert("Debe seleccionar al menos una solicitud!");
		}	
		return false;
	}
//-->
</script>