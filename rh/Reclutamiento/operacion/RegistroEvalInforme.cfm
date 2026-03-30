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

<cfif isDefined("Url.RHCconcurso") and not isDefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = Url.RHCconcurso>
</cfif>
<cfset vparams ="">
<cfset vparams = vparams & "&RHCconcurso=" & form.RHCconcurso>
<!--- <cfdump var="#form#"> --->
<cfoutput>
	<cfif not isdefined("url.imprimir")>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_rhimprime datos="/rh/Reclutamiento/operacion/RegistroEvalInforme-form.cfm" paramsuri="#vparams#">
				</td>	
			</tr>
		</table>	
	</cfif>
</cfoutput>

<cfinclude template="RegistroEvalInforme-form.cfm">