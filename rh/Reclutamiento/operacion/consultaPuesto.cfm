<script language="JavaScript" type="text/javascript">
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


	<cfif isdefined("url.RHPcodigo")>
		<cfset form.RHPCodigo = url.RHPcodigo>
	</cfif>
    <cfif isdefined("url.Ecodigo")>
		<cfset form.varEcodigo = url.Ecodigo>
    <cfelse>         
		<cfset form.varEcodigo = session.Ecodigo>
	</cfif>    

	<cfset vparams ="">
	<cfset vparams = vparams & "&RHPcodigo=" & form.RHPcodigo & "Ecodigo="&form.varEcodigo>
	<!--- <cf_rhreporte 
	modulo="" 
	modulolink="" 
	modulodesc=""
		datos="/rh/admin/catalogos/formPuestosReport.cfm" paramsuri="&RHPcodigo=#form.RHPcodigo#"> 
	--->
	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cf_rhimprime datos="/rh/admin/catalogos/formPuestosReport.cfm" paramsuri="#vparams#">
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>
	<!---  <cfset parametros = "/rh/Utiles/genImpr.cfm?archivo=/rh/admin/catalogos/formPuestosReport.cfm&imprimir=true" & "&RHPcodigo=" & form.RHPcodigo>
	<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="right">
			<a href="javascript:printURL('#parametros#');">Imprimir</a>
		</td>
		<td width="1%"><a href="javascript:printURL('#parametros#');"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"></a></td>
	</tr>
</table>
</cfoutput>--->
	<cfinclude template="../../admin/catalogos/formPuestosReport.cfm">