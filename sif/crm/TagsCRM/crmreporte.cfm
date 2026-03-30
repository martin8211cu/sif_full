<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.principal" default="" type="String"> <!--- Nombre del archivo principal que manda los parámetros --->
<cfparam name="Attributes.datos" default="" type="String"> <!--- Nombre del archivo de datos --->
<cfparam name="Attributes.modulo" default="" type="String"> <!--- Nombre del módulo. Require modulolink y modulodesc. En RH no es requerido. --->
<cfparam name="Attributes.modulolink" default="" type="String"> <!--- Link del módulo --->
<cfparam name="Attributes.modulodesc" default="" type="String"> <!--- Descripción del módulo --->
<cfparam name="Attributes.paramsuri" default="" type="String"> <!--- parámetros adicionales URI --->
<cfparam name="Attributes.objetosForm" default="True" type="boolean"> <!--- parámetros adicionales URI --->

<cfset Attributes.paramsuri=replace(Attributes.paramsuri,'?','&','all')>

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
		<cfset parametros = parametros & "&" &  i & "=" & #Evaluate('Form.#i#')#>
	</cfloop>
</cfif>
<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
  <tr align="left"> 
	<td nowrap>
		<a href="/cfmx/sif/crm/index.cfm"><cfoutput>#Request.Translate('SistemaCRM','CRM','/sif/crm/Utiles/Generales.xml')#</cfoutput></a>
		</td>
	<td>|</td>
	<cfif len(trim(Attributes.modulo)) gt 0 and len(trim(Attributes.modulolink)) gt 0 and len(trim(Attributes.modulodesc)) gt 0>
		<td nowrap>
			<cfoutput><a href="#Attributes.modulolink#">#Request.Translate(Attributes.modulo,Attributes.modulodesc,'/sif/Generales.xml')#</a></cfoutput>
		</td>
		<td>|</td>
	</cfif>
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
<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>