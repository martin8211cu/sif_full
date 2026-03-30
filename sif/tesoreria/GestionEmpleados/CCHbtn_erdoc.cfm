<cfif isdefined ('url.GELid') and not isdefined ('form.GELid') and len(trim(url.GELid)) gt 0> 
	<cfset form.id=#url.GELid#>
</cfif>
		<table><tr><td style="background-color: #D4D0C8; border:outset 2px #FFFFFF;">
			<cf_navegacion name="chkImprimir" session default="1">
			<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"style="background-color:inherit;"
				<cfif form.chkImprimir NEQ "0">checked</cfif>/>
				<label for="chkImprimir" title="Imprime el vale despues de aplicarlo">
					Imprimir Vale Generado
				</label>
		</td></tr></table>

<cfoutput>
	 <script language="javascript">
		<cfif modo NEQ "ALTA">
			function funcImprimir()
				{
					<cfif isdefined ('form.GELtotalGastos')and #form.GELtotalGastos# EQ 0>
						alert("ERROR: No se puede Imprimir un vale sin facturas");
						return false;
					</cfif>
					
					
					<cfif isdefined ('form.tipo') and #form.tipo# neq 'GASTOS'>
						var url ='/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/GestionEmpleados/vale_imprimir_Ant.cfm.cfm")#  &imprime=1&GEAid=#form.id#';	
					<cfelse>
						var url ='/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/GestionEmpleados/vale_imprimir_Liq.cfm")# &imprime=1&GELid=#form.id#';
					</cfif>			
					
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
						  else
							  {
									var win = window.open('', 'printerWindow','width=600,height=300,resizable,scrollbars,toolbar,menubar');
									var html = '';
									html += '<html>';
									html += '<frameset rows="100%, *" ' 
										 +  'onload="opener.printFrame(window.urlToPrint);window.close();">';
									html += '<frame name="urlToPrint" src="' + url + '" \/>';
									html += '<frame src="about:blank" \/>';
									html += '<\/frameset><\/html>';
									win.document.open();
									win.document.write(html);
									win.document.close();
								}
						 return false;
							}	

					function printFrame (frame) 
					{
					  if (frame.print) 
					  {
						frame.focus();
						frame.print();
						frame.src = "about:blank"
					  }
				}
		</cfif>
	</script>
</cfoutput>

