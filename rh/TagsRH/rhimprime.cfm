<!--- 
	Modificado por Gustavo Fonseca H.
	Motivo: Comentario => Para que no se abra una ventana nueva con la misma información incluir la siguiente 
	linéa(Abajo de la invocación de este tag).
	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
--->

 
<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.principal" default="" type="String"> <!--- Nombre del archivo principal que manda los parámetros --->
<cfparam name="Attributes.datos" default="" type="String"> <!--- Nombre del archivo de datos --->
<cfparam name="Attributes.modulo" default="" type="String"> <!--- Nombre del módulo. Require modulolink y modulodesc. En RH no es requerido. --->
<cfparam name="Attributes.modulolink" default="" type="String"> <!--- Link del módulo --->
<cfparam name="Attributes.modulodesc" default="" type="String"> <!--- Descripción del módulo --->
<cfparam name="Attributes.paramsuri" default="" type="String"> <!--- parámetros adicionales URI --->
<cfparam name="Attributes.objetosForm" default="True" type="boolean"> <!--- parámetros adicionales URI --->
<cfparam name="Attributes.formato" default="html" type="String"> <!---parámetro de formato--->
<cfparam name="Attributes.width" 	default="600" type="numeric"> <!--- parámetros adicionales URI --->
<cfparam name="Attributes.height" 	default="300" type="numeric"> <!---parámetro de formato--->
<cfset Attributes.paramsuri=replace(Attributes.paramsuri,'?','&','all')>

<style type="text/css">
	#printerIframe {
	  position: absolute;
	  width: 0px; height: 0px;
	  border-style: none;
	  /* visibility: hidden; */
	}
	@media print {
	.noprint {
		display: none;
	}
	} 
</style>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaAbrirUnaNuevaVentana" default="Para imprimir este documento necesitamos abrir una nueva ventana. Desea continuar" returnvariable="MSG_DeseaAbrirUnaNuevaVentana" xmlFile="/rh/generales.xml">
<script type="text/javascript">
	function printURL (url,parFormato) {
	  if (window.print && window.frames && window.frames.printerIframe) {
		var html = '';
		html += '<html>';
		html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
		html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
		html += '<\/body><\/html>';

		var ifd = window.frames.printerIframe.document;
		ifd.open();
		ifd.write(html);
		ifd.close();
	  }
	  else {
			/*if (confirm('<cfoutput>#MSG_DeseaAbrirUnaNuevaVentana#</cfoutput>?')) {*/
				var win = window.open('', 'printerWindow', 'width=#Attributes.width#,height=#Attributes.height#,resizable,scrollbars,toolbar,menubar');
				var html = '';
				html += '<html>';
				html += '<frameset rows="100%, *" ' 
					 +  'onload="opener.printFrame(window.urlToPrint);">';
				html += '<frame name="urlToPrint" src="' + url + '" \/>';
				html += '<frame src="about:blank" \/>';
				html += '<\/frameset><\/html>';
				win.document.open();
				win.document.write(html);
				win.document.close();
		/*}*/
	  }
	}

	function printFrame (frame) {
	  if (frame.print) {
		frame.focus();
		frame.print();
		frame.src = "about:blank"
	  }
	}

</script>
<!--- concatena todos los parametros que vienen en el Form con formato de link --->
<cfset parametros = "?archivo=#Attributes.datos#&imprimir=true" & Attributes.paramsuri>
<cfset cont = 0 >

<cfif Attributes.objetosForm>
	<cfparam name="Form.FieldNames" default="">
	<cfloop list="#Form.FieldNames#" index="i">
		<cfif ListContainsNoCase(ucase(parametros), ucase(i) & "=") EQ 0>
			<cfset parametros = parametros & "&" &  i & "=" & JSStringFormat(Evaluate('Form.#i#')) >
		</cfif>
	</cfloop>
</cfif>

<cfoutput>
<cfif Attributes.formato eq "html">
	<!----si es HTML ---->
	<cfif not isdefined("url.imprimir")>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr >
				<cfif isdefined("Attributes.regresar") and len(trim(Attributes.regresar))>
				<td width="100%" align="right" class="noprint"><a href="#Attributes.regresar#"><cf_translate key="LB_Regresar" xmlFile="/rh/generales.xml">Regresar</cf_translate></a></td>
				<td align="right" class="noprint"><a href="#Attributes.regresar#"><img src="/cfmx/rh/imagenes/back.gif" alt="Regresar" 	name="regresar" border="0" align="absmiddle"></a></td>
				</cfif>
				<td align="right" class="noprint">
					<a href="javascript:printURL('/cfmx/rh/Utiles/genImpr.cfm#JSStringFormat(parametros)#','#Attributes.formato#');"><cf_translate key="LB_Imprimir" xmlFile="/rh/generales.xml">Imprimir</cf_translate></a>
				</td>
				<td width="1%" class="noprint"><a href="javascript:printURL('/cfmx/rh/Utiles/genImpr.cfm#JSStringFormat(parametros)#','#Attributes.formato#');"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></td>
			</tr>
		</table>
	</cfif>
<cfelse>
	<!---Si es cualquier otro---->
	<script type="text/javascript">
		function _printURL(){
			var param = param+'#parametros#'+'&formato='+'#Attributes.formato#' //Agrega el parametro de formato
			window.open('/cfmx/rh/Utiles/genImpr.cfm#JSStringFormat(parametros)#&formato='+'#Attributes.formato#', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar')
		}
	</script>	
	<cfif not isdefined("url.imprimir")>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td align="right" class="noprint">
					<a href="javascript:_printURL();"><cf_translate key="LB_Imprimir" xmlFile="/rh/generales.xml">Imprimir</cf_translate></a>
				</td>
				<td width="1%" class="noprint"><a href="javascript:_printURL();"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></td>
			</tr>
		</table>
	</cfif>
</cfif>
</cfoutput>



<!---<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>--->