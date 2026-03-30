<cfcomponent>
	<cffunction name='imprime' access='public' returntype='any' output='true'>
		<cfargument name='printEn' type='string' required='true' default=''>
		<cfargument name='Param' type='string' required='false' default=''>		
		<cfargument name='Tipo' type='numeric' required='false' default='1'>
		<cfargument name='texto' type='string' required='false' default='Imprimir'>

		<cfoutput>
			<a href="javascript:printURL('#printEn#?#Param#');">
				<cfif Tipo EQ 1>
					<img src="/cfmx/sif/imagenes/Printer01_T.gif" height="33" border="0"><br>
					#texto#
				<cfelseif Tipo EQ 2>			
					<strong>
						#texto#
					</strong>
				</cfif>
			</a>
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