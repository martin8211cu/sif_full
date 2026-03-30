<cfcomponent>
	<cffunction name='Navega' access='public' returntype='any' output='true'>
		<cfargument name='printEn' type='string' required='true' default=''>
		<cfargument name='Param' type='string' required='false' default=''>		
		<cfargument name='Tipo' type='numeric' required='false' default='1'>

		<cfoutput>
			<table width="100%" border="0" cellpadding="4" cellspacing="0" class="areaMenu">
			  <tr align="left"> 
				<td><a href="/cfmx/edu" tabindex="-1">Educaci&oacute;n</a></td>
				<td>|</td>
				<cfif Tipo EQ 1>
					<td nowrap><a href="/cfmx/edu/ced/MenuCED.cfm" tabindex="-1">Administración</a></td>
				<cfelseif Tipo EQ 2>
					<td nowrap><a href="/cfmx/edu/docencia/MenuDOC.cfm" tabindex="-1">Docencia</a></td>
				<cfelseif Tipo EQ 3>
					<td nowrap><a href="/cfmx/edu/asistencia/MenuAST.cfm" tabindex="-1">Asistencia</a></td>
				<cfelseif Tipo EQ 4>
					<td nowrap><a href="/cfmx/edu/director/consultas/consultarActividadesDIR.cfm" tabindex="-1">Rendimiento Académico</a></td>
				</cfif>
				<td>|</td>
				<td><a href="<cfoutput>#Session.Edu.RegresarUrl#</cfoutput>" tabindex="-1">Regresar</a></td>
				<td>|</td>
				<td width="100%"><cfoutput><a href="javascript:printURL('#printEn#?f=1&#Param#');">Imprimir</a></cfoutput></td>
			  </tr>
			</table>		
		</cfoutput>
		
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
			
			function printFrame (frame) {
			  if (frame.print) {
				frame.focus();
				frame.print();
				frame.src = "about:blank"
			  }
			}
			
		</script>		
	</cffunction>
</cfcomponent>