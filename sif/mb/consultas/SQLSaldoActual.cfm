<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Banco" default="Bancos" returnvariable="LB_Banco" xmlfile="SQLSaldoActual.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReporteSaldoActualCuentas" default="Reporte de Saldo Actual de Cuentas" returnvariable="LB_ReporteSaldoActualCuentas" xmlfile="SQLSaldoActual.xml"/>

<cf_templateheader title="#LB_Banco#">
		
		<cfinclude  template="../../portlets/pNavegacionMB.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ReporteSaldoActualCuentas#'>
	

				<!--- Cuando veo el detalle del reporte y cambio de empresa,
				      me devuelve a la pantalla de filtro --->

					<cfif not isdefined("url.tipo")>	
						<cflocation addtoken="no" url="../MenuMB.cfm" >
					</cfif>
					<cfset form.fechai = LSDateFormat(Now(),'DD/MM/YYYY') >
					
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
				<cfinclude template="formSaldoActual.cfm">
				<iframe name="printerIframe" id="printerIframe" src="about:blank" >
				</iframe>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>