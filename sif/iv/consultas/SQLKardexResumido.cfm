<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
	
		<td valign="top">
		<!--- Cuando veo el detalle del reporte y cambio de empresa,
			  me devuelve a la pantalla de filtro --->
		<cfif not isdefined("form.btnConsultar")>
			<cflocation addtoken="no" url="kardexResumido.cfm">
		</cfif>
		
		<cfparam name="form.almini" default="">	
		<cfparam name="form.almfin" default="">		

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
		<cfif not  isdefined("form.toExcel")>
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td><a href="/cfmx/sif/">SIF</a></td>
				<td>|</td>
				<td nowrap><a href="../MenuIV.cfm">Inventarios</a></td>
				<td>|</td>
				<td><a href="../consultas/kardexResumido.cfm">Regresar</a></td>
				<td align="right" width="100%">
				<cfoutput>
					<a href="javascript:printURL('KardexResumidoImpr.cfm?almini=#form.almini#&almfin=#form.almfin#&ACodigo1=#form.Acodigo1#&Acodigo2=#form.Acodigo2#&perini=#form.perini#&mesini=#form.mesini#&perfin=#form.perfin#&mesfin=#form.mesfin#');">Imprimir</a>
				</cfoutput>
				</td>
			  </tr>
			</table>
		</cfif>	
		<cfinclude template="formKardexResumido.cfm">
		<iframe name="printerIframe" id="printerIframe" src="about:blank">
		</iframe>
		</td>	
	</tr>
</table>	
