<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.principal" default="" type="String"> <!--- Nombre del archivo principal que manda los parámetros --->
<cfparam name="Attributes.datos" default="" type="String"> <!--- Nombre del archivo de datos --->
<cfparam name="Attributes.modulo" default="" type="String"> <!--- Nombre del módulo --->
<cfparam name="Attributes.paramsuri" default="" type="String"> <!--- parámetros adicionales URI --->
<cfparam name="Attributes.objetosForm" default="true" type="boolean"> <!--- incluir Objetos del Form --->

<cfset Attributes.paramsuri=replace(Attributes.paramsuri,'?','&','all')>
<cfif Len(Trim(Attributes.modulo)) EQ 0 >
	<script language="JavaScript1.2"> history.back(); </script>
</cfif>

<style type="text/css">
	#printerIframe {
	  position: absolute;
	  width: 0px; height: 0px;
	  border-style: none;
	  /* visibility: hidden; */
	}
</style>

<script type="text/javascript">
	function printURL (url) {
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
			if (confirm('To print a page with this browser ' +
						'we need to open a window with the page. Do you want to continue?')) {
				var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
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
		}
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
<cfset parametros = "?archivo=#Attributes.datos#" >
<cfset cont = 0 >

<cfif Attributes.objetosForm>
	<cfparam name="Form.FieldNames" default="">
	<cfloop list="#Form.FieldNames#" index="i">
		<cfset parametros = parametros & "&" &  URLEncodedFormat(i) & "=" & URLEncodedFormat(Form[i])>
	</cfloop>
</cfif>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
  <tr align="left">
	<td><a href="/cfmx/sif/indexSif.cfm">SIF</a></td>
	<td>|</td>
	<td nowrap><a href="/cfmx/home/menu/modulo.cfm?s=<cfoutput>#Session.monitoreo.SScodigo#</cfoutput>&m=<cfoutput>#Session.monitoreo.SMcodigo#</cfoutput>"><cfoutput>#Attributes.modulo#</cfoutput></a></td>
	<td>|</td>
	<td>
	<cfif Len(Trim(Attributes.principal)) GT 0>
	<a href="<cfoutput>#Attributes.principal#</cfoutput>">Regresar</a>
	<cfelse>
	<a href="javascript: history.back();">Regresar</a>
	</cfif>
	</td>
	<td align="right" width="100%">
	<cfoutput>
		<a href="javascript:printURL('/cfmx/sif/Utiles/genImpr.cfm#parametros##Attributes.paramsuri#');">Imprimir</a>
	</cfoutput>
	</td>
  </tr>
</table>

<cfinclude template="#Attributes.datos#">
<!---<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>--->


