

<cfif isdefined("url.Ccuenta") and len(trim(url.Ccuenta)) and not isdefined("form.Ccuenta")>
	<cfset form.Ccuenta = url.Ccuenta>
</cfif>
<cfif isdefined("url.mes") and len(trim(url.mes)) and not isdefined("form.mes")>
	<cfset form.mes = url.mes>
</cfif>
<cfif isdefined("url.MesCierre") and len(trim(url.MesCierre)) and not isdefined("form.MesCierre")>
	<cfset form.MesCierre = url.MesCierre>
</cfif>
<cfif isdefined("url.oficina") and len(trim(url.oficina)) and not isdefined("form.oficina")>
	<cfset form.oficina = url.oficina>
</cfif>
<cfif isdefined("url.periodo") and len(trim(url.periodo)) and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo>
</cfif>
<cfif isdefined("url.periodoLista") and len(trim(url.periodoLista)) and not isdefined("form.periodoLista")>
	<cfset form.periodoLista = url.periodoLista>
</cfif>

<SCRIPT LANGUAGE='Javascript'  src="../../js/utilesMonto.js"> </SCRIPT>
<cf_templateheader title="Contabilidad General">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos y Movimientos por Cuenta Contable'> 
	

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
					//if (confirm('To print a page with this browser ' +
					//		'we need to open a window with the page. Do you want to continue?')) {
					var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars');
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
					//}
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
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DFDFDF">
		<tr>
			<cfoutput>
					<td align="right" width="6%"> 
						&nbsp;<a href="javascript:printURL('saldosymov02Impr.cfm?Impr=1&Periodo=#Form.Periodo#&PeriodoLista=#Form.PeriodoLista#&Ccuenta=#Form.Ccuenta#&Mes=#Form.Mes#&MesCierre=#Form.MesCierre#&Oficina=#Form.Oficina#');"> 
						Imprimir
						</a>
					</td>	
			</cfoutput>
		</tr>
	</table>				
<cfinclude template="formsaldosymov02.cfm">
<cf_web_portlet_end> 
<cf_templatefooter>
