<!--- 
	<cf_templateheader title="Saldos Diarios"> --->
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
		<cfif isdefined("Form.periodo") and Len(Trim(Form.periodo)) and isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
			<!--- <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos Diarios'>
				<cfinclude template="../../portlets/pNavegacion.cfm"> --->
				<table width="100%" border="0" cellpadding="4" cellspacing="0">
					<tr>
						<td align="right" width="100%">
							<cfoutput>
								<a href="SaldosDiarios.cfm">Regresar</a> |
								<a href="javascript:printURL('SaldosDiarios-report.cfm?periodo=#Form.periodo#&Cmayor=#Form.Cmayor#');">Imprimir</a>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="center" width="100%">
							
							<!--- Pintar la matriz de Saldos Diarios --->
							<cfinclude template="SaldosDiarios-report.cfm">
						</td>
					</tr>
				</table>
			<!--- <cf_web_portlet_end>	 --->			
		</cfif>
	<!--- <cf_templatefooter> --->