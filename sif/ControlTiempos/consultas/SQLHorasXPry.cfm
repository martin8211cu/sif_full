<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><cfinclude template="/sif/ControlTiempos/portlets/pEmpresas2.cfm"></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Control de Tiempos</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="/sif/ControlTiempos/jsMenuCT.cfm"></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Horas por Proyecto">
	 
					
				<cfif not isdefined("form.fecDesde") or not isDefined("form.fecHasta") or not isDefined("form.cobrable")>
					<cflocation addtoken="no" url="ChartHorasXPry.cfm">
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

			<form action="ChartHorasXPry.cfm" method="post" name="form0">
				<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
				  <tr align="left"> 
					<td nowrap><a href="../MenuControlTiempos.cfm">Menú</a></td>
					<td>|</td>
					<td>
						<cfoutput>
						<input name="fecDesde" type="hidden" value="#form.fecDesde#">
						<input name="fecHasta" type="hidden" value="#form.fecHasta#">
						<input name="cobrable" type="hidden" value="#form.cobrable#">
						</cfoutput>
					</td>
					<td align="left" width="100%">
						<a href="javascript: this.document.form0.submit();">Regresar</a>
					</td>
					<td align="right" width="100%">
					<cfoutput>
						<a href="javascript:printURL('ImprHorasXPry.cfm?fecDesde=#form.fecDesde#&fecHasta=#form.fecHasta#&cobrable=#form.cobrable#');">Imprimir</a>
					</cfoutput>
					</td>
				  </tr>
				</table>
			</form>
				<cfinclude template="formHorasXPry.cfm">
				<iframe name="printerIframe" id="printerIframe" src="about:blank">
				</iframe>
		
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->