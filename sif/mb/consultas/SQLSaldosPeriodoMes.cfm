<cf_templateheader title="	Bancos">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Movimientos por Per&iacute;odo/Mes'>
	

				<!--- Cuando veo el detalle del reporte y cambio de empresa,
				      me devuelve a la pantalla de filtro --->

				<cfif not isdefined("form.btnConsultar")>
					<cflocation addtoken="no" url="SaldosPeriodoMes.cfm">
 				</cfif>
				
				<cfparam name="form.MLperiodo" default="">	
				<cfparam name="form.MLmes" default="">		
				<cfparam name="form.CBid" default="">		

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
				<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
				  <tr align="left"> 
					<td><a href="/cfmx/sif/">SIF</a></td>
					<td>|</td>
					<td nowrap><a href="../MenuMB.cfm">Bancos</a></td>
					<td>|</td>
					<td><a href="../consultas/SaldosPeriodoMes.cfm">Regresar</a></td>
					<td align="right" width="100%">
					<cfoutput>
						<a href="javascript:printURL('SaldosPeriodosMesImpr.cfm?MLperiodo=#form.MLperiodo#&MLmes=#form.MLmes#&CBid=#form.CBid#');">Imprimir</a>
					</cfoutput>
					</td>
				  </tr>
				</table>
				<cfinclude template="formSaldosPeriodosMes.cfm">
				<iframe name="printerIframe" id="printerIframe" src="about:blank" >
				</iframe>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>